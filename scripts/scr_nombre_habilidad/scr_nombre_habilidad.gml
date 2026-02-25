/// scr_nombre_habilidad(id_habilidad) -> string
function scr_nombre_habilidad(_id) {

    switch (_id) {

        // ==========================================
        // 1. HABILIDADES DE ARMAS
        // ==========================================
        case "ataque_basico":           return "Golpe";
        case "ataque_fuego_basico":     return "Golpe Ígneo";
        case "ataque_fuego_mejorado":   return "Golpe Ígneo+";
        case "explosion_carmesi":       return "Expl. Carmesí";

        // ==========================================
        // 2. HABILIDADES DE CLASES
        // ==========================================
        case "golpe_guardia":           return "Golpe Guardia";      // Vanguardia
        case "corte_rapido":            return "Corte Rápido";       // Filotormenta
        case "impacto_tectonico":       return "Imp. Tectónico";     // Quebrador
        case "baluarte_ferreo":         return "Baluarte Férreo";    // Centinela
        case "estocada_critica":        return "Estocada Crítica";   // Duelista
        case "descarga_esencia":        return "Desc. Esencia";      // Canalizador

        // ==========================================
        // 3. HABILIDADES DE ENEMIGOS COMUNES
        // ==========================================
        case "golpe_fuego":             return "Golpe Fuego";        // Soldado Igneo
        case "mirada_gelida":           return "Mirada Gélida";      // Vigia Boreal
        case "rafaga_cortante":         return "Ráfaga Cortante";    // Halito Verde
        case "chispazo":                return "Chispazo";           // Bestia Tronadora
        case "muro_piedra":             return "Muro de Piedra";     // Guardian Terracota
        case "abrazo_vacio":            return "Abrazo Vacío";       // Naufrago
        case "destello_debil":          return "Destello Débil";     // Paladin Marchito
        case "pulso_arcano":            return "Pulso Arcano";       // Errante Runico

        // ==========================================
        // 4. HABILIDADES DE ENEMIGOS ELITE
        // ==========================================
        case "pilar_llama":             return "Pilar de Llamas";    // Soldado Igneo Elite
        case "prision_glaciar":         return "Prisión Glaciar";    // Vigia Boreal Elite
        case "tornado_esmeralda":       return "Tornado Esmeralda";  // Halito Verde Elite
        case "tormenta_electrica":      return "Tormenta Eléctrica"; // Bestia Tronadora Elite
        case "terremoto":               return "Terremoto";          // Guardian Terracota Elite
        case "agujero_negro":           return "Agujero Negro";      // Naufrago Elite
        case "juicio_sagrado":          return "Juicio Sagrado";     // Paladin Marchito Elite
        case "cometa_runico":           return "Cometa Rúnico";      // Errante Runico Elite

        // ==========================================
        // 5. HABILIDADES DE JEFES
        // ==========================================
        case "erupcion_forjada":        return "Erupción Forjada";   // Titan (Fuego+Tierra)
        case "maremoto_vegetal":        return "Maremoto Vegetal";   // Coloso (Agua+Planta)
        case "fulgor_celestial":        return "Fulgor Celestial";   // Sentinela (Rayo+Luz)
        case "vacio_runico":            return "Vacío Rúnico";       // Oraculo (Sombra+Arcano)
    }

    // Fallback — habilidad sin nombre registrado
    show_debug_message("Nombre no registrado para: " + string(_id));
    return string(_id);
}