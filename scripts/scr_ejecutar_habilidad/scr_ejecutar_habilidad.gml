/// @function scr_ejecutar_habilidad(atacante, defensor, id_habilidad)
function scr_ejecutar_habilidad(_atacante, _defensor, _id) {

    switch (_id) {

        // ==========================================
        // 1. HABILIDADES DE ARMAS
        // ==========================================

        // --- Arma base ---
        case "ataque_basico":
        {
            scr_activar_pasiva_afinidad(_atacante, "uso_habilidad");
            var dano = scr_calcular_dano(_atacante, _defensor);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            scr_activar_pasiva_afinidad(_defensor, "recibir_dano");
            _atacante.esencia = clamp(_atacante.esencia + 10, 0, _atacante.esencia_llena);
        }
        break;

        // --- FUEGO (R1: Filo Igneo) ---
        case "ataque_fuego_basico":
        {
            var dano_base = scr_calcular_dano(_atacante, _defensor);
            var bonus = round(_atacante.poder_elemental * 0.5);
            _defensor.vida_actual = max(0, _defensor.vida_actual - (dano_base + bonus));
            scr_aplicar_estado(_defensor, "quemadura_fuego", round(room_speed * 3), round(_atacante.poder_elemental * 0.4));
            _atacante.esencia = clamp(_atacante.esencia + 10, 0, _atacante.esencia_llena);
        }
        break;

        // --- FUEGO (R2: Mandoble Carmesi) ---
        case "ataque_fuego_mejorado":
        {
            var dano_base = scr_calcular_dano(_atacante, _defensor);
            var bonus = round(_atacante.poder_elemental * 0.8);
            _defensor.vida_actual = max(0, _defensor.vida_actual - (dano_base + bonus));
            scr_aplicar_estado(_defensor, "quemadura_fuego", round(room_speed * 3), round(_atacante.poder_elemental * 0.6));
            _atacante.esencia = clamp(_atacante.esencia + 12, 0, _atacante.esencia_llena);
        }
        break;

        case "explosion_carmesi":
        {
            var dano_base = scr_calcular_dano(_atacante, _defensor);
            var bonus = round(_atacante.poder_elemental * 1.2);
            _defensor.vida_actual = max(0, _defensor.vida_actual - (dano_base + bonus));
            scr_aplicar_estado(_defensor, "quemadura_fuego", round(room_speed * 4), round(_atacante.poder_elemental * 0.8));
            _atacante.esencia = clamp(_atacante.esencia + 20, 0, _atacante.esencia_llena);
        }
        break;

        // --- FUEGO (R3: Espada Solar del Titan) ---
        case "llamarada_solar":
        {
            var dano = scr_calcular_dano(_atacante, _defensor) + round(_atacante.poder_elemental * 1.5);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            scr_aplicar_estado(_defensor, "quemadura_fuego", round(room_speed * 5), round(_atacante.poder_elemental * 1.0));
            _atacante.esencia = clamp(_atacante.esencia + 15, 0, _atacante.esencia_llena);
        }
        break;

        case "furia_del_titan":
        {
            var dano = round((_atacante.ataque_base + _atacante.poder_elemental) * 2.0);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.esencia = clamp(_atacante.esencia + 25, 0, _atacante.esencia_llena);
        }
        break;

        // --- AGUA (R1: Hoja Coral) ---
        case "corte_glaciar":
        {
            var dano = scr_calcular_dano(_atacante, _defensor) + round(_atacante.poder_elemental * 0.4);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.esencia = clamp(_atacante.esencia + 10, 0, _atacante.esencia_llena);
        }
        break;

        // --- AGUA (R2: Tridente Abisal) ---
        case "lanza_marina":
        {
            var dano = scr_calcular_dano(_atacante, _defensor) + round(_atacante.poder_elemental * 0.7);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.esencia = clamp(_atacante.esencia + 12, 0, _atacante.esencia_llena);
        }
        break;

        case "corriente_abisal":
        {
            var dano = round(_atacante.poder_elemental * 1.0);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + round(dano * 0.3));
            _atacante.esencia = clamp(_atacante.esencia + 8, 0, _atacante.esencia_llena);
        }
        break;

        // --- AGUA (R3: Lanza del Maremoto) ---
        case "tsunami":
        {
            var dano = scr_calcular_dano(_atacante, _defensor) + round(_atacante.poder_elemental * 1.4);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.esencia = clamp(_atacante.esencia + 18, 0, _atacante.esencia_llena);
        }
        break;

        case "diluvio_eterno":
        {
            var dano = round(_atacante.poder_elemental * 2.0);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + round(dano * 0.4));
            _atacante.esencia = clamp(_atacante.esencia + 20, 0, _atacante.esencia_llena);
        }
        break;

        // --- PLANTA (R1: Vara Espinosa) ---
        case "latigazo_espina":
        {
            var dano = scr_calcular_dano(_atacante, _defensor) + round(_atacante.poder_elemental * 0.4);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.esencia = clamp(_atacante.esencia + 10, 0, _atacante.esencia_llena);
        }
        break;

        // --- PLANTA (R2: Latigo de Cepa) ---
        case "enredadera_voraz":
        {
            var dano = scr_calcular_dano(_atacante, _defensor) + round(_atacante.poder_elemental * 0.6);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.esencia = clamp(_atacante.esencia + 10, 0, _atacante.esencia_llena);
        }
        break;

        case "drenaje_vital":
        {
            var dano = round(_atacante.poder_elemental * 0.8);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + round(dano * 0.5));
            _atacante.esencia = clamp(_atacante.esencia + 8, 0, _atacante.esencia_llena);
        }
        break;

        // --- PLANTA (R3: Cetro del Bosque Primigenio) ---
        case "explosion_espora":
        {
            var dano = scr_calcular_dano(_atacante, _defensor) + round(_atacante.poder_elemental * 1.3);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.esencia = clamp(_atacante.esencia + 15, 0, _atacante.esencia_llena);
        }
        break;

        case "selva_eterna":
        {
            var dano = round(_atacante.poder_elemental * 1.8);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + round(dano * 0.6));
            _atacante.esencia = clamp(_atacante.esencia + 20, 0, _atacante.esencia_llena);
        }
        break;

        // --- RAYO (R1: Daga Voltaica) ---
        case "descarga_rapida":
        {
            var dano = round(_atacante.ataque_base * 0.8 + _atacante.poder_elemental * 0.5);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.esencia = clamp(_atacante.esencia + 12, 0, _atacante.esencia_llena);
        }
        break;

        // --- RAYO (R2: Garras del Relampago) ---
        case "cadena_electrica":
        {
            var dano = scr_calcular_dano(_atacante, _defensor) + round(_atacante.poder_elemental * 0.7);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.esencia = clamp(_atacante.esencia + 12, 0, _atacante.esencia_llena);
        }
        break;

        case "tormenta_fugaz":
        {
            var dano = round((_atacante.ataque_base + _atacante.poder_elemental) * 1.0);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.esencia = clamp(_atacante.esencia + 15, 0, _atacante.esencia_llena);
        }
        break;

        // --- RAYO (R3: Espada del Trueno Eterno) ---
        case "rayo_fulminante":
        {
            var dano = scr_calcular_dano(_atacante, _defensor) + round(_atacante.poder_elemental * 1.5);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.esencia = clamp(_atacante.esencia + 18, 0, _atacante.esencia_llena);
        }
        break;

        case "juicio_relampago":
        {
            var dano = round((_atacante.ataque_base + _atacante.poder_elemental) * 2.0);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.esencia = clamp(_atacante.esencia + 25, 0, _atacante.esencia_llena);
        }
        break;

        // --- TIERRA (R1: Mazo Petreo) ---
        case "golpe_sismico":
        {
            var dano = scr_calcular_dano(_atacante, _defensor) + round(_atacante.defensa_base * 0.5);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.esencia = clamp(_atacante.esencia + 10, 0, _atacante.esencia_llena);
        }
        break;

        // --- TIERRA (R2: Garrote de Roca Viva) ---
        case "avalancha":
        {
            var dano = scr_calcular_dano(_atacante, _defensor) + round(_atacante.ataque_base * 0.8);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.esencia = clamp(_atacante.esencia + 12, 0, _atacante.esencia_llena);
        }
        break;

        case "escudo_petreo":
        {
            _atacante.defensa_bonus_temp += round(_atacante.defensa_base * 0.4);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + round(_atacante.defensa_base * 0.5));
            _atacante.esencia = clamp(_atacante.esencia + 8, 0, _atacante.esencia_llena);
        }
        break;

        // --- TIERRA (R3: Martillo del Coloso) ---
        case "cataclismo":
        {
            var dano = round((_atacante.ataque_base + _atacante.defensa_base) * 2.0);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.esencia = clamp(_atacante.esencia + 20, 0, _atacante.esencia_llena);
        }
        break;

        case "furia_continental":
        {
            var dano = round(_atacante.ataque_base * 2.5);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.defensa_bonus_temp += round(_atacante.defensa_base * 0.6);
            _atacante.esencia = clamp(_atacante.esencia + 25, 0, _atacante.esencia_llena);
        }
        break;

        // --- SOMBRA (R1: Filo Sombrio) ---
        case "tajo_umbral":
        {
            var dano = scr_calcular_dano(_atacante, _defensor) + round(_atacante.poder_elemental * 0.5);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.esencia = clamp(_atacante.esencia + 10, 0, _atacante.esencia_llena);
        }
        break;

        // --- SOMBRA (R2: Guadana Penumbral) ---
        case "siega_oscura":
        {
            var dano = scr_calcular_dano(_atacante, _defensor) + round(_atacante.poder_elemental * 0.8);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.esencia = clamp(_atacante.esencia + 12, 0, _atacante.esencia_llena);
        }
        break;

        case "drenar_alma":
        {
            var robo = round(_defensor.vida_actual * 0.12);
            _defensor.vida_actual = max(0, _defensor.vida_actual - robo);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + robo);
            _atacante.esencia = clamp(_atacante.esencia + 10, 0, _atacante.esencia_llena);
        }
        break;

        // --- SOMBRA (R3: Espada del Abismo) ---
        case "noche_eterna":
        {
            var dano = scr_calcular_dano(_atacante, _defensor) + round(_atacante.poder_elemental * 1.5);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.esencia = clamp(_atacante.esencia + 18, 0, _atacante.esencia_llena);
        }
        break;

        case "eclipse_total":
        {
            var robo = round(_defensor.vida_actual * 0.20);
            _defensor.vida_actual = max(0, _defensor.vida_actual - robo);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + round(robo * 0.7));
            _atacante.esencia = clamp(_atacante.esencia + 25, 0, _atacante.esencia_llena);
        }
        break;

        // --- LUZ (R1: Espadin Aureo) ---
        case "hoja_radiante":
        {
            var dano = scr_calcular_dano(_atacante, _defensor) + round(_atacante.poder_elemental * 0.4);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.esencia = clamp(_atacante.esencia + 10, 0, _atacante.esencia_llena);
        }
        break;

        // --- LUZ (R2: Lanza Solar) ---
        case "embestida_solar":
        {
            var dano = scr_calcular_dano(_atacante, _defensor) + round(_atacante.poder_elemental * 0.7);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.esencia = clamp(_atacante.esencia + 12, 0, _atacante.esencia_llena);
        }
        break;

        case "bendicion_luz":
        {
            var cura = round(_atacante.poder_elemental * 1.0);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + cura);
            _atacante.esencia = clamp(_atacante.esencia + 8, 0, _atacante.esencia_llena);
        }
        break;

        // --- LUZ (R3: Hoja de la Aurora) ---
        case "amanecer_divino":
        {
            var dano = scr_calcular_dano(_atacante, _defensor) + round(_atacante.poder_elemental * 1.5);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + round(dano * 0.2));
            _atacante.esencia = clamp(_atacante.esencia + 18, 0, _atacante.esencia_llena);
        }
        break;

        case "juicio_celestial":
        {
            var dano = round((_atacante.ataque_base + _atacante.poder_elemental) * 2.0);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            var cura = round(_atacante.poder_elemental * 0.8);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + cura);
            _atacante.esencia = clamp(_atacante.esencia + 25, 0, _atacante.esencia_llena);
        }
        break;

        // --- ARCANO (R1: Vara Runica) ---
        case "pulso_runico":
        {
            var dano = round(_atacante.poder_elemental * 0.8);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.esencia = clamp(_atacante.esencia + 12, 0, _atacante.esencia_llena);
        }
        break;

        // --- ARCANO (R2: Espada Arcana) ---
        case "corte_arcano":
        {
            var dano = scr_calcular_dano(_atacante, _defensor) + round(_atacante.poder_elemental * 0.7);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.esencia = clamp(_atacante.esencia + 12, 0, _atacante.esencia_llena);
        }
        break;

        case "onda_arcana":
        {
            var dano = round(_atacante.poder_elemental * 1.2);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.esencia = clamp(_atacante.esencia + 15, 0, _atacante.esencia_llena);
        }
        break;

        // --- ARCANO (R3: Baston del Primer Conductor) ---
        case "singularidad_arcana":
        {
            var dano = round(_atacante.poder_elemental * 2.0);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.esencia = clamp(_atacante.esencia + 20, 0, _atacante.esencia_llena);
        }
        break;

        case "ruptura_dimensional":
        {
            var dano = round(_atacante.poder_elemental * 2.5);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.esencia = clamp(_atacante.esencia + 30, 0, _atacante.esencia_llena);
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
        // 5. HABILIDADES DE JEFES (Sin Estados)
        // ==========================================
        case "erupcion_forjada": // Titan de las Forjas Rotas (Fuego+Tierra)
            var dano_total = 60;
            _defensor.vida_actual -= dano_total;
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + 30);
            show_debug_message("¡EL TITÁN GOLPEA CON FUERZA BRUTA!");
        break;

        case "maremoto_vegetal": // Coloso del Fango Viviente (Agua+Planta)
            var dano_total = 50;
            _defensor.vida_actual -= dano_total;
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + 20);
            show_debug_message("¡EL COLOSO DESATA UN MAREMOTO VEGETAL!");
        break;

        case "fulgor_celestial": // Sentinela del Cielo Roto (Rayo+Luz)
            var dano_total = 65;
            _defensor.vida_actual -= dano_total;
            show_debug_message("¡LA SENTINELA DESATA UN FULGOR CELESTIAL!");
        break;

        case "vacio_runico": // Oraculo Quebrado del Abismo (Sombra+Arcano)
            var robo = round(_defensor.vida_actual * 0.20);
            _defensor.vida_actual -= robo;
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + round(robo * 0.5));
            show_debug_message("¡EL ORÁCULO INVOCA EL VACÍO RÚNICO!");
        break;

        default:
            show_debug_message("Habilidad no implementada: " + string(_id));
        break;
    }
}