/// STEP — obj_enemy_select

// ==============================
// ESTADO 1 → ELEGIR CATEGORÍA
// ==============================
if (estado == EnemySelState.CATEGORIA) {

    if (keyboard_check_pressed(vk_up)) {
        indice_categoria = (indice_categoria - 1 + array_length(categorias)) mod array_length(categorias);
    }

    if (keyboard_check_pressed(vk_down)) {
        indice_categoria = (indice_categoria + 1) mod array_length(categorias);
    }

    // ESC en categoría → volver a selección de personaje
    if (keyboard_check_pressed(vk_escape)) {
        scr_transicion_ir(rm_select);
    }

    if (keyboard_check_pressed(vk_enter)) {

        var sel = categorias[indice_categoria];

        if (sel == "Común") {
            enemigos_actuales = enemigos_comunes;
        }
        else if (sel == "Élite") {
            enemigos_actuales = enemigos_elite;
        }
        else if (sel == "Jefe") {
            enemigos_actuales = enemigos_jefe;
        }
        else if (sel == "Random") {
            // Construir pool combinado solo con categorías que tengan enemigos
            var _pool_total = [];
            for (var _ri = 0; _ri < array_length(enemigos_comunes); _ri++) array_push(_pool_total, enemigos_comunes[_ri]);
            for (var _ri = 0; _ri < array_length(enemigos_elite); _ri++)  array_push(_pool_total, enemigos_elite[_ri]);
            for (var _ri = 0; _ri < array_length(enemigos_jefe); _ri++)   array_push(_pool_total, enemigos_jefe[_ri]);

            if (array_length(_pool_total) == 0) exit;

            control_juego.enemigo_seleccionado = _pool_total[irandom(array_length(_pool_total) - 1)];
            estado = EnemySelState.CONFIRMAR;
            io_clear();
            exit;
        }

        // Si la categoría está vacía, no avanzar
        if (array_length(enemigos_actuales) == 0) {
            exit;
        }

        indice_enemigo = 0;
        estado = EnemySelState.LISTA;
    }
}


// ==============================
// ESTADO 2 → LISTA DE ENEMIGOS
// ==============================
else if (estado == EnemySelState.LISTA) {

    var _len = array_length(enemigos_actuales);
    if (_len == 0) {
        estado = EnemySelState.CATEGORIA;
        exit;
    }

    if (keyboard_check_pressed(vk_up)) {
        indice_enemigo = (indice_enemigo - 1 + _len) mod _len;
    }

    if (keyboard_check_pressed(vk_down)) {
        indice_enemigo = (indice_enemigo + 1) mod _len;
    }

    if (keyboard_check_pressed(vk_escape)) {
        estado = EnemySelState.CATEGORIA;
    }

    if (keyboard_check_pressed(vk_enter)) {
        control_juego.enemigo_seleccionado = enemigos_actuales[indice_enemigo];
        estado = EnemySelState.CONFIRMAR;
    }
}


// ==============================
// ESTADO 3 → CONFIRMAR
// ==============================
else if (estado == EnemySelState.CONFIRMAR) {

    if (keyboard_check_pressed(vk_enter)) {
        scr_transicion_ir(rm_combate);
    }

    if (keyboard_check_pressed(vk_escape)) {
        estado = EnemySelState.LISTA;
    }
}