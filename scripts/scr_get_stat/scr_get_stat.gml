/// @function scr_get_stat(personaje, stat_id)
/// @description Devuelve el valor numérico de una stat del personaje dado su ID string.
///   - "ataque"      → ataque_base
///   - "defensa"     → defensa_base + defensa_bonus_temp
///   - "velocidad"   → velocidad
///   - "poder"       → poder_elemental
///   - "vida_max"    → vida_max
///   - "vida_actual" → vida_actual
///   - "ninguno"     → 0

function scr_get_stat(_personaje, _stat_id) {

    switch (_stat_id) {
        case "ataque":      return _personaje.ataque_base;
        case "defensa":     return _personaje.defensa_base + _personaje.defensa_bonus_temp;
        case "defensa_magica": return _personaje.defensa_magica_base + _personaje.defensa_magica_bonus_temp;
        case "velocidad":   return _personaje.velocidad;
        case "poder":       return _personaje.poder_elemental;
        case "vida_max":    return _personaje.vida_max;
        case "vida_actual": return _personaje.vida_actual;
        case "ninguno":     return 0;
    }

    show_debug_message("scr_get_stat: Stat desconocida: " + string(_stat_id));
    return 0;
}
