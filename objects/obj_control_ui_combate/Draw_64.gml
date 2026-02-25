/// DRAW GUI - obj_control_ui_combate

if (!instance_exists(control_combate)) {
    exit;
}

var pj = control_combate.personaje_jugador;
var en = control_combate.personaje_enemigo;
// ===========================
//  BARRA DE HABILIDADES
// ===========================

if (is_array(pj.habilidades_arma)) {

    var habs = pj.habilidades_arma;
    var cds  = pj.habilidades_cd;

    var slots = array_length(habs);
    if (slots > 3) slots = 3; // por diseño: máximo 3

    var x_start = 40;
    var y_start = display_get_gui_height() - 90;

    var slot_w = 80;
    var slot_h = 50;
    var gap    = 16;

    var key_labels = ["SPC", "Q", "W"];

    for (var i = 0; i < slots; i++) {

        var sx1 = x_start + i * (slot_w + gap);
        var sy1 = y_start;
        var sx2 = sx1 + slot_w;
        var sy2 = sy1 + slot_h;

        var id_hab = habs[i];
        var cd_actual = cds[i];

        // Marco
        draw_set_color(c_white);
        draw_rectangle(sx1, sy1, sx2, sy2, false);

        // Fondo
        draw_set_color(make_color_rgb(30,30,30));
        draw_rectangle(sx1+1, sy1+1, sx2-1, sy2-1, false);

        // Nombre de habilidad
        var nombre = scr_nombre_habilidad(id_hab);
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text((sx1+sx2)/2, sy1 + 18, nombre);

        // Tecla
        draw_set_color(c_yellow);
        draw_text((sx1+sx2)/2, sy2 - 10, key_labels[i]);

        // Cooldown overlay
        var cd_base = scr_cooldown_habilidad(id_hab);
        if (cd_actual > 0 && cd_base > 0) {

            var ratio = clamp(cd_actual / cd_base, 0, 1);

           // Color negro con alpha para el overlay de cooldown
			draw_set_color(c_black);
			draw_set_alpha(0.7); // 70% opaco, ajusta a gusto

			var fill_h = slot_h * ratio;
			draw_rectangle(sx1+1, sy2 - fill_h, sx2-1, sy2-1, false);

			// Restaurar alpha para no afectar otras cosas
			draw_set_alpha(1);

            // Número de segundos restantes
            var secs = cd_actual / room_speed;
            draw_set_color(c_aqua);
            draw_text((sx1+sx2)/2, sy1 + 5, string_format(secs, 1, 1));
        }
    }

    // Restaurar alineación default
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
// Fondo
draw_set_color(c_black);
draw_set_alpha(0.5);
draw_rectangle(0, 0, display_get_gui_width(), 80, false);
draw_set_alpha(1);

// Vida jugador
var w_gui = display_get_gui_width();

var barra_ancho = 200;
var barra_alto  = 16;

// Porcentaje de vida
var pj_ratio = pj.vida_actual / pj.vida_max;
var en_ratio = en.vida_actual / en.vida_max;

// Barra jugador (izquierda)
var x1 = 20;
var y1 = 20;
var x2 = x1 + barra_ancho;
var y2 = y1 + barra_alto;

// Marco
draw_set_color(c_white);
draw_rectangle(x1, y1, x2, y2, false);

// Relleno
draw_set_color(c_lime);
draw_rectangle(x1, y1, x1 + barra_ancho * pj_ratio, y2, false);

// Texto
/// DIBUJAR NOMBRE + ARMA + VIDA DEL JUGADOR

var texto_jugador = pj.nombre + " [" + pj.arma + "]  HP: " 
    + string(pj.vida_actual) + " / " + string(pj.vida_max);

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_text(20, 45, texto_jugador);



// Barra enemigo (derecha)
x2 = w_gui - 20;
x1 = x2 - barra_ancho;
y1 = 20;
y2 = y1 + barra_alto;

// Marco
draw_set_color(c_white);
draw_rectangle(x1, y1, x2, y2, false);

// Relleno
draw_set_color(c_red);
draw_rectangle(x2 - barra_ancho * en_ratio, y1, x2, y2, false);

// Texto
var texto_enemigo = en.nombre + "  HP: "
    + string(en.vida_actual) + " / " + string(en.vida_max);

draw_text(display_get_gui_width() - 240, 45, texto_enemigo);


// Mensaje de fin de combate
if (control_combate.combate_terminado) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_yellow);

    draw_text(w_gui * 0.5, 60, "Ganador: " + control_combate.ganador);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}