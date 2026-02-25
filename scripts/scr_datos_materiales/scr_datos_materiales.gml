/// scr_datos_materiales(nombre_material)
function scr_datos_materiales(_mat) {

    switch (_mat) {

        // ==========================================
        // MATERIALES COMUNES (1 por afinidad)
        // Fuente: Enemigos comunes
        // ==========================================
        case "Fragmento Igneo":
            return { afinidad: "Fuego",  rareza: "comun" };

        case "Escama Glaciar":
            return { afinidad: "Agua",   rareza: "comun" };

        case "Savia Espinosa":
            return { afinidad: "Planta", rareza: "comun" };

        case "Chispa Voltica":
            return { afinidad: "Rayo",   rareza: "comun" };

        case "Arcilla Ancestral":
            return { afinidad: "Tierra", rareza: "comun" };

        case "Fragmento Sombrio":
            return { afinidad: "Sombra", rareza: "comun" };

        case "Polvo Sagrado":
            return { afinidad: "Luz",    rareza: "comun" };

        case "Runa Menor":
            return { afinidad: "Arcano", rareza: "comun" };

        // ==========================================
        // MATERIALES RAROS (1 por afinidad)
        // Fuente: Enemigos élite (garantizado)
        //         Enemigos comunes (12% chance)
        // ==========================================
        case "Brasa Carmesi":
            return { afinidad: "Fuego",  rareza: "raro" };

        case "Perla Abisal":
            return { afinidad: "Agua",   rareza: "raro" };

        case "Raiz Primigenia":
            return { afinidad: "Planta", rareza: "raro" };

        case "Colmillo de Rayo":
            return { afinidad: "Rayo",   rareza: "raro" };

        case "Ladrillo de Jade":
            return { afinidad: "Tierra", rareza: "raro" };

        case "Materia Oscura":
            return { afinidad: "Sombra", rareza: "raro" };

        case "Reliquia de Oro":
            return { afinidad: "Luz",    rareza: "raro" };

        case "Runa Mayor":
            return { afinidad: "Arcano", rareza: "raro" };

        // ==========================================
        // MATERIALES LEGENDARIOS / UNICOS (1 por jefe)
        // Fuente: Jefes duales (garantizado)
        // ==========================================
        case "Nucleo de Forja Antigua":
            return { afinidad: "Fuego-Tierra",   rareza: "legendario" };

        case "Corazon de Fango":
            return { afinidad: "Agua-Planta",    rareza: "legendario" };

        case "Fragmento Celestial":
            return { afinidad: "Rayo-Luz",       rareza: "legendario" };

        case "Cristal del Vacio":
            return { afinidad: "Sombra-Arcano",  rareza: "legendario" };
    }

    show_error("Material no encontrado: " + string(_mat), true);
}