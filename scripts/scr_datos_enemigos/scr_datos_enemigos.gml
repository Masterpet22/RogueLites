/// @function scr_datos_enemigos(_e)
function scr_datos_enemigos(_e) {

    switch (_e) {
        
        // --- ENEMIGOS COMUNES ---
        case "Soldado Igneo":
            return { vida: 80, ataque: 8, defensa: 3, afinidad: "Fuego", habilidad_fija: "golpe_fuego", material_drop: "Fragmento Igneo" };

        case "Vigia Boreal":
            return { vida: 70, ataque: 6, defensa: 5, afinidad: "Hielo", habilidad_fija: "mirada_gelida", material_drop: "Escarcha Eterna" };

        case "Halito Verde":
            return { vida: 60, ataque: 10, defensa: 2, afinidad: "Viento", habilidad_fija: "rafaga_cortante", material_drop: "Esencia de Aire" };

        case "Bestia Tronadora":
            return { vida: 75, ataque: 12, defensa: 1, afinidad: "Rayo", habilidad_fija: "chispazo", material_drop: "Nucelo Electrico" };

        case "Guardian Terracota":
            return { vida: 110, ataque: 5, defensa: 10, afinidad: "Tierra", habilidad_fija: "muro_piedra", material_drop: "Arcilla Ancestral" };

        case "Naufrago de la Oscuridad":
            return { vida: 90, ataque: 9, defensa: 4, afinidad: "Oscuridad", habilidad_fija: "abrazo_vacio", material_drop: "Polvo Estelar" };

        case "Paladin Marchito":
            return { vida: 100, ataque: 7, defensa: 8, afinidad: "Luz", habilidad_fija: "destello_debil", material_drop: "Hierro Oxidado" };

        case "Errante Runico":
            return { vida: 85, ataque: 8, defensa: 6, afinidad: "Arcano", habilidad_fija: "pulso_arcano", material_drop: "Runa Menor" };


        // --- ENEMIGOS ELITE (Stats base x 1.5 aprox) ---
        case "Soldado Igneo Elite":
            return { vida: 150, ataque: 12, defensa: 6, afinidad: "Fuego", habilidad_fija: "pilar_llama", material_drop: "Nucleo Igneo" };

        case "Vigia Boreal Elite":
            return { vida: 130, ataque: 10, defensa: 8, afinidad: "Hielo", habilidad_fija: "prision_glaciar", material_drop: "Cristal Boreal" };

        case "Halito Verde Elite":
            return { vida: 110, ataque: 15, defensa: 4, afinidad: "Viento", habilidad_fija: "tornado_esmeralda", material_drop: "Pluma de Vendaval" };

        case "Bestia Tronadora Elite":
            return { vida: 140, ataque: 18, defensa: 3, afinidad: "Rayo", habilidad_fija: "tormenta_electrica", material_drop: "Colmillo de Rayo" };

        case "Guardian Terracota Elite":
            return { vida: 200, ataque: 9, defensa: 15, afinidad: "Tierra", habilidad_fija: "terremoto", material_drop: "Ladrillo de Jade" };

        case "Naufrago de la Oscuridad Elite":
            return { vida: 160, ataque: 14, defensa: 7, afinidad: "Oscuridad", habilidad_fija: "agujero_negro", material_drop: "Materia Oscura" };

        case "Paladin Marchito Elite":
            return { vida: 180, ataque: 11, defensa: 12, afinidad: "Luz", habilidad_fija: "juicio_sagrado", material_drop: "Reliquia de Oro" };

        case "Errante Runico Elite":
            return { vida: 150, ataque: 13, defensa: 10, afinidad: "Arcano", habilidad_fija: "cometa_runico", material_drop: "Runa Mayor" };


        // --- JEFES ---
        case "Titan de las Forjas Rotas":
            return {
                vida: 1200,
                ataque: 25,
                defensa: 20,
                afinidad: "Fuego-Tierra", // Dual
                habilidad_fija: "erupcion_forjada",
                material_drop: "Corazon del Titan"
            };

        default:
            show_error("Enemigo no encontrado: " + string(_e), true);
            return undefined;
    }
}