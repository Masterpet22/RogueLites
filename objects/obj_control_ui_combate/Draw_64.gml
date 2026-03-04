/// DRAW GUI - obj_control_ui_combate

if (!instance_exists(control_combate)) {
    exit;
}

// Fondo de combate (sprite aleatorio según arena)
{
    var _bg_spr = spr_bg_combate_1;
    var _arena = 0;
    if (variable_struct_exists(control_combate, "combate_arena_idx")) {
        _arena = control_combate.combate_arena_idx;
    }
    switch (_arena) {
        case 1:  _bg_spr = spr_bg_combate_2; break;
        case 2:  _bg_spr = spr_bg_combate_3; break;
        case 3:  _bg_spr = spr_bg_combate_4; break;
        case 4:  _bg_spr = spr_bg_combate_5; break;
        default: _bg_spr = spr_bg_combate_1; break;
    }
    draw_sprite_stretched(_bg_spr, 0, 0, 0, display_get_gui_width(), display_get_gui_height());
}

draw_set_font(fnt_1);

var pj = control_combate.personaje_jugador;
var en = control_combate.personaje_enemigo;
var w_gui = display_get_gui_width();   // 1280
var h_gui = display_get_gui_height();  // 720

// ╔═══════════════════════════════════════════════════════════════╗
// ║  PANEL SUPERIOR — INFO JUGADOR (izquierda) + ENEMIGO (derecha)
// ╚═══════════════════════════════════════════════════════════════╝

// Fondo semitransparente superior
draw_set_color(c_black);
draw_set_alpha(0.55);
draw_rectangle(0, 0, w_gui, 100, false);
draw_set_alpha(1);

// ─────────────────────────────────
//  JUGADOR — Panel izquierdo
// ─────────────────────────────────
{
    var _pj_frame_x = 10;
    var _pj_frame_y = 8;
    var _portrait_size = 84;

    // Retrato del jugador (sprite spr_jugador_rostro con efectos de feedback)
    scr_feedback_dibujar_retrato(true, _pj_frame_x, _pj_frame_y, _portrait_size);

    // ── Info texto a la derecha del retrato ──
    var _info_x = _pj_frame_x + _portrait_size + 12;
    var _info_y = _pj_frame_y;

    // Línea 1: Nombre + Clase
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_text(_info_x, _info_y, pj.nombre + "  —  " + pj.clase);

    // Barra de vida (código — multicapa por afinidad)
    var _barra_x = _info_x;
    var _barra_y = _info_y + 22;
    var _barra_w = 280;
    var _barra_h = 16;

    // Dibujar barra multicapa (izq → der, no invertida)
    scr_barra_vida_draw(_barra_x, _barra_y, _barra_w, _barra_h, pj, false);

    // Línea 3: Afinidad (con icono) + Personalidad + Arma
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    var _afin_ico = scr_sprite_icono_afinidad(pj.afinidad);
    var _afin_y3 = _barra_y + _barra_h + 10;  // +10 para dejar espacio a muescas de capas
    if (_afin_ico != -1) {
        draw_sprite_stretched(_afin_ico, 0, _info_x, _afin_y3, 16, 16);
        draw_set_color(c_ltgray);
        draw_text(_info_x + 20, _afin_y3, pj.afinidad + "  |  " + pj.personalidad + "  |  " + pj.arma);
    } else {
        draw_set_color(c_ltgray);
        draw_text(_info_x, _afin_y3, pj.afinidad + "  |  " + pj.personalidad + "  |  " + pj.arma);
    }

    // ── ESTADOS ALTERADOS DEL JUGADOR (iconos debajo del retrato) ──
    if (is_array(pj.estados)) {
        var _st_x = _pj_frame_x;
        var _st_y = _pj_frame_y + _portrait_size + 4;
        var _st_size = 28;
        var _st_gap = 4;
        var _st_count = 0;

        for (var _si = 0; _si < array_length(pj.estados); _si++) {
            var _est = pj.estados[_si];
            if (!_est.activo) continue;

            // Color según tipo de estado
            var _st_col = c_white;
            if (_est.tipo == "dot") _st_col = c_red;
            else if (_est.tipo == "hot") _st_col = c_lime;
            else if (string_pos("buff", _est.tipo) > 0) _st_col = c_aqua;
            else if (string_pos("debuff", _est.tipo) > 0) _st_col = c_orange;

            var _sx = _st_x + _st_count * (_st_size + _st_gap);
            var _sy = _st_y;

            // Icono del estado (sprite o fallback)
            var _ico_spr = scr_sprite_icono_estado(_est.id);
            if (_ico_spr != -1) {
                draw_sprite_stretched(_ico_spr, 0, _sx, _sy, _st_size, _st_size);
            } else {
                draw_set_color(make_color_rgb(20, 20, 20));
                draw_rectangle(_sx, _sy, _sx + _st_size, _sy + _st_size, false);
                draw_set_halign(fa_center); draw_set_valign(fa_middle);
                draw_set_color(_st_col);
                draw_text(_sx + _st_size / 2, _sy + _st_size / 2 - 2, string_upper(string_copy(_est.id, 1, 3)));
            }

            // Marco del icono
            draw_set_color(_st_col);
            draw_rectangle(_sx, _sy, _sx + _st_size, _sy + _st_size, true);

            // Timer restante
            draw_set_halign(fa_center);
            draw_set_valign(fa_top);
            draw_set_color(c_ltgray);
            var _seg_rest = max(0, _est.tiempo_rest / GAME_FPS);
            draw_text(_sx + _st_size / 2, _sy + _st_size + 1, string_format(_seg_rest, 1, 0));

            _st_count++;
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
        }
    }
}

// ─────────────────────────────────
//  ENEMIGO — Panel derecho
// ─────────────────────────────────
{
    var _en_portrait_size = 84;
    var _en_frame_x = w_gui - 10 - _en_portrait_size;
    var _en_frame_y = 8;

    // Retrato del enemigo (sprite spr_enemigo_rostro con efectos de feedback)
    scr_feedback_dibujar_retrato(false, _en_frame_x, _en_frame_y, _en_portrait_size);

    // ── Info texto a la izquierda del retrato ──
    var _en_info_x = _en_frame_x - 12;
    var _en_info_y = _en_frame_y;
    var _en_barra_w = 280;

    // Nombre
    draw_set_halign(fa_right);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_text(_en_info_x, _en_info_y, en.nombre);

    // Barra de vida enemigo (código — multicapa por afinidad)
    var _en_barra_x = _en_info_x - _en_barra_w;
    var _en_barra_y = _en_info_y + 22;
    var _en_barra_h = 16;

    // Dibujar barra multicapa (der → izq, invertida)
    scr_barra_vida_draw(_en_barra_x, _en_barra_y, _en_barra_w, _en_barra_h, en, true);

    // Afinidad + Rango del enemigo (con icono)
    draw_set_halign(fa_right);
    draw_set_valign(fa_top);
    var _rango_txt = variable_struct_exists(en, "rango") ? en.rango : "Enemigo";
    var _en_afin_ico = scr_sprite_icono_afinidad(en.afinidad);
    var _en_afin_y = _en_barra_y + _en_barra_h + 10;  // +10 para dejar espacio a muescas de capas
    draw_set_color(c_ltgray);
    draw_text(_en_info_x, _en_afin_y, en.afinidad + "  |  " + _rango_txt);
    if (_en_afin_ico != -1) {
        var _en_afin_txt_w = string_width(en.afinidad + "  |  " + _rango_txt);
        draw_sprite_stretched(_en_afin_ico, 0, _en_info_x - _en_afin_txt_w - 20, _en_afin_y, 16, 16);
    }

    // ── Estado IA enemiga (debajo del retrato) ──
    var _ia_y = _en_frame_y + _en_portrait_size + 4;

    var _estado_txt = "";
    var _estado_col = c_white;

    switch (en.ia_estado) {
        case "ia_esperando":
            var _secs_left = en.ia_timer / GAME_FPS;
            _estado_txt = string_format(_secs_left, 1, 1) + "s";
            _estado_col = c_gray;
            break;
        case "ia_preparando":
            var _prep_left = en.ia_prep_timer / GAME_FPS;
            _estado_txt = "¡PREP! " + string_format(_prep_left, 1, 1) + "s";
            _estado_col = c_orange;
            break;
        case "ia_atacando":
            _estado_txt = "¡ATK!";
            _estado_col = c_red;
            break;
    }

    // Barra progreso IA bajo el retrato
    var _ia_bar_w = _en_portrait_size;
    var _ia_bar_h = 6;
    var _ia_bar_x = _en_frame_x;
    var _ia_bar_y = _ia_y;

    draw_set_color(make_color_rgb(40, 40, 40));
    draw_rectangle(_ia_bar_x, _ia_bar_y, _ia_bar_x + _ia_bar_w, _ia_bar_y + _ia_bar_h, false);

    if (en.ia_estado == "ia_esperando" || en.ia_estado == "ia_preparando") {
        var _ratio = 0;
        if (en.ia_estado == "ia_esperando") {
            var _max_t = scr_ia_calcular_espera(en.velocidad);
            _ratio = clamp(1 - (en.ia_timer / _max_t), 0, 1);
        } else {
            _ratio = clamp(1 - (en.ia_prep_timer / IA_PREP_FRAMES), 0, 1);
        }
        draw_set_color(_estado_col);
        draw_rectangle(_ia_bar_x, _ia_bar_y, _ia_bar_x + _ia_bar_w * _ratio, _ia_bar_y + _ia_bar_h, false);
    } else {
        draw_set_color(_estado_col);
        draw_rectangle(_ia_bar_x, _ia_bar_y, _ia_bar_x + _ia_bar_w, _ia_bar_y + _ia_bar_h, false);
    }

    // Texto estado IA centrado en la barra
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(_estado_col);
    draw_text(_ia_bar_x + _ia_bar_w / 2, _ia_bar_y + _ia_bar_h / 2, _estado_txt);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // ── ESTADOS ALTERADOS DEL ENEMIGO (iconos debajo de la barra IA) ──
    if (is_array(en.estados)) {
        var _est_x = _en_frame_x;
        var _est_y = _ia_bar_y + _ia_bar_h + 4;
        var _est_size = 28;
        var _est_gap = 4;
        var _est_count = 0;

        for (var _ei = 0; _ei < array_length(en.estados); _ei++) {
            var _ee = en.estados[_ei];
            if (!_ee.activo) continue;

            var _ec = c_white;
            if (_ee.tipo == "dot") _ec = c_red;
            else if (_ee.tipo == "hot") _ec = c_lime;
            else if (string_pos("buff", _ee.tipo) > 0) _ec = c_aqua;
            else if (string_pos("debuff", _ee.tipo) > 0) _ec = c_orange;

            var _ex = _est_x + _en_portrait_size - (_est_count + 1) * (_est_size + _est_gap);
            var _ey = _est_y;

            // Icono del estado enemigo (sprite o fallback)
            var _eico = scr_sprite_icono_estado(_ee.id);
            if (_eico != -1) {
                draw_sprite_stretched(_eico, 0, _ex, _ey, _est_size, _est_size);
            } else {
                draw_set_color(make_color_rgb(20, 20, 20));
                draw_rectangle(_ex, _ey, _ex + _est_size, _ey + _est_size, false);
                draw_set_halign(fa_center); draw_set_valign(fa_middle);
                draw_set_color(_ec);
                draw_text(_ex + _est_size / 2, _ey + _est_size / 2 - 2, string_upper(string_copy(_ee.id, 1, 3)));
            }
            draw_set_color(_ec);
            draw_rectangle(_ex, _ey, _ex + _est_size, _ey + _est_size, true);

            draw_set_halign(fa_center);
            draw_set_valign(fa_top);
            draw_set_color(c_ltgray);
            var _eseg = max(0, _ee.tiempo_rest / GAME_FPS);
            draw_text(_ex + _est_size / 2, _ey + _est_size + 1, string_format(_eseg, 1, 0));

            _est_count++;
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
        }
    }
}

// ── INDICADORES DE MECÁNICAS ESPECIALES ──
if (variable_struct_exists(en, "mecanicas") && is_array(en.mecanicas) && array_length(en.mecanicas) > 0) {
    var _mec_indicadores = scr_mec_obtener_indicadores(en);
    var _mec_x = w_gui - 300;
    var _mec_y = 104;

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    for (var _mi = 0; _mi < array_length(_mec_indicadores); _mi++) {
        var _ind = _mec_indicadores[_mi];
        draw_set_color(_ind.color);
        draw_text(_mec_x, _mec_y + _mi * 16, _ind.texto);
    }
}

// ╔═══════════════════════════════════════════════════════════════╗
// ║  SPRITES DE CUERPO COMPLETO (centro de pantalla)
// ╚═══════════════════════════════════════════════════════════════╝
if (!control_combate.combate_terminado || (variable_struct_exists(control_combate, "fin_dramatico_timer") && control_combate.fin_dramatico_timer > 0)) {

    // Aplicar zoom de impacto (centrado en pantalla)
    scr_fx_zoom_aplicar();

    scr_feedback_dibujar_sprites();

    // Partículas de impacto (sobre los sprites)
    scr_fx_particulas_dibujar();

    // Restaurar zoom de impacto
    scr_fx_zoom_restaurar();
}

// ╔═══════════════════════════════════════════════════════════════╗
// ║  TIMER DE COMBATE (centro superior)
// ╚═══════════════════════════════════════════════════════════════╝
{
    var _timer_frames = en.combate_timer;
    var _timer_secs = _timer_frames / GAME_FPS;
    var _mins = floor(_timer_secs / 60);
    var _secs = floor(_timer_secs) mod 60;

    var _timer_txt = string(_mins) + ":" + ((_secs < 10) ? "0" : "") + string(_secs);

    var _timer_col = c_white;
    var _timer_limite = en.timer_limite;
    if (_timer_limite > 0) {
        var _ratio_t = _timer_secs / _timer_limite;
        if (_ratio_t >= 1.0) _timer_col = c_red;
        else if (_ratio_t >= 0.75) _timer_col = c_orange;
        else if (_ratio_t >= 0.50) _timer_col = c_yellow;

        _timer_txt += " / " + string(floor(_timer_limite / 60)) + ":"
            + ((floor(_timer_limite) mod 60 < 10) ? "0" : "")
            + string(floor(_timer_limite) mod 60);
    }

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(_timer_col);
    draw_text(w_gui * 0.5, 5, _timer_txt);
    draw_set_halign(fa_left);
}

// ╔═══════════════════════════════════════════════════════════════╗
// ║  PANEL INFERIOR — HABILIDADES (Q W E R) + ITEMS (1 2 3) + RUNA
// ╚═══════════════════════════════════════════════════════════════╝

// ===========================
//  BARRA DE HABILIDADES (4 slots: Q W E R)
// ===========================
if (!control_combate.combate_terminado && is_array(pj.habilidades_arma)) {

    var habs = pj.habilidades_arma;
    var cds  = pj.habilidades_cd;

    var slots = array_length(habs);
    if (slots > 4) slots = 4;

    var _hab_w = 80;
    var _hab_h = 50;
    var _hab_gap = 8;
    var _hab_x_start = 30;
    var _hab_y_start = h_gui - 110;

    var key_labels = ["Q", "W", "E", "R"];

    for (var i = 0; i < slots; i++) {

        var sx1 = _hab_x_start + i * (_hab_w + _hab_gap);
        var sy1 = _hab_y_start;
        var sx2 = sx1 + _hab_w;
        var sy2 = sy1 + _hab_h;

        var id_hab = habs[i];
        var cd_actual = cds[i];
        var es_clase = (i == 0);

        // Icono de habilidad
        var _hab_ico = -1;
        if (es_clase) _hab_ico = spr_ico_hab_clase;
        else if (i == 1) _hab_ico = spr_ico_hab_arma_1;
        else if (i == 2) _hab_ico = spr_ico_hab_arma_2;
        else if (i == 3) _hab_ico = spr_ico_hab_arma_3;

        if (_hab_ico != -1) {
            draw_sprite_stretched(_hab_ico, 0, sx1 + 1, sy1 + 1, _hab_w - 2, _hab_h - 2);
        } else {
            draw_set_color(es_clase ? make_color_rgb(50, 35, 10) : make_color_rgb(30, 30, 30));
            draw_rectangle(sx1 + 1, sy1 + 1, sx2 - 1, sy2 - 1, false);
        }

        // Marco
        draw_set_color(es_clase ? c_orange : c_white);
        draw_rectangle(sx1, sy1, sx2, sy2, true);

        // Nombre habilidad
        var nombre = scr_nombre_habilidad(id_hab);
        draw_set_color(es_clase ? c_orange : c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text((sx1 + sx2) / 2, sy1 + 18, nombre);

        // Tecla
        draw_set_color(c_yellow);
        draw_text((sx1 + sx2) / 2, sy2 - 10, key_labels[i]);

        // Cooldown overlay
        var cd_base = scr_cooldown_habilidad(id_hab);
        if (cd_actual > 0 && cd_base > 0) {
            var ratio = clamp(cd_actual / cd_base, 0, 1);
            draw_set_color(c_black);
            draw_set_alpha(0.7);
            var fill_h = _hab_h * ratio;
            draw_rectangle(sx1 + 1, sy2 - fill_h, sx2 - 1, sy2 - 1, false);
            draw_set_alpha(1);

            var secs = cd_actual / GAME_FPS;
            draw_set_color(c_aqua);
            draw_text((sx1 + sx2) / 2, sy1 + 5, string_format(secs, 1, 1));
        }
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// ===========================
//  BARRA DE ESENCIA — Sistema visual premium
// ===========================
if (!control_combate.combate_terminado) {
    scr_esencia_barra_dibujar(pj);
}

// ===========================
//  BOTÓN SÚPER (a la derecha de la barra de esencia)
// ===========================
if (!control_combate.combate_terminado) {
    var _ese_ratio = clamp(pj.esencia / max(1, pj.esencia_llena), 0, 1);
    var _super_ok  = (_ese_ratio >= 0.50);  // 50% mínimo para usar

    // Posición: justo después de la barra de esencia
    var _sb_x = ESE_BAR_MARGIN + ESE_BAR_W + 12 + super_deny_shake;
    var _sb_y = h_gui - ESE_BAR_BOTTOM - 6;
    var _sb_w = 110;
    var _sb_h = 30;

    // Color y estilo según disponibilidad
    var _afinidad_pj = variable_struct_exists(pj, "afinidad") ? pj.afinidad : "Neutra";
    var _pal = scr_paleta_afinidad(_afinidad_pj);

    if (_super_ok) {
        // Disponible: glow pulsante
        var _pulse = 0.7 + 0.3 * sin(current_time * 0.004);
        // Glow detrás
        draw_set_color(_pal.energia);
        draw_set_alpha(0.15 * _pulse);
        draw_roundrect_ext(_sb_x - 3, _sb_y - 3, _sb_x + _sb_w + 3, _sb_y + _sb_h + 3, 6, 6, false);
        draw_set_alpha(1);
        // Fondo botón
        draw_set_color(make_color_rgb(20, 15, 40));
        draw_set_alpha(0.85);
        draw_roundrect_ext(_sb_x, _sb_y, _sb_x + _sb_w, _sb_y + _sb_h, 4, 4, false);
        draw_set_alpha(1);
        // Borde
        draw_set_color(merge_color(_pal.energia, c_white, _pulse * 0.3));
        draw_roundrect_ext(_sb_x, _sb_y, _sb_x + _sb_w, _sb_y + _sb_h, 4, 4, true);
        // Texto
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(merge_color(_pal.energia, c_white, _pulse * 0.4));
        draw_text(_sb_x + _sb_w / 2, _sb_y + _sb_h / 2, "[TAB] SÚPER");
    } else {
        // No disponible: botón apagado
        draw_set_color(make_color_rgb(15, 12, 25));
        draw_set_alpha(0.7);
        draw_roundrect_ext(_sb_x, _sb_y, _sb_x + _sb_w, _sb_y + _sb_h, 4, 4, false);
        draw_set_alpha(1);
        draw_set_color(make_color_rgb(60, 55, 70));
        draw_roundrect_ext(_sb_x, _sb_y, _sb_x + _sb_w, _sb_y + _sb_h, 4, 4, true);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(make_color_rgb(80, 70, 90));
        draw_text(_sb_x + _sb_w / 2, _sb_y + _sb_h / 2, "[TAB] SÚPER");
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// ===========================
//  COLUMNA IZQUIERDA: RUNA (arriba) + CONSUMIBLES 1-2-3 (abajo)
// ===========================
if (!control_combate.combate_terminado) {

    var _obj_arr  = control_combate.objetos_equipados;
    var _used_arr = control_combate.objetos_usados;

    // Dimensiones de cada slot
    var _sw = 54;
    var _sh = 50;
    var _sgap = 6;

    // Columna vertical centrada a la izquierda del personaje
    // Personaje está en w_gui * 0.22 ≈ 282.  Columna en x = 8.
    // 4 slots (1 runa + 3 consumibles): altura total = 4×50 + 3×6 = 218
    // Centrada verticalmente sobre el cuerpo del PJ (y ≈ 396)
    var _col_x = 8;
    var _col_h = 4 * _sh + 3 * _sgap;  // 218
    var _col_y = floor(h_gui * 0.55 - _col_h * 0.5);  // ≈ 287

    // ── SLOT DE RUNA (posición 0, arriba de todo) ──
    {
        var _runa_nom = control_combate.runa_activa;
        var _runa_vacia = (_runa_nom == "" || _runa_nom == undefined);

        var _rx1 = _col_x;
        var _ry1 = _col_y;
        var _rx2 = _rx1 + _sw;
        var _ry2 = _ry1 + _sh;

        draw_sprite_stretched(spr_slot_runa, 0, _rx1, _ry1, _sw, _sh);

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);

        if (_runa_vacia) {
            draw_set_color(c_dkgray);
            draw_text((_rx1 + _rx2) / 2, _ry1 + 18, "—");
        } else {
            var _runa_ico = scr_sprite_icono_runa(_runa_nom);
            if (_runa_ico != -1) {
                draw_sprite_stretched(_runa_ico, 0, _rx1 + (_sw - 30) / 2, _ry1 + 2, 30, 30);
            } else {
                draw_set_color(make_color_rgb(220, 180, 255));
                var _rtxt = _runa_nom;
                if (string_length(_rtxt) > 6) _rtxt = string_copy(_rtxt, 1, 6);
                draw_text((_rx1 + _rx2) / 2, _ry1 + 14, _rtxt);
            }
        }

        draw_set_color(_runa_vacia ? c_dkgray : make_color_rgb(180, 120, 255));
        draw_text((_rx1 + _rx2) / 2, _ry2 - 9, "R");
    }

    // ── SLOTS DE CONSUMIBLES (posiciones 1-3, debajo de la runa) ──
    for (var i = 0; i < 3; i++) {

        var _ox1 = _col_x;
        var _oy1 = _col_y + (i + 1) * (_sh + _sgap);
        var _ox2 = _ox1 + _sw;
        var _oy2 = _oy1 + _sh;

        var _tiene_obj = (is_array(_obj_arr) && i < array_length(_obj_arr));
        var _obj_nombre = _tiene_obj ? _obj_arr[i] : "";
        var _usado = (_tiene_obj && is_array(_used_arr)) ? _used_arr[i] : false;
        var _vacio = (!_tiene_obj || _obj_nombre == "" || _obj_nombre == undefined);

        draw_sprite_stretched(spr_slot_objeto, 0, _ox1, _oy1, _sw, _sh);

        if (_usado) {
            draw_set_color(c_black);
            draw_set_alpha(0.6);
            draw_rectangle(_ox1 + 1, _oy1 + 1, _ox2 - 1, _oy2 - 1, false);
            draw_set_alpha(1);
        }

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);

        if (_vacio) {
            draw_set_color(c_dkgray);
            draw_text((_ox1 + _ox2) / 2, _oy1 + 18, "—");
        } else if (_usado) {
            draw_set_color(c_dkgray);
            draw_text((_ox1 + _ox2) / 2, _oy1 + 18, "X");
        } else {
            var _obj_ico = scr_sprite_icono_objeto(_obj_nombre);
            if (_obj_ico != -1) {
                draw_sprite_stretched(_obj_ico, 0, _ox1 + (_sw - 30) / 2, _oy1 + 2, 30, 30);
            } else {
                draw_set_color(c_white);
                var _txt = _obj_nombre;
                if (string_length(_txt) > 6) _txt = string_copy(_txt, 1, 6);
                draw_text((_ox1 + _ox2) / 2, _oy1 + 14, _txt);
            }
        }

        draw_set_color(_vacio ? c_dkgray : (_usado ? c_dkgray : c_yellow));
        draw_text((_ox1 + _ox2) / 2, _oy2 - 9, string(i + 1));
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// ╔═══════════════════════════════════════════════════════════════╗
// ║  MENSAJE DE FIN DE COMBATE
// ╚═══════════════════════════════════════════════════════════════╝
if (control_combate.combate_terminado) {

    // ── Flash dramático de fin de combate ──
    scr_fin_combate_dibujar_flash();

    // ── Si el timer dramático sigue activo, NO mostrar resultados aún ──
    if (variable_struct_exists(control_combate, "fin_dramatico_timer")
        && control_combate.fin_dramatico_timer > 0) {
        // Solo mostrar sprites y flash, no el overlay de resultados
    } else {

    // Overlay oscuro
    draw_set_color(c_black);
    draw_set_alpha(0.6);
    draw_rectangle(0, 0, w_gui, h_gui, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    var _fy = h_gui * 0.35;

    draw_set_color(c_yellow);
    draw_text(w_gui * 0.5, _fy, "Ganador: " + control_combate.ganador);

    if (control_combate.ganador == "Jugador" && control_combate.oro_recompensa > 0) {
        draw_set_color(make_color_rgb(255, 215, 0));
        draw_text(w_gui * 0.5, _fy + 30, "+" + string(control_combate.oro_recompensa) + " Oro");
    }

    // Tiempo
    var _final_time = en.combate_timer / GAME_FPS;
    var _fm = floor(_final_time / 60);
    var _fs = floor(_final_time) mod 60;
    var _timp_txt = "Tiempo: " + string(_fm) + ":" + ((_fs < 10) ? "0" : "") + string(_fs);
    if (en.timer_limite > 0) {
        if (_final_time <= en.timer_limite) {
            draw_set_color(c_lime);
            _timp_txt += " ✓ ¡En tiempo!";
        } else {
            draw_set_color(c_orange);
            _timp_txt += " ✗ Fuera de tiempo";
        }
    } else {
        draw_set_color(c_white);
    }
    draw_text(w_gui * 0.5, _fy + 90, _timp_txt);

    draw_set_color(c_gray);
    draw_text(w_gui * 0.5, _fy + 60, "Pulsa ENTER o ESC para continuar");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    } // fin del else (timer dramático terminó)
}

// ===========================
//  NOTIFICACIONES (ocultar si el combate terminó)
// ===========================
if (!control_combate.combate_terminado) {
    scr_notif_dibujar();
    // Números flotantes de feedback (daño, curación, buffs)
    scr_feedback_dibujar();
    // Efectos FX (impacto, crítico, curación, etc.)
    scr_feedback_dibujar_fx();

    // Diálogos pre-combate (overlay sobre todo)
    scr_dialogos_dibujar();
} else {
    // Limpiar notificaciones y feedbacks para que no se acumulen al volver
    control_combate.notificaciones = [];
    control_combate.feedbacks = [];
}

// ╔═══════════════════════════════════════════════════════════════╗
// ║  MENÚ DE PAUSA
// ╚═══════════════════════════════════════════════════════════════╝
if (pausado && !control_combate.combate_terminado) {

    // Overlay oscuro
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, w_gui, h_gui, false);
    draw_set_alpha(1);

    var _pw = 300;
    var _ph = 180;
    var _px = (w_gui - _pw) / 2;
    var _py = (h_gui - _ph) / 2;

    // Fondo panel (sprite)
    draw_sprite_stretched(spr_panel_info, 0, _px, _py, _pw, _ph);

    // Marco panel
    draw_set_color(c_white);
    draw_rectangle(_px, _py, _px + _pw, _py + _ph, true);

    // Título
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_yellow);
    draw_text(_px + _pw / 2, _py + 20, "PAUSA");

    // Opciones
    var _opciones = ["Reanudar", "Salir al Menú"];
    for (var i = 0; i < 2; i++) {
        var _oy = _py + 70 + i * 40;
        if (i == pausa_opcion) {
            draw_set_color(c_yellow);
            draw_text(_px + _pw / 2, _oy, "> " + _opciones[i] + " <");
        } else {
            draw_set_color(c_gray);
            draw_text(_px + _pw / 2, _oy, _opciones[i]);
        }
    }

    draw_set_color(c_dkgray);
    draw_text(_px + _pw / 2, _py + _ph - 25, "ESPACIO: Volver");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// ── Indicador de pausa (pequeño) ──
if (!control_combate.combate_terminado) {
    draw_set_halign(fa_right);
    draw_set_valign(fa_top);
    draw_set_color(c_dkgray);
    draw_text(w_gui - 10, h_gui - 15, "[ESPACIO] Pausa");
    draw_set_halign(fa_left);
}
