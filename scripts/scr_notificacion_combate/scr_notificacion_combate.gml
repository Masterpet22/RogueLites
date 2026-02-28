/// @function scr_notif_agregar(quien, texto, color)
/// @description  Agrega una notificación de acción al sistema.
///   Máximo 2 visibles; si ya hay 2, la más vieja se elimina.
///   Cada notificación dura NOTIF_DURACION frames (2 s).
///
/// @param {string} _quien   Nombre del actor ("Kael", "Soldado Igneo", etc.)
/// @param {string} _texto   Descripción de la acción ("usa Golpe Ígneo", etc.)
/// @param {real}   _color   Color de la notificación (c_lime para jugador, c_red para enemigo)
function scr_notif_agregar(_quien, _texto, _color) {

    // Referencia al array global de notificaciones (vive en obj_control_combate)
    if (!instance_exists(obj_control_combate)) return;
    var _ctrl = instance_find(obj_control_combate, 0);

    // Crear entrada
    var _notif = {
        quien:   _quien,
        texto:   _texto,
        color:   _color,
        timer:   NOTIF_DURACION,      // frames restantes
        alpha:   1.0,                 // para fade-out
    };

    // Agregar al final
    array_push(_ctrl.notificaciones, _notif);

    // Si hay más de 2, eliminar la más vieja
    while (array_length(_ctrl.notificaciones) > NOTIF_MAX) {
        array_delete(_ctrl.notificaciones, 0, 1);
    }
}


/// @function scr_notif_actualizar()
/// @description  Actualizar timers de notificaciones. Llamar 1 vez por frame.
function scr_notif_actualizar() {

    if (!instance_exists(obj_control_combate)) return;
    var _ctrl = instance_find(obj_control_combate, 0);
    var _arr  = _ctrl.notificaciones;

    for (var i = array_length(_arr) - 1; i >= 0; i--) {
        _arr[i].timer -= 1;

        // Fade-out en el último 25% de vida
        var _fade_start = NOTIF_DURACION * 0.25;
        if (_arr[i].timer < _fade_start) {
            _arr[i].alpha = clamp(_arr[i].timer / _fade_start, 0, 1);
        }

        // Eliminar cuando expira
        if (_arr[i].timer <= 0) {
            array_delete(_arr, i, 1);
        }
    }
}


/// @function scr_notif_dibujar()
/// @description  Dibuja las notificaciones activas en pantalla.
///   Posición: centro-derecha de la pantalla, apiladas verticalmente.
function scr_notif_dibujar() {

    if (!instance_exists(obj_control_combate)) return;
    var _ctrl = instance_find(obj_control_combate, 0);
    var _arr  = _ctrl.notificaciones;

    if (array_length(_arr) == 0) return;

    var _w_gui = display_get_gui_width();
    var _h_gui = display_get_gui_height();

    // Posición base: centro de pantalla, ligeramente arriba
    var _base_x = _w_gui * 0.5;
    var _base_y = _h_gui * 0.35;

    var _box_w = 320;
    var _box_h = 32;
    var _gap   = 6;

    draw_set_font(fnt_1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    for (var i = 0; i < array_length(_arr); i++) {
        var _n = _arr[i];

        var _nx = _base_x;
        var _ny = _base_y + i * (_box_h + _gap);

        // Fondo semi-transparente
        draw_set_alpha(_n.alpha * 0.75);
        draw_set_color(c_black);
        draw_rectangle(_nx - _box_w/2, _ny - _box_h/2,
                        _nx + _box_w/2, _ny + _box_h/2, false);

        // Borde del color del actor
        draw_set_alpha(_n.alpha);
        draw_set_color(_n.color);
        draw_rectangle(_nx - _box_w/2, _ny - _box_h/2,
                        _nx + _box_w/2, _ny + _box_h/2, true);

        // Texto: "Nombre: acción"
        draw_set_color(_n.color);
        draw_text(_nx, _ny, _n.quien + ": " + _n.texto);
    }

    // Restaurar
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
