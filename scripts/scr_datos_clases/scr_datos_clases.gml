/// @function scr_datos_clases(_clase)
/// @description Retorna un struct con las estadísticas y habilidades de la clase especificada.
function scr_datos_clases(_clase) {

    switch (_clase) {

        case "Vanguardia":
            return {
                vida: 120,
                ataque: 10,
                defensa: 8,
                defensa_magica: 5,
                velocidad: 4,
                poder_elemental: 5,
                carga_esencia: "recibir_dano",
                habilidad_fija: "golpe_guardia",
                precio: 0,  // clase inicial
            };

        case "Filotormenta":
            return {
                vida: 90,
                ataque: 12,
                defensa: 4,
                defensa_magica: 3,
                velocidad: 10,
                poder_elemental: 6,
                carga_esencia: "combo_habilidades",
                habilidad_fija: "corte_rapido",
                precio: 500,
            };

        case "Quebrador":
            return {
                vida: 110,
                ataque: 15,
                defensa: 6,
                defensa_magica: 3,
                velocidad: 3,
                poder_elemental: 4,
                carga_esencia: "ataques_pesados",
                habilidad_fija: "impacto_tectonico",
                precio: 500,
            };

        case "Centinela":
            return {
                vida: 150,
                ataque: 7,
                defensa: 12,
                defensa_magica: 10,
                velocidad: 2,
                poder_elemental: 5,
                carga_esencia: "bloqueo_exitoso",
                habilidad_fija: "baluarte_ferreo",
                precio: 750,
            };

        case "Duelista":
            return {
                vida: 85,
                ataque: 11,
                defensa: 5,
                defensa_magica: 6,
                velocidad: 9,
                poder_elemental: 7,
                carga_esencia: "parry_perfecto",
                habilidad_fija: "estocada_critica",
                precio: 750,
            };

        case "Canalizador":
            return {
                vida: 80,
                ataque: 6,
                defensa: 4,
                defensa_magica: 8,
                velocidad: 6,
                poder_elemental: 15,
                carga_esencia: "uso_elemental",
                habilidad_fija: "descarga_esencia",
                precio: 1000,
            };

        default:
            show_error("Clase no encontrada: " + string(_clase), true);
            return undefined;
    }
}