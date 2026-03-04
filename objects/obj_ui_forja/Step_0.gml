/// STEP — obj_ui_forja

if (keyboard_check_pressed(vk_escape)) {
    if (estado == ForjaState.ARMAS) {
        estado = ForjaState.PERSONAJE; // Retroceder un paso
    } else {
        // Volver al mapa si estamos en modo Camino, sino al menú
        if (instance_exists(obj_control_juego) && variable_struct_exists(obj_control_juego, "modo_camino") && obj_control_juego.modo_camino) {
            scr_transicion_ir(rm_camino);
        } else {
            scr_transicion_ir(rm_menu);
        }
    }
}

// Mensajes
if (mensaje_timer > 0) {
    mensaje_timer--;
    if (mensaje_timer <= 0) mensaje = "";
}

// =========================
// ESTADO 1 — Seleccionar personaje
// =========================
if (estado == ForjaState.PERSONAJE) {

    if (keyboard_check_pressed(vk_up)) {
        indice_personaje = (indice_personaje - 1 + array_length(personajes)) mod array_length(personajes);
    }

    if (keyboard_check_pressed(vk_down)) {
        indice_personaje = (indice_personaje + 1) mod array_length(personajes);
    }

    if (keyboard_check_pressed(vk_enter)) {
        personaje_objetivo = personajes[indice_personaje];
        
        // --- Generar lista de armas forjables desde el catálogo completo ---
        armas_forjables = [];
        var lista_armas = scr_lista_armas_disponibles();

        for (var i = 0; i < array_length(lista_armas); i++) {
            var arma = lista_armas[i];
            var datos = scr_datos_armas(arma);
            if (is_array(datos.receta) && array_length(datos.receta) > 0) {
                array_push(armas_forjables, arma);
            }
        }
        
        indice_arma = 0;
        estado = ForjaState.ARMAS;
    }
}

// =========================
// ESTADO 2 — Lista de armas
// =========================
else if (estado == ForjaState.ARMAS) {

    // Verificación de seguridad por si no hay armas forjables
    if (array_length(armas_forjables) == 0) {
        mensaje = "Este personaje no tiene armas disponibles.";
        estado = ForjaState.PERSONAJE;
        exit;
    }

    if (keyboard_check_pressed(vk_up)) {
        indice_arma = (indice_arma - 1 + array_length(armas_forjables)) mod array_length(armas_forjables);
    }

    if (keyboard_check_pressed(vk_down)) {
        indice_arma = (indice_arma + 1) mod array_length(armas_forjables);
    }

    if (keyboard_check_pressed(vk_enter)) {
        var arma_sel = armas_forjables[indice_arma];

        // Intentar fabricar (pasando el personaje objetivo para que se le asigne el arma)
        if (scr_fabricar_arma(control_juego, arma_sel, personaje_objetivo)) {
            mensaje = "¡Has forjado " + arma_sel + " para " + personaje_objetivo + "!";
        } else {
            mensaje = "No tienes materiales suficientes.";
        }

        mensaje_timer = GAME_FPS * 2;
    }
}