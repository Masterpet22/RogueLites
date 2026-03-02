/// scr_sprite_personaje(nombre, es_rostro)
/// Devuelve el sprite correspondiente al personaje jugable.
/// Si es_rostro es true, devuelve el retrato; si no, el cuerpo completo.
/// Fallback a spr_jugador / spr_jugador_rostro si no existe.
function scr_sprite_personaje(_nombre, _es_rostro) {
    
    if (_es_rostro) {
        switch (_nombre) {
            case "Kael":    return spr_rostro_kael;
            case "Lys":     return spr_rostro_lys;
            case "Torvan":  return spr_rostro_torvan;
            case "Maelis":  return spr_rostro_maelis;
            case "Saren":   return spr_rostro_saren;
            case "Nerya":   return spr_rostro_nerya;
            case "Thalys":  return spr_rostro_thalys;
            case "Brenn":   return spr_rostro_brenn;
            default:        return spr_jugador_rostro;
        }
    } else {
        switch (_nombre) {
            case "Kael":    return spr_jugador_kael;
            case "Lys":     return spr_jugador_lys;
            case "Torvan":  return spr_jugador_torvan;
            case "Maelis":  return spr_jugador_maelis;
            case "Saren":   return spr_jugador_saren;
            case "Nerya":   return spr_jugador_nerya;
            case "Thalys":  return spr_jugador_thalys;
            case "Brenn":   return spr_jugador_brenn;
            default:        return spr_jugador;
        }
    }
}
