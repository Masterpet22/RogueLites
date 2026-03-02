/// DRAW GUI - obj_menu

// Fondo
draw_sprite_stretched(spr_bg_menu, 0, 0, 0, display_get_gui_width(), display_get_gui_height());

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var cx = display_get_gui_width() * 0.5;
var cy = display_get_gui_height() * 0.3;

// Logo del juego
draw_sprite_ext(spr_logo_arcadium, 0, cx, cy - 90, 0.8, 0.8, 0, c_white, 1);

draw_text(cx, cy - 40, "MENU PRINCIPAL");

// Dibujar cada opción con botón sprite
for (var i = 0; i < array_length(opciones); i++) {

    var texto = opciones[i];
    var _by = cy + i * 50;
    
    // Botón de fondo
    draw_sprite_stretched(spr_boton_menu, 0, cx - 96, _by - 18, 192, 36);

    if (i == opcion) draw_set_color(c_yellow);
    else             draw_set_color(c_white);

    draw_text(cx, _by, texto);
}

// Mostrar oro del jugador
if (instance_exists(obj_control_juego)) {
    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text(cx, cy + array_length(opciones) * 40 + 30, "Oro: " + string(obj_control_juego.oro) + " G");
}

draw_set_color(c_white);