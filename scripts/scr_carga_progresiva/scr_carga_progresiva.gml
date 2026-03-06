/// @file scr_carga_progresiva.gml
/// @description  Sistema de Daño Progresivo (carga al mantener tecla).
///   Ciertas habilidades (clase + R2/R3) permiten cargar al mantener la tecla.
///   Drenaje: 10 energía/seg. Niveles: N1=100%, N2=150% (1s), N3=250% (2s).
///   +25% daño recibido mientras carga. Parry cancela la carga.
///   Si energía llega a 0, dispara con la carga actual.


// ══════════════════════════════════════════════════════════════
//  scr_carga_es_cargable(id_habilidad)
//  Retorna true si la habilidad admite carga progresiva.
//  (Habilidad de clase + habilidades R2/R3 de arma)
// ══════════════════════════════════════════════════════════════
function scr_carga_es_cargable(_id) {

    switch (_id) {
        // ─── Habilidades de clase (slot 0) ───
        case "golpe_guardia":
        case "corte_rapido":
        case "impacto_tectonico":
        case "baluarte_ferreo":
        case "estocada_critica":
        case "descarga_esencia":

        // ─── R2 (slot 2 de arma → slot 2 global) ───
        case "explosion_carmesi":
        case "corriente_abisal":
        case "drenaje_vital":
        case "tormenta_fugaz":
        case "escudo_petreo":
        case "drenar_alma":
        case "bendicion_luz":
        case "onda_arcana":

        // ─── R3 (slot 3 de arma → slot 3 global) ───
        case "furia_del_titan":
        case "diluvio_eterno":
        case "selva_eterna":
        case "juicio_relampago":
        case "furia_continental":
        case "eclipse_total":
        case "juicio_celestial":
        case "ruptura_dimensional":
            return true;
    }

    return false;
}


// ══════════════════════════════════════════════════════════════
//  scr_carga_nivel(tiempo_carga_frames)
//  Retorna el nivel de carga (1, 2 o 3) según el tiempo cargado.
// ══════════════════════════════════════════════════════════════
function scr_carga_nivel(_frames) {
    var _seg = _frames / GAME_FPS;
    if (_seg >= CARGA_NIVEL3_SEG) return 3;
    if (_seg >= CARGA_NIVEL2_SEG) return 2;
    return 1;
}


// ══════════════════════════════════════════════════════════════
//  scr_carga_multiplicador(nivel)
//  Retorna el multiplicador de daño según el nivel de carga.
// ══════════════════════════════════════════════════════════════
function scr_carga_multiplicador(_nivel) {
    switch (_nivel) {
        case 3: return CARGA_MULT_N3;
        case 2: return CARGA_MULT_N2;
        default: return CARGA_MULT_N1;
    }
}


// ══════════════════════════════════════════════════════════════
//  scr_carga_iniciar(personaje, indice_habilidad)
//  Comienza la carga de una habilidad. Retorna true si se pudo iniciar.
// ══════════════════════════════════════════════════════════════
function scr_carga_iniciar(_p, _indice) {
    if (!_p.es_jugador) return false;

    var habs = _p.habilidades_arma;
    if (!is_array(habs)) return false;
    if (_indice < 0 || _indice >= array_length(habs)) return false;

    var _id = habs[_indice];
    if (!scr_carga_es_cargable(_id)) return false;

    // Verificar que no esté ya cargando otra habilidad
    if (_p.carga_activa) return false;

    // Verificar cooldown y GCD
    if (_p.habilidades_cd[_indice] > 0) return false;
    if (_p.gcd_timer > 0) return false;
    if (!scr_parry_puede_actuar(_p)) return false;

    // Verificar energía mínima para iniciar (al menos 1 frame de drenaje)
    var _costo_base = scr_energia_costo_habilidad(_id);
    if (!scr_energia_puede_gastar(_p, _costo_base)) {
        scr_notif_agregar(_p.nombre, "¡Energía insuficiente!", c_orange);
        return false;
    }

    // Consumir costo base de energía al iniciar la carga
    scr_energia_gastar(_p, _costo_base);

    _p.carga_activa     = true;
    _p.carga_indice     = _indice;
    _p.carga_timer      = 0;
    _p.carga_drenaje_acum = 0;

    show_debug_message("⚡ " + _p.nombre + " — Carga iniciada: " + _id);
    return true;
}


// ══════════════════════════════════════════════════════════════
//  scr_carga_actualizar(personaje)
//  Llamar cada frame. Gestiona el drenaje de energía y la carga.
//  Retorna true si la carga sigue activa, false si terminó.
// ══════════════════════════════════════════════════════════════
function scr_carga_actualizar(_p) {
    if (!_p.carga_activa) return false;

    // Incrementar timer de carga
    _p.carga_timer += 1;

    // Drenaje de energía por segundo
    _p.carga_drenaje_acum += CARGA_DRENAJE_ENERGIA / GAME_FPS;
    if (_p.carga_drenaje_acum >= 1) {
        var _drenaje = floor(_p.carga_drenaje_acum);
        _p.carga_drenaje_acum -= _drenaje;
        scr_energia_gastar(_p, _drenaje);
    }

    // Si energía llega a 0, disparar automáticamente con carga actual
    if (_p.energia <= 0) {
        show_debug_message("⚡ " + _p.nombre + " — ¡Energía agotada durante carga! Disparo automático.");
        scr_carga_disparar(_p);
        return false;
    }

    // Verificar nivel actual (para feedback visual)
    var _nivel = scr_carga_nivel(_p.carga_timer);

    // Notificación al alcanzar nivel 3 (una sola vez)
    if (_nivel == 3 && _p.carga_timer == round(GAME_FPS * CARGA_NIVEL3_SEG)) {
        scr_notif_agregar(_p.nombre, "¡CARGA MÁXIMA!", c_yellow);
        show_debug_message("⚡ " + _p.nombre + " — NIVEL 3 (MÁXIMO) alcanzado.");
    }

    return true;
}


// ══════════════════════════════════════════════════════════════
//  scr_carga_disparar(personaje)
//  Libera la carga y ejecuta la habilidad con multiplicador.
// ══════════════════════════════════════════════════════════════
function scr_carga_disparar(_p) {
    if (!_p.carga_activa) return;

    var _indice = _p.carga_indice;
    var _nivel  = scr_carga_nivel(_p.carga_timer);
    var _mult   = scr_carga_multiplicador(_nivel);

    var _id_hab = _p.habilidades_arma[_indice];

    // Guardar multiplicador de carga para que scr_formula_dano lo use
    _p.carga_mult_temp = _mult;
    _p.carga_nivel_temp = _nivel;

    // Obtener referencia al defensor
    var _defensor = undefined;
    if (instance_exists(obj_control_combate)) {
        _defensor = obj_control_combate.personaje_enemigo;
    }

    if (_defensor != undefined) {
        // Guardar ID de habilidad actual para postura/tracking
        _p.hab_actual_id = _id_hab;

        // Ejecutar habilidad
        scr_ejecutar_habilidad(_p, _defensor, _id_hab);

        // Notificación de acción
        var _nombre_hab = scr_nombre_habilidad(_id_hab);
        scr_notif_agregar(_p.nombre, "usa " + _nombre_hab + " (N" + string(_nivel) + " x" + string(_mult) + ")", c_lime);

        // Asignar cooldown
        var cd_base = scr_cooldown_habilidad(_id_hab);
        _p.habilidades_cd[_indice] = cd_base;

        // Activar GCD
        _p.gcd_timer = round(GAME_FPS * GCD_DURACION_SEG);
    }

    // Resetear carga
    _p.carga_activa     = false;
    _p.carga_indice     = -1;
    _p.carga_timer      = 0;
    _p.carga_mult_temp  = 1.0;
    _p.carga_nivel_temp = 1;
    _p.carga_drenaje_acum = 0;

    show_debug_message("⚡ " + _p.nombre + " — Carga disparada: N" + string(_nivel) + " x" + string(_mult));
}


// ══════════════════════════════════════════════════════════════
//  scr_carga_cancelar(personaje)
//  Cancela la carga (por parry, stun, etc.). Se pierde la energía.
// ══════════════════════════════════════════════════════════════
function scr_carga_cancelar(_p) {
    if (!_p.carga_activa) return;

    show_debug_message("⚡ " + _p.nombre + " — Carga cancelada.");
    scr_notif_agregar(_p.nombre, "¡Carga cancelada!", c_orange);

    _p.carga_activa     = false;
    _p.carga_indice     = -1;
    _p.carga_timer      = 0;
    _p.carga_mult_temp  = 1.0;
    _p.carga_nivel_temp = 1;
    _p.carga_drenaje_acum = 0;
}


// ══════════════════════════════════════════════════════════════
//  scr_carga_interrumpir_por_dano(personaje)
//  Cuando el jugador recibe un golpe mientras carga: micro-stun.
//  Pierde la carga y queda indefenso 0.5s.
// ══════════════════════════════════════════════════════════════
function scr_carga_interrumpir_por_dano(_p) {
    if (!_p.carga_activa) return;

    scr_carga_cancelar(_p);

    // Micro-stun al jugador
    _p.micro_stun_timer = round(GAME_FPS * CARGA_MICRO_STUN_SEG);
    scr_notif_agregar(_p.nombre, "¡Interrumpido! Micro-stun", c_red);
    show_debug_message("⚡ " + _p.nombre + " — Micro-stun por golpe durante carga.");
}
