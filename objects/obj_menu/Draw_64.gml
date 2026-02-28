/// DRAW GUI - obj_menu

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var cx = display_get_gui_width() * 0.5;
var cy = display_get_gui_height() * 0.3;

draw_text(cx, cy - 40, "MENU PRINCIPAL");

// Dibujar cada opción
for (var i = 0; i < array_length(opciones); i++) {

    var texto = opciones[i];

    if (i == opcion) draw_set_color(c_yellow);
    else             draw_set_color(c_white);

    draw_text(cx, cy + i * 40, texto);
}

// Mostrar oro del jugador
if (instance_exists(obj_control_juego)) {
    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text(cx, cy + array_length(opciones) * 40 + 30, "Oro: " + string(obj_control_juego.oro) + " G");
}

draw_set_color(c_white);