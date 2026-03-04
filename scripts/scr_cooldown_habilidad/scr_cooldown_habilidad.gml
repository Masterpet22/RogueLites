/// scr_cooldown_habilidad(id_habilidad) -> frames
function scr_cooldown_habilidad(_id) {

    switch (_id) {

        // ==========================================
        // 1. HABILIDADES DE ARMAS
        // ==========================================

        // --- Arma base ---
        case "ataque_basico":           return round(GAME_FPS * 0.4);

        // --- FUEGO ---
        case "ataque_fuego_basico":     return round(GAME_FPS * 0.6);   // R1
        case "ataque_fuego_mejorado":   return round(GAME_FPS * 0.8);   // R2
        case "explosion_carmesi":       return round(GAME_FPS * 2.5);   // R2
        case "llamarada_solar":         return round(GAME_FPS * 1.5);   // R3
        case "furia_del_titan":         return round(GAME_FPS * 4.0);   // R3

        // --- AGUA ---
        case "corte_glaciar":           return round(GAME_FPS * 0.6);   // R1
        case "lanza_marina":            return round(GAME_FPS * 0.8);   // R2
        case "corriente_abisal":        return round(GAME_FPS * 2.0);   // R2
        case "tsunami":                 return round(GAME_FPS * 1.5);   // R3
        case "diluvio_eterno":          return round(GAME_FPS * 4.0);   // R3

        // --- PLANTA ---
        case "latigazo_espina":          return round(GAME_FPS * 0.6);   // R1
        case "enredadera_voraz":         return round(GAME_FPS * 0.8);   // R2
        case "drenaje_vital":            return round(GAME_FPS * 2.0);   // R2
        case "explosion_espora":         return round(GAME_FPS * 1.5);   // R3
        case "selva_eterna":             return round(GAME_FPS * 4.0);   // R3

        // --- RAYO ---
        case "descarga_rapida":          return round(GAME_FPS * 0.4);   // R1
        case "cadena_electrica":         return round(GAME_FPS * 0.7);   // R2
        case "tormenta_fugaz":           return round(GAME_FPS * 2.0);   // R2
        case "rayo_fulminante":          return round(GAME_FPS * 1.2);   // R3
        case "juicio_relampago":         return round(GAME_FPS * 4.0);   // R3

        // --- TIERRA ---
        case "golpe_sismico":            return round(GAME_FPS * 0.7);   // R1
        case "avalancha":                return round(GAME_FPS * 1.0);   // R2
        case "escudo_petreo":            return round(GAME_FPS * 2.5);   // R2
        case "cataclismo":               return round(GAME_FPS * 2.0);   // R3
        case "furia_continental":         return round(GAME_FPS * 4.5);   // R3

        // --- SOMBRA ---
        case "tajo_umbral":              return round(GAME_FPS * 0.6);   // R1
        case "siega_oscura":             return round(GAME_FPS * 0.8);   // R2
        case "drenar_alma":              return round(GAME_FPS * 2.5);   // R2
        case "noche_eterna":             return round(GAME_FPS * 1.5);   // R3
        case "eclipse_total":            return round(GAME_FPS * 4.5);   // R3

        // --- LUZ ---
        case "hoja_radiante":            return round(GAME_FPS * 0.6);   // R1
        case "embestida_solar":          return round(GAME_FPS * 0.8);   // R2
        case "bendicion_luz":            return round(GAME_FPS * 2.5);   // R2
        case "amanecer_divino":          return round(GAME_FPS * 1.5);   // R3
        case "juicio_celestial":         return round(GAME_FPS * 4.0);   // R3

        // --- ARCANO ---
        case "pulso_runico":             return round(GAME_FPS * 0.6);   // R1
        case "corte_arcano":             return round(GAME_FPS * 0.7);   // R2
        case "onda_arcana":              return round(GAME_FPS * 2.0);   // R2
        case "singularidad_arcana":      return round(GAME_FPS * 1.5);   // R3
        case "ruptura_dimensional":      return round(GAME_FPS * 4.5);   // R3

        // ==========================================
        // 2. HABILIDADES DE CLASES
        // ==========================================
        case "golpe_guardia":           return round(GAME_FPS * 1.2);  // Vanguardia
        case "corte_rapido":            return round(GAME_FPS * 0.5);  // Filotormenta
        case "impacto_tectonico":       return round(GAME_FPS * 2.0);  // Quebrador
        case "baluarte_ferreo":         return round(GAME_FPS * 3.0);  // Centinela
        case "estocada_critica":        return round(GAME_FPS * 1.5);  // Duelista
        case "descarga_esencia":        return round(GAME_FPS * 2.5);  // Canalizador

        // ==========================================
        // 3. HABILIDADES DE ENEMIGOS COMUNES
        // ==========================================
        case "golpe_fuego":             return round(GAME_FPS * 1.0);  // Soldado Igneo
        case "mirada_gelida":           return round(GAME_FPS * 1.2);  // Vigia Boreal
        case "rafaga_cortante":         return round(GAME_FPS * 0.8);  // Halito Verde
        case "chispazo":                return round(GAME_FPS * 0.9);  // Bestia Tronadora
        case "muro_piedra":             return round(GAME_FPS * 2.0);  // Guardian Terracota
        case "abrazo_vacio":            return round(GAME_FPS * 1.5);  // Naufrago
        case "destello_debil":          return round(GAME_FPS * 1.0);  // Paladin Marchito
        case "pulso_arcano":            return round(GAME_FPS * 1.2);  // Errante Runico

        // ==========================================
        // 4. HABILIDADES DE ENEMIGOS ELITE
        // ==========================================
        case "pilar_llama":             return round(GAME_FPS * 1.5);  // Soldado Igneo Elite
        case "prision_glaciar":         return round(GAME_FPS * 2.0);  // Vigia Boreal Elite
        case "tornado_esmeralda":       return round(GAME_FPS * 1.2);  // Halito Verde Elite
        case "tormenta_electrica":      return round(GAME_FPS * 1.5);  // Bestia Tronadora Elite
        case "terremoto":               return round(GAME_FPS * 2.5);  // Guardian Terracota Elite
        case "agujero_negro":           return round(GAME_FPS * 3.0);  // Naufrago Elite
        case "juicio_sagrado":          return round(GAME_FPS * 2.0);  // Paladin Marchito Elite
        case "cometa_runico":           return round(GAME_FPS * 2.0);  // Errante Runico Elite

        // ==========================================
        // 4b. SECUNDARIAS ELITE (con estados)
        // ==========================================
        case "llamarada_furia":         return round(GAME_FPS * 3.0);  // Soldado Igneo Elite
        case "ventisca_polar":          return round(GAME_FPS * 3.5);  // Vigia Boreal Elite
        case "esporas_toxicas":         return round(GAME_FPS * 3.0);  // Halito Verde Elite
        case "impulso_voltaico":        return round(GAME_FPS * 3.5);  // Bestia Tronadora Elite
        case "fortaleza_petrea":        return round(GAME_FPS * 4.0);  // Guardian Terracota Elite
        case "marca_sombria":           return round(GAME_FPS * 3.5);  // Naufrago Elite
        case "plegaria_marchita":       return round(GAME_FPS * 4.0);  // Paladin Marchito Elite
        case "sello_arcano":            return round(GAME_FPS * 3.5);  // Errante Runico Elite

        // ==========================================
        // 5. HABILIDADES DE JEFES
        // ==========================================
        // ── Titán de las Forjas Rotas ──
        case "erupcion_forjada":        return round(GAME_FPS * 3.0);
        case "martillo_incandescente":  return round(GAME_FPS * 2.0);
        case "muro_magmatico":          return round(GAME_FPS * 5.0);
        case "cataclismo_forjado":      return round(GAME_FPS * 6.0);
        // ── Coloso del Fango Viviente ──
        case "maremoto_vegetal":        return round(GAME_FPS * 3.5);
        case "torrente_fangoso":        return round(GAME_FPS * 2.5);
        case "esporas_regenerativas":   return round(GAME_FPS * 5.0);
        case "aplastamiento_pantano":   return round(GAME_FPS * 6.0);
        // ── Sentinela del Cielo Roto ──
        case "fulgor_celestial":        return round(GAME_FPS * 2.5);
        case "relampago_sagrado":       return round(GAME_FPS * 1.5);
        case "destello_purificador":    return round(GAME_FPS * 4.0);
        case "tormenta_divina":         return round(GAME_FPS * 6.0);
        // ── Oráculo Quebrado del Abismo ──
        case "vacio_runico":            return round(GAME_FPS * 4.0);
        case "pulso_abismal":           return round(GAME_FPS * 2.5);
        case "sifon_sombrio":           return round(GAME_FPS * 3.5);
        case "apocalipsis_runico":      return round(GAME_FPS * 6.0);
        // ── El Devorador ──
        case "mordida_vacia":           return round(GAME_FPS * 2.0);
        case "pulso_devorador":         return round(GAME_FPS * 3.5);
        case "espejo_voraz":            return round(GAME_FPS * 4.0);
        case "consumo_absoluto":        return round(GAME_FPS * 7.0);
        // ── El Primer Conductor ──
        case "golpe_primordial":        return round(GAME_FPS * 2.0);
        case "resonancia_conductor":    return round(GAME_FPS * 5.0);
        case "armonia_invertida":       return round(GAME_FPS * 5.0);
        case "genesis_final":           return round(GAME_FPS * 8.0);
    }

    // Fallback — habilidad sin cooldown registrado
    show_debug_message("Cooldown no registrado para: " + string(_id));
    return round(GAME_FPS * 1.0);
}