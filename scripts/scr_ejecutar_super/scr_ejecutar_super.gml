/// scr_ejecutar_super(atacante, defensor)
/// Ejecuta la Súper-Habilidad del personaje según Clase × Personalidad.
/// Requiere esencia == esencia_llena (100). La consume al usarla.
/// Total: 24 variantes (6 clases × 4 personalidades).

function scr_ejecutar_super(_atk, _def) {

    // Seguridad: necesita esencia llena
    if (_atk.esencia < _atk.esencia_llena) return false;

    var _key = _atk.clase + "_" + _atk.personalidad;

    switch (_key) {

        // =============================================================
        // VANGUARDIA (tanque frontal, carga por recibir daño)
        // =============================================================

        case "Vanguardia_Agresivo":
            // "Embestida Volcánica" — Golpe masivo sin defensa propia
            var d = round(_atk.ataque_base * 3.5);
            _def.vida_actual = max(0, _def.vida_actual - d);
            break;

        case "Vanguardia_Metodico":
            // "Fortaleza Inquebrantable" — Curación + escudo temporal
            _atk.vida_actual = min(_atk.vida_max, _atk.vida_actual + round(_atk.vida_max * 0.35));
            _atk.defensa_bonus_temp += round(_atk.defensa_base * 0.5);
            break;

        case "Vanguardia_Temerario":
            // "Sacrificio del Titán" — Daño enorme, se hiere a sí mismo
            var d = round(_atk.ataque_base * 5.0);
            _def.vida_actual = max(0, _def.vida_actual - d);
            _atk.vida_actual = max(1, _atk.vida_actual - round(_atk.vida_max * 0.15));
            break;

        case "Vanguardia_Resuelto":
            // "Golpe del Guardián" — Golpe sólido + cura parcial
            var d = round(_atk.ataque_base * 3.0);
            _def.vida_actual = max(0, _def.vida_actual - d);
            _atk.vida_actual = min(_atk.vida_max, _atk.vida_actual + round(d * 0.3));
            break;

        // =============================================================
        // FILOTORMENTA (DPS rápido, carga por combos)
        // =============================================================

        case "Filotormenta_Agresivo":
            // "Ráfaga Imparable" — 5 golpes rápidos
            for (var i = 0; i < 5; i++) {
                var d = round(scr_calcular_dano(_atk, _def) * 0.6);
                _def.vida_actual = max(0, _def.vida_actual - d);
            }
            break;

        case "Filotormenta_Metodico":
            // "Corte Preciso" — 3 golpes fuertes + reduce defensa enemiga
            for (var i = 0; i < 3; i++) {
                var d = round(scr_calcular_dano(_atk, _def) * 0.9);
                _def.vida_actual = max(0, _def.vida_actual - d);
            }
            _def.defensa_bonus_temp -= round(_def.defensa_base * 0.2);
            break;

        case "Filotormenta_Temerario":
            // "Tormenta de Acero" — 7 golpes que pierden vida propia
            for (var i = 0; i < 7; i++) {
                var d = round(scr_calcular_dano(_atk, _def) * 0.5);
                _def.vida_actual = max(0, _def.vida_actual - d);
            }
            _atk.vida_actual = max(1, _atk.vida_actual - round(_atk.vida_max * 0.10));
            break;

        case "Filotormenta_Resuelto":
            // "Danza del Filo" — 4 golpes equilibrados + gana esencia residual
            for (var i = 0; i < 4; i++) {
                var d = round(scr_calcular_dano(_atk, _def) * 0.7);
                _def.vida_actual = max(0, _def.vida_actual - d);
            }
            break;

        // =============================================================
        // QUEBRADOR (golpes pesados, carga por golpes fuertes)
        // =============================================================

        case "Quebrador_Agresivo":
            // "Cataclismo Furioso" — Un impacto devastador
            var d = round((_atk.ataque_base + _atk.poder_elemental) * 4.0);
            _def.vida_actual = max(0, _def.vida_actual - d);
            break;

        case "Quebrador_Metodico":
            // "Pulverizar" — Daño fuerte + aplicar quemadura
            var d = round(_atk.ataque_base * 3.0);
            _def.vida_actual = max(0, _def.vida_actual - d);
            scr_aplicar_estado(_def, "quemadura_fuego", round(room_speed * 5), round(_atk.poder_elemental * 0.8));
            break;

        case "Quebrador_Temerario":
            // "Impacto Suicida" — Daño máximo, pierde mucha vida
            var d = round(_atk.ataque_base * 6.0);
            _def.vida_actual = max(0, _def.vida_actual - d);
            _atk.vida_actual = max(1, _atk.vida_actual - round(_atk.vida_max * 0.25));
            break;

        case "Quebrador_Resuelto":
            // "Martillazo Firme" — Buen daño + buff defensa
            var d = round(_atk.ataque_base * 3.0);
            _def.vida_actual = max(0, _def.vida_actual - d);
            _atk.defensa_bonus_temp += round(_atk.defensa_base * 0.3);
            break;

        // =============================================================
        // CENTINELA (tanque defensivo, carga al mitigar daño)
        // =============================================================

        case "Centinela_Agresivo":
            // "Contraataque Blindado" — Daño basado en defensa
            var d = round(_atk.defensa_base * 3.5);
            _def.vida_actual = max(0, _def.vida_actual - d);
            break;

        case "Centinela_Metodico":
            // "Bastión Eterno" — Gran curación + gran escudo
            _atk.vida_actual = min(_atk.vida_max, _atk.vida_actual + round(_atk.vida_max * 0.40));
            _atk.defensa_bonus_temp += round(_atk.defensa_base * 0.6);
            break;

        case "Centinela_Temerario":
            // "Explosión de Hierro" — Sacrifica escudo por daño masivo
            var bonus_def = max(0, _atk.defensa_bonus_temp);
            var d = round((_atk.defensa_base + bonus_def) * 4.0);
            _def.vida_actual = max(0, _def.vida_actual - d);
            _atk.defensa_bonus_temp = 0; // pierde todo buff de defensa
            break;

        case "Centinela_Resuelto":
            // "Muro Inquebrantable" — Curación moderada + escudo moderado + daño leve
            var d = round(_atk.defensa_base * 1.5);
            _def.vida_actual = max(0, _def.vida_actual - d);
            _atk.vida_actual = min(_atk.vida_max, _atk.vida_actual + round(_atk.vida_max * 0.20));
            _atk.defensa_bonus_temp += round(_atk.defensa_base * 0.3);
            break;

        // =============================================================
        // DUELISTA (ágil, carga por parry/esquivar)
        // =============================================================

        case "Duelista_Agresivo":
            // "Estocada Mortal" — Golpe crítico garantizado
            var d = round((_atk.ataque_base + _atk.velocidad) * 3.5);
            _def.vida_actual = max(0, _def.vida_actual - d);
            break;

        case "Duelista_Metodico":
            // "Mil Cortes" — Muchos golpes pequeños pero seguros
            for (var i = 0; i < 6; i++) {
                var d = round(_atk.ataque_base * 0.5);
                _def.vida_actual = max(0, _def.vida_actual - d);
            }
            break;

        case "Duelista_Temerario":
            // "Apuesta Final" — Daño basado en vida perdida
            var vida_perdida = _atk.vida_max - _atk.vida_actual;
            var d = round(_atk.ataque_base * 2.5 + vida_perdida * 1.5);
            _def.vida_actual = max(0, _def.vida_actual - d);
            break;

        case "Duelista_Resuelto":
            // "Golpe Certero" — Buen daño + roba vida
            var d = round((_atk.ataque_base + _atk.velocidad) * 2.5);
            _def.vida_actual = max(0, _def.vida_actual - d);
            _atk.vida_actual = min(_atk.vida_max, _atk.vida_actual + round(d * 0.25));
            break;

        // =============================================================
        // CANALIZADOR (mago, carga por uso elemental)
        // =============================================================

        case "Canalizador_Agresivo":
            // "Nova Arcana" — Explosión de poder elemental puro
            var d = round(_atk.poder_elemental * 5.0);
            _def.vida_actual = max(0, _def.vida_actual - d);
            break;

        case "Canalizador_Metodico":
            // "Canalización Estable" — Daño elemental + curación
            var d = round(_atk.poder_elemental * 3.0);
            _def.vida_actual = max(0, _def.vida_actual - d);
            _atk.vida_actual = min(_atk.vida_max, _atk.vida_actual + round(_atk.poder_elemental * 1.5));
            break;

        case "Canalizador_Temerario":
            // "Detonación Interior" — Poder devastador, se daña
            var d = round(_atk.poder_elemental * 7.0);
            _def.vida_actual = max(0, _def.vida_actual - d);
            _atk.vida_actual = max(1, _atk.vida_actual - round(_atk.vida_max * 0.20));
            break;

        case "Canalizador_Resuelto":
            // "Flujo Arcano" — Daño constante + resetea cooldowns
            var d = round(_atk.poder_elemental * 3.0);
            _def.vida_actual = max(0, _def.vida_actual - d);
            // Resetear cooldowns de todas las habilidades
            for (var i = 0; i < array_length(_atk.habilidades_cd); i++) {
                _atk.habilidades_cd[i] = 0;
            }
            break;

        default:
            show_debug_message("Súper no definida para: " + _key);
            return false;
    }

    // Consumir esencia
    _atk.esencia = 0;
    show_debug_message(_atk.nombre + " usó SÚPER: " + _key);
    return true;
}
