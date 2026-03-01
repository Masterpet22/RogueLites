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
                       mult_poder:1.0, penetracion:0, esencia_gen:10, es_arma:true, tipo_dano:"fisico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            scr_activar_pasiva_afinidad(_defensor, "recibir_dano");
        }
        break;

        // ── FUEGO R1: Filo Igneo ──
        case "ataque_fuego_basico":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:0.5, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:10, es_arma:true, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            scr_aplicar_estado(_defensor, "quemadura_fuego", round(GAME_FPS * 3), round(_atacante.poder_elemental * 0.2));
        }
        break;

        // ── FUEGO R2: Mandoble Carmesi ──
        case "ataque_fuego_mejorado":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:0.8, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:12, es_arma:true, tipo_dano:"fisico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            scr_aplicar_estado(_defensor, "quemadura_fuego", round(GAME_FPS * 3), round(_atacante.poder_elemental * 0.3));
        }
        break;

        case "explosion_carmesi":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:1.2, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:20, es_arma:true, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            scr_aplicar_estado(_defensor, "quemadura_fuego", round(GAME_FPS * 4), round(_atacante.poder_elemental * 0.4));
        }
        break;

        // ── FUEGO R3: Espada Solar del Titan ──
        case "llamarada_solar":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:1.5, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:15, es_arma:true, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            scr_aplicar_estado(_defensor, "quemadura_fuego", round(GAME_FPS * 5), round(_atacante.poder_elemental * 0.5));
        }
        break;

        case "furia_del_titan":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:1.0, base_fija:0,
                       mult_poder:2.0, penetracion:1.0, esencia_gen:25, es_arma:true, tipo_dano:"fisico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        // ── AGUA R1: Hoja Coral ──
        case "corte_glaciar":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:0.4, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:10, es_arma:true, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            // Ralentización al enemigo (3s)
            scr_aplicar_estado(_defensor, "ralentizacion", round(GAME_FPS * 3), 0);
        }
        break;

        // ── AGUA R2: Tridente Abisal ──
        case "lanza_marina":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:0.7, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:12, es_arma:true, tipo_dano:"fisico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "corriente_abisal":  // Daño + autocuración 30 % + regeneración
        {
            var _p = { stat1:"poder", escala1:1.0, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:8, es_arma:true, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + round(dano * 0.3));
            // Regeneración al usuario (3s, potencia extra basada en poder×0.2)
            scr_aplicar_estado(_atacante, "regeneracion", round(GAME_FPS * 3), round(_atacante.poder_elemental * 0.2));
        }
        break;

        // ── AGUA R3: Lanza del Maremoto ──
        case "tsunami":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:1.4, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:18, es_arma:true, tipo_dano:"fisico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            // Ralentización al enemigo (4s)
            scr_aplicar_estado(_defensor, "ralentizacion", round(GAME_FPS * 4), 0);
        }
        break;

        case "diluvio_eterno":  // Daño + autocuración 40 %
        {
            var _p = { stat1:"poder", escala1:2.0, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:20, es_arma:true, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + round(dano * 0.4));
        }
        break;

        // ── PLANTA R1: Vara Espinosa ──
        case "latigazo_espina":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:0.4, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:10, es_arma:true, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            // Veneno al enemigo (3s, potencia extra basada en poder×0.2)
            scr_aplicar_estado(_defensor, "veneno", round(GAME_FPS * 3), round(_atacante.poder_elemental * 0.2));
        }
        break;

        // ── PLANTA R2: Latigo de Cepa ──
        case "enredadera_voraz":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:0.6, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:10, es_arma:true, tipo_dano:"fisico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            // Veneno al enemigo (4s, potencia extra basada en poder×0.3)
            scr_aplicar_estado(_defensor, "veneno", round(GAME_FPS * 4), round(_atacante.poder_elemental * 0.3));
        }
        break;

        case "drenaje_vital":  // Daño + autocuración 50 %
        {
            var _p = { stat1:"poder", escala1:0.8, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:8, es_arma:true, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + round(dano * 0.5));
        }
        break;

        // ── PLANTA R3: Cetro del Bosque Primigenio ──
        case "explosion_espora":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:1.3, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:15, es_arma:true, tipo_dano:"fisico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "selva_eterna":  // Daño + autocuración 60 %
        {
            var _p = { stat1:"poder", escala1:1.8, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:20, es_arma:true, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + round(dano * 0.6));
        }
        break;

        // ── RAYO R1: Daga Voltaica ──
        case "descarga_rapida":
        {
            var _p = { stat1:"ataque", escala1:0.8, stat2:"poder", escala2:0.5, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:12, es_arma:true, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            // Aceleración al usuario (3s)
            scr_aplicar_estado(_atacante, "aceleracion_rayo", round(GAME_FPS * 3), 0);
        }
        break;

        // ── RAYO R2: Garras del Relampago ──
        case "cadena_electrica":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:0.7, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:12, es_arma:true, tipo_dano:"fisico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            // Aceleración al usuario (4s)
            scr_aplicar_estado(_atacante, "aceleracion_rayo", round(GAME_FPS * 4), 0);
        }
        break;

        case "tormenta_fugaz":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:1.0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:15, es_arma:true, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        // ── RAYO R3: Espada del Trueno Eterno ──
        case "rayo_fulminante":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:1.5, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:18, es_arma:true, tipo_dano:"fisico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "juicio_relampago":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:1.0, base_fija:0,
                       mult_poder:2.0, penetracion:1.0, esencia_gen:25, es_arma:true, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        // ── TIERRA R1: Mazo Petreo ──
        case "golpe_sismico":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"defensa", escala2:0.5, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:10, es_arma:true, tipo_dano:"fisico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        // ── TIERRA R2: Garrote de Roca Viva ──
        case "avalancha":
        {
            var _p = { stat1:"ataque", escala1:1.8, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:12, es_arma:true, tipo_dano:"fisico" };
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
                       mult_poder:2.0, penetracion:1.0, esencia_gen:20, es_arma:true, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "furia_continental":  // Daño + buff de defensa
        {
            var _p = { stat1:"ataque", escala1:2.5, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:25, es_arma:true, tipo_dano:"fisico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.defensa_bonus_temp += round(_atacante.defensa_base * 0.6);
        }
        break;

        // ── SOMBRA R1: Filo Sombrio ──
        case "tajo_umbral":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:0.5, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:10, es_arma:true, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            // Vulnerabilidad al enemigo (3s)
            scr_aplicar_estado(_defensor, "vulnerabilidad", round(GAME_FPS * 3), 0);
        }
        break;

        // ── SOMBRA R2: Guadana Penumbral ──
        case "siega_oscura":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:0.8, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:12, es_arma:true, tipo_dano:"fisico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            // Vulnerabilidad al enemigo (4s)
            scr_aplicar_estado(_defensor, "vulnerabilidad", round(GAME_FPS * 4), 0);
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
                       mult_poder:1.0, penetracion:0, esencia_gen:18, es_arma:true, tipo_dano:"fisico" };
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
                       mult_poder:1.0, penetracion:0, esencia_gen:10, es_arma:true, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        // ── LUZ R2: Lanza Solar ──
        case "embestida_solar":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:0.7, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:12, es_arma:true, tipo_dano:"fisico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "bendicion_luz":  // Curación pura + regeneración
        {
            var _p = { stat1:"poder", escala1:1.0, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, esencia_gen:8, es_arma:true };
            var cura = scr_formula_beneficio(_atacante, _p);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + cura);
            // Regeneración al usuario (4s, potencia extra basada en poder×0.3)
            scr_aplicar_estado(_atacante, "regeneracion", round(GAME_FPS * 4), round(_atacante.poder_elemental * 0.3));
        }
        break;

        // ── LUZ R3: Hoja de la Aurora ──
        case "amanecer_divino":  // Daño + autocuración 20 % del daño
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:1.5, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:18, es_arma:true, tipo_dano:"fisico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + round(dano * 0.2));
        }
        break;

        case "juicio_celestial":  // Daño fuerte + curación aparte
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:1.0, base_fija:0,
                       mult_poder:2.0, penetracion:1.0, esencia_gen:25, es_arma:true, tipo_dano:"magico" };
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
                       mult_poder:1.0, penetracion:1.0, esencia_gen:12, es_arma:true, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            // Supresión arcana al enemigo (3s)
            scr_aplicar_estado(_defensor, "supresion_arcana", round(GAME_FPS * 3), 0);
        }
        break;

        // ── ARCANO R2: Espada Arcana ──
        case "corte_arcano":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"poder", escala2:0.7, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:12, es_arma:true, tipo_dano:"fisico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "onda_arcana":
        {
            var _p = { stat1:"poder", escala1:1.2, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:15, es_arma:true, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            // Supresión arcana al enemigo (4s)
            scr_aplicar_estado(_defensor, "supresion_arcana", round(GAME_FPS * 4), 0);
        }
        break;

        // ── ARCANO R3: Baston del Primer Conductor ──
        case "singularidad_arcana":
        {
            var _p = { stat1:"poder", escala1:2.0, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:20, es_arma:true, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "ruptura_dimensional":
        {
            var _p = { stat1:"poder", escala1:2.5, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:30, es_arma:true, tipo_dano:"fisico" };
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
                       mult_poder:1.0, penetracion:0, esencia_gen:15, es_arma:false, tipo_dano:"fisico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "corte_rapido": // Filotormenta
        {
            var _p = { stat1:"ataque", escala1:0.7, stat2:"velocidad", escala2:0.6, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:8, es_arma:false, tipo_dano:"fisico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "impacto_tectonico": // Quebrador
        {
            var _p = { stat1:"ataque", escala1:2.5, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:5, es_arma:false, tipo_dano:"fisico" };
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
                       mult_poder:1.2, penetracion:1.0, esencia_gen:15, es_arma:false, tipo_dano:"fisico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "descarga_esencia": // Canalizador
        {
            var _p = { stat1:"poder", escala1:2.5, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:0.5, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
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
                       mult_poder:1.0, penetracion:0, esencia_gen:0, es_arma:false, tipo_dano:"fisico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "mirada_gelida": // Vigia Boreal
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"ninguno", escala2:0, base_fija:2,
                       mult_poder:1.0, penetracion:0, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "rafaga_cortante": // Halito Verde
        {
            var _p = { stat1:"ataque", escala1:1.3, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:0, es_arma:false, tipo_dano:"fisico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "chispazo": // Bestia Tronadora
        {
            var _p = { stat1:"ninguno", escala1:0, stat2:"ninguno", escala2:0, base_fija:12,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
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
                       mult_poder:1.0, penetracion:1.0, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + dano);
        }
        break;

        case "destello_debil": // Paladin Marchito
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"ninguno", escala2:0, base_fija:0,
                       mult_poder:1.0, penetracion:0, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "pulso_arcano": // Errante Runico
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"ninguno", escala2:0, base_fija:8,
                       mult_poder:1.0, penetracion:1.0, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
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
                       mult_poder:1.2, penetracion:0.5, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "prision_glaciar":
        {
            var _p = { stat1:"ataque", escala1:0.8, stat2:"ninguno", escala2:0, base_fija:8,
                       mult_poder:1.1, penetracion:0.5, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "tornado_esmeralda":
        {
            var _p = { stat1:"ataque", escala1:1.2, stat2:"ninguno", escala2:0, base_fija:10,
                       mult_poder:1.2, penetracion:0.5, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "tormenta_electrica":
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"ninguno", escala2:0, base_fija:8,
                       mult_poder:1.15, penetracion:0.5, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "terremoto":
        {
            var _p = { stat1:"ataque", escala1:1.3, stat2:"ninguno", escala2:0, base_fija:12,
                       mult_poder:1.2, penetracion:0.5, esencia_gen:0, es_arma:false, tipo_dano:"fisico" };
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
                       mult_poder:1.2, penetracion:0.5, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        case "cometa_runico":
        {
            var _p = { stat1:"ataque", escala1:1.5, stat2:"ninguno", escala2:0, base_fija:18,
                       mult_poder:1.25, penetracion:0.5, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
        }
        break;

        // ==========================================================
        //  4b. S E C U N D A R I A S   É L I T E  (con estados)
        // ==========================================================

        case "llamarada_furia":  // Soldado Igneo Elite — Daño + quemadura
        {
            var _p = { stat1:"ataque", escala1:0.6, stat2:"ninguno", escala2:0, base_fija:5,
                       mult_poder:1.0, penetracion:0, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            scr_aplicar_estado(_defensor, "quemadura_fuego", round(GAME_FPS * 4), round(_atacante.poder_elemental * 0.3));
        }
        break;

        case "ventisca_polar":  // Vigia Boreal Elite — Daño + ralentización
        {
            var _p = { stat1:"ataque", escala1:0.5, stat2:"ninguno", escala2:0, base_fija:4,
                       mult_poder:1.0, penetracion:0, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            scr_aplicar_estado(_defensor, "ralentizacion", round(GAME_FPS * 3), 0);
        }
        break;

        case "esporas_toxicas":  // Halito Verde Elite — Daño + veneno
        {
            var _p = { stat1:"ataque", escala1:0.5, stat2:"ninguno", escala2:0, base_fija:3,
                       mult_poder:1.0, penetracion:0, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            scr_aplicar_estado(_defensor, "veneno", round(GAME_FPS * 4), round(_atacante.poder_elemental * 0.2));
        }
        break;

        case "impulso_voltaico":  // Bestia Tronadora Elite — Daño + auto-aceleración
        {
            var _p = { stat1:"ataque", escala1:0.6, stat2:"ninguno", escala2:0, base_fija:5,
                       mult_poder:1.0, penetracion:0.5, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            scr_aplicar_estado(_atacante, "aceleracion_rayo", round(GAME_FPS * 4), 0);
        }
        break;

        case "fortaleza_petrea":  // Guardian Terracota Elite — Curación + muro_tierra
        {
            var _p = { stat1:"ninguno", escala1:0, stat2:"ninguno", escala2:0, base_fija:20,
                       mult_poder:1.0, esencia_gen:0, es_arma:false };
            var cura = scr_formula_beneficio(_atacante, _p);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + cura);
            scr_aplicar_estado(_atacante, "muro_tierra", round(GAME_FPS * 4), 0);
        }
        break;

        case "marca_sombria":  // Naufrago Elite — Daño + vulnerabilidad
        {
            var _p = { stat1:"ataque", escala1:0.5, stat2:"ninguno", escala2:0, base_fija:5,
                       mult_poder:1.0, penetracion:0, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            scr_aplicar_estado(_defensor, "vulnerabilidad", round(GAME_FPS * 4), 0);
        }
        break;

        case "plegaria_marchita":  // Paladin Marchito Elite — Curación + regeneración
        {
            var _p = { stat1:"ninguno", escala1:0, stat2:"ninguno", escala2:0, base_fija:15,
                       mult_poder:1.0, esencia_gen:0, es_arma:false };
            var cura = scr_formula_beneficio(_atacante, _p);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + cura);
            scr_aplicar_estado(_atacante, "regeneracion", round(GAME_FPS * 4), round(_atacante.poder_elemental * 0.3));
        }
        break;

        case "sello_arcano":  // Errante Runico Elite — Daño + supresión arcana
        {
            var _p = { stat1:"ataque", escala1:0.6, stat2:"ninguno", escala2:0, base_fija:8,
                       mult_poder:1.0, penetracion:0.5, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            scr_aplicar_estado(_defensor, "supresion_arcana", round(GAME_FPS * 4), 0);
        }
        break;

        // ==========================================================
        //  5.  J E F E S
        // ==========================================================

        // ──────────────────────────────────────────────────
        //  TITÁN DE LAS FORJAS ROTAS  (Fuego + Tierra)
        // ──────────────────────────────────────────────────

        case "erupcion_forjada": // Nuke principal — Daño fuerte + autocuración
        {
            var _p = { stat1:"ataque", escala1:2.0, stat2:"ninguno", escala2:0, base_fija:15,
                       mult_poder:1.3, penetracion:0.5, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            var _pc = { stat1:"ninguno", escala1:0, stat2:"ninguno", escala2:0, base_fija:30,
                        mult_poder:1.0, esencia_gen:0, es_arma:false };
            var cura = scr_formula_beneficio(_atacante, _pc);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + cura);
            show_debug_message("🔥🪨 TITÁN — Erupción Forjada");
        }
        break;

        case "martillo_incandescente": // Bread & butter — Físico + quemadura
        {
            var _p = { stat1:"ataque", escala1:1.5, stat2:"ninguno", escala2:0, base_fija:10,
                       mult_poder:1.1, penetracion:0.3, esencia_gen:0, es_arma:false, tipo_dano:"fisico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            scr_aplicar_estado(_defensor, "quemadura_fuego", round(GAME_FPS * 3), round(_atacante.poder_elemental * 0.3));
            show_debug_message("🔥🪨 TITÁN — Martillo Incandescente");
        }
        break;

        case "muro_magmatico": // Defensiva — Curación + muro_tierra
        {
            var _pc = { stat1:"defensa", escala1:1.0, stat2:"ninguno", escala2:0, base_fija:25,
                        mult_poder:1.0, esencia_gen:0, es_arma:false };
            var cura = scr_formula_beneficio(_atacante, _pc);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + cura);
            scr_aplicar_estado(_atacante, "muro_tierra", round(GAME_FPS * 5), 0);
            show_debug_message("🔥🪨 TITÁN — Muro Magmático");
        }
        break;

        case "cataclismo_forjado": // Ultimate — Daño máximo + vulnerabilidad
        {
            var _p = { stat1:"ataque", escala1:2.5, stat2:"ninguno", escala2:0, base_fija:20,
                       mult_poder:1.5, penetracion:0.8, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            scr_aplicar_estado(_defensor, "vulnerabilidad", round(GAME_FPS * 3), 0);
            show_debug_message("🔥🪨 TITÁN — ¡¡CATACLISMO FORJADO!!");
        }
        break;

        // ──────────────────────────────────────────────────
        //  COLOSO DEL FANGO VIVIENTE  (Agua + Planta)
        // ──────────────────────────────────────────────────

        case "maremoto_vegetal": // Nuke principal — Daño + autocuración
        {
            var _p = { stat1:"ataque", escala1:1.8, stat2:"ninguno", escala2:0, base_fija:12,
                       mult_poder:1.2, penetracion:0.5, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            var _pc = { stat1:"ninguno", escala1:0, stat2:"ninguno", escala2:0, base_fija:20,
                        mult_poder:1.0, esencia_gen:0, es_arma:false };
            var cura = scr_formula_beneficio(_atacante, _pc);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + cura);
            show_debug_message("🌊🌿 COLOSO — Maremoto Vegetal");
        }
        break;

        case "torrente_fangoso": // Debuff — Daño + ralentización
        {
            var _p = { stat1:"ataque", escala1:1.2, stat2:"ninguno", escala2:0, base_fija:8,
                       mult_poder:1.1, penetracion:0.3, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            scr_aplicar_estado(_defensor, "ralentizacion", round(GAME_FPS * 3), 0);
            show_debug_message("🌊🌿 COLOSO — Torrente Fangoso");
        }
        break;

        case "esporas_regenerativas": // Curación pura — Gran heal + regeneración
        {
            var _pc = { stat1:"ninguno", escala1:0, stat2:"ninguno", escala2:0, base_fija:40,
                        mult_poder:1.0, esencia_gen:0, es_arma:false };
            var cura = scr_formula_beneficio(_atacante, _pc);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + cura);
            scr_aplicar_estado(_atacante, "regeneracion", round(GAME_FPS * 4), round(_atacante.poder_elemental * 0.4));
            show_debug_message("🌊🌿 COLOSO — Esporas Regenerativas");
        }
        break;

        case "aplastamiento_pantano": // Ultimate — Daño físico devastador
        {
            var _p = { stat1:"ataque", escala1:2.5, stat2:"defensa", escala2:0.5, base_fija:15,
                       mult_poder:1.3, penetracion:0.8, esencia_gen:0, es_arma:false, tipo_dano:"fisico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            show_debug_message("🌊🌿 COLOSO — ¡¡APLASTAMIENTO PANTANO!!");
        }
        break;

        // ──────────────────────────────────────────────────
        //  SENTINELA DEL CIELO ROTO  (Rayo + Luz)
        // ──────────────────────────────────────────────────

        case "fulgor_celestial": // Nuke principal — Daño mágico fuerte
        {
            var _p = { stat1:"ataque", escala1:2.2, stat2:"ninguno", escala2:0, base_fija:18,
                       mult_poder:1.3, penetracion:0.5, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            show_debug_message("⚡✨ SENTINELA — Fulgor Celestial");
        }
        break;

        case "relampago_sagrado": // Rápido — Daño + auto-aceleración
        {
            var _p = { stat1:"ataque", escala1:1.3, stat2:"ninguno", escala2:0, base_fija:10,
                       mult_poder:1.1, penetracion:0.3, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            scr_aplicar_estado(_atacante, "aceleracion_rayo", round(GAME_FPS * 3), 0);
            show_debug_message("⚡✨ SENTINELA — Relámpago Sagrado");
        }
        break;

        case "destello_purificador": // Anti-buff — Daño + purga estados positivos del defensor
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"ninguno", escala2:0, base_fija:12,
                       mult_poder:1.2, penetracion:0.5, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            // Purga: eliminar buffs positivos del jugador
            var _estados = _defensor.estados;
            var _limpios = [];
            for (var _i = 0; _i < array_length(_estados); _i++) {
                var _tipo = _estados[_i].tipo;
                // Mantener solo debuffs y DoTs, eliminar buffs
                if (_tipo != "buff_defensa" && _tipo != "buff_velocidad" && _tipo != "hot") {
                    array_push(_limpios, _estados[_i]);
                }
            }
            _defensor.estados = _limpios;
            _defensor.defensa_bonus_temp = 0;
            show_debug_message("⚡✨ SENTINELA — Destello Purificador (buffs purgados)");
        }
        break;

        case "tormenta_divina": // Ultimate — Daño máximo con penetración total
        {
            var _p = { stat1:"ataque", escala1:2.8, stat2:"ninguno", escala2:0, base_fija:22,
                       mult_poder:1.5, penetracion:1.0, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            show_debug_message("⚡✨ SENTINELA — ¡¡TORMENTA DIVINA!!");
        }
        break;

        // ──────────────────────────────────────────────────
        //  ORÁCULO QUEBRADO DEL ABISMO  (Sombra + Arcano)
        // ──────────────────────────────────────────────────

        case "vacio_runico": // Signature — %HP drain + self-heal
        {
            var robo = round(_defensor.vida_actual * 0.20);
            _defensor.vida_actual = max(0, _defensor.vida_actual - robo);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + round(robo * 0.5));
            show_debug_message("🌑🔮 ORÁCULO — Vacío Rúnico");
        }
        break;

        case "pulso_abismal": // Debuff — Daño arcano + supresión arcana
        {
            var _p = { stat1:"ataque", escala1:1.5, stat2:"ninguno", escala2:0, base_fija:12,
                       mult_poder:1.2, penetracion:0.5, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            scr_aplicar_estado(_defensor, "supresion_arcana", round(GAME_FPS * 4), 0);
            show_debug_message("🌑🔮 ORÁCULO — Pulso Abismal");
        }
        break;

        case "sifon_sombrio": // Resource denial — Daño + drena esencia del jugador
        {
            var _p = { stat1:"ataque", escala1:1.0, stat2:"ninguno", escala2:0, base_fija:8,
                       mult_poder:1.1, penetracion:0.3, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            // Drenar esencia del jugador
            var _drenado = min(_defensor.esencia, 15);
            _defensor.esencia = max(0, _defensor.esencia - _drenado);
            if (_drenado > 0) {
                scr_notif_agregar(_atacante.nombre, "Sifón: -" + string(_drenado) + " esencia", c_purple);
            }
            show_debug_message("🌑🔮 ORÁCULO — Sifón Sombrío (-" + string(_drenado) + " esencia)");
        }
        break;

        case "apocalipsis_runico": // Ultimate — Daño masivo + self-heal 40% del daño
        {
            var _p = { stat1:"ataque", escala1:2.5, stat2:"ninguno", escala2:0, base_fija:20,
                       mult_poder:1.5, penetracion:0.8, esencia_gen:0, es_arma:false, tipo_dano:"magico" };
            var dano = scr_formula_dano(_atacante, _defensor, _p);
            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
            _atacante.vida_actual = min(_atacante.vida_max, _atacante.vida_actual + round(dano * 0.4));
            show_debug_message("🌑🔮 ORÁCULO — ¡¡APOCALIPSIS RÚNICO!!");
        }
        break;

        default:
            show_debug_message("Habilidad no implementada: " + string(_id));
        break;
    }
}