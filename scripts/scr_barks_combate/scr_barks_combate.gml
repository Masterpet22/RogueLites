/// scr_barks_combate — Diálogos cortos no bloqueantes durante el combate
/// Se muestran como texto flotante sobre el personaje que habla.
/// Triggers: 50% HP, parry perfecto, uso de súper, muerte de enemigo.

// ══════════════════════════════════════════════════════════════
//  Macros de configuración
// ══════════════════════════════════════════════════════════════
#macro BARK_DURACION        180     // 3 segundos a 60 FPS
#macro BARK_COOLDOWN        300     // 5 segundos entre barks del mismo tipo
#macro BARK_FADE_FRAMES     30      // último medio segundo en fade-out
#macro BARK_Y_OFFSET        -40     // offset arriba del sprite

// ══════════════════════════════════════════════════════════════
//  scr_barks_init()
//  Llamar al inicio del combate para inicializar el sistema.
// ══════════════════════════════════════════════════════════════
function scr_barks_init() {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);

    _c.bark_activo       = false;
    _c.bark_texto        = "";
    _c.bark_es_jugador   = true;
    _c.bark_timer        = 0;
    _c.bark_color        = c_white;

    // Cooldowns por tipo para evitar spam
    _c.bark_cd_vida_pj   = 0;
    _c.bark_cd_vida_en   = 0;
    _c.bark_cd_parry     = 0;
    _c.bark_cd_super     = 0;

    // Tracking de triggers ya disparados
    _c.bark_vida50_pj    = false;
    _c.bark_vida50_en    = false;

    // ── Diálogo mid-combat (bloqueante, 1 vez por combate) ──
    _c.dial_mid_activo      = false;
    _c.dial_mid_disparado   = false;   // true después de la 1ª vez → no repetir
    _c.dial_mid_frases      = [];      // array de { nombre, texto, es_jugador }
    _c.dial_mid_indice      = 0;
    _c.dial_mid_timer       = 0;
}

// ══════════════════════════════════════════════════════════════
//  scr_barks_actualizar()
//  Llamar cada frame. Decrementa timers y cooldowns.
// ══════════════════════════════════════════════════════════════
function scr_barks_actualizar() {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);

    // Decrementar bark activo
    if (_c.bark_activo) {
        _c.bark_timer--;
        if (_c.bark_timer <= 0) {
            _c.bark_activo = false;
        }
    }

    // Decrementar cooldowns
    if (_c.bark_cd_vida_pj > 0) _c.bark_cd_vida_pj--;
    if (_c.bark_cd_vida_en > 0) _c.bark_cd_vida_en--;
    if (_c.bark_cd_parry > 0)   _c.bark_cd_parry--;
    if (_c.bark_cd_super > 0)   _c.bark_cd_super--;

    // ── Auto-trigger: chequear HP al 50% — diálogo bloqueante (1 vez por combate) ──
    var _pj = _c.personaje_jugador;
    var _en = _c.personaje_enemigo;

    if (!_c.dial_mid_disparado && !_c.dial_mid_activo) {
        var _pj_bajo50 = (_pj.vida_actual <= _pj.vida_max * 0.5 && _pj.vida_actual > 0);
        var _en_bajo50 = (_en.vida_actual <= _en.vida_max * 0.5 && _en.vida_actual > 0);

        if (_pj_bajo50 || _en_bajo50) {
            scr_dial_mid_iniciar(_pj, _en);
        }
    }

    // Actualizar diálogo mid-combat si está activo
    // (la lógica de bloqueo se hace desde Step consultando scr_dial_mid_activo())
}

// ══════════════════════════════════════════════════════════════
//  scr_bark_mostrar(es_jugador, texto, color)
//  Inicia un bark visible.
// ══════════════════════════════════════════════════════════════
function scr_bark_mostrar(_es_jugador, _texto, _color) {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);

    _c.bark_activo     = true;
    _c.bark_texto      = _texto;
    _c.bark_es_jugador = _es_jugador;
    _c.bark_timer      = BARK_DURACION;
    _c.bark_color      = _color;
}

// ══════════════════════════════════════════════════════════════
//  scr_bark_on_parry_perfecto(defensor, atacante)
//  Trigger: después de un parry perfecto exitoso.
// ══════════════════════════════════════════════════════════════
function scr_bark_on_parry_perfecto(_defensor, _atacante) {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);
    if (_c.bark_cd_parry > 0) return; // cooldown activo

    var _frases = [
        "¡No pasarás!",
        "¡Demasiado lento!",
        "¡Leí tu movimiento!",
        "¡Inútil!",
        "¡Parry perfecto!"
    ];
    var _texto = _frases[irandom(array_length(_frases) - 1)];
    scr_bark_mostrar(_defensor.es_jugador, _texto, c_aqua);
    _c.bark_cd_parry = BARK_COOLDOWN;
}

// ══════════════════════════════════════════════════════════════
//  scr_bark_on_super(atacante)
//  Trigger: al activar una súper-habilidad.
// ══════════════════════════════════════════════════════════════
function scr_bark_on_super(_atacante) {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);
    if (_c.bark_cd_super > 0) return;

    var _frases = [
        "¡Siente mi poder!",
        "¡Ahora verás!",
        "¡Éste es mi verdadero poder!",
        "¡No podrás resistir esto!",
        "¡TOMA ESTO!"
    ];
    var _texto = _frases[irandom(array_length(_frases) - 1)];
    scr_bark_mostrar(_atacante.es_jugador, _texto, make_color_rgb(180, 120, 255));
    _c.bark_cd_super = BARK_COOLDOWN;
}

// ══════════════════════════════════════════════════════════════
//  scr_bark_frase_vida50(personaje, es_jugador) -> string
//  Genera una frase según el estado de salud al 50%.
//  (Legacy — mantenida para compatibilidad, el sistema principal
//   ahora usa scr_dial_mid_iniciar para el diálogo bloqueante)
// ══════════════════════════════════════════════════════════════
function scr_bark_frase_vida50(_personaje, _es_jugador) {
    if (_es_jugador) {
        var _frases = [
            "No puedo bajar la guardia...",
            "Esto se pone difícil...",
            "Aún me queda fuerza.",
            "No caeré tan fácil."
        ];
    } else {
        var _frases = [
            "¡Pagarás por esto!",
            "¡No me subestimes!",
            "Aún no he terminado...",
            "¡Esto apenas comienza!"
        ];
    }
    return _frases[irandom(array_length(_frases) - 1)];
}


// ══════════════════════════════════════════════════════════════
//  DIÁLOGO MID-COMBAT (bloqueante, 50% HP, 1 vez por combate)
//  Similar a los diálogos pre-combate pero se activa mid-fight.
// ══════════════════════════════════════════════════════════════

#macro DIAL_MID_DURACION  180   // 3 s por frase
#macro DIAL_MID_FADE      15    // frames fade-in/out

/// scr_dial_mid_iniciar(pj, en)
/// Dispara el diálogo bloqueante de 50% HP.
/// Elige al azar quién habla; su frase refleja si va ganando o perdiendo.
function scr_dial_mid_iniciar(_pj, _en) {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);
    if (_c.dial_mid_disparado) return;   // ya se usó este combate

    _c.dial_mid_disparado = true;

    // Determinar quién va ganando (% de HP restante)
    var _pct_pj = _pj.vida_actual / max(1, _pj.vida_max);
    var _pct_en = _en.vida_actual / max(1, _en.vida_max);

    // Elegir al azar quién habla (true = jugador, false = enemigo)
    var _habla_jugador = (irandom(1) == 0);

    // ¿El que habla va ganando?
    var _va_ganando = _habla_jugador ? (_pct_pj >= _pct_en) : (_pct_en >= _pct_pj);

    // Frases según estado
    var _frases_ganando = [
        "¡Ya eres mío!",
        "¿Eso es todo lo que tienes?",
        "Siento tu debilidad...",
        "Un golpe más y caerás.",
        "La victoria está cerca.",
        "Ni siquiera estoy usando toda mi fuerza."
    ];

    var _frases_perdiendo = [
        "No... aún no termino...",
        "Esto no puede acabar así...",
        "¡No pienso rendirme!",
        "Tengo que resistir un poco más...",
        "Aún me queda algo de fuerza.",
        "¡No me subestimes!"
    ];

    var _lista = _va_ganando ? _frases_ganando : _frases_perdiendo;
    var _texto = _lista[irandom(array_length(_lista) - 1)];
    var _nombre = _habla_jugador ? _pj.nombre : _en.nombre;

    // Armar secuencia de 1 frase
    _c.dial_mid_frases = [{
        nombre:     _nombre,
        texto:      _texto,
        es_jugador: _habla_jugador
    }];

    _c.dial_mid_activo  = true;
    _c.dial_mid_indice  = 0;
    _c.dial_mid_timer   = DIAL_MID_DURACION;

    // Foco visual en el que habla
    _c.foco_quien      = _habla_jugador ? 1 : 2;
    _c.foco_escala_obj = 1.12;
    _c.foco_dim_obj    = 0.45;
    _c.foco_vel        = 0.06;
}

/// scr_dial_mid_actualizar()
/// Llamar cada frame ANTES de la lógica de combate.
/// Retorna TRUE si el diálogo mid está activo (bloquear combate).
function scr_dial_mid_actualizar() {
    if (!instance_exists(obj_control_combate)) return false;
    var _c = instance_find(obj_control_combate, 0);
    if (!_c.dial_mid_activo) return false;

    // Skip con Enter
    if (keyboard_check_pressed(vk_enter) || mouse_check_button_pressed(mb_left)) {
        _c.dial_mid_timer = 0;
    }

    _c.dial_mid_timer--;

    if (_c.dial_mid_timer <= 0) {
        _c.dial_mid_indice++;
        if (_c.dial_mid_indice >= array_length(_c.dial_mid_frases)) {
            // Fin del diálogo → restaurar foco
            _c.dial_mid_activo   = false;
            _c.foco_quien        = 0;
            _c.foco_escala_obj   = 1.0;
            _c.foco_dim_obj      = 1.0;
            return false;
        }
        _c.dial_mid_timer = DIAL_MID_DURACION;

        // Actualizar foco hacia nueva frase
        var _fr = _c.dial_mid_frases[_c.dial_mid_indice];
        _c.foco_quien      = _fr.es_jugador ? 1 : 2;
        _c.foco_escala_obj = 1.12;
        _c.foco_dim_obj    = 0.45;
    }

    return true;  // bloquear combate
}

/// scr_dial_mid_activo()
/// Consulta rápida: ¿está activo el diálogo mid-combat?
function scr_dial_mid_activo() {
    if (!instance_exists(obj_control_combate)) return false;
    var _c = instance_find(obj_control_combate, 0);
    return _c.dial_mid_activo;
}

/// scr_dial_mid_dibujar()
/// Dibujar la caja de diálogo mid-combat (estilo pre-combate).
/// Llamar en Draw_64 DESPUÉS de barks.
function scr_dial_mid_dibujar() {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);
    if (!_c.dial_mid_activo) return;
    if (_c.dial_mid_indice >= array_length(_c.dial_mid_frases)) return;

    var _frase = _c.dial_mid_frases[_c.dial_mid_indice];
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

    // Alpha con fade-in/out
    var _elapsed = DIAL_MID_DURACION - _c.dial_mid_timer;
    var _alpha = 1.0;
    if (_elapsed < DIAL_MID_FADE) {
        _alpha = _elapsed / DIAL_MID_FADE;
    } else if (_c.dial_mid_timer < DIAL_MID_FADE) {
        _alpha = _c.dial_mid_timer / DIAL_MID_FADE;
    }

    // Overlay oscuro
    draw_set_color(c_black);
    draw_set_alpha(0.35 * _alpha);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);

    // Caja de diálogo
    var _box_w = _gw * 0.6;
    var _box_h = 72;
    var _box_x = (_gw - _box_w) * 0.5;
    var _box_y = _gh * 0.75;

    // Fondo caja
    draw_set_color(c_black);
    draw_set_alpha(0.75 * _alpha);
    draw_roundrect(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h, false);
    draw_set_alpha(1);

    // Borde
    var _borde_col = _frase.es_jugador ? make_color_rgb(60, 140, 220) : make_color_rgb(200, 60, 60);
    draw_set_color(_borde_col);
    draw_set_alpha(_alpha);
    draw_roundrect(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h, true);

    // Nombre
    draw_set_font(fnt_1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(_frase.es_jugador ? make_color_rgb(100, 180, 255) : make_color_rgb(255, 120, 100));
    draw_set_alpha(_alpha);
    draw_text(_box_x + 16, _box_y + 8, _frase.nombre);

    // Texto
    draw_set_color(c_white);
    draw_text(_box_x + 16, _box_y + 30, _frase.texto);

    // Indicador [ENTER]
    if (_elapsed > 30) {
        draw_set_halign(fa_right);
        draw_set_color(c_gray);
        var _blink = ((_c.dial_mid_timer div 20) mod 2 == 0) ? 0.7 : 0.3;
        draw_set_alpha(_blink * _alpha);
        draw_text(_box_x + _box_w - 16, _box_y + _box_h - 20, "[ENTER]");
    }

    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}

// ══════════════════════════════════════════════════════════════
//  scr_barks_dibujar()
//  Renderizar el bark activo como texto flotante.
//  Llamar desde Draw_64.
// ══════════════════════════════════════════════════════════════
function scr_barks_dibujar() {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);
    if (!_c.bark_activo) return;

    var _gui_w = display_get_gui_width();

    // Posición según quién habla
    var _bx, _by;
    if (_c.bark_es_jugador) {
        _bx = 200;
        _by = 180 + BARK_Y_OFFSET;
    } else {
        _bx = _gui_w - 200;
        _by = 180 + BARK_Y_OFFSET;
    }

    // Fade-out en los últimos frames
    var _alpha = 1.0;
    if (_c.bark_timer < BARK_FADE_FRAMES) {
        _alpha = clamp(_c.bark_timer / BARK_FADE_FRAMES, 0, 1);
    }

    // Fondo semitransparente (burbuja de diálogo)
    var _tw = string_width(_c.bark_texto) + 20;
    var _th = 28;
    draw_set_alpha(_alpha * 0.6);
    draw_set_color(c_black);
    draw_roundrect_ext(_bx - _tw * 0.5, _by - _th * 0.5, _bx + _tw * 0.5, _by + _th * 0.5, 6, 6, false);
    draw_set_alpha(_alpha);

    // Texto
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(_c.bark_color);
    draw_text(_bx, _by, _c.bark_texto);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
}
