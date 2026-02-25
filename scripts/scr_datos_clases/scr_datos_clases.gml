// scr_datos_clases(nombre_clase)
function scr_datos_clases(_clase) {

    switch (_clase) {

        case "Vanguardia":
            return {
                vida: 120,
                ataque: 10,
                defensa: 8,
                velocidad: 4,
                poder_elemental: 5,
                carga_esencia: "recibir_dano",
                habilidad_fija: "golpe_guardia",
            };

        case "Filotormenta":
            return {
                vida: 90,
                ataque: 12,
                defensa: 4,
                velocidad: 8,
                poder_elemental: 6,
                carga_esencia: "combo_habilidades",
                habilidad_fija: "corte_rapido",
            };

        // Agregaremos el resto luego en el paso 6 del MVP

    }

    show_error("Clase no encontrada: " + string(_clase), true);
}