/// scr_aplicar_estado(personaje, id_estado, duracion_frames, potencia_extra)
function scr_aplicar_estado(_p, _id, _duracion, _pot_extra) {

    var conf = scr_datos_estados(_id);
    if (conf == undefined) return;

    // Tope global de duración: ningún estado dura más de ESTADO_DUR_MAX_SEG
    var _dur_max = round(GAME_FPS * ESTADO_DUR_MAX_SEG);
    _duracion = min(_duracion, _dur_max);

    // Inicializar array de estados si hace falta
    if (!is_array(_p.estados)) {
        _p.estados = [];
    }

    // ¿Ya existe este estado en el personaje? → refrescar
    var n = array_length(_p.estados);
    for (var i = 0; i < n; i++) {
        var est = _p.estados[i];
        if (est.activo && est.id == _id) {
            est.tiempo_rest = _duracion;
            est.potencia    = (variable_struct_exists(conf, "potencia_base") ? conf.potencia_base : 0) + _pot_extra;
            est.tick_timer  = (variable_struct_exists(conf, "tick_interval") ? conf.tick_interval : 0);
            _p.estados[i]   = est;
            return;
        }
    }

    // No existe aún → crearlo
    var nuevo = {
        id:           _id,
        tipo:         conf.tipo,
        tiempo_rest:  _duracion,
        activo:       true,

        // dot
        tick_interval: (variable_struct_exists(conf, "tick_interval") ? conf.tick_interval : 0),
        tick_timer:    (variable_struct_exists(conf, "tick_interval") ? conf.tick_interval : 0),
        potencia:      (variable_struct_exists(conf, "potencia_base") ? conf.potencia_base : 0) + _pot_extra,

        // buff defensa
        defensa_bonus: (variable_struct_exists(conf, "defensa_bonus") ? conf.defensa_bonus : 0),

        // buff defensa mágica
        defensa_magica_bonus: (variable_struct_exists(conf, "defensa_magica_bonus") ? conf.defensa_magica_bonus : 0),

        // buff velocidad
        velocidad_bonus: (variable_struct_exists(conf, "velocidad_bonus") ? conf.velocidad_bonus : 0),

        // debuffs
        velocidad_penalty: (variable_struct_exists(conf, "velocidad_penalty") ? conf.velocidad_penalty : 0),
        defensa_penalty:   (variable_struct_exists(conf, "defensa_penalty")   ? conf.defensa_penalty   : 0),
        poder_penalty:     (variable_struct_exists(conf, "poder_penalty")     ? conf.poder_penalty     : 0),
    };

    // Aplicar efectos inmediatos de ciertos estados (ej: buff defensa)
    if (nuevo.tipo == "buff_defensa" && nuevo.defensa_bonus != 0) {
        _p.defensa_bonus_temp += nuevo.defensa_bonus;
    }
    if (nuevo.tipo == "buff_defensa_magica" && nuevo.defensa_magica_bonus != 0) {
        _p.defensa_magica_bonus_temp += nuevo.defensa_magica_bonus;
    }
    if (nuevo.tipo == "buff_velocidad" && nuevo.velocidad_bonus != 0) {
        _p.velocidad += nuevo.velocidad_bonus;
    }
    if (nuevo.tipo == "debuff_velocidad" && nuevo.velocidad_penalty != 0) {
        _p.velocidad = max(1, _p.velocidad - nuevo.velocidad_penalty);
    }
    if (nuevo.tipo == "debuff_defensa" && nuevo.defensa_penalty != 0) {
        _p.defensa_bonus_temp -= nuevo.defensa_penalty;
    }
    if (nuevo.tipo == "debuff_poder" && nuevo.poder_penalty != 0) {
        _p.poder_elemental = max(0, _p.poder_elemental - nuevo.poder_penalty);
    }

    array_push(_p.estados, nuevo);
}