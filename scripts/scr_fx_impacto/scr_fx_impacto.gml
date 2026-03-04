/// @file scr_fx_impacto.gml
/// @description  Sistema modular de Game Feel para impactos de combate.
///   - Camera Shake escalable por tipo de ataque
///   - Hit Stop proporcional a la fuerza del golpe
///   - Zoom dinámico al impactar (ease in-out)
///   - Partículas procedurales de golpe y curación
///
///   Todos los efectos respetan los flags FX_*_ON de scr_config_juego
///   y se escalan con FX_SHAKE_MULT / FX_ZOOM_INTENSIDAD.

// ══════════════════════════════════════════════════════════════
//  MACROS DE IMPACTO
// ══════════════════════════════════════════════════════════════
#macro FX_PART_MAX          24      // máximo de partículas simultáneas
#macro FX_PART_DURACION     20      // frames de vida base de una partícula
#macro FX_PART_VEL_MIN      1.0     // velocidad mínima de expansión
#macro FX_PART_VEL_MAX      3.5     // velocidad máxima de expansión
#macro FX_PART_SIZE_MIN     2       // tamaño mínimo (px)
#macro FX_PART_SIZE_MAX     6       // tamaño máximo (px)


// ══════════════════════════════════════════════════════════════
//  scr_fx_impacto_init()
//  Inicializa el sistema de zoom y partículas.
//  Llamar en scr_feedback_init().
// ══════════════════════════════════════════════════════════════
function scr_fx_impacto_init() {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);

    // Zoom dinámico
    _c.fx_zoom_actual   = 1.0;      // escala actual de GUI
    _c.fx_zoom_objetivo = 1.0;      // escala objetivo (1.0 = normal)

    // Partículas procedurales
    _c.fx_particulas = [];           // array de structs
}


// ══════════════════════════════════════════════════════════════
//  scr_fx_impacto_golpe(es_jugador_receptor, tipo_ataque, afinidad_atacante)
//  Dispara TODOS los efectos de impacto simultáneamente.
//
//  @param {bool}   _es_jugador   ¿Quién recibe el golpe?
//  @param {string} _tipo         "normal"|"fuerte"|"habilidad"|"super"|"critico"
//  @param {string} _afinidad     Afinidad del atacante (para color de partículas)
// ══════════════════════════════════════════════════════════════
function scr_fx_impacto_golpe(_es_jugador, _tipo, _afinidad) {
    // ── Tabla de intensidades por tipo ──
    var _shake_frames, _shake_fuerza, _hitstop_frames, _zoom_extra, _num_particulas;

    switch (_tipo) {
        case "super":
            _shake_frames  = 20;
            _shake_fuerza  = 12;
            _hitstop_frames = 10;
            _zoom_extra    = 0.06;
            _num_particulas = 12;
            break;
        case "critico":
            _shake_frames  = 14;
            _shake_fuerza  = 9;
            _hitstop_frames = 6;
            _zoom_extra    = 0.05;
            _num_particulas = 10;
            break;
        case "habilidad":
            _shake_frames  = 10;
            _shake_fuerza  = 6;
            _hitstop_frames = 4;
            _zoom_extra    = 0.03;
            _num_particulas = 7;
            break;
        case "fuerte":
            _shake_frames  = 8;
            _shake_fuerza  = 5;
            _hitstop_frames = 3;
            _zoom_extra    = 0.02;
            _num_particulas = 5;
            break;
        default: // "normal"
            _shake_frames  = 5;
            _shake_fuerza  = 3;
            _hitstop_frames = 2;
            _zoom_extra    = 0.015;
            _num_particulas = 3;
            break;
    }

    // ── Camera Shake ──
    if (FX_CAMERA_SHAKE_ON) {
        _scr_fx_camera_shake(_es_jugador, _shake_frames, _shake_fuerza);
    }

    // ── Hit Stop ──
    if (FX_HITSTOP_ON) {
        scr_fx_hitstop(_hitstop_frames);
    }

    // ── Zoom dinámico ──
    if (FX_ZOOM_IMPACTO_ON) {
        _scr_fx_zoom_in(_zoom_extra);
    }

    // ── Partículas ──
    if (FX_PARTICULAS_ON) {
        _scr_fx_particulas_spawn(_es_jugador, _num_particulas, _afinidad, "impacto");
    }
}


// ══════════════════════════════════════════════════════════════
//  scr_fx_impacto_curacion(es_jugador)
//  Efecto visual de curación: partículas ascendentes verdes.
// ══════════════════════════════════════════════════════════════
function scr_fx_impacto_curacion(_es_jugador) {
    if (!FX_FLASH_CURA_ON) return;
    if (!FX_PARTICULAS_ON) return;
    _scr_fx_particulas_spawn(_es_jugador, 6, "Planta", "curacion");
}


// ══════════════════════════════════════════════════════════════
//  CAMERA SHAKE — escalable y no acumulativo
// ══════════════════════════════════════════════════════════════
function _scr_fx_camera_shake(_es_jugador, _frames, _fuerza) {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);

    var _f = round(_frames * FX_SHAKE_MULT);
    var _p = round(_fuerza * FX_SHAKE_MULT);

    // Sacudir SOLO al personaje que recibe el golpe
    var _idx = _es_jugador ? 0 : 1;
    _c.fb_shake_timer[_idx] = max(_c.fb_shake_timer[_idx], _f);
}


// ══════════════════════════════════════════════════════════════
//  ZOOM DINÁMICO — ease in rápido, ease out suave
// ══════════════════════════════════════════════════════════════
function _scr_fx_zoom_in(_extra) {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);

    // Aplicar zoom instantáneo (snap in)
    var _zoom_target = 1.0 + (_extra * FX_ZOOM_INTENSIDAD / 0.03);
    _c.fx_zoom_actual = max(_c.fx_zoom_actual, _zoom_target);
    _c.fx_zoom_objetivo = 1.0; // siempre vuelve a 1.0
}


// ══════════════════════════════════════════════════════════════
//  scr_fx_zoom_actualizar()
//  Llamar cada frame. Interpola suavemente el zoom de vuelta a 1.0.
// ══════════════════════════════════════════════════════════════
function scr_fx_zoom_actualizar() {
    if (!instance_exists(obj_control_combate)) return;
    if (!FX_ZOOM_IMPACTO_ON) return;
    var _c = instance_find(obj_control_combate, 0);

    // Ease-out suave hacia 1.0
    _c.fx_zoom_actual = lerp(_c.fx_zoom_actual, _c.fx_zoom_objetivo, FX_ZOOM_VELOCIDAD);

    // Snap a 1.0 cuando está suficientemente cerca
    if (abs(_c.fx_zoom_actual - 1.0) < 0.001) {
        _c.fx_zoom_actual = 1.0;
    }
}


// ══════════════════════════════════════════════════════════════
//  scr_fx_zoom_aplicar()
//  Aplica la transformación de zoom centrada al GUI.
//  Llamar al INICIO del Draw GUI, antes de dibujar sprites.
// ══════════════════════════════════════════════════════════════
function scr_fx_zoom_aplicar() {
    if (!instance_exists(obj_control_combate)) return;
    if (!FX_ZOOM_IMPACTO_ON) return;
    var _c = instance_find(obj_control_combate, 0);

    if (_c.fx_zoom_actual == 1.0) return;

    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _s  = _c.fx_zoom_actual;

    // Centrar el zoom: offset para compensar escalado
    var _ox = (_gw - _gw * _s) * 0.5;
    var _oy = (_gh - _gh * _s) * 0.5;

    // Aplicar matriz de transformación GUI
    var _mat = matrix_build(_ox, _oy, 0, 0, 0, 0, _s, _s, 1);
    matrix_set(matrix_world, _mat);
}


// ══════════════════════════════════════════════════════════════
//  scr_fx_zoom_restaurar()
//  Restaurar matriz GUI a identidad.
//  Llamar al FINAL del Draw GUI.
// ══════════════════════════════════════════════════════════════
function scr_fx_zoom_restaurar() {
    if (!FX_ZOOM_IMPACTO_ON) return;
    matrix_set(matrix_world, matrix_build_identity());
}


// ══════════════════════════════════════════════════════════════
//  PARTÍCULAS PROCEDURALES — sin particle system de GM
//  Usa arrays de structs para máximo control y portabilidad.
// ══════════════════════════════════════════════════════════════

/// @function _scr_fx_particulas_spawn(es_jugador, cantidad, afinidad, modo)
/// @param {bool}   _es_jugador
/// @param {real}   _cantidad
/// @param {string} _afinidad    Para determinar color
/// @param {string} _modo        "impacto"|"curacion"
function _scr_fx_particulas_spawn(_es_jugador, _cantidad, _afinidad, _modo) {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);

    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();

    // Centro del personaje receptor
    var _cx = _es_jugador ? _gui_w * 0.22 : _gui_w * 0.78;
    var _cy = _gui_h * 0.52;

    // Color base según afinidad
    var _color1 = c_white;
    var _color2 = c_ltgray;

    if (_modo == "curacion") {
        _color1 = c_lime;
        _color2 = make_color_rgb(100, 255, 150);
    } else {
        // Color por afinidad del atacante
        switch (_afinidad) {
            case "Fuego":   _color1 = c_red;    _color2 = c_orange;  break;
            case "Agua":    _color1 = c_aqua;   _color2 = c_blue;    break;
            case "Planta":  _color1 = c_lime;   _color2 = c_green;   break;
            case "Rayo":    _color1 = c_yellow;  _color2 = c_white;  break;
            case "Tierra":  _color1 = make_color_rgb(180, 130, 50); _color2 = make_color_rgb(120, 90, 40); break;
            case "Sombra":  _color1 = make_color_rgb(100, 30, 130); _color2 = make_color_rgb(60, 10, 80);  break;
            case "Luz":     _color1 = make_color_rgb(255, 240, 180); _color2 = c_white; break;
            case "Arcano":  _color1 = make_color_rgb(140, 100, 255); _color2 = make_color_rgb(180, 130, 255); break;
            default:        _color1 = c_white;  _color2 = c_ltgray;  break;
        }
    }

    for (var _i = 0; _i < _cantidad; _i++) {
        var _angulo = random(360);
        var _vel = random_range(FX_PART_VEL_MIN, FX_PART_VEL_MAX);

        // Curacion: partículas suben; Impacto: explotan radialmente
        var _vx, _vy;
        if (_modo == "curacion") {
            _vx = random_range(-0.8, 0.8);
            _vy = -random_range(1.5, 3.0);
        } else {
            _vx = lengthdir_x(_vel, _angulo);
            _vy = lengthdir_y(_vel, _angulo);
        }

        var _part = {
            x:       _cx + random_range(-20, 20),
            y:       _cy + random_range(-15, 15),
            vx:      _vx,
            vy:      _vy,
            color:   choose(_color1, _color2),
            size:    random_range(FX_PART_SIZE_MIN, FX_PART_SIZE_MAX),
            timer:   FX_PART_DURACION + irandom(8),
            timer_max: FX_PART_DURACION + 8,
            alpha:   1.0,
            modo:    _modo,
        };

        array_push(_c.fx_particulas, _part);
    }

    // Limitar total
    while (array_length(_c.fx_particulas) > FX_PART_MAX) {
        array_delete(_c.fx_particulas, 0, 1);
    }
}


// ══════════════════════════════════════════════════════════════
//  scr_fx_particulas_actualizar()
//  Llamar cada frame en Step (después de feedback).
// ══════════════════════════════════════════════════════════════
function scr_fx_particulas_actualizar() {
    if (!instance_exists(obj_control_combate)) return;
    if (!FX_PARTICULAS_ON) return;
    var _c = instance_find(obj_control_combate, 0);

    for (var _i = array_length(_c.fx_particulas) - 1; _i >= 0; _i--) {
        var _p = _c.fx_particulas[_i];

        _p.x += _p.vx;
        _p.y += _p.vy;

        // Fricción / gravedad
        _p.vx *= 0.94;
        if (_p.modo == "curacion") {
            _p.vy *= 0.97;  // se decelera suavemente
        } else {
            _p.vy += 0.08;  // ligera gravedad en impactos
            _p.vx *= 0.92;
        }

        // Encoger con el tiempo
        _p.size *= 0.97;

        // Fade out
        _p.timer -= 1;
        var _fade_start = _p.timer_max * 0.4;
        if (_p.timer < _fade_start) {
            _p.alpha = clamp(_p.timer / _fade_start, 0, 1);
        }

        if (_p.timer <= 0 || _p.size < 0.5) {
            array_delete(_c.fx_particulas, _i, 1);
        }
    }
}


// ══════════════════════════════════════════════════════════════
//  scr_fx_particulas_dibujar()
//  Dibujar partículas activas. Llamar en Draw GUI.
// ══════════════════════════════════════════════════════════════
function scr_fx_particulas_dibujar() {
    if (!instance_exists(obj_control_combate)) return;
    if (!FX_PARTICULAS_ON) return;
    var _c = instance_find(obj_control_combate, 0);

    if (array_length(_c.fx_particulas) == 0) return;

    for (var _i = 0; _i < array_length(_c.fx_particulas); _i++) {
        var _p = _c.fx_particulas[_i];

        draw_set_alpha(_p.alpha);
        draw_set_color(_p.color);

        // Partículas de curación: círculos suaves
        // Partículas de impacto: cuadrados/rombo rotados
        if (_p.modo == "curacion") {
            draw_circle(_p.x, _p.y, _p.size, false);
        } else {
            // Rombo: cuadrado rotado 45°
            var _s = _p.size;
            draw_rectangle(_p.x - _s, _p.y - _s, _p.x + _s, _p.y + _s, false);
        }
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
}


// ══════════════════════════════════════════════════════════════
//  SISTEMA DRAMÁTICO DE FIN DE COMBATE
//  - Zoom in hacia el perdedor
//  - Flash verde (victoria) o rojo (derrota)
//  - Hitstop dramático antes de mostrar resultados
// ══════════════════════════════════════════════════════════════
#macro FIN_DRAMATICO_FRAMES    80      // duración total (~1.3s)
#macro FIN_HITSTOP_FRAMES      25      // congelamiento inicial (~0.4s)
#macro FIN_ZOOM_OBJETIVO       1.25    // zoom in hacia el perdedor (25%)
#macro FIN_ZOOM_VELOCIDAD      0.04    // velocidad de interpolación del zoom
#macro FIN_FLASH_ALPHA_MAX     0.55    // alpha máxima del flash


/// @function scr_fin_combate_init()
/// Inicializa variables del finale dramático. Llamar en Create.
function scr_fin_combate_init() {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);

    _c.fin_dramatico_timer  = 0;
    _c.fin_flash_color      = c_white;
    _c.fin_flash_alpha      = 0;
    _c.fin_hitstop_timer    = 0;
    _c.fin_activado         = false;
}


/// @function scr_fin_combate_activar(ganador)
/// Activar la secuencia dramática al finalizar combate.
/// @param {string} _ganador  "Jugador"|"Enemigo"|"Empate"
function scr_fin_combate_activar(_ganador) {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);

    if (_c.fin_activado) return; // una sola vez
    _c.fin_activado = true;

    _c.fin_dramatico_timer = FIN_DRAMATICO_FRAMES;
    _c.fin_hitstop_timer   = FIN_HITSTOP_FRAMES;

    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

    // Foco individual en el PERDEDOR (agrandar, centrar, atenuar al otro)
    var _pj_base_x = _gw * 0.22;
    var _en_base_x = _gw * 0.78;
    var _centro_x  = _gw * 0.5;

    if (_ganador == "Jugador") {
        // Ganó el jugador → perdedor (enemigo) sale por la derecha
        _c.foco_quien       = 2;
        _c.fin_flash_color  = c_red;
        _c.foco_offset_en_x_obj = _gw + 100 - _en_base_x;   // enemigo sale por derecha
        _c.foco_offset_pj_x_obj = 0;                         // jugador se queda (invisible)
    } else if (_ganador == "Enemigo") {
        // Perdió el jugador → sale por la izquierda
        _c.foco_quien       = 1;
        _c.fin_flash_color  = c_red;
        _c.foco_offset_pj_x_obj = -_pj_base_x - 200;        // jugador sale por izquierda
        _c.foco_offset_en_x_obj = 0;                         // enemigo se queda (invisible)
    } else {
        // Empate → ambos salen por sus lados
        _c.foco_quien       = 0;
        _c.fin_flash_color  = c_orange;
        _c.foco_offset_pj_x_obj = -_pj_base_x - 200;
        _c.foco_offset_en_x_obj = _gw + 100 - _en_base_x;
    }

    _c.foco_escala_obj  = FIN_ZOOM_OBJETIVO;    // 1.25
    _c.foco_dim_obj     = 0.0;                  // ganador desaparece completamente
    _c.foco_vel         = FIN_ZOOM_VELOCIDAD;   // 0.04

    _c.fin_flash_alpha = FIN_FLASH_ALPHA_MAX;
}


/// @function scr_fin_combate_actualizar()
/// Llamar cada frame en Step. Retorna TRUE si está en secuencia dramática.
function scr_fin_combate_actualizar() {
    if (!instance_exists(obj_control_combate)) return false;
    var _c = instance_find(obj_control_combate, 0);

    if (_c.fin_dramatico_timer <= 0) return false;

    // Hitstop inicial: congelar todo
    if (_c.fin_hitstop_timer > 0) {
        _c.fin_hitstop_timer -= 1;
        // Durante hitstop: foco se aplica rápidamente
        _c.foco_vel = 0.15;
        return true;
    }

    // Fase de flash
    _c.fin_dramatico_timer -= 1;

    // Flash se desvanece
    _c.fin_flash_alpha = lerp(_c.fin_flash_alpha, 0, 0.03);

    // Al final del timer, restaurar foco y offsets
    if (_c.fin_dramatico_timer <= 0) {
        _c.fin_flash_alpha = 0;
        _c.foco_quien       = 0;
        _c.foco_escala_obj  = 1.0;
        _c.foco_dim_obj     = 1.0;
        _c.foco_offset_pj_x_obj = 0;
        _c.foco_offset_en_x_obj = 0;
    }

    return (_c.fin_dramatico_timer > 0);
}


/// @function scr_fin_combate_zoom_aplicar()
/// DESACTIVADO — El énfasis ahora es individual por sprite.
function scr_fin_combate_zoom_aplicar() {
    // No-op: se usa sistema de foco individual
}


/// @function scr_fin_combate_zoom_restaurar()
/// DESACTIVADO — El énfasis ahora es individual por sprite.
function scr_fin_combate_zoom_restaurar() {
    // No-op: se usa sistema de foco individual
}


/// @function scr_fin_combate_dibujar_flash()
/// Dibuja el flash de color (verde/rojo) sobre toda la pantalla.
/// Llamar en Draw GUI.
function scr_fin_combate_dibujar_flash() {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);

    if (!_c.fin_activado || _c.fin_flash_alpha <= 0.01) return;

    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

    draw_set_color(_c.fin_flash_color);
    draw_set_alpha(_c.fin_flash_alpha);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}
