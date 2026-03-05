/// DRAW GUI — obj_enemy_select

// Fondo
draw_sprite_stretched(spr_bg_enemy_select, 0, 0, 0, display_get_gui_width(), display_get_gui_height());

draw_set_font(fnt_1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var w_gui = display_get_gui_width();
var h_gui = display_get_gui_height();

// Título
draw_set_color(c_white);
draw_text(40, 20, "SELECCIÓN DE ENEMIGO");

// ═══════════════════════════════════════════════════════════════
//  TABS DE CATEGORÍA (horizontal en la parte superior)
// ═══════════════════════════════════════════════════════════════
{
    var _tab_y = 58;
    var _tab_h = 28;
    var _tab_x_start = 40;
    var _tab_gap = 10;

    for (var i = 0; i < array_length(categorias); i++) {
        var _tab_txt = categorias[i];
        var _tw = string_width(_tab_txt) + 32;
        var _tx = _tab_x_start;
        var _sel = (i == indice_categoria);

        // Colores por categoría
        var _col_bg, _col_borde, _col_txt;
        switch (categorias[i]) {
            case "Común":
                _col_bg     = _sel ? make_color_rgb(50, 70, 50)   : make_color_rgb(20, 30, 20);
                _col_borde  = _sel ? make_color_rgb(120, 200, 120): make_color_rgb(50, 80, 50);
                _col_txt    = _sel ? make_color_rgb(160, 255, 160): make_color_rgb(100, 140, 100);
                break;
            case "Élite":
                _col_bg     = _sel ? make_color_rgb(60, 40, 90)   : make_color_rgb(25, 15, 40);
                _col_borde  = _sel ? make_color_rgb(180, 140, 255): make_color_rgb(80, 60, 120);
                _col_txt    = _sel ? make_color_rgb(200, 170, 255): make_color_rgb(140, 110, 180);
                break;
            case "Jefe":
                _col_bg     = _sel ? make_color_rgb(90, 30, 30)   : make_color_rgb(40, 12, 12);
                _col_borde  = _sel ? make_color_rgb(255, 100, 80) : make_color_rgb(120, 50, 40);
                _col_txt    = _sel ? make_color_rgb(255, 130, 100): make_color_rgb(180, 80, 60);
                if (_sel) { _tw += 8; }
                break;
            default: // Random
                _col_bg     = _sel ? make_color_rgb(60, 60, 100)  : c_black;
                _col_borde  = _sel ? c_yellow : make_color_rgb(60, 60, 80);
                _col_txt    = _sel ? c_yellow : c_ltgray;
                break;
        }

        // Fondo de tab
        draw_set_color(_col_bg);
        draw_set_alpha(_sel ? 0.95 : 0.6);
        draw_roundrect_ext(_tx, _tab_y, _tx + _tw, _tab_y + _tab_h, 4, 4, false);
        draw_set_alpha(1);

        // Borde
        draw_set_color(_col_borde);
        draw_roundrect_ext(_tx, _tab_y, _tx + _tw, _tab_y + _tab_h, 4, 4, true);

        // Icono de categoría
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        var _ico_txt = "";
        if (categorias[i] == "Jefe")       _ico_txt = "";
        else if (categorias[i] == "Élite") _ico_txt = "";

        // Texto
        draw_set_color(_col_txt);
        draw_text(_tx + _tw * 0.5, _tab_y + _tab_h * 0.5, _ico_txt + _tab_txt);

        _tab_x_start += _tw + _tab_gap;
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// ═══════════════════════════════════════════════════════════════
//  CONTENIDO según estado
// ═══════════════════════════════════════════════════════════════

if (estado == EnemySelState.CATEGORIA) {
    // Solo mostrar las categorías (tabs), con instrucciones
    draw_set_color(c_ltgray);
    draw_text(40, 110, "Izq/Der: Elegir categoria    ENTER: Confirmar    ESC: Volver");
}

else if (estado == EnemySelState.LISTA) {

    // ── Grid de retratos de enemigos ──
    var _grid_x = 40;
    var _grid_y = 110;
    var _cell_w = 120;
    var _cell_h = 140;
    var _portrait_size = 96;
    var _cols = sel_cols;
    var _en_count = array_length(enemigos_actuales);

    // Determinar rango del enemigo según categoría
    var _cat_name = categorias[indice_categoria];
    var _rango = "Común";
    if (_cat_name == "Élite") _rango = "Élite";
    else if (_cat_name == "Jefe") _rango = "Jefe";

    for (var i = 0; i < _en_count; i++) {
        var _col = i mod _cols;
        var _row = i div _cols;
        var _cx = _grid_x + _col * _cell_w;
        var _cy = _grid_y + _row * _cell_h;
        var _sel = (i == indice_enemigo);

        // Retrato
        var _spr_r = scr_sprite_enemigo(enemigos_actuales[i], _rango, true);
        var _rs = _portrait_size / sprite_get_width(_spr_r);

        // Glow de selección
        if (_sel) {
            draw_set_color(c_yellow);
            draw_set_alpha(0.25 + 0.1 * sin(current_time * 0.004));
            draw_roundrect_ext(_cx - 4, _cy - 4, _cx + _portrait_size + 4, _cy + _portrait_size + 4, 4, 4, false);
            draw_set_alpha(1);
        }

        // Sprite
        draw_sprite_ext(_spr_r, 0, _cx, _cy, _rs, _rs, 0, c_white, 1);

        // Marco
        draw_sprite_stretched(spr_marco_retrato, 0, _cx - 4, _cy - 4, _portrait_size + 8, _portrait_size + 8);
        var _bord_col = _sel ? c_yellow : make_color_rgb(100, 100, 120);
        draw_set_color(_bord_col);
        draw_rectangle(_cx - 4, _cy - 4, _cx + _portrait_size + 4, _cy + _portrait_size + 4, true);

        // Nombre debajo
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_set_color(_sel ? c_yellow : c_ltgray);
        var _name_txt = enemigos_actuales[i];
        if (string_length(_name_txt) > 14) _name_txt = string_copy(_name_txt, 1, 14);
        draw_text(_cx + _portrait_size * 0.5, _cy + _portrait_size + 6, _name_txt);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }

    // ── Panel de información (derecha) ──
    if (_en_count > 0) {
        var _nombre_sel = enemigos_actuales[indice_enemigo];
        var _datos_en = scr_datos_enemigos(_nombre_sel);

        var _panel_x = w_gui - 440;
        var _panel_y = 110;
        var _panel_w = 400;
        var _panel_h = 280;

        // Fondo
        draw_set_color(c_black);
        draw_set_alpha(0.7);
        draw_roundrect_ext(_panel_x, _panel_y, _panel_x + _panel_w, _panel_y + _panel_h, 6, 6, false);
        draw_set_alpha(1);
        draw_set_color(make_color_rgb(80, 80, 120));
        draw_roundrect_ext(_panel_x, _panel_y, _panel_x + _panel_w, _panel_y + _panel_h, 6, 6, true);

        var _tx = _panel_x + 16;
        var _ty = _panel_y + 14;
        var _lh = 22;

        // Nombre
        draw_set_color(c_white);
        draw_text_transformed(_tx, _ty, _nombre_sel, 1.2, 1.2, 0);
        _ty += 28;

        // Rango
        draw_set_color(c_ltgray);
        draw_text(_tx, _ty, "Rango: ");
        var _rc = c_white;
        if (_rango == "Élite") _rc = make_color_rgb(180, 140, 255);
        else if (_rango == "Jefe") _rc = c_red;
        draw_set_color(_rc);
        draw_text(_tx + string_width("Rango: "), _ty, _rango);
        _ty += _lh;

        // Afinidad
        if (variable_struct_exists(_datos_en, "afinidad")) {
            draw_set_color(c_ltgray);
            draw_text(_tx, _ty, "Afinidad: ");
            var _afin_ico = scr_sprite_icono_afinidad(_datos_en.afinidad);
            var _afin_x = _tx + string_width("Afinidad: ");
            if (_afin_ico != -1) {
                draw_sprite_stretched(_afin_ico, 0, _afin_x, _ty, 16, 16);
                _afin_x += 20;
            }
            draw_set_color(c_white);
            draw_text(_afin_x, _ty, _datos_en.afinidad);
            _ty += _lh;
        }

        _ty += 6;

        // Separador
        draw_set_color(make_color_rgb(60, 60, 80));
        draw_line(_tx, _ty, _panel_x + _panel_w - 16, _ty);
        _ty += 8;

        // Habilidades
        draw_set_color(c_orange);
        draw_text(_tx, _ty, "Habilidades:");
        _ty += _lh;

        // Habilidad fija
        if (variable_struct_exists(_datos_en, "habilidad_fija")) {
            draw_set_color(c_yellow);
            var _h_nombre = scr_nombre_habilidad(_datos_en.habilidad_fija);
            draw_text(_tx + 10, _ty, "• " + _h_nombre);
            _ty += _lh;
        }

        // Habilidad secundaria
        if (variable_struct_exists(_datos_en, "habilidad_secundaria")) {
            draw_set_color(make_color_rgb(200, 180, 100));
            var _h2_nombre = scr_nombre_habilidad(_datos_en.habilidad_secundaria);
            draw_text(_tx + 10, _ty, "• " + _h2_nombre);
            _ty += _lh;
        }

        // Patrón
        if (variable_struct_exists(_datos_en, "patron")) {
            _ty += 4;
            draw_set_color(c_ltgray);
            var _patron_txt = "";
            if (is_array(_datos_en.patron)) {
                var _plen = min(array_length(_datos_en.patron), 4);
                for (var _pi = 0; _pi < _plen; _pi++) {
                    if (_pi > 0) _patron_txt += " >> ";
                    _patron_txt += scr_nombre_habilidad(_datos_en.patron[_pi]);
                }
                if (array_length(_datos_en.patron) > 4) _patron_txt += " ...";
            } else {
                _patron_txt = string(_datos_en.patron);
            }
            draw_text(_tx, _ty, "Patrón: " + _patron_txt);
            _ty += _lh;
        }

        // Stats básicos
        _ty += 6;
        draw_set_color(make_color_rgb(60, 60, 80));
        draw_line(_tx, _ty, _panel_x + _panel_w - 16, _ty);
        _ty += 8;

        draw_set_color(c_aqua);
        draw_text(_tx, _ty, "Estadísticas:");
        _ty += _lh;
        draw_set_color(c_ltgray);
        if (variable_struct_exists(_datos_en, "vida")) {
            draw_text(_tx, _ty, "HP: " + string(_datos_en.vida) + "   ATK: " + string(_datos_en.ataque) + "   DEF: " + string(_datos_en.defensa));
        }
    }

    // Instrucciones
    draw_set_color(c_yellow);
    draw_text(40, h_gui - 40, "Flechas: Elegir    ENTER: Combatir    ESC: Volver");
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
        var _panel_h_full = 180;
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
            draw_text(_lx, _ly, "── ENEMIGO ──");
            _ly += _lh + 4;
            draw_set_color(c_ltgray);
            draw_text(_lx, _ly, "Izq / Der    Categoria / enemigo"); _ly += _lh;
            draw_text(_lx, _ly, "Arriba / Abajo    Fila anterior/sig."); _ly += _lh;
            draw_text(_lx, _ly, "Enter    Confirmar enemigo"); _ly += _lh;
            draw_text(_lx, _ly, "Escape   Volver"); _ly += _lh + 4;
            draw_set_color(make_color_rgb(120, 120, 120));
            draw_text(_lx, _ly, "H  Cerrar este panel");
            draw_set_alpha(1);
        }
    }
}

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);