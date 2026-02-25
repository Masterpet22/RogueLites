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

        case "Tierra":
            return {
                activador: "recibir_dano",
                bono: 1.20,            // +20% defensa temporal
                penalizacion: -0.05,   // -5% velocidad
                cooldown: 3,
            };

        case "Agua":
            return {
                activador: "recibir_dano",
                bono: 1.20,            // -20% cooldowns (reducción)
                penalizacion: -0.05,   // -5% ataque
                cooldown: 4,
            };

        case "Planta":
            return {
                activador: "turno_pasado",
                bono: 1.15,            // +15% regeneración de vida
                penalizacion: -0.05,   // -5% poder elemental
                cooldown: 3,
            };

        case "Sombra":
            return {
                activador: "golpe_critico",
                bono: 1.25,            // +25% daño en golpe crítico
                penalizacion: -0.10,   // -10% defensa
                cooldown: 4,
            };

        case "Luz":
            return {
                activador: "recibir_dano",
                bono: 1.15,            // +15% curación / escudo
                penalizacion: -0.05,   // -5% poder elemental
                cooldown: 3,
            };

        case "Arcano":
            return {
                activador: "uso_habilidad",
                bono: 1.20,            // +20% poder elemental
                penalizacion: -0.10,   // -10% defensa
                cooldown: 4,
            };

    }

    show_error("Afinidad no encontrada: " + string(_afi), true);
}