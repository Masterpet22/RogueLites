/// DRAW GUI — obj_ui_tienda
draw_set_font(fnt_1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// Fondo
draw_set_color(c_black);
draw_set_alpha(0.75);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

var _x = 40;
var _y = 25;

// ── Título y oro ──
draw_set_color(c_white);
draw_text(_x, _y, "=== TIENDA ===");

draw_set_color(c_yellow);
draw_text(_gw - 200, _y, "Oro: " + string(control_juego.oro) + " G");
_y += 40;

// ==============================
// ESTADO 1 — Categorías
// ==============================
if (estado == TiendaState.CATEGORIA) {

    draw_set_color(c_white);
    draw_text(_x, _y, "Elige una categoria:");
    _y += 35;

    for (var i = 0; i < array_length(categorias); i++) {
        if (i == indice_categoria) draw_set_color(c_yellow);
        else                       draw_set_color(c_white);
        draw_text(_x + 20, _y, categorias[i]);
        _y += 30;
    }

    draw_set_color(c_gray);
    draw_text(_x, _y + 25, "Arriba/Abajo: Navegar | ENTER: Seleccionar | ESC: Volver al menu");
}

// ==============================
// ESTADO 2 — Lista de items
// ==============================
else if (estado == TiendaState.LISTA) {

    var _cat_sel = categorias[indice_categoria];
    draw_set_color(c_white);
    draw_text(_x, _y, "Categoria: " + _cat_sel);
    _y += 35;

    var _total = array_length(items_lista);
    var _linea_h = 28;
    var _max_vis = min(_total, 14);

    // Scroll
    var _scroll = 0;
    if (_total > _max_vis) {
        _scroll = clamp(indice_item - floor(_max_vis / 2), 0, _total - _max_vis);
    }

    // ── Panel izquierdo: lista ──
    if (_scroll > 0) {
        draw_set_color(c_gray);
        draw_text(_x + 20, _y, "^ ^ ^");
        _y += _linea_h;
    }

    for (var i = _scroll; i < min(_scroll + _max_vis, _total); i++) {
        var _it = items_lista[i];

        // Color
        if (_it.comprado && _it.tipo != "objeto") {
            // Ya comprado → gris
            if (i == indice_item) draw_set_color(make_color_rgb(180, 180, 100));
            else                  draw_set_color(c_gray);
        } else {
            if (i == indice_item) draw_set_color(c_yellow);
            else                  draw_set_color(c_white);
        }

        var _etiqueta = _it.nombre;
        if (_it.comprado && _it.tipo != "objeto") {
            _etiqueta += "  [DESBLOQUEADO]";
        }
        if (_it.tipo == "objeto") {
            var _cant = variable_struct_exists(_it, "cantidad") ? _it.cantidad : 0;
            _etiqueta += "  (x" + string(_cant) + ")";
        }
        _etiqueta += "   " + string(_it.precio) + " G";

        draw_text(_x + 20, _y, _etiqueta);
        _y += _linea_h;
    }

    if (_scroll + _max_vis < _total) {
        draw_set_color(c_gray);
        draw_text(_x + 20, _y, "v v v");
    }

    // ── Panel derecho: detalle del item seleccionado ──
    var _det_x = _gw * 0.55;
    var _det_y = 100;

    if (_total > 0) {
        var _sel = items_lista[indice_item];

        draw_set_color(c_white);
        draw_text(_det_x, _det_y, _sel.nombre);
        _det_y += 25;

        draw_set_color(c_ltgray);
        draw_text(_det_x, _det_y, _sel.subtitulo);
        _det_y += 25;

        draw_set_color(c_yellow);
        draw_text(_det_x, _det_y, "Precio: " + string(_sel.precio) + " G");
        _det_y += 25;

        if (_sel.comprado && _sel.tipo != "objeto") {
            draw_set_color(c_lime);
            draw_text(_det_x, _det_y, ">> DESBLOQUEADO <<");
            _det_y += 25;
        }

        // Info extra según tipo
        if (_sel.tipo == "personaje") {
            var _pd = _sel.datos_extra;
            var _dc = scr_datos_clases(_pd.clase);
            _det_y += 10;
            draw_set_color(c_white);
            draw_text(_det_x, _det_y, "Clase: " + _pd.clase);           _det_y += 20;
            draw_text(_det_x, _det_y, "Afinidad: " + _pd.afinidad);     _det_y += 20;
            draw_text(_det_x, _det_y, "Vida: " + string(_dc.vida));     _det_y += 20;
            draw_text(_det_x, _det_y, "Ataque: " + string(_dc.ataque)); _det_y += 20;
            draw_text(_det_x, _det_y, "Defensa: " + string(_dc.defensa)); _det_y += 20;
            draw_text(_det_x, _det_y, "Vel: " + string(_dc.velocidad) + "  |  P.Elem: " + string(_dc.poder_elemental));
        }
        else if (_sel.tipo == "enemigo") {
            var _de = scr_datos_enemigos(_sel.datos_extra);
            _det_y += 10;
            draw_set_color(c_white);
            draw_text(_det_x, _det_y, "Afinidad: " + _de.afinidad);     _det_y += 20;
            draw_text(_det_x, _det_y, "Vida: " + string(_de.vida));     _det_y += 20;
            draw_text(_det_x, _det_y, "Ataque: " + string(_de.ataque)); _det_y += 20;
            draw_text(_det_x, _det_y, "Defensa: " + string(_de.defensa)); _det_y += 20;
            draw_text(_det_x, _det_y, "Oro drop: " + string(_de.oro_min) + "-" + string(_de.oro_max) + " G");
        }
        else if (_sel.tipo == "objeto") {
            var _do = scr_datos_objetos(_sel.datos_extra);
            _det_y += 10;
            draw_set_color(c_white);
            draw_text(_det_x, _det_y, "Tipo: " + _do.tipo);             _det_y += 20;
            draw_set_color(c_ltgray);
            draw_text(_det_x, _det_y, _do.descripcion);                 _det_y += 20;
            draw_set_color(c_white);
            var _cant_inv = scr_inventario_get_objeto(control_juego, _sel.datos_extra);
            draw_text(_det_x, _det_y, "En inventario: x" + string(_cant_inv));
        }
    }

    draw_set_color(c_gray);
    draw_text(_x, _gh - 40, "Arriba/Abajo: Navegar | ENTER: Comprar | ESC: Volver");
}

// ── Mensaje flotante ──
if (mensaje != "") {
    draw_set_halign(fa_center);
    draw_set_color(mensaje_color);
    draw_text(_gw * 0.5, _gh - 70, mensaje);
    draw_set_halign(fa_left);
}

draw_set_color(c_white);
