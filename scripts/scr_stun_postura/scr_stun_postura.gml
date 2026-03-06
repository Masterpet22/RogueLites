/// @file scr_stun_postura.gml
/// @description  Sistema de Stun y Postura.
///   Stun de Reacción: Parry Perfecto → 1.2s stun al enemigo.
///   Stun de Ruptura: Barra de postura → al romperla, 3s stun.
///   Stun detiene la IA del enemigo, reinicia su barra de cast.
///   Bonificación: golpear stunned con carga máx → x2 esencia.


// ══════════════════════════════════════════════════════════════
//  scr_stun_aplicar(personaje, duracion_segundos, tipo)
//  Aplica stun a un personaje (normalmente enemigo).
//  tipo: "parry" o "postura"
// ══════════════════════════════════════════════════════════════
function scr_stun_aplicar(_p, _duracion_seg, _tipo) {
    _p.stun_activo = true;
    _p.stun_timer  = round(GAME_FPS * _duracion_seg);
    _p.stun_tipo   = _tipo;

    // Reiniciar barra de cast del enemigo (detener su ataque actual)
    if (!_p.es_jugador) {
        _p.ia_estado     = "ia_esperando";
        _p.ia_prep_timer = 0;
        _p.ia_hab_elegida = -1;
        _p.ia_patron_hab  = "";
        // Recalcular espera tras stun (se aplicará cuando termine)
        _p.ia_timer = _p.stun_timer + round(GAME_FPS * 0.5);
    }

    var _label = (_tipo == "parry") ? "STUN (Parry)" : "¡POSTURA ROTA!";
    scr_notif_agregar(_p.nombre, _label + " " + string(_duracion_seg) + "s", c_aqua);
    show_debug_message("💫 " + _p.nombre + " — STUN [" + _tipo + "] " + string(_duracion_seg) + "s");
}


// ══════════════════════════════════════════════════════════════
//  scr_stun_actualizar(personaje)
//  Llamar cada frame. Decrementa timer y desactiva stun al terminar.
// ══════════════════════════════════════════════════════════════
function scr_stun_actualizar(_p) {
    // Stun del personaje
    if (_p.stun_activo) {
        _p.stun_timer -= 1;
        if (_p.stun_timer <= 0) {
            _p.stun_activo = false;
            _p.stun_timer  = 0;
            _p.stun_tipo   = "";
            show_debug_message("💫 " + _p.nombre + " — Stun terminado.");
        }
    }

    // Micro-stun del jugador (interrupción de carga)
    if (variable_struct_exists(_p, "micro_stun_timer") && _p.micro_stun_timer > 0) {
        _p.micro_stun_timer -= 1;
    }

    // Regeneración de postura del enemigo
    if (!_p.es_jugador && variable_struct_exists(_p, "postura")) {
        _p.postura_sin_golpe_timer += 1;

        // Solo regenerar si no recibió golpes recientemente
        if (_p.postura_sin_golpe_timer >= round(GAME_FPS * POSTURA_REGEN_SEG) && !_p.stun_activo) {
            var _regen = (_p.postura_max * POSTURA_REGEN_RATE) / GAME_FPS;
            _p.postura = min(_p.postura_max, _p.postura + _regen);
        }
    }
}


// ══════════════════════════════════════════════════════════════
//  scr_postura_reducir(enemigo, cantidad)
//  Reduce la postura del enemigo. Si llega a 0 → Stun de Ruptura.
//  Retorna true si se rompió la postura.
// ══════════════════════════════════════════════════════════════
function scr_postura_reducir(_enemigo, _cantidad) {
    if (_enemigo.es_jugador) return false;
    if (_enemigo.stun_activo) return false;  // No reducir postura si ya está stunned

    _enemigo.postura = max(0, _enemigo.postura - _cantidad);
    _enemigo.postura_sin_golpe_timer = 0;  // Reiniciar regen timer

    show_debug_message("📊 " + _enemigo.nombre + " — Postura: "
        + string(round(_enemigo.postura)) + "/" + string(_enemigo.postura_max)
        + " (-" + string(round(_cantidad)) + ")");

    if (_enemigo.postura <= 0) {
        // ¡Postura rota! Aplicar stun largo
        scr_stun_aplicar(_enemigo, STUN_POSTURA_SEG, "postura");

        // Restaurar postura al máximo tras el stun
        _enemigo.postura = _enemigo.postura_max;

        return true;
    }

    return false;
}


// ══════════════════════════════════════════════════════════════
//  scr_postura_dano_habilidad(id_habilidad)
//  Retorna cuánta postura resta cada habilidad.
//  Armas pesadas restan más. Habilidades rápidas restan menos.
// ══════════════════════════════════════════════════════════════
function scr_postura_dano_habilidad(_id) {
    switch (_id) {
        // ─── Clase (moderado) ───
        case "golpe_guardia":       return 12;
        case "corte_rapido":        return 6;
        case "impacto_tectonico":   return 20;  // Quebrador: fuerte en postura
        case "baluarte_ferreo":     return 8;
        case "estocada_critica":    return 10;
        case "descarga_esencia":    return 14;

        // ─── Básico ───
        case "ataque_basico":       return 5;

        // ─── Fuego ───
        case "ataque_fuego_basico":     return 6;
        case "ataque_fuego_mejorado":   return 10;
        case "explosion_carmesi":       return 15;
        case "llamarada_solar":         return 12;
        case "furia_del_titan":         return 25;

        // ─── Agua ───
        case "corte_glaciar":       return 6;
        case "lanza_marina":        return 8;
        case "corriente_abisal":    return 12;
        case "tsunami":             return 14;
        case "diluvio_eterno":      return 20;

        // ─── Planta ───
        case "latigazo_espina":     return 5;
        case "enredadera_voraz":    return 8;
        case "drenaje_vital":       return 10;
        case "explosion_espora":    return 12;
        case "selva_eterna":        return 18;

        // ─── Rayo ───
        case "descarga_rapida":     return 4;
        case "cadena_electrica":    return 7;
        case "tormenta_fugaz":      return 12;
        case "rayo_fulminante":     return 10;
        case "juicio_relampago":    return 22;

        // ─── Tierra ───
        case "golpe_sismico":       return 10;
        case "avalancha":           return 14;
        case "escudo_petreo":       return 8;
        case "cataclismo":          return 18;
        case "furia_continental":   return 25;

        // ─── Sombra ───
        case "tajo_umbral":         return 6;
        case "siega_oscura":        return 10;
        case "drenar_alma":         return 12;
        case "noche_eterna":        return 14;
        case "eclipse_total":       return 22;

        // ─── Luz ───
        case "hoja_radiante":       return 6;
        case "embestida_solar":     return 10;
        case "bendicion_luz":       return 5;   // curación: poco daño de postura
        case "amanecer_divino":     return 12;
        case "juicio_celestial":    return 20;

        // ─── Arcano ───
        case "pulso_runico":        return 6;
        case "corte_arcano":        return 8;
        case "onda_arcana":         return 12;
        case "singularidad_arcana": return 14;
        case "ruptura_dimensional": return 24;
    }

    return 8;  // fallback
}


// ══════════════════════════════════════════════════════════════
//  scr_esta_stunned(personaje)
//  Retorna true si el personaje está en stun.
// ══════════════════════════════════════════════════════════════
function scr_esta_stunned(_p) {
    return (_p.stun_activo);
}


// ══════════════════════════════════════════════════════════════
//  scr_jugador_puede_actuar(personaje)
//  Retorna true si el jugador puede usar habilidades (no micro-stunned).
// ══════════════════════════════════════════════════════════════
function scr_jugador_puede_actuar(_p) {
    if (variable_struct_exists(_p, "micro_stun_timer") && _p.micro_stun_timer > 0) {
        return false;
    }
    return true;
}
