/// DRAW GUI — obj_control_camino

// Solo dibujar en rm_camino
if (room != rm_camino) exit;

// Fondo — reutiliza spr_bg_torre (o se puede crear spr_bg_camino luego)
draw_sprite_stretched(spr_bg_torre, 0, 0, 0, display_get_gui_width(), display_get_gui_height());

draw_set_font(fnt_1);
var w_gui = display_get_gui_width();
var h_gui = display_get_gui_height();
var cx = w_gui * 0.5;
var control_juego = instance_find(obj_control_juego, 0);

// ═══════════════════════════════════════════
//  HEADER COMÚN
// ═══════════════════════════════════════════
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_color(make_color_rgb(255, 215, 0));
if (instance_exists(control_juego)) {
    draw_text(w_gui - 20, 10, "Oro: " + string(control_juego.oro) + " G");
}

// ── Info de run activa ──
if (camino_activo && camino_capitulo != undefined) {
    draw_set_halign(fa_left);
    draw_set_color(camino_capitulo.color);
    draw_text(20, 10, "Cap. " + string(camino_capitulo.numero) + ": " + camino_capitulo.nombre);
    draw_set_color(c_ltgray);
    draw_text(20, 28, camino_perfil_nombre + " — " + camino_arma);
}


// ═══════════════════════════════════════════
//  FASE: SELECCIÓN DE PERSONAJE
// ═══════════════════════════════════════════
if (camino_fase == "seleccion_personaje") {

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(make_color_rgb(220, 170, 50));
    draw_text(cx, 40, "CAMINO DEL HÉROE");
    draw_set_color(c_ltgray);
    draw_text(cx, 65, "El modo principal de Arcadium. Atraviesa los dominios y derrota al Devorador.");
    draw_set_color(c_gray);
    draw_text(cx, 88, "Elige tu Conductor");

    if (instance_exists(control_juego)) {
        var _nombres = scr_ds_map_keys_array(control_juego.perfiles_personaje);

        for (var i = 0; i < array_length(_nombres); i++) {
            var _nom = _nombres[i];
            var _perfil = control_juego.perfiles_personaje[? _nom];
            var _sel = (i == sel_pj_indice);

            var _by = 130 + i * 55;
            var _bx = cx - 250;
            var _bw = 500;
            var _bh = 45;

            // Fondo del panel
            draw_set_color(_sel ? make_color_rgb(40, 35, 55) : make_color_rgb(20, 18, 28));
            draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);

            // Marco
            draw_set_color(_sel ? make_color_rgb(220, 170, 50) : make_color_rgb(50, 50, 60));
            draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, true);

            // Nombre
            draw_set_halign(fa_left);
            draw_set_color(_sel ? c_yellow : c_white);
            draw_text(_bx + 15, _by + 5, _nom);

            // Clase / Afinidad / Personalidad
            draw_set_color(_sel ? c_ltgray : c_gray);
            draw_text(_bx + 15, _by + 24, _perfil.clase + " | " + _perfil.afinidad + " | " + _perfil.personalidad);

            // Arma equipada
            draw_set_halign(fa_right);
            draw_set_color(_sel ? c_aqua : c_dkgray);
            draw_text(_bx + _bw - 15, _by + 14, "Arma: " + _perfil.arma_equipada);
        }
    }

    draw_set_halign(fa_center);
    draw_set_color(c_dkgray);
    draw_text(cx, h_gui - 30, "ENTER: Seleccionar  |  ESC: Volver al menú");
}


// ═══════════════════════════════════════════
//  FASE: SELECCIÓN DE ARMA
// ═══════════════════════════════════════════
else if (camino_fase == "seleccion_arma") {

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(make_color_rgb(220, 170, 50));
    draw_text(cx, 40, "CAMINO DEL HÉROE — Elegir Arma");
    draw_set_color(c_white);
    draw_text(cx, 70, "Conductor: " + camino_perfil_nombre);

    for (var i = 0; i < array_length(camino_armas_disponibles); i++) {
        var _nom_arma = camino_armas_disponibles[i];
        var _sel = (i == sel_arma_indice);
        var _by = 120 + i * 45;
        var _bx = cx - 200;
        var _bw = 400;
        var _bh = 36;

        draw_set_color(_sel ? make_color_rgb(40, 35, 55) : make_color_rgb(20, 18, 28));
        draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);

        draw_set_color(_sel ? make_color_rgb(220, 170, 50) : make_color_rgb(50, 50, 60));
        draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, true);

        draw_set_halign(fa_center);
        draw_set_color(_sel ? c_yellow : c_white);
        draw_text(cx, _by + 10, _nom_arma);
    }

    draw_set_halign(fa_center);
    draw_set_color(c_dkgray);
    draw_text(cx, h_gui - 30, "ENTER: Seleccionar  |  ESC: Volver");
}


// ═══════════════════════════════════════════
//  FASE: NARRATIVA (línea por línea)
// ═══════════════════════════════════════════
else if (camino_fase == "narrativa_linea") {

    // Fondo oscuro cinematográfico
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, w_gui, h_gui, false);
    draw_set_alpha(1);

    // Barra decorativa superior
    var _cap_col = (camino_capitulo != undefined) ? camino_capitulo.color : make_color_rgb(220, 170, 50);
    draw_set_color(_cap_col);
    draw_set_alpha(0.6);
    draw_rectangle(0, h_gui * 0.28, w_gui, h_gui * 0.30, false);
    draw_rectangle(0, h_gui * 0.70, w_gui, h_gui * 0.72, false);
    draw_set_alpha(1);

    // Texto de la línea actual
    if (camino_narrativa_idx < array_length(camino_narrativa_lineas)) {
        var _linea = camino_narrativa_lineas[camino_narrativa_idx];

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text_ext(cx, h_gui * 0.5, _linea, 28, w_gui * 0.75);
    }

    // Indicador de progreso
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_gray);
    var _prog = string(camino_narrativa_idx + 1) + " / " + string(array_length(camino_narrativa_lineas));
    draw_text(cx, h_gui - 50, _prog);

    draw_set_color(c_dkgray);
    draw_text(cx, h_gui - 25, "ENTER: Continuar  |  ESC: Saltar");
}


// ═══════════════════════════════════════════
//  FASE: PRE-COMBATE
// ═══════════════════════════════════════════
else if (camino_fase == "pre_combate") {

    draw_set_color(c_black);
    draw_set_alpha(0.3);
    draw_rectangle(0, 0, w_gui, h_gui, false);
    draw_set_alpha(1);

    // Título del capítulo
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    var _cap_col = (camino_capitulo != undefined) ? camino_capitulo.color : c_white;
    draw_set_color(_cap_col);
    draw_text(cx, 40, "Capítulo " + string(camino_capitulo.numero) + ": " + camino_capitulo.nombre);

    // Progreso del capítulo
    draw_set_color(c_yellow);
    var _total_enc = array_length(camino_encuentros);
    draw_text(cx, 70, "Encuentro " + string(camino_encuentro_idx + 1) + " / " + string(_total_enc));

    // Info del enemigo
    var _enc = undefined;
    if (camino_encuentro_idx < array_length(camino_encuentros)) {
        _enc = camino_encuentros[camino_encuentro_idx];
    }

    var _y = 120;

    if (_enc != undefined) {
        draw_set_color(c_white);
        draw_text(cx, _y, "Próximo enemigo:");
        _y += 30;

        // Color según tipo
        var _tipo_col = c_ltgray;
        var _rango_txt = "";
        if (_enc.es_jefe)  { _tipo_col = c_red;    _rango_txt = "[JEFE] ";  }
        if (_enc.es_elite) { _tipo_col = c_orange;  _rango_txt = "[ELITE] "; }

        draw_set_color(_tipo_col);
        draw_text(cx, _y, _rango_txt + _enc.nombre_enemigo);
        _y += 30;

        if (_enc.hp_mult > 1) {
            draw_set_color(c_orange);
            draw_text(cx, _y, "HP enemigo: +" + string(round((_enc.hp_mult - 1) * 100)) + "%");
            _y += 25;
        }
    }

    // Progreso global
    _y += 20;
    draw_set_color(c_aqua);
    draw_text(cx, _y, "Victorias: " + string(camino_combates_ganados));
    _y += 22;
    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text(cx, _y, "Oro acumulado: " + string(camino_oro_ganado) + " G");

    // Mapa de progreso visual (capítulos)
    _y = h_gui - 130;
    draw_set_color(c_gray);
    draw_text(cx, _y - 20, "── Progreso del Camino ──");

    var _caps = scr_camino_get_capitulos();
    var _total_caps = array_length(_caps);
    var _map_w = 500;
    var _map_x = cx - _map_w / 2;
    var _node_r = 12;

    for (var i = 0; i < _total_caps; i++) {
        var _nx = _map_x + (_map_w / (_total_caps - 1)) * i;
        var _ny = _y + 10;

        // Línea conectora
        if (i < _total_caps - 1) {
            var _nx2 = _map_x + (_map_w / (_total_caps - 1)) * (i + 1);
            draw_set_color(i < camino_capitulo_idx ? _caps[i].color : make_color_rgb(50, 50, 50));
            draw_line_width(_nx, _ny, _nx2, _ny, 2);
        }

        // Nodo
        if (i < camino_capitulo_idx) {
            draw_set_color(_caps[i].color);  // Completado
        } else if (i == camino_capitulo_idx) {
            draw_set_color(c_yellow);        // Actual
        } else {
            draw_set_color(make_color_rgb(50, 50, 50));  // Futuro
        }
        draw_circle(_nx, _ny, _node_r, false);

        // Número del capítulo
        draw_set_color(c_black);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_nx, _ny, string(i + 1));

        // Nombre debajo
        draw_set_valign(fa_top);
        draw_set_color(i == camino_capitulo_idx ? c_white : c_dkgray);
        draw_text(_nx, _ny + _node_r + 5, _caps[i].nombre);
    }

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_dkgray);
    draw_text(cx, h_gui - 30, "ENTER: ¡Combatir!  |  ESC: Abandonar");
}


// ═══════════════════════════════════════════
//  FASE: EQUIPAR OBJETOS / RUNAS
// ═══════════════════════════════════════════
else if (camino_fase == "equipar") {

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(make_color_rgb(220, 170, 50));
    draw_text(cx, 30, "── PREPARAR COMBATE ──");

    if (camino_equip_fase == "objetos") {
        draw_set_color(c_white);
        draw_text(cx, 60, "Selecciona hasta 3 objetos consumibles");
        draw_set_color(c_gray);
        draw_text(cx, 83, "▲▼ Navegar  |  TAB: Seleccionar/Quitar  |  ENTER: Confirmar  |  ESC: Omitir");

        var _y = 120;
        var _n = array_length(camino_equip_obj_disponibles);
        var _cj = instance_find(obj_control_juego, 0);

        for (var i = 0; i < _n; i++) {
            var _nom = camino_equip_obj_disponibles[i];
            var _cant_inv = scr_inventario_get_objeto(_cj, _nom);
            var _sel_count = 0;
            for (var j = 0; j < array_length(camino_equip_objetos); j++) {
                if (camino_equip_objetos[j] == _nom) _sel_count++;
            }

            if (i == camino_equip_indice) {
                draw_set_color(c_yellow);
                draw_text(cx - 200, _y, "►");
            }

            if (_sel_count > 0)
                draw_set_color(c_lime);
            else if (i == camino_equip_indice)
                draw_set_color(c_white);
            else
                draw_set_color(c_ltgray);

            draw_text(cx, _y, _nom + "  (" + string(_sel_count) + "/" + string(_cant_inv) + ")");
            _y += 28;
        }

        _y += 10;
        draw_set_color(c_aqua);
        draw_text(cx, _y, "Equipados: " + string(array_length(camino_equip_objetos)) + " / 3");
        _y += 24;
        for (var i = 0; i < array_length(camino_equip_objetos); i++) {
            draw_set_color(c_white);
            draw_text(cx, _y, string(i + 1) + ". " + camino_equip_objetos[i]);
            _y += 22;
        }
    }

    else if (camino_equip_fase == "runa") {
        draw_set_color(c_white);
        draw_text(cx, 60, "Selecciona una runa (efecto pasivo en combate)");
        draw_set_color(c_gray);
        draw_text(cx, 83, "▲▼ Navegar  |  ENTER: Confirmar  |  ESC: Sin runa");

        var _y = 125;
        var _n_runas = array_length(camino_equip_runas_disponibles);

        for (var i = 0; i < _n_runas; i++) {
            if (i == camino_equip_runa_indice)
                draw_set_color(c_yellow);
            else
                draw_set_color(c_ltgray);

            var _pref = (i == camino_equip_runa_indice) ? "► " : "  ";
            draw_text(cx, _y, _pref + camino_equip_runas_disponibles[i]);
            _y += 28;
        }

        if (camino_equip_runa_indice == _n_runas)
            draw_set_color(c_yellow);
        else
            draw_set_color(c_dkgray);

        var _pref2 = (camino_equip_runa_indice == _n_runas) ? "► " : "  ";
        draw_text(cx, _y, _pref2 + "[ Sin runa ]");
    }
}


// ═══════════════════════════════════════════
//  FASE: POST-COMBATE (victoria de encuentro)
// ═══════════════════════════════════════════
else if (camino_fase == "post_combate") {

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_lime);
    draw_text(cx, 50, "¡VICTORIA!");

    var _y = 100;

    // Info del encuentro superado
    draw_set_color(c_white);
    draw_text(cx, _y, "Encuentro " + string(camino_encuentro_idx + 1) + " de " + string(array_length(camino_encuentros)) + " completado");
    _y += 30;

    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text(cx, _y, "Oro obtenido: +" + string(camino_ultimo_oro) + " G");
    _y += 25;

    draw_set_color(c_aqua);
    draw_text(cx, _y, "Victorias totales: " + string(camino_combates_ganados));
    _y += 25;

    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text(cx, _y, "Oro acumulado: " + string(camino_oro_ganado) + " G");
    _y += 50;

    // Opciones
    var _opciones_txt = ["Continuar", "Abandonar Camino"];
    for (var i = 0; i < 2; i++) {
        if (i == camino_post_opcion) {
            draw_set_color(c_yellow);
            draw_text(cx, _y + i * 35, "> " + _opciones_txt[i] + " <");
        } else {
            draw_set_color(c_gray);
            draw_text(cx, _y + i * 35, _opciones_txt[i]);
        }
    }

    draw_set_color(c_dkgray);
    draw_text(cx, h_gui - 30, "ENTER: Confirmar");
}


// ═══════════════════════════════════════════
//  FASE: VICTORIA DE CAPÍTULO
// ═══════════════════════════════════════════
else if (camino_fase == "victoria_capitulo") {

    draw_set_color(c_black);
    draw_set_alpha(0.5);
    draw_rectangle(0, 0, w_gui, h_gui, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    var _cap_col = (camino_capitulo != undefined) ? camino_capitulo.color : c_yellow;
    draw_set_color(_cap_col);
    draw_text(cx, h_gui * 0.25, "CAPÍTULO " + string(camino_capitulo.numero) + " COMPLETADO");

    draw_set_color(c_white);
    draw_text(cx, h_gui * 0.25 + 40, camino_capitulo.nombre);

    // Recompensa
    var _recomp = scr_camino_recompensa_capitulo(camino_capitulo);
    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text(cx, h_gui * 0.5 - 20, "Recompensa: +" + string(_recomp.oro) + " oro");

    draw_set_color(c_aqua);
    draw_text(cx, h_gui * 0.5 + 20, "Victorias: " + string(camino_combates_ganados) + " | Derrotas: " + string(camino_derrotas));

    draw_set_color(c_gray);
    draw_text(cx, h_gui * 0.7, "Pulsa ENTER para continuar");
}


// ═══════════════════════════════════════════
//  FASE: ENTRE CAPÍTULOS (centro de operaciones)
// ═══════════════════════════════════════════
else if (camino_fase == "entre_capitulos") {

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);

    draw_set_color(make_color_rgb(220, 170, 50));
    draw_text(cx, 40, "── ENTRE CAPÍTULOS ──");

    // Info del próximo capítulo
    var _next_idx = camino_capitulo_idx + 1;
    if (_next_idx < array_length(camino_capitulos)) {
        var _next = camino_capitulos[_next_idx];
        draw_set_color(c_white);
        draw_text(cx, 75, "Próximo: Capítulo " + string(_next.numero) + " — " + _next.nombre);
        draw_set_color(c_ltgray);
        draw_text(cx, 100, _next.subtitulo);

        // Afinidades del próximo capítulo
        var _afi = "";
        for (var i = 0; i < array_length(_next.afinidades); i++) {
            if (i > 0) _afi += " + ";
            _afi += _next.afinidades[i];
        }
        if (_afi != "") {
            draw_set_color(_next.color);
            draw_text(cx, 125, "Afinidades: " + _afi);
        }
    }

    // Estado actual
    var _y = 170;
    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text(cx, _y, "Oro: " + string(control_juego.oro) + " G");
    _y += 25;
    draw_set_color(c_aqua);
    draw_text(cx, _y, "Victorias: " + string(camino_combates_ganados) + " | Derrotas: " + string(camino_derrotas));
    _y += 45;

    // Opciones
    var _opciones_txt = ["Siguiente Capítulo", "Ir a la Forja", "Ir a la Tienda", "Abandonar Camino"];
    var _opciones_col = [c_lime, make_color_rgb(200, 140, 60), make_color_rgb(100, 180, 220), c_red];

    for (var i = 0; i < array_length(_opciones_txt); i++) {
        var _sel = (i == camino_entre_opcion);

        var _by = _y + i * 50;
        var _bx = cx - 180;
        var _bw = 360;
        var _bh = 38;

        // Fondo
        draw_set_color(_sel ? make_color_rgb(40, 35, 55) : make_color_rgb(20, 18, 28));
        draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);

        // Marco
        draw_set_color(_sel ? _opciones_col[i] : make_color_rgb(50, 50, 60));
        draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, true);

        // Texto
        draw_set_color(_sel ? _opciones_col[i] : c_gray);
        draw_set_halign(fa_center);
        draw_text(cx, _by + 10, _opciones_txt[i]);
    }

    draw_set_color(c_dkgray);
    draw_text(cx, h_gui - 30, "ENTER: Confirmar");
}


// ═══════════════════════════════════════════
//  FASE: VICTORIA FINAL
// ═══════════════════════════════════════════
else if (camino_fase == "victoria_final") {

    draw_set_color(c_black);
    draw_set_alpha(0.6);
    draw_rectangle(0, 0, w_gui, h_gui, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Título épico
    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text(cx, h_gui * 0.2, "¡EL DEVORADOR HA CAÍDO!");

    draw_set_color(c_white);
    draw_text(cx, h_gui * 0.2 + 45, "El Camino del Héroe ha sido completado.");

    draw_set_color(make_color_rgb(220, 170, 50));
    draw_text(cx, h_gui * 0.2 + 80, "Conductor: " + camino_perfil_nombre);

    // Estadísticas
    var _y = h_gui * 0.45;
    draw_set_color(c_aqua);
    draw_text(cx, _y, "── Resumen de la Aventura ──");
    _y += 30;

    draw_set_color(c_white);
    draw_text(cx, _y, "Capítulos completados: 5 / 5");
    _y += 22;
    draw_text(cx, _y, "Victorias: " + string(camino_combates_ganados));
    _y += 22;
    draw_text(cx, _y, "Derrotas: " + string(camino_derrotas));
    _y += 22;

    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text(cx, _y, "Oro total ganado: " + string(camino_oro_ganado) + " G");
    _y += 30;

    // Run perfecta?
    if (camino_derrotas == 0) {
        draw_set_color(make_color_rgb(255, 100, 255));
        draw_text(cx, _y, "¡Run Perfecta! Sin derrotas.");
        _y += 22;
        draw_set_color(c_yellow);
        draw_text(cx, _y, "Un desafío secreto te espera...");
    }

    draw_set_color(c_gray);
    draw_text(cx, h_gui * 0.85, "Pulsa ENTER para continuar");
}


// ═══════════════════════════════════════════
//  FASE: SECRETO PRE-COMBATE
// ═══════════════════════════════════════════
else if (camino_fase == "secreto_pre_combate") {

    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, w_gui, h_gui, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_color(make_color_rgb(180, 50, 255));
    draw_text(cx, h_gui * 0.3, "EL PRIMER CONDUCTOR");
    draw_set_color(c_white);
    draw_text(cx, h_gui * 0.3 + 35, "El desafío definitivo de Arcadium");

    draw_set_color(c_red);
    draw_text(cx, h_gui * 0.5, "⚠ El jefe más difícil del juego ⚠");

    draw_set_color(c_yellow);
    draw_text(cx, h_gui * 0.65, "ENTER: Aceptar el desafío");
    draw_set_color(c_gray);
    draw_text(cx, h_gui * 0.7, "ESC: Volver al menú con tu victoria");
}


// ═══════════════════════════════════════════
//  FASE: SECRETO VICTORIA
// ═══════════════════════════════════════════
else if (camino_fase == "secreto_victoria") {

    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, w_gui, h_gui, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text(cx, h_gui * 0.25, "VICTORIA TOTAL");

    draw_set_color(make_color_rgb(180, 50, 255));
    draw_text(cx, h_gui * 0.25 + 40, "El Primer Conductor ha caído");

    draw_set_color(c_white);
    draw_text(cx, h_gui * 0.45, "Has completado Arcadium al 100%.");
    draw_text(cx, h_gui * 0.45 + 25, "Un verdadero Conductor.");

    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text(cx, h_gui * 0.6, "Oro total: " + string(camino_oro_ganado) + " G");

    draw_set_color(c_gray);
    draw_text(cx, h_gui * 0.8, "Pulsa ENTER para volver al menú");
}


// ═══════════════════════════════════════════
//  FASE: DERROTA
// ═══════════════════════════════════════════
else if (camino_fase == "derrota") {

    draw_set_color(c_black);
    draw_set_alpha(0.5);
    draw_rectangle(0, 0, w_gui, h_gui, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_red);
    draw_text(cx, h_gui * 0.25, "DERROTA");

    draw_set_color(c_white);
    if (camino_capitulo != undefined) {
        draw_text(cx, h_gui * 0.25 + 35, "Capítulo " + string(camino_capitulo.numero) + ": " + camino_capitulo.nombre);
    }

    draw_set_color(c_ltgray);
    draw_text(cx, h_gui * 0.4, "No llegas al final esta vez, pero puedes reintentar.");

    var _y = h_gui * 0.55;
    var _opciones_txt = ["Reintentar este combate", "Abandonar el Camino"];
    for (var i = 0; i < 2; i++) {
        if (i == camino_post_opcion) {
            draw_set_color(c_yellow);
            draw_text(cx, _y + i * 35, "> " + _opciones_txt[i] + " <");
        } else {
            draw_set_color(c_gray);
            draw_text(cx, _y + i * 35, _opciones_txt[i]);
        }
    }

    draw_set_color(c_dkgray);
    draw_text(cx, h_gui * 0.85, "ENTER: Confirmar");
}


// Reset draw state
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
