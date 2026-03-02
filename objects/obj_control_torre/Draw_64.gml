/// DRAW GUI — obj_control_torre

// Solo dibujar en rm_torre
if (room != rm_torre) exit;

// Fondo
draw_sprite_stretched(spr_bg_torre, 0, 0, 0, display_get_gui_width(), display_get_gui_height());

draw_set_font(fnt_1);
var w_gui = display_get_gui_width();
var h_gui = display_get_gui_height();
var cx = w_gui * 0.5;
var control_juego = instance_find(obj_control_juego, 0);

// ═══════════════════════════════════════════
//  HEADER COMÚN (siempre visible en rm_torre)
// ═══════════════════════════════════════════
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_color(make_color_rgb(255, 215, 0));
if (instance_exists(control_juego)) {
    draw_text(w_gui - 20, 10, "Oro: " + string(control_juego.oro) + " G");
}

// ═══════════════════════════════════════════
//  FASE: SELECCIÓN DE ALA
// ═══════════════════════════════════════════
if (torre_fase == "seleccion_ala") {

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_text(cx, 40, "MODO TORRE");
    draw_set_color(c_gray);
    draw_text(cx, 65, "Elige un Ala para explorar");

    var _alas = scr_torre_get_alas();

    for (var i = 0; i < array_length(_alas); i++) {
        var _a = _alas[i];
        var _bx = cx - 200;
        var _by = 120 + i * 130;
        var _bw = 400;
        var _bh = 110;

        var _sel = (i == sel_ala_indice);

        // Fondo del panel
        draw_set_color(_sel ? make_color_rgb(40, 40, 60) : make_color_rgb(20, 20, 30));
        draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);

        // Marco
        draw_set_color(_sel ? _a.color : c_dkgray);
        draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, true);

        // Texto
        draw_set_halign(fa_left);
        draw_set_color(_sel ? _a.color : c_white);
        draw_text(_bx + 15, _by + 10, _a.nombre);

        draw_set_color(_sel ? c_ltgray : c_gray);
        draw_text(_bx + 15, _by + 30, _a.subtitulo);

        draw_set_color(c_gray);
        draw_text(_bx + 15, _by + 55, _a.descripcion);

        // Afinidades
        draw_set_color(c_dkgray);
        var _afi_txt = "";
        for (var j = 0; j < array_length(_a.afinidades); j++) {
            if (j > 0) _afi_txt += "  |  ";
            _afi_txt += _a.afinidades[j];
        }
        draw_text(_bx + 15, _by + _bh - 22, _afi_txt);
    }

    draw_set_halign(fa_center);
    draw_set_color(c_dkgray);
    draw_text(cx, h_gui - 30, "ENTER: Seleccionar  |  ESC: Volver al menú");
}

// ═══════════════════════════════════════════
//  FASE: SELECCIÓN DE DIFICULTAD
// ═══════════════════════════════════════════
else if (torre_fase == "seleccion_dificultad") {

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(torre_ala.color);
    draw_text(cx, 40, torre_ala.nombre + " — Seleccionar Dificultad");

    var _difs = scr_torre_get_dificultades();

    for (var i = 0; i < array_length(_difs); i++) {
        var _d = _difs[i];
        var _bx = cx - 220;
        var _by = 110 + i * 130;
        var _bw = 440;
        var _bh = 110;

        var _sel = (i == sel_dif_indice);

        draw_set_color(_sel ? make_color_rgb(40, 40, 60) : make_color_rgb(20, 20, 30));
        draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);

        draw_set_color(_sel ? _d.color : c_dkgray);
        draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, true);

        draw_set_halign(fa_left);
        draw_set_color(_sel ? _d.color : c_white);
        draw_text(_bx + 15, _by + 10, _d.nombre);

        draw_set_color(c_ltgray);
        draw_text(_bx + 15, _by + 32, "Pisos: " + string(_d.pisos_total));
        draw_text(_bx + 15, _by + 50, "HP enemigos: +" + string(_d.hp_bonus_pct) + "%");
        draw_text(_bx + 15, _by + 68, "Tienda cada: " + string(_d.tienda_cada) + " pisos");

        draw_set_halign(fa_right);
        draw_set_color(c_gray);
        if (_d.usa_elites) draw_text(_bx + _bw - 15, _by + 32, "Incluye Elites");
        if (_d.tiene_jefe_final) draw_text(_bx + _bw - 15, _by + 50, "Jefe Final");

        var _oro_txt = (_d.oro_bonus_pct >= 0) ? "+" + string(_d.oro_bonus_pct) + "%" : string(_d.oro_bonus_pct) + "%";
        draw_set_color((_d.oro_bonus_pct >= 0) ? c_lime : c_orange);
        draw_text(_bx + _bw - 15, _by + 68, "Oro: " + _oro_txt);
    }

    draw_set_halign(fa_center);
    draw_set_color(c_dkgray);
    draw_text(cx, h_gui - 30, "ENTER: Seleccionar  |  ESC: Volver");
}

// ═══════════════════════════════════════════
//  FASE: SELECCIÓN DE PERSONAJE
// ═══════════════════════════════════════════
else if (torre_fase == "seleccion_personaje") {

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(torre_ala.color);
    draw_text(cx, 40, torre_ala.nombre + " (" + torre_dificultad.nombre + ") — Elegir Personaje");

    if (instance_exists(control_juego)) {
        var _nombres = scr_ds_map_keys_array(control_juego.perfiles_personaje);

        for (var i = 0; i < array_length(_nombres); i++) {
            var _nom = _nombres[i];
            var _perfil = control_juego.perfiles_personaje[? _nom];
            var _sel = (i == sel_pj_indice);

            var _txt_col = _sel ? c_yellow : c_white;
            var _pre = _sel ? "> " : "  ";

            draw_set_halign(fa_left);
            draw_set_color(_txt_col);
            draw_text(cx - 200, 100 + i * 30, _pre + _nom + "  (" + _perfil.clase + " / " + _perfil.afinidad + ")");
        }
    }

    draw_set_halign(fa_center);
    draw_set_color(c_dkgray);
    draw_text(cx, h_gui - 30, "ENTER: Seleccionar  |  ESC: Volver");
}

// ═══════════════════════════════════════════
//  FASE: SELECCIÓN DE ARMA
// ═══════════════════════════════════════════
else if (torre_fase == "seleccion_arma") {

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_text(cx, 40, "Elegir Arma para " + torre_perfil_nombre);

    for (var i = 0; i < array_length(torre_armas_disponibles); i++) {
        var _sel = (i == sel_arma_indice);
        draw_set_halign(fa_left);
        draw_set_color(_sel ? c_yellow : c_white);
        draw_text(cx - 150, 100 + i * 30, (_sel ? "> " : "  ") + torre_armas_disponibles[i]);
    }

    draw_set_halign(fa_center);
    draw_set_color(c_dkgray);
    draw_text(cx, h_gui - 30, "ENTER: Seleccionar  |  ESC: Volver");
}

// ═══════════════════════════════════════════
//  FASE: PRE-COMBATE (pantalla entre pisos)
// ═══════════════════════════════════════════
else if (torre_fase == "pre_combate") {

    // Fondo sutil
    draw_set_color(c_black);
    draw_set_alpha(0.3);
    draw_rectangle(0, 0, w_gui, h_gui, false);
    draw_set_alpha(1);

    // Título
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(torre_ala.color);
    draw_text(cx, 50, torre_ala.nombre + " — " + torre_dificultad.nombre);

    // Piso actual
    draw_set_color(c_yellow);
    draw_text(cx, 85, "PISO " + string(torre_piso) + " / " + string(torre_pisos_total));

    // Info del enemigo
    var _pd = torre_piso_data;
    var _y = 140;
    draw_set_color(c_white);
    draw_text(cx, _y, "Próximo enemigo:");
    _y += 25;

    draw_set_color(_pd.es_jefe ? c_red : (_pd.es_elite ? c_orange : c_ltgray));
    var _rango_txt = _pd.es_jefe ? "[JEFE] " : (_pd.es_elite ? "[ELITE] " : "");
    draw_text(cx, _y, _rango_txt + _pd.nombre_enemigo);
    _y += 25;

    if (_pd.hp_mult > 1) {
        draw_set_color(c_orange);
        draw_text(cx, _y, "HP enemigo: +" + string(round((_pd.hp_mult - 1) * 100)) + "%");
        _y += 20;
    }

    // HP del jugador (si ya peleó al menos un piso)
    if (torre_pj_vida_max > 0) {
        _y += 10;
        draw_set_color(c_white);
        draw_text(cx, _y, "Tu HP: " + string(torre_pj_vida_actual) + " / " + string(torre_pj_vida_max));
        _y += 20;

        // Barra de HP visual
        var _bar_w = 300;
        var _bar_h = 14;
        var _bar_x = cx - _bar_w / 2;
        var _bar_y = _y;
        var _hp_ratio = clamp(torre_pj_vida_actual / torre_pj_vida_max, 0, 1);

        draw_set_color(make_color_rgb(40, 10, 10));
        draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, false);

        draw_set_color((_hp_ratio > 0.5) ? c_lime : ((_hp_ratio > 0.25) ? c_yellow : c_red));
        draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w * _hp_ratio, _bar_y + _bar_h, false);

        draw_set_color(c_white);
        draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, true);

        _y += _bar_h + 15;
    }

    // Racha
    if (torre_racha_hp_alta > 0) {
        draw_set_color(c_aqua);
        draw_text(cx, _y, "Racha HP alta: " + string(torre_racha_hp_alta) + "/3");
        if (torre_bonus_racha) {
            draw_set_color(c_yellow);
            draw_text(cx, _y + 18, "¡Bonus de racha activo! (+15% oro)");
        }
        _y += 40;
    }

    draw_set_color(c_dkgray);
    draw_text(cx, h_gui - 55, "ENTER: ¡Combatir!");
    draw_text(cx, h_gui - 30, "ESC: Abandonar torre");
}

// ═══════════════════════════════════════════
//  FASE: EQUIPAR OBJETOS/RUNA PRE-COMBATE
// ═══════════════════════════════════════════
else if (torre_fase == "equipar") {

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_yellow);
    draw_set_font(fnt_1);
    draw_text(cx, 30, "── PISO " + string(torre_piso) + " / " + string(torre_pisos_total) + " — EQUIPAR ──");

    if (torre_equip_fase == "objetos") {
        draw_set_color(c_white);
        draw_text(cx, 65, "Selecciona hasta 3 objetos consumibles");
        draw_set_color(c_gray);
        draw_text(cx, 88, "▲▼ Navegar  |  TAB: Seleccionar/Quitar  |  ENTER: Confirmar  |  ESC: Omitir");

        var _y = 125;
        var _n = array_length(torre_equip_obj_disponibles);
        var _cj = instance_find(obj_control_juego, 0);

        for (var i = 0; i < _n; i++) {
            var _nom = torre_equip_obj_disponibles[i];
            var _cant_inv = scr_inventario_get_objeto(_cj, _nom);
            // Contar cuántas veces lo seleccionamos
            var _sel = 0;
            for (var j = 0; j < array_length(torre_equip_objetos); j++) {
                if (torre_equip_objetos[j] == _nom) _sel++;
            }

            if (i == torre_equip_indice) {
                draw_set_color(c_yellow);
                draw_text(cx - 200, _y, "►");
            }

            if (_sel > 0)
                draw_set_color(c_lime);
            else if (i == torre_equip_indice)
                draw_set_color(c_white);
            else
                draw_set_color(c_ltgray);

            draw_text(cx, _y, _nom + "  (" + string(_sel) + "/" + string(_cant_inv) + ")");
            _y += 28;
        }

        // Mostrar selección actual
        _y += 10;
        draw_set_color(c_aqua);
        draw_text(cx, _y, "Equipados: " + string(array_length(torre_equip_objetos)) + " / 3");
        _y += 24;
        for (var i = 0; i < array_length(torre_equip_objetos); i++) {
            draw_set_color(c_white);
            draw_text(cx, _y, string(i + 1) + ". " + torre_equip_objetos[i]);
            _y += 22;
        }
    }

    else if (torre_equip_fase == "runa") {
        draw_set_color(c_white);
        draw_text(cx, 65, "Selecciona una runa (efecto pasivo en combate)");
        draw_set_color(c_gray);
        draw_text(cx, 88, "▲▼ Navegar  |  ENTER: Confirmar  |  ESC: Sin runa");

        var _y = 130;
        var _n_runas = array_length(torre_equip_runas_disponibles);

        for (var i = 0; i < _n_runas; i++) {
            if (i == torre_equip_runa_indice)
                draw_set_color(c_yellow);
            else
                draw_set_color(c_ltgray);

            var _pref = (i == torre_equip_runa_indice) ? "► " : "  ";
            draw_text(cx, _y, _pref + torre_equip_runas_disponibles[i]);
            _y += 28;
        }

        // "Sin runa" option
        if (torre_equip_runa_indice == _n_runas)
            draw_set_color(c_yellow);
        else
            draw_set_color(c_dkgray);

        var _pref2 = (torre_equip_runa_indice == _n_runas) ? "► " : "  ";
        draw_text(cx, _y, _pref2 + "[ Sin runa ]");
    }
}

// ═══════════════════════════════════════════
//  FASE: POST-COMBATE
// ═══════════════════════════════════════════
else if (torre_fase == "post_combate") {

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_lime);
    draw_text(cx, 50, "¡PISO " + string(torre_piso) + " COMPLETADO!");

    var _y = 100;
    draw_set_color(c_white);
    draw_text(cx, _y, "HP restante: " + string(torre_pj_vida_actual) + " / " + string(torre_pj_vida_max));
    _y += 30;

    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text(cx, _y, "Oro acumulado: " + string(torre_oro_ganado) + " G");
    _y += 30;

    if (torre_racha_hp_alta > 0) {
        draw_set_color(c_aqua);
        draw_text(cx, _y, "Racha HP alta: " + string(torre_racha_hp_alta) + "/3");
        _y += 25;
    }

    // Próximo paso
    var _hay_tienda = scr_torre_es_piso_tienda(torre_dificultad, torre_piso);
    var _siguiente_txt = _hay_tienda ? "Ir a la Tienda" : "Siguiente Piso";

    _y += 30;
    var _opciones = [_siguiente_txt, "Abandonar Torre"];
    for (var i = 0; i < 2; i++) {
        if (i == torre_post_opcion) {
            draw_set_color(c_yellow);
            draw_text(cx, _y + i * 35, "> " + _opciones[i] + " <");
        } else {
            draw_set_color(c_gray);
            draw_text(cx, _y + i * 35, _opciones[i]);
        }
    }

    draw_set_halign(fa_center);
    draw_set_color(c_dkgray);
    draw_text(cx, h_gui - 30, "ENTER: Confirmar");
}

// ═══════════════════════════════════════════
//  FASE: TIENDA ENTRE PISOS
// ═══════════════════════════════════════════
else if (torre_fase == "tienda") {

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_yellow);
    draw_text(cx, 40, "TIENDA — Piso " + string(torre_piso));

    draw_set_color(c_gray);
    draw_text(cx, 65, "Prepárate para los próximos pisos");

    var _items = torre_tienda_items;
    var _n = array_length(_items);

    for (var i = 0; i < _n; i++) {
        var _it = _items[i];
        var _sel = (i == torre_tienda_indice);
        var _iy = 110 + i * 28;

        draw_set_halign(fa_left);
        draw_set_color(_sel ? c_yellow : c_white);
        draw_text(cx - 200, _iy, (_sel ? "> " : "  ") + _it.nombre);

        draw_set_halign(fa_right);
        draw_set_color(_sel ? make_color_rgb(255, 215, 0) : c_ltgray);
        draw_text(cx + 200, _iy, string(_it.precio) + " G");
    }

    // Opción "Continuar"
    var _cont_y = 110 + _n * 28 + 15;
    var _sel_cont = (torre_tienda_indice == _n);
    draw_set_halign(fa_center);
    draw_set_color(_sel_cont ? c_lime : c_gray);
    draw_text(cx, _cont_y, (_sel_cont ? "> " : "") + "Continuar al siguiente piso" + (_sel_cont ? " <" : ""));

    // Mensaje de compra
    if (torre_tienda_mensaje != "") {
        draw_set_color(c_aqua);
        draw_text(cx, _cont_y + 40, torre_tienda_mensaje);
    }

    // Oro
    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text(cx, h_gui - 55, "Oro: " + string(control_juego.oro) + " G");
    draw_set_color(c_dkgray);
    draw_text(cx, h_gui - 30, "ENTER: Comprar / Continuar  |  ESC: Continuar");
}

// ═══════════════════════════════════════════
//  FASE: VICTORIA
// ═══════════════════════════════════════════
else if (torre_fase == "victoria") {

    draw_set_color(c_black);
    draw_set_alpha(0.5);
    draw_rectangle(0, 0, w_gui, h_gui, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_yellow);
    draw_text(cx, h_gui * 0.3, "¡TORRE COMPLETADA!");

    draw_set_color(torre_ala.color);
    draw_text(cx, h_gui * 0.3 + 40, torre_ala.nombre + " — " + torre_dificultad.nombre);

    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text(cx, h_gui * 0.3 + 80, "Oro total ganado: " + string(torre_oro_ganado) + " G");

    draw_set_color(c_white);
    draw_text(cx, h_gui * 0.3 + 120, string(torre_pisos_total) + " pisos completados");

    draw_set_color(c_gray);
    draw_text(cx, h_gui * 0.7, "Pulsa ENTER para volver al menú");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// ═══════════════════════════════════════════
//  FASE: DERROTA
// ═══════════════════════════════════════════
else if (torre_fase == "derrota") {

    draw_set_color(c_black);
    draw_set_alpha(0.5);
    draw_rectangle(0, 0, w_gui, h_gui, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_red);
    draw_text(cx, h_gui * 0.3, "DERROTA");

    draw_set_color(c_white);
    draw_text(cx, h_gui * 0.3 + 35, "Caíste en el piso " + string(torre_piso) + " de " + string(torre_pisos_total));

    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text(cx, h_gui * 0.3 + 70, "Oro conservado: " + string(torre_oro_ganado) + " G");

    draw_set_color(c_gray);
    draw_text(cx, h_gui * 0.7, "Pulsa ENTER para volver al menú");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// Reset draw state
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
