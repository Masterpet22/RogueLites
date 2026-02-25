// scr_datos_enemigos(nombre_enemigo)
function scr_datos_enemigos(_e) {

    switch (_e) {

        case "Soldado Igneo":
            return {
                vida: 80,
                ataque: 8,
                defensa: 3,
                afinidad: "Fuego",
                habilidad_fija: "golpe_fuego",
                material_drop: "Fragmento Igneo",
            };

        // Añadiremos los otros después

    }

    show_error("Enemigo no encontrado: " + string(_e), true);
}