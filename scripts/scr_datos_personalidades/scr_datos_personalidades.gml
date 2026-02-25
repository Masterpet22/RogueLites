/// scr_datos_personalidades(personalidad) -> struct con modificadores
/// 4 personalidades: Agresivo, Metódico, Temerario, Resuelto
///
/// Cada una devuelve multiplicadores que se aplican a los stats base del personaje.
/// mult_ataque, mult_defensa, mult_velocidad, mult_poder_elemental, mult_vida

function scr_datos_personalidades(_personalidad) {

    switch (_personalidad) {

        // ===================================================
        // AGRESIVO: Favorece ataque/velocidad, penaliza defensa
        // ===================================================
        case "Agresivo":
            return {
                nombre: "Agresivo",
                descripcion: "Favorece ataque y velocidad, penaliza defensa",
                mult_vida:             0.90,   // -10% vida
                mult_ataque:           1.20,   // +20% ataque
                mult_defensa:          0.80,   // -20% defensa
                mult_velocidad:        1.15,   // +15% velocidad
                mult_poder_elemental:  1.10,   // +10% poder elemental
            };

        // ===================================================
        // METÓDICO: Favorece defensa y consistencia
        // ===================================================
        case "Metodico":
            return {
                nombre: "Metodico",
                descripcion: "Favorece defensa y consistencia general",
                mult_vida:             1.10,   // +10% vida
                mult_ataque:           1.00,   // sin cambio
                mult_defensa:          1.15,   // +15% defensa
                mult_velocidad:        0.95,   // -5% velocidad
                mult_poder_elemental:  1.05,   // +5% poder elemental
            };

        // ===================================================
        // TEMERARIO: Gran poder a cambio de riesgos altos
        // ===================================================
        case "Temerario":
            return {
                nombre: "Temerario",
                descripcion: "Gran poder ofensivo a cambio de mayor riesgo",
                mult_vida:             0.80,   // -20% vida
                mult_ataque:           1.30,   // +30% ataque
                mult_defensa:          0.75,   // -25% defensa
                mult_velocidad:        1.10,   // +10% velocidad
                mult_poder_elemental:  1.20,   // +20% poder elemental
            };

        // ===================================================
        // RESUELTO: Estabilidad, penalizaciones menores, constante
        // ===================================================
        case "Resuelto":
            return {
                nombre: "Resuelto",
                descripcion: "Estabilidad general, sin grandes ventajas ni penalizaciones",
                mult_vida:             1.05,   // +5% vida
                mult_ataque:           1.05,   // +5% ataque
                mult_defensa:          1.05,   // +5% defensa
                mult_velocidad:        1.05,   // +5% velocidad
                mult_poder_elemental:  1.05,   // +5% poder elemental
            };

        default:
            show_error("Personalidad no encontrada: " + string(_personalidad), true);
            return undefined;
    }
}
