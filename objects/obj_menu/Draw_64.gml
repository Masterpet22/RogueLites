/// DRAW GUI - obj_menu

var _gw_full = display_get_gui_width();
var _gh_full = display_get_gui_height();

// Fondo
draw_sprite_stretched(spr_bg_menu, 0, 0, 0, _gw_full, _gh_full);

// ── FX del menú: viñeta oscura en las esquinas ──
{
    var _vig_alpha = 0.35;
    draw_set_alpha(_vig_alpha);
    draw_set_color(c_black);
    // Degradado superior
    for (var _v = 0; _v < 80; _v++) {
        draw_set_alpha(_vig_alpha * (1 - _v / 80));
        draw_line_width(0, _v, _gw_full, _v, 1);
    }
    // Degradado inferior
    for (var _v = 0; _v < 60; _v++) {
        draw_set_alpha(_vig_alpha * 0.6 * (1 - _v / 60));
        draw_line_width(0, _gh_full - _v, _gw_full, _gh_full - _v, 1);
    }
    draw_set_alpha(1);
    draw_set_color(c_white);
}

// ── FX del menú: partículas flotantes luminosas ──
{
    menu_fx_timer++;

    // Generar nuevas partículas periódicamente
    if (menu_fx_timer mod 6 == 0 && array_length(menu_particulas) < 40) {
        array_push(menu_particulas, {
            x: random(_gw_full),
            y: _gh_full + random(20),
            vx: random_range(-0.3, 0.3),
            vy: random_range(-0.6, -1.5),
            size: random_range(1.5, 4),
            alpha: random_range(0.15, 0.4),
            color: choose(
                make_color_rgb(100, 140, 255),   // azul
                make_color_rgb(180, 120, 255),   // púrpura
                make_color_rgb(255, 200, 80),    // dorado
                make_color_rgb(80, 220, 180)     // turquesa
            ),
            life: irandom_range(180, 360),
        });
    }

    // Dibujar y actualizar partículas
    gpu_set_blendmode(bm_add);
    for (var _pi = array_length(menu_particulas) - 1; _pi >= 0; _pi--) {
        var _mp = menu_particulas[_pi];
        _mp.x += _mp.vx;
        _mp.y += _mp.vy;
        _mp.vx += random_range(-0.02, 0.02);  // movimiento fluctuante
        _mp.life--;
        var _fade = clamp(_mp.life / 60, 0, 1);
        draw_set_color(_mp.color);
        draw_set_alpha(_mp.alpha * _fade);
        draw_circle(_mp.x, _mp.y, _mp.size, false);
        // Halo más grande y tenue
        draw_set_alpha(_mp.alpha * _fade * 0.3);
        draw_circle(_mp.x, _mp.y, _mp.size * 2.5, false);
        if (_mp.life <= 0 || _mp.y < -20) {
            array_delete(menu_particulas, _pi, 1);
        }
    }
    draw_set_alpha(1);
    gpu_set_blendmode(bm_normal);
}

// ── FX del menú: líneas de energía horizontales sutiles ──
{
    var _t = current_time;
    gpu_set_blendmode(bm_add);
    for (var _li = 0; _li < 3; _li++) {
        var _ly = (_gh_full * 0.3) + _li * (_gh_full * 0.2);
        var _wave = sin(_t * 0.001 + _li * 2.0) * 15;
        var _la = 0.04 + 0.03 * sin(_t * 0.002 + _li);
        draw_set_color(make_color_rgb(120, 100, 220));
        draw_set_alpha(_la);
        draw_line_width(0, _ly + _wave, _gw_full, _ly + _wave + sin(_t * 0.0015) * 8, 1.5);
    }
    draw_set_alpha(1);
    gpu_set_blendmode(bm_normal);
}
draw_set_font(fnt_1)
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var cx = display_get_gui_width() * 0.5;
var cy = display_get_gui_height() * 0.3;

// Logo del juego (escala dinámica)
var _logo_s = 410 / sprite_get_width(spr_logo_arcadium);
draw_sprite_ext(spr_logo_arcadium, 0, cx, cy - 90, _logo_s, _logo_s, 0, c_white, 1);

// ═══════════════════════════════════════════════════════════════
//  ORO — ESQUINA SUPERIOR DERECHA con efecto y sprite decorativo
// ═══════════════════════════════════════════════════════════════
if (instance_exists(obj_control_juego)) {
    var _oro_val = obj_control_juego.oro;
    var _oro_txt = string(_oro_val) + " G";
    var _oro_x = display_get_gui_width() - 20;
    var _oro_y = 28;

    // Icono de moneda procedural (círculo dorado con brillo)
    var _ico_x = _oro_x - string_width(_oro_txt) - 30;
    var _ico_r = 12;

    // Glow dorado pulsante detrás del icono
    var _pulse = 0.6 + 0.4 * sin(current_time * 0.003);
    draw_set_color(make_color_rgb(255, 200, 0));
    draw_set_alpha(0.2 * _pulse);
    draw_circle(_ico_x, _oro_y, _ico_r + 5, false);
    draw_set_alpha(1);

    // Moneda (círculo dorado)
    draw_set_color(make_color_rgb(220, 180, 20));
    draw_circle(_ico_x, _oro_y, _ico_r, false);
    draw_set_color(make_color_rgb(255, 230, 80));
    draw_circle(_ico_x, _oro_y, _ico_r - 3, false);
    // Símbolo G en el centro
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(140, 100, 10));
    draw_text(_ico_x, _oro_y, "G");

    // Texto de oro con sombra y efecto dorado
    draw_set_halign(fa_right);
    draw_set_valign(fa_middle);
    // Sombra
    draw_set_color(c_black);
    draw_text(_oro_x + 1, _oro_y + 1, _oro_txt);
    // Texto dorado brillante
    draw_set_color(merge_color(make_color_rgb(255, 215, 0), make_color_rgb(255, 240, 150), _pulse * 0.3));
    draw_text(_oro_x, _oro_y, _oro_txt);
}

// ═══════════════════════════════════════════════════════════════
//  BOTONES DE MENÚ — posición baja, pulsación suave del sprite
// ═══════════════════════════════════════════════════════════════
var _menu_y_start = cy + 120;  // bien abajo para no chocar con el logo

for (var i = 0; i < array_length(opciones); i++) {

    var texto = opciones[i];
    var _by = _menu_y_start + i * 56;
    var _es_seleccionado = (i == opcion);

    // Escala del botón: seleccionado es más grande + pulsación suave
    var _btn_w_base = _es_seleccionado ? 220 : 192;
    var _btn_h_base = _es_seleccionado ? 42 : 36;

    // Pulsación suave: el sprite del botón seleccionado respira
    var _pulse_scale = 1.0;
    if (_es_seleccionado) {
        _pulse_scale = 1.0 + 0.04 * sin(current_time * 0.004);
    }
    var _btn_w = round(_btn_w_base * _pulse_scale);
    var _btn_h = round(_btn_h_base * _pulse_scale);

    // Botón de fondo (sprite con pulsación)
    draw_sprite_stretched(spr_boton_menu, 0, cx - _btn_w / 2, _by - _btn_h / 2, _btn_w, _btn_h);

    // Texto con sombra y colores mejorados
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    if (_es_seleccionado) {
        // Sombra del texto seleccionado
        draw_set_color(c_black);
        draw_text(cx + 1, _by + 1, texto);
        // Texto seleccionado: blanco brillante
        draw_set_color(c_white);
        draw_text(cx, _by, texto);
        // Indicadores de selección
        draw_set_color(make_color_rgb(220, 220, 230));
        draw_text(cx - _btn_w / 2 + 14, _by, ">");
        draw_text(cx + _btn_w / 2 - 14, _by, "<");
    } else {
        // Sombra
        draw_set_color(c_black);
        draw_text(cx + 1, _by + 1, texto);
        // Texto no seleccionado: gris claro
        draw_set_color(make_color_rgb(180, 180, 190));
        draw_text(cx, _by, texto);
    }
}

// ═══════════════════════════════════════════════════════════════
//  ICONO DE AYUDA (esquina inferior derecha) + PANEL VERTICAL
// ═══════════════════════════════════════════════════════════════
{
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

    // ── Icono "?" ──
    var _ix = _gw - guia_ico_margin - guia_ico_size;
    var _iy = _gh - guia_ico_margin - guia_ico_size;

    // Fondo del icono (círculo simulado con roundrect)
    var _ico_col = mostrar_guia ? c_yellow : make_color_rgb(80, 80, 120);
    draw_set_color(c_black);
    draw_set_alpha(0.6);
    draw_roundrect_ext(_ix, _iy, _ix + guia_ico_size, _iy + guia_ico_size, 10, 10, false);
    draw_set_alpha(1);
    draw_set_color(_ico_col);
    draw_roundrect_ext(_ix, _iy, _ix + guia_ico_size, _iy + guia_ico_size, 10, 10, true);

    // "H" dentro del icono
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(_ico_col);
    draw_text(_ix + guia_ico_size * 0.5, _iy + guia_ico_size * 0.5, "H");

    // ── Panel vertical (se expande de abajo hacia arriba) ──
    if (guia_anim > 0.01) {
        var _panel_w = 280;
        var _panel_h_full = 280;
        var _panel_h_vis = round(_panel_h_full * guia_anim);

        // El panel crece hacia arriba desde el icono
        var _panel_x = _ix + guia_ico_size - _panel_w;  // alineado a la derecha con el icono
        var _panel_bottom = _iy - 6;
        var _panel_top = _panel_bottom - _panel_h_vis;

        // Fondo
        draw_set_color(c_black);
        draw_set_alpha(0.75 * guia_anim);
        draw_roundrect_ext(_panel_x, _panel_top, _panel_x + _panel_w, _panel_bottom, 8, 8, false);
        draw_set_alpha(1);

        // Borde
        draw_set_color(make_color_rgb(80, 80, 120));
        draw_set_alpha(guia_anim);
        draw_roundrect_ext(_panel_x, _panel_top, _panel_x + _panel_w, _panel_bottom, 8, 8, true);
        draw_set_alpha(1);

        // Solo dibujar texto si la animación supera 50%
        if (guia_anim > 0.5) {
            var _txt_alpha = clamp((guia_anim - 0.5) * 2, 0, 1);
            draw_set_alpha(_txt_alpha);

            var _lx = _panel_x + 16;
            var _full_top = _panel_bottom - _panel_h_full;
            var _ly = _full_top + 12;
            var _lh = 19;

            draw_set_halign(fa_left);
            draw_set_valign(fa_top);

            // Título
            draw_set_color(c_yellow);
            draw_text(_lx, _ly, "── CONTROLES ──");
            _ly += _lh + 4;

            // NAVEGACIÓN
            draw_set_color(c_aqua);
            draw_text(_lx, _ly, "NAVEGACIÓN"); _ly += _lh;
            draw_set_color(c_ltgray);
            draw_text(_lx, _ly, "Arriba / Abajo    Mover seleccion"); _ly += _lh;
            draw_text(_lx, _ly, "Izq / Der    Elegir en mapa"); _ly += _lh;
            draw_text(_lx, _ly, "Enter    Confirmar"); _ly += _lh;
            draw_text(_lx, _ly, "Escape   Volver / Salir"); _ly += _lh + 4;

            // COMBATE
            draw_set_color(c_aqua);
            draw_text(_lx, _ly, "COMBATE"); _ly += _lh;
            draw_set_color(c_ltgray);
            draw_text(_lx, _ly, "Q W E R  Habilidades"); _ly += _lh;
            draw_text(_lx, _ly, "TAB      Súper (esen. >50%)"); _ly += _lh;
            draw_text(_lx, _ly, "1 2 3    Consumibles"); _ly += _lh;
            draw_text(_lx, _ly, "Espacio  Pausar"); _ly += _lh + 4;

            // Hint cierre
            draw_set_color(make_color_rgb(120, 120, 120));
            draw_text(_lx, _ly, "H  Cerrar este panel");

            draw_set_alpha(1);
        }
    }
}

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);