/// @function scr_formula_dano(atacante, defensor, params)
/// @description  Fórmula UNIVERSAL de daño. Todas las habilidades ofensivas la usan.
///
/// params = {
///   stat1       : string   – stat primaria del atacante ("ataque","poder","defensa","velocidad","vida_max","ninguno")
///   escala1     : real     – multiplicador de stat1
///   stat2       : string   – stat secundaria (o "ninguno")
///   escala2     : real     – multiplicador de stat2
///   base_fija   : real     – daño plano sumado antes de defensa
///   mult_poder  : real     – amplificador general del diseñador  (1.0 = normal)
///   penetracion : real     – 0.0 = defensa normal, 1.0 = ignora toda defensa
///   esencia_gen : real     – esencia generada al usar (0 para enemigos/supers)
///   es_arma     : bool     – true = habilidad de arma → usa afinidad del ARMA para ventaja elemental
/// }
///
/// Flujo:
///   1. Daño bruto = stat1×esc1 + stat2×esc2 + base_fija
///   2. Reducción  = DEF_defensor × FACTOR_DEF × (1 − penetración)
///   3. Neto       = max(1, bruto − reducción)
///   4. ×mult_poder  ×mult_rareza  ×mult_afinidad  ×mult_pasivas
///   5. ×varianza aleatoria (±VAR_RANGO)
///   6. ×crítico (positivo o negativo, según prob.)
///   7. Final      = max(1, round(todo))

// ══════════════════════════════════════════════════════════════
//  PALANCAS GLOBALES  — modifica estos macros para balancear
// ══════════════════════════════════════════════════════════════
#macro FACTOR_DEF_GLOBAL  0.5     // Peso de la defensa en todo el juego
#macro VAR_RANGO          0.15    // Varianza aleatoria ±15 %  (0.85 – 1.15)
#macro VAR_MIN_ABS        2       // Spread mínimo absoluto (±2 pts) — evita que daños bajos se sientan fijos
#macro CRIT_POS_CHANCE    5       // % probabilidad de crítico positivo  (antes 10)
#macro CRIT_POS_MULT      1.50    // ×1.5 daño en crítico positivo
#macro CRIT_NEG_CHANCE    3       // % probabilidad de crítico negativo  (antes 5)
#macro CRIT_NEG_MULT      0.60    // ×0.6 daño en crítico negativo

function scr_formula_dano(_atacante, _defensor, _p) {

    // ─── Paso 1: Daño bruto ───
    var _val1 = scr_get_stat(_atacante, _p.stat1) * _p.escala1;
    var _val2 = scr_get_stat(_atacante, _p.stat2) * _p.escala2;
    var _dano_bruto = _val1 + _val2 + _p.base_fija;

    // ─── Paso 2: Reducción por defensa del defensor ───
    //   tipo_dano "fisico" → usa defensa; "magico" → usa defensa_magica
    var _def_total;
    if (variable_struct_exists(_p, "tipo_dano") && _p.tipo_dano == "magico") {
        _def_total = _defensor.defensa_magica_base + _defensor.defensa_magica_bonus_temp;
    } else {
        _def_total = _defensor.defensa_base + _defensor.defensa_bonus_temp;
    }
    var _reduccion = _def_total * FACTOR_DEF_GLOBAL * (1.0 - _p.penetracion);
    var _dano_neto = max(1, _dano_bruto - _reduccion);

    // ─── Paso 3: Multiplicador de rareza del arma (solo hab. de arma) ───
    //   R0 = 1.0 │ R1 = 1.10 │ R2 = 1.20 │ R3 = 1.30
    var _mult_rareza = 1.0;
    if (_p.es_arma && variable_struct_exists(_atacante, "arma_data") && _atacante.arma_data != undefined) {
        _mult_rareza = 1.0 + (_atacante.arma_data.rareza * 0.10);
    }

    // ─── Paso 4: Ventaja/desventaja de afinidad elemental ───
    var _mult_afi = 1.0;
    if (_p.es_arma
        && variable_struct_exists(_atacante, "arma_data")
        && _atacante.arma_data != undefined
        && _atacante.arma_data.afinidad != "Neutra") {
        // Habilidad de arma → afinidad del ARMA vs defensor
        _mult_afi = scr_multiplicador_afinidad(_atacante.arma_data.afinidad, _defensor.afinidad);
        // Checa afinidad secundaria del defensor (jefes duales)
        if (variable_struct_exists(_defensor, "afinidad_secundaria") && _defensor.afinidad_secundaria != "none") {
            var _alt = scr_multiplicador_afinidad(_atacante.arma_data.afinidad, _defensor.afinidad_secundaria);
            _mult_afi = max(_mult_afi, _alt);
        }
    } else {
        // Habilidad de clase / enemigo → afinidad del PERSONAJE vs defensor
        _mult_afi = scr_multiplicador_afinidad_dual(_atacante, _defensor);
    }

    // ─── Paso 5: Pasivas de afinidad ───
    var _mult_pas = 1.0;

    var _atk_afi2 = variable_struct_exists(_atacante, "afinidad_secundaria")
                    ? _atacante.afinidad_secundaria : "none";
    var _def_afi2 = variable_struct_exists(_defensor, "afinidad_secundaria")
                    ? _defensor.afinidad_secundaria : "none";

    // Fuego: +20 % daño cuando pasiva activa
    if (_atacante.pasiva_activa && (_atacante.afinidad == "Fuego" || _atk_afi2 == "Fuego")) {
        _mult_pas *= 1.20;
    }
    // Rayo: +15 % daño cuando pasiva activa
    if (_atacante.pasiva_activa && (_atacante.afinidad == "Rayo" || _atk_afi2 == "Rayo")) {
        _mult_pas *= 1.15;
    }
    // Sombra: +25 % daño cuando pasiva activa (golpe crítico)
    if (_atacante.pasiva_activa && (_atacante.afinidad == "Sombra" || _atk_afi2 == "Sombra")) {
        _mult_pas *= 1.25;
    }
    // Arcano: +20 % daño cuando pasiva activa
    if (_atacante.pasiva_activa && (_atacante.afinidad == "Arcano" || _atk_afi2 == "Arcano")) {
        _mult_pas *= 1.20;
    }

    // Tierra defensiva: defensor recibe −20 % daño
    if (_defensor.pasiva_activa && (_defensor.afinidad == "Tierra" || _def_afi2 == "Tierra")) {
        _mult_pas *= 0.80;
    }

    // ─── Paso 6: Varianza aleatoria ───
    //   Usa el MAYOR entre spread porcentual (±VAR_RANGO) y spread absoluto (±VAR_MIN_ABS)
    //   Así golpes débiles (~5-8 daño) igualmente sienten variación.
    var _dano_pre = _dano_neto * _p.mult_poder * _mult_rareza * _mult_afi * _mult_pas;
    var _spread_pct = _dano_pre * VAR_RANGO;            // spread porcentual
    var _spread     = max(_spread_pct, VAR_MIN_ABS);    // garantiza mínimo ±VAR_MIN_ABS pts
    var _dano_var   = _dano_pre + random_range(-_spread, _spread);

    // ─── Paso 7: Crítico (positivo o negativo) ───
    //   Crit chance dinámica: base + floor(ataque / divisor)
    var _crit_chance = CRIT_BASE_CHANCE + floor(_atacante.ataque_base / CRIT_ATK_DIVISOR);
    var _mult_crit = 1.0;
    var _tipo_crit = 0;  // 0 = normal, 1 = crit+, -1 = crit-
    var _roll = irandom(99);
    if (_roll < _crit_chance) {
        _mult_crit = CRIT_POS_MULT;
        _tipo_crit = 1;
    } else if (_roll >= (100 - CRIT_NEG_CHANCE)) {
        _mult_crit = CRIT_NEG_MULT;
        _tipo_crit = -1;
    }

    // ─── Paso 8: Resultado final ───
    var _dano_final = max(1, round(_dano_var * _mult_crit));

    // Debug: mostrar varianza real para verificar aleatoriedad
    show_debug_message("⚔ " + _atacante.nombre + " → " + _defensor.nombre
        + " | pre=" + string(round(_dano_pre*100)/100)
        + " spread=±" + string(round(_spread*100)/100)
        + " var=" + string(round(_dano_var*100)/100)
        + " crit=" + string(_mult_crit)
        + " FINAL=" + string(_dano_final));

    // Generar esencia dinámica
    //   base (del param) + % del daño + bonus velocidad + bonus poder (si mágico)
    //   crit positivo multiplica el total por ESENCIA_CRIT_BONUS
    if (_p.esencia_gen > 0) {
        var _esen_base = _p.esencia_gen;
        var _esen_dano = round(_dano_final * ESENCIA_PCT_DANO);
        var _esen_vel  = round(_atacante.velocidad * ESENCIA_MULT_VEL);
        var _esen_mag  = (variable_struct_exists(_p, "tipo_dano") && _p.tipo_dano == "magico")
                         ? round(_atacante.poder_elemental * ESENCIA_MULT_PODER_MAG) : 0;
        var _esen_total = _esen_base + _esen_dano + _esen_vel + _esen_mag;
        if (_tipo_crit == 1) _esen_total = round(_esen_total * ESENCIA_CRIT_BONUS);
        _atacante.esencia = clamp(_atacante.esencia + _esen_total, 0, _atacante.esencia_llena);
    }

    return _dano_final;
}
