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
///   2. ×mult_poder  ×mult_rareza  ×mult_afinidad  ×mult_pasivas
///   3. ×varianza aleatoria (±VAR_RANGO)
///   4. ×crítico (solo positivo) + carga progresiva (N1/N2/N3)
///   5. Mitigación = Bruto_amplificado × (K / (K + DEF_efectiva))
///   6. Golpe Rozado (VEL defensor >> VEL atacante)
///   7. Final = max(1, round(todo))

// ══════════════════════════════════════════════════════════════
//  PALANCAS GLOBALES  — modifica estos macros para balancear
// ══════════════════════════════════════════════════════════════
#macro K_MITIGACION       40      // Constante K de mitigación porcentual (40 DEF = 50% reducción)
#macro VAR_RANGO          0.15    // Varianza aleatoria ±15 %  (0.85 – 1.15)
#macro VAR_MIN_ABS        2       // Spread mínimo absoluto (±2 pts) — evita que daños bajos se sientan fijos
#macro CRIT_POS_MULT      1.50    // ×1.5 daño en crítico positivo
#macro GOLPE_ROZADO_MULT  0.70    // ×0.7 daño cuando el defensor es mucho más rápido
#macro GOLPE_ROZADO_VEL_DIF 5     // diferencia de VEL mínima para activar golpe rozado

function scr_formula_dano(_atacante, _defensor, _p) {

    // ─── Paso 1: Daño bruto ───
    var _val1 = scr_get_stat(_atacante, _p.stat1) * _p.escala1;
    var _val2 = scr_get_stat(_atacante, _p.stat2) * _p.escala2;
    var _dano_bruto = _val1 + _val2 + _p.base_fija;

    // ─── Paso 2: Multiplicador de rareza del arma (solo hab. de arma) ───
    //   R0 = 1.0 │ R1 = 1.10 │ R2 = 1.20 │ R3 = 1.30
    var _mult_rareza = 1.0;
    if (_p.es_arma && variable_struct_exists(_atacante, "arma_data") && _atacante.arma_data != undefined) {
        _mult_rareza = 1.0 + (_atacante.arma_data.rareza * 0.10);
    }

    // ─── Paso 3: Ventaja/desventaja de afinidad elemental ───
    var _mult_afi = 1.0;
    if (_p.es_arma
        && variable_struct_exists(_atacante, "arma_data")
        && _atacante.arma_data != undefined
        && _atacante.arma_data.afinidad != "Neutra") {
        _mult_afi = scr_multiplicador_afinidad(_atacante.arma_data.afinidad, _defensor.afinidad);
        if (variable_struct_exists(_defensor, "afinidad_secundaria") && _defensor.afinidad_secundaria != "none") {
            var _alt = scr_multiplicador_afinidad(_atacante.arma_data.afinidad, _defensor.afinidad_secundaria);
            _mult_afi = max(_mult_afi, _alt);
        }
    } else {
        _mult_afi = scr_multiplicador_afinidad_dual(_atacante, _defensor);
    }

    // ─── Paso 4: Pasivas de afinidad ───
    var _mult_pas = 1.0;

    var _atk_afi2 = variable_struct_exists(_atacante, "afinidad_secundaria")
                    ? _atacante.afinidad_secundaria : "none";
    var _def_afi2 = variable_struct_exists(_defensor, "afinidad_secundaria")
                    ? _defensor.afinidad_secundaria : "none";

    if (_atacante.pasiva_activa) {
        var _afi_atk = _atacante.afinidad;
        var _ofensivas = ["Fuego", "Rayo", "Sombra", "Arcano"];
        for (var _oi = 0; _oi < 4; _oi++) {
            if (_afi_atk == _ofensivas[_oi] || _atk_afi2 == _ofensivas[_oi]) {
                var _bono = scr_datos_afinidades(_ofensivas[_oi]).bono;
                _mult_pas *= _bono;
            }
        }
    }

    if (_defensor.pasiva_activa && (_defensor.afinidad == "Tierra" || _def_afi2 == "Tierra")) {
        var _bono_tierra = scr_datos_afinidades("Tierra").bono;
        _mult_pas *= (2.0 - _bono_tierra);
    }

    // ─── Paso 5: Varianza aleatoria ───
    var _dano_pre = _dano_bruto * _p.mult_poder * _mult_rareza * _mult_afi * _mult_pas;
    var _spread_pct = _dano_pre * VAR_RANGO;
    var _spread     = max(_spread_pct, VAR_MIN_ABS);
    var _dano_var   = _dano_pre + random_range(-_spread, _spread);

    // ─── Paso 6: Crítico (solo positivo) + Carga Progresiva ───
    //   Crit y Carga se aplican ANTES de defensa para que funcionen como "rompe-defensas"
    var _crit_chance = CRIT_BASE_CHANCE + floor(_atacante.ataque_base / CRIT_ATK_DIVISOR);
    var _mult_crit = 1.0;
    var _tipo_crit = 0;
    var _roll = irandom(99);
    if (_roll < _crit_chance) {
        _mult_crit = CRIT_POS_MULT;
        _tipo_crit = 1;
        scr_activar_pasiva_afinidad(_atacante, "golpe_critico");
    }

    // Multiplicador de CARGA PROGRESIVA (aplicado antes de defensa)
    var _mult_carga = 1.0;
    if (variable_struct_exists(_atacante, "carga_mult_temp") && _atacante.carga_mult_temp > 1.0) {
        _mult_carga = _atacante.carga_mult_temp;
    }

    var _dano_amplificado = _dano_var * _mult_crit * _mult_carga;

    // ─── Paso 7: Mitigación porcentual por Defensa ───
    //   Daño = bruto_amplificado × (K / (K + DEF_efectiva))
    //   Con K = 40: DEF 40 = 50% reducción, DEF 80 = 33% reducción, DEF 0 = 0% reducción
    var _def_total;
    if (variable_struct_exists(_p, "tipo_dano") && _p.tipo_dano == "magico") {
        _def_total = _defensor.defensa_magica_base + _defensor.defensa_magica_bonus_temp;
    } else {
        _def_total = _defensor.defensa_base + _defensor.defensa_bonus_temp;
    }
    var _def_efectiva = _def_total * (1.0 - _p.penetracion);
    var _reduccion = _def_efectiva;  // guardamos para esencia del Centinela
    var _factor_mitigacion = K_MITIGACION / (K_MITIGACION + max(0, _def_efectiva));
    var _dano_neto = _dano_amplificado * _factor_mitigacion;

    // ─── Paso 8: Golpe Rozado (reemplazo de crítico negativo) ───
    //   Si la VEL del defensor supera la del atacante por >= GOLPE_ROZADO_VEL_DIF, hay probabilidad de rozar
    var _vel_atk = variable_struct_exists(_atacante, "velocidad") ? _atacante.velocidad : 0;
    var _vel_def = variable_struct_exists(_defensor, "velocidad") ? _defensor.velocidad : 0;
    var _vel_dif = _vel_def - _vel_atk;
    if (_vel_dif >= GOLPE_ROZADO_VEL_DIF) {
        var _prob_rozado = min(25, _vel_dif * 3);  // 3% por punto de diferencia, máx 25%
        if (irandom(99) < _prob_rozado) {
            _dano_neto *= GOLPE_ROZADO_MULT;
            _tipo_crit = -1;  // Marcamos como rozado para feedback
        }
    }

    // ─── Paso 9: Resultado final ───
    var _dano_final = max(1, round(_dano_neto));

    // Pasiva de Vanguardia: Contraataque (tras bloqueo exitoso → 50% penetración)
    if (_atacante.es_jugador && variable_struct_exists(_atacante, "contraataque_activo") && _atacante.contraataque_activo) {
        // Ya está incorporada la penetración extra en _def_efectiva arriba? No,
        // el contraataque reduce la defensa percibida DESPUES del cálculo normal.
        // Recalcular con 50% menos defensa efectiva.
        var _def_contra = _def_efectiva * 0.5;
        var _factor_contra = K_MITIGACION / (K_MITIGACION + max(0, _def_contra));
        _dano_final = max(1, round(_dano_amplificado * _factor_contra));
        _atacante.contraataque_activo = false;
        scr_notif_agregar(_atacante.nombre, "¡CONTRAATAQUE! Ignora 50% DEF", c_orange);
    }

    // ─── Paso 9b: Modificadores de RUNAS ───
    if (instance_exists(obj_control_combate)) {
        var _cc = instance_find(obj_control_combate, 0);

        // Runa del Último Aliento: primer ataque del jugador hace 0 daño
        if (_atacante.es_jugador && _cc.runa_primer_ataque) {
            _dano_final = 0;
            _cc.runa_primer_ataque = false;
            scr_notif_agregar("Jugador", "¡Primer ataque nulo! (Runa)", c_purple);
        }

        // Runa de Fortaleza: jugador hace -25% daño
        if (_atacante.es_jugador && _cc.runa_fortaleza) {
            _dano_final = max(1, round(_dano_final * 0.75));
        }

        // Runa de Cristal: +50% daño infligido y +50% daño recibido
        if (_cc.runa_cristal) {
            if (_atacante.es_jugador) {
                _dano_final = round(_dano_final * 1.50);
            }
            if (_defensor.es_jugador) {
                _dano_final = round(_dano_final * 1.50);
            }
        }
    }

    // ─── Paso 9c: Vulnerabilidad por CARGA (defensor cargando recibe +25%) ───
    if (_defensor.es_jugador && variable_struct_exists(_defensor, "carga_activa") && _defensor.carga_activa) {
        _dano_final = round(_dano_final * CARGA_VULN_RECIBIDO);
    }

    // ─── Paso 9e: Evaluación de PARRY del defensor ───
    // Si el defensor (jugador) está en ventana de parry, evaluar resultado
    if (_defensor.es_jugador && _defensor.parry_estado == "ventana") {
        _dano_final = scr_parry_evaluar(_defensor, _atacante, _dano_final);
    }

    // ─── Paso 9e2: Parry enemigo (probabilístico) ───
    // Si el atacante es jugador y el defensor es enemigo en ia_preparando
    if (_atacante.es_jugador && !_defensor.es_jugador
        && variable_struct_exists(_defensor, "parry_chance")
        && _defensor.ia_estado == "ia_preparando"
        && _defensor.parry_cd_timer <= 0) {

        // Chance base + bonus anti-spam
        var _chance_total = _defensor.parry_chance + _defensor.antispam_bloqueo_bonus;
        if (random(1.0) < _chance_total) {
            _dano_final = round(_dano_final * 0.3);  // Bloqueo parcial: -70% daño
            _defensor.parry_cd_timer = round(GAME_FPS * 3);  // CD de 3s entre parries
            scr_notif_agregar(_defensor.nombre, "¡BLOQUEO!", c_aqua);
            // Resetear combo del jugador
            _atacante.combo_contador = 0;
            _atacante.combo_timer = 0;
            show_debug_message("🛡 ENEMY PARRY: " + _defensor.nombre + " bloquea a " + _atacante.nombre
                + " (chance=" + string(round(_chance_total*100)) + "%)");
        }
    }

    // ─── Paso 9e3: Anti-spam tracking ───
    // Registrar uso de habilidad del jugador para ajustar bloqueo enemigo
    if (_atacante.es_jugador && !_defensor.es_jugador
        && variable_struct_exists(_defensor, "antispam_tracking")
        && variable_struct_exists(_atacante, "hab_actual_id")
        && _atacante.hab_actual_id != "") {

        var _hab_usada = _atacante.hab_actual_id;
        var _map = _defensor.antispam_tracking;
        var _usos = ds_map_exists(_map, _hab_usada) ? _map[? _hab_usada] : 0;
        _map[? _hab_usada] = _usos + 1;

        // Si abusa de la misma técnica (3+ usos), aumentar bloqueo
        if (_usos + 1 >= 3) {
            _defensor.antispam_bloqueo_bonus = min(0.30, (_usos + 1 - 2) * 0.05);
        } else {
            _defensor.antispam_bloqueo_bonus = 0;
        }
    }

    // ─── Paso 9f: Interrumpir carga del jugador si recibe daño ───
    if (_defensor.es_jugador && variable_struct_exists(_defensor, "carga_activa") && _defensor.carga_activa && _dano_final > 0) {
        scr_carga_interrumpir_por_dano(_defensor);
    }

    // ─── Paso 10: Mecánicas especiales de combate ───
    // Si el defensor es un enemigo con mecánicas → modificar daño recibido
    if (!_defensor.es_jugador && variable_struct_exists(_defensor, "mecanicas")) {
        var _afi_ataque = _atacante.afinidad; // afinidad del ataque
        if (_p.es_arma && variable_struct_exists(_atacante, "arma_data") && _atacante.arma_data != undefined) {
            _afi_ataque = _atacante.arma_data.afinidad;
        }
        _dano_final = scr_mec_modificar_dano_recibido(_atacante, _defensor, _dano_final, _afi_ataque);
        // Acumular reflejo diferido
        scr_mec_reflejo_acumular(_defensor, _dano_final);
        // Registrar habilidad para penalización por repetición
        // (usamos la afinidad como key de tracking simplificada)
        scr_mec_registrar_habilidad(_defensor, _afi_ataque);
    }
    // Si el atacante es un enemigo con mecánicas → modificar daño infligido
    if (!_atacante.es_jugador && variable_struct_exists(_atacante, "mecanicas")) {
        // Necesitamos referencia al jugador (el defensor en este caso)
        _dano_final = scr_mec_modificar_dano_infligido(_atacante, _defensor, _dano_final);
    }

    // Debug: mostrar varianza real para verificar aleatoriedad
    show_debug_message("⚔ " + _atacante.nombre + " → " + _defensor.nombre
        + " | pre=" + string(round(_dano_pre*100)/100)
        + " amp=" + string(round(_dano_amplificado*100)/100)
        + " mitig=" + string(round(_factor_mitigacion*100)/100)
        + " crit=" + string(_mult_crit)
        + (_tipo_crit == -1 ? " [ROZADO]" : "")
        + " FINAL=" + string(_dano_final));

    // ─── Paso 10b: Sistema de Combos ───
    if (_dano_final > 0) {
        _atacante.combo_contador++;
        _atacante.combo_timer = GAME_FPS * 2;  // 2 segundos para mantener combo
        _atacante.combo_max = max(_atacante.combo_max, _atacante.combo_contador);
    }

    // Generar esencia dinámica
    //   base (del param) + % del daño + bonus velocidad + bonus poder (si mágico)
    //   crit positivo multiplica el total por ESENCIA_CRIT_BONUS
    //   multiplicador de clase según método de carga
    if (_p.esencia_gen > 0) {
        var _esen_base = _p.esencia_gen;
        var _esen_dano = round(_dano_final * ESENCIA_PCT_DANO);
        var _esen_vel  = round(_atacante.velocidad * ESENCIA_MULT_VEL);
        var _esen_mag  = (variable_struct_exists(_p, "tipo_dano") && _p.tipo_dano == "magico")
                         ? round(_atacante.poder_elemental * ESENCIA_MULT_PODER_MAG) : 0;
        var _esen_total = _esen_base + _esen_dano + _esen_vel + _esen_mag;
        if (_tipo_crit == 1) _esen_total = round(_esen_total * ESENCIA_CRIT_BONUS);

        // Multiplicador de clase: cada clase genera más esencia en su evento preferido
        if (_atacante.es_jugador && variable_struct_exists(_atacante, "clase")) {
            var _mult_clase_es = ESENCIA_CLASE_BASE;  // por defecto, evento no-preferido
            switch (_atacante.clase) {
                case "Quebrador":
                    // Genera más con golpes fuertes (>= mult_poder 1.3)
                    if (_p.mult_poder >= 1.3) _mult_clase_es = ESENCIA_CLASE_BONUS;
                    break;
                case "Filotormenta":
                    // Genera más por cada uso de habilidad (siempre, pero más si CD bajo)
                    _mult_clase_es = ESENCIA_CLASE_BONUS;
                    break;
                case "Canalizador":
                    // Genera más con habilidades mágicas/elementales
                    if (variable_struct_exists(_p, "tipo_dano") && _p.tipo_dano == "magico")
                        _mult_clase_es = ESENCIA_CLASE_BONUS;
                    else
                        _mult_clase_es = 1.0; // normal para físico
                    break;
                case "Duelista":
                    // Bonus base normal en ataque, su bonus real viene de contraataques (Step)
                    _mult_clase_es = 1.0;
                    break;
                case "Vanguardia":
                    // Su bonus real viene de recibir daño (abajo en defensor)
                    _mult_clase_es = 0.80;
                    break;
                case "Centinela":
                    // Su bonus real viene de mitigar daño (abajo en defensor)
                    _mult_clase_es = 0.80;
                    break;
            }
            _esen_total = round(_esen_total * _mult_clase_es);
        }

        // Runa Vampírica: -40% generación de esencia
        if (instance_exists(obj_control_combate)) {
            var _cc2 = instance_find(obj_control_combate, 0);
            if (_cc2.runa_vampirica && _atacante.es_jugador) {
                _esen_total = round(_esen_total * 0.60);
            }
        }

        _atacante.esencia = clamp(_atacante.esencia + _esen_total, 0, _atacante.esencia_llena);
    }

    // ── Esencia para el DEFENSOR al recibir daño (Vanguardia / Centinela) ──
    if (_defensor.es_jugador && variable_struct_exists(_defensor, "clase") && _dano_final > 0) {
        var _esen_def = 0;
        if (_defensor.clase == "Vanguardia") {
            // Vanguardia: gana esencia al recibir daño (50% del daño recibido)
            _esen_def = round(_dano_final * 0.50);
        } else if (_defensor.clase == "Centinela") {
            // Centinela: gana esencia al mitigar daño (basado en defensa usada)
            _esen_def = round(_reduccion * 0.40);
        }
        if (_esen_def > 0) {
            _defensor.esencia = clamp(_defensor.esencia + _esen_def, 0, _defensor.esencia_llena);
        }
    }

    // ── Reducir POSTURA del enemigo al recibir daño del jugador ──
    if (_atacante.es_jugador && !_defensor.es_jugador && _dano_final > 0) {
        var _id_hab_actual = variable_struct_exists(_atacante, "hab_actual_id") ? _atacante.hab_actual_id : "";
        var _postura_dano = scr_postura_dano_habilidad(_id_hab_actual);
        scr_postura_reducir(_defensor, _postura_dano);
    }

    // ── Bonificación SINERGIA: carga máxima + enemigo stunned → x2 esencia ──
    if (_atacante.es_jugador && !_defensor.es_jugador
        && variable_struct_exists(_atacante, "carga_nivel_temp") && _atacante.carga_nivel_temp >= 3
        && scr_esta_stunned(_defensor)) {
        var _bonus_sinergia = round(_atacante.esencia_llena * 0.05); // +5% extra base
        _bonus_sinergia = round(_bonus_sinergia * STUN_ESENCIA_MULT);
        _atacante.esencia = clamp(_atacante.esencia + _bonus_sinergia, 0, _atacante.esencia_llena);
        scr_notif_agregar(_atacante.nombre, "¡COMBO MAESTRO! +" + string(_bonus_sinergia) + " esencia", c_yellow);
    }

    // Resetear multiplicador temporal de carga tras aplicar
    if (_atacante.es_jugador && variable_struct_exists(_atacante, "carga_mult_temp")) {
        _atacante.carga_mult_temp = 1.0;
        _atacante.carga_nivel_temp = 1;
    }

    return _dano_final;
}
