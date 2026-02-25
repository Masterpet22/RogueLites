/// @function scr_ejecutar_habilidad(atacante, defensor, id_habilidad)
function scr_ejecutar_habilidad(_atacante, _defensor, _id) {

    switch (_id) {

        // ==========================================
        // 1. TUS HABILIDADES ORIGINALES (Mantienen Estados)
        // ==========================================
        case "ataque_basico":
        {
            scr_activar_pasiva_afinidad(_atacante, "uso_habilidad");
            var dano = scr_calcular_dano(_atacante, _defensor);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            scr_activar_pasiva_afinidad(_defensor, "recibir_dano");

            _atacante.esencia = clamp(_atacante.esencia + 10, 0, _atacante.esencia_llena);
            show_debug_message(_atacante.nombre + " hace " + string(dano) + " de daño básico.");
        }
        break;

        case "ataque_fuego_basico":
        {
            var dano_base = scr_calcular_dano(_atacante, _defensor);
            var bonus_fuego = round(_atacante.poder_elemental * 0.5);
            var dano_total = dano_base + bonus_fuego;
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano_total);

            // Mantenido por petición
            var duracion = round(room_speed * 3);
            var pot_extra = round(_atacante.poder_elemental * 0.4);
            scr_aplicar_estado(_defensor, "quemadura_fuego", duracion, pot_extra);

            _atacante.esencia = clamp(_atacante.esencia + 10, 0, _atacante.esencia_llena);
        }
        break;

        case "ataque_fuego_mejorado":
        {
            var dano_base = scr_calcular_dano(_atacante, _defensor);
            var bonus_fuego = round(_atacante.poder_elemental * 0.8);
            var dano_total = dano_base + bonus_fuego;
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano_total);

            // Mantenido por petición
            var dur = round(room_speed * 3);
            var pot = round(_atacante.poder_elemental * 0.6);
            scr_aplicar_estado(_defensor, "quemadura_fuego", dur, pot);

            _atacante.esencia = clamp(_atacante.esencia + 12, 0, _atacante.esencia_llena);
        }
        break;

        case "explosion_carmesi":
        {
            var dano_base = scr_calcular_dano(_atacante, _defensor);
            var bonus_explosion = round(_atacante.poder_elemental * 1.2);
            var dano_total = dano_base + bonus_explosion;
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano_total);

            // Mantenido por petición
            var dur = round(room_speed * 4);
            var pot = round(_atacante.poder_elemental * 0.8);
            scr_aplicar_estado(_defensor, "quemadura_fuego", dur, pot);

            _atacante.esencia = clamp(_atacante.esencia + 20, 0, _atacante.esencia_llena);
        }
        break;

        // ==========================================
        // 2. HABILIDADES DE CLASES (Sin Estados)
        // ==========================================
        case "golpe_guardia": // Vanguardia
            var dano_total = scr_calcular_dano(_atacante, _defensor) + round(_atacante.defensa * 1.5);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano_total);
            _atacante.esencia = clamp(_atacante.esencia + 15, 0, _atacante.esencia_llena);
        break;

        case "corte_rapido": // Filotormenta
            var dano_total = round(_atacante.ataque * 0.7 + _atacante.velocidad * 0.6);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano_total);
            _atacante.esencia = clamp(_atacante.esencia + 8, 0, _atacante.esencia_llena);
        break;

        case "impacto_tectonico": // Quebrador
            var dano_total = round(_atacante.ataque * 2.5);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano_total);
            _atacante.esencia = clamp(_atacante.esencia + 5, 0, _atacante.esencia_llena);
        break;

        case "baluarte_ferreo": // Centineela (Rediseñado a curación interna al no haber estados)
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + (_atacante.defensa * 2));
            show_debug_message(_atacante.nombre + " se fortalece y recupera vida.");
        break;

        case "estocada_critica": // Duelista
            var dano_total = round((_atacante.ataque + _atacante.velocidad) * 1.2);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano_total);
            _atacante.esencia = clamp(_atacante.esencia + 15, 0, _atacante.esencia_llena);
        break;

        case "descarga_esencia": // Canalizador
            var dano_total = round(_atacante.poder_elemental * 2.5);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano_total);
        break;

        // ==========================================
        // 3. HABILIDADES DE ENEMIGOS COMUNES (Sin Estados)
        // ==========================================
        case "golpe_fuego": // Soldado Igneo
            _defensor.vida_actual -= (scr_calcular_dano(_atacante, _defensor) + 4);
        break;

        case "mirada_gelida": // Vigia Boreal
            _defensor.vida_actual -= (scr_calcular_dano(_atacante, _defensor) + 2);
        break;

        case "rafaga_cortante": // Halito Verde
            _defensor.vida_actual -= round(_atacante.ataque * 1.3);
        break;

        case "chispazo": // Bestia Tronadora
            _defensor.vida_actual -= 12;
        break;

        case "muro_piedra": // Guardian Terracota (Cura al enemigo)
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + 15);
        break;

        case "abrazo_vacio": // Naufrago
            var robo = 10;
            _defensor.vida_actual -= robo;
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + robo);
        break;

        case "destello_debil": // Paladin Marchito
            _defensor.vida_actual -= scr_calcular_dano(_atacante, _defensor);
        break;

        case "pulso_arcano": // Errante Runico
            _defensor.vida_actual -= round(_atacante.ataque + 8);
        break;

        // ==========================================
        // 4. HABILIDADES DE ENEMIGOS ELITE (Sin Estados)
        // ==========================================
        case "pilar_llama": 
            _defensor.vida_actual -= 35;
        break;

        case "prision_glaciar":
            _defensor.vida_actual -= 25;
        break;

        case "tornado_esmeralda":
            _defensor.vida_actual -= 40;
        break;

        case "tormenta_electrica":
            _defensor.vida_actual -= 30;
        break;

        case "terremoto":
            _defensor.vida_actual -= 45;
        break;

        case "agujero_negro":
            _defensor.vida_actual -= round(_defensor.vida_actual * 0.25);
        break;

        case "juicio_sagrado":
            _defensor.vida_actual -= 50;
        break;

        case "cometa_runico":
            _defensor.vida_actual -= 55;
        break;

        // ==========================================
        // 5. JEFE FINAL (Sin Estados)
        // ==========================================
        case "erupcion_forjada": // Titan
            var dano_total = 60;
            _defensor.vida_actual -= dano_total;
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + 30);
            show_debug_message("¡EL TITÁN GOLPEA CON FUERZA BRUTA!");
        break;

        default:
            show_debug_message("Habilidad no implementada: " + string(_id));
        break;
    }
}