/// DRAW GUI — obj_select
draw_set_font(fnt_1)
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Título
draw_set_color(c_white);
draw_text(40, 40, "SELECCIÓN DE PERSONAJE");

// Lista de personajes
y = 120;

for (var i = 0; i < array_length(personajes); i++) {

    if (i == indice_personaje) {
        draw_set_color(c_yellow);
        draw_text(60, y, "> " + personajes[i]);
    } else {
        draw_set_color(c_gray);
        draw_text(60, y, personajes[i]);
    }

    y += 30;
}

// Info del personaje actual
var perfil = control_juego.perfiles_personaje[? personajes[indice_personaje]];

draw_set_color(c_white);
draw_text(60, y + 20, "Clase: " + perfil.clase);
draw_text(60, y + 45, "Afinidad: " + perfil.afinidad);
draw_text(60, y + 70, "Personalidad: " + perfil.personalidad);

if (estado == SelState.PERSONAJE) {
    draw_set_color(c_yellow);
    draw_text(60, y + 100, "ENTER: Seleccionar arma  |  ESC: Volver al menú");
}

// =========================
// POPUP DE ARMAS
// =========================
if (estado == SelState.ARMA_POPUP) {

    var w = 360;
    var h = 260;
    var cx = display_get_gui_width() / 2;
    var cy = display_get_gui_height() / 2;

    var x1 = cx - w / 2;
    var y1 = cy - h / 2;

    // Fondo semi-transparente
    draw_set_color(c_black);
    draw_set_alpha(0.85);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);

    // Ventana
    draw_set_color(c_black);
    draw_rectangle(x1, y1, x1 + w, y1 + h, false);

    draw_set_color(c_white);
    draw_text(x1 + 20, y1 + 20, "ARMAS DE " + perfil.nombre);

    var armas = scr_ds_map_keys_array(perfil.armas_obtenidas);
    var ay = y1 + 60;

    for (var i = 0; i < array_length(armas); i++) {

        if (i == indice_arma) {
            draw_set_color(c_lime);
            draw_text(x1 + 40, ay, "> " + armas[i]);
        } else {
            draw_set_color(c_gray);
            draw_text(x1 + 40, ay, armas[i]);
        }

        ay += 30;
    }

    draw_set_color(c_white);
    draw_text(x1 + 20, y1 + h - 50, "ENTER: Equipar y elegir objetos");
    draw_text(x1 + 20, y1 + h - 25, "ESC: Volver a seleccionar personaje");
}

// =========================
// POPUP DE OBJETOS
// =========================
if (estado == SelState.OBJETOS_POPUP) {

    var w = 420;
    var h = 340;
    var cx = display_get_gui_width() / 2;
    var cy = display_get_gui_height() / 2;

    var x1 = cx - w / 2;
    var y1 = cy - h / 2;

    // Fondo semi-transparente
    draw_set_color(c_black);
    draw_set_alpha(0.85);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);

    // Ventana
    draw_set_color(c_black);
    draw_rectangle(x1, y1, x1 + w, y1 + h, false);

    draw_set_color(c_white);
    draw_text(x1 + 20, y1 + 15, "EQUIPAR OBJETOS (máx. 3)");

    draw_set_color(c_gray);
    draw_text(x1 + 20, y1 + 35, "Seleccionados: " + string(array_length(objetos_seleccionados)) + " / 3");

    var oy = y1 + 65;

    for (var i = 0; i < array_length(objetos_disponibles); i++) {

        var _obj_nom = objetos_disponibles[i];
        var _cant = scr_inventario_get_objeto(control_juego, _obj_nom);

        // Verificar si está seleccionado
        var _esta_sel = false;
        var _veces_sel = 0;
        for (var j = 0; j < array_length(objetos_seleccionados); j++) {
            if (objetos_seleccionados[j] == _obj_nom) {
                _esta_sel = true;
                _veces_sel++;
            }
        }

        // Color según estado
        if (i == indice_objeto) {
            draw_set_color(_esta_sel ? c_aqua : c_yellow);
            draw_text(x1 + 30, oy, "> ");
        } else {
            draw_set_color(_esta_sel ? c_aqua : c_gray);
        }

        var _marca = _esta_sel ? "[x" + string(_veces_sel) + "] " : "[ ] ";
        draw_text(x1 + 50, oy, _marca + _obj_nom + "  (x" + string(_cant) + ")");

        oy += 28;
    }

    // Mostrar objetos seleccionados abajo
    var sy = y1 + h - 90;
    draw_set_color(c_yellow);
    draw_text(x1 + 20, sy, "Equipados:");

    for (var i = 0; i < 3; i++) {
        var _slot_txt = "Slot " + string(i + 1) + ": ";
        if (i < array_length(objetos_seleccionados)) {
            _slot_txt += objetos_seleccionados[i];
            draw_set_color(c_lime);
        } else {
            _slot_txt += "(vacío)";
            draw_set_color(c_gray);
        }
        draw_text(x1 + 30, sy + 22 + i * 20, _slot_txt);
    }

    draw_set_color(c_white);
    draw_text(x1 + 20, y1 + h - 22, "TAB: Sel/Desel  |  ENTER: Confirmar  |  ESC: Volver");
}