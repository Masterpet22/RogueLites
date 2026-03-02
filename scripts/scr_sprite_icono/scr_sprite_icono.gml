/// @func scr_sprite_icono_estado(_id_estado)
/// @desc Devuelve el sprite de icono para un estado alterado
/// @param {string} _id_estado  ID del estado (ej: "quemadura_fuego")
/// @returns {Asset.GMSprite}
function scr_sprite_icono_estado(_id_estado) {
    switch (_id_estado) {
        case "quemadura_fuego":     return spr_ico_quemadura;
        case "veneno":              return spr_ico_veneno;
        case "regeneracion":        return spr_ico_regeneracion;
        case "muro_tierra":         return spr_ico_muro_tierra;
        case "aceleracion_rayo":    return spr_ico_aceleracion;
        case "ralentizacion":       return spr_ico_ralentizacion;
        case "vulnerabilidad":      return spr_ico_vulnerabilidad;
        case "supresion_arcana":    return spr_ico_supresion;
        default:                    return -1;
    }
}

/// @func scr_sprite_icono_objeto(_nombre_obj)
/// @desc Devuelve el sprite de icono para un objeto consumible
/// @param {string} _nombre_obj  Nombre del objeto (ej: "Pocion Basica")
/// @returns {Asset.GMSprite}
function scr_sprite_icono_objeto(_nombre_obj) {
    switch (_nombre_obj) {
        case "Pocion Basica":       return spr_ico_pocion_basica;
        case "Pocion Media":        return spr_ico_pocion_media;
        case "Elixir de Esencia":   return spr_ico_elixir_esencia;
        case "Tonico de Ataque":    return spr_ico_tonico_ataque;
        case "Tonico de Defensa":   return spr_ico_tonico_defensa;
        default:                    return -1;
    }
}

/// @func scr_sprite_icono_runa(_nombre_runa)
/// @desc Devuelve el sprite de icono para un objeto rúnico
/// @param {string} _nombre_runa  Nombre de la runa (ej: "Runa de Furia")
/// @returns {Asset.GMSprite}
function scr_sprite_icono_runa(_nombre_runa) {
    switch (_nombre_runa) {
        case "Runa de Furia":           return spr_ico_runa_furia;
        case "Runa de Fortaleza":       return spr_ico_runa_fortaleza;
        case "Runa de Celeridad":       return spr_ico_runa_celeridad;
        case "Runa del Ultimo Aliento": return spr_ico_runa_ultimo_aliento;
        case "Runa Vampirica":          return spr_ico_runa_vampirica;
        case "Runa de Cristal":         return spr_ico_runa_cristal;
        default:                        return -1;
    }
}

/// @func scr_sprite_icono_afinidad(_nombre_afinidad)
/// @desc Devuelve el sprite de icono para una afinidad elemental
/// @param {string} _nombre_afinidad  Nombre de la afinidad (ej: "Fuego")
/// @returns {Asset.GMSprite}
function scr_sprite_icono_afinidad(_nombre_afinidad) {
    switch (_nombre_afinidad) {
        case "Fuego":   return spr_ico_afinidad_fuego;
        case "Agua":    return spr_ico_afinidad_agua;
        case "Planta":  return spr_ico_afinidad_planta;
        case "Rayo":    return spr_ico_afinidad_rayo;
        case "Tierra":  return spr_ico_afinidad_tierra;
        case "Sombra":  return spr_ico_afinidad_sombra;
        case "Luz":     return spr_ico_afinidad_luz;
        case "Arcano":  return spr_ico_afinidad_arcano;
        default:        return -1;
    }
}
