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

    // ─── Paso 3: Pasivas curativas de afinidad ───
    var _mult_pas = 1.0;
    var _usr_afi2 = variable_struct_exists(_usuario, "afinidad_secundaria")
                    ? _usuario.afinidad_secundaria : "none";

    if (_usuario.pasiva_activa) {
        // Luz: +15 % curación / escudo
        if (_usuario.afinidad == "Luz" || _usr_afi2 == "Luz") {
            _mult_pas *= 1.15;
        }
        // Planta: +15 % regeneración
        if (_usuario.afinidad == "Planta" || _usr_afi2 == "Planta") {
            _mult_pas *= 1.15;
        }
        // Agua: +10 % beneficios (flexibilidad acuática)
        if (_usuario.afinidad == "Agua" || _usr_afi2 == "Agua") {
            _mult_pas *= 1.10;
        }
    }

    // ─── Paso 4: Varianza aleatoria (±VAR_RANGO) ───
    var _mult_var = (1.0 - VAR_RANGO) + (random(VAR_RANGO * 2));

    // ─── Paso 5: Crítico curativo / fallo ───
    //   Crítico positivo = curación extra  │  Crítico negativo = curación reducida
    var _mult_crit = 1.0;
    var _tipo_crit = 0;
    var _roll = irandom(99);
    if (_roll < CRIT_POS_CHANCE) {
        _mult_crit = CRIT_POS_MULT;
        _tipo_crit = 1;
    } else if (_roll >= (100 - CRIT_NEG_CHANCE)) {
        _mult_crit = CRIT_NEG_MULT;
        _tipo_crit = -1;
    }

    // ─── Paso 6: Resultado final ───
    var _resultado = max(1, round(_beneficio * _p.mult_poder * _mult_rareza * _mult_pas * _mult_var * _mult_crit));

    // Log de críticos curativos
    if (_tipo_crit == 1) {
        show_debug_message("✨ ¡Curación CRÍTICA! " + _usuario.nombre + " recupera " + string(_resultado) + ".");
    } else if (_tipo_crit == -1) {
        show_debug_message("💫 Curación débil... " + _usuario.nombre + " solo recupera " + string(_resultado) + ".");
    }

    // Generar esencia
    if (_p.esencia_gen > 0) {
        _usuario.esencia = clamp(_usuario.esencia + _p.esencia_gen, 0, _usuario.esencia_llena);
    }

    return _resultado;
}
