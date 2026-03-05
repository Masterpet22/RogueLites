/// STEP — obj_enemy_select

// ── Toggle guía de ayuda (H) ──
if (keyboard_check_pressed(ord("H"))) {
    mostrar_guia = !mostrar_guia;
}
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _ix = _gw - guia_ico_margin - guia_ico_size;
var _iy = _gh - guia_ico_margin - guia_ico_size;
if (mouse_check_button_pressed(mb_left)) {
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    if (_mx >= _ix && _mx <= _ix + guia_ico_size && _my >= _iy && _my <= _iy + guia_ico_size) {
        mostrar_guia = !mostrar_guia;
    }
}
// Animar panel
guia_anim = lerp(guia_anim, mostrar_guia ? 1 : 0, guia_anim_vel);
if (!mostrar_guia && guia_anim < 0.01) guia_anim = 0;

// ==============================
// ESTADO 1 → ELEGIR CATEGORÍA (tabs horizontales)
// ==============================
if (estado == EnemySelState.CATEGORIA) {

    if (keyboard_check_pressed(vk_left)) {
        indice_categoria = (indice_categoria - 1 + array_length(categorias)) mod array_length(categorias);
    }

    if (keyboard_check_pressed(vk_right)) {
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
            var _pool_total = [];
            for (var _ri = 0; _ri < array_length(enemigos_comunes); _ri++) array_push(_pool_total, enemigos_comunes[_ri]);
            for (var _ri = 0; _ri < array_length(enemigos_elite); _ri++)  array_push(_pool_total, enemigos_elite[_ri]);
            for (var _ri = 0; _ri < array_length(enemigos_jefe); _ri++)   array_push(_pool_total, enemigos_jefe[_ri]);

            if (array_length(_pool_total) == 0) exit;

            control_juego.enemigo_seleccionado = _pool_total[irandom(array_length(_pool_total) - 1)];
            scr_transicion_ir(rm_combate);
            io_clear();
            exit;
        }

        if (array_length(enemigos_actuales) == 0) {
            exit;
        }

        indice_enemigo = 0;
        estado = EnemySelState.LISTA;
    }
}


// ==============================
// ESTADO 2 → GRID DE ENEMIGOS
// ==============================
else if (estado == EnemySelState.LISTA) {

    var _len = array_length(enemigos_actuales);
    if (_len == 0) {
        estado = EnemySelState.CATEGORIA;
        exit;
    }

    if (keyboard_check_pressed(vk_left)) {
        indice_enemigo = max(0, indice_enemigo - 1);
    }
    if (keyboard_check_pressed(vk_right)) {
        indice_enemigo = min(_len - 1, indice_enemigo + 1);
    }
    if (keyboard_check_pressed(vk_up)) {
        indice_enemigo = max(0, indice_enemigo - sel_cols);
    }
    if (keyboard_check_pressed(vk_down)) {
        indice_enemigo = min(_len - 1, indice_enemigo + sel_cols);
    }

    if (keyboard_check_pressed(vk_escape)) {
        estado = EnemySelState.CATEGORIA;
    }

    if (keyboard_check_pressed(vk_enter)) {
        control_juego.enemigo_seleccionado = enemigos_actuales[indice_enemigo];
        scr_transicion_ir(rm_combate);
    }
}