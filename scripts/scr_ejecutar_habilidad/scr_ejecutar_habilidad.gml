/// @function scr_ejecutar_habilidad(atacante, defensor, id_habilidad)
/// @description  Ejecuta la habilidad indicada.
///   Usa scr_formula_dano / scr_formula_beneficio para TODAS las habilidades,
///   asegurando que las capas de personalidad, afinidad, rareza y pasivas
///   siempre se apliquen de forma consistente.

function scr_ejecutar_habilidad(_atacante, _defensor, _id) {

    switch (_id) {

        // ==========================================================
        //  1.  H A B I L I D A D E S   D E   A R M A S
        // ==========================================================

        // ── Arma base ──
        case "ataque_basico":
        {
            scr_activar_pasiva_afinidad(_atacante, "uso_habilidad");
            var _p = { stat1:"ataque", escala1:1.0, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:10, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            scr_activar_pasiva_afinidad(_defensor, "recibir_dano");
        }
        break;

        // ── FUEGO R1: Filo Igneo ──
        case "ataque_fuego_basico":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:0.5, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:10, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            scr_aplicar_estado(_defensor, "quemadura_fuego", round(room_speed * 3), round(_atacante.poder_elemental * 0.4));
        }
        break;

        // ── FUEGO R2: Mandoble Carmesi ──
        case "ataque_fuego_mejorado":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:0.8, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:12, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            scr_aplicar_estado(_defensor, "quemadura_fuego", round(room_speed * 3), round(_atacante.poder_elemental * 0.6));
        }
        break;

        case "explosion_carmesi":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:1.2, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:20, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            scr_aplicar_estado(_defensor, "quemadura_fuego", round(room_speed * 4), round(_atacante.poder_elemental * 0.8));
        }
        break;

        // ── FUEGO R3: Espada Solar del Titan ──
        case "llamarada_solar":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:1.5, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:15, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            scr_aplicar_estado(_defensor, "quemadura_fuego", round(room_speed * 5), round(_atacante.poder_elemental * 1.0));
        }
        break;

        case "furia_del_titan":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:1.0, base_fija:0,
                       mult_poder:2.0, penetracion:1.0, esencia_gen:25, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        // ── AGUA R1: Hoja Coral ──
        case "corte_glaciar":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:0.4, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:10, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        // ── AGUA R2: Tridente Abisal ──
        case "lanza_marina":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:0.7, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:12, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "corriente_abisal":  // Daño + autocuración 30 %
        {
            var _p = { stat1:"poder", escala1:1.0, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:8, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + round(dano * 0.3));
        }
        break;

        // ── AGUA R3: Lanza del Maremoto ──
        case "tsunami":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:1.4, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:18, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "diluvio_eterno":  // Daño + autocuración 40 %
        {
            var _p = { stat1:"poder", escala1:2.0, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:20, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + round(dano * 0.4));
        }
        break;

        // ── PLANTA R1: Vara Espinosa ──
        case "latigazo_espina":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:0.4, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:10, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        // ── PLANTA R2: Latigo de Cepa ──
        case "enredadera_voraz":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:0.6, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:10, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "drenaje_vital":  // Daño + autocuración 50 %
        {
            var _p = { stat1:"poder", escala1:0.8, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:8, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + round(dano * 0.5));
        }
        break;

        // ── PLANTA R3: Cetro del Bosque Primigenio ──
        case "explosion_espora":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:1.3, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:15, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "selva_eterna":  // Daño + autocuración 60 %
        {
            var _p = { stat1:"poder", escala1:1.8, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:20, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + round(dano * 0.6));
        }
        break;

        // ── RAYO R1: Daga Voltaica ──
        case "descarga_rapida":
        {
            var _p = { stat1:"ataque", escala1:0.8, stat2:"poder", escala2:0.5, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:12, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        // ── RAYO R2: Garras del Relampago ──
        case "cadena_electrica":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:0.7, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:12, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "tormenta_fugaz":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:1.0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:15, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        // ── RAYO R3: Espada del Trueno Eterno ──
        case "rayo_fulminante":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:1.5, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:18, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "juicio_relampago":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:1.0, base_fija:0,
                       mult_poder:2.0, penetracion:1.0, esencia_gen:25, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        // ── TIERRA R1: Mazo Petreo ──
        case "golpe_sismico":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"defensa", escala2:0.5, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:10, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        // ── TIERRA R2: Garrote de Roca Viva ──
        case "avalancha":
        {
            var _p = { stat1:"ataque", escala1:1.8, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:12, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "escudo_petreo":  // Escudo + curación
        {
            var _p_buff = { stat1:"defensa", escala1:0.5, stat2:"ninguno", escala2:0, base_fija:0,
                            mult_poder:1.0, esencia_gen:8, es_arma:true };
            var cura = scr_formula_beneficio(_atacante, _p_buff);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + cura);
            _atacante.defensa_bonus_temp += round(scr_get_stat(_atacante, "defensa") * 0.4);
        }
        break;

        // ── TIERRA R3: Martillo del Coloso ──
        case "cataclismo":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"defensa", escala2:1.0, base_fija:0,
                       mult_poder:2.0, penetracion:1.0, esencia_gen:20, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "furia_continental":  // Daño + buff de defensa
        {
            var _p = { stat1:"ataque", escala1:2.5, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:25, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.defensa_bonus_temp += round(_atacante.defensa_base * 0.6);
        }
        break;

        // ── SOMBRA R1: Filo Sombrio ──
        case "tajo_umbral":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:0.5, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:10, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        // ── SOMBRA R2: Guadana Penumbral ──
        case "siega_oscura":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:0.8, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:12, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "drenar_alma":  // Robo de vida basado en % HP del defensor (especial)
        {
            var robo = round(_defensor.vida_actual * 0.12);
            _defensor.vida_actual = max(0, _defensor.vida_actual - robo);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + robo);
            _atacante.esencia = clamp(_atacante.esencia + 10, 0, _atacante.esencia_llena);
        }
        break;

        // ── SOMBRA R3: Espada del Abismo ──
        case "noche_eterna":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:1.5, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:18, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "eclipse_total":  // Robo de vida basado en % HP del defensor (especial)
        {
            var robo = round(_defensor.vida_actual * 0.20);
            _defensor.vida_actual = max(0, _defensor.vida_actual - robo);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + round(robo * 0.7));
            _atacante.esencia = clamp(_atacante.esencia + 25, 0, _atacante.esencia_llena);
        }
        break;

        // ── LUZ R1: Espadin Aureo ──
        case "hoja_radiante":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:0.4, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:10, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        // ── LUZ R2: Lanza Solar ──
        case "embestida_solar":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:0.7, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:12, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "bendicion_luz":  // Curación pura
        {
            var _p = { stat1:"poder", escala1:1.0, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, esencia_gen:8, es_arma:true };
            var cura = scr_formula_beneficio(_atacante, _p);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + cura);
        }
        break;

        // ── LUZ R3: Hoja de la Aurora ──
        case "amanecer_divino":  // Daño + autocuración 20 % del daño
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:1.5, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:18, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + round(dano * 0.2));
        }
        break;

        case "juicio_celestial":  // Daño fuerte + curación aparte
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:1.0, base_fija:0,
                       mult_poder:2.0, penetracion:1.0, esencia_gen:25, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            // Curación extra (poder×0.8)
            var _pc = { stat1:"poder", escala1:0.8, stat2:"ninguno", escala2:0, base_fija:0,
                        mult_poder:1.0, esencia_gen:0, es_arma:true };
            var cura = scr_formula_beneficio(_atacante, _pc);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + cura);
        }
        break;

        // ── ARCANO R1: Vara Runica ──
        case "pulso_runico":
        {
            var _p = { stat1:"poder", escala1:0.8, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:12, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        // ── ARCANO R2: Espada Arcana ──
        case "corte_arcano":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:0.7, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:12, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "onda_arcana":
        {
            var _p = { stat1:"poder", escala1:1.2, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:15, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        // ── ARCANO R3: Baston del Primer Conductor ──
        case "singularidad_arcana":
        {
            var _p = { stat1:"poder", escala1:2.0, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:20, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "ruptura_dimensional":
        {
            var _p = { stat1:"poder", escala1:2.5, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:30, es_arma:true };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        // ==========================================================
        //  2.  H A B I L I D A D E S   D E   C L A S E
        //      es_arma = false → afinidad del PERSONAJE
        // ==========================================================

        case "golpe_guardia": // Vanguardia
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"defensa", escala2:1.5, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:15, es_arma:false };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "corte_rapido": // Filotormenta
        {
            var _p = { stat1:"ataque", escala1:0.7, stat2:"velocidad", escala2:0.6, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:8, es_arma:false };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "impacto_tectonico": // Quebrador
        {
            var _p = { stat1:"ataque", escala1:2.5, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:5, es_arma:false };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "baluarte_ferreo": // Centinela — curación defensiva
        {
            var _p = { stat1:"defensa", escala1:2.0, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, esencia_gen:5, es_arma:false };
            var cura = scr_formula_beneficio(_atacante, _p);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + cura);
            show_debug_message(_atacante.nombre + " se fortalece y recupera " + string(cura) + " vida.");
        }
        break;

        case "estocada_critica": // Duelista
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"velocidad", escala2:1.0, base_fija:0,
                       mult_poder:1.2, penetracion:1.0, esencia_gen:15, es_arma:false };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "descarga_esencia": // Canalizador
        {
            var _p = { stat1:"poder", escala1:2.5, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:0.5, esencia_gen:0, es_arma:false };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        // ==========================================================
        //  3.  E N E M I G O S   C O M U N E S
        //      es_arma = false → afinidad del ENEMIGO
        // ==========================================================

        case "golpe_fuego": // Soldado Igneo
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"ninguno", escala2:0, base_fija:4,
                       mult_poder:1.0, penetracion:0, esencia_gen:0, es_arma:false };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "mirada_gelida": // Vigia Boreal
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"ninguno", escala2:0, base_fija:2,
                       mult_poder:1.0, penetracion:0, esencia_gen:0, es_arma:false };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "rafaga_cortante": // Halito Verde
        {
            var _p = { stat1:"ataque", escala1:1.3, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:0, es_arma:false };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "chispazo": // Bestia Tronadora
        {
            var _p = { stat1:"ninguno", escala1:0, stat2:"ninguno", escala2:0, base_fija:12,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:0, es_arma:false };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "muro_piedra": // Guardian Terracota — autocuración
        {
            var _p = { stat1:"ninguno", escala1:0, stat2:"ninguno", escala2:0, base_fija:15,
                       mult_poder:1.0, esencia_gen:0, es_arma:false };
            var cura = scr_formula_beneficio(_atacante, _p);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + cura);
        }
        break;

        case "abrazo_vacio": // Naufrago — robo de vida plano
        {
            var _p = { stat1:"ninguno", escala1:0, stat2:"ninguno", escala2:0, base_fija:10,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:0, es_arma:false };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + dano);
        }
        break;

        case "destello_debil": // Paladin Marchito
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:0, es_arma:false };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "pulso_arcano": // Errante Runico
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"ninguno", escala2:0, base_fija:8,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:0, es_arma:false };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        // ==========================================================
        //  4.  E N E M I G O S   É L I T E
        // ==========================================================

        case "pilar_llama":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"ninguno", escala2:0, base_fija:10,
                       mult_poder:1.2, penetracion:0.5, esencia_gen:0, es_arma:false };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "prision_glaciar":
        {
            var _p = { stat1:"ataque", escala1:0.8, stat2:"ninguno", escala2:0, base_fija:8,
                       mult_poder:1.1, penetracion:0.5, esencia_gen:0, es_arma:false };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "tornado_esmeralda":
        {
            var _p = { stat1:"ataque", escala1:1.2, stat2:"ninguno", escala2:0, base_fija:10,
                       mult_poder:1.2, penetracion:0.5, esencia_gen:0, es_arma:false };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "tormenta_electrica":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"ninguno", escala2:0, base_fija:8,
                       mult_poder:1.15, penetracion:0.5, esencia_gen:0, es_arma:false };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "terremoto":
        {
            var _p = { stat1:"ataque", escala1:1.3, stat2:"ninguno", escala2:0, base_fija:12,
                       mult_poder:1.2, penetracion:0.5, esencia_gen:0, es_arma:false };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "agujero_negro":  // % de vida del defensor (especial)
        {
            var robo = round(_defensor.vida_actual * 0.25);
            _defensor.vida_actual = max(0, _defensor.vida_actual - robo);
        }
        break;

        case "juicio_sagrado":
        {
            var _p = { stat1:"ataque", escala1:1.5, stat2:"ninguno", escala2:0, base_fija:15,
                       mult_poder:1.2, penetracion:0.5, esencia_gen:0, es_arma:false };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "cometa_runico":
        {
            var _p = { stat1:"ataque", escala1:1.5, stat2:"ninguno", escala2:0, base_fija:18,
                       mult_poder:1.25, penetracion:0.5, esencia_gen:0, es_arma:false };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        // ==========================================================
        //  5.  J E F E S
        // ==========================================================

        case "erupcion_forjada": // Titan de las Forjas Rotas (Fuego+Tierra)
        {
            var _p = { stat1:"ataque", escala1:2.0, stat2:"ninguno", escala2:0, base_fija:15,
                       mult_poder:1.3, penetracion:0.5, esencia_gen:0, es_arma:false };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            // Autocuración
            var _pc = { stat1:"ninguno", escala1:0, stat2:"ninguno", escala2:0, base_fija:30,
                        mult_poder:1.0, esencia_gen:0, es_arma:false };
            var cura = scr_formula_beneficio(_atacante, _pc);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + cura);
            show_debug_message("¡EL TITÁN GOLPEA CON FUERZA BRUTA!");
        }
        break;

        case "maremoto_vegetal": // Coloso del Fango Viviente (Agua+Planta)
        {
            var _p = { stat1:"ataque", escala1:1.8, stat2:"ninguno", escala2:0, base_fija:12,
                       mult_poder:1.2, penetracion:0.5, esencia_gen:0, es_arma:false };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            var _pc = { stat1:"ninguno", escala1:0, stat2:"ninguno", escala2:0, base_fija:20,
                        mult_poder:1.0, esencia_gen:0, es_arma:false };
            var cura = scr_formula_beneficio(_atacante, _pc);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + cura);
            show_debug_message("¡EL COLOSO DESATA UN MAREMOTO VEGETAL!");
        }
        break;

        case "fulgor_celestial": // Sentinela del Cielo Roto (Rayo+Luz)
        {
            var _p = { stat1:"ataque", escala1:2.2, stat2:"ninguno", escala2:0, base_fija:18,
                       mult_poder:1.3, penetracion:0.5, esencia_gen:0, es_arma:false };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            show_debug_message("¡LA SENTINELA DESATA UN FULGOR CELESTIAL!");
        }
        break;

        case "vacio_runico": // Oraculo Quebrado del Abismo (Sombra+Arcano) — % HP
        {
            var robo = round(_defensor.vida_actual * 0.20);
            _defensor.vida_actual = max(0, _defensor.vida_actual - robo);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + round(robo * 0.5));
            show_debug_message("¡EL ORÁCULO INVOCA EL VACÍO RÚNICO!");
        }
        break;

        default:
            show_debug_message("Habilidad no implementada: " + string(_id));
        break;
    }
}