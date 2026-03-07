/// @file scr_fx_mundo.gml
/// @description  Sistema de efectos visuales por mundo/arena.
///   Cada arena tiene partículas ambientales únicas, overlay de viñeta,
///   y efectos especiales (ceniza, nieve, hojas, polvo).
///
///   Arena 0 — Forja de Obsidiana (Fuego): ceniza, viñeta cálida, brillo
///   Arena 1 — Canal de la Cascada  (Hielo): nieve, destellos, neblina azul
///   Arena 2 — Raíces Sombrías     (Bosque): rayos de luz, niebla, hojas
///   Arena 3 — Bastión Tormenta    (Cueva): polvo, iluminación dinámica, ondas
///   Arena 4 — Santuario del Tiempo (Neutra): partículas doradas sutiles

#macro MUNDO_PART_MAX  30
#macro MUNDO_RAY_MAX    5

// ══════════════════════════════════════════════════════════════
//  scr_fx_mundo_init()
//  Inicializa el sistema de efectos de mundo en obj_control_combate.
// ══════════════════════════════════════════════════════════════
function scr_fx_mundo_init() {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);

    _c.mundo_particulas = [];
    _c.mundo_rayos      = [];
    _c.mundo_timer      = 0;

    // Viñeta
    _c.mundo_vignette_color = c_black;
    _c.mundo_vignette_alpha = 0;

    // Arena actual
    var _arena = variable_struct_exists(_c, "combate_arena_idx") ? _c.combate_arena_idx : 0;
    _c.mundo_arena = _arena;

    // Configurar según arena
    switch (_arena) {
        case 0: // Fuego — viñeta cálida
            _c.mundo_vignette_color = make_color_rgb(180, 60, 10);
            _c.mundo_vignette_alpha = 0.12;
            break;
        case 1: // Hielo — viñeta azul fría
            _c.mundo_vignette_color = make_color_rgb(30, 60, 140);
            _c.mundo_vignette_alpha = 0.10;
            break;
        case 2: // Bosque — viñeta verde oscura
            _c.mundo_vignette_color = make_color_rgb(10, 40, 15);
            _c.mundo_vignette_alpha = 0.08;
            break;
        case 3: // Cueva — viñeta negra fuerte
            _c.mundo_vignette_color = c_black;
            _c.mundo_vignette_alpha = 0.18;
            break;
        case 4: // Neutra — viñeta dorada sutil
            _c.mundo_vignette_color = make_color_rgb(120, 100, 30);
            _c.mundo_vignette_alpha = 0.06;
            break;
    }

    // Pre-generar rayos de luz para bosque (arena 2)
    if (_arena == 2) {
        for (var i = 0; i < MUNDO_RAY_MAX; i++) {
            var _ray = {
                x:     random(display_get_gui_width()),
                w:     random_range(30, 80),
                alpha: random_range(0.03, 0.08),
                speed: random_range(0.1, 0.4),
                phase: random(pi * 2),
            };
            array_push(_c.mundo_rayos, _ray);
        }
    }
}


// ══════════════════════════════════════════════════════════════
//  scr_fx_mundo_actualizar()
//  Llamar cada frame en el Step del controlador.
// ══════════════════════════════════════════════════════════════
function scr_fx_mundo_actualizar() {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);
    if (!variable_struct_exists(_c, "mundo_arena")) return;

    _c.mundo_timer++;
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

    // ── Emitir partículas según arena ──
    if (array_length(_c.mundo_particulas) < MUNDO_PART_MAX) {
        switch (_c.mundo_arena) {
            case 0: _mundo_emitir_ceniza(_c, _gw, _gh); break;
            case 1: _mundo_emitir_nieve(_c, _gw, _gh);  break;
            case 2: _mundo_emitir_hojas(_c, _gw, _gh);  break;
            case 3: _mundo_emitir_polvo(_c, _gw, _gh);  break;
            case 4: _mundo_emitir_dorada(_c, _gw, _gh); break;
        }
    }

    // ── Actualizar partículas ──
    for (var i = array_length(_c.mundo_particulas) - 1; i >= 0; i--) {
        var _p = _c.mundo_particulas[i];
        _p.x += _p.vx;
        _p.y += _p.vy;
        _p.vida--;
        _p.alpha = clamp(_p.vida / _p.vida_max, 0, 1) * _p.alpha_base;

        // Movimiento sinusoidal lateral
        if (_p.sway != 0) {
            _p.x += sin((_c.mundo_timer + _p.phase) * _p.sway_speed) * _p.sway;
        }

        // Eliminar partículas muertas o fuera de pantalla
        if (_p.vida <= 0 || _p.y > _gh + 20 || _p.y < -20 || _p.x < -20 || _p.x > _gw + 20) {
            array_delete(_c.mundo_particulas, i, 1);
        }
    }
}


// ══════════════════════════════════════════════════════════════
//  scr_fx_mundo_dibujar_bajo()
//  Dibujar efectos DEBAJO de los sprites (niebla, rayos de luz).
//  Llamar en Draw GUI antes de scr_feedback_dibujar_sprites.
// ══════════════════════════════════════════════════════════════
function scr_fx_mundo_dibujar_bajo() {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);
    if (!variable_struct_exists(_c, "mundo_arena")) return;

    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

    switch (_c.mundo_arena) {
        case 2: // Bosque — Rayos de luz (god rays) + niebla baja
            _mundo_dibujar_rayos(_c, _gw, _gh);
            _mundo_dibujar_niebla(_c, _gw, _gh, make_color_rgb(180, 200, 170), 0.08);
            break;
        case 3: // Cueva — Iluminación dinámica (zona oscura con claros)
            _mundo_dibujar_cave_light(_c, _gw, _gh);
            break;
    }
}


// ══════════════════════════════════════════════════════════════
//  scr_fx_mundo_dibujar_sobre()
//  Dibujar efectos SOBRE los sprites (partículas, viñeta).
//  Llamar en Draw GUI después de los sprites y partículas.
// ══════════════════════════════════════════════════════════════
function scr_fx_mundo_dibujar_sobre() {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);
    if (!variable_struct_exists(_c, "mundo_arena")) return;

    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

    // ── Dibujar partículas de mundo ──
    for (var i = 0; i < array_length(_c.mundo_particulas); i++) {
        var _p = _c.mundo_particulas[i];
        draw_set_alpha(_p.alpha);
        draw_set_color(_p.color);

        switch (_p.forma) {
            case 0: // Círculo
                draw_circle(_p.x, _p.y, _p.size, false);
                break;
            case 1: // Cuadrado (ceniza, polvo)
                draw_rectangle(_p.x, _p.y, _p.x + _p.size, _p.y + _p.size, false);
                break;
            case 2: // Hoja (triángulo rotado)
                var _ang = (_c.mundo_timer + _p.phase) * 2;
                var _s = _p.size;
                var _cx = _p.x; var _cy = _p.y;
                draw_triangle(
                    _cx + lengthdir_x(_s, _ang),       _cy + lengthdir_y(_s, _ang),
                    _cx + lengthdir_x(_s, _ang + 120),  _cy + lengthdir_y(_s, _ang + 120),
                    _cx + lengthdir_x(_s * 0.6, _ang + 240), _cy + lengthdir_y(_s * 0.6, _ang + 240),
                    false
                );
                break;
            case 3: // Destello (cruz brillante)
                var _s2 = _p.size;
                draw_line_width(_p.x - _s2, _p.y, _p.x + _s2, _p.y, 1);
                draw_line_width(_p.x, _p.y - _s2, _p.x, _p.y + _s2, 1);
                break;
        }
    }
    draw_set_alpha(1);

    // ── Viñeta ──
    if (_c.mundo_vignette_alpha > 0) {
        _mundo_dibujar_vignette(_c, _gw, _gh);
    }
}


// ══════════════════════════════════════════════════════════════
//  FUNCIONES INTERNAS — Emisión de partículas
// ══════════════════════════════════════════════════════════════

function _mundo_emitir_ceniza(_c, _gw, _gh) {
    // Emitir cada 3 frames
    if (_c.mundo_timer mod 3 != 0) return;
    var _p = {
        x:          random(_gw),
        y:          -5,
        vx:         random_range(-0.3, 0.5),
        vy:         random_range(0.4, 1.2),
        size:       random_range(1.5, 3),
        color:      choose(
            make_color_rgb(200, 80, 30),
            make_color_rgb(160, 60, 20),
            make_color_rgb(255, 140, 40),
            make_color_rgb(100, 50, 20)
        ),
        alpha:      0,
        alpha_base: random_range(0.3, 0.6),
        vida:       irandom_range(120, 240),
        vida_max:   0,
        forma:      1,
        sway:       random_range(0.2, 0.5),
        sway_speed: random_range(0.02, 0.04),
        phase:      random(pi * 2),
    };
    _p.vida_max = _p.vida;
    array_push(_c.mundo_particulas, _p);
}


function _mundo_emitir_nieve(_c, _gw, _gh) {
    if (_c.mundo_timer mod 4 != 0) return;
    var _p = {
        x:          random(_gw),
        y:          -5,
        vx:         random_range(-0.2, 0.2),
        vy:         random_range(0.3, 0.8),
        size:       random_range(1.5, 3.5),
        color:      choose(c_white, make_color_rgb(200, 220, 255), make_color_rgb(180, 200, 240)),
        alpha:      0,
        alpha_base: random_range(0.4, 0.7),
        vida:       irandom_range(180, 360),
        vida_max:   0,
        forma:      0,
        sway:       random_range(0.3, 0.8),
        sway_speed: random_range(0.015, 0.03),
        phase:      random(pi * 2),
    };
    _p.vida_max = _p.vida;
    array_push(_c.mundo_particulas, _p);
}


function _mundo_emitir_hojas(_c, _gw, _gh) {
    if (_c.mundo_timer mod 8 != 0) return;
    var _p = {
        x:          random(_gw),
        y:          -10,
        vx:         random_range(0.1, 0.6),
        vy:         random_range(0.2, 0.6),
        size:       random_range(3, 6),
        color:      choose(
            make_color_rgb(50, 140, 40),
            make_color_rgb(80, 160, 30),
            make_color_rgb(40, 100, 30),
            make_color_rgb(120, 160, 50)
        ),
        alpha:      0,
        alpha_base: random_range(0.35, 0.55),
        vida:       irandom_range(200, 400),
        vida_max:   0,
        forma:      2,
        sway:       random_range(0.5, 1.2),
        sway_speed: random_range(0.02, 0.035),
        phase:      random(pi * 2),
    };
    _p.vida_max = _p.vida;
    array_push(_c.mundo_particulas, _p);
}


function _mundo_emitir_polvo(_c, _gw, _gh) {
    if (_c.mundo_timer mod 5 != 0) return;
    var _p = {
        x:          random(_gw),
        y:          random(_gh),
        vx:         random_range(-0.15, 0.15),
        vy:         random_range(-0.1, -0.3),
        size:       random_range(1, 2.5),
        color:      choose(
            make_color_rgb(140, 120, 100),
            make_color_rgb(100, 90, 70),
            make_color_rgb(80, 70, 60)
        ),
        alpha:      0,
        alpha_base: random_range(0.2, 0.4),
        vida:       irandom_range(100, 200),
        vida_max:   0,
        forma:      0,
        sway:       random_range(0.1, 0.3),
        sway_speed: random_range(0.01, 0.025),
        phase:      random(pi * 2),
    };
    _p.vida_max = _p.vida;
    array_push(_c.mundo_particulas, _p);
}


function _mundo_emitir_dorada(_c, _gw, _gh) {
    if (_c.mundo_timer mod 10 != 0) return;
    var _p = {
        x:          random(_gw),
        y:          random(_gh),
        vx:         random_range(-0.1, 0.1),
        vy:         random_range(-0.15, -0.3),
        size:       random_range(1.5, 3),
        color:      choose(
            make_color_rgb(255, 215, 80),
            make_color_rgb(220, 180, 60),
            make_color_rgb(255, 240, 120)
        ),
        alpha:      0,
        alpha_base: random_range(0.15, 0.35),
        vida:       irandom_range(150, 300),
        vida_max:   0,
        forma:      3,
        sway:       random_range(0.2, 0.5),
        sway_speed: random_range(0.01, 0.02),
        phase:      random(pi * 2),
    };
    _p.vida_max = _p.vida;
    array_push(_c.mundo_particulas, _p);
}


// ══════════════════════════════════════════════════════════════
//  FUNCIONES INTERNAS — Dibujo de efectos especiales
// ══════════════════════════════════════════════════════════════

/// @function _mundo_dibujar_vignette(ctrl, gui_w, gui_h)
/// @description Viñeta: borde oscuro/tintado que reduce hacia el centro.
function _mundo_dibujar_vignette(_c, _gw, _gh) {
    var _a = _c.mundo_vignette_alpha;
    var _col = _c.mundo_vignette_color;

    // Pulso sutil
    var _pulse = 0.85 + 0.15 * sin(current_time / 800);
    _a *= _pulse;

    draw_set_color(_col);

    // Bordes exteriores (más opacos) → interior (transparente)
    // 4 franjas en gradiente
    var _bw = _gw * 0.15;  // ancho de la franja de viñeta
    var _bh = _gh * 0.15;

    // Izquierda
    draw_set_alpha(_a);
    draw_rectangle(0, 0, _bw * 0.3, _gh, false);
    draw_set_alpha(_a * 0.6);
    draw_rectangle(_bw * 0.3, 0, _bw * 0.7, _gh, false);
    draw_set_alpha(_a * 0.25);
    draw_rectangle(_bw * 0.7, 0, _bw, _gh, false);

    // Derecha
    draw_set_alpha(_a);
    draw_rectangle(_gw - _bw * 0.3, 0, _gw, _gh, false);
    draw_set_alpha(_a * 0.6);
    draw_rectangle(_gw - _bw * 0.7, 0, _gw - _bw * 0.3, _gh, false);
    draw_set_alpha(_a * 0.25);
    draw_rectangle(_gw - _bw, 0, _gw - _bw * 0.7, _gh, false);

    // Arriba
    draw_set_alpha(_a * 0.8);
    draw_rectangle(_bw, 0, _gw - _bw, _bh * 0.3, false);
    draw_set_alpha(_a * 0.4);
    draw_rectangle(_bw, _bh * 0.3, _gw - _bw, _bh * 0.7, false);

    // Abajo
    draw_set_alpha(_a * 0.8);
    draw_rectangle(_bw, _gh - _bh * 0.3, _gw - _bw, _gh, false);
    draw_set_alpha(_a * 0.4);
    draw_rectangle(_bw, _gh - _bh * 0.7, _gw - _bw, _gh - _bh * 0.3, false);

    // Esquinas (refuerzo)
    draw_set_alpha(_a * 1.2);
    draw_rectangle(0, 0, _bw * 0.5, _bh * 0.5, false);
    draw_rectangle(_gw - _bw * 0.5, 0, _gw, _bh * 0.5, false);
    draw_rectangle(0, _gh - _bh * 0.5, _bw * 0.5, _gh, false);
    draw_rectangle(_gw - _bw * 0.5, _gh - _bh * 0.5, _gw, _gh, false);

    draw_set_alpha(1);
    draw_set_color(c_white);
}


/// @function _mundo_dibujar_rayos(ctrl, gui_w, gui_h)
/// @description Rayos de luz diagonales (god rays) para arena de bosque.
function _mundo_dibujar_rayos(_c, _gw, _gh) {
    gpu_set_blendmode(bm_add);
    draw_set_color(make_color_rgb(255, 245, 200));

    for (var i = 0; i < array_length(_c.mundo_rayos); i++) {
        var _r = _c.mundo_rayos[i];
        var _pulse = sin(current_time / 1500 + _r.phase) * 0.5 + 0.5;
        var _a = _r.alpha * (0.6 + 0.4 * _pulse);

        // Rayo diagonal (arriba-izq → abajo-der)
        var _rx = _r.x + sin(current_time / 3000 + _r.phase) * 20;
        var _rw = _r.w * (0.8 + 0.2 * _pulse);

        draw_set_alpha(_a);

        // Triángulo inclinado que simula un rayo de luz
        var _top_x = _rx + _rw * 0.3;
        var _bot_x = _rx + _rw * 1.5;
        draw_triangle(_rx, 0, _top_x + _rw, 0, _bot_x, _gh * 0.85, false);
    }

    draw_set_alpha(1);
    gpu_set_blendmode(bm_normal);
    draw_set_color(c_white);
}


/// @function _mundo_dibujar_niebla(ctrl, gui_w, gui_h, color, alpha)
/// @description Niebla baja en la parte inferior de la pantalla.
function _mundo_dibujar_niebla(_c, _gw, _gh, _col, _a) {
    var _fog_h = _gh * 0.18;
    var _fog_y = _gh - _fog_h;

    // Desplazamiento sinusoidal
    var _offset = sin(current_time / 2000) * 15;

    draw_set_color(_col);

    // Capa 1: más densa abajo
    draw_set_alpha(_a);
    draw_rectangle(0, _fog_y + _fog_h * 0.5 + _offset, _gw, _gh, false);

    // Capa 2: gradiente medio
    draw_set_alpha(_a * 0.5);
    draw_rectangle(0, _fog_y + _offset, _gw, _fog_y + _fog_h * 0.5 + _offset, false);

    // Capa 3: sutil arriba
    draw_set_alpha(_a * 0.15);
    draw_rectangle(0, _fog_y - _fog_h * 0.3 + _offset, _gw, _fog_y + _offset, false);

    draw_set_alpha(1);
    draw_set_color(c_white);
}


/// @function _mundo_dibujar_cave_light(ctrl, gui_w, gui_h)
/// @description Iluminación dinámica de cueva: oscuridad base con claros que se mueven.
function _mundo_dibujar_cave_light(_c, _gw, _gh) {
    // Overlay oscuro base
    draw_set_color(c_black);
    draw_set_alpha(0.15);
    draw_rectangle(0, 0, _gw, _gh, false);

    // Claros dinámicos (zonas menos oscuras con bm_subtract)
    // Simulamos con zonas de luz additive
    gpu_set_blendmode(bm_add);
    draw_set_color(make_color_rgb(40, 35, 50));

    // Centro de la escena (donde están los personajes)
    var _lx1 = _gw * 0.22 + sin(current_time / 2000) * 20;
    var _ly1 = _gh * 0.55;
    draw_set_alpha(0.06);
    draw_circle(_lx1, _ly1, 120, false);

    var _lx2 = _gw * 0.78 + cos(current_time / 2500) * 15;
    draw_circle(_lx2, _ly1, 100, false);

    // Luz cenital tenue
    draw_set_color(make_color_rgb(50, 45, 70));
    draw_set_alpha(0.04);
    draw_circle(_gw * 0.5, _gh * 0.3, 200, false);

    draw_set_alpha(1);
    gpu_set_blendmode(bm_normal);
    draw_set_color(c_white);
}
