/// scr_actualizar_pasivas(personaje)
function scr_actualizar_pasivas(_p) {

    // Timer activo
    if (_p.pasiva_timer > 0) {
        _p.pasiva_timer--;

        if (_p.pasiva_timer <= 0) {
            // No desactivar si la sinergia es permanente
            if (variable_struct_exists(_p, "sinergia_pasiva_permanente") && _p.sinergia_pasiva_permanente) {
                _p.pasiva_timer = 0;  // Mantener en 0 pero activa
            } else {
                _p.pasiva_activa = false;
                // Restaurar penalizaciones al expirar
                if (variable_struct_exists(_p, "pasiva_pen_aplicada") && _p.pasiva_pen_aplicada) {
                    scr_pasiva_revertir_penalizacion(_p);
                }
            }
        }
    }

    // Cooldown interno
    if (_p.pasiva_cooldown > 0) {
        _p.pasiva_cooldown--;
    }

    // ── Aplicar penalización cuando se activa la pasiva ──
    if (_p.pasiva_activa) {
        if (!variable_struct_exists(_p, "pasiva_pen_aplicada")) _p.pasiva_pen_aplicada = false;
        if (!_p.pasiva_pen_aplicada) {
            scr_pasiva_aplicar_penalizacion(_p);
        }
    }

    // ── Agua: reducir cooldowns 20% más rápido mientras pasiva activa ──
    var _afi = _p.afinidad;
    var _afi2 = variable_struct_exists(_p, "afinidad_secundaria") ? _p.afinidad_secundaria : "none";
    if (_p.pasiva_activa && (_afi == "Agua" || _afi2 == "Agua")) {
        if (is_array(_p.habilidades_cd)) {
            for (var i = 0; i < array_length(_p.habilidades_cd); i++) {
                if (_p.habilidades_cd[i] > 0) {
                    _p.habilidades_cd[i] -= 0.20;  // 20% extra por frame
                    if (_p.habilidades_cd[i] < 0) _p.habilidades_cd[i] = 0;
                }
            }
        }
    }

    // ── Planta: emitir turno_pasado cada segundo para activar regen ──
    if (_afi == "Planta" || _afi2 == "Planta") {
        if (!variable_struct_exists(_p, "pasiva_planta_tick")) {
            _p.pasiva_planta_tick = 0;
        }
        _p.pasiva_planta_tick++;
        if (_p.pasiva_planta_tick >= GAME_FPS) {
            _p.pasiva_planta_tick = 0;
            scr_activar_pasiva_afinidad(_p, "turno_pasado");
        }
        // Si pasiva de Planta activa → regenerar vida (1.5% vida max por segundo / GAME_FPS)
        if (_p.pasiva_activa && (_afi == "Planta" || _afi2 == "Planta")) {
            var _regen_por_frame = (_p.vida_max * 0.015) / GAME_FPS;
            _p.vida_actual = min(_p.vida_max, _p.vida_actual + _regen_por_frame);
        }
    }
}


/// @function scr_pasiva_aplicar_penalizacion(personaje)
/// @description Aplica la penalización de la afinidad mientras la pasiva está activa.
function scr_pasiva_aplicar_penalizacion(_p) {
    var _afi = _p.afinidad;
    var _datos = scr_datos_afinidades(_afi);
    var _pen = _datos.penalizacion;  // valor negativo, ej: -0.05

    if (_pen == 0) { _p.pasiva_pen_aplicada = true; return; }

    // Guardar stats originales para restaurar después
    _p.pasiva_pen_stat_backup = {
        ataque_base:     _p.ataque_base,
        defensa_base:    _p.defensa_base,
        velocidad:       _p.velocidad,
        poder_elemental: _p.poder_elemental,
    };

    switch (_afi) {
        case "Fuego":    // -5% defensa
            _p.defensa_base = max(1, round(_p.defensa_base * (1.0 + _pen)));
            break;
        case "Rayo":     // -10% velocidad
            _p.velocidad = max(1, round(_p.velocidad * (1.0 + _pen)));
            break;
        case "Tierra":   // -5% velocidad
            _p.velocidad = max(1, round(_p.velocidad * (1.0 + _pen)));
            break;
        case "Agua":     // -5% ataque
            _p.ataque_base = max(1, round(_p.ataque_base * (1.0 + _pen)));
            break;
        case "Planta":   // -5% poder elemental
            _p.poder_elemental = max(0, round(_p.poder_elemental * (1.0 + _pen)));
            break;
        case "Sombra":   // -10% defensa
            _p.defensa_base = max(1, round(_p.defensa_base * (1.0 + _pen)));
            break;
        case "Luz":      // -5% poder elemental
            _p.poder_elemental = max(0, round(_p.poder_elemental * (1.0 + _pen)));
            break;
        case "Arcano":   // -10% defensa
            _p.defensa_base = max(1, round(_p.defensa_base * (1.0 + _pen)));
            break;
    }

    _p.pasiva_pen_aplicada = true;
}


/// @function scr_pasiva_revertir_penalizacion(personaje)
/// @description Restaura las stats a su valor original al expirar la pasiva.
function scr_pasiva_revertir_penalizacion(_p) {
    if (variable_struct_exists(_p, "pasiva_pen_stat_backup")) {
        var _bk = _p.pasiva_pen_stat_backup;
        _p.ataque_base     = _bk.ataque_base;
        _p.defensa_base    = _bk.defensa_base;
        _p.velocidad       = _bk.velocidad;
        _p.poder_elemental = _bk.poder_elemental;
    }
    _p.pasiva_pen_aplicada = false;
}