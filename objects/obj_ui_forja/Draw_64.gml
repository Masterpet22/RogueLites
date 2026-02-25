/// DRAW GUI — obj_ui_forja
draw_set_font(fnt_1)
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// Fondo
draw_set_color(c_black);
draw_set_alpha(0.7);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

var _x = 40;
var _y = 30;

draw_set_color(c_white);
draw_text(_x, _y, "=== FORJA ===");
_y += 40;

// ===================================================
// ESTADO 1 — Selección de personaje
// ===================================================
if (estado == ForjaState.PERSONAJE) {

    draw_text(_x, _y, "Elige el personaje para el que quieres forjar:");
    _y += 40;

    for (var i = 0; i < array_length(personajes); i++) {
        var _pname = personajes[i];
        var _perfil_i = control_juego.perfiles_personaje[? _pname];
        var _aff_txt = (_perfil_i != undefined) ? (" [" + _perfil_i.afinidad + "]") : "";

        if (i == indice_personaje) draw_set_color(c_yellow);
        else                       draw_set_color(c_white);

        draw_text(_x + 20, _y, _pname + _aff_txt);
        _y += 30;
    }

    draw_set_color(c_gray);
    draw_text(_x, _y + 20, "Flecha Arriba/Abajo: Navegar | ENTER: Seleccionar | ESC: Volver");
}


// ===================================================
// ESTADO 2 — Selección de ARMA para ese personaje
// ===================================================
else if (estado == ForjaState.ARMAS) {

    var personaje_sel = personajes[indice_personaje];
    var _perfil_sel = control_juego.perfiles_personaje[? personaje_sel];
    var _afinidad_pj = (_perfil_sel != undefined) ? _perfil_sel.afinidad : "";

    draw_set_color(c_white);
    draw_text(_x, _y, "Forjar para: " + personaje_sel + " [" + _afinidad_pj + "]");
    _y += 35;

    // --- PANEL IZQUIERDO: Lista de armas (con scroll visual) ---
    var _lista_x = _x;
    var _lista_y = _y;
    var _linea_h = 22;
    var _max_visibles = min(array_length(armas_forjables), 12);
    var _total = array_length(armas_forjables);

    // Calcular offset de scroll para mantener el seleccionado visible
    var _scroll_offset = 0;
    if (_total > _max_visibles) {
        _scroll_offset = clamp(indice_arma - floor(_max_visibles / 2), 0, _total - _max_visibles);
    }

    draw_set_color(c_white);
    draw_text(_lista_x, _lista_y, "Armas (" + string(_total) + "):");
    _lista_y += 25;

    // Indicador scroll arriba
    if (_scroll_offset > 0) {
        draw_set_color(c_gray);
        draw_text(_lista_x + 20, _lista_y, "^ ^ ^");
        _lista_y += _linea_h;
    }

    for (var i = _scroll_offset; i < min(_scroll_offset + _max_visibles, _total); i++) {
        var _arma_nombre = armas_forjables[i];
        var _d = scr_datos_armas(_arma_nombre);
        var _r_str = "R" + string(_d.rareza);
        var _aff_arma = _d.afinidad;
        var _match = (_aff_arma == _afinidad_pj);

        // Color según selección y sinergia
        if (i == indice_arma) {
            draw_set_color(_match ? c_lime : c_yellow);
        } else {
            draw_set_color(_match ? make_color_rgb(100, 200, 100) : c_white);
        }

        var _tag = _match ? " *" : "";
        draw_text(_lista_x + 20, _lista_y, _r_str + " " + _arma_nombre + " [" + _aff_arma + "]" + _tag);
        _lista_y += _linea_h;
    }

    // Indicador scroll abajo
    if (_scroll_offset + _max_visibles < _total) {
        draw_set_color(c_gray);
        draw_text(_lista_x + 20, _lista_y, "v v v");
    }

    // --- PANEL DERECHO: Detalles del arma seleccionada ---
    var _det_x = _gw * 0.45;
    var _det_y = _y;

    if (_total > 0) {
        var arma_sel = armas_forjables[indice_arma];
        var dat = scr_datos_armas(arma_sel);
        var _es_sinergia = (dat.afinidad == _afinidad_pj);

        // Título
        if (_es_sinergia) draw_set_color(c_lime);
        else               draw_set_color(c_white);
        draw_text(_det_x, _det_y, arma_sel);
        _det_y += 25;

        // Sinergia
        if (_es_sinergia) {
            draw_set_color(c_lime);
            draw_text(_det_x, _det_y, ">> SINERGIA: Atq y P.Elem +15% <<");
            _det_y += 22;
        }

        // Rareza y afinidad
        draw_set_color(c_white);
        draw_text(_det_x, _det_y, "Rareza: R" + string(dat.rareza) + "   |   Afinidad: " + dat.afinidad);
        _det_y += 22;

        // Stats con/sin sinergia
        var _mult = _es_sinergia ? 1.15 : 1.0;
        var _atq_txt = string(dat.ataque_bonus);
        var _pel_txt = string(dat.poder_elemental_bonus);
        if (_es_sinergia) {
            _atq_txt += " -> " + string(round(dat.ataque_bonus * _mult));
            _pel_txt += " -> " + string(round(dat.poder_elemental_bonus * _mult));
        }
        draw_set_color(c_white);
        draw_text(_det_x, _det_y, "Ataque Bonus: " + _atq_txt);
        _det_y += 20;
        draw_text(_det_x, _det_y, "P.Elemental Bonus: " + _pel_txt);
        _det_y += 28;

        // Habilidades
        draw_set_color(c_aqua);
        draw_text(_det_x, _det_y, "Habilidades:");
        _det_y += 22;
        for (var h = 0; h < array_length(dat.habilidades_arma); h++) {
            var _hab_id = dat.habilidades_arma[h];
            var _hab_nom = scr_nombre_habilidad(_hab_id);
            var _hab_cd  = scr_cooldown_habilidad(_hab_id);
            var _cd_seg  = string_format(_hab_cd / room_speed, 1, 1);
            draw_set_color(c_aqua);
            draw_text(_det_x + 10, _det_y, _hab_nom + "  (CD: " + _cd_seg + "s)");
            _det_y += 20;
        }
        _det_y += 10;

        // Receta
        draw_set_color(c_white);
        draw_text(_det_x, _det_y, "Receta:");
        _det_y += 22;

        for (var r = 0; r < array_length(dat.receta); r++) {
            var req = dat.receta[r];
            var mat = req.material;
            var nes = req.cantidad;
            var ten = scr_inventario_get_material(control_juego, mat);

            if (ten >= nes) draw_set_color(c_lime); else draw_set_color(c_red);
            draw_text(_det_x + 10, _det_y, mat + ": " + string(ten) + "/" + string(nes));
            _det_y += 20;
        }

        // Indica si ya tiene el arma
        if (_perfil_sel != undefined && ds_map_exists(_perfil_sel.armas_obtenidas, arma_sel)) {
            _det_y += 8;
            draw_set_color(c_yellow);
            draw_text(_det_x, _det_y, "[Ya forjada]");
        }
    }

    // Controles (parte inferior)
    draw_set_color(c_gray);
    draw_text(_x, _gh - 40, "Flecha Arriba/Abajo: Navegar | ENTER: Forjar | ESC: Personaje anterior     (* = sinergia de afinidad)");
}

// Mostrar mensaje temporal
if (mensaje != "") {
    draw_set_color(c_yellow);
    draw_text(_x, _gh - 70, mensaje);
}