/// STEP — obj_enemy_select

// ESC = volver a selección de personaje
if (keyboard_check_pressed(vk_escape)) {
    room_goto(rm_select);
}

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
            // Utilizamos mezcla total
            enemigos_actuales = enemigos_comunes + enemigos_elite + enemigos_jefe;
        }

        indice_enemigo = 0;
        estado = EnemySelState.LISTA;
    }
}


// ==============================
// ESTADO 2 → LISTA DE ENEMIGOS
// ==============================
else if (estado == EnemySelState.LISTA) {

    if (keyboard_check_pressed(vk_up)) {
        indice_enemigo = (indice_enemigo - 1 + array_length(enemigos_actuales)) mod array_length(enemigos_actuales);
    }

    if (keyboard_check_pressed(vk_down)) {
        indice_enemigo = (indice_enemigo + 1) mod array_length(enemigos_actuales);
    }

    if (keyboard_check_pressed(vk_escape)) {
        estado = EnemySelState.CATEGORIA;
    }

    if (keyboard_check_pressed(vk_enter)) {

        // RANDOM especial
        var sel_cat = categorias[indice_categoria];
        if (sel_cat == "Random") {
            var rand_index = irandom(array_length(enemigos_actuales) - 1);
            control_juego.enemigo_seleccionado = enemigos_actuales[rand_index];
        } else {
            control_juego.enemigo_seleccionado = enemigos_actuales[indice_enemigo];
        }

        estado = EnemySelState.CONFIRMAR;
    }
}


// ==============================
// ESTADO 3 → CONFIRMAR
// ==============================
else if (estado == EnemySelState.CONFIRMAR) {

    if (keyboard_check_pressed(vk_enter)) {
        room_goto(rm_combate);
    }

    if (keyboard_check_pressed(vk_escape)) {
        estado = EnemySelState.LISTA;
    }
}