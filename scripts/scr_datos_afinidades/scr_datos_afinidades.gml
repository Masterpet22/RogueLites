// scr_datos_afinidades(nombre_afinidad)
function scr_datos_afinidades(_afi) {

    switch (_afi) {

        case "Fuego":
            return {
                activador: "usar_habilidad",
                bono: 1.10,  // +10% daño
                penalizacion: -0.05, // -5% defensa
                cooldown: 2,
            };

        case "Rayo":
            return {
                activador: "combo_velocidad",
                bono: 1.15,
                penalizacion: -0.10,
                cooldown: 3,
            };

        // Más adelante añadiremos las otras 6

    }

    show_error("Afinidad no encontrada: " + string(_afi), true);
}