// scr_datos_materiales(nombre_material)
function scr_datos_materiales(_mat) {

    switch (_mat) {

        case "Fragmento Igneo":
            return {
                afinidad: "Fuego",
                rareza: "comun",
            };

        case "Chispa Voltica":
            return {
                afinidad: "Rayo",
                rareza: "comun",
            };

        // Luego añadiremos raros y únicos

    }

    show_error("Material no encontrado: " + string(_mat), true);
}