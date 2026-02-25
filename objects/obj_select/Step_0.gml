/// STEP — obj_select

// Seguridad
if (!instance_exists(control_juego)) exit;

// Perfil actual según índice
perfil = control_juego.perfiles_personaje[? personajes[indice_personaje]];

// =========================
// ESTADO: SELECCIONAR PERSONAJE
// =========================
if (estado == SelState.PERSONAJE) {

    if (keyboard_check_pressed(vk_up)) {
        indice_personaje = (indice_personaje - 1 + array_length(personajes)) mod array_length(personajes);
    }

    if (keyboard_check_pressed(vk_down)) {
        indice_personaje = (indice_personaje + 1) mod array_length(personajes);
    }

    if (keyboard_check_pressed(vk_enter)) {
        // Entrar al popup de armas
        var armas = scr_ds_map_keys_array(perfil.armas_obtenidas);
        indice_arma = 0;
        estado = SelState.ARMA_POPUP;
		io_clear();
        
        // OPCIONAL: io_clear(); // Limpia el estado de las teclas para este frame
    }

    if (keyboard_check_pressed(vk_escape)) {
        room_goto(rm_menu);
    }
}
// AGREGAMOS "ELSE" AQUÍ PARA EVITAR LA CASCADA
else if (estado == SelState.ARMA_POPUP) {

    var armas = scr_ds_map_keys_array(perfil.armas_obtenidas);

    if (array_length(armas) == 0) {
        estado = SelState.PERSONAJE;
        exit;
    }

    if (keyboard_check_pressed(vk_up)) {
        indice_arma = (indice_arma - 1 + array_length(armas)) mod array_length(armas);
    }

    if (keyboard_check_pressed(vk_down)) {
        indice_arma = (indice_arma + 1) mod array_length(armas);
    }

    if (keyboard_check_pressed(vk_escape)) {
        estado = SelState.PERSONAJE;
    }

    if (keyboard_check_pressed(vk_enter)) {
        var arma = armas[indice_arma];
        perfil.arma_equipada = arma;
        control_juego.personaje_seleccionado = personajes[indice_personaje];

       room_goto(rm_enemy_select);
    }
}