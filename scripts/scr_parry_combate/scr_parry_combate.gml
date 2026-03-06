/// @file scr_parry_combate.gml
/// @description  Sistema de Parry (mecánica de interacción universal).
///   Sin cooldown tradicional, pero con "Lag de Recuperación".
///   Ventana activa de 0.3s: si no recibe golpe → penalización 0.6s.
///   Resultados:
///     - Parry Perfecto: 0 daño, +30% energía, +5-10% esencia (según afinidad)
///     - Bloqueo (temprano): 40% daño, sin regen, consume un poco de energía
///     - Fallo (tarde/aire): 100% daño + aturdimiento breve


// ══════════════════════════════════════════════════════════════
//  scr_parry_intentar(personaje)
//  El jugador presiona la tecla de Parry. Inicia la ventana activa.
//  Retorna true si se pudo iniciar, false si ya está en parry/vulnerable.
// ══════════════════════════════════════════════════════════════
function scr_parry_intentar(_p) {
    // No se puede hacer parry si ya está en ventana activa o vulnerable
    if (_p.parry_estado != "inactivo") return false;

    // No se puede hacer parry si el GCD está activo
    if (_p.gcd_timer > 0) return false;

    // Cancelar carga activa al hacer parry (prioridad defensiva)
    if (_p.carga_activa) {
        scr_carga_cancelar(_p);
    }

    _p.parry_estado = "ventana";
    _p.parry_timer  = round(GAME_FPS * PARRY_VENTANA_SEG);

    show_debug_message("🛡 " + _p.nombre + " — ¡Parry iniciado! Ventana: " + string(PARRY_VENTANA_SEG) + "s");
    return true;
}


// ══════════════════════════════════════════════════════════════
//  scr_parry_actualizar(personaje)
//  Llamar cada frame. Gestiona timers de ventana y vulnerabilidad.
// ══════════════════════════════════════════════════════════════
function scr_parry_actualizar(_p) {
    if (_p.parry_estado == "inactivo") return;

    _p.parry_timer -= 1;

    if (_p.parry_timer <= 0) {
        if (_p.parry_estado == "ventana") {
            // La ventana expiró sin recibir golpe → FALLO
            // Entra en estado "vulnerable" (penalización)
            _p.parry_estado = "vulnerable";
            _p.parry_timer  = round(GAME_FPS * PARRY_VULNERABLE_SEG);
            show_debug_message("🛡 " + _p.nombre + " — Parry fallido → Vulnerable " + string(PARRY_VULNERABLE_SEG) + "s");
            scr_notif_agregar(_p.nombre, "¡Parry fallido!", c_orange);
        } else if (_p.parry_estado == "vulnerable") {
            // Vulnerabilidad terminó → volver a inactivo
            _p.parry_estado = "inactivo";
            _p.parry_timer  = 0;
        }
    }
}


// ══════════════════════════════════════════════════════════════
//  scr_parry_evaluar(defensor, atacante, dano_original)
//  Llamar ANTES de aplicar daño al defensor si éste tiene parry activo.
//  Retorna el daño modificado según el resultado del parry.
//  También aplica efectos secundarios (energía, esencia, aturdimiento).
// ══════════════════════════════════════════════════════════════
function scr_parry_evaluar(_defensor, _atacante, _dano) {

    // Si no está en estado de parry activo, retornar daño completo (sin modificar)
    if (_defensor.parry_estado != "ventana") {
        return _dano;
    }

    // ═══════════════════════════════════════════════
    //  Calcular timing del parry
    //  ventana_total = PARRY_VENTANA_SEG * GAME_FPS
    //  tiempo_restante = parry_timer
    //  ratio = tiempo transcurrido / ventana total
    // ═══════════════════════════════════════════════
    var _ventana_total = round(GAME_FPS * PARRY_VENTANA_SEG);
    var _transcurrido  = _ventana_total - _defensor.parry_timer;
    var _ratio         = _transcurrido / max(1, _ventana_total);

    // Umbral para "Perfecto" vs "Bloqueo"
    // Perfecto: si el golpe llega en el primer 50% de la ventana (timing exacto)
    // Bloqueo:  si llega en el 50-100% restante (temprano/impreciso)
    var _dano_final = _dano;

    if (_ratio <= 0.5) {
        // ══════════════════════════════════
        //  PARRY PERFECTO
        // ══════════════════════════════════
        _dano_final = 0;

        // Recuperar energía
        var _energia_ganada = round(_defensor.energia_max * (PARRY_PERFECTO_ENERGIA / 100));
        _defensor.energia = min(_defensor.energia_max, _defensor.energia + _energia_ganada);

        // Generar esencia (5-10% según afinidad)
        var _esencia_pct = PARRY_PERFECTO_ESENCIA;
        // Afinidades que benefician más del parry
        var _afi = _defensor.afinidad;
        if (_afi == "Tierra" || _afi == "Luz") {
            _esencia_pct = PARRY_PERFECTO_ESENCIA_MAX;  // 10%
        } else if (_afi == "Agua" || _afi == "Sombra") {
            _esencia_pct = round((PARRY_PERFECTO_ESENCIA + PARRY_PERFECTO_ESENCIA_MAX) / 2);  // 7-8%
        }
        var _esencia_ganada = round(_defensor.esencia_llena * (_esencia_pct / 100));
        _defensor.esencia = clamp(_defensor.esencia + _esencia_ganada, 0, _defensor.esencia_llena);

        // Bonus especial para clase Duelista (su método de carga es parry_perfecto)
        if (_defensor.es_jugador && variable_struct_exists(_defensor, "clase") && _defensor.clase == "Duelista") {
            var _bonus_duelista = round(_esencia_ganada * (ESENCIA_CLASE_BONUS - 1.0));
            _defensor.esencia = clamp(_defensor.esencia + _bonus_duelista, 0, _defensor.esencia_llena);
        }

        // Activar pasiva de afinidad (evento de bloqueo/parry)
        scr_activar_pasiva_afinidad(_defensor, "recibir_dano");

        // Notificación
        scr_notif_agregar(_defensor.nombre, "¡PARRY PERFECTO! +" + string(_energia_ganada) + " energía", c_aqua);

        // ── Stun de Reacción al atacante ──
        scr_stun_aplicar(_atacante, STUN_PARRY_SEG, "parry");

        show_debug_message("🛡✨ " + _defensor.nombre + " — PARRY PERFECTO vs " + _atacante.nombre
            + " | +energía:" + string(_energia_ganada) + " +esencia:" + string(_esencia_ganada));

    } else {
        // ══════════════════════════════════
        //  BLOQUEO (temprano/impreciso)
        // ══════════════════════════════════
        _dano_final = round(_dano * PARRY_BLOQUEO_DANO_PCT);

        // Consume un poco de energía por el esfuerzo
        scr_energia_gastar(_defensor, PARRY_BLOQUEO_ENERGIA_COSTO);

        scr_notif_agregar(_defensor.nombre, "Bloqueo parcial (-" + string(round((1 - PARRY_BLOQUEO_DANO_PCT) * 100)) + "% daño)", c_yellow);

        show_debug_message("🛡 " + _defensor.nombre + " — BLOQUEO vs " + _atacante.nombre
            + " | daño reducido: " + string(_dano) + " → " + string(_dano_final));
    }

    // Resetear estado de parry (ya se resolvió)
    _defensor.parry_estado = "inactivo";
    _defensor.parry_timer  = 0;

    return _dano_final;
}


// ══════════════════════════════════════════════════════════════
//  scr_parry_puede_actuar(personaje)
//  Retorna true si el personaje puede usar habilidades.
//  False si está en vulnerabilidad post-parry o en ventana activa.
// ══════════════════════════════════════════════════════════════
function scr_parry_puede_actuar(_p) {
    return (_p.parry_estado == "inactivo");
}
