/// STEP — obj_control_ui_combate

if (!instance_exists(control_combate)) exit;

// ── PAUSA (Espacio) ──
if (keyboard_check_pressed(vk_space)) {
    if (!control_combate.combate_terminado) {
        pausado = !pausado;
        pausa_opcion = 0;
        io_clear();
    }
}

// Navegación del menú de pausa
if (pausado) {
    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_down)) {
        pausa_opcion = 1 - pausa_opcion; // alternar entre 0 y 1
    }
    if (keyboard_check_pressed(vk_enter)) {
        if (pausa_opcion == 0) {
            // Reanudar
            pausado = false;
        } else {
            // Salir al menú
            pausado = false;

            // Si estamos en modo torre, resetear el controlador
            if (instance_exists(obj_control_torre)
                && instance_exists(obj_control_juego)
                && variable_struct_exists(obj_control_juego, "modo_torre")
                && obj_control_juego.modo_torre) {
                with (obj_control_torre) {
                    scr_torre_finalizar("abandono_pausa");
                }
            } else {
                room_goto(rm_menu);
            }
        }
    }
}
