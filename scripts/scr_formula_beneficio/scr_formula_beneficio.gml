/// @function scr_formula_beneficio(usuario, params)
/// @description  Fórmula UNIVERSAL de beneficio (curación, escudos, robo de vida, etc.)
///
/// params = {
///   stat1       : string   – stat primaria del usuario ("defensa","poder","vida_max","ninguno", etc.)
///   escala1     : real     – multiplicador de stat1
///   stat2       : string   – stat secundaria (o "ninguno")
///   escala2     : real     – multiplicador de stat2
///   base_fija   : real     – beneficio plano
///   mult_poder  : real     – amplificador general (1.0 = normal)
///   esencia_gen : real     – esencia generada al usar
///   es_arma     : bool     – true = habilidad de arma → escala con rareza
/// }
///
/// Flujo:
///   1. Beneficio bruto = stat1×esc1 + stat2×esc2 + base_fija
///   2. ×mult_poder  ×mult_rareza  ×mult_pasivas_curativas
///   3. Final = max(1, round(todo))

function scr_formula_beneficio(_usuario, _p) {

    // ─── Paso 1: Beneficio bruto ───
    var _val1 = scr_get_stat(_usuario, _p.stat1) * _p.escala1;
    var _val2 = scr_get_stat(_usuario, _p.stat2) * _p.escala2;
    var _beneficio = _val1 + _val2 + _p.base_fija;

    // ─── Paso 2: Multiplicador de rareza del arma (solo hab. de arma) ───
    var _mult_rareza = 1.0;
    if (_p.es_arma && variable_struct_exists(_usuario, "arma_data") && _usuario.arma_data != undefined) {
        _mult_rareza = 1.0 + (_usuario.arma_data.rareza * 0.10);
    }

    // ─── Paso 3: Pasivas curativas de afinidad (lee bono de scr_datos_afinidades) ───
    var _mult_pas = 1.0;
    var _usr_afi2 = variable_struct_exists(_usuario, "afinidad_secundaria")
                    ? _usuario.afinidad_secundaria : "none";

    if (_usuario.pasiva_activa) {
        var _curativas = ["Luz", "Planta", "Agua"];
        for (var _ci = 0; _ci < 3; _ci++) {
            if (_usuario.afinidad == _curativas[_ci] || _usr_afi2 == _curativas[_ci]) {
                var _bono = scr_datos_afinidades(_curativas[_ci]).bono;
                _mult_pas *= _bono;
            }
        }
    }

    // ─── Paso 4: Varianza aleatoria ───
    //   Usa el MAYOR entre spread porcentual (±VAR_RANGO) y spread absoluto (±VAR_MIN_ABS)
    var _benef_pre  = _beneficio * _p.mult_poder * _mult_rareza * _mult_pas;
    var _spread_pct = _benef_pre * VAR_RANGO;
    var _spread     = max(_spread_pct, VAR_MIN_ABS);
    var _benef_var  = _benef_pre + random_range(-_spread, _spread);

    // ─── Paso 5: Crítico curativo / fallo ───
    //   Crit chance dinámica: base + floor(ataque / divisor)
    var _crit_chance = CRIT_BASE_CHANCE + floor(_usuario.ataque_base / CRIT_ATK_DIVISOR);
    var _mult_crit = 1.0;
    var _tipo_crit = 0;
    var _roll = irandom(99);
    if (_roll < _crit_chance) {
        _mult_crit = CRIT_POS_MULT;
        _tipo_crit = 1;
    }

    // ─── Paso 6: Resultado final ───
    var _resultado = max(1, round(_benef_var * _mult_crit));

    // Log de críticos curativos
    if (_tipo_crit == 1) {
        show_debug_message("✨ ¡Curación CRÍTICA! " + _usuario.nombre + " recupera " + string(_resultado) + ".");
    } else if (_tipo_crit == -1) {
        show_debug_message("💫 Curación débil... " + _usuario.nombre + " solo recupera " + string(_resultado) + ".");
    }

    // Generar esencia dinámica (base + bonus velocidad)
    if (_p.esencia_gen > 0) {
        var _esen_base = _p.esencia_gen;
        var _esen_vel  = round(_usuario.velocidad * ESENCIA_MULT_VEL);
        var _esen_total = _esen_base + _esen_vel;
        if (_tipo_crit == 1) _esen_total = round(_esen_total * ESENCIA_CRIT_BONUS);
        _usuario.esencia = clamp(_usuario.esencia + _esen_total, 0, _usuario.esencia_llena);
    }

    return _resultado;
}
