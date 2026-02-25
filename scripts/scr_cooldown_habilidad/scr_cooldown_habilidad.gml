/// scr_cooldown_habilidad(id_habilidad) -> frames
function scr_cooldown_habilidad(_id) {

    switch (_id) {

        // ==========================================
        // 1. HABILIDADES DE ARMAS
        // ==========================================

        // --- Arma base ---
        case "ataque_basico":           return round(room_speed * 0.4);

        // --- FUEGO ---
        case "ataque_fuego_basico":     return round(room_speed * 0.6);   // R1
        case "ataque_fuego_mejorado":   return round(room_speed * 0.8);   // R2
        case "explosion_carmesi":       return round(room_speed * 2.5);   // R2
        case "llamarada_solar":         return round(room_speed * 1.5);   // R3
        case "furia_del_titan":         return round(room_speed * 4.0);   // R3

        // --- AGUA ---
        case "corte_glaciar":           return round(room_speed * 0.6);   // R1
        case "lanza_marina":            return round(room_speed * 0.8);   // R2
        case "corriente_abisal":        return round(room_speed * 2.0);   // R2
        case "tsunami":                 return round(room_speed * 1.5);   // R3
        case "diluvio_eterno":          return round(room_speed * 4.0);   // R3

        // --- PLANTA ---
        case "latigazo_espina":          return round(room_speed * 0.6);   // R1
        case "enredadera_voraz":         return round(room_speed * 0.8);   // R2
        case "drenaje_vital":            return round(room_speed * 2.0);   // R2
        case "explosion_espora":         return round(room_speed * 1.5);   // R3
        case "selva_eterna":             return round(room_speed * 4.0);   // R3

        // --- RAYO ---
        case "descarga_rapida":          return round(room_speed * 0.4);   // R1
        case "cadena_electrica":         return round(room_speed * 0.7);   // R2
        case "tormenta_fugaz":           return round(room_speed * 2.0);   // R2
        case "rayo_fulminante":          return round(room_speed * 1.2);   // R3
        case "juicio_relampago":         return round(room_speed * 4.0);   // R3

        // --- TIERRA ---
        case "golpe_sismico":            return round(room_speed * 0.7);   // R1
        case "avalancha":                return round(room_speed * 1.0);   // R2
        case "escudo_petreo":            return round(room_speed * 2.5);   // R2
        case "cataclismo":               return round(room_speed * 2.0);   // R3
        case "furia_continental":         return round(room_speed * 4.5);   // R3

        // --- SOMBRA ---
        case "tajo_umbral":              return round(room_speed * 0.6);   // R1
        case "siega_oscura":             return round(room_speed * 0.8);   // R2
        case "drenar_alma":              return round(room_speed * 2.5);   // R2
        case "noche_eterna":             return round(room_speed * 1.5);   // R3
        case "eclipse_total":            return round(room_speed * 4.5);   // R3

        // --- LUZ ---
        case "hoja_radiante":            return round(room_speed * 0.6);   // R1
        case "embestida_solar":          return round(room_speed * 0.8);   // R2
        case "bendicion_luz":            return round(room_speed * 2.5);   // R2
        case "amanecer_divino":          return round(room_speed * 1.5);   // R3
        case "juicio_celestial":         return round(room_speed * 4.0);   // R3

        // --- ARCANO ---
        case "pulso_runico":             return round(room_speed * 0.6);   // R1
        case "corte_arcano":             return round(room_speed * 0.7);   // R2
        case "onda_arcana":              return round(room_speed * 2.0);   // R2
        case "singularidad_arcana":      return round(room_speed * 1.5);   // R3
        case "ruptura_dimensional":      return round(room_speed * 4.5);   // R3

        // ==========================================
        // 2. HABILIDADES DE CLASES
        // ==========================================
        case "golpe_guardia":           return round(room_speed * 1.2);  // Vanguardia
        case "corte_rapido":            return round(room_speed * 0.5);  // Filotormenta
        case "impacto_tectonico":       return round(room_speed * 2.0);  // Quebrador
        case "baluarte_ferreo":         return round(room_speed * 3.0);  // Centinela
        case "estocada_critica":        return round(room_speed * 1.5);  // Duelista
        case "descarga_esencia":        return round(room_speed * 2.5);  // Canalizador

        // ==========================================
        // 3. HABILIDADES DE ENEMIGOS COMUNES
        // ==========================================
        case "golpe_fuego":             return round(room_speed * 1.0);  // Soldado Igneo
        case "mirada_gelida":           return round(room_speed * 1.2);  // Vigia Boreal
        case "rafaga_cortante":         return round(room_speed * 0.8);  // Halito Verde
        case "chispazo":                return round(room_speed * 0.9);  // Bestia Tronadora
        case "muro_piedra":             return round(room_speed * 2.0);  // Guardian Terracota
        case "abrazo_vacio":            return round(room_speed * 1.5);  // Naufrago
        case "destello_debil":          return round(room_speed * 1.0);  // Paladin Marchito
        case "pulso_arcano":            return round(room_speed * 1.2);  // Errante Runico

        // ==========================================
        // 4. HABILIDADES DE ENEMIGOS ELITE
        // ==========================================
        case "pilar_llama":             return round(room_speed * 1.5);  // Soldado Igneo Elite
        case "prision_glaciar":         return round(room_speed * 2.0);  // Vigia Boreal Elite
        case "tornado_esmeralda":       return round(room_speed * 1.2);  // Halito Verde Elite
        case "tormenta_electrica":      return round(room_speed * 1.5);  // Bestia Tronadora Elite
        case "terremoto":               return round(room_speed * 2.5);  // Guardian Terracota Elite
        case "agujero_negro":           return round(room_speed * 3.0);  // Naufrago Elite
        case "juicio_sagrado":          return round(room_speed * 2.0);  // Paladin Marchito Elite
        case "cometa_runico":           return round(room_speed * 2.0);  // Errante Runico Elite

        // ==========================================
        // 5. HABILIDADES DE JEFES
        // ==========================================
        case "erupcion_forjada":        return round(room_speed * 3.0);  // Titan (Fuego+Tierra)
        case "maremoto_vegetal":        return round(room_speed * 3.5);  // Coloso (Agua+Planta)
        case "fulgor_celestial":        return round(room_speed * 2.5);  // Sentinela (Rayo+Luz)
        case "vacio_runico":            return round(room_speed * 4.0);  // Oraculo (Sombra+Arcano)
    }

    // Fallback — habilidad sin cooldown registrado
    show_debug_message("Cooldown no registrado para: " + string(_id));
    return round(room_speed * 1.0);
}