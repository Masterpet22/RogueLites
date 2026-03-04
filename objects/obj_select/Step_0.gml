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
        scr_transicion_ir(rm_menu);
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

        // Preparar lista de objetos disponibles (que el jugador posea cantidad > 0)
        objetos_disponibles = [];
        var _todos = scr_lista_objetos_disponibles();
        for (var i = 0; i < array_length(_todos); i++) {
            var _cant = scr_inventario_get_objeto(control_juego, _todos[i]);
            if (_cant > 0) {
                array_push(objetos_disponibles, _todos[i]);
            }
        }

        objetos_seleccionados = [];
        indice_objeto = 0;

        // Si no tiene objetos, saltar a runas o enemigo
        if (array_length(objetos_disponibles) == 0) {
            control_juego.objetos_para_combate = [];

            // Preparar lista de runas disponibles
            runas_disponibles = [];
            var _todas_runas = scr_lista_runicos_disponibles();
            for (var i = 0; i < array_length(_todas_runas); i++) {
                var _cant = scr_inventario_get_objeto(control_juego, _todas_runas[i]);
                if (_cant > 0) {
                    array_push(runas_disponibles, _todas_runas[i]);
                }
            }
            runa_seleccionada = "";
            indice_runa = 0;

            if (array_length(runas_disponibles) == 0) {
                control_juego.runa_equipada = "";
                scr_transicion_ir(rm_enemy_select);
            } else {
                estado = SelState.RUNA_POPUP;
                io_clear();
            }
        } else {
            estado = SelState.OBJETOS_POPUP;
            io_clear();
        }
    }
}

// =========================
// ESTADO: SELECCIONAR OBJETOS
// =========================
else if (estado == SelState.OBJETOS_POPUP) {

    var n_obj = array_length(objetos_disponibles);

    // Navegar con flechas
    if (keyboard_check_pressed(vk_up)) {
        indice_objeto = (indice_objeto - 1 + n_obj) mod n_obj;
    }
    if (keyboard_check_pressed(vk_down)) {
        indice_objeto = (indice_objeto + 1) mod n_obj;
    }

    // TAB: alternar selección del objeto actual
    if (keyboard_check_pressed(vk_tab)) {
        var _obj_nombre = objetos_disponibles[indice_objeto];

        // Contar cuántas veces ya está seleccionado este objeto
        var _veces_sel = 0;
        for (var i = 0; i < array_length(objetos_seleccionados); i++) {
            if (objetos_seleccionados[i] == _obj_nombre) _veces_sel++;
        }

        var _cant_inv = scr_inventario_get_objeto(control_juego, _obj_nombre);

        // Si aún cabe (total < 3) y tiene inventario disponible → agregar
        if (array_length(objetos_seleccionados) < 3 && _veces_sel < _cant_inv) {
            array_push(objetos_seleccionados, _obj_nombre);
        }
        // Si ya está al máximo de inventario para este objeto → quitar uno
        else if (_veces_sel > 0) {
            // Buscar la última ocurrencia y eliminarla
            for (var i = array_length(objetos_seleccionados) - 1; i >= 0; i--) {
                if (objetos_seleccionados[i] == _obj_nombre) {
                    array_delete(objetos_seleccionados, i, 1);
                    break;
                }
            }
        }
    }

    // ENTER: confirmar y pasar a seleccionar runa
    if (keyboard_check_pressed(vk_enter)) {
        // Guardar objetos seleccionados en control_juego para que combate los lea
        control_juego.objetos_para_combate = [];
        array_copy(control_juego.objetos_para_combate, 0, objetos_seleccionados, 0, array_length(objetos_seleccionados));

        // Preparar lista de runas disponibles
        runas_disponibles = [];
        var _todas_runas = scr_lista_runicos_disponibles();
        for (var i = 0; i < array_length(_todas_runas); i++) {
            var _cant = scr_inventario_get_objeto(control_juego, _todas_runas[i]);
            if (_cant > 0) {
                array_push(runas_disponibles, _todas_runas[i]);
            }
        }

        runa_seleccionada = "";
        indice_runa = 0;

        // Si no tiene runas, ir directo a seleccionar enemigo
        if (array_length(runas_disponibles) == 0) {
            control_juego.runa_equipada = "";
            scr_transicion_ir(rm_enemy_select);
        } else {
            estado = SelState.RUNA_POPUP;
            io_clear();
        }
    }

    // ESC: volver a selección de arma sin equipar objetos
    if (keyboard_check_pressed(vk_escape)) {
        objetos_seleccionados = [];
        estado = SelState.ARMA_POPUP;
    }
}

// =========================
// ESTADO: SELECCIONAR RUNA
// =========================
else if (estado == SelState.RUNA_POPUP) {

    var n_runas = array_length(runas_disponibles);

    // Navegar con flechas
    if (keyboard_check_pressed(vk_up)) {
        indice_runa = (indice_runa - 1 + (n_runas + 1)) mod (n_runas + 1);
    }
    if (keyboard_check_pressed(vk_down)) {
        indice_runa = (indice_runa + 1) mod (n_runas + 1);
    }

    // ENTER: confirmar y pasar a seleccionar enemigo
    if (keyboard_check_pressed(vk_enter)) {
        if (indice_runa < n_runas) {
            runa_seleccionada = runas_disponibles[indice_runa];
        } else {
            runa_seleccionada = ""; // Opción "Sin runa"
        }
        control_juego.runa_equipada = runa_seleccionada;
        scr_transicion_ir(rm_enemy_select);
    }

    // ESC: volver a objetos
    if (keyboard_check_pressed(vk_escape)) {
        runa_seleccionada = "";
        estado = SelState.OBJETOS_POPUP;
    }
}