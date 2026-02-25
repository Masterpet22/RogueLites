/// scr_datos_armas(nombre_arma)
function scr_datos_armas(_arma) {

    switch (_arma) {

        // =====================================================================
        // ARMA INICIAL (sin receta, sin afinidad real)
        // =====================================================================
        case "Hoja Rota":
            return {
                afinidad: "none",
                rareza: 0,
                ataque_bonus: 0,
                poder_elemental_bonus: 0,
                habilidades_arma: ["ataque_basico"],
                receta: []
            };

        // =====================================================================
        // FUEGO
        // =====================================================================
        case "Filo Igneo":                    // R1
            return {
                afinidad: "Fuego", rareza: 1,
                ataque_bonus: 4, poder_elemental_bonus: 3,
                habilidades_arma: ["ataque_fuego_basico"],
                receta: [
                    { material: "Fragmento Igneo", cantidad: 5 }
                ]
            };

        case "Mandoble Carmesi":              // R2
            return {
                afinidad: "Fuego", rareza: 2,
                ataque_bonus: 8, poder_elemental_bonus: 6,
                habilidades_arma: ["ataque_fuego_mejorado", "explosion_carmesi"],
                receta: [
                    { material: "Fragmento Igneo", cantidad: 10 },
                    { material: "Brasa Carmesi",   cantidad: 3 }
                ]
            };

        case "Espada Solar del Titan":        // R3
            return {
                afinidad: "Fuego", rareza: 3,
                ataque_bonus: 14, poder_elemental_bonus: 10,
                habilidades_arma: ["llamarada_solar", "explosion_carmesi", "furia_del_titan"],
                receta: [
                    { material: "Brasa Carmesi",          cantidad: 5 },
                    { material: "Nucleo de Forja Antigua", cantidad: 1 }
                ]
            };

        // =====================================================================
        // AGUA
        // =====================================================================
        case "Hoja Coral":                    // R1
            return {
                afinidad: "Agua", rareza: 1,
                ataque_bonus: 3, poder_elemental_bonus: 4,
                habilidades_arma: ["corte_glaciar"],
                receta: [
                    { material: "Escama Glaciar", cantidad: 5 }
                ]
            };

        case "Tridente Abisal":               // R2
            return {
                afinidad: "Agua", rareza: 2,
                ataque_bonus: 7, poder_elemental_bonus: 7,
                habilidades_arma: ["lanza_marina", "corriente_abisal"],
                receta: [
                    { material: "Escama Glaciar", cantidad: 10 },
                    { material: "Perla Abisal",   cantidad: 3 }
                ]
            };

        case "Lanza del Maremoto":            // R3
            return {
                afinidad: "Agua", rareza: 3,
                ataque_bonus: 12, poder_elemental_bonus: 12,
                habilidades_arma: ["tsunami", "corriente_abisal", "diluvio_eterno"],
                receta: [
                    { material: "Perla Abisal",    cantidad: 5 },
                    { material: "Corazon de Fango", cantidad: 1 }
                ]
            };

        // =====================================================================
        // PLANTA
        // =====================================================================
        case "Vara Espinosa":                 // R1
            return {
                afinidad: "Planta", rareza: 1,
                ataque_bonus: 3, poder_elemental_bonus: 4,
                habilidades_arma: ["latigazo_espina"],
                receta: [
                    { material: "Savia Espinosa", cantidad: 5 }
                ]
            };

        case "Latigo de Cepa":                // R2
            return {
                afinidad: "Planta", rareza: 2,
                ataque_bonus: 6, poder_elemental_bonus: 8,
                habilidades_arma: ["enredadera_voraz", "drenaje_vital"],
                receta: [
                    { material: "Savia Espinosa",  cantidad: 10 },
                    { material: "Raiz Primigenia", cantidad: 3 }
                ]
            };

        case "Cetro del Bosque Primigenio":   // R3
            return {
                afinidad: "Planta", rareza: 3,
                ataque_bonus: 10, poder_elemental_bonus: 14,
                habilidades_arma: ["explosion_espora", "drenaje_vital", "selva_eterna"],
                receta: [
                    { material: "Raiz Primigenia",  cantidad: 5 },
                    { material: "Corazon de Fango", cantidad: 1 }
                ]
            };

        // =====================================================================
        // RAYO
        // =====================================================================
        case "Daga Voltaica":                 // R1
            return {
                afinidad: "Rayo", rareza: 1,
                ataque_bonus: 5, poder_elemental_bonus: 3,
                habilidades_arma: ["descarga_rapida"],
                receta: [
                    { material: "Chispa Voltica", cantidad: 5 }
                ]
            };

        case "Garras del Relampago":          // R2
            return {
                afinidad: "Rayo", rareza: 2,
                ataque_bonus: 9, poder_elemental_bonus: 6,
                habilidades_arma: ["cadena_electrica", "tormenta_fugaz"],
                receta: [
                    { material: "Chispa Voltica",   cantidad: 10 },
                    { material: "Colmillo de Rayo", cantidad: 3 }
                ]
            };

        case "Espada del Trueno Eterno":      // R3
            return {
                afinidad: "Rayo", rareza: 3,
                ataque_bonus: 15, poder_elemental_bonus: 9,
                habilidades_arma: ["rayo_fulminante", "tormenta_fugaz", "juicio_relampago"],
                receta: [
                    { material: "Colmillo de Rayo",    cantidad: 5 },
                    { material: "Fragmento Celestial", cantidad: 1 }
                ]
            };

        // =====================================================================
        // TIERRA
        // =====================================================================
        case "Mazo Petreo":                   // R1
            return {
                afinidad: "Tierra", rareza: 1,
                ataque_bonus: 5, poder_elemental_bonus: 2,
                habilidades_arma: ["golpe_sismico"],
                receta: [
                    { material: "Arcilla Ancestral", cantidad: 5 }
                ]
            };

        case "Garrote de Roca Viva":          // R2
            return {
                afinidad: "Tierra", rareza: 2,
                ataque_bonus: 10, poder_elemental_bonus: 5,
                habilidades_arma: ["avalancha", "escudo_petreo"],
                receta: [
                    { material: "Arcilla Ancestral", cantidad: 10 },
                    { material: "Ladrillo de Jade",  cantidad: 3 }
                ]
            };

        case "Martillo del Coloso":           // R3
            return {
                afinidad: "Tierra", rareza: 3,
                ataque_bonus: 16, poder_elemental_bonus: 8,
                habilidades_arma: ["cataclismo", "escudo_petreo", "furia_continental"],
                receta: [
                    { material: "Ladrillo de Jade",        cantidad: 5 },
                    { material: "Nucleo de Forja Antigua", cantidad: 1 }
                ]
            };

        // =====================================================================
        // SOMBRA
        // =====================================================================
        case "Filo Sombrio":                  // R1
            return {
                afinidad: "Sombra", rareza: 1,
                ataque_bonus: 4, poder_elemental_bonus: 4,
                habilidades_arma: ["tajo_umbral"],
                receta: [
                    { material: "Fragmento Sombrio", cantidad: 5 }
                ]
            };

        case "Guadana Penumbral":             // R2
            return {
                afinidad: "Sombra", rareza: 2,
                ataque_bonus: 8, poder_elemental_bonus: 7,
                habilidades_arma: ["siega_oscura", "drenar_alma"],
                receta: [
                    { material: "Fragmento Sombrio", cantidad: 10 },
                    { material: "Materia Oscura",    cantidad: 3 }
                ]
            };

        case "Espada del Abismo":             // R3
            return {
                afinidad: "Sombra", rareza: 3,
                ataque_bonus: 13, poder_elemental_bonus: 11,
                habilidades_arma: ["noche_eterna", "drenar_alma", "eclipse_total"],
                receta: [
                    { material: "Materia Oscura",   cantidad: 5 },
                    { material: "Cristal del Vacio", cantidad: 1 }
                ]
            };

        // =====================================================================
        // LUZ
        // =====================================================================
        case "Espadin Aureo":                 // R1
            return {
                afinidad: "Luz", rareza: 1,
                ataque_bonus: 3, poder_elemental_bonus: 4,
                habilidades_arma: ["hoja_radiante"],
                receta: [
                    { material: "Polvo Sagrado", cantidad: 5 }
                ]
            };

        case "Lanza Solar":                   // R2
            return {
                afinidad: "Luz", rareza: 2,
                ataque_bonus: 7, poder_elemental_bonus: 8,
                habilidades_arma: ["embestida_solar", "bendicion_luz"],
                receta: [
                    { material: "Polvo Sagrado",  cantidad: 10 },
                    { material: "Reliquia de Oro", cantidad: 3 }
                ]
            };

        case "Hoja de la Aurora":             // R3
            return {
                afinidad: "Luz", rareza: 3,
                ataque_bonus: 12, poder_elemental_bonus: 13,
                habilidades_arma: ["amanecer_divino", "bendicion_luz", "juicio_celestial"],
                receta: [
                    { material: "Reliquia de Oro",     cantidad: 5 },
                    { material: "Fragmento Celestial", cantidad: 1 }
                ]
            };

        // =====================================================================
        // ARCANO
        // =====================================================================
        case "Vara Runica":                   // R1
            return {
                afinidad: "Arcano", rareza: 1,
                ataque_bonus: 2, poder_elemental_bonus: 6,
                habilidades_arma: ["pulso_runico"],
                receta: [
                    { material: "Runa Menor", cantidad: 5 }
                ]
            };

        case "Espada Arcana":                 // R2
            return {
                afinidad: "Arcano", rareza: 2,
                ataque_bonus: 6, poder_elemental_bonus: 10,
                habilidades_arma: ["corte_arcano", "onda_arcana"],
                receta: [
                    { material: "Runa Menor", cantidad: 10 },
                    { material: "Runa Mayor", cantidad: 3 }
                ]
            };

        case "Baston del Primer Conductor":   // R3
            return {
                afinidad: "Arcano", rareza: 3,
                ataque_bonus: 10, poder_elemental_bonus: 16,
                habilidades_arma: ["singularidad_arcana", "onda_arcana", "ruptura_dimensional"],
                receta: [
                    { material: "Runa Mayor",       cantidad: 5 },
                    { material: "Cristal del Vacio", cantidad: 1 }
                ]
            };

        default:
            show_error("Arma no encontrada: " + string(_arma), true);
            return undefined;
    }
}