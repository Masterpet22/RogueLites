/// DRAW GUI - obj_menu

// Fondo
draw_sprite_stretched(spr_bg_menu, 0, 0, 0, display_get_gui_width(), display_get_gui_height());
draw_set_font(fnt_1)
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var cx = display_get_gui_width() * 0.5;
var cy = display_get_gui_height() * 0.3;

// Logo del juego (escala dinámica)
var _logo_s = 410 / sprite_get_width(spr_logo_arcadium);
draw_sprite_ext(spr_logo_arcadium, 0, cx, cy - 90, _logo_s, _logo_s, 0, c_white, 1);

draw_text(cx, cy - 40, "MENU PRINCIPAL");

// Dibujar cada opción con botón sprite
for (var i = 0; i < array_length(opciones); i++) {

    var texto = opciones[i];
    var _by = cy + i * 50;
    
    // Botón de fondo
    draw_sprite_stretched(spr_boton_menu, 0, cx - 96, _by - 18, 192, 36);

    if (i == opcion) draw_set_color(c_aqua);
    else             draw_set_color(c_black);

    draw_text(cx, _by, texto);
}

// Mostrar oro del jugador
if (instance_exists(obj_control_juego)) {
    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text(cx, cy + array_length(opciones) * 40 + 30, "Oro: " + string(obj_control_juego.oro) + " G");
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
            draw_text(_lx, _ly, "▲ / ▼    Mover selección"); _ly += _lh;
            draw_text(_lx, _ly, "◄ / ►    Elegir en mapa"); _ly += _lh;
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