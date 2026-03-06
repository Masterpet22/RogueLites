/// @file scr_feedback_combate.gml
/// @description  Sistema de feedback visual para combate:
///   - Números flotantes de daño/curación/buffs
///   - Sacudida (shake) de sprites al recibir daño
///   - Flash de color en sprites al recibir efectos (con color elemental por afinidad)
///   - Tracking automático de cambios de vida para generar feedback
///   - Glow elemental (additive blending) sobre personajes
///   - Hitstop para impactos fuertes y súper
///   - Flash de pantalla elemental
///   - Integración con scr_fx_esencia_visual y scr_paleta_afinidad

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
#macro FB_FX_DURACION     20      // frames que dura un efecto FX


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

    // Efectos visuales FX
    _c.fb_fx_list = [];

    // ── Sistema de FOCO individual (énfasis en un sprite) ──
    _c.foco_quien       = 0;     // 0=ninguno, 1=jugador, 2=enemigo
    _c.foco_escala       = 1.0;   // escala interpolada del focalizado
    _c.foco_escala_obj   = 1.0;   // escala objetivo
    _c.foco_dim          = 1.0;   // alpha interpolada del NO focalizado
    _c.foco_dim_obj      = 1.0;   // alpha objetivo del NO focalizado
    _c.foco_vel          = 0.06;  // velocidad de interpolación
    _c.foco_offset_pj_x  = 0;    // offset X interpolado del jugador (para centrar en fin)
    _c.foco_offset_en_x  = 0;    // offset X interpolado del enemigo
    _c.foco_offset_pj_x_obj = 0; // offset X objetivo del jugador
    _c.foco_offset_en_x_obj = 0; // offset X objetivo del enemigo

    // Timer para restaurar foco después de zoom de súper
    _c.foco_super_restore_timer = 0;

    // ── Blur de escenario durante súper ──
    _c.super_blur_timer   = 0;
    _c.super_blur_alpha   = 0;
    _c.super_blur_surface = -1;  // surface para blur fake

    // Inicializar sistema de esencia visual (glow, hitstop, flash pantalla)
    scr_fx_esencia_init();
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

    // ── Actualizar FX de esencia (glow, hitstop, flash pantalla) ──
    var _hitstop = scr_fx_esencia_actualizar();
    if (_hitstop) return; // todo congelado durante hitstop

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

    // ── Restaurar foco después de zoom de súper ──
    if (_c.foco_super_restore_timer > 0) {
        _c.foco_super_restore_timer--;
        if (_c.foco_super_restore_timer <= 0) {
            _c.foco_quien      = 0;
            _c.foco_escala_obj = 1.0;
            _c.foco_dim_obj    = 1.0;
            // Devolver sprites a su posición original
            _c.foco_offset_pj_x_obj = 0;
            _c.foco_offset_en_x_obj = 0;
        }
    }

    // ── Blur de escenario durante súper ──
    if (_c.super_blur_timer > 0) {
        _c.super_blur_timer--;
        // Fade-out del blur en los últimos 10 frames
        if (_c.super_blur_timer < 10) {
            _c.super_blur_alpha = clamp(_c.super_blur_timer / 10, 0, 1) * 0.85;
        }
        // Liberar surface cuando termina el blur
        if (_c.super_blur_timer <= 0 && surface_exists(_c.super_blur_surface)) {
            surface_free(_c.super_blur_surface);
            _c.super_blur_surface = -1;
        }
    }

    // ── Detección automática de cambios de vida ──
    var _pj = _c.personaje_jugador;
    var _en = _c.personaje_enemigo;

    // ── Determinar colores elementales para flash ──
    var _afi_jugador = variable_struct_exists(_pj, "afinidad") ? _pj.afinidad : "Neutra";
    var _afi_enemigo = variable_struct_exists(_en, "afinidad") ? _en.afinidad : "Neutra";
    var _col_flash_jugador = scr_color_energia_afinidad(_afi_enemigo); // flash del color del atacante
    var _col_flash_enemigo = scr_color_energia_afinidad(_afi_jugador);

    // Jugador
    var _pj_diff = _c.fb_pj_vida_prev - _pj.vida_actual;
    if (_pj_diff > 0) {
        // Jugador recibió daño — flash con color elemental del enemigo
        scr_feedback_agregar(true, _pj_diff, "dano");
        scr_feedback_sacudir(true);
        scr_feedback_flash(true, _col_flash_jugador);
        scr_feedback_fx(true, "impacto");
        // Hitstop corto en golpes grandes (>15% vida max)
        if (_pj_diff > _pj.vida_max * 0.15) {
            scr_fx_hitstop(4); // ~0.07s
        }
        // ── FX Impacto: shake de cámara + zoom + partículas ──
        var _tipo_golpe = "normal";
        if (_pj_diff > _pj.vida_max * 0.25) _tipo_golpe = "fuerte";
        if (_pj_diff > _pj.vida_max * 0.40) _tipo_golpe = "critico";
        scr_fx_impacto_golpe(true, _tipo_golpe, _afi_enemigo);
        // ── Flash elemental con shader (intensidad según daño) ──
        if (_pj_diff > _pj.vida_max * 0.10) {
            scr_fx_flash_elemental(_afi_enemigo);
        }
    } else if (_pj_diff < 0) {
        // Jugador se curó
        scr_feedback_agregar(true, abs(_pj_diff), "cura");
        scr_feedback_flash(true, c_lime);
        scr_feedback_fx(true, "curacion");
        scr_fx_impacto_curacion(true);
    }
    _c.fb_pj_vida_prev = _pj.vida_actual;

    // Enemigo
    var _en_diff = _c.fb_en_vida_prev - _en.vida_actual;
    if (_en_diff > 0) {
        // Enemigo recibió daño — flash con color elemental del jugador
        scr_feedback_agregar(false, _en_diff, "dano");
        scr_feedback_sacudir(false);
        scr_feedback_flash(false, _col_flash_enemigo);
        scr_feedback_fx(false, "impacto");
        // Hitstop corto en golpes grandes (>15% vida max)
        if (_en_diff > _en.vida_max * 0.15) {
            scr_fx_hitstop(4);
        }
        // ── FX Impacto: shake de cámara + zoom + partículas ──
        var _tipo_golpe_en = "normal";
        if (_en_diff > _en.vida_max * 0.25) _tipo_golpe_en = "fuerte";
        if (_en_diff > _en.vida_max * 0.40) _tipo_golpe_en = "critico";
        scr_fx_impacto_golpe(false, _tipo_golpe_en, _afi_jugador);
        // ── Flash elemental con shader (intensidad según daño) ──
        if (_en_diff > _en.vida_max * 0.10) {
            scr_fx_flash_elemental(_afi_jugador);
        }
    } else if (_en_diff < 0) {
        // Enemigo se curó
        scr_feedback_agregar(false, abs(_en_diff), "cura");
        scr_feedback_flash(false, c_lime);
        scr_feedback_fx(false, "curacion");
        scr_fx_impacto_curacion(false);
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
//  scr_sprite_y_anclado_suelo(sprite, suelo_y, escala)
//  Calcula la Y de dibujo para que la BASE de la máscara de
//  colisión del sprite quede exactamente en suelo_y.
//  Así todos los personajes comparten la misma línea de suelo
//  sin importar el tamaño del lienzo ni el origen del sprite.
// ══════════════════════════════════════════════════════════════
/// @function scr_sprite_y_anclado_suelo(sprite, suelo_y, escala)
/// @param {Asset.GMSprite} _spr     Sprite a dibujar
/// @param {real}           _suelo_y Posición Y de la línea de suelo
/// @param {real}           _escala  Factor de escala aplicado al sprite
/// @returns {real}         Y corregida para draw_sprite_ext
function scr_sprite_y_anclado_suelo(_spr, _suelo_y, _escala) {
    // Distancia desde el origen del sprite hasta la base de la máscara (bbox_bottom)
    var _bbox_bottom  = sprite_get_bbox_bottom(_spr);  // píxeles desde arriba del lienzo
    var _yoffset      = sprite_get_yoffset(_spr);      // origen Y del sprite
    var _dist_origen_a_base = _bbox_bottom - _yoffset;  // px debajo del origen hasta base máscara
    // La Y de dibujo debe ser tal que: Ydraw + _dist_origen_a_base * escala == suelo_y
    return _suelo_y - _dist_origen_a_base * _escala;
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

    // Posiciones base X de los sprites de cuerpo
    var _pj_x = _gui_w * 0.22;
    var _en_x = _gui_w * 0.78;

    // Línea de suelo compartida — todos los personajes apoyan aquí la base de su máscara
    var _suelo_y = _gui_h * 0.82;

    // Escala dinámica: tamaño de pantalla deseado / tamaño real del sprite
    var _display_h = 345;  // 230 * 1.5

    // ── Interpolar foco (énfasis individual) ──
    _c.foco_escala = lerp(_c.foco_escala, _c.foco_escala_obj, _c.foco_vel);
    _c.foco_dim    = lerp(_c.foco_dim,    _c.foco_dim_obj,    _c.foco_vel);
    _c.foco_offset_pj_x = lerp(_c.foco_offset_pj_x, _c.foco_offset_pj_x_obj, _c.foco_vel);
    _c.foco_offset_en_x = lerp(_c.foco_offset_en_x, _c.foco_offset_en_x_obj, _c.foco_vel);

    // Determinar multiplicadores de escala y alpha por personaje según foco
    var _pj_foco_escala = 1.0;
    var _pj_foco_alpha  = 1.0;
    var _en_foco_escala  = 1.0;
    var _en_foco_alpha   = 1.0;

    if (_c.foco_quien == 1) {
        // Jugador focalizado → agrandar, atenuar enemigo
        _pj_foco_escala = _c.foco_escala;
        _en_foco_alpha  = _c.foco_dim;
    } else if (_c.foco_quien == 2) {
        // Enemigo focalizado → agrandar, atenuar jugador
        _en_foco_escala = _c.foco_escala;
        _pj_foco_alpha  = _c.foco_dim;
    }

    // Aplicar offsets de posición (para centrar perdedor en fin de combate)
    _pj_x += _c.foco_offset_pj_x;
    _en_x += _c.foco_offset_en_x;

    // ── JUGADOR BODY SPRITE ──
    {
        // Usar sprite individual del personaje si existe
        var _spr_j = (variable_struct_exists(_c, "personaje_jugador") && variable_struct_exists(_c.personaje_jugador, "sprite_cuerpo"))
                     ? _c.personaje_jugador.sprite_cuerpo : spr_jugador;
        var _escala_j = (_display_h / sprite_get_height(_spr_j)) * _pj_foco_escala;

        // Y anclada al suelo por máscara de colisión (usa escala con foco)
        var _pj_y = scr_sprite_y_anclado_suelo(_spr_j, _suelo_y, _escala_j);

        var _sx = _pj_x + _c.fb_shake_offset_x[0];
        var _sy = _pj_y + _c.fb_shake_offset_y[0];

        // Flash de color
        var _blend = c_white;
        var _alpha = _pj_foco_alpha;
        if (_c.fb_flash_timer[0] > 0) {
            var _flash_ratio = _c.fb_flash_timer[0] / FB_FLASH_FRAMES;
            _blend = merge_color(c_white, _c.fb_flash_color[0], _flash_ratio * 0.7);
            // Parpadeo rápido
            if (_c.fb_flash_timer[0] mod 3 == 0) {
                _alpha *= 0.5;
            }
        }

        // Tinte rojo permanente si es el perdedor (foco_quien == 1)
        if (_c.fin_activado && _c.foco_quien == 1) {
            _blend = c_red;
        }

        // ── Shader: flash de golpe (reemplaza merge_color básico) ──
        var _shader_on = false;
        if (_c.fb_flash_timer[0] > 0 && shader_is_compiled(shd_flash)) {
            var _fr = _c.fb_flash_timer[0] / FB_FLASH_FRAMES;
            var _fc = _c.fb_flash_color[0];
            scr_shader_flash_set(
                color_get_red(_fc) / 255,
                color_get_green(_fc) / 255,
                color_get_blue(_fc) / 255,
                _fr * 0.85
            );
            _blend = c_white; // el shader se encarga del tinte
            _shader_on = true;
        } else if (_c.foco_quien == 2 && _c.super_blur_timer > 0 && shader_is_compiled(shd_desaturate)) {
            // Objetivo del súper: oscurecer con desaturación
            scr_shader_desaturate_set(0.85);
            _shader_on = true;
        } else if (_c.fin_activado && _c.foco_quien == 1 && shader_is_compiled(shd_desaturate)) {
            // Perdedor: desaturar progresivamente
            scr_shader_desaturate_set(0.7);
            _shader_on = true;
        }

        draw_sprite_ext(_spr_j, 0, _sx, _sy, _escala_j, _escala_j, 0, _blend, _alpha);
        if (_shader_on) shader_reset();
    }

    // ── ENEMIGO BODY SPRITE ──
    {
        // Usar sprite individual del enemigo si existe
        var _spr_e = (variable_struct_exists(_c, "personaje_enemigo") && variable_struct_exists(_c.personaje_enemigo, "sprite_cuerpo"))
                     ? _c.personaje_enemigo.sprite_cuerpo : spr_enemigo;
        var _escala_e = (_display_h / sprite_get_height(_spr_e)) * _en_foco_escala;

        // Y anclada al suelo por máscara de colisión (usa escala con foco)
        var _en_y = scr_sprite_y_anclado_suelo(_spr_e, _suelo_y, _escala_e);

        var _sx = _en_x + _c.fb_shake_offset_x[1];
        var _sy = _en_y + _c.fb_shake_offset_y[1];

        // Flash de color
        var _blend = c_white;
        var _alpha = _en_foco_alpha;
        if (_c.fb_flash_timer[1] > 0) {
            var _flash_ratio = _c.fb_flash_timer[1] / FB_FLASH_FRAMES;
            _blend = merge_color(c_white, _c.fb_flash_color[1], _flash_ratio * 0.7);
            if (_c.fb_flash_timer[1] mod 3 == 0) {
                _alpha *= 0.5;
            }
        }

        // Tinte rojo permanente si es el perdedor (foco_quien == 2)
        if (_c.fin_activado && _c.foco_quien == 2) {
            _blend = c_red;
        }

        // ── Shader: flash de golpe al enemigo ──
        var _shader_en_on = false;
        if (_c.fb_flash_timer[1] > 0 && shader_is_compiled(shd_flash)) {
            var _fr = _c.fb_flash_timer[1] / FB_FLASH_FRAMES;
            var _fc = _c.fb_flash_color[1];
            scr_shader_flash_set(
                color_get_red(_fc) / 255,
                color_get_green(_fc) / 255,
                color_get_blue(_fc) / 255,
                _fr * 0.85
            );
            _blend = c_white;
            _shader_en_on = true;
        } else if (_c.foco_quien == 1 && _c.super_blur_timer > 0 && shader_is_compiled(shd_desaturate)) {
            // Objetivo del súper: oscurecer con desaturación
            scr_shader_desaturate_set(0.85);
            _shader_en_on = true;
        } else if (_c.fin_activado && _c.foco_quien == 2 && shader_is_compiled(shd_desaturate)) {
            scr_shader_desaturate_set(0.7);
            _shader_en_on = true;
        }

        // ── FX especiales según rango ──
        var _rc = (variable_struct_exists(_c.personaje_enemigo, "recolor_elite"))
                  ? _c.personaje_enemigo.recolor_elite : undefined;
        var _jf = (variable_struct_exists(_c.personaje_enemigo, "fx_jefe"))
                  ? _c.personaje_enemigo.fx_jefe : undefined;

        if (_jf != undefined) {
            // Dibujar con FX de jefe (doble aura, sombra, partículas, escala 1.5x)
            scr_fx_jefe_dibujar(_spr_e, _sx, _sy, _escala_e, _jf, true, _blend, _alpha);
        } else if (_rc != undefined) {
            // Dibujar con efecto élite (aura glow, escala 1.3x)
            scr_recolor_elite_dibujar(_spr_e, _sx, _sy, _escala_e, _rc, true, _blend, _alpha);
        } else {
            // Dibujar normal (flip horizontal para enemigos)
            draw_sprite_ext(_spr_e, 0, _sx, _sy, -_escala_e, _escala_e, 0, _blend, _alpha);
        }
        if (_shader_en_on) shader_reset();
    }

    // ── GLOW ELEMENTAL de esencia sobre el jugador (additive blending) ──
    scr_fx_esencia_dibujar_glow();
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
    // Usar sprite de retrato individual si existe
    var _spr = spr_jugador_rostro; // fallback
    if (_es_jugador) {
        _spr = (variable_struct_exists(_c, "personaje_jugador") && variable_struct_exists(_c.personaje_jugador, "sprite_rostro"))
               ? _c.personaje_jugador.sprite_rostro : spr_jugador_rostro;
    } else {
        _spr = (variable_struct_exists(_c, "personaje_enemigo") && variable_struct_exists(_c.personaje_enemigo, "sprite_rostro"))
               ? _c.personaje_enemigo.sprite_rostro : spr_enemigo_rostro;
    }

    // Escala dinámica (cualquier resolución → _tam x _tam)
    var _escala = _tam / sprite_get_height(_spr);

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

    // Marco del retrato (sprite spr_marco_retrato)
    draw_sprite_stretched(spr_marco_retrato, 0, _rx - 4, _ry - 4, _tam + 8, _tam + 8);

    // Dibujar sprite del rostro
    // Flip horizontal para enemigos (sprites generados mirando a la izquierda)
    var _escala_x = _es_jugador ? _escala : -_escala;
    var _draw_x = _es_jugador ? (_rx + _offset_x) : (_rx + _tam + _offset_x);

    // Dibujar retrato (sin tint para élites, usan sprite propio)
    draw_sprite_ext(_spr, 0,
        _draw_x, _ry + _offset_y,
        _escala_x, _escala,
        0, _blend, _alpha_spr);

    // Borde tint según jugador/enemigo (élites/jefes usan colores especiales)
    var _marco_col;
    if (_es_jugador) {
        _marco_col = make_color_rgb(60, 120, 200);
    } else {
        var _jf2 = (variable_struct_exists(_c.personaje_enemigo, "fx_jefe"))
                   ? _c.personaje_enemigo.fx_jefe : undefined;
        var _rc2 = (variable_struct_exists(_c.personaje_enemigo, "recolor_elite"))
                   ? _c.personaje_enemigo.recolor_elite : undefined;
        if (_jf2 != undefined) {
            // Jefes: borde con color primario de afinidad
            _marco_col = _jf2.aura_color_1;
        } else {
            _marco_col = (_rc2 != undefined) ? _rc2.aura_color : make_color_rgb(200, 60, 60);
        }
    }
    draw_set_color(_marco_col);
    draw_rectangle(_rx - 4, _ry - 4, _rx + _tam + 4, _ry + _tam + 4, true);

    // Jefes: segundo borde exterior con color secundario (doble marco)
    if (!_es_jugador) {
        var _jf3 = (variable_struct_exists(_c.personaje_enemigo, "fx_jefe"))
                   ? _c.personaje_enemigo.fx_jefe : undefined;
        if (_jf3 != undefined) {
            draw_set_color(_jf3.aura_color_2);
            draw_rectangle(_rx - 6, _ry - 6, _rx + _tam + 6, _ry + _tam + 6, true);
        }
    }
}


// ══════════════════════════════════════════════════════════════
//  scr_feedback_fx(es_jugador, tipo_fx)
//  Genera un efecto visual (sprite animado) sobre un personaje.
//  @param {bool}   _es_jugador
//  @param {string} _tipo  "impacto"|"critico"|"curacion"|"esquiva"|"esencia"|"super"
// ══════════════════════════════════════════════════════════════
function scr_feedback_fx(_es_jugador, _tipo) {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);

    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    var _fx_x = _es_jugador ? _gui_w * 0.22 : _gui_w * 0.78;
    var _fx_y = _gui_h * 0.50;

    var _spr = -1;
    switch (_tipo) {
        case "impacto":  _spr = spr_fx_impacto;  break;
        case "critico":  _spr = spr_fx_critico;  break;
        case "curacion": _spr = spr_fx_curacion;  break;
        case "esquiva":  _spr = spr_fx_esquiva;  break;
        case "esencia":  _spr = spr_fx_esencia;  break;
        case "super":    _spr = spr_fx_super;    break;
    }
    if (_spr == -1) return;

    // Offset aleatorio más amplio para que cada golpe se vea diferente
    // Impactos y críticos varían más; curación y esencia varían menos
    var _offset_rango_x = 30;
    var _offset_rango_y = 40;
    if (_tipo == "curacion" || _tipo == "esencia") {
        _offset_rango_x = 15;
        _offset_rango_y = 20;
    } else if (_tipo == "critico" || _tipo == "super") {
        _offset_rango_x = 40;
        _offset_rango_y = 50;
    }

    var _fx = {
        sprite:  _spr,
        x:       _fx_x + random_range(-_offset_rango_x, _offset_rango_x),
        y:       _fx_y + random_range(-_offset_rango_y, _offset_rango_y),
        angulo:  random_range(-25, 25),   // rotación aleatoria para más variedad
        timer:   FB_FX_DURACION,
        escala:  1.0,
        alpha:   1.0,
    };

    array_push(_c.fb_fx_list, _fx);
}


// ══════════════════════════════════════════════════════════════
//  scr_feedback_dibujar_fx()
//  Dibuja los efectos FX activos. Llamar en Draw GUI.
// ══════════════════════════════════════════════════════════════
function scr_feedback_dibujar_fx() {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);

    if (!variable_struct_exists(_c, "fb_fx_list")) return;

    for (var i = array_length(_c.fb_fx_list) - 1; i >= 0; i--) {
        var _fx = _c.fb_fx_list[i];
        _fx.timer -= 1;

        // Escala crece y luego decrece (normalizada a 64px deseados)
        var _progreso = 1 - (_fx.timer / FB_FX_DURACION);
        var _fx_base = 64 / sprite_get_width(_fx.sprite);
        var _fx_anim = (_progreso < 0.3) ? lerp(0.5, 1.5, _progreso / 0.3) : lerp(1.5, 0.8, (_progreso - 0.3) / 0.7);
        _fx.escala = _fx_base * _fx_anim;
        _fx.alpha = (_fx.timer < FB_FX_DURACION * 0.3) ? clamp(_fx.timer / (FB_FX_DURACION * 0.3), 0, 1) : 1.0;

        var _ang = variable_struct_exists(_fx, "angulo") ? _fx.angulo : 0;
        draw_sprite_ext(_fx.sprite, 0, _fx.x, _fx.y, _fx.escala, _fx.escala, _ang, c_white, _fx.alpha);

        if (_fx.timer <= 0) {
            array_delete(_c.fb_fx_list, i, 1);
        }
    }

    // ── Flash de pantalla completa (elemental / súper) ── última capa
    scr_fx_dibujar_flash_pantalla();
}
