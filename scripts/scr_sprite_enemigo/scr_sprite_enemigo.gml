/// scr_sprite_enemigo(nombre_enemigo, rango, es_rostro)
/// Devuelve el sprite correspondiente al enemigo según su nombre y rango.
/// Si es_rostro es true, devuelve el retrato; si no, el cuerpo completo.
/// Fallback a spr_enemigo / spr_enemigo_rostro si no hay match.
function scr_sprite_enemigo(_nombre, _rango, _es_rostro) {
    
    // ── JEFES ──
    if (_rango == "Jefe") {
        if (_es_rostro) {
            switch (_nombre) {
                case "Titan de las Forjas Rotas":    return spr_rostro_titan_forjas;
                case "Coloso del Fango Viviente":    return spr_rostro_coloso_fango;
                case "Sentinela del Cielo Roto":     return spr_rostro_sentinela_cielo;
                case "Oraculo Quebrado del Abismo":  return spr_rostro_oraculo_abismo;
                case "El Devorador":                 return spr_rostro_devorador;
                case "El Primer Conductor":          return spr_rostro_primer_conductor;
                default:                             return spr_enemigo_rostro;
            }
        } else {
            switch (_nombre) {
                case "Titan de las Forjas Rotas":    return spr_jefe_titan_forjas;
                case "Coloso del Fango Viviente":    return spr_jefe_coloso_fango;
                case "Sentinela del Cielo Roto":     return spr_jefe_sentinela_cielo;
                case "Oraculo Quebrado del Abismo":  return spr_jefe_oraculo_abismo;
                case "El Devorador":                 return spr_jefe_devorador;
                case "El Primer Conductor":          return spr_jefe_primer_conductor;
                default:                             return spr_enemigo;
            }
        }
    }
    
    // ── ÉLITES ──
    // Los élites intentan usar sprite propio; si no existe, usan el del común
    // (para que el sistema de recolor por código funcione como fallback)
    if (_rango == "Elite") {
        // Extraer nombre base (sin " Elite")
        var _nombre_base = string_replace(_nombre, " Elite", "");
        
        if (_es_rostro) {
            var _spr_elite = -1;
            switch (_nombre) {
                case "Soldado Igneo Elite":                _spr_elite = spr_rostro_elite_soldado_igneo; break;
                case "Vigia Boreal Elite":                 _spr_elite = spr_rostro_elite_vigia_boreal; break;
                case "Halito Verde Elite":                 _spr_elite = spr_rostro_elite_halito_verde; break;
                case "Bestia Tronadora Elite":             _spr_elite = spr_rostro_elite_bestia_tronadora; break;
                case "Guardian Terracota Elite":            _spr_elite = spr_rostro_elite_guardian_terracota; break;
                case "Naufrago de la Oscuridad Elite":     _spr_elite = spr_rostro_elite_naufrago; break;
                case "Paladin Marchito Elite":             _spr_elite = spr_rostro_elite_paladin_marchito; break;
                case "Errante Runico Elite":               _spr_elite = spr_rostro_elite_errante_runico; break;
            }
            // Si el sprite élite existe realmente, usarlo; si no, fallback al común
            if (_spr_elite != -1 && sprite_exists(_spr_elite)) return _spr_elite;
            return scr_sprite_enemigo(_nombre_base, "Común", true);
        } else {
            var _spr_elite = -1;
            switch (_nombre) {
                case "Soldado Igneo Elite":                _spr_elite = spr_elite_soldado_igneo; break;
                case "Vigia Boreal Elite":                 _spr_elite = spr_elite_vigia_boreal; break;
                case "Halito Verde Elite":                 _spr_elite = spr_elite_halito_verde; break;
                case "Bestia Tronadora Elite":             _spr_elite = spr_elite_bestia_tronadora; break;
                case "Guardian Terracota Elite":            _spr_elite = spr_elite_guardian_terracota; break;
                case "Naufrago de la Oscuridad Elite":     _spr_elite = spr_elite_naufrago; break;
                case "Paladin Marchito Elite":             _spr_elite = spr_elite_paladin_marchito; break;
                case "Errante Runico Elite":               _spr_elite = spr_elite_errante_runico; break;
            }
            if (_spr_elite != -1 && sprite_exists(_spr_elite)) return _spr_elite;
            return scr_sprite_enemigo(_nombre_base, "Común", false);
        }
    }
    
    // ── COMUNES ──
    if (_es_rostro) {
        switch (_nombre) {
            case "Soldado Igneo":                return spr_rostro_soldado_igneo;
            case "Vigia Boreal":                 return spr_rostro_vigia_boreal;
            case "Halito Verde":                 return spr_rostro_halito_verde;
            case "Bestia Tronadora":             return spr_rostro_bestia_tronadora;
            case "Guardian Terracota":           return spr_rostro_guardian_terracota;
            case "Naufrago de la Oscuridad":     return spr_rostro_naufrago;
            case "Paladin Marchito":             return spr_rostro_paladin_marchito;
            case "Errante Runico":               return spr_rostro_errante_runico;
            default:                             return spr_enemigo_rostro;
        }
    } else {
        switch (_nombre) {
            case "Soldado Igneo":                return spr_enemigo_soldado_igneo;
            case "Vigia Boreal":                 return spr_enemigo_vigia_boreal;
            case "Halito Verde":                 return spr_enemigo_halito_verde;
            case "Bestia Tronadora":             return spr_enemigo_bestia_tronadora;
            case "Guardian Terracota":           return spr_enemigo_guardian_terracota;
            case "Naufrago de la Oscuridad":     return spr_enemigo_naufrago;
            case "Paladin Marchito":             return spr_enemigo_paladin_marchito;
            case "Errante Runico":               return spr_enemigo_errante_runico;
            default:                             return spr_enemigo;
        }
    }
}
