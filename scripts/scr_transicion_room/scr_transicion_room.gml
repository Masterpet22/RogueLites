/// @file scr_transicion_room.gml
/// @description  Sistema de transiciones animadas entre rooms.
///   - Múltiples tipos: barras horizontales, iris circular, diagonal wipe
///   - Se selecciona un tipo al azar en cada transición
///   - Controlado por flag FX_TRANSICIONES_ON
///   - Velocidad configurable con FX_TRANSICION_VEL
///
///   USO: En lugar de room_goto(rm_X), llamar:
///     scr_transicion_ir(rm_X);
///
///   El sistema se auto-gestiona en Step y Draw GUI
///   de obj_control_juego (persistente).

// ══════════════════════════════════════════════════════════════
//  MACROS DE TRANSICIONES
// ══════════════════════════════════════════════════════════════
#macro TRANS_BARRAS_NUM      10     // cantidad de barras horizontales
#macro TRANS_DURACION        35     // frames que dura cada fase (out/in)
#macro TRANS_PAUSA_FRAMES    8      // frames de pausa con pantalla cubierta

// ══════════════════════════════════════════════════════════════
//  ESTADO DE TRANSICIÓN (almacenado en obj_control_juego)
// ══════════════════════════════════════════════════════════════

/// @function scr_transicion_init()
/// @description Inicializar variables de transición. Llamar en Create de obj_control_juego.
function scr_transicion_init() {
    if (!instance_exists(obj_control_juego)) return;
    var _g = instance_find(obj_control_juego, 0);

    _g.trans_activa     = false;    // ¿transición en curso?
    _g.trans_fase       = "none";   // "anim_out"|"pausa"|"cambiar"|"anim_in"|"none"
    _g.trans_progreso   = 0;        // progreso actual 0..1
    _g.trans_room_dest  = -1;       // room destino
    _g.trans_vel        = FX_TRANSICION_VEL;
    _g.trans_tipo       = 0;        // 0=barras, 1=iris, 2=diagonal
    _g.trans_pausa_timer = 0;       // timer de pausa entre fases
    _g.trans_surface    = -1;       // surface para iris
    _g.trans_color      = c_black;  // color base de la transición
}


/// @function scr_transicion_ir(room_destino)
/// @description Inicia transición animada hacia otra room.
///   Si FX_TRANSICIONES_ON es false, hace room_goto directo.
/// @param {Asset.GMRoom} _room_dest
function scr_transicion_ir(_room_dest) {
    // Sin transiciones → cambio directo
    if (!FX_TRANSICIONES_ON) {
        room_goto(_room_dest);
        return;
    }

    if (!instance_exists(obj_control_juego)) {
        room_goto(_room_dest);
        return;
    }

    var _g = instance_find(obj_control_juego, 0);

    // Si ya hay una transición en curso, ignorar
    if (_g.trans_activa) return;

    _g.trans_activa      = true;
    _g.trans_fase        = "anim_out";
    _g.trans_progreso    = 0;
    _g.trans_room_dest   = _room_dest;
    _g.trans_vel         = 1 / TRANS_DURACION;  // completar en TRANS_DURACION frames
    _g.trans_pausa_timer = 0;

    // Elegir tipo de transición al azar
    _g.trans_tipo = irandom(2);  // 0=barras, 1=iris, 2=diagonal

    // Color aleatorio sutil (oscuro) para variedad — amplia paleta de tonos oscuros
    var _cols = [
        c_black,
        make_color_rgb(15, 10, 25),   // púrpura oscuro
        make_color_rgb(20, 12, 8),    // marrón oscuro
        make_color_rgb(8, 15, 20),    // azul noche
        make_color_rgb(18, 8, 8),     // rojo sangre oscuro
        make_color_rgb(6, 18, 12),    // verde bosque oscuro
        make_color_rgb(12, 10, 22),   // índigo profundo
        make_color_rgb(20, 18, 8),    // bronce oscuro
        make_color_rgb(10, 5, 18),    // violeta abisal
        make_color_rgb(5, 12, 18),    // cian medianoche
    ];
    _g.trans_color = _cols[irandom(array_length(_cols) - 1)];
}


/// @function scr_transicion_actualizar()
/// @description Actualizar transición cada frame. Llamar en Step de obj_control_juego.
function scr_transicion_actualizar() {
    if (!instance_exists(obj_control_juego)) return;
    var _g = instance_find(obj_control_juego, 0);

    if (!_g.trans_activa) return;

    switch (_g.trans_fase) {
        case "anim_out":
            // Animación de salida (cubrir pantalla)
            _g.trans_progreso += _g.trans_vel;
            if (_g.trans_progreso >= 1.0) {
                _g.trans_progreso = 1.0;
                _g.trans_fase = "pausa";
                _g.trans_pausa_timer = TRANS_PAUSA_FRAMES;
            }
            break;

        case "pausa":
            // Breve pausa con pantalla cubierta
            _g.trans_pausa_timer -= 1;
            if (_g.trans_pausa_timer <= 0) {
                _g.trans_fase = "cambiar";
            }
            break;

        case "cambiar":
            // Cambio de room — pantalla cubierta
            room_goto(_g.trans_room_dest);
            _g.trans_fase = "anim_in";
            break;

        case "anim_in":
            // Animación de entrada (descubrir pantalla)
            _g.trans_progreso -= _g.trans_vel;
            if (_g.trans_progreso <= 0) {
                _g.trans_progreso = 0;
                _g.trans_fase = "none";
                _g.trans_activa = false;
                // Liberar surface si existe
                if (surface_exists(_g.trans_surface)) {
                    surface_free(_g.trans_surface);
                    _g.trans_surface = -1;
                }
            }
            break;
    }
}


/// @function scr_transicion_dibujar()
/// @description Dibujar transición animada. Llamar como ÚLTIMA capa en Draw GUI.
function scr_transicion_dibujar() {
    if (!instance_exists(obj_control_juego)) return;
    var _g = instance_find(obj_control_juego, 0);

    if (!_g.trans_activa && _g.trans_progreso <= 0) return;

    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _p  = _g.trans_progreso;

    // Ease in-out para movimiento más suave
    var _t = _p * _p * (3 - 2 * _p);  // smoothstep

    switch (_g.trans_tipo) {
        case 0:
            _scr_trans_dibujar_barras(_gw, _gh, _t, _g.trans_color);
            break;
        case 1:
            _scr_trans_dibujar_iris(_gw, _gh, _t, _g.trans_color, _g);
            break;
        case 2:
            _scr_trans_dibujar_diagonal(_gw, _gh, _t, _g.trans_color);
            break;
    }
}


// ══════════════════════════════════════════════════════════════
//  TIPO 0: BARRAS HORIZONTALES
//  Barras que entran desde lados alternados (izquierda/derecha)
// ══════════════════════════════════════════════════════════════
/// @function _scr_trans_dibujar_barras(gw, gh, t, col)
function _scr_trans_dibujar_barras(_gw, _gh, _t, _col) {
    var _n = TRANS_BARRAS_NUM;
    var _bar_h = ceil(_gh / _n) + 1;

    draw_set_color(_col);
    draw_set_alpha(1);

    for (var i = 0; i < _n; i++) {
        var _y1 = i * (_gh / _n);
        var _y2 = _y1 + _bar_h;

        // Cada barra entra con un ligero desfase (stagger reducido)
        var _stagger = i / _n * 0.20;
        var _local_t = clamp((_t - _stagger) / (1 - _stagger), 0, 1);

        // Dirección alternada
        var _from_left = (i mod 2 == 0);
        var _x1, _x2;

        if (_from_left) {
            // La barra cubre todo su ancho cuando local_t >= 0.5
            _x1 = lerp(-_gw, 0, clamp(_local_t * 2, 0, 1));
            _x2 = _x1 + _gw;
        } else {
            _x2 = lerp(_gw * 2, _gw, clamp(_local_t * 2, 0, 1));
            _x1 = _x2 - _gw;
        }

        // Clamp al área visible
        _x1 = max(0, _x1);
        _x2 = min(_gw, _x2);

        if (_x2 > _x1) {
            draw_rectangle(_x1, _y1, _x2, _y2, false);
        }
    }

    draw_set_color(c_white);
}


// ══════════════════════════════════════════════════════════════
//  TIPO 1: IRIS CIRCULAR
//  Círculo que se cierra al centro / se abre desde el centro
//  Usa surface para recortar el agujero circular.
// ══════════════════════════════════════════════════════════════
/// @function _scr_trans_dibujar_iris(gw, gh, t, col, g)
function _scr_trans_dibujar_iris(_gw, _gh, _t, _col, _g) {
    // Radio máximo = diagonal de la pantalla
    var _r_max = sqrt(_gw * _gw + _gh * _gh) * 0.55;
    // Radio del agujero: de r_max (t=0, todo visible) a 0 (t=1, todo cubierto)
    var _r = _r_max * (1 - _t);

    var _cx = _gw * 0.5;
    var _cy = _gh * 0.5;

    // Crear/recrear surface
    if (!surface_exists(_g.trans_surface)) {
        _g.trans_surface = surface_create(_gw, _gh);
    }

    surface_set_target(_g.trans_surface);
    draw_clear_alpha(c_black, 0);

    // Dibujar el overlay de color (cubre todo)
    draw_set_color(_col);
    draw_set_alpha(1);
    draw_rectangle(0, 0, _gw, _gh, false);

    // Recortar un círculo (borrar píxeles en el centro)
    if (_r > 1) {
        gpu_set_blendmode_ext(bm_zero, bm_zero);
        draw_circle(_cx, _cy, _r, false);
        gpu_set_blendmode(bm_normal);
    }

    surface_reset_target();

    // Dibujar surface al GUI
    draw_surface(_g.trans_surface, 0, 0);
    draw_set_color(c_white);
}


// ══════════════════════════════════════════════════════════════
//  TIPO 2: BARRIDO DIAGONAL
//  Franja diagonal que barre de esquina a esquina.
// ══════════════════════════════════════════════════════════════
/// @function _scr_trans_dibujar_diagonal(gw, gh, t, col)
function _scr_trans_dibujar_diagonal(_gw, _gh, _t, _col) {
    // El barrido va de arriba-izquierda a abajo-derecha
    var _diag = _gw + _gh;

    // Posición del borde diagonal
    var _borde = _t * (_diag + _gw * 0.3);

    draw_set_color(_col);
    draw_set_alpha(1);

    // Dibujar líneas horizontales con el corte diagonal
    var _paso = 3;
    for (var _y = 0; _y < _gh; _y += _paso) {
        // Para cada línea Y, el corte se desplaza
        var _corte = _borde - _y;

        if (_corte > 0) {
            var _x_fin = min(_corte, _gw);
            draw_rectangle(0, _y, _x_fin, _y + _paso, false);
        }
    }

    draw_set_color(c_white);
    draw_set_alpha(1);
}


/// @function scr_transicion_bloqueando()
/// @description Retorna true si hay una transición en curso (bloquear input).
/// @returns {bool}
function scr_transicion_bloqueando() {
    if (!instance_exists(obj_control_juego)) return false;
    var _g = instance_find(obj_control_juego, 0);
    return _g.trans_activa;
}
