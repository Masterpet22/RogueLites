/// DRAW GUI — obj_select

// Fondo
draw_sprite_stretched(spr_bg_select, 0, 0, 0, display_get_gui_width(), display_get_gui_height());

draw_set_font(fnt_1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var w_gui = display_get_gui_width();
var h_gui = display_get_gui_height();

// Título
draw_set_color(c_white);
draw_text(40, 20, "SELECCIÓN DE PERSONAJE");

// ═══════════════════════════════════════════════════════════════
//  GRID DE RETRATOS (izquierda)
// ═══════════════════════════════════════════════════════════════
{
    var _grid_x = 40;
    var _grid_y = 70;
    var _cell_w = 120;
    var _cell_h = 140;
    var _portrait_size = 96;
    var _cols = sel_cols;

    for (var i = 0; i < array_length(personajes); i++) {
        var _col = i mod _cols;
        var _row = i div _cols;
        var _cx = _grid_x + _col * _cell_w;
        var _cy = _grid_y + _row * _cell_h;
        var _sel = (i == indice_personaje);

        // Retrato del personaje
        var _spr_r = scr_sprite_personaje(personajes[i], true);
        var _rs = _portrait_size / sprite_get_width(_spr_r);

        // Marco
        if (_sel) {
            // Glow de selección
            draw_set_color(c_yellow);
            draw_set_alpha(0.25 + 0.1 * sin(current_time * 0.004));
            draw_roundrect_ext(_cx - 4, _cy - 4, _cx + _portrait_size + 4, _cy + _portrait_size + 4, 4, 4, false);
            draw_set_alpha(1);
        }

        // Retrato sprite
        draw_sprite_ext(_spr_r, 0, _cx, _cy, _rs, _rs, 0, c_white, 1);

        // Marco del retrato
        draw_sprite_stretched(spr_marco_retrato, 0, _cx - 4, _cy - 4, _portrait_size + 8, _portrait_size + 8);
        draw_set_color(_sel ? c_yellow : make_color_rgb(100, 100, 120));
        draw_rectangle(_cx - 4, _cy - 4, _cx + _portrait_size + 4, _cy + _portrait_size + 4, true);

        // Nombre debajo del retrato
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_set_color(_sel ? c_yellow : c_ltgray);
        var _name_txt = personajes[i];
        if (string_length(_name_txt) > 10) _name_txt = string_copy(_name_txt, 1, 10);
        draw_text(_cx + _portrait_size * 0.5, _cy + _portrait_size + 6, _name_txt);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
}

// ═══════════════════════════════════════════════════════════════
//  PANEL DE INFORMACIÓN (derecha)
// ═══════════════════════════════════════════════════════════════
{
    var perfil = control_juego.perfiles_personaje[? personajes[indice_personaje]];
    var _datos_clase = scr_datos_clases(perfil.clase);

    var _panel_x = w_gui - 440;
    var _panel_y = 70;
    var _panel_w = 400;
    var _panel_h = 310;

    // Fondo del panel
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_roundrect_ext(_panel_x, _panel_y, _panel_x + _panel_w, _panel_y + _panel_h, 6, 6, false);
    draw_set_alpha(1);

    // Borde
    draw_set_color(make_color_rgb(80, 80, 120));
    draw_roundrect_ext(_panel_x, _panel_y, _panel_x + _panel_w, _panel_y + _panel_h, 6, 6, true);

    var _tx = _panel_x + 16;
    var _ty = _panel_y + 14;
    var _lh = 22;

    // Nombre grande
    draw_set_color(c_white);
    draw_text_transformed(_tx, _ty, personajes[indice_personaje], 1.3, 1.3, 0);
    _ty += 30;

    // Clase
    draw_set_color(c_ltgray);
    draw_text(_tx, _ty, "Clase: ");
    draw_set_color(c_white);
    draw_text(_tx + string_width("Clase: "), _ty, perfil.clase);
    _ty += _lh;

    // Afinidad con icono
    draw_set_color(c_ltgray);
    draw_text(_tx, _ty, "Afinidad: ");
    var _afin_ico = scr_sprite_icono_afinidad(perfil.afinidad);
    var _afin_x = _tx + string_width("Afinidad: ");
    if (_afin_ico != -1) {
        draw_sprite_stretched(_afin_ico, 0, _afin_x, _ty, 16, 16);
        _afin_x += 20;
    }
    draw_set_color(c_white);
    draw_text(_afin_x, _ty, perfil.afinidad);
    _ty += _lh;

    // Personalidad
    draw_set_color(c_ltgray);
    draw_text(_tx, _ty, "Personalidad: ");
    draw_set_color(c_white);
    draw_text(_tx + string_width("Personalidad: "), _ty, perfil.personalidad);
    _ty += _lh + 6;

    // Separador
    draw_set_color(make_color_rgb(60, 60, 80));
    draw_line(_tx, _ty, _panel_x + _panel_w - 16, _ty);
    _ty += 8;

    // Habilidad de clase
    var _hab_clase_nombre = scr_nombre_habilidad(_datos_clase.habilidad_fija);
    draw_set_color(c_orange);
    draw_text(_tx, _ty, "Habilidad [Q]: ");
    draw_set_color(c_white);
    draw_text(_tx + string_width("Habilidad [Q]: "), _ty, _hab_clase_nombre);
    _ty += _lh;

    // Súper-Habilidad
    var _super_nombre = scr_nombre_super(perfil.clase, perfil.personalidad);
    draw_set_color(make_color_rgb(180, 120, 255));
    draw_text(_tx, _ty, "Súper [TAB]: ");
    draw_set_color(c_white);
    draw_text(_tx + string_width("Súper [TAB]: "), _ty, _super_nombre);
    _ty += _lh;

    // Carga de esencia
    draw_set_color(c_ltgray);
    draw_text(_tx, _ty, "Carga esencia: ");
    draw_set_color(make_color_rgb(140, 100, 255));
    draw_text(_tx + string_width("Carga esencia: "), _ty, _datos_clase.carga_esencia);
    _ty += _lh + 6;

    // Separador
    draw_set_color(make_color_rgb(60, 60, 80));
    draw_line(_tx, _ty, _panel_x + _panel_w - 16, _ty);
    _ty += 8;

    // Stats
    draw_set_color(c_aqua);
    draw_text(_tx, _ty, "Estadísticas base:");
    _ty += _lh;
    draw_set_color(c_ltgray);
    draw_text(_tx, _ty, "HP: " + string(_datos_clase.vida) + "   ATK: " + string(_datos_clase.ataque) + "   DEF: " + string(_datos_clase.defensa));
    _ty += _lh;
    draw_text(_tx, _ty, "VEL: " + string(_datos_clase.velocidad) + "   POD: " + string(_datos_clase.poder_elemental) + "   DMAGIC: " + string(_datos_clase.defensa_magica));

    // ═══════════════════════════════════════════════════════════════
    //  4 SLOTS DE EQUIPAMIENTO (debajo del panel de info)
    // ═══════════════════════════════════════════════════════════════
    var _slot_y = _panel_y + _panel_h + 16;
    var _slot_w = 90;
    var _slot_h = 70;
    var _slot_gap = 8;
    var _slots_total_w = 4 * _slot_w + 3 * _slot_gap;
    var _slot_x_start = _panel_x + (_panel_w - _slots_total_w) * 0.5;

    // Verificar disponibilidad
    var _tiene_runas = false;
    var _tiene_objetos = false;
    if (instance_exists(control_juego)) {
        var _todas_runas_disp = scr_lista_runicos_disponibles();
        for (var _ri = 0; _ri < array_length(_todas_runas_disp); _ri++) {
            if (scr_inventario_get_objeto(control_juego, _todas_runas_disp[_ri]) > 0) {
                _tiene_runas = true;
                break;
            }
        }
        var _todos_obj_disp = scr_lista_objetos_disponibles();
        for (var _oi = 0; _oi < array_length(_todos_obj_disp); _oi++) {
            if (scr_inventario_get_objeto(control_juego, _todos_obj_disp[_oi]) > 0) {
                _tiene_objetos = true;
                break;
            }
        }
    }

    var _slot_labels = ["Runa", "Obj 1", "Obj 2", "Obj 3"];
    var _slot_enabled = [_tiene_runas, _tiene_objetos, _tiene_objetos, _tiene_objetos];
    var _slot_contents = ["", "", "", ""];

    // Llenar contenido de slots según selección actual
    if (runa_seleccionada != "") _slot_contents[0] = runa_seleccionada;
    for (var _si = 0; _si < min(3, array_length(objetos_seleccionados)); _si++) {
        _slot_contents[_si + 1] = objetos_seleccionados[_si];
    }

    for (var i = 0; i < 4; i++) {
        var _sx = _slot_x_start + i * (_slot_w + _slot_gap);
        var _sy = _slot_y;
        var _enabled = _slot_enabled[i];
        var _content = _slot_contents[i];

        // Fondo del slot
        draw_set_color(c_black);
        draw_set_alpha(_enabled ? 0.6 : 0.3);
        draw_roundrect_ext(_sx, _sy, _sx + _slot_w, _sy + _slot_h, 4, 4, false);
        draw_set_alpha(1);

        // Borde
        draw_set_color(_enabled ? make_color_rgb(80, 80, 120) : make_color_rgb(40, 40, 50));
        draw_roundrect_ext(_sx, _sy, _sx + _slot_w, _sy + _slot_h, 4, 4, true);

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);

        if (_content != "") {
            // Mostrar contenido equipado
            draw_set_color(i == 0 ? make_color_rgb(200, 150, 255) : c_lime);
            var _ctxt = _content;
            if (string_length(_ctxt) > 10) _ctxt = string_copy(_ctxt, 1, 10);
            draw_text(_sx + _slot_w * 0.5, _sy + _slot_h * 0.35, _ctxt);
        } else {
            // Vacío
            draw_set_color(_enabled ? c_dkgray : make_color_rgb(30, 30, 40));
            draw_text(_sx + _slot_w * 0.5, _sy + _slot_h * 0.35, "—");
        }

        // Etiqueta
        draw_set_color(_enabled ? c_ltgray : make_color_rgb(50, 50, 60));
        draw_set_valign(fa_bottom);
        draw_text(_sx + _slot_w * 0.5, _sy + _slot_h - 6, _slot_labels[i]);

        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
}

// Instrucciones
if (estado == SelState.PERSONAJE) {
    draw_set_color(c_yellow);
    draw_text(40, h_gui - 40, "ENTER: Elegir personalidad  |  ESC: Volver al menú");
}

// =========================
// POPUP DE PERSONALIDAD
// =========================
if (estado == SelState.PERSONALIDAD_POPUP) {

    var _n_pers = array_length(personalidades_lista);

    // Descripciones por personalidad
    var _desc_pers = ds_map_create();
    _desc_pers[? "Agresivo"]  = "Más daño, menor defensa.";
    _desc_pers[? "Metodico"]  = "Equilibrado, sin penalizaciones.";
    _desc_pers[? "Temerario"] = "Alta velocidad, menor HP.";
    _desc_pers[? "Resuelto"]  = "Mayor defensa, menor ataque.";

    // Dimensiones del popup
    var _pw = 420;
    var _ph = 320;
    var _pcx = w_gui / 2;
    var _pcy = h_gui / 2;
    var _px1 = _pcx - _pw / 2;
    var _py1 = _pcy - _ph / 2;

    // Fondo oscurecido
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(0, 0, w_gui, h_gui, false);
    draw_set_alpha(1);

    // Panel principal
    draw_set_color(make_color_rgb(18, 18, 28));
    draw_roundrect_ext(_px1, _py1, _px1 + _pw, _py1 + _ph, 8, 8, false);
    draw_set_color(make_color_rgb(90, 90, 140));
    draw_roundrect_ext(_px1, _py1, _px1 + _pw, _py1 + _ph, 8, 8, true);

    // Barra de título
    draw_set_color(make_color_rgb(30, 30, 50));
    draw_roundrect_ext(_px1, _py1, _px1 + _pw, _py1 + 36, 8, 8, false);
    draw_set_color(make_color_rgb(90, 90, 140));
    draw_line(_px1, _py1 + 36, _px1 + _pw, _py1 + 36);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(_pcx, _py1 + 18, "PERSONALIDAD DE " + personajes[indice_personaje]);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // Lista de personalidades
    var _list_y = _py1 + 52;
    var _item_h = 50;

    for (var i = 0; i < _n_pers; i++) {
        var _iy = _list_y + i * _item_h;
        var _is_sel = (i == indice_personalidad);
        var _pers_name = personalidades_lista[i];

        // Fondo del item
        draw_set_color(_is_sel ? make_color_rgb(50, 50, 80) : make_color_rgb(22, 22, 34));
        draw_set_alpha(_is_sel ? 0.9 : 0.5);
        draw_roundrect_ext(_px1 + 16, _iy, _px1 + _pw - 16, _iy + _item_h - 4, 4, 4, false);
        draw_set_alpha(1);

        // Borde de selección
        if (_is_sel) {
            draw_set_color(c_yellow);
            draw_roundrect_ext(_px1 + 16, _iy, _px1 + _pw - 16, _iy + _item_h - 4, 4, 4, true);
        }

        // Indicador y nombre
        draw_set_valign(fa_middle);
        if (_is_sel) {
            draw_set_color(c_white);
            draw_text(_px1 + 26, _iy + 14, ">");
        }
        draw_set_color(_is_sel ? c_yellow : c_ltgray);
        draw_text(_px1 + 42, _iy + 14, _pers_name);

        // Actualizar Súper nombre según personalidad
        var _super_prev = scr_nombre_super(perfil.clase, _pers_name);
        draw_set_color(make_color_rgb(180, 120, 255));
        draw_text(_px1 + 180, _iy + 14, "Súper: " + _super_prev);

        // Descripción
        draw_set_color(_is_sel ? c_white : make_color_rgb(120, 120, 140));
        draw_text(_px1 + 42, _iy + 34, _desc_pers[? _pers_name]);
        draw_set_valign(fa_top);
    }

    // Instrucciones
    draw_set_color(make_color_rgb(60, 60, 80));
    draw_line(_px1 + 16, _py1 + _ph - 40, _px1 + _pw - 16, _py1 + _ph - 40);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_ltgray);
    draw_text(_pcx, _py1 + _ph - 22, "Arriba/Abajo: Elegir   ENTER: Confirmar   ESC: Volver");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    ds_map_destroy(_desc_pers);
}

// =========================
// POPUP DE ARMAS
// =========================
if (estado == SelState.ARMA_POPUP) {

    var armas = scr_ds_map_keys_array(perfil.armas_obtenidas);
    var _n_armas = array_length(armas);

    // Dimensiones del popup
    var _pw = 620;
    var _ph = 520;
    var _pcx = w_gui / 2;
    var _pcy = h_gui / 2;
    var _px1 = _pcx - _pw / 2;
    var _py1 = _pcy - _ph / 2;

    // Fondo oscurecido
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(0, 0, w_gui, h_gui, false);
    draw_set_alpha(1);

    // Panel principal
    draw_set_color(make_color_rgb(18, 18, 28));
    draw_roundrect_ext(_px1, _py1, _px1 + _pw, _py1 + _ph, 8, 8, false);
    draw_set_color(make_color_rgb(90, 90, 140));
    draw_roundrect_ext(_px1, _py1, _px1 + _pw, _py1 + _ph, 8, 8, true);

    // Barra de título
    draw_set_color(make_color_rgb(30, 30, 50));
    draw_roundrect_ext(_px1, _py1, _px1 + _pw, _py1 + 36, 8, 8, false);
    draw_set_color(make_color_rgb(90, 90, 140));
    draw_line(_px1, _py1 + 36, _px1 + _pw, _py1 + 36);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(_pcx, _py1 + 18, "ARMAS DE " + perfil.nombre);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // Zona izquierda: lista de armas CON SCROLL
    var _list_x = _px1 + 16;
    var _list_y = _py1 + 48;
    var _list_w = 220;
    var _item_h = 32;
    var _list_h_max = _ph - 48 - 50;  // altura visible de la lista
    var _items_visibles = floor(_list_h_max / _item_h);

    // Calcular offset de scroll para mantener selección visible
    var _scroll_offset = 0;
    if (_n_armas > _items_visibles) {
        _scroll_offset = clamp(indice_arma - floor(_items_visibles / 2), 0, _n_armas - _items_visibles);
    }

    // Indicadores de scroll
    if (_scroll_offset > 0) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_yellow);
        draw_text(_list_x + _list_w * 0.5, _list_y - 8, "▲ " + string(_scroll_offset) + " más");
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }

    var _i_start = _scroll_offset;
    var _i_end = min(_n_armas, _scroll_offset + _items_visibles);

    for (var i = _i_start; i < _i_end; i++) {
        var _draw_idx = i - _scroll_offset;
        var _iy = _list_y + _draw_idx * _item_h;
        var _is_sel = (i == indice_arma);
        var _arma_datos = scr_datos_armas(armas[i]);

        // Color de rareza
        var _rar_col = c_ltgray;
        if (variable_struct_exists(_arma_datos, "rareza")) {
            if (_arma_datos.rareza == 1) _rar_col = make_color_rgb(100, 200, 100);
            else if (_arma_datos.rareza == 2) _rar_col = make_color_rgb(100, 160, 255);
            else if (_arma_datos.rareza == 3) _rar_col = make_color_rgb(255, 180, 80);
        }

        // Fondo del item
        draw_set_color(_is_sel ? make_color_rgb(50, 50, 80) : make_color_rgb(22, 22, 34));
        draw_set_alpha(_is_sel ? 0.9 : 0.5);
        draw_roundrect_ext(_list_x, _iy, _list_x + _list_w, _iy + _item_h - 2, 4, 4, false);
        draw_set_alpha(1);

        // Borde selección
        if (_is_sel) {
            draw_set_color(_rar_col);
            draw_roundrect_ext(_list_x, _iy, _list_x + _list_w, _iy + _item_h - 2, 4, 4, true);
        }

        // Indicador de selección
        draw_set_valign(fa_middle);
        if (_is_sel) {
            draw_set_color(c_white);
            draw_text(_list_x + 8, _iy + _item_h * 0.5, ">");
        }

        // Nombre del arma
        draw_set_color(_is_sel ? _rar_col : make_color_rgb(140, 140, 160));
        var _arma_txt = armas[i];
        if (string_length(_arma_txt) > 20) _arma_txt = string_copy(_arma_txt, 1, 20);
        draw_text(_list_x + 24, _iy + _item_h * 0.5, _arma_txt);
        draw_set_valign(fa_top);
    }

    // Indicador de scroll inferior
    var _restantes_abajo = _n_armas - _i_end;
    if (_restantes_abajo > 0) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_yellow);
        draw_text(_list_x + _list_w * 0.5, _list_y + _items_visibles * _item_h + 6, "▼ " + string(_restantes_abajo) + " más");
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }

    // Zona derecha: info del arma seleccionada
    if (_n_armas > 0) {
        var _info_x = _px1 + _list_w + 40;
        var _info_y = _py1 + 48;
        var _info_w = _pw - _list_w - 56;
        var _lh = 21;

        var _sel_arma = armas[indice_arma];
        var _arma_d = scr_datos_armas(_sel_arma);

        // Panel info fondo
        draw_set_color(make_color_rgb(14, 14, 22));
        draw_set_alpha(0.6);
        draw_roundrect_ext(_info_x - 8, _info_y - 4, _info_x + _info_w + 8, _py1 + _ph - 52, 6, 6, false);
        draw_set_alpha(1);

        var _ity = _info_y + 4;

        // Nombre grande
        var _rar_col2 = c_white;
        if (variable_struct_exists(_arma_d, "rareza")) {
            if (_arma_d.rareza == 1) _rar_col2 = make_color_rgb(100, 200, 100);
            else if (_arma_d.rareza == 2) _rar_col2 = make_color_rgb(100, 160, 255);
            else if (_arma_d.rareza == 3) _rar_col2 = make_color_rgb(255, 180, 80);
        }
        draw_set_color(_rar_col2);
        draw_text_transformed(_info_x, _ity, _sel_arma, 1.1, 1.1, 0);
        _ity += 26;

        // Afinidad con icono
        if (variable_struct_exists(_arma_d, "afinidad")) {
            draw_set_color(c_ltgray);
            draw_text(_info_x, _ity, "Afinidad: ");
            var _afn_ico = scr_sprite_icono_afinidad(_arma_d.afinidad);
            var _afn_x = _info_x + string_width("Afinidad: ");
            if (_afn_ico != -1) {
                draw_sprite_stretched(_afn_ico, 0, _afn_x, _ity, 14, 14);
                _afn_x += 18;
            }
            draw_set_color(c_white);
            draw_text(_afn_x, _ity, _arma_d.afinidad);
            _ity += _lh;
        }

        // Rareza
        if (variable_struct_exists(_arma_d, "rareza")) {
            draw_set_color(c_ltgray);
            var _rar_txt = "";
            for (var _ri = 0; _ri < _arma_d.rareza; _ri++) _rar_txt += "*";
            if (_rar_txt == "") _rar_txt = "—";
            draw_text(_info_x, _ity, "Rareza: ");
            draw_set_color(_rar_col2);
            draw_text(_info_x + string_width("Rareza: "), _ity, _rar_txt);
            _ity += _lh;
        }

        _ity += 4;
        draw_set_color(make_color_rgb(60, 60, 80));
        draw_line(_info_x, _ity, _info_x + _info_w, _ity);
        _ity += 8;

        // Stats bonus
        draw_set_color(c_aqua);
        draw_text(_info_x, _ity, "Bonificaciones:");
        _ity += _lh;
        draw_set_color(c_ltgray);
        if (variable_struct_exists(_arma_d, "ataque_bonus") && _arma_d.ataque_bonus != 0) {
            draw_set_color(c_lime);
            draw_text(_info_x, _ity, "ATK +" + string(_arma_d.ataque_bonus));
            _ity += _lh;
        }
        if (variable_struct_exists(_arma_d, "poder_elemental_bonus") && _arma_d.poder_elemental_bonus != 0) {
            draw_set_color(make_color_rgb(180, 120, 255));
            draw_text(_info_x, _ity, "POD +" + string(_arma_d.poder_elemental_bonus));
            _ity += _lh;
        }
        if (variable_struct_exists(_arma_d, "defensa_bonus") && _arma_d.defensa_bonus != 0) {
            draw_set_color(make_color_rgb(100, 180, 255));
            draw_text(_info_x, _ity, "DEF +" + string(_arma_d.defensa_bonus));
            _ity += _lh;
        }
        if (variable_struct_exists(_arma_d, "vida_bonus") && _arma_d.vida_bonus != 0) {
            draw_set_color(make_color_rgb(100, 255, 100));
            draw_text(_info_x, _ity, "HP +" + string(_arma_d.vida_bonus));
            _ity += _lh;
        }

        // Habilidades
        if (variable_struct_exists(_arma_d, "habilidades_arma")) {
            _ity += 4;
            draw_set_color(make_color_rgb(60, 60, 80));
            draw_line(_info_x, _ity, _info_x + _info_w, _ity);
            _ity += 8;
            draw_set_color(c_orange);
            draw_text(_info_x, _ity, "Habilidades:");
            _ity += _lh;
            for (var _hi = 0; _hi < array_length(_arma_d.habilidades_arma); _hi++) {
                draw_set_color(c_yellow);
                var _h_nom = scr_nombre_habilidad(_arma_d.habilidades_arma[_hi]);
                draw_text(_info_x + 8, _ity, "• " + _h_nom);
                _ity += _lh;
            }
        }
    }

    // Instrucciones en la parte inferior
    draw_set_color(make_color_rgb(60, 60, 80));
    draw_line(_px1 + 16, _py1 + _ph - 40, _px1 + _pw - 16, _py1 + _ph - 40);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_ltgray);
    draw_text(_pcx, _py1 + _ph - 22, "Arriba/Abajo: Elegir   ENTER: Equipar   ESC: Volver");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// =========================
// POPUP DE OBJETOS
// =========================
if (estado == SelState.OBJETOS_POPUP) {

    var w = 420;
    var h = 340;
    var cx = w_gui / 2;
    var cy = h_gui / 2;

    var x1 = cx - w / 2;
    var y1 = cy - h / 2;

    // Fondo semi-transparente
    draw_set_color(c_black);
    draw_set_alpha(0.85);
    draw_rectangle(0, 0, w_gui, h_gui, false);
    draw_set_alpha(1);

    // Ventana
    draw_set_color(c_black);
    draw_rectangle(x1, y1, x1 + w, y1 + h, false);
    draw_set_color(make_color_rgb(80, 80, 120));
    draw_rectangle(x1, y1, x1 + w, y1 + h, true);

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

// =========================
// POPUP DE RUNAS
// =========================
if (estado == SelState.RUNA_POPUP) {

    var w = 480;
    var h = 380;
    var cx = w_gui / 2;
    var cy = h_gui / 2;

    var x1 = cx - w / 2;
    var y1 = cy - h / 2;

    // Fondo semi-transparente
    draw_set_color(c_black);
    draw_set_alpha(0.85);
    draw_rectangle(0, 0, w_gui, h_gui, false);
    draw_set_alpha(1);

    // Ventana
    draw_set_color(c_black);
    draw_rectangle(x1, y1, x1 + w, y1 + h, false);
    draw_set_color(make_color_rgb(80, 80, 120));
    draw_rectangle(x1, y1, x1 + w, y1 + h, true);

    draw_set_color(make_color_rgb(180, 120, 255));
    draw_text(x1 + 20, y1 + 15, "EQUIPAR RUNA (máx. 1)");
    draw_set_color(c_gray);
    draw_text(x1 + 20, y1 + 35, "Ventaja a cambio de desventaja. Se consume al terminar.");

    var ry = y1 + 65;
    var n_runas = array_length(runas_disponibles);

    for (var i = 0; i < n_runas; i++) {
        var _runa_nom = runas_disponibles[i];
        var _cant = scr_inventario_get_objeto(control_juego, _runa_nom);

        if (i == indice_runa) {
            draw_set_color(make_color_rgb(220, 180, 255));
            draw_text(x1 + 30, ry, "> " + _runa_nom + "  (x" + string(_cant) + ")");
        } else {
            draw_set_color(c_ltgray);
            draw_text(x1 + 50, ry, _runa_nom + "  (x" + string(_cant) + ")");
        }
        ry += 28;
    }

    // Opción "Sin runa"
    if (indice_runa == n_runas) {
        draw_set_color(c_yellow);
        draw_text(x1 + 30, ry, "> Sin runa");
    } else {
        draw_set_color(c_gray);
        draw_text(x1 + 50, ry, "Sin runa");
    }
    ry += 35;

    // Descripción de la runa seleccionada
    if (indice_runa < n_runas) {
        var _sel_runa = runas_disponibles[indice_runa];
        var _datos_r = scr_datos_objetos(_sel_runa);
        draw_set_color(c_ltgray);
        draw_text(x1 + 20, ry, _datos_r.descripcion);
        ry += 22;
        draw_set_color(c_lime);
        draw_text(x1 + 20, ry, "+ " + _datos_r.ventaja);
        ry += 20;
        draw_set_color(c_red);
        draw_text(x1 + 20, ry, "- " + _datos_r.desventaja);
    }

    draw_set_color(c_white);
    draw_text(x1 + 20, y1 + h - 22, "ENTER: Confirmar  |  ESC: Volver a objetos");
}

// ═══════════════════════════════════════════════════════════════
//  ICONO DE AYUDA (esquina inferior derecha) + PANEL VERTICAL
// ═══════════════════════════════════════════════════════════════
{
    var _gw = w_gui;
    var _gh = h_gui;

    // ── Icono "?" ──
    var _ix = _gw - guia_ico_margin - guia_ico_size;
    var _iy = _gh - guia_ico_margin - guia_ico_size;

    var _ico_col = mostrar_guia ? c_yellow : make_color_rgb(80, 80, 120);
    draw_set_color(c_black);
    draw_set_alpha(0.6);
    draw_roundrect_ext(_ix, _iy, _ix + guia_ico_size, _iy + guia_ico_size, 10, 10, false);
    draw_set_alpha(1);
    draw_set_color(_ico_col);
    draw_roundrect_ext(_ix, _iy, _ix + guia_ico_size, _iy + guia_ico_size, 10, 10, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(_ico_col);
    draw_text(_ix + guia_ico_size * 0.5, _iy + guia_ico_size * 0.5, "H");

    // ── Panel vertical ──
    if (guia_anim > 0.01) {
        var _panel_w = 280;
        var _panel_h_full = 220;
        var _panel_h_vis = round(_panel_h_full * guia_anim);
        var _panel_x = _ix + guia_ico_size - _panel_w;
        var _panel_bottom = _iy - 6;
        var _panel_top = _panel_bottom - _panel_h_vis;

        draw_set_color(c_black);
        draw_set_alpha(0.75 * guia_anim);
        draw_roundrect_ext(_panel_x, _panel_top, _panel_x + _panel_w, _panel_bottom, 8, 8, false);
        draw_set_alpha(1);
        draw_set_color(make_color_rgb(80, 80, 120));
        draw_set_alpha(guia_anim);
        draw_roundrect_ext(_panel_x, _panel_top, _panel_x + _panel_w, _panel_bottom, 8, 8, true);
        draw_set_alpha(1);

        if (guia_anim > 0.5) {
            var _txt_alpha = clamp((guia_anim - 0.5) * 2, 0, 1);
            draw_set_alpha(_txt_alpha);
            var _lx = _panel_x + 16;
            var _full_top = _panel_bottom - _panel_h_full;
            var _ly = _full_top + 12;
            var _lh = 19;
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);

            draw_set_color(c_yellow);
            draw_text(_lx, _ly, "── SELECCIÓN ──");
            _ly += _lh + 4;
            draw_set_color(c_ltgray);
            draw_text(_lx, _ly, "Izq / Der    Elegir personaje"); _ly += _lh;
            draw_text(_lx, _ly, "Arriba / Abajo    Fila anterior/sig."); _ly += _lh;
            draw_text(_lx, _ly, "Enter    Confirmar"); _ly += _lh;
            draw_text(_lx, _ly, "Escape   Volver"); _ly += _lh + 4;
            draw_set_color(c_aqua);
            draw_text(_lx, _ly, "EQUIPAMIENTO"); _ly += _lh;
            draw_set_color(c_ltgray);
            draw_text(_lx, _ly, "TAB      Sel/Desel objeto"); _ly += _lh;
            draw_text(_lx, _ly, "Elige arma, objetos y runa"); _ly += _lh + 4;
            draw_set_color(make_color_rgb(120, 120, 120));
            draw_text(_lx, _ly, "H  Cerrar este panel");
            draw_set_alpha(1);
        }
    }
}

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);