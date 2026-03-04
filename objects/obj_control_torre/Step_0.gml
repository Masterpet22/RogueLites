/// STEP — obj_control_torre

// No procesar input durante el combate (rm_combate tiene su propio controlador)
// Pero si estamos en rm_torre con fase "combate", algo fue mal → resetear
if (torre_fase == "combate") {
    if (room == rm_torre) {
        torre_fase = "seleccion_ala";
        show_debug_message("⚠ Torre: fase 'combate' detectada en rm_torre — reseteando a seleccion_ala");
    } else {
        exit;
    }
}

// Solo procesar input en rm_torre
if (room != rm_torre) exit;

var control_juego = instance_find(obj_control_juego, 0);
if (!instance_exists(control_juego)) exit;

// ═══════════════════════════════════════════
//  FASE: SELECCIÓN DE ALA
// ═══════════════════════════════════════════
if (torre_fase == "seleccion_ala") {

    var _alas = scr_torre_get_alas();
    var _n = array_length(_alas);

    if (keyboard_check_pressed(vk_up))    sel_ala_indice = (sel_ala_indice - 1 + _n) mod _n;
    if (keyboard_check_pressed(vk_down))  sel_ala_indice = (sel_ala_indice + 1) mod _n;

    if (keyboard_check_pressed(vk_enter)) {
        torre_ala = _alas[sel_ala_indice];
        torre_fase = "seleccion_dificultad";
        sel_dif_indice = 0;
        io_clear();
    }

    if (keyboard_check_pressed(vk_escape)) {
        scr_transicion_ir(rm_menu);
    }
}

// ═══════════════════════════════════════════
//  FASE: SELECCIÓN DE DIFICULTAD
// ═══════════════════════════════════════════
else if (torre_fase == "seleccion_dificultad") {

    var _difs = scr_torre_get_dificultades();
    var _n = array_length(_difs);

    if (keyboard_check_pressed(vk_up))    sel_dif_indice = (sel_dif_indice - 1 + _n) mod _n;
    if (keyboard_check_pressed(vk_down))  sel_dif_indice = (sel_dif_indice + 1) mod _n;

    if (keyboard_check_pressed(vk_enter)) {
        torre_dificultad = _difs[sel_dif_indice];
        torre_pisos_total = torre_dificultad.pisos_total;
        torre_fase = "seleccion_personaje";
        sel_pj_indice = 0;
        io_clear();
    }

    if (keyboard_check_pressed(vk_escape)) {
        torre_fase = "seleccion_ala";
        io_clear();
    }
}

// ═══════════════════════════════════════════
//  FASE: SELECCIÓN DE PERSONAJE
// ═══════════════════════════════════════════
else if (torre_fase == "seleccion_personaje") {

    // Obtener lista de personajes disponibles (desbloqueados)
    var _nombres = scr_ds_map_keys_array(control_juego.perfiles_personaje);
    var _n = array_length(_nombres);

    if (keyboard_check_pressed(vk_up))    sel_pj_indice = (sel_pj_indice - 1 + _n) mod _n;
    if (keyboard_check_pressed(vk_down))  sel_pj_indice = (sel_pj_indice + 1) mod _n;

    if (keyboard_check_pressed(vk_enter)) {
        var _nombre = _nombres[sel_pj_indice];
        var _perfil = control_juego.perfiles_personaje[? _nombre];

        torre_perfil_nombre   = _nombre;
        torre_pj_clase        = _perfil.clase;
        torre_pj_afinidad     = _perfil.afinidad;
        torre_pj_personalidad = _perfil.personalidad;

        // Obtener armas disponibles
        torre_armas_disponibles = [];
        var _arma_key = ds_map_find_first(_perfil.armas_obtenidas);
        while (_arma_key != undefined) {
            array_push(torre_armas_disponibles, _arma_key);
            _arma_key = ds_map_find_next(_perfil.armas_obtenidas, _arma_key);
        }

        if (array_length(torre_armas_disponibles) == 1) {
            // Solo tiene un arma, seleccionar automáticamente
            torre_arma = torre_armas_disponibles[0];
            scr_torre_iniciar_run();
        } else {
            torre_fase = "seleccion_arma";
            sel_arma_indice = 0;
        }
        io_clear();
    }

    if (keyboard_check_pressed(vk_escape)) {
        torre_fase = "seleccion_dificultad";
        io_clear();
    }
}

// ═══════════════════════════════════════════
//  FASE: SELECCIÓN DE ARMA
// ═══════════════════════════════════════════
else if (torre_fase == "seleccion_arma") {

    var _n = array_length(torre_armas_disponibles);

    if (keyboard_check_pressed(vk_up))    sel_arma_indice = (sel_arma_indice - 1 + _n) mod _n;
    if (keyboard_check_pressed(vk_down))  sel_arma_indice = (sel_arma_indice + 1) mod _n;

    if (keyboard_check_pressed(vk_enter)) {
        torre_arma = torre_armas_disponibles[sel_arma_indice];
        scr_torre_iniciar_run();
        io_clear();
    }

    if (keyboard_check_pressed(vk_escape)) {
        torre_fase = "seleccion_personaje";
        io_clear();
    }
}

// ═══════════════════════════════════════════
//  FASE: PRE-COMBATE (pantalla entre pisos)
// ═══════════════════════════════════════════
else if (torre_fase == "pre_combate") {

    torre_post_opcion = 0;

    if (keyboard_check_pressed(vk_enter)) {
        // Preparar equipamiento de objetos
        torre_equip_objetos = [];
        torre_equip_runa = "";
        torre_equip_indice = 0;
        torre_equip_runa_indice = 0;

        // Obtener objetos disponibles
        var _cj = instance_find(obj_control_juego, 0);
        torre_equip_obj_disponibles = [];
        var _todos = scr_lista_objetos_disponibles();
        for (var i = 0; i < array_length(_todos); i++) {
            var _cant = scr_inventario_get_objeto(_cj, _todos[i]);
            if (_cant > 0) array_push(torre_equip_obj_disponibles, _todos[i]);
        }

        // Check si tiene objetos
        if (array_length(torre_equip_obj_disponibles) > 0) {
            torre_equip_fase = "objetos";
            torre_fase = "equipar";
        } else {
            // No tiene objetos, check runas
            torre_equip_runas_disponibles = [];
            var _todas_runas = scr_lista_runicos_disponibles();
            for (var i = 0; i < array_length(_todas_runas); i++) {
                var _cant = scr_inventario_get_objeto(_cj, _todas_runas[i]);
                if (_cant > 0) array_push(torre_equip_runas_disponibles, _todas_runas[i]);
            }
            if (array_length(torre_equip_runas_disponibles) > 0) {
                torre_equip_fase = "runa";
                torre_fase = "equipar";
            } else {
                // Sin objetos ni runas, ir directo al combate
                scr_torre_lanzar_combate();
            }
        }
        io_clear();
    }

    if (keyboard_check_pressed(vk_escape)) {
        // Abandonar torre
        scr_torre_finalizar("abandono");
    }
}

// ═══════════════════════════════════════════
//  FASE: EQUIPAR OBJETOS/RUNA PRE-COMBATE
// ═══════════════════════════════════════════
else if (torre_fase == "equipar") {

    var _cj = instance_find(obj_control_juego, 0);

    if (torre_equip_fase == "objetos") {
        var _n = array_length(torre_equip_obj_disponibles);

        if (keyboard_check_pressed(vk_up))   torre_equip_indice = (torre_equip_indice - 1 + _n) mod _n;
        if (keyboard_check_pressed(vk_down)) torre_equip_indice = (torre_equip_indice + 1) mod _n;

        // TAB: alternar selección
        if (keyboard_check_pressed(vk_tab)) {
            var _obj_nom = torre_equip_obj_disponibles[torre_equip_indice];
            var _veces = 0;
            for (var i = 0; i < array_length(torre_equip_objetos); i++) {
                if (torre_equip_objetos[i] == _obj_nom) _veces++;
            }
            var _cant_inv = scr_inventario_get_objeto(_cj, _obj_nom);
            if (array_length(torre_equip_objetos) < 3 && _veces < _cant_inv) {
                array_push(torre_equip_objetos, _obj_nom);
            } else if (_veces > 0) {
                for (var i = array_length(torre_equip_objetos) - 1; i >= 0; i--) {
                    if (torre_equip_objetos[i] == _obj_nom) {
                        array_delete(torre_equip_objetos, i, 1);
                        break;
                    }
                }
            }
        }

        // ENTER: confirmar objetos, pasar a runa
        if (keyboard_check_pressed(vk_enter)) {
            _cj.objetos_para_combate = [];
            array_copy(_cj.objetos_para_combate, 0, torre_equip_objetos, 0, array_length(torre_equip_objetos));

            // Preparar runas
            torre_equip_runas_disponibles = [];
            var _todas_runas = scr_lista_runicos_disponibles();
            for (var i = 0; i < array_length(_todas_runas); i++) {
                var _cant = scr_inventario_get_objeto(_cj, _todas_runas[i]);
                if (_cant > 0) array_push(torre_equip_runas_disponibles, _todas_runas[i]);
            }

            if (array_length(torre_equip_runas_disponibles) > 0) {
                torre_equip_fase = "runa";
                torre_equip_runa_indice = 0;
            } else {
                _cj.runa_equipada = "";
                scr_torre_lanzar_combate();
            }
            io_clear();
        }

        // ESC: skip objetos
        if (keyboard_check_pressed(vk_escape)) {
            torre_equip_objetos = [];
            _cj.objetos_para_combate = [];

            // Ir a runas o directo al combate
            torre_equip_runas_disponibles = [];
            var _todas_runas = scr_lista_runicos_disponibles();
            for (var i = 0; i < array_length(_todas_runas); i++) {
                var _cant = scr_inventario_get_objeto(_cj, _todas_runas[i]);
                if (_cant > 0) array_push(torre_equip_runas_disponibles, _todas_runas[i]);
            }
            if (array_length(torre_equip_runas_disponibles) > 0) {
                torre_equip_fase = "runa";
                torre_equip_runa_indice = 0;
            } else {
                _cj.runa_equipada = "";
                scr_torre_lanzar_combate();
            }
            io_clear();
        }
    }

    else if (torre_equip_fase == "runa") {
        var _n_runas = array_length(torre_equip_runas_disponibles);
        var _total_opts = _n_runas + 1; // +1 for "Sin runa"

        if (keyboard_check_pressed(vk_up))   torre_equip_runa_indice = (torre_equip_runa_indice - 1 + _total_opts) mod _total_opts;
        if (keyboard_check_pressed(vk_down)) torre_equip_runa_indice = (torre_equip_runa_indice + 1) mod _total_opts;

        if (keyboard_check_pressed(vk_enter)) {
            if (torre_equip_runa_indice < _n_runas) {
                _cj.runa_equipada = torre_equip_runas_disponibles[torre_equip_runa_indice];
            } else {
                _cj.runa_equipada = "";
            }
            scr_torre_lanzar_combate();
            io_clear();
        }

        if (keyboard_check_pressed(vk_escape)) {
            _cj.runa_equipada = "";
            scr_torre_lanzar_combate();
            io_clear();
        }
    }
}

// ═══════════════════════════════════════════
//  FASE: COMBATE (se maneja en rm_combate)
// ═══════════════════════════════════════════
// No se procesa aquí — el combate corre en rm_combate
// Al terminar, obj_control_combate llama a scr_torre_post_combate()

// ═══════════════════════════════════════════
//  FASE: POST-COMBATE (resumen de piso)
// ═══════════════════════════════════════════
else if (torre_fase == "post_combate") {

    if (keyboard_check_pressed(vk_up))   torre_post_opcion = max(0, torre_post_opcion - 1);
    if (keyboard_check_pressed(vk_down)) torre_post_opcion = min(1, torre_post_opcion + 1);

    if (keyboard_check_pressed(vk_enter)) {
        if (torre_post_opcion == 0) {
            // Siguiente piso o tienda
            if (scr_torre_es_piso_tienda(torre_dificultad, torre_piso)) {
                torre_fase = "tienda";
                torre_tienda_items = scr_torre_catalogo_tienda_piso(torre_piso, torre_pisos_total);
                torre_tienda_indice = 0;
                torre_tienda_mensaje = "";
            } else {
                torre_piso++;
                torre_piso_data = scr_torre_generar_piso(torre_ala, torre_dificultad, torre_piso);
                torre_fase = "pre_combate";
            }
        } else {
            // Abandonar
            scr_torre_finalizar("abandono");
        }
        io_clear();
    }
}

// ═══════════════════════════════════════════
//  FASE: TIENDA ENTRE PISOS
// ═══════════════════════════════════════════
else if (torre_fase == "tienda") {

    var _n_items = array_length(torre_tienda_items);

    // Navegación: arriba/abajo
    if (keyboard_check_pressed(vk_up))    torre_tienda_indice = (torre_tienda_indice - 1 + (_n_items + 1)) mod (_n_items + 1);
    if (keyboard_check_pressed(vk_down))  torre_tienda_indice = (torre_tienda_indice + 1) mod (_n_items + 1);

    // Comprar o continuar
    if (keyboard_check_pressed(vk_enter)) {
        if (torre_tienda_indice == _n_items) {
            // Último slot = "Continuar"
            torre_piso++;
            torre_piso_data = scr_torre_generar_piso(torre_ala, torre_dificultad, torre_piso);
            torre_fase = "pre_combate";
            io_clear();
        } else {
            var _item = torre_tienda_items[torre_tienda_indice];
            if (control_juego.oro >= _item.precio) {
                control_juego.oro -= _item.precio;
                scr_inventario_agregar_objeto(control_juego, _item.nombre, 1);
                torre_tienda_mensaje = "¡Comprado: " + _item.nombre + "!";
                torre_tienda_msg_timer = GAME_FPS * 2;
            } else {
                torre_tienda_mensaje = "Oro insuficiente";
                torre_tienda_msg_timer = GAME_FPS * 1.5;
            }
        }
    }

    // Timer de mensaje
    if (torre_tienda_msg_timer > 0) {
        torre_tienda_msg_timer--;
        if (torre_tienda_msg_timer <= 0) torre_tienda_mensaje = "";
    }

    if (keyboard_check_pressed(vk_escape)) {
        // ESC en tienda = continuar
        torre_piso++;
        torre_piso_data = scr_torre_generar_piso(torre_ala, torre_dificultad, torre_piso);
        torre_fase = "pre_combate";
        io_clear();
    }
}

// ═══════════════════════════════════════════
//  FASE: VICTORIA
// ═══════════════════════════════════════════
else if (torre_fase == "victoria") {
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_escape)) {
        scr_torre_finalizar("victoria");
    }
}

// ═══════════════════════════════════════════
//  FASE: DERROTA
// ═══════════════════════════════════════════
else if (torre_fase == "derrota") {
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_escape)) {
        scr_torre_finalizar("derrota");
    }
}


// ═══════════════════════════════════════════════════════════════
//  FUNCIONES AUXILIARES DE LA TORRE
// ═══════════════════════════════════════════════════════════════

/// @function scr_torre_iniciar_run()
/// Inicia una nueva run de torre con los datos seleccionados
function scr_torre_iniciar_run() {
    torre_activa = true;
    torre_piso = 1;
    torre_oro_ganado = 0;
    torre_materiales_run = [];
    torre_racha_hp_alta = 0;
    torre_bonus_racha = false;
    torre_pj_vida_actual = 0; // Se seteará al crear el personaje
    torre_pj_vida_max = 0;

    // Generar primer piso
    torre_piso_data = scr_torre_generar_piso(torre_ala, torre_dificultad, torre_piso);
    torre_fase = "pre_combate";

    show_debug_message("🏰 Torre iniciada: " + torre_ala.nombre + " | " + torre_dificultad.nombre
        + " | PJ: " + torre_perfil_nombre + " | Arma: " + torre_arma);
}

/// @function scr_torre_lanzar_combate()
/// Prepara los datos y lanza rm_combate
function scr_torre_lanzar_combate() {
    var _cj = instance_find(obj_control_juego, 0);

    // Setear personaje seleccionado como activo
    _cj.personaje_seleccionado = torre_perfil_nombre;
    var _perfil = _cj.perfiles_personaje[? torre_perfil_nombre];
    _perfil.arma_equipada = torre_arma;

    // Equipamiento: si no se asignó en la fase equipar, asegurar arrays vacíos
    if (!variable_instance_exists(_cj, "objetos_para_combate") || !is_array(_cj.objetos_para_combate)) {
        _cj.objetos_para_combate = [];
    }
    if (!variable_instance_exists(_cj, "runa_equipada")) {
        _cj.runa_equipada = "";
    }

    // Setear enemigo
    _cj.enemigo_seleccionado = torre_piso_data.nombre_enemigo;

    // Marcar que estamos en modo torre (para que obj_control_combate lo sepa)
    _cj.modo_torre = true;
    _cj.torre_hp_mult = torre_piso_data.hp_mult;
    _cj.torre_oro_mult = torre_piso_data.oro_mult;

    torre_fase = "combate";
    scr_transicion_ir(rm_combate);
}

/// @function scr_torre_post_combate(_ganador, _pj, _oro_ganado)
/// Llamada desde obj_control_combate cuando termina el combate en modo torre
function scr_torre_post_combate(_ganador, _pj, _oro_ganado) {

    // Guardar HP del jugador
    torre_pj_vida_actual = _pj.vida_actual;
    torre_pj_vida_max    = _pj.vida_max;

    if (_ganador == "Jugador") {
        torre_oro_ganado += _oro_ganado;

        // Racha de HP alta
        if (_pj.vida_actual >= _pj.vida_max * 0.5) {
            torre_racha_hp_alta++;
            if (torre_racha_hp_alta >= 3 && !torre_bonus_racha) {
                torre_bonus_racha = true;
                // Bonus: +15% del oro ganado hasta ahora
                var _bonus = floor(torre_oro_ganado * 0.15);
                torre_oro_ganado += _bonus;
                var _cj = instance_find(obj_control_juego, 0);
                if (instance_exists(_cj)) _cj.oro += _bonus;
                show_debug_message("🔥 ¡Bonus de racha! +" + string(_bonus) + " oro");
            }
        } else {
            torre_racha_hp_alta = 0;
            torre_bonus_racha = false;
        }

        // ¿Último piso?
        if (torre_piso >= torre_pisos_total) {
            // Recompensa de completar ala
            var _recomp = scr_torre_recompensa_completar(torre_ala, torre_dificultad);
            var _cj = instance_find(obj_control_juego, 0);
            if (instance_exists(_cj)) _cj.oro += _recomp.oro;
            torre_oro_ganado += _recomp.oro;
            torre_fase = "victoria";
        } else {
            torre_fase = "post_combate";
        }
    } else {
        torre_fase = "derrota";
    }

    // Volver a rm_torre
    scr_transicion_ir(rm_torre);
}

/// @function scr_torre_finalizar(_resultado)
/// Limpia el estado de torre y vuelve al menú.
/// NO destruye la instancia (es persistente y GameMaker no la recrea).
function scr_torre_finalizar(_resultado) {
    var _cj = instance_find(obj_control_juego, 0);
    if (instance_exists(_cj)) {
        _cj.modo_torre = false;
        _cj.torre_hp_mult = 1;
        _cj.torre_oro_mult = 1;
    }

    show_debug_message("🏰 Torre finalizada: " + _resultado
        + " | Oro total: " + string(torre_oro_ganado)
        + " | Piso alcanzado: " + string(torre_piso));

    // ── Reset completo del estado para la próxima entrada ──
    torre_activa     = false;
    torre_ala        = undefined;
    torre_dificultad = undefined;
    torre_piso       = 0;
    torre_pisos_total = 0;
    torre_fase       = "seleccion_ala";

    sel_ala_indice   = 0;
    sel_dif_indice   = 0;
    sel_pj_indice    = 0;
    sel_arma_indice  = 0;

    torre_perfil_nombre   = "";
    torre_arma            = "";
    torre_pj_clase        = "";
    torre_pj_afinidad     = "";
    torre_pj_personalidad = "";

    torre_oro_ganado     = 0;
    torre_materiales_run = [];
    torre_racha_hp_alta  = 0;
    torre_bonus_racha    = false;

    torre_piso_data      = undefined;
    torre_pj_vida_actual = 0;
    torre_pj_vida_max    = 0;

    torre_tienda_items     = [];
    torre_tienda_indice    = 0;
    torre_tienda_mensaje   = "";
    torre_tienda_msg_timer = 0;

    torre_post_opcion = 0;

    torre_equip_objetos           = [];
    torre_equip_indice            = 0;
    torre_equip_runa              = "";
    torre_equip_fase              = "objetos";
    torre_equip_runa_indice       = 0;
    torre_equip_obj_disponibles   = [];
    torre_equip_runas_disponibles = [];

    scr_transicion_ir(rm_menu);
}
