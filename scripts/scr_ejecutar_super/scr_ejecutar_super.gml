/// scr_ejecutar_super(atacante, defensor)
/// Ejecuta la Súper-Habilidad del personaje según Clase × Personalidad.
/// Se puede usar con 50%+, 75%+ o 100% de esencia (efecto escalado).
///   - 50–74%:  potencia ×0.50
///   - 75–99%:  potencia ×0.75
///   - 100%:    potencia ×1.00
/// Siempre vacía toda la esencia al usarla.
/// Total: 24 variantes (6 clases × 4 personalidades).
/// Usa scr_formula_dano / scr_formula_beneficio para consistencia.

function scr_ejecutar_super(_atk, _def) {

    // Seguridad: necesita al menos 50 % de esencia
    var _umbral_min = _atk.esencia_llena * 0.5;
    if (_atk.esencia < _umbral_min) return false;

    // Determinar multiplicador de potencia según tier de esencia
    var _mult_esencia = 1.0;
    var _tier_nombre  = "100%";
    if (_atk.esencia >= _atk.esencia_llena) {
        _mult_esencia = 1.0;
        _tier_nombre  = "100%";
    } else if (_atk.esencia >= _atk.esencia_llena * 0.75) {
        _mult_esencia = 0.75;
        _tier_nombre  = "75%";
    } else {
        _mult_esencia = 0.5;
        _tier_nombre  = "50%";
    }

    // Snapshot de estado antes de ejecutar la súper (para escalado retroactivo)
    var _vida_def_pre  = _def.vida_actual;
    var _vida_atk_pre  = _atk.vida_actual;
    var _defb_atk_pre  = _atk.defensa_bonus_temp;
    var _defb_def_pre  = _def.defensa_bonus_temp;

    var _key = _atk.clase + "_" + _atk.personalidad;

    switch (_key) {

        // =============================================================
        // VANGUARDIA (tanque frontal, carga por recibir daño)
        // =============================================================

        case "Vanguardia_Agresivo":
        {
            // "Embestida Volcánica" — Golpe masivo sin defensa propia
            var _p = { stat1:"ataque", escala1:3.5, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:0, es_arma:false, tipo_dano:"fisico" };
            var d = scr_formula_dano(_atk, _def, _p);
            _def.vida_actual = max(0, _def.vida_actual - d);
        }
        break;

        case "Vanguardia_Metodico":
        {
            // "Fortaleza Inquebrantable" — Curación + escudo temporal
            var _p = { stat1:"vida_max", escala1:0.35, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, esencia_gen:0, es_arma:false };
            var cura = scr_formula_beneficio(_atk, _p);
            _atk.vida_actual = min(_atk.vida_max, _atk.vida_actual + cura);
            _atk.defensa_bonus_temp += round(_atk.defensa_base * 0.5);
        }
        break;

        case "Vanguardia_Temerario":
        {
            // "Sacrificio del Titán" — Daño enorme, se hiere a sí mismo
            var _p = { stat1:"ataque", escala1:5.0, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:0, es_arma:false, tipo_dano:"fisico" };
            var d = scr_formula_dano(_atk, _def, _p);
            _def.vida_actual = max(0, _def.vida_actual - d);
            _atk.vida_actual = max(1, _atk.vida_actual - round(_atk.vida_max * 0.15));
        }
        break;

        case "Vanguardia_Resuelto":
        {
            // "Golpe del Guardián" — Golpe sólido + cura parcial
            var _p = { stat1:"ataque", escala1:3.0, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:0, es_arma:false, tipo_dano:"fisico" };
            var d = scr_formula_dano(_atk, _def, _p);
            _def.vida_actual = max(0, _def.vida_actual - d);
            _atk.vida_actual = min(_atk.vida_max, _atk.vida_actual + round(d * 0.3));
        }
        break;

        // =============================================================
        // FILOTORMENTA (DPS rápido, carga por combos)
        // =============================================================

        case "Filotormenta_Agresivo":
        {
            // "Ráfaga Imparable" — 5 golpes rápidos
            var _p = { stat1:"ataque", escala1:0.6, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:0, es_arma:false, tipo_dano:"fisico" };
            for (var i = 0; i < 5; i++) {
                var d = scr_formula_dano(_atk, _def, _p);
                _def.vida_actual = max(0, _def.vida_actual - d);
            }
        }
        break;

        case "Filotormenta_Metodico":
        {
            // "Corte Preciso" — 3 golpes fuertes + reduce defensa enemiga
            var _p = { stat1:"ataque", escala1:0.9, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:0, es_arma:false, tipo_dano:"fisico" };
            for (var i = 0; i < 3; i++) {
                var d = scr_formula_dano(_atk, _def, _p);
                _def.vida_actual = max(0, _def.vida_actual - d);
            }
            _def.defensa_bonus_temp -= round(_def.defensa_base * 0.2);
        }
        break;

        case "Filotormenta_Temerario":
        {
            // "Tormenta de Acero" — 7 golpes que pierden vida propia
            var _p = { stat1:"ataque", escala1:0.5, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:0, es_arma:false, tipo_dano:"fisico" };
            for (var i = 0; i < 7; i++) {
                var d = scr_formula_dano(_atk, _def, _p);
                _def.vida_actual = max(0, _def.vida_actual - d);
            }
            _atk.vida_actual = max(1, _atk.vida_actual - round(_atk.vida_max * 0.10));
        }
        break;

        case "Filotormenta_Resuelto":
        {
            // "Danza del Filo" — 4 golpes equilibrados
            var _p = { stat1:"ataque", escala1:0.7, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:0, es_arma:false, tipo_dano:"fisico" };
            for (var i = 0; i < 4; i++) {
                var d = scr_formula_dano(_atk, _def, _p);
                _def.vida_actual = max(0, _def.vida_actual - d);
            }
        }
        break;

        // =============================================================
        // QUEBRADOR (golpes pesados, carga por golpes fuertes)
        // =============================================================

        case "Quebrador_Agresivo":
        {
            // "Cataclismo Furioso" — Un impacto devastador
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:1.0, base_fija:0,
                       mult_poder:4.0, penetracion:1.0, esencia_gen:0, es_arma:false, tipo_dano:"fisico" };
            var d = scr_formula_dano(_atk, _def, _p);
            _def.vida_actual = max(0, _def.vida_actual - d);
        }
        break;

        case "Quebrador_Metodico":
        {
            // "Pulverizar" — Daño fuerte + aplicar quemadura
            var _p = { stat1:"ataque", escala1:3.0, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:0, es_arma:false, tipo_dano:"fisico" };
            var d = scr_formula_dano(_atk, _def, _p);
            _def.vida_actual = max(0, _def.vida_actual - d);
            scr_aplicar_estado(_def, "quemadura_fuego", round(GAME_FPS * 5), round(_atk.poder_elemental * 0.4));
        }
        break;

        case "Quebrador_Temerario":
        {
            // "Impacto Suicida" — Daño máximo, pierde mucha vida
            var _p = { stat1:"ataque", escala1:6.0, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:0, es_arma:false, tipo_dano:"fisico" };
            var d = scr_formula_dano(_atk, _def, _p);
            _def.vida_actual = max(0, _def.vida_actual - d);
            _atk.vida_actual = max(1, _atk.vida_actual - round(_atk.vida_max * 0.25));
        }
        break;

        case "Quebrador_Resuelto":
        {
            // "Martillazo Firme" — Buen daño + buff defensa
            var _p = { stat1:"ataque", escala1:3.0, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:0, es_arma:false, tipo_dano:"fisico" };
            var d = scr_formula_dano(_atk, _def, _p);
            _def.vida_actual = max(0, _def.vida_actual - d);
            _atk.defensa_bonus_temp += round(_atk.defensa_base * 0.3);
        }
        break;

        // =============================================================
        // CENTINELA (tanque defensivo, carga al mitigar daño)
        // =============================================================

        case "Centinela_Agresivo":
        {
            // "Contraataque Blindado" — Daño basado en defensa
            var _p = { stat1:"defensa", escala1:3.5, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:0, es_arma:false, tipo_dano:"fisico" };
            var d = scr_formula_dano(_atk, _def, _p);
            _def.vida_actual = max(0, _def.vida_actual - d);
        }
        break;

        case "Centinela_Metodico":
        {
            // "Bastión Eterno" — Gran curación + gran escudo
            var _p = { stat1:"vida_max", escala1:0.40, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, esencia_gen:0, es_arma:false };
            var cura = scr_formula_beneficio(_atk, _p);
            _atk.vida_actual = min(_atk.vida_max, _atk.vida_actual + cura);
            _atk.defensa_bonus_temp += round(_atk.defensa_base * 0.6);
        }
        break;

        case "Centinela_Temerario":
        {
            // "Explosión de Hierro" — Sacrifica escudo por daño masivo
            var bonus_def = max(0, _atk.defensa_bonus_temp);
            var _p = { stat1:"defensa", escala1:1.0, stat2:"ninguno", escala2:0, base_fija:bonus_def,
                       mult_poder:4.0, penetracion:1.0, esencia_gen:0, es_arma:false, tipo_dano:"fisico" };
            var d = scr_formula_dano(_atk, _def, _p);
            _def.vida_actual = max(0, _def.vida_actual - d);
            _atk.defensa_bonus_temp = 0; // pierde todo buff de defensa
        }
        break;

        case "Centinela_Resuelto":
        {
            // "Muro Inquebrantable" — Curación moderada + escudo moderado + daño leve
            var _pd = { stat1:"defensa", escala1:1.5, stat2:"ninguno", escala2:0, base_fija:0,
                        mult_poder:1.0, penetracion:1.0, esencia_gen:0, es_arma:false, tipo_dano:"fisico" };
            var d = scr_formula_dano(_atk, _def, _pd);
            _def.vida_actual = max(0, _def.vida_actual - d);
            var _pb = { stat1:"vida_max", escala1:0.20, stat2:"ninguno", escala2:0, base_fija:0,
                        mult_poder:1.0, esencia_gen:0, es_arma:false };
            var cura = scr_formula_beneficio(_atk, _pb);
            _atk.vida_actual = min(_atk.vida_max, _atk.vida_actual + cura);
            _atk.defensa_bonus_temp += round(_atk.defensa_base * 0.3);
        }
        break;

        // =============================================================
        // DUELISTA (ágil, carga por parry/esquivar)
        // =============================================================

        case "Duelista_Agresivo":
        {
            // "Estocada Mortal" — Golpe crítico garantizado
            var _p = { stat1:"ataque", escala1:1.0, stat2:"velocidad", escala2:1.0, base_fija:0,
                       mult_poder:3.5, penetracion:1.0, esencia_gen:0, es_arma:false, tipo_dano:"fisico" };
            var d = scr_formula_dano(_atk, _def, _p);
            _def.vida_actual = max(0, _def.vida_actual - d);
        }
        break;

        case "Duelista_Metodico":
        {
            // "Mil Cortes" — Muchos golpes pequeños pero seguros
            var _p = { stat1:"ataque", escala1:0.5, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:0, es_arma:false, tipo_dano:"fisico" };
            for (var i = 0; i < 6; i++) {
                var d = scr_formula_dano(_atk, _def, _p);
                _def.vida_actual = max(0, _def.vida_actual - d);
            }
        }
        break;

        case "Duelista_Temerario":
        {
            // "Apuesta Final" — Daño basado en vida perdida (especial)
            var vida_perdida = _atk.vida_max - _atk.vida_actual;
            var _p = { stat1:"ataque", escala1:2.5, stat2:"ninguno", escala2:0, base_fija:round(vida_perdida * 1.5),
                       mult_poder:1.0, penetracion:1.0, esencia_gen:0, es_arma:false, tipo_dano:"fisico" };
            var d = scr_formula_dano(_atk, _def, _p);
            _def.vida_actual = max(0, _def.vida_actual - d);
        }
        break;

        case "Duelista_Resuelto":
        {
            // "Golpe Certero" — Buen daño + roba vida
            var _p = { stat1:"ataque", escala1:1.0, stat2:"velocidad", escala2:1.0, base_fija:0,
                       mult_poder:2.5, penetracion:1.0, esencia_gen:0, es_arma:false, tipo_dano:"fisico" };
            var d = scr_formula_dano(_atk, _def, _p);
            _def.vida_actual = max(0, _def.vida_actual - d);
            _atk.vida_actual = min(_atk.vida_max, _atk.vida_actual + round(d * 0.25));
        }
        break;

        // =============================================================
        // CANALIZADOR (mago, carga por uso elemental)
        // =============================================================

        case "Canalizador_Agresivo":
        {
            // "Nova Arcana" — Explosión de poder elemental puro
            var _p = { stat1:"poder", escala1:5.0, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var d = scr_formula_dano(_atk, _def, _p);
            _def.vida_actual = max(0, _def.vida_actual - d);
        }
        break;

        case "Canalizador_Metodico":
        {
            // "Canalización Estable" — Daño elemental + curación
            var _pd = { stat1:"poder", escala1:3.0, stat2:"ninguno", escala2:0, base_fija:0,
                        mult_poder:1.0, penetracion:1.0, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var d = scr_formula_dano(_atk, _def, _pd);
            _def.vida_actual = max(0, _def.vida_actual - d);
            var _pb = { stat1:"poder", escala1:1.5, stat2:"ninguno", escala2:0, base_fija:0,
                        mult_poder:1.0, esencia_gen:0, es_arma:false };
            var cura = scr_formula_beneficio(_atk, _pb);
            _atk.vida_actual = min(_atk.vida_max, _atk.vida_actual + cura);
        }
        break;

        case "Canalizador_Temerario":
        {
            // "Detonación Interior" — Poder devastador, se daña
            var _p = { stat1:"poder", escala1:7.0, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var d = scr_formula_dano(_atk, _def, _p);
            _def.vida_actual = max(0, _def.vida_actual - d);
            _atk.vida_actual = max(1, _atk.vida_actual - round(_atk.vida_max * 0.20));
        }
        break;

        case "Canalizador_Resuelto":
        {
            // "Flujo Arcano" — Daño constante + resetea cooldowns
            var _p = { stat1:"poder", escala1:3.0, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var d = scr_formula_dano(_atk, _def, _p);
            _def.vida_actual = max(0, _def.vida_actual - d);
            // Resetear cooldowns de todas las habilidades
            for (var i = 0; i < array_length(_atk.habilidades_cd); i++) {
                _atk.habilidades_cd[i] = 0;
            }
        }
        break;

        default:
            show_debug_message("Súper no definida para: " + _key);
            return false;
    }

    // ═══ ESCALADO RETROACTIVO POR TIER DE ESENCIA ═══
    // Recalcular deltas y aplicar _mult_esencia a todos los efectos
    if (_mult_esencia < 1.0) {

        // Daño infligido al defensor
        var _delta_vida_def = _vida_def_pre - _def.vida_actual;
        if (_delta_vida_def > 0) {
            _def.vida_actual = max(0, _vida_def_pre - round(_delta_vida_def * _mult_esencia));
        }

        // Curación o autodaño del atacante
        var _delta_vida_atk = _atk.vida_actual - _vida_atk_pre;
        if (_delta_vida_atk != 0) {
            _atk.vida_actual = clamp(
                _vida_atk_pre + round(_delta_vida_atk * _mult_esencia),
                1, _atk.vida_max
            );
        }

        // Buffs/debuffs de defensa del atacante
        var _delta_defb_atk = _atk.defensa_bonus_temp - _defb_atk_pre;
        if (_delta_defb_atk != 0) {
            _atk.defensa_bonus_temp = _defb_atk_pre + round(_delta_defb_atk * _mult_esencia);
        }

        // Buffs/debuffs de defensa del defensor
        var _delta_defb_def = _def.defensa_bonus_temp - _defb_def_pre;
        if (_delta_defb_def != 0) {
            _def.defensa_bonus_temp = _defb_def_pre + round(_delta_defb_def * _mult_esencia);
        }
    }

    // Consumir TODA la esencia (independientemente del tier)
    _atk.esencia = 0;
    show_debug_message(_atk.nombre + " usó SÚPER (" + _tier_nombre + "): " + _key);

    // ═══ FX VISUAL DE SÚPER ═══
    // Hitstop (0.2s) + screenshake + flash elemental de pantalla
    var _afi_super = variable_struct_exists(_atk, "afinidad") ? _atk.afinidad : "Neutra";
    scr_fx_activar_super(_afi_super, _atk);

    // Bark de combate: línea de diálogo al usar la súper
    scr_bark_on_super(_atk);

    // Hook: Mecánica de Absorción de Esencia del defensor
    if (_atk.es_jugador && variable_struct_exists(_def, "mecanicas")) {
        var _dano_super = max(0, _vida_def_pre - _def.vida_actual);
        scr_mec_absorcion_esencia(_def, _atk, _tier_nombre, _dano_super);
    }

    // Notificación de súper con tier
    var _col_super = _atk.es_jugador ? c_yellow : c_fuchsia;
    var _notif_txt = "¡SÚPER " + _tier_nombre + "! " + _key;
    scr_notif_agregar(_atk.nombre, _notif_txt, _col_super);

    return true;
}
