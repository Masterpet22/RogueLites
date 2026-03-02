/// @file scr_feedback_combate.gml
/// @description  Sistema de feedback visual para combate:
///   - Números flotantes de daño/curación/buffs
///   - Sacudida (shake) de sprites al recibir daño
///   - Flash de color en sprites al recibir efectos
///   - Tracking automático de cambios de vida para generar feedback

// ══════════════════════════════════════════════════════════════
//  MACROS DE FEEDBACK
// ══════════════════════════════════════════════════════════════
#macro FB_DURACION        50      // frames que dura un número flotante (~0.83s a 60fps)
#macro FB_VEL_Y          -1.2     // velocidad vertical (sube)
#macro FB_MAX             12      // máximo de números flotantes simultáneos
#macro FB_SHAKE_FRAMES    12      // duración del shake en frames
#macro FB_SHAKE_FUERZA    6       // píxeles máximos de desplazamiento
#macro FB_FLASH_FRAMES    10      // duración del flash de color
#macro FB_CRIT_ESCALA     1.5     // escala del texto en crítico


// ══════════════════════════════════════════════════════════════
//  scr_feedback_init()
//  Llamar en el Create del controlador de combate.
// ══════════════════════════════════════════════════════════════
function scr_feedback_init() {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);

    // Array de números flotantes
    _c.feedbacks = [];

    // Vida previa para detección automática de cambios
    _c.fb_pj_vida_prev = _c.personaje_jugador.vida_actual;
    _c.fb_en_vida_prev = _c.personaje_enemigo.vida_actual;

    // Shake por personaje (0 = jugador, 1 = enemigo)
    _c.fb_shake_timer   = [0, 0];
    _c.fb_shake_offset_x = [0, 0];
    _c.fb_shake_offset_y = [0, 0];

    // Flash por personaje
    _c.fb_flash_timer = [0, 0];
    _c.fb_flash_color = [c_white, c_white];
}


// ══════════════════════════════════════════════════════════════
//  scr_feedback_agregar(es_jugador, valor, tipo)
//  Agrega un número flotante sobre el sprite del personaje.
//
//  @param {bool}   _es_jugador   true = jugador, false = enemigo
//  @param {real}   _valor        cantidad numérica (positiva)
//  @param {string} _tipo         "dano" | "cura" | "buff" | "debuff" | "critico" | "esencia"
// ══════════════════════════════════════════════════════════════
function scr_feedback_agregar(_es_jugador, _valor, _tipo) {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);

    // Determinar color y prefijo según tipo
    var _color = c_white;
    var _prefijo = "";
    var _escala = 1.0;

    switch (_tipo) {
        case "dano":
            _color = _es_jugador ? c_red : c_yellow;
            _prefijo = "-";
            break;
        case "cura":
            _color = c_lime;
            _prefijo = "+";
            break;
        case "buff":
            _color = c_aqua;
            _prefijo = "+";
            break;
        case "debuff":
            _color = c_orange;
            _prefijo = "-";
            break;
        case "critico":
            _color = make_color_rgb(255, 215, 0); // dorado
            _prefijo = "CRIT -";
            _escala = FB_CRIT_ESCALA;
            break;
        case "esencia":
            _color = make_color_rgb(140, 100, 255); // púrpura
            _prefijo = "+";
            break;
        default:
            _color = c_white;
            _prefijo = "";
            break;
    }

    // Posición GUI base según quién recibe el efecto
    //   Jugador body sprite: centrado en ~250, ~400
    //   Enemigo body sprite: centrado en ~1030, ~400
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    var _base_x, _base_y;
    if (_es_jugador) {
        _base_x = _gui_w * 0.22;
        _base_y = _gui_h * 0.48;
    } else {
        _base_x = _gui_w * 0.78;
        _base_y = _gui_h * 0.48;
    }

    // Pequeño offset aleatorio horizontal para que no se apilen exactamente
    _base_x += random_range(-20, 20);

    var _fb = {
        x:         _base_x,
        y:         _base_y,
        valor:     _valor,
        tipo:      _tipo,
        texto:     _prefijo + string(_valor),
        color:     _color,
        escala:    _escala,
        timer:     FB_DURACION,
        alpha:     1.0,
        vel_y:     FB_VEL_Y,
    };

    array_push(_c.feedbacks, _fb);

    // Limitar máximo
    while (array_length(_c.feedbacks) > FB_MAX) {
        array_delete(_c.feedbacks, 0, 1);
    }
}


// ══════════════════════════════════════════════════════════════
//  scr_feedback_sacudir(es_jugador)
//  Inicia efecto de sacudida en el sprite del personaje.
// ══════════════════════════════════════════════════════════════
function scr_feedback_sacudir(_es_jugador) {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);
    var _idx = _es_jugador ? 0 : 1;
    _c.fb_shake_timer[_idx] = FB_SHAKE_FRAMES;
}


// ══════════════════════════════════════════════════════════════
//  scr_feedback_flash(es_jugador, color)
//  Inicia un flash de color en el sprite del personaje.
// ══════════════════════════════════════════════════════════════
function scr_feedback_flash(_es_jugador, _color) {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);
    var _idx = _es_jugador ? 0 : 1;
    _c.fb_flash_timer[_idx] = FB_FLASH_FRAMES;
    _c.fb_flash_color[_idx] = _color;
}


// ══════════════════════════════════════════════════════════════
//  scr_feedback_actualizar()
//  Llamar 1 vez por frame en el Step del controlador de combate.
//  Actualiza números flotantes, shakes, y genera feedback automático.
// ══════════════════════════════════════════════════════════════
function scr_feedback_actualizar() {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);

    // ── Actualizar números flotantes ──
    var _arr = _c.feedbacks;
    for (var i = array_length(_arr) - 1; i >= 0; i--) {
        _arr[i].timer -= 1;
        _arr[i].y += _arr[i].vel_y;

        // Desacelerar subida
        _arr[i].vel_y *= 0.97;

        // Fade-out en el último 30%
        var _fade_start = FB_DURACION * 0.30;
        if (_arr[i].timer < _fade_start) {
            _arr[i].alpha = clamp(_arr[i].timer / _fade_start, 0, 1);
        }

        // Eliminar cuando expira
        if (_arr[i].timer <= 0) {
            array_delete(_arr, i, 1);
        }
    }

    // ── Actualizar shake ──
    for (var _s = 0; _s < 2; _s++) {
        if (_c.fb_shake_timer[_s] > 0) {
            _c.fb_shake_timer[_s] -= 1;
            var _intensity = FB_SHAKE_FUERZA * (_c.fb_shake_timer[_s] / FB_SHAKE_FRAMES);
            _c.fb_shake_offset_x[_s] = random_range(-_intensity, _intensity);
            _c.fb_shake_offset_y[_s] = random_range(-_intensity, _intensity);
        } else {
            _c.fb_shake_offset_x[_s] = 0;
            _c.fb_shake_offset_y[_s] = 0;
        }
    }

    // ── Actualizar flash ──
    for (var _f = 0; _f < 2; _f++) {
        if (_c.fb_flash_timer[_f] > 0) {
            _c.fb_flash_timer[_f] -= 1;
        }
    }

    // ── Detección automática de cambios de vida ──
    var _pj = _c.personaje_jugador;
    var _en = _c.personaje_enemigo;

    // Jugador
    var _pj_diff = _c.fb_pj_vida_prev - _pj.vida_actual;
    if (_pj_diff > 0) {
        // Jugador recibió daño
        scr_feedback_agregar(true, _pj_diff, "dano");
        scr_feedback_sacudir(true);
        scr_feedback_flash(true, c_red);
    } else if (_pj_diff < 0) {
        // Jugador se curó
        scr_feedback_agregar(true, abs(_pj_diff), "cura");
        scr_feedback_flash(true, c_lime);
    }
    _c.fb_pj_vida_prev = _pj.vida_actual;

    // Enemigo
    var _en_diff = _c.fb_en_vida_prev - _en.vida_actual;
    if (_en_diff > 0) {
        // Enemigo recibió daño
        scr_feedback_agregar(false, _en_diff, "dano");
        scr_feedback_sacudir(false);
        scr_feedback_flash(false, c_red);
    } else if (_en_diff < 0) {
        // Enemigo se curó
        scr_feedback_agregar(false, abs(_en_diff), "cura");
        scr_feedback_flash(false, c_lime);
    }
    _c.fb_en_vida_prev = _en.vida_actual;
}


// ══════════════════════════════════════════════════════════════
//  scr_feedback_dibujar()
//  Dibuja todos los números flotantes activos en pantalla GUI.
//  Llamar en el Draw GUI del controlador de UI.
// ══════════════════════════════════════════════════════════════
function scr_feedback_dibujar() {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);
    var _arr = _c.feedbacks;

    if (array_length(_arr) == 0) return;

    draw_set_font(fnt_1);

    for (var i = 0; i < array_length(_arr); i++) {
        var _fb = _arr[i];

        // Sombra del texto (outline negro para legibilidad)
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_alpha(_fb.alpha);

        // Escalar texto
        var _sx = _fb.escala;
        var _sy = _fb.escala;

        // Sombra negra (offset 1px en 4 direcciones)
        draw_set_color(c_black);
        draw_text_transformed(_fb.x + 1, _fb.y + 1, _fb.texto, _sx, _sy, 0);
        draw_text_transformed(_fb.x - 1, _fb.y - 1, _fb.texto, _sx, _sy, 0);
        draw_text_transformed(_fb.x + 1, _fb.y - 1, _fb.texto, _sx, _sy, 0);
        draw_text_transformed(_fb.x - 1, _fb.y + 1, _fb.texto, _sx, _sy, 0);

        // Texto principal
        draw_set_color(_fb.color);
        draw_text_transformed(_fb.x, _fb.y, _fb.texto, _sx, _sy, 0);
    }

    // Restaurar
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}


// ══════════════════════════════════════════════════════════════
//  scr_feedback_dibujar_sprites()
//  Dibuja los sprites de cuerpo completo del jugador y enemigo
//  en el centro de la pantalla con efectos de shake y flash.
//  Llamar en el Draw GUI del controlador de UI.
// ══════════════════════════════════════════════════════════════
function scr_feedback_dibujar_sprites() {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);

    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();

    // Posiciones base de los sprites de cuerpo
    var _pj_x = _gui_w * 0.22;
    var _pj_y = _gui_h * 0.55;
    var _en_x = _gui_w * 0.78;
    var _en_y = _gui_h * 0.55;

    // Escala: sprite es 128x128, queremos ~200px de alto
    var _escala = 1.8;

    // ── JUGADOR BODY SPRITE ──
    {
        var _sx = _pj_x + _c.fb_shake_offset_x[0];
        var _sy = _pj_y + _c.fb_shake_offset_y[0];

        // Flash de color
        var _blend = c_white;
        var _alpha = 1.0;
        if (_c.fb_flash_timer[0] > 0) {
            var _flash_ratio = _c.fb_flash_timer[0] / FB_FLASH_FRAMES;
            _blend = merge_color(c_white, _c.fb_flash_color[0], _flash_ratio * 0.7);
            // Parpadeo rápido
            if (_c.fb_flash_timer[0] mod 3 == 0) {
                _alpha = 0.5;
            }
        }

        draw_sprite_ext(spr_jugador, 0, _sx, _sy, _escala, _escala, 0, _blend, _alpha);
    }

    // ── ENEMIGO BODY SPRITE ──
    {
        var _sx = _en_x + _c.fb_shake_offset_x[1];
        var _sy = _en_y + _c.fb_shake_offset_y[1];

        // Flash de color
        var _blend = c_white;
        var _alpha = 1.0;
        if (_c.fb_flash_timer[1] > 0) {
            var _flash_ratio = _c.fb_flash_timer[1] / FB_FLASH_FRAMES;
            _blend = merge_color(c_white, _c.fb_flash_color[1], _flash_ratio * 0.7);
            if (_c.fb_flash_timer[1] mod 3 == 0) {
                _alpha = 0.5;
            }
        }

        draw_sprite_ext(spr_enemigo, 0, _sx, _sy, _escala, _escala, 0, _blend, _alpha);
    }
}


// ══════════════════════════════════════════════════════════════
//  scr_feedback_dibujar_retrato(es_jugador, x, y, tamaño)
//  Dibuja el retrato (rostro) con shake y flash integrados.
//  Reemplaza los placeholders rectangulares del Draw GUI.
// ══════════════════════════════════════════════════════════════
function scr_feedback_dibujar_retrato(_es_jugador, _rx, _ry, _tam) {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);
    var _idx = _es_jugador ? 0 : 1;
    var _spr = _es_jugador ? spr_jugador_rostro : spr_enemigo_rostro;

    // Escala del sprite (128x128 → _tam x _tam)
    var _escala = _tam / 128;

    // Aplicar shake al retrato también (más sutil)
    var _offset_x = _c.fb_shake_offset_x[_idx] * 0.4;
    var _offset_y = _c.fb_shake_offset_y[_idx] * 0.4;

    // Flash de color
    var _blend = c_white;
    var _alpha_spr = 1.0;
    if (_c.fb_flash_timer[_idx] > 0) {
        var _flash_ratio = _c.fb_flash_timer[_idx] / FB_FLASH_FRAMES;
        _blend = merge_color(c_white, _c.fb_flash_color[_idx], _flash_ratio * 0.6);
    }

    // Marco del retrato (borde de color según jugador/enemigo)
    var _marco_col = _es_jugador ? make_color_rgb(60, 120, 200) : make_color_rgb(200, 60, 60);
    draw_set_color(_marco_col);
    draw_rectangle(_rx - 2, _ry - 2, _rx + _tam + 2, _ry + _tam + 2, false);

    // Dibujar sprite del rostro
    draw_sprite_ext(_spr, 0,
        _rx + _offset_x, _ry + _offset_y,
        _escala, _escala,
        0, _blend, _alpha_spr);

    // Borde fino exterior
    draw_set_color(_marco_col);
    draw_rectangle(_rx - 2, _ry - 2, _rx + _tam + 2, _ry + _tam + 2, true);
}
