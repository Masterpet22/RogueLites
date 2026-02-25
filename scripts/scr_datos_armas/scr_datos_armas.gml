/// scr_datos_armas(nombre_arma)
function scr_datos_armas(_arma) {

    switch (_arma) {

        case "Hoja Rota":
            return {
                afinidad: "Fuego",
                rareza: 1,
                ataque_bonus: 0,
                poder_elemental_bonus: 0,
                habilidades_arma: ["ataque_basico"],
                receta: [] 
            };

        case "Filo Igneo":
            return {
                afinidad: "Fuego",
                rareza: 1,
                ataque_bonus: 4,
                poder_elemental_bonus: 3,
                habilidades_arma: ["ataque_fuego_basico"],
                receta: [ { material: "Fragmento Igneo", cantidad: 5 } ]
            };

        case "Mandoble Carmesi":
            return {
                afinidad: "Fuego",
                rareza: 2,
                ataque_bonus: 8,
                poder_elemental_bonus: 6,
                habilidades_arma: ["ataque_fuego_mejorado", "explosion_carmesi"],
                receta: [ 
                    { material: "Fragmento Igneo", cantidad: 1 } // Ajusté cantidad para escalabilidad
                    //{ material: "Brasa Carmesi", cantidad: 3 } 
                ]
            };

        default:
            show_error("Arma no encontrada: " + string(_arma), true);
            return undefined; // Retorno de seguridad
    }
}