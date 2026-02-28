/// STEP - obj_menu

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
            room_goto(rm_select);
        break;

        case 1:
            room_goto(rm_forja);
        break;

        case 2:
            room_goto(rm_tienda);
        break;
    }
}