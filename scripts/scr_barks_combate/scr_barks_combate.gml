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

    // ── Auto-trigger: chequear HP al 50% ──
    var _pj = _c.personaje_jugador;
    var _en = _c.personaje_enemigo;

    // Jugador baja al 50%
    if (!_c.bark_vida50_pj && _pj.vida_actual <= _pj.vida_max * 0.5 && _pj.vida_actual > 0) {
        _c.bark_vida50_pj = true;
        scr_bark_mostrar(true, scr_bark_frase_vida50(_pj, true), c_yellow);
    }

    // Enemigo baja al 50%
    if (!_c.bark_vida50_en && _en.vida_actual <= _en.vida_max * 0.5 && _en.vida_actual > 0) {
        _c.bark_vida50_en = true;
        scr_bark_mostrar(false, scr_bark_frase_vida50(_en, false), c_red);
    }
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
