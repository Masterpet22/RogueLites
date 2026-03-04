/// @function scr_datos_clases(_clase)
/// @description Retorna un struct con las estadísticas y habilidades de la clase especificada.
function scr_datos_clases(_clase) {

    switch (_clase) {

        case "Vanguardia":
            return {
                vida: 160,
                ataque: 10,
                defensa: 10,
                defensa_magica: 7,
                velocidad: 4,
                poder_elemental: 5,
                carga_esencia: "recibir_dano",
                habilidad_fija: "golpe_guardia",
                precio: 0,  // clase inicial
            };

        case "Filotormenta":
            return {
                vida: 130,
                ataque: 12,
                defensa: 5,
                defensa_magica: 4,
                velocidad: 10,
                poder_elemental: 6,
                carga_esencia: "combo_habilidades",
                habilidad_fija: "corte_rapido",
                precio: 500,
            };

        case "Quebrador":
            return {
                vida: 150,
                ataque: 15,
                defensa: 7,
                defensa_magica: 5,
                velocidad: 3,
                poder_elemental: 4,
                carga_esencia: "ataques_pesados",
                habilidad_fija: "impacto_tectonico",
                precio: 500,
            };

        case "Centinela":
            return {
                vida: 200,
                ataque: 7,
                defensa: 14,
                defensa_magica: 12,
                velocidad: 2,
                poder_elemental: 5,
                carga_esencia: "bloqueo_exitoso",
                habilidad_fija: "baluarte_ferreo",
                precio: 750,
            };

        case "Duelista":
            return {
                vida: 125,
                ataque: 11,
                defensa: 6,
                defensa_magica: 6,
                velocidad: 9,
                poder_elemental: 7,
                carga_esencia: "parry_perfecto",
                habilidad_fija: "estocada_critica",
                precio: 750,
            };

        case "Canalizador":
            return {
                vida: 125,
                ataque: 6,
                defensa: 5,
                defensa_magica: 10,
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


/// @function scr_nombre_super(_clase, _personalidad)
/// @description Retorna el nombre de la Súper-Habilidad según Clase × Personalidad.
function scr_nombre_super(_clase, _personalidad) {
    var _key = _clase + "_" + _personalidad;
    switch (_key) {
        case "Vanguardia_Agresivo":     return "Embestida Volcánica";
        case "Vanguardia_Metodico":     return "Fortaleza Inquebrantable";
        case "Vanguardia_Temerario":    return "Sacrificio del Titán";
        case "Vanguardia_Resuelto":     return "Golpe del Guardián";
        case "Filotormenta_Agresivo":   return "Ráfaga Imparable";
        case "Filotormenta_Metodico":   return "Corte Preciso";
        case "Filotormenta_Temerario":  return "Tormenta de Acero";
        case "Filotormenta_Resuelto":   return "Danza del Filo";
        case "Quebrador_Agresivo":      return "Cataclismo Furioso";
        case "Quebrador_Metodico":      return "Pulverizar";
        case "Quebrador_Temerario":     return "Impacto Suicida";
        case "Quebrador_Resuelto":      return "Martillazo Firme";
        case "Centinela_Agresivo":      return "Contraataque Blindado";
        case "Centinela_Metodico":      return "Bastión Eterno";
        case "Centinela_Temerario":     return "Explosión de Hierro";
        case "Centinela_Resuelto":      return "Muro Inquebrantable";
        case "Duelista_Agresivo":       return "Estocada Mortal";
        case "Duelista_Metodico":       return "Mil Cortes";
        case "Duelista_Temerario":      return "Apuesta Final";
        case "Duelista_Resuelto":       return "Golpe Certero";
        case "Canalizador_Agresivo":    return "Nova Arcana";
        case "Canalizador_Metodico":    return "Canalización Estable";
        case "Canalizador_Temerario":   return "Detonación Interior";
        case "Canalizador_Resuelto":    return "Flujo Arcano";
        default: return "???";
    }
}