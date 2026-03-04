/// STEP - obj_menu

// Toggle guía de controles con H
if (keyboard_check_pressed(ord("H"))) {
    mostrar_guia = !mostrar_guia;
}

// Click en icono "?" para toggle
if (mouse_check_button_pressed(mb_left)) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _ix = _gw - guia_ico_margin - guia_ico_size;
    var _iy = _gh - guia_ico_margin - guia_ico_size;
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    if (_mx >= _ix && _mx <= _ix + guia_ico_size && _my >= _iy && _my <= _iy + guia_ico_size) {
        mostrar_guia = !mostrar_guia;
    }
}

// Animar apertura/cierre de la guía
if (mostrar_guia) {
    guia_anim = min(1, guia_anim + guia_anim_vel);
} else {
    guia_anim = max(0, guia_anim - guia_anim_vel);
}

// Navegar con arriba/abajo
if (keyboard_check_pressed(vk_up)) {
    opcion = max(0, opcion - 1);
}

if (keyboard_check_pressed(vk_down)) {
    opcion = min(array_length(opciones) - 1, opcion + 1);
}

// Confirmar con Enter
if (keyboard_check_pressed(vk_enter)) {

    switch (opcion) {

        case 0:
            scr_transicion_ir(rm_camino);
        break;

        case 1:
            scr_transicion_ir(rm_select);
        break;

        case 2:
            scr_transicion_ir(rm_torre);
        break;

        case 3:
            scr_transicion_ir(rm_forja);
        break;

        case 4:
            scr_transicion_ir(rm_tienda);
        break;
    }
}