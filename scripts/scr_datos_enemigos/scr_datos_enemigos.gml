/// @function scr_datos_enemigos(_e)
function scr_datos_enemigos(_e) {

    switch (_e) {
        
        // =============================================================
        // ENEMIGOS COMUNES — Drop principal (común) garantizado
        //                     Drop secundario (raro) con baja chance
        // =============================================================
        case "Soldado Igneo":
            return {
                vida: 130, ataque: 8, defensa: 4, defensa_magica: 5,
                velocidad: 4, poder_elemental: 5,
                afinidad: "Fuego",
                habilidad_fija: "golpe_fuego",
                habilidad_2: "chispa_ignea",
                habilidad_3: "escudo_ceniza",
                oro_min: 10, oro_max: 25,
                precio: 200,
                drops: [
                    { material: "Fragmento Igneo",   cant_min: 1, cant_max: 3, chance: 100 },
                    { material: "Brasa Carmesi",     cant_min: 1, cant_max: 1, chance: 12  },
                ]
            };

        case "Vigia Boreal":
            return {
                vida: 115, ataque: 6, defensa: 6, defensa_magica: 7,
                velocidad: 3, poder_elemental: 7,
                afinidad: "Agua",
                habilidad_fija: "mirada_gelida",
                habilidad_2: "oleaje_menor",
                habilidad_3: "rocio_curativo",
                oro_min: 10, oro_max: 25,
                precio: 200,
                drops: [
                    { material: "Escama Glaciar",    cant_min: 1, cant_max: 3, chance: 100 },
                    { material: "Perla Abisal",      cant_min: 1, cant_max: 1, chance: 12  },
                ]
            };

        case "Halito Verde":
            return {
                vida: 100, ataque: 10, defensa: 3, defensa_magica: 4,
                velocidad: 6, poder_elemental: 4,
                afinidad: "Planta",
                habilidad_fija: "rafaga_cortante",
                habilidad_2: "espina_veloz",
                habilidad_3: "semilla_parasita",
                oro_min: 10, oro_max: 20,
                precio: 150,
                drops: [
                    { material: "Savia Espinosa",    cant_min: 1, cant_max: 3, chance: 100 },
                    { material: "Raiz Primigenia",   cant_min: 1, cant_max: 1, chance: 12  },
                ]
            };

        case "Bestia Tronadora":
            return {
                vida: 120, ataque: 12, defensa: 2, defensa_magica: 3,
                velocidad: 7, poder_elemental: 3,
                afinidad: "Rayo",
                habilidad_fija: "chispazo",
                habilidad_2: "arco_voltaico",
                habilidad_3: "aullido_electrico",
                oro_min: 12, oro_max: 28,
                precio: 200,
                drops: [
                    { material: "Chispa Voltica",    cant_min: 1, cant_max: 3, chance: 100 },
                    { material: "Colmillo de Rayo",  cant_min: 1, cant_max: 1, chance: 12  },
                ]
            };

        case "Guardian Terracota":
            return {
                vida: 170, ataque: 5, defensa: 12, defensa_magica: 5,
                velocidad: 2, poder_elemental: 3,
                afinidad: "Tierra",
                habilidad_fija: "muro_piedra",
                habilidad_2: "lanzar_rocas",
                habilidad_3: "temblor_menor",
                oro_min: 15, oro_max: 30,
                precio: 250,
                drops: [
                    { material: "Arcilla Ancestral", cant_min: 1, cant_max: 3, chance: 100 },
                    { material: "Ladrillo de Jade",  cant_min: 1, cant_max: 1, chance: 12  },
                ]
            };

        case "Naufrago de la Oscuridad":
            return {
                vida: 140, ataque: 9, defensa: 5, defensa_magica: 6,
                velocidad: 4, poder_elemental: 6,
                afinidad: "Sombra",
                habilidad_fija: "abrazo_vacio",
                habilidad_2: "sombra_fugaz",
                habilidad_3: "pulso_nocturno",
                oro_min: 12, oro_max: 25,
                precio: 200,
                drops: [
                    { material: "Fragmento Sombrio", cant_min: 1, cant_max: 3, chance: 100 },
                    { material: "Materia Oscura",    cant_min: 1, cant_max: 1, chance: 12  },
                ]
            };

        case "Paladin Marchito":
            return {
                vida: 155, ataque: 7, defensa: 9, defensa_magica: 9,
                velocidad: 3, poder_elemental: 5,
                afinidad: "Luz",
                habilidad_fija: "destello_debil",
                habilidad_2: "golpe_sagrado",
                habilidad_3: "aura_debilitante",
                oro_min: 15, oro_max: 30,
                precio: 250,
                drops: [
                    { material: "Polvo Sagrado",     cant_min: 1, cant_max: 3, chance: 100 },
                    { material: "Reliquia de Oro",   cant_min: 1, cant_max: 1, chance: 12  },
                ]
            };

        case "Errante Runico":
            return {
                vida: 135, ataque: 8, defensa: 7, defensa_magica: 8,
                velocidad: 4, poder_elemental: 8,
                afinidad: "Arcano",
                habilidad_fija: "pulso_arcano",
                habilidad_2: "distorsion_arcana",
                habilidad_3: "silencio_runico",
                oro_min: 12, oro_max: 28,
                precio: 200,
                drops: [
                    { material: "Runa Menor",        cant_min: 1, cant_max: 3, chance: 100 },
                    { material: "Runa Mayor",        cant_min: 1, cant_max: 1, chance: 12  },
                ]
            };


        // =============================================================
        // ENEMIGOS ELITE — Drop raro garantizado
        //                   Drop común de su afinidad con buena chance
        // =============================================================
        case "Soldado Igneo Elite":
            return {
                vida: 150, ataque: 12, defensa: 6, defensa_magica: 7,
                velocidad: 5, poder_elemental: 7,
                afinidad: "Fuego",
                habilidad_fija: "pilar_llama",
                habilidad_secundaria: "llamarada_furia",
                oro_min: 40, oro_max: 80,
                precio: 600,
                drops: [
                    { material: "Brasa Carmesi",     cant_min: 1, cant_max: 2, chance: 100 },
                    { material: "Fragmento Igneo",   cant_min: 2, cant_max: 4, chance: 60  },
                ]
            };

        case "Vigia Boreal Elite":
            return {
                vida: 130, ataque: 10, defensa: 8, defensa_magica: 10,
                velocidad: 4, poder_elemental: 9,
                afinidad: "Agua",
                habilidad_fija: "prision_glaciar",
                habilidad_secundaria: "ventisca_polar",
                oro_min: 40, oro_max: 75,
                precio: 600,
                drops: [
                    { material: "Perla Abisal",      cant_min: 1, cant_max: 2, chance: 100 },
                    { material: "Escama Glaciar",    cant_min: 2, cant_max: 4, chance: 60  },
                ]
            };

        case "Halito Verde Elite":
            return {
                vida: 110, ataque: 15, defensa: 4, defensa_magica: 5,
                velocidad: 7, poder_elemental: 6,
                afinidad: "Planta",
                habilidad_fija: "tornado_esmeralda",
                habilidad_secundaria: "esporas_toxicas",
                oro_min: 35, oro_max: 70,
                precio: 500,
                drops: [
                    { material: "Raiz Primigenia",   cant_min: 1, cant_max: 2, chance: 100 },
                    { material: "Savia Espinosa",    cant_min: 2, cant_max: 4, chance: 60  },
                ]
            };

        case "Bestia Tronadora Elite":
            return {
                vida: 140, ataque: 16, defensa: 3, defensa_magica: 4,
                velocidad: 8, poder_elemental: 5,
                afinidad: "Rayo",
                habilidad_fija: "tormenta_electrica",
                habilidad_secundaria: "impulso_voltaico",
                oro_min: 45, oro_max: 85,
                precio: 650,
                mecanicas: ["mec_penalizacion_repeticion"],
                timer_limite: 80,
                drops: [
                    { material: "Colmillo de Rayo",  cant_min: 1, cant_max: 2, chance: 100 },
                    { material: "Chispa Voltica",    cant_min: 2, cant_max: 4, chance: 60  },
                ]
            };

        case "Guardian Terracota Elite":
            return {
                vida: 200, ataque: 9, defensa: 15, defensa_magica: 7,
                velocidad: 3, poder_elemental: 5,
                afinidad: "Tierra",
                habilidad_fija: "terremoto",
                habilidad_secundaria: "fortaleza_petrea",
                oro_min: 50, oro_max: 90,
                precio: 700,
                mecanicas: ["mec_penalizacion_repeticion"],
                timer_limite: 110,
                drops: [
                    { material: "Ladrillo de Jade",  cant_min: 1, cant_max: 2, chance: 100 },
                    { material: "Arcilla Ancestral", cant_min: 2, cant_max: 4, chance: 60  },
                ]
            };

        case "Naufrago de la Oscuridad Elite":
            return {
                vida: 160, ataque: 13, defensa: 7, defensa_magica: 9,
                velocidad: 5, poder_elemental: 8,
                afinidad: "Sombra",
                habilidad_fija: "agujero_negro",
                habilidad_secundaria: "marca_sombria",
                oro_min: 45, oro_max: 80,
                precio: 600,
                mecanicas: ["mec_reflejo_diferido"],
                timer_limite: 95,
                drops: [
                    { material: "Materia Oscura",    cant_min: 1, cant_max: 2, chance: 100 },
                    { material: "Fragmento Sombrio", cant_min: 2, cant_max: 4, chance: 60  },
                ]
            };

        case "Paladin Marchito Elite":
            return {
                vida: 180, ataque: 11, defensa: 12, defensa_magica: 13,
                velocidad: 4, poder_elemental: 7,
                afinidad: "Luz",
                habilidad_fija: "juicio_sagrado",
                habilidad_secundaria: "plegaria_marchita",
                oro_min: 50, oro_max: 85,
                precio: 650,
                mecanicas: ["mec_escalado_vida_jugador"],
                timer_limite: 110,
                drops: [
                    { material: "Reliquia de Oro",   cant_min: 1, cant_max: 2, chance: 100 },
                    { material: "Polvo Sagrado",     cant_min: 2, cant_max: 4, chance: 60  },
                ]
            };

        case "Errante Runico Elite":
            return {
                vida: 150, ataque: 13, defensa: 10, defensa_magica: 12,
                velocidad: 5, poder_elemental: 10,
                afinidad: "Arcano",
                habilidad_fija: "cometa_runico",
                habilidad_secundaria: "sello_arcano",
                oro_min: 45, oro_max: 80,
                precio: 600,
                drops: [
                    { material: "Runa Mayor",        cant_min: 1, cant_max: 2, chance: 100 },
                    { material: "Runa Menor",        cant_min: 2, cant_max: 4, chance: 60  },
                ]
            };


        // =============================================================
        // JEFES — Drop único (legendario) garantizado
        //         Drop raro de ambas afinidades con buena chance
        // =============================================================
        case "Titan de las Forjas Rotas":
            return {
                vida: 1050, ataque: 22, defensa: 18, defensa_magica: 14,
                velocidad: 3, poder_elemental: 12,
                afinidad: "Fuego-Tierra",
                habilidad_fija: "erupcion_forjada",
                habilidad_2: "martillo_incandescente",
                habilidad_3: "muro_magmatico",
                habilidad_4: "cataclismo_forjado",
                patron: ["martillo_incandescente", "erupcion_forjada", "muro_magmatico",
                         "martillo_incandescente", "erupcion_forjada", "cataclismo_forjado"],
                oro_min: 200, oro_max: 400,
                precio: 2500,
                mecanicas: ["mec_ventana_invertida"],
                timer_limite: 200,
                drops: [
                    { material: "Nucleo de Forja Antigua",  cant_min: 1, cant_max: 1, chance: 100 },
                    { material: "Brasa Carmesi",            cant_min: 2, cant_max: 3, chance: 70  },
                    { material: "Ladrillo de Jade",         cant_min: 2, cant_max: 3, chance: 70  },
                ]
            };

        case "Coloso del Fango Viviente":
            return {
                vida: 1000, ataque: 18, defensa: 20, defensa_magica: 16,
                velocidad: 2, poder_elemental: 10,
                afinidad: "Agua-Planta",
                habilidad_fija: "maremoto_vegetal",
                habilidad_2: "torrente_fangoso",
                habilidad_3: "esporas_regenerativas",
                habilidad_4: "aplastamiento_pantano",
                patron: ["torrente_fangoso", "maremoto_vegetal", "esporas_regenerativas",
                         "torrente_fangoso", "maremoto_vegetal", "aplastamiento_pantano"],
                oro_min: 180, oro_max: 380,
                precio: 2500,
                mecanicas: ["mec_escalado_vida_jugador", "mec_penalizacion_repeticion"],
                timer_limite: 200,
                drops: [
                    { material: "Corazon de Fango",         cant_min: 1, cant_max: 1, chance: 100 },
                    { material: "Perla Abisal",             cant_min: 2, cant_max: 3, chance: 70  },
                    { material: "Raiz Primigenia",          cant_min: 2, cant_max: 3, chance: 70  },
                ]
            };

        case "Sentinela del Cielo Roto":
            return {
                vida: 900, ataque: 25, defensa: 14, defensa_magica: 11,
                velocidad: 6, poder_elemental: 15,
                afinidad: "Rayo-Luz",
                habilidad_fija: "fulgor_celestial",
                habilidad_2: "relampago_sagrado",
                habilidad_3: "destello_purificador",
                habilidad_4: "tormenta_divina",
                patron: ["relampago_sagrado", "relampago_sagrado", "fulgor_celestial",
                         "destello_purificador", "relampago_sagrado", "tormenta_divina"],
                oro_min: 220, oro_max: 450,
                precio: 3000,
                mecanicas: ["mec_afinidad_reactiva", "mec_reflejo_diferido"],
                timer_limite: 180,
                drops: [
                    { material: "Fragmento Celestial",      cant_min: 1, cant_max: 1, chance: 100 },
                    { material: "Colmillo de Rayo",         cant_min: 2, cant_max: 3, chance: 70  },
                    { material: "Reliquia de Oro",          cant_min: 2, cant_max: 3, chance: 70  },
                ]
            };

        case "Oraculo Quebrado del Abismo":
            return {
                vida: 1000, ataque: 21, defensa: 16, defensa_magica: 18,
                velocidad: 4, poder_elemental: 18,
                afinidad: "Sombra-Arcano",
                habilidad_fija: "vacio_runico",
                habilidad_2: "pulso_abismal",
                habilidad_3: "sifon_sombrio",
                habilidad_4: "apocalipsis_runico",
                patron: ["pulso_abismal", "vacio_runico", "sifon_sombrio",
                         "pulso_abismal", "vacio_runico", "apocalipsis_runico"],
                oro_min: 250, oro_max: 500,
                precio: 3500,
                mecanicas: ["mec_absorcion_esencia"],
                timer_limite: 200,
                drops: [
                    { material: "Cristal del Vacio",        cant_min: 1, cant_max: 1, chance: 100 },
                    { material: "Materia Oscura",           cant_min: 2, cant_max: 3, chance: 70  },
                    { material: "Runa Mayor",               cant_min: 2, cant_max: 3, chance: 70  },
                ]
            };

        // =============================================================
        // JEFE FINAL — El Devorador (sin afinidad)
        //   Roba esencia, desactiva pasivas, espejea al jugador
        // =============================================================

        // ── Nuevo Jefe: Heraldo de la Llama Negra (Fuego-Sombra) ──
        case "Heraldo de la Llama Negra":
            return {
                vida: 1100, ataque: 24, defensa: 15, defensa_magica: 16,
                velocidad: 5, poder_elemental: 16,
                afinidad: "Fuego-Sombra",
                habilidad_fija: "lanza_oscura",
                habilidad_2: "inmolacion_sombria",
                habilidad_3: "cortina_cenizas",
                habilidad_4: "pira_abismal",
                patron: ["lanza_oscura", "inmolacion_sombria", "lanza_oscura",
                         "cortina_cenizas", "inmolacion_sombria", "pira_abismal"],
                oro_min: 230, oro_max: 460,
                precio: 3000,
                mecanicas: ["mec_reflejo_diferido"],
                timer_limite: 190,
                drops: [
                    { material: "Ascua del Abismo",         cant_min: 1, cant_max: 1, chance: 100 },
                    { material: "Brasa Carmesi",            cant_min: 2, cant_max: 3, chance: 70  },
                    { material: "Materia Oscura",           cant_min: 2, cant_max: 3, chance: 70  },
                ]
            };

        // ── Nuevo Jefe: Leviatan Esporal (Planta-Rayo) ──
        case "Leviatan Esporal":
            return {
                vida: 950, ataque: 20, defensa: 17, defensa_magica: 15,
                velocidad: 4, poder_elemental: 14,
                afinidad: "Planta-Rayo",
                habilidad_fija: "latigo_electrico",
                habilidad_2: "descarga_esporal",
                habilidad_3: "barrera_fotovoltaica",
                habilidad_4: "genesis_esporal",
                patron: ["latigo_electrico", "descarga_esporal", "latigo_electrico",
                         "barrera_fotovoltaica", "descarga_esporal", "genesis_esporal"],
                oro_min: 210, oro_max: 430,
                precio: 2800,
                mecanicas: ["mec_penalizacion_repeticion", "mec_escalado_vida_jugador"],
                timer_limite: 195,
                drops: [
                    { material: "Semilla Voltaica",         cant_min: 1, cant_max: 1, chance: 100 },
                    { material: "Raiz Primigenia",          cant_min: 2, cant_max: 3, chance: 70  },
                    { material: "Colmillo de Rayo",         cant_min: 2, cant_max: 3, chance: 70  },
                ]
            };

        case "El Devorador":
            return {
                vida: 1350, ataque: 27, defensa: 20, defensa_magica: 20,
                velocidad: 5, poder_elemental: 20,
                afinidad: "Neutra",
                habilidad_fija: "mordida_vacia",
                habilidad_2: "pulso_devorador",
                habilidad_3: "espejo_voraz",
                habilidad_4: "consumo_absoluto",
                patron: ["mordida_vacia", "pulso_devorador", "mordida_vacia",
                         "espejo_voraz", "pulso_devorador", "consumo_absoluto"],
                oro_min: 400, oro_max: 800,
                precio: 5000,
                mecanicas: ["mec_robo_esencia_golpe", "mec_supresion_pasiva"],
                timer_limite: 240,
                drops: [
                    { material: "Esencia del Vacio",        cant_min: 1, cant_max: 1, chance: 100 },
                    { material: "Cristal del Vacio",        cant_min: 1, cant_max: 2, chance: 80  },
                    { material: "Runa Mayor",               cant_min: 2, cant_max: 3, chance: 70  },
                ]
            };

        // =============================================================
        // JEFE SECRETO — El Primer Conductor (sin afinidad visible)
        //   Imita clase del jugador, manipula esencia, HP ×1.80
        // =============================================================
        case "El Primer Conductor":
            return {
                vida: 1600, ataque: 30, defensa: 23, defensa_magica: 23,
                velocidad: 6, poder_elemental: 25,
                afinidad: "Neutra",
                habilidad_fija: "golpe_primordial",
                habilidad_2: "resonancia_conductor",
                habilidad_3: "armonia_invertida",
                habilidad_4: "genesis_final",
                patron: ["golpe_primordial", "resonancia_conductor", "golpe_primordial",
                         "armonia_invertida", "resonancia_conductor", "genesis_final"],
                oro_min: 600, oro_max: 1200,
                precio: 8000,
                mecanicas: ["mec_espejo_clase", "mec_escalado_vida_jugador"],
                timer_limite: 270,
                drops: [
                    { material: "Eco del Primer Conductor", cant_min: 1, cant_max: 1, chance: 100 },
                    { material: "Esencia del Vacio",        cant_min: 1, cant_max: 1, chance: 80  },
                    { material: "Nucleo de Forja Antigua",  cant_min: 1, cant_max: 1, chance: 50  },
                ]
            };

        default:
            show_error("Enemigo no encontrado: " + string(_e), true);
            return undefined;
    }
}