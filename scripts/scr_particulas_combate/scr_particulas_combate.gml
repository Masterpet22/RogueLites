/// @file scr_particulas_combate.gml
/// @description  Sistema de partículas extendido para combate.
///   Complementa scr_fx_impacto con tipos adicionales:
///     - Estela elemental (trail detrás de ataques)
///     - Chispas de esencia (al cargar medidor)
///     - Partículas de muerte (al morir un personaje)
///     - Lluvia ambiental elemental (decorativa según afinidad)
///   Usa el mismo sistema de array-of-structs de scr_fx_impacto.

#macro PART_TRAIL_MAX       16     // máximo de partículas de estela
#macro PART_ESENCIA_MAX     20     // máximo de chispas de esencia
#macro PART_MUERTE_NUM      18     // número de partículas al morir
#macro PART_AMBIENT_MAX     12     // máximo de partículas ambientales


// ══════════════════════════════════════════════════════════════
//  scr_particulas_init()
//  Inicializa arrays extra de partículas.
//  Llamar en obj_control_combate Create_0 (después de scr_fx_impacto_init).
// ══════════════════════════════════════════════════════════════
function scr_particulas_init() {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);

    _c.part_trail    = [];   // estela de ataques
    _c.part_esencia  = [];   // chispas de carga de esencia
    _c.part_muerte   = [];   // explosión de muerte
    _c.part_ambient  = [];   // partículas ambientales decorativas
}


// ══════════════════════════════════════════════════════════════
//  ESTELA ELEMENTAL (Trail)
//  Se emite durante la animación de ataque.
// ══════════════════════════════════════════════════════════════

/// @function scr_part_trail_emitir(x, y, afinidad, cantidad)
function scr_part_trail_emitir(_px, _py, _afinidad, _cantidad) {
    if (!instance_exists(obj_control_combate)) return;
    if (!FX_PARTICULAS_ON) return;
    var _c = instance_find(obj_control_combate, 0);

    var _colores = scr_part_colores_afinidad(_afinidad);

    for (var _i = 0; _i < _cantidad; _i++) {
        var _p = {
            x:     _px + random_range(-8, 8),
            y:     _py + random_range(-8, 8),
            vx:    random_range(-0.5, 0.5),
            vy:    random_range(-1.5, -0.3),
            color: choose(_colores[0], _colores[1]),
            size:  random_range(2, 5),
            timer: 15 + irandom(10),
            timer_max: 25,
            alpha: 0.8,
            tipo:  "trail",
        };
        array_push(_c.part_trail, _p);
    }

    while (array_length(_c.part_trail) > PART_TRAIL_MAX) {
        array_delete(_c.part_trail, 0, 1);
    }
}


// ══════════════════════════════════════════════════════════════
//  CHISPAS DE ESENCIA
//  Se emiten cuando el medidor de esencia sube.
// ══════════════════════════════════════════════════════════════

/// @function scr_part_esencia_emitir(x, y, cantidad)
function scr_part_esencia_emitir(_px, _py, _cantidad) {
    if (!instance_exists(obj_control_combate)) return;
    if (!FX_PARTICULAS_ON) return;
    var _c = instance_find(obj_control_combate, 0);

    for (var _i = 0; _i < _cantidad; _i++) {
        var _ang = random(360);
        var _vel = random_range(1.0, 2.5);
        var _p = {
            x:     _px + random_range(-5, 5),
            y:     _py + random_range(-5, 5),
            vx:    lengthdir_x(_vel, _ang),
            vy:    lengthdir_y(_vel, _ang) - 0.5,
            color: choose(
                make_color_rgb(255, 220, 100),  // dorado
                make_color_rgb(255, 180, 50),   // ámbar
                c_white
            ),
            size:  random_range(1.5, 3.5),
            timer: 18 + irandom(8),
            timer_max: 26,
            alpha: 1.0,
            tipo:  "esencia",
        };
        array_push(_c.part_esencia, _p);
    }

    while (array_length(_c.part_esencia) > PART_ESENCIA_MAX) {
        array_delete(_c.part_esencia, 0, 1);
    }
}


// ══════════════════════════════════════════════════════════════
//  PARTÍCULAS DE MUERTE
//  Explosión al morir un personaje.
// ══════════════════════════════════════════════════════════════

/// @function scr_part_muerte_emitir(x, y, afinidad)
function scr_part_muerte_emitir(_px, _py, _afinidad) {
    if (!instance_exists(obj_control_combate)) return;
    if (!FX_PARTICULAS_ON) return;
    var _c = instance_find(obj_control_combate, 0);

    var _colores = scr_part_colores_afinidad(_afinidad);

    for (var _i = 0; _i < PART_MUERTE_NUM; _i++) {
        var _ang = random(360);
        var _vel = random_range(2.0, 5.0);
        var _p = {
            x:     _px + random_range(-10, 10),
            y:     _py + random_range(-10, 10),
            vx:    lengthdir_x(_vel, _ang),
            vy:    lengthdir_y(_vel, _ang),
            color: choose(_colores[0], _colores[1], c_dkgray),
            size:  random_range(3, 7),
            timer: 30 + irandom(15),
            timer_max: 45,
            alpha: 1.0,
            tipo:  "muerte",
        };
        array_push(_c.part_muerte, _p);
    }
}


// ══════════════════════════════════════════════════════════════
//  LLUVIA AMBIENTAL ELEMENTAL
//  Partículas decorativas que caen según la afinidad del enemigo.
// ══════════════════════════════════════════════════════════════

/// @function scr_part_ambient_emitir(afinidad)
/// Se llama periódicamente (cada ~30 frames) para generar ambiente.
function scr_part_ambient_emitir(_afinidad) {
    if (!instance_exists(obj_control_combate)) return;
    if (!FX_PARTICULAS_ON) return;
    var _c = instance_find(obj_control_combate, 0);

    if (array_length(_c.part_ambient) >= PART_AMBIENT_MAX) return;

    var _gw = display_get_gui_width();
    var _colores = scr_part_colores_afinidad(_afinidad);

    // Generar 1-2 partículas desde la parte superior
    var _num = irandom_range(1, 2);
    for (var _i = 0; _i < _num; _i++) {
        var _p = {
            x:     random(_gw),
            y:     -5,
            vx:    random_range(-0.3, 0.3),
            vy:    random_range(0.3, 1.0),
            color: choose(_colores[0], _colores[1]),
            size:  random_range(1, 3),
            timer: 120 + irandom(60),
            timer_max: 180,
            alpha: 0.4,
            tipo:  "ambient",
        };
        array_push(_c.part_ambient, _p);
    }
}


// ══════════════════════════════════════════════════════════════
//  ACTUALIZAR TODAS LAS PARTÍCULAS EXTENDIDAS
// ══════════════════════════════════════════════════════════════

/// @function scr_particulas_actualizar()
function scr_particulas_actualizar() {
    if (!instance_exists(obj_control_combate)) return;
    if (!FX_PARTICULAS_ON) return;
    var _c = instance_find(obj_control_combate, 0);

    // Actualizar los 4 arrays de partículas
    _scr_part_array_update(_c.part_trail);
    _scr_part_array_update(_c.part_esencia);
    _scr_part_array_update(_c.part_muerte);
    _scr_part_array_update(_c.part_ambient);
}

/// @function _scr_part_array_update(arr)
/// @description Física y limpieza genérica de un array de partículas.
function _scr_part_array_update(_arr) {
    for (var _i = array_length(_arr) - 1; _i >= 0; _i--) {
        var _p = _arr[_i];

        _p.x += _p.vx;
        _p.y += _p.vy;

        // Física por tipo
        switch (_p.tipo) {
            case "trail":
                _p.vx *= 0.90;
                _p.vy *= 0.90;
                _p.size *= 0.95;
                break;
            case "esencia":
                _p.vx *= 0.92;
                _p.vy -= 0.03; // flotar hacia arriba ligeramente
                _p.size *= 0.96;
                break;
            case "muerte":
                _p.vx *= 0.93;
                _p.vy += 0.12; // gravedad fuerte
                _p.size *= 0.97;
                break;
            case "ambient":
                _p.vx += random_range(-0.05, 0.05); // deriva suave
                _p.vy *= 0.99;
                break;
        }

        // Fade out
        _p.timer--;
        var _fade_start = _p.timer_max * 0.35;
        if (_p.timer < _fade_start) {
            _p.alpha = clamp(_p.timer / _fade_start, 0, 1);
        }

        if (_p.timer <= 0 || _p.size < 0.3) {
            array_delete(_arr, _i, 1);
        }
    }
}


// ══════════════════════════════════════════════════════════════
//  DIBUJAR TODAS LAS PARTÍCULAS EXTENDIDAS
// ══════════════════════════════════════════════════════════════

/// @function scr_particulas_dibujar()
/// @description Dibuja TODAS las partículas extendidas (ambientales + sobre sprites).
function scr_particulas_dibujar() {
    scr_particulas_dibujar_bajo();
    scr_particulas_dibujar_sobre();
}

/// @function scr_particulas_dibujar_bajo()
/// @description Dibuja partículas que van DEBAJO de los sprites (ambientales).
function scr_particulas_dibujar_bajo() {
    if (!instance_exists(obj_control_combate)) return;
    if (!FX_PARTICULAS_ON) return;
    var _c = instance_find(obj_control_combate, 0);

    _scr_part_array_draw(_c.part_ambient);
}

/// @function scr_particulas_dibujar_sobre()
/// @description Dibuja partículas que van ENCIMA de los sprites (trail, esencia, muerte).
function scr_particulas_dibujar_sobre() {
    if (!instance_exists(obj_control_combate)) return;
    if (!FX_PARTICULAS_ON) return;
    var _c = instance_find(obj_control_combate, 0);

    _scr_part_array_draw(_c.part_trail);
    _scr_part_array_draw(_c.part_esencia);
    _scr_part_array_draw(_c.part_muerte);
}

/// @function _scr_part_array_draw(arr)
function _scr_part_array_draw(_arr) {
    for (var _i = 0; _i < array_length(_arr); _i++) {
        var _p = _arr[_i];
        draw_set_alpha(_p.alpha);
        draw_set_color(_p.color);

        if (_p.tipo == "esencia" || _p.tipo == "ambient") {
            draw_circle(_p.x, _p.y, _p.size, false);
        } else if (_p.tipo == "muerte") {
            // Triángulos irregulares (fragmentos)
            var _s = _p.size;
            draw_triangle(_p.x, _p.y - _s,
                          _p.x - _s, _p.y + _s * 0.6,
                          _p.x + _s * 0.8, _p.y + _s * 0.4,
                          false);
        } else {
            // Trail: rectángulos alargados
            var _s = _p.size;
            draw_rectangle(_p.x - _s * 0.5, _p.y - _s,
                           _p.x + _s * 0.5, _p.y + _s, false);
        }
    }
    draw_set_alpha(1);
    draw_set_color(c_white);
}


// ══════════════════════════════════════════════════════════════
//  UTILIDAD: Colores por afinidad (para partículas)
// ══════════════════════════════════════════════════════════════

/// @function scr_part_colores_afinidad(afinidad)
/// @returns {array} [color1, color2]
function scr_part_colores_afinidad(_afinidad) {
    switch (_afinidad) {
        case "Fuego":      return [c_red, c_orange];
        case "Agua":       return [c_aqua, c_blue];
        case "Planta":     return [c_lime, c_green];
        case "Rayo":       return [c_yellow, c_white];
        case "Tierra":     return [make_color_rgb(180, 130, 50), make_color_rgb(120, 90, 40)];
        case "Sombra":     return [make_color_rgb(100, 30, 130), make_color_rgb(60, 10, 80)];
        case "Luz":        return [make_color_rgb(255, 240, 180), c_white];
        case "Oscuridad":  return [make_color_rgb(80, 20, 100), make_color_rgb(40, 10, 50)];
        case "Arcano":     return [make_color_rgb(140, 100, 255), make_color_rgb(180, 130, 255)];
        case "Viento":     return [make_color_rgb(130, 230, 160), make_color_rgb(200, 255, 220)];
        default:           return [c_white, c_ltgray]; // Neutra
    }
}
