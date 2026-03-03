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
//  FASE: MAPA DE RAMIFICACIONES
// ═══════════════════════════════════════════
else if (camino_fase == "mapa") {

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(make_color_rgb(220, 170, 50));
    draw_text(cx, 45, "── MAPA DEL CAPÍTULO ──");

    var _total_tiers = array_length(camino_mapa);
    if (_total_tiers > 0) {

        // Sanitizar conexiones: filtrar índices inválidos para el mapa actual
        var _next_t = camino_tier_actual + 1;
        if (_next_t >= 0 && _next_t < _total_tiers) {
            var _max_nodos_next = array_length(camino_mapa[_next_t]);
            var _conexiones_validas = [];
            for (var _si = 0; _si < array_length(camino_mapa_conexiones); _si++) {
                if (camino_mapa_conexiones[_si] < _max_nodos_next) {
                    array_push(_conexiones_validas, camino_mapa_conexiones[_si]);
                }
            }
            camino_mapa_conexiones = _conexiones_validas;
            if (camino_mapa_sel >= array_length(camino_mapa_conexiones)) camino_mapa_sel = 0;
        }

        // ── Layout del mapa ──
        var _map_x1 = 80;
        var _map_x2 = w_gui - 300;
        var _map_y1 = 100;
        var _map_y2 = h_gui - 80;
        var _map_w_span = _map_x2 - _map_x1;
        var _map_h_span = _map_y2 - _map_y1;
        var _node_r = 16;

        // Calcular posiciones de cada nodo
        for (var t = 0; t < _total_tiers; t++) {
            var _tier = camino_mapa[t];
            var _tc = array_length(_tier);
            var _tx = _map_x1 + (_map_w_span / max(_total_tiers - 1, 1)) * t;

            for (var n = 0; n < _tc; n++) {
                var _nodo = _tier[n];
                _nodo.__draw_x = _tx;
                _nodo.__draw_y = _map_y1 + (_map_h_span / (_tc + 1)) * (n + 1);
            }
        }

        // ── Determinar visibilidad (niebla de guerra) ──
        // Solo mostrar: nodos visitados + nodo actual + nodos del siguiente tier
        for (var t = 0; t < _total_tiers; t++) {
            for (var n = 0; n < array_length(camino_mapa[t]); n++) {
                camino_mapa[t][n].__visible = false;
            }
        }
        // Nodos visitados (ruta tomada)
        for (var ri = 0; ri < array_length(camino_ruta_visitada); ri++) {
            var _vt = camino_ruta_visitada[ri][0];
            var _vn = camino_ruta_visitada[ri][1];
            if (_vt < _total_tiers && _vn < array_length(camino_mapa[_vt])) {
                camino_mapa[_vt][_vn].__visible = true;
            }
        }
        // Nodo actual
        if (camino_tier_actual >= 0 && camino_tier_actual < _total_tiers) {
            if (camino_nodo_actual < array_length(camino_mapa[camino_tier_actual])) {
                camino_mapa[camino_tier_actual][camino_nodo_actual].__visible = true;
            }
        }
        // Siguiente tier: todos visibles (las opciones)
        var _next_vis_tier = camino_tier_actual + 1;
        if (_next_vis_tier >= 0 && _next_vis_tier < _total_tiers) {
            for (var ni = 0; ni < array_length(camino_mapa[_next_vis_tier]); ni++) {
                camino_mapa[_next_vis_tier][ni].__visible = true;
            }
        }

        // ── Dibujar conexiones ──
        for (var t = 0; t < _total_tiers - 1; t++) {
            var _tier = camino_mapa[t];
            for (var n = 0; n < array_length(_tier); n++) {
                var _nodo = _tier[n];
                if (!_nodo.__visible) continue;  // Solo conexiones desde nodos visibles
                for (var ci = 0; ci < array_length(_nodo.conexiones); ci++) {
                    var _di = _nodo.conexiones[ci];
                    if (_di >= array_length(camino_mapa[t + 1])) continue;  // Índice inválido
                    var _dest = camino_mapa[t + 1][_di];
                    if (!_dest.__visible) continue;  // Solo hacia nodos visibles

                    if (_nodo.visitado && t < camino_tier_actual) {
                        draw_set_color(make_color_rgb(80, 80, 120));
                        draw_line_width(_nodo.__draw_x, _nodo.__draw_y, _dest.__draw_x, _dest.__draw_y, 2);
                    } else if (t == camino_tier_actual && n == camino_nodo_actual) {
                        draw_set_color(make_color_rgb(200, 200, 255));
                        draw_line_width(_nodo.__draw_x, _nodo.__draw_y, _dest.__draw_x, _dest.__draw_y, 3);
                    } else {
                        draw_set_color(make_color_rgb(40, 40, 50));
                        draw_line_width(_nodo.__draw_x, _nodo.__draw_y, _dest.__draw_x, _dest.__draw_y, 1);
                    }
                }
            }
        }

        // ── Dibujar nodos ──
        for (var t = 0; t < _total_tiers; t++) {
            var _tier = camino_mapa[t];
            for (var n = 0; n < array_length(_tier); n++) {
                var _nodo = _tier[n];
                if (!_nodo.__visible) continue;  // Solo nodos visibles
                var _nx = _nodo.__draw_x;
                var _ny = _nodo.__draw_y;

                // Color por tipo
                var _ncol = c_ltgray;
                switch (_nodo.tipo) {
                    case "combate":  _ncol = c_white; break;
                    case "elite":    _ncol = c_orange; break;
                    case "jefe":     _ncol = c_red; break;
                    case "tienda":   _ncol = make_color_rgb(100, 180, 220); break;
                    case "forja":    _ncol = make_color_rgb(200, 140, 60); break;
                    case "descanso": _ncol = c_lime; break;
                    case "cofre":    _ncol = make_color_rgb(255, 215, 0); break;
                    case "evento":   _ncol = make_color_rgb(180, 120, 255); break;
                }

                // Estado visual del nodo
                var _es_seleccionado = false;
                var _es_alcanzable = false;
                if (t == camino_tier_actual + 1) {
                    for (var ci = 0; ci < array_length(camino_mapa_conexiones); ci++) {
                        if (camino_mapa_conexiones[ci] == n) {
                            _es_alcanzable = true;
                            if (ci == camino_mapa_sel) _es_seleccionado = true;
                        }
                    }
                }

                if (_nodo.visitado) {
                    draw_set_color(make_color_rgb(60, 60, 70));
                    draw_circle(_nx, _ny, _node_r, false);
                    draw_set_color(_ncol);
                    draw_circle(_nx, _ny, _node_r, true);
                } else if (_es_seleccionado) {
                    draw_set_color(_ncol);
                    draw_set_alpha(0.3);
                    draw_circle(_nx, _ny, _node_r + 6, false);
                    draw_set_alpha(1);
                    draw_set_color(_ncol);
                    draw_circle(_nx, _ny, _node_r, false);
                } else if (_es_alcanzable) {
                    draw_set_color(_ncol);
                    draw_set_alpha(0.6);
                    draw_circle(_nx, _ny, _node_r, false);
                    draw_set_alpha(1);
                } else {
                    draw_set_color(make_color_rgb(35, 35, 45));
                    draw_circle(_nx, _ny, _node_r, false);
                    draw_set_color(make_color_rgb(60, 60, 70));
                    draw_circle(_nx, _ny, _node_r, true);
                }

                // Letra indicadora del tipo
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_set_color(_nodo.visitado ? c_dkgray : c_black);
                var _icon = "?";
                switch (_nodo.tipo) {
                    case "combate":  _icon = "!"; break;
                    case "elite":    _icon = "*"; break;
                    case "jefe":     _icon = "X"; break;
                    case "tienda":   _icon = "$"; break;
                    case "forja":    _icon = "F"; break;
                    case "descanso": _icon = "+"; break;
                    case "cofre":    _icon = "C"; break;
                    case "evento":   _icon = "E"; break;
                }
                draw_text(_nx, _ny, _icon);
            }
        }

        // ── Icono del jugador ──
        var _pj_x, _pj_y;
        if (camino_tier_actual < 0) {
            _pj_x = _map_x1 - 40;
            _pj_y = (_map_y1 + _map_y2) / 2;
        } else {
            var _nodo_pj = camino_mapa[camino_tier_actual][camino_nodo_actual];
            _pj_x = _nodo_pj.__draw_x;
            _pj_y = _nodo_pj.__draw_y - _node_r - 22;
        }

        var _spr = scr_sprite_personaje(camino_perfil_nombre, false);
        if (sprite_exists(_spr)) {
            var _sw = sprite_get_width(_spr);
            var _sh = sprite_get_height(_spr);
            var _esc = 28 / max(_sw, _sh);
            draw_sprite_ext(_spr, 0, _pj_x, _pj_y, _esc, _esc, 0, c_white, 1);
        } else {
            draw_set_color(c_yellow);
            draw_circle(_pj_x, _pj_y, 8, false);
        }

        // ── Panel de info del nodo seleccionado ──
        var _panel_x = w_gui - 280;
        var _panel_y = 100;
        var _panel_w = 260;
        var _panel_h = 300;

        draw_set_color(make_color_rgb(20, 18, 28));
        draw_set_alpha(0.9);
        draw_rectangle(_panel_x, _panel_y, _panel_x + _panel_w, _panel_y + _panel_h, false);
        draw_set_alpha(1);
        draw_set_color(make_color_rgb(80, 75, 100));
        draw_rectangle(_panel_x, _panel_y, _panel_x + _panel_w, _panel_y + _panel_h, true);

        if (array_length(camino_mapa_conexiones) > 0 && camino_mapa_sel < array_length(camino_mapa_conexiones)) {
            var _sel_idx = camino_mapa_conexiones[camino_mapa_sel];
            var _sel_tier = camino_tier_actual + 1;
            if (_sel_tier < _total_tiers && _sel_idx < array_length(camino_mapa[_sel_tier])) {
                var _sel_nodo = camino_mapa[_sel_tier][_sel_idx];

                draw_set_halign(fa_center);
                draw_set_valign(fa_top);

                var _tipo_col = c_ltgray;
                var _tipo_txt = _sel_nodo.tipo;
                switch (_sel_nodo.tipo) {
                    case "combate":  _tipo_col = c_white;  _tipo_txt = "COMBATE"; break;
                    case "elite":    _tipo_col = c_orange;  _tipo_txt = "ELITE"; break;
                    case "jefe":     _tipo_col = c_red;     _tipo_txt = "JEFE"; break;
                    case "tienda":   _tipo_col = make_color_rgb(100, 180, 220); _tipo_txt = "TIENDA"; break;
                    case "forja":    _tipo_col = make_color_rgb(200, 140, 60);  _tipo_txt = "FORJA"; break;
                    case "descanso": _tipo_col = c_lime;    _tipo_txt = "DESCANSO"; break;
                    case "cofre":    _tipo_col = make_color_rgb(255, 215, 0);   _tipo_txt = "COFRE"; break;
                    case "evento":   _tipo_col = make_color_rgb(180, 120, 255); _tipo_txt = "EVENTO"; break;
                }

                draw_set_color(_tipo_col);
                draw_text(_panel_x + _panel_w / 2, _panel_y + 15, "[ " + _tipo_txt + " ]");

                draw_set_color(c_white);
                draw_text_ext(_panel_x + _panel_w / 2, _panel_y + 45, _sel_nodo.nombre, 20, _panel_w - 30);

                draw_set_color(c_ltgray);
                draw_text_ext(_panel_x + _panel_w / 2, _panel_y + 90, _sel_nodo.descripcion, 18, _panel_w - 30);

                var _iy = _panel_y + 170;
                if (_sel_nodo.tipo == "combate" || _sel_nodo.tipo == "elite" || _sel_nodo.tipo == "jefe") {
                    if (_sel_nodo.hp_mult > 1) {
                        draw_set_color(c_orange);
                        draw_text(_panel_x + _panel_w / 2, _iy, "HP: +" + string(round((_sel_nodo.hp_mult - 1) * 100)) + "%");
                        _iy += 22;
                    }
                    if (_sel_nodo.oro_mult > 1) {
                        draw_set_color(make_color_rgb(255, 215, 0));
                        draw_text(_panel_x + _panel_w / 2, _iy, "Oro: x" + string(_sel_nodo.oro_mult));
                    }
                } else if (_sel_nodo.tipo == "cofre") {
                    draw_set_color(make_color_rgb(255, 215, 0));
                    draw_text(_panel_x + _panel_w / 2, _iy, "+" + string(_sel_nodo.recompensa_oro) + " oro");
                } else if (_sel_nodo.tipo == "evento") {
                    var _rar = variable_struct_exists(_sel_nodo, "recompensa_rareza") ? _sel_nodo.recompensa_rareza : 1;
                    draw_set_color(make_color_rgb(180, 120, 255));
                    draw_text(_panel_x + _panel_w / 2, _iy, "Arma de Rareza " + string(_rar));
                }
            }
        } else {
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(c_gray);
            draw_text(_panel_x + _panel_w / 2, _panel_y + _panel_h / 2, "Elige un camino");
        }

        // Leyenda de tipos
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        var _ly = _panel_y + _panel_h + 15;
        var _leyenda = [["!", "Combate", c_white], ["*", "Elite", c_orange], ["$", "Tienda", make_color_rgb(100, 180, 220)],
                        ["F", "Forja", make_color_rgb(200, 140, 60)], ["+", "Descanso", c_lime], ["C", "Cofre", make_color_rgb(255, 215, 0)],
                        ["E", "Evento", make_color_rgb(180, 120, 255)]];
        for (var li = 0; li < array_length(_leyenda); li++) {
            draw_set_color(_leyenda[li][2]);
            draw_text(_panel_x + (li % 3) * 90, _ly + floor(li / 3) * 20, _leyenda[li][0] + " " + _leyenda[li][1]);
        }
    }

    // Progreso global
    draw_set_halign(fa_left);
    draw_set_valign(fa_bottom);
    draw_set_color(c_aqua);
    draw_text(20, h_gui - 40, "Victorias: " + string(camino_combates_ganados));
    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text(20, h_gui - 20, "Oro: " + string(camino_oro_ganado) + " G");

    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_dkgray);
    draw_text(cx, h_gui - 5, "◄► Elegir camino  |  ENTER: Avanzar  |  ESC: Abandonar");
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

    // Tier actual
    draw_set_color(c_yellow);
    draw_text(cx, 70, "Tier " + string(camino_tier_actual + 1) + " / " + string(array_length(camino_mapa)));

    // Info del enemigo
    var _enc = camino_encuentro;

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

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_dkgray);
    draw_text(cx, h_gui - 30, "ENTER: ¡Combatir!  |  ESC: Volver al mapa");
}


// ═══════════════════════════════════════════
//  FASE: SELECCIÓN DE ARMA PARA EL COMBATE
// ═══════════════════════════════════════════
else if (camino_fase == "seleccion_arma_combate") {

    draw_set_color(c_black);
    draw_set_alpha(0.5);
    draw_rectangle(0, 0, w_gui, h_gui, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(make_color_rgb(220, 170, 50));
    draw_text(cx, 40, "── ELEGIR ARMA ──");

    draw_set_color(c_white);
    draw_text(cx, 70, "Selecciona el arma para este combate");
    draw_set_color(c_gray);
    draw_text(cx, 93, "▲▼ Navegar  |  ENTER: Confirmar  |  ESC: Volver");

    var _y_arm = 140;
    var _n_armas = array_length(camino_armas_run);

    for (var i = 0; i < _n_armas; i++) {
        var _a_nombre = camino_armas_run[i];
        var _a_datos = scr_datos_armas(_a_nombre);
        var _es_actual = (_a_nombre == camino_arma);

        // Cursor
        if (i == camino_arma_sel_indice) {
            draw_set_color(c_yellow);
            draw_text(cx - 280, _y_arm, "►");
        }

        // Color
        if (i == camino_arma_sel_indice)
            draw_set_color(c_yellow);
        else if (_es_actual)
            draw_set_color(c_aqua);
        else
            draw_set_color(c_ltgray);

        var _etiqueta = _a_nombre;
        if (_es_actual) _etiqueta += "  [ACTUAL]";

        draw_set_halign(fa_left);
        draw_text(cx - 260, _y_arm, _etiqueta);

        // Stats del arma
        draw_set_halign(fa_right);
        draw_set_color(c_gray);
        var _stats_txt = "R" + string(_a_datos.rareza) + " | " + _a_datos.afinidad;
        if (_a_datos.ataque_bonus != 0) _stats_txt += " | ATK+" + string(_a_datos.ataque_bonus);
        draw_text(cx + 280, _y_arm, _stats_txt);

        _y_arm += 32;
    }

    // Detalles del arma seleccionada
    if (camino_arma_sel_indice < _n_armas) {
        var _sel_a = camino_armas_run[camino_arma_sel_indice];
        var _sel_d = scr_datos_armas(_sel_a);
        var _det_y = _y_arm + 20;

        draw_set_halign(fa_center);
        draw_set_color(make_color_rgb(180, 150, 80));
        draw_text(cx, _det_y, "── Detalles ──");
        _det_y += 25;

        draw_set_color(c_white);
        draw_text(cx, _det_y, _sel_a);
        _det_y += 22;

        draw_set_color(c_ltgray);
        draw_text(cx, _det_y, "Afinidad: " + _sel_d.afinidad + "  |  Rareza: " + string(_sel_d.rareza));
        _det_y += 22;

        draw_set_color(c_orange);
        draw_text(cx, _det_y, "ATK bonus: +" + string(_sel_d.ataque_bonus) + "  |  Poder Elemental: +" + string(_sel_d.poder_elemental_bonus));
        _det_y += 28;

        // Habilidades del arma
        if (variable_struct_exists(_sel_d, "habilidades_arma") && is_array(_sel_d.habilidades_arma)) {
            draw_set_color(c_aqua);
            draw_text(cx, _det_y, "Habilidades:");
            _det_y += 22;
            for (var hi = 0; hi < array_length(_sel_d.habilidades_arma); hi++) {
                draw_set_color(c_white);
                draw_text(cx, _det_y, _sel_d.habilidades_arma[hi]);
                _det_y += 20;
            }
        }
    }
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

        for (var i = 0; i < _n; i++) {
            var _nom = camino_equip_obj_disponibles[i];
            var _cant_inv = ds_map_exists(camino_objetos_run, _nom) ? camino_objetos_run[? _nom] : 0;
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
    draw_text(cx, _y, "Combate completado");
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
    var _opciones_txt = ["Volver al mapa", "Abandonar Camino"];
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
