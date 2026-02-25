/// DRAW GUI — obj_ui_forja

draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Fondo
draw_set_color(c_black);
draw_set_alpha(0.5);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);

x = 40;
y = 40;

draw_set_color(c_white);
draw_text(x, y, "FORJA");
y += 40;

// ===================================================
// ESTADO 1 — Selección de personaje
// ===================================================
if (estado == ForjaState.PERSONAJE) {

    draw_text(x, y, "Elige el personaje para el que quieres forjar:");
    y += 40;

    for (var i = 0; i < array_length(personajes); i++) {

        if (i == indice_personaje) draw_set_color(c_yellow);
        else                       draw_set_color(c_white);

        draw_text(x + 20, y, personajes[i]);

        y += 30;
    }

    draw_set_color(c_white);
    draw_text(x, y + 20, "ENTER: Seleccionar personaje | ESC: Volver");
}


// ===================================================
// ESTADO 2 — Selección de ARMA para ese personaje
// ===================================================
else if (estado == ForjaState.ARMAS) {

    var personaje_sel = personajes[indice_personaje];
    draw_text(x, y, "Forjar para: " + personaje_sel);
    y += 40;

    draw_set_color(c_white);
    draw_text(x, y, "Armas disponibles:");
    y += 30;

    for (var i = 0; i < array_length(armas_forjables); i++) {

        if (i == indice_arma) draw_set_color(c_lime);
        else                  draw_set_color(c_white);

        draw_text(x + 20, y, armas_forjables[i]);

        y += 30;
    }

    y += 20;

    // Detalles del arma seleccionada
    var arma_sel = armas_forjables[indice_arma];
    var dat = scr_datos_armas(arma_sel);

    draw_set_color(c_white);
    draw_text(x, y, "Detalles de " + arma_sel + ":");
    y += 25;

    draw_text(x + 20, y, "Rareza: " + string(dat.rareza));
    y += 20;

    draw_text(x + 20, y, "Ataque Bonus: " + string(dat.ataque_bonus));
    y += 20;

    draw_text(x + 20, y, "P.Elemental Bonus: " + string(dat.poder_elemental_bonus));
    y += 25;

    draw_text(x, y, "Receta:");
    y += 25;

    for (var r = 0; r < array_length(dat.receta); r++) {
        var req = dat.receta[r];
        var mat = req.material;
        var nes = req.cantidad;
        var ten = scr_inventario_get_material(control_juego, mat);

        if (ten >= nes) draw_set_color(c_lime); else draw_set_color(c_red);

        draw_text(x + 20, y, mat + ": " + string(ten) + "/" + string(nes));
        y += 20;
    }

    draw_set_color(c_white);
    y += 30;
    draw_text(x, y, "ENTER: Forjar | ESC: Personaje anterior");
}

// Mostrar mensaje
if (mensaje != "") {
    draw_set_color(c_yellow);
    draw_text(x, display_get_gui_height() - 60, mensaje);
}