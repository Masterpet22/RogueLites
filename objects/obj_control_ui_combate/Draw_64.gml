/// DRAW GUI - obj_control_ui_combate

if (!instance_exists(control_combate)) {
    exit;
}
draw_set_font(fnt_1)

var pj = control_combate.personaje_jugador;
var en = control_combate.personaje_enemigo;
// ===========================
//  BARRA DE HABILIDADES (4 slots: Clase + Arma)
// ===========================

if (is_array(pj.habilidades_arma)) {

    var habs = pj.habilidades_arma;
    var cds  = pj.habilidades_cd;

    var slots = array_length(habs);
    if (slots > 4) slots = 4; // máximo 4 (1 clase + 3 arma)

    var x_start = 40;
    var y_start = display_get_gui_height() - 90;

    var slot_w = 80;
    var slot_h = 50;
    var gap    = 12;

    var key_labels = ["SPC", "Q", "W", "E"];

    for (var i = 0; i < slots; i++) {

        var sx1 = x_start + i * (slot_w + gap);
        var sy1 = y_start;
        var sx2 = sx1 + slot_w;
        var sy2 = sy1 + slot_h;

        var id_hab = habs[i];
        var cd_actual = cds[i];
        var es_clase = (i == 0); // slot 0 siempre es la habilidad de clase

        // Marco: dorado para clase, blanco para arma
        draw_set_color(es_clase ? c_orange : c_white);
        draw_rectangle(sx1, sy1, sx2, sy2, false);

        // Fondo: tono distinto para clase
        draw_set_color(es_clase ? make_color_rgb(50, 35, 10) : make_color_rgb(30, 30, 30));
        draw_rectangle(sx1+1, sy1+1, sx2-1, sy2-1, false);

        // Nombre de habilidad
        var nombre = scr_nombre_habilidad(id_hab);
        draw_set_color(es_clase ? c_orange : c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text((sx1+sx2)/2, sy1 + 18, nombre);

        // Tecla
        draw_set_color(c_yellow);
        draw_text((sx1+sx2)/2, sy2 - 10, key_labels[i]);

        // Cooldown overlay
        var cd_base = scr_cooldown_habilidad(id_hab);
        if (cd_actual > 0 && cd_base > 0) {

            var ratio = clamp(cd_actual / cd_base, 0, 1);

            draw_set_color(c_black);
            draw_set_alpha(0.7);

            var fill_h = slot_h * ratio;
            draw_rectangle(sx1+1, sy2 - fill_h, sx2-1, sy2-1, false);

            draw_set_alpha(1);

            // Número de segundos restantes
            var secs = cd_actual / GAME_FPS;
            draw_set_color(c_aqua);
            draw_text((sx1+sx2)/2, sy1 + 5, string_format(secs, 1, 1));
        }
    }

    // Restaurar alineación default
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// ===========================
//  BARRA DE ESENCIA + SLOT SÚPER (TIERS: 50% / 75% / 100%)
// ===========================
{
    var _es_x = 40;
    var _es_y = display_get_gui_height() - 30;
    var _es_w = 200;
    var _es_h = 12;

    var _esencia_ratio = clamp(pj.esencia / pj.esencia_llena, 0, 1);

    // Determinar tier actual
    var _tier = 0;       // 0 = no disponible, 1 = 50%, 2 = 75%, 3 = 100%
    var _tier_txt = "";
    var _tier_col = make_color_rgb(80, 60, 200); // púrpura base

    if (pj.esencia >= pj.esencia_llena) {
        _tier = 3;
        _tier_txt = "100%";
        _tier_col = c_yellow;
    } else if (pj.esencia >= pj.esencia_llena * 0.75) {
        _tier = 2;
        _tier_txt = "75%";
        _tier_col = c_orange;
    } else if (pj.esencia >= pj.esencia_llena * 0.5) {
        _tier = 1;
        _tier_txt = "50%";
        _tier_col = make_color_rgb(100, 180, 255);
    }

    var _super_disponible = (_tier >= 1);

    // Fondo barra
    draw_set_color(make_color_rgb(30, 30, 50));
    draw_rectangle(_es_x, _es_y, _es_x + _es_w, _es_y + _es_h, false);

    // Relleno esencia (color según tier)
    draw_set_color(_super_disponible ? _tier_col : make_color_rgb(80, 60, 200));
    draw_rectangle(_es_x, _es_y, _es_x + _es_w * _esencia_ratio, _es_y + _es_h, false);

    // Marcadores de tier (líneas verticales al 50% y 75%)
    draw_set_color(make_color_rgb(180, 180, 180));
    draw_set_alpha(0.6);
    var _mark_50 = _es_x + _es_w * 0.50;
    var _mark_75 = _es_x + _es_w * 0.75;
    draw_line(_mark_50, _es_y, _mark_50, _es_y + _es_h);
    draw_line(_mark_75, _es_y, _mark_75, _es_y + _es_h);
    draw_set_alpha(1);

    // Marco
    draw_set_color(_super_disponible ? _tier_col : c_white);
    draw_rectangle(_es_x, _es_y, _es_x + _es_w, _es_y + _es_h, true);

    // Texto
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(_super_disponible ? _tier_col : c_white);

    var _etiqueta = "ESENCIA: " + string(round(pj.esencia)) + "/" + string(pj.esencia_llena);
    if (_super_disponible) {
        _etiqueta += "  [R] SÚPER " + _tier_txt + "!";
    }
    draw_text(_es_x + _es_w + 12, _es_y - 1, _etiqueta);
}
// Fondo
draw_set_color(c_black);
draw_set_alpha(0.5);
draw_rectangle(0, 0, display_get_gui_width(), 80, false);
draw_set_alpha(1);

// Vida jugador
var w_gui = display_get_gui_width();

var barra_ancho = 200;
var barra_alto  = 16;

// Porcentaje de vida
var pj_ratio = pj.vida_actual / pj.vida_max;
var en_ratio = en.vida_actual / en.vida_max;

// Barra jugador (izquierda)
var x1 = 20;
var y1 = 20;
var x2 = x1 + barra_ancho;
var y2 = y1 + barra_alto;

// Marco
draw_set_color(c_white);
draw_rectangle(x1, y1, x2, y2, false);

// Relleno
draw_set_color(c_lime);
draw_rectangle(x1, y1, x1 + barra_ancho * pj_ratio, y2, false);

// Texto
/// DIBUJAR NOMBRE + ARMA + VIDA DEL JUGADOR

var texto_jugador = pj.nombre + " [" + pj.arma + " | " + pj.personalidad + "]  HP: " 
    + string(pj.vida_actual) + " / " + string(pj.vida_max);

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_text(20, 45, texto_jugador);



// Barra enemigo (derecha)
x2 = w_gui - 20;
x1 = x2 - barra_ancho;
y1 = 20;
y2 = y1 + barra_alto;

// Marco
draw_set_color(c_white);
draw_rectangle(x1, y1, x2, y2, false);

// Relleno
draw_set_color(c_red);
draw_rectangle(x2 - barra_ancho * en_ratio, y1, x2, y2, false);

// Texto
var texto_enemigo = en.nombre + "  HP: "
    + string(en.vida_actual) + " / " + string(en.vida_max);

draw_text(display_get_gui_width() - 240, 45, texto_enemigo);


// ===========================
//  INDICADOR DE ESTADO IA ENEMIGA
// ===========================
{
    var _ia_x = display_get_gui_width() - 240;
    var _ia_y = 62;

    var _estado_txt = "";
    var _estado_col = c_white;

    switch (en.ia_estado) {
        case "ia_esperando":
            var _secs_left = en.ia_timer / GAME_FPS;
            _estado_txt = "Esperando... " + string_format(_secs_left, 1, 1) + "s";
            _estado_col = c_gray;
            break;

        case "ia_preparando":
            var _prep_left = en.ia_prep_timer / GAME_FPS;
            _estado_txt = "¡Preparando ataque! " + string_format(_prep_left, 1, 1) + "s";
            _estado_col = c_orange;
            break;

        case "ia_atacando":
            _estado_txt = "¡ATACANDO!";
            _estado_col = c_red;
            break;
    }

    draw_set_color(_estado_col);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text(_ia_x, _ia_y, _estado_txt);

    // Barra de progreso del timer (pequeña, debajo del estado)
    if (en.ia_estado == "ia_esperando" || en.ia_estado == "ia_preparando") {
        var _bar_w = 150;
        var _bar_h = 4;
        var _bar_x = _ia_x;
        var _bar_y = _ia_y + 16;

        // Calcular ratio
        var _ratio = 0;
        if (en.ia_estado == "ia_esperando") {
            var _max_t = scr_ia_calcular_espera(en.velocidad);
            _ratio = clamp(1 - (en.ia_timer / _max_t), 0, 1);
        } else {
            _ratio = clamp(1 - (en.ia_prep_timer / IA_PREP_FRAMES), 0, 1);
        }

        // Fondo
        draw_set_color(make_color_rgb(40, 40, 40));
        draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, false);

        // Relleno
        draw_set_color(_estado_col);
        draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w * _ratio, _bar_y + _bar_h, false);
    }
}

// ===========================
//  INDICADORES DE MECÁNICAS ESPECIALES
// ===========================
if (variable_struct_exists(en, "mecanicas") && is_array(en.mecanicas) && array_length(en.mecanicas) > 0) {
    var _mec_indicadores = scr_mec_obtener_indicadores(en);
    var _mec_x = display_get_gui_width() - 240;
    var _mec_y = 86;

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    for (var _mi = 0; _mi < array_length(_mec_indicadores); _mi++) {
        var _ind = _mec_indicadores[_mi];
        draw_set_color(_ind.color);
        draw_text(_mec_x, _mec_y + _mi * 14, _ind.texto);
    }
}

// ===========================
//  TIMER DE COMBATE
// ===========================
{
    var _timer_frames = en.combate_timer;
    var _timer_secs = _timer_frames / GAME_FPS;
    var _mins = floor(_timer_secs / 60);
    var _secs = floor(_timer_secs) mod 60;

    var _timer_txt = string(_mins) + ":" + ((_secs < 10) ? "0" : "") + string(_secs);

    // Si hay timer límite, mostrar con color según urgencia
    var _timer_col = c_white;
    var _timer_limite = en.timer_limite;
    if (_timer_limite > 0) {
        var _ratio_t = _timer_secs / _timer_limite;
        if (_ratio_t >= 1.0) {
            _timer_col = c_red;
        } else if (_ratio_t >= 0.75) {
            _timer_col = c_orange;
        } else if (_ratio_t >= 0.50) {
            _timer_col = c_yellow;
        }
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


// Mensaje de fin de combate
if (control_combate.combate_terminado) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_yellow);

    draw_text(w_gui * 0.5, 60, "Ganador: " + control_combate.ganador);

    // Mostrar oro ganado si el jugador ganó
    if (control_combate.ganador == "Jugador" && control_combate.oro_recompensa > 0) {
        draw_set_color(make_color_rgb(255, 215, 0)); // dorado
        draw_text(w_gui * 0.5, 85, "+" + string(control_combate.oro_recompensa) + " Oro");
    }

    // Mostrar tiempo de combate en pantalla de fin
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
    draw_text(w_gui * 0.5, 135, _timp_txt);

    draw_set_color(c_gray);
    draw_text(w_gui * 0.5, 110, "Pulsa ENTER o ESC para continuar");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// ===========================
//  NOTIFICACIONES DE ACCIONES
// ===========================
scr_notif_dibujar();

// ===========================
//  SLOTS DE OBJETOS EQUIPADOS (teclas 1, 2, 3) — siempre 3 slots
// ===========================
if (!control_combate.combate_terminado) {

    var _obj_arr  = control_combate.objetos_equipados;
    var _used_arr = control_combate.objetos_usados;

    var _ox_start = display_get_gui_width() - 300;
    var _oy_start = display_get_gui_height() - 90;

    var _ow = 85;
    var _oh = 50;
    var _ogap = 10;

    for (var i = 0; i < 3; i++) {

        var _ox1 = _ox_start + i * (_ow + _ogap);
        var _oy1 = _oy_start;
        var _ox2 = _ox1 + _ow;
        var _oy2 = _oy1 + _oh;

        // Determinar si este slot tiene objeto
        var _tiene_obj = (is_array(_obj_arr) && i < array_length(_obj_arr));
        var _obj_nombre = _tiene_obj ? _obj_arr[i] : "";
        var _usado = (_tiene_obj && is_array(_used_arr)) ? _used_arr[i] : false;
        var _vacio = (!_tiene_obj || _obj_nombre == "" || _obj_nombre == undefined);

        // Marco
        if (_vacio) {
            draw_set_color(c_dkgray);
        } else {
            draw_set_color(_usado ? c_dkgray : c_lime);
        }
        draw_rectangle(_ox1, _oy1, _ox2, _oy2, false);

        // Fondo
        draw_set_color(_vacio ? make_color_rgb(25, 25, 25) : (_usado ? make_color_rgb(20, 20, 20) : make_color_rgb(15, 40, 15)));
        draw_rectangle(_ox1+1, _oy1+1, _ox2-1, _oy2-1, false);

        // Nombre del objeto (abreviado)
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);

        if (_vacio) {
            draw_set_color(c_dkgray);
            draw_text((_ox1+_ox2)/2, _oy1 + 16, "Vacío");
        } else if (_usado) {
            draw_set_color(c_dkgray);
            draw_text((_ox1+_ox2)/2, _oy1 + 16, "USADO");
        } else {
            draw_set_color(c_white);
            var _txt = _obj_nombre;
            if (string_length(_txt) > 10) _txt = string_copy(_txt, 1, 10) + ".";
            draw_text((_ox1+_ox2)/2, _oy1 + 16, _txt);
        }

        // Tecla
        draw_set_color(_vacio ? c_dkgray : (_usado ? c_dkgray : c_yellow));
        draw_text((_ox1+_ox2)/2, _oy2 - 10, string(i + 1));
    }

    // Restaurar alineación
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}