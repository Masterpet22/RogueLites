/// DRAW GUI — obj_enemy_select

draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Título
draw_set_color(c_white);
draw_text(40, 40, "SELECCIÓN DE ENEMIGO");

x = 40;
y = 120;

// ==========================
// ESTADO: CATEGORÍAS
// ==========================
if (estado == EnemySelState.CATEGORIA) {

    draw_set_color(c_white);
    draw_text(x, y, "Elige la categoría:");
    y += 40;

    for (var i = 0; i < array_length(categorias); i++) {

        if (i == indice_categoria) draw_set_color(c_yellow);
        else                       draw_set_color(c_gray);

        draw_text(x + 20, y, categorias[i]);
        y += 30;
    }

    draw_set_color(c_white);
    draw_text(x, y + 40, "ENTER = Seleccionar categoría  |  ESC = Volver");
}


// ==========================
// ESTADO: LISTA
// ==========================
else if (estado == EnemySelState.LISTA) {

    draw_set_color(c_white);
    draw_text(x, y, "Elige el enemigo:");
    y += 40;

    for (var i = 0; i < array_length(enemigos_actuales); i++) {

        if (i == indice_enemigo) draw_set_color(c_lime);
        else                     draw_set_color(c_gray);

        draw_text(x + 20, y, enemigos_actuales[i]);
        y += 30;
    }

    draw_set_color(c_white);
    draw_text(x, y + 40, "ENTER = Confirmar enemigo | ESC = Volver");
}


// ==========================
// ESTADO: CONFIRMAR
// ==========================
else if (estado == EnemySelState.CONFIRMAR) {

    var nome = control_juego.enemigo_seleccionado;

    draw_set_color(c_white);
    draw_text(x, y, "Enemigo seleccionado:");
    draw_set_color(c_yellow);
    draw_text(x + 20, y + 40, nome);

    draw_set_color(c_white);
    draw_text(x, y + 100, "ENTER = Iniciar combate | ESC = Cambiar");
}