/// scr_nombre_habilidad(id_habilidad) -> string
function scr_nombre_habilidad(_id) {

    switch (_id) {

        // ==========================================
        // 1. HABILIDADES DE ARMAS
        // ==========================================

        // --- Arma base ---
        case "ataque_basico":           return "Golpe";

        // --- FUEGO ---
        case "ataque_fuego_basico":     return "Golpe Ígneo";         // R1
        case "ataque_fuego_mejorado":   return "Golpe Ígneo+";        // R2
        case "explosion_carmesi":       return "Expl. Carmesí";       // R2
        case "llamarada_solar":         return "Llamarada Solar";     // R3
        case "furia_del_titan":         return "Furia del Titán";     // R3

        // --- AGUA ---
        case "corte_glaciar":           return "Corte Glaciar";       // R1
        case "lanza_marina":            return "Lanza Marina";        // R2
        case "corriente_abisal":        return "Corr. Abisal";        // R2
        case "tsunami":                 return "Tsunami";             // R3
        case "diluvio_eterno":          return "Diluvio Eterno";      // R3

        // --- PLANTA ---
        case "latigazo_espina":          return "Latigazo Espina";     // R1
        case "enredadera_voraz":         return "Enredadera Voraz";    // R2
        case "drenaje_vital":            return "Drenaje Vital";       // R2
        case "explosion_espora":         return "Expl. Espora";        // R3
        case "selva_eterna":             return "Selva Eterna";        // R3

        // --- RAYO ---
        case "descarga_rapida":          return "Descarga Rápida";     // R1
        case "cadena_electrica":         return "Cadena Eléctrica";    // R2
        case "tormenta_fugaz":           return "Tormenta Fugaz";      // R2
        case "rayo_fulminante":          return "Rayo Fulminante";     // R3
        case "juicio_relampago":         return "Juicio Relámpago";    // R3

        // --- TIERRA ---
        case "golpe_sismico":            return "Golpe Sísmico";       // R1
        case "avalancha":                return "Avalancha";           // R2
        case "escudo_petreo":            return "Escudo Pétreo";       // R2
        case "cataclismo":               return "Cataclismo";          // R3
        case "furia_continental":         return "Furia Continental";   // R3

        // --- SOMBRA ---
        case "tajo_umbral":              return "Tajo Umbral";         // R1
        case "siega_oscura":             return "Siega Oscura";        // R2
        case "drenar_alma":              return "Drenar Alma";         // R2
        case "noche_eterna":             return "Noche Eterna";        // R3
        case "eclipse_total":            return "Eclipse Total";       // R3

        // --- LUZ ---
        case "hoja_radiante":            return "Hoja Radiante";       // R1
        case "embestida_solar":          return "Embestida Solar";     // R2
        case "bendicion_luz":            return "Bendición de Luz";    // R2
        case "amanecer_divino":          return "Amanecer Divino";     // R3
        case "juicio_celestial":         return "Juicio Celestial";    // R3

        // --- ARCANO ---
        case "pulso_runico":             return "Pulso Rúnico";        // R1
        case "corte_arcano":             return "Corte Arcano";        // R2
        case "onda_arcana":              return "Onda Arcana";         // R2
        case "singularidad_arcana":      return "Singularidad Arc.";   // R3
        case "ruptura_dimensional":      return "Rupt. Dimensional";   // R3

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