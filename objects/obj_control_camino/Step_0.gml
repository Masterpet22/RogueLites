/// STEP — obj_control_camino

// No procesar durante combate activo
if (camino_fase == "combate") {
    if (room == rm_camino) {
        camino_fase = "seleccion_personaje";
        show_debug_message("⚠ Camino: fase 'combate' detectada en rm_camino — reseteando");
    } else {
        exit;
    }
}

// Solo procesar input en rm_camino
if (room != rm_camino) exit;

var control_juego = instance_find(obj_control_juego, 0);
if (!instance_exists(control_juego)) exit;


// ═══════════════════════════════════════════
//  FASE: SELECCIÓN DE PERSONAJE
// ═══════════════════════════════════════════
if (camino_fase == "seleccion_personaje") {

    var _nombres = scr_ds_map_keys_array(control_juego.perfiles_personaje);
    var _n = array_length(_nombres);

    if (keyboard_check_pressed(vk_up))    sel_pj_indice = (sel_pj_indice - 1 + _n) mod _n;
    if (keyboard_check_pressed(vk_down))  sel_pj_indice = (sel_pj_indice + 1) mod _n;

    if (keyboard_check_pressed(vk_enter)) {
        var _nombre = _nombres[sel_pj_indice];
        var _perfil = control_juego.perfiles_personaje[? _nombre];

        camino_perfil_nombre   = _nombre;
        camino_pj_clase        = _perfil.clase;
        camino_pj_afinidad     = _perfil.afinidad;
        camino_pj_personalidad = _perfil.personalidad;

        // Obtener armas disponibles
        camino_armas_disponibles = [];
        var _arma_key = ds_map_find_first(_perfil.armas_obtenidas);
        while (_arma_key != undefined) {
            array_push(camino_armas_disponibles, _arma_key);
            _arma_key = ds_map_find_next(_perfil.armas_obtenidas, _arma_key);
        }

        if (array_length(camino_armas_disponibles) == 1) {
            camino_arma = camino_armas_disponibles[0];
            scr_camino_iniciar_run();
        } else {
            camino_fase = "seleccion_arma";
            sel_arma_indice = 0;
        }
        io_clear();
    }

    if (keyboard_check_pressed(vk_escape)) {
        room_goto(rm_menu);
    }
}


// ═══════════════════════════════════════════
//  FASE: SELECCIÓN DE ARMA
// ═══════════════════════════════════════════
else if (camino_fase == "seleccion_arma") {

    var _n = array_length(camino_armas_disponibles);

    if (keyboard_check_pressed(vk_up))    sel_arma_indice = (sel_arma_indice - 1 + _n) mod _n;
    if (keyboard_check_pressed(vk_down))  sel_arma_indice = (sel_arma_indice + 1) mod _n;

    if (keyboard_check_pressed(vk_enter)) {
        camino_arma = camino_armas_disponibles[sel_arma_indice];
        scr_camino_iniciar_run();
        io_clear();
    }

    if (keyboard_check_pressed(vk_escape)) {
        camino_fase = "seleccion_personaje";
        io_clear();
    }
}


// ═══════════════════════════════════════════
//  FASE: NARRATIVA (intro/victoria/fragmentos)
// ═══════════════════════════════════════════
else if (camino_fase == "narrativa_linea") {

    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
        camino_narrativa_idx++;
        if (camino_narrativa_idx >= array_length(camino_narrativa_lineas)) {
            // Terminar narrativa → ir al destino
            camino_fase = camino_narrativa_destino;
            io_clear();
        }
    }

    if (keyboard_check_pressed(vk_escape)) {
        // Saltar toda la narrativa
        camino_fase = camino_narrativa_destino;
        io_clear();
    }
}


// ═══════════════════════════════════════════
//  FASE: MAPA DE RAMIFICACIONES
// ═══════════════════════════════════════════
else if (camino_fase == "mapa") {

    // Calcular conexiones disponibles desde la posición actual
    var _total_tiers = array_length(camino_mapa);
    var _next_tier = camino_tier_actual + 1;

    if (_next_tier >= _total_tiers) {
        // Ya pasó todos los tiers → victoria de capítulo
        camino_fase = "victoria_capitulo";
    } else {
        // Determinar nodos alcanzables
        if (camino_tier_actual < 0) {
            // Inicio: todos los nodos del tier 0 son alcanzables
            camino_mapa_conexiones = [];
            for (var i = 0; i < array_length(camino_mapa[0]); i++) {
                array_push(camino_mapa_conexiones, i);
            }
        } else {
            var _nodo_actual = camino_mapa[camino_tier_actual][camino_nodo_actual];
            camino_mapa_conexiones = _nodo_actual.conexiones;
        }

        // Clamp la selección al rango válido
        if (camino_mapa_sel >= array_length(camino_mapa_conexiones)) {
            camino_mapa_sel = 0;
        }

        // Navegación ← →
        var _n_conex = array_length(camino_mapa_conexiones);
        if (_n_conex > 0) {
            if (keyboard_check_pressed(vk_left))  camino_mapa_sel = (camino_mapa_sel - 1 + _n_conex) mod _n_conex;
            if (keyboard_check_pressed(vk_right)) camino_mapa_sel = (camino_mapa_sel + 1) mod _n_conex;
            if (keyboard_check_pressed(vk_up))    camino_mapa_sel = (camino_mapa_sel - 1 + _n_conex) mod _n_conex;
            if (keyboard_check_pressed(vk_down))  camino_mapa_sel = (camino_mapa_sel + 1) mod _n_conex;

            if (keyboard_check_pressed(vk_enter)) {
                camino_tier_actual = _next_tier;
                camino_nodo_actual = camino_mapa_conexiones[camino_mapa_sel];
                camino_mapa_sel = 0;
                scr_camino_ejecutar_nodo();
                io_clear();
            }
        }

        if (keyboard_check_pressed(vk_escape)) {
            scr_camino_finalizar("abandono");
            io_clear();
        }
    }
}


// ═══════════════════════════════════════════
//  FASE: PRE-COMBATE
// ═══════════════════════════════════════════
else if (camino_fase == "pre_combate") {

    camino_post_opcion = 0;

    if (keyboard_check_pressed(vk_enter)) {
        // Preparar equipamiento de objetos
        camino_equip_objetos = [];
        camino_equip_runa = "";
        camino_equip_indice = 0;
        camino_equip_runa_indice = 0;

        var _cj = instance_find(obj_control_juego, 0);
        camino_equip_obj_disponibles = [];
        var _todos = scr_lista_objetos_disponibles();
        for (var i = 0; i < array_length(_todos); i++) {
            var _cant = scr_inventario_get_objeto(_cj, _todos[i]);
            if (_cant > 0) array_push(camino_equip_obj_disponibles, _todos[i]);
        }

        if (array_length(camino_equip_obj_disponibles) > 0) {
            camino_equip_fase = "objetos";
            camino_fase = "equipar";
        } else {
            camino_equip_runas_disponibles = [];
            var _todas_runas = scr_lista_runicos_disponibles();
            for (var i = 0; i < array_length(_todas_runas); i++) {
                var _cant = scr_inventario_get_objeto(_cj, _todas_runas[i]);
                if (_cant > 0) array_push(camino_equip_runas_disponibles, _todas_runas[i]);
            }
            if (array_length(camino_equip_runas_disponibles) > 0) {
                camino_equip_fase = "runa";
                camino_fase = "equipar";
            } else {
                scr_camino_lanzar_combate();
            }
        }
        io_clear();
    }

    if (keyboard_check_pressed(vk_escape)) {
        scr_camino_finalizar("abandono");
    }
}


// ═══════════════════════════════════════════
//  FASE: EQUIPAR OBJETOS / RUNAS
// ═══════════════════════════════════════════
else if (camino_fase == "equipar") {

    var _cj = instance_find(obj_control_juego, 0);

    if (camino_equip_fase == "objetos") {
        var _n = array_length(camino_equip_obj_disponibles);

        if (keyboard_check_pressed(vk_up))   camino_equip_indice = (camino_equip_indice - 1 + _n) mod _n;
        if (keyboard_check_pressed(vk_down)) camino_equip_indice = (camino_equip_indice + 1) mod _n;

        // TAB: alternar selección
        if (keyboard_check_pressed(vk_tab)) {
            var _obj_nom = camino_equip_obj_disponibles[camino_equip_indice];
            var _veces = 0;
            for (var i = 0; i < array_length(camino_equip_objetos); i++) {
                if (camino_equip_objetos[i] == _obj_nom) _veces++;
            }
            var _cant_inv = scr_inventario_get_objeto(_cj, _obj_nom);
            if (array_length(camino_equip_objetos) < 3 && _veces < _cant_inv) {
                array_push(camino_equip_objetos, _obj_nom);
            } else if (_veces > 0) {
                for (var i = array_length(camino_equip_objetos) - 1; i >= 0; i--) {
                    if (camino_equip_objetos[i] == _obj_nom) {
                        array_delete(camino_equip_objetos, i, 1);
                        break;
                    }
                }
            }
        }

        // ENTER: confirmar objetos → pasar a runas
        if (keyboard_check_pressed(vk_enter)) {
            _cj.objetos_para_combate = [];
            array_copy(_cj.objetos_para_combate, 0, camino_equip_objetos, 0, array_length(camino_equip_objetos));

            camino_equip_runas_disponibles = [];
            var _todas_runas = scr_lista_runicos_disponibles();
            for (var i = 0; i < array_length(_todas_runas); i++) {
                var _cant = scr_inventario_get_objeto(_cj, _todas_runas[i]);
                if (_cant > 0) array_push(camino_equip_runas_disponibles, _todas_runas[i]);
            }

            if (array_length(camino_equip_runas_disponibles) > 0) {
                camino_equip_fase = "runa";
                camino_equip_runa_indice = 0;
            } else {
                _cj.runa_equipada = "";
                scr_camino_lanzar_combate();
            }
            io_clear();
        }

        // ESC: skip objetos
        if (keyboard_check_pressed(vk_escape)) {
            camino_equip_objetos = [];
            _cj.objetos_para_combate = [];

            camino_equip_runas_disponibles = [];
            var _todas_runas = scr_lista_runicos_disponibles();
            for (var i = 0; i < array_length(_todas_runas); i++) {
                var _cant = scr_inventario_get_objeto(_cj, _todas_runas[i]);
                if (_cant > 0) array_push(camino_equip_runas_disponibles, _todas_runas[i]);
            }
            if (array_length(camino_equip_runas_disponibles) > 0) {
                camino_equip_fase = "runa";
                camino_equip_runa_indice = 0;
            } else {
                _cj.runa_equipada = "";
                scr_camino_lanzar_combate();
            }
            io_clear();
        }
    }

    else if (camino_equip_fase == "runa") {
        var _n_runas = array_length(camino_equip_runas_disponibles);
        var _total_opts = _n_runas + 1;

        if (keyboard_check_pressed(vk_up))   camino_equip_runa_indice = (camino_equip_runa_indice - 1 + _total_opts) mod _total_opts;
        if (keyboard_check_pressed(vk_down)) camino_equip_runa_indice = (camino_equip_runa_indice + 1) mod _total_opts;

        if (keyboard_check_pressed(vk_enter)) {
            if (camino_equip_runa_indice < _n_runas) {
                _cj.runa_equipada = camino_equip_runas_disponibles[camino_equip_runa_indice];
            } else {
                _cj.runa_equipada = "";
            }
            scr_camino_lanzar_combate();
            io_clear();
        }

        if (keyboard_check_pressed(vk_escape)) {
            _cj.runa_equipada = "";
            scr_camino_lanzar_combate();
            io_clear();
        }
    }
}


// ═══════════════════════════════════════════
//  FASE: POST-COMBATE
// ═══════════════════════════════════════════
else if (camino_fase == "post_combate") {

    if (keyboard_check_pressed(vk_up))   camino_post_opcion = max(0, camino_post_opcion - 1);
    if (keyboard_check_pressed(vk_down)) camino_post_opcion = min(1, camino_post_opcion + 1);

    if (keyboard_check_pressed(vk_enter)) {
        if (camino_post_opcion == 0) {
            // Continuar → volver al mapa para elegir siguiente camino
            camino_fase = "mapa";
            camino_mapa_sel = 0;
        } else {
            // Abandonar
            scr_camino_finalizar("abandono");
        }
        io_clear();
    }
}


// ═══════════════════════════════════════════
//  FASE: VICTORIA DE CAPÍTULO
// ═══════════════════════════════════════════
else if (camino_fase == "victoria_capitulo") {

    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
        // Dar recompensa de capítulo
        var _recomp = scr_camino_recompensa_capitulo(camino_capitulo);
        var _cj = instance_find(obj_control_juego, 0);
        if (instance_exists(_cj)) _cj.oro += _recomp.oro;
        camino_oro_ganado += _recomp.oro;

        // Mostrar narrativa de victoria del capítulo
        camino_narrativa_lineas = camino_capitulo.narrativa_victoria;
        camino_narrativa_idx = 0;
        camino_narrativa_destino = "entre_capitulos";
        camino_fase = "narrativa_linea";
        io_clear();
    }
}


// ═══════════════════════════════════════════
//  FASE: ENTRE CAPÍTULOS (forja/tienda/continuar)
// ═══════════════════════════════════════════
else if (camino_fase == "entre_capitulos") {

    var _n_opciones = 4; // Siguiente, Forja, Tienda, Abandonar

    if (keyboard_check_pressed(vk_up))   camino_entre_opcion = (camino_entre_opcion - 1 + _n_opciones) mod _n_opciones;
    if (keyboard_check_pressed(vk_down)) camino_entre_opcion = (camino_entre_opcion + 1) mod _n_opciones;

    if (keyboard_check_pressed(vk_enter)) {
        switch (camino_entre_opcion) {
            case 0: // Siguiente capítulo
                scr_camino_siguiente_capitulo();
                break;
            case 1: // Forja
                room_goto(rm_forja);
                break;
            case 2: // Tienda
                room_goto(rm_tienda);
                break;
            case 3: // Abandonar
                scr_camino_finalizar("abandono");
                break;
        }
        io_clear();
    }
}


// ═══════════════════════════════════════════
//  FASE: VICTORIA FINAL
// ═══════════════════════════════════════════
else if (camino_fase == "victoria_final") {

    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_escape)) {
        // Check secreto
        if (scr_camino_check_secreto(self) && !camino_secreto_completado) {
            camino_secreto_disponible = true;
            camino_narrativa_lineas = [
                "...",
                "Algo se mueve en las profundidades de las Corrientes.",
                "Una presencia antigua, anterior al Devorador.",
                "El Primer Conductor te ha encontrado.",
                "¿Estás listo para la verdadera prueba?",
            ];
            camino_narrativa_idx = 0;
            camino_narrativa_destino = "secreto_pre_combate";
            camino_fase = "narrativa_linea";
        } else {
            scr_camino_finalizar("victoria");
        }
        io_clear();
    }
}


// ═══════════════════════════════════════════
//  FASE: SECRETO PRE-COMBATE
// ═══════════════════════════════════════════
else if (camino_fase == "secreto_pre_combate") {

    if (keyboard_check_pressed(vk_enter)) {
        // Lanzar combate contra El Primer Conductor
        camino_encuentro = {
            nombre_enemigo: "El Primer Conductor",
            hp_mult:        1.80,
            oro_mult:       3.0,
            es_jefe:        true,
            es_elite:       false,
            tipo:           "secreto",
        };
        scr_camino_lanzar_combate();
        io_clear();
    }

    if (keyboard_check_pressed(vk_escape)) {
        scr_camino_finalizar("victoria");
        io_clear();
    }
}


// ═══════════════════════════════════════════
//  FASE: SECRETO VICTORIA
// ═══════════════════════════════════════════
else if (camino_fase == "secreto_victoria") {

    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_escape)) {
        camino_secreto_completado = true;
        scr_camino_finalizar("victoria_total");
        io_clear();
    }
}


// ═══════════════════════════════════════════
//  FASE: DERROTA
// ═══════════════════════════════════════════
else if (camino_fase == "derrota") {

    if (keyboard_check_pressed(vk_up))   camino_post_opcion = max(0, camino_post_opcion - 1);
    if (keyboard_check_pressed(vk_down)) camino_post_opcion = min(1, camino_post_opcion + 1);

    if (keyboard_check_pressed(vk_enter)) {
        if (camino_post_opcion == 0) {
            // Reintentar mismo encuentro
            camino_derrotas++;
            // Recrear el encuentro desde el nodo actual del mapa
            var _nodo_retry = camino_mapa[camino_tier_actual][camino_nodo_actual];
            camino_encuentro = {
                nombre_enemigo: _nodo_retry.nombre,
                hp_mult: _nodo_retry.hp_mult,
                oro_mult: _nodo_retry.oro_mult,
                es_jefe: (_nodo_retry.tipo == "jefe"),
                es_elite: (_nodo_retry.tipo == "elite"),
                tipo: _nodo_retry.tipo,
            };
            camino_fase = "pre_combate";
        } else {
            // Abandonar
            scr_camino_finalizar("derrota");
        }
        io_clear();
    }
}


// ═══════════════════════════════════════════════════════════════
//  FUNCIONES AUXILIARES DEL CAMINO DEL HÉROE
// ═══════════════════════════════════════════════════════════════

/// @function scr_camino_iniciar_run()
/// Inicia una nueva run del Camino del Héroe
function scr_camino_iniciar_run() {
    camino_activo = true;
    camino_capitulos = scr_camino_get_capitulos();
    camino_capitulo_idx = 0;
    camino_oro_ganado = 0;
    camino_materiales_run = [];
    camino_combates_ganados = 0;
    camino_derrotas = 0;
    camino_combates_totales = 0;
    camino_secreto_disponible = false;

    show_debug_message("⚔ Camino del Héroe iniciado | PJ: " + camino_perfil_nombre + " | Arma: " + camino_arma);

    scr_camino_iniciar_capitulo(0);
}


/// @function scr_camino_iniciar_capitulo(_idx)
/// Inicia un capítulo: genera mapa ramificado y muestra narrativa intro
function scr_camino_iniciar_capitulo(_idx) {
    camino_capitulo_idx = _idx;
    camino_capitulo = camino_capitulos[_idx];

    // Generar mapa ramificado del capítulo
    camino_mapa = scr_camino_generar_mapa(camino_capitulo);
    camino_tier_actual = -1;
    camino_nodo_actual = 0;
    camino_mapa_sel = 0;
    camino_mapa_conexiones = [];

    show_debug_message("📖 Capítulo " + string(camino_capitulo.numero) + ": " + camino_capitulo.nombre
        + " | Tiers: " + string(array_length(camino_mapa)));

    // Narrativa de intro → luego al mapa
    camino_narrativa_lineas = camino_capitulo.narrativa_intro;
    camino_narrativa_idx = 0;
    camino_narrativa_destino = "mapa";
    camino_fase = "narrativa_linea";
}


/// @function scr_camino_siguiente_capitulo()
function scr_camino_siguiente_capitulo() {
    var _next = camino_capitulo_idx + 1;
    if (_next < array_length(camino_capitulos)) {
        scr_camino_iniciar_capitulo(_next);
    } else {
        scr_camino_finalizar("victoria");
    }
}


/// @function scr_camino_ejecutar_nodo()
/// Ejecuta el evento del nodo actual del mapa
function scr_camino_ejecutar_nodo() {
    var _nodo = camino_mapa[camino_tier_actual][camino_nodo_actual];
    _nodo.visitado = true;

    show_debug_message("🗺 Nodo: Tier " + string(camino_tier_actual)
        + " | Nodo " + string(camino_nodo_actual)
        + " | Tipo: " + _nodo.tipo + " | " + _nodo.nombre);

    switch (_nodo.tipo) {
        case "combate":
        case "elite":
            camino_encuentro = {
                nombre_enemigo: _nodo.nombre,
                hp_mult: _nodo.hp_mult,
                oro_mult: _nodo.oro_mult,
                es_jefe: false,
                es_elite: (_nodo.tipo == "elite"),
                tipo: _nodo.tipo,
            };
            camino_fase = "pre_combate";
            break;

        case "jefe":
            camino_encuentro = {
                nombre_enemigo: _nodo.nombre,
                hp_mult: _nodo.hp_mult,
                oro_mult: _nodo.oro_mult,
                es_jefe: true,
                es_elite: false,
                tipo: "jefe",
            };
            camino_fase = "pre_combate";
            break;

        case "tienda":
            room_goto(rm_tienda);
            break;

        case "forja":
            room_goto(rm_forja);
            break;

        case "descanso":
            camino_narrativa_lineas = [
                scr_camino_fragmento_combate(camino_capitulo, camino_tier_actual),
                "Un momento de descanso entre las ruinas...",
                "Recuperas fuerzas para el camino que queda.",
            ];
            camino_narrativa_idx = 0;
            camino_narrativa_destino = "mapa";
            camino_fase = "narrativa_linea";
            break;

        case "cofre":
            var _cj = instance_find(obj_control_juego, 0);
            if (instance_exists(_cj)) {
                _cj.oro += _nodo.recompensa_oro;
                camino_oro_ganado += _nodo.recompensa_oro;
            }
            camino_narrativa_lineas = [
                "¡Has encontrado un cofre entre las ruinas!",
                "Obtienes " + string(_nodo.recompensa_oro) + " oro.",
            ];
            camino_narrativa_idx = 0;
            camino_narrativa_destino = "mapa";
            camino_fase = "narrativa_linea";
            break;
    }
}


/// @function scr_camino_lanzar_combate()
/// Prepara los datos y lanza rm_combate
function scr_camino_lanzar_combate() {
    var _cj = instance_find(obj_control_juego, 0);

    _cj.personaje_seleccionado = camino_perfil_nombre;
    var _perfil = _cj.perfiles_personaje[? camino_perfil_nombre];
    _perfil.arma_equipada = camino_arma;

    if (!variable_instance_exists(_cj, "objetos_para_combate") || !is_array(_cj.objetos_para_combate)) {
        _cj.objetos_para_combate = [];
    }
    if (!variable_instance_exists(_cj, "runa_equipada")) {
        _cj.runa_equipada = "";
    }

    _cj.enemigo_seleccionado = camino_encuentro.nombre_enemigo;

    _cj.modo_camino = true;
    _cj.modo_torre = false;
    _cj.camino_hp_mult = camino_encuentro.hp_mult;
    _cj.camino_oro_mult = camino_encuentro.oro_mult;

    camino_fase = "combate";
    room_goto(rm_combate);
}


/// @function scr_camino_post_combate(_ganador, _pj, _oro_ganado)
/// Callback desde obj_control_combate al terminar un combate en modo camino
function scr_camino_post_combate(_ganador, _pj, _oro_ganado) {
    camino_ultimo_ganador = _ganador;
    camino_ultimo_oro = _oro_ganado;
    camino_combates_totales++;

    if (_ganador == "Jugador") {
        camino_combates_ganados++;
        camino_oro_ganado += _oro_ganado;

        // ¿Fue el combate secreto?
        if (camino_encuentro != undefined && camino_encuentro.tipo == "secreto") {
            camino_narrativa_lineas = [
                "El Primer Conductor cae de rodillas.",
                "\"Eres digno... más digno de lo que yo fui.\"",
                "\"Arcadium está en buenas manos.\"",
                "Has completado la verdadera prueba del Camino del Héroe.",
            ];
            camino_narrativa_idx = 0;
            camino_narrativa_destino = "secreto_victoria";
            camino_fase = "narrativa_linea";
            camino_encuentro = undefined;
            room_goto(rm_camino);
            return;
        }

        // ¿Era el jefe del capítulo?
        if (camino_encuentro != undefined && camino_encuentro.tipo == "jefe") {
            if (camino_capitulo_idx >= array_length(camino_capitulos) - 1) {
                camino_narrativa_lineas = camino_capitulo.narrativa_victoria;
                camino_narrativa_idx = 0;
                camino_narrativa_destino = "victoria_final";
                camino_fase = "narrativa_linea";
            } else {
                camino_fase = "victoria_capitulo";
            }
        } else {
            // Victoria normal → volver al mapa
            camino_fase = "post_combate";
        }
    } else {
        camino_post_opcion = 0;
        camino_fase = "derrota";
    }

    camino_encuentro = undefined;
    room_goto(rm_camino);
}


/// @function scr_camino_finalizar(_resultado)
/// Limpia estado del camino y vuelve al menú
function scr_camino_finalizar(_resultado) {
    var _cj = instance_find(obj_control_juego, 0);
    if (instance_exists(_cj)) {
        _cj.modo_camino = false;
        _cj.camino_hp_mult = 1;
        _cj.camino_oro_mult = 1;
    }

    show_debug_message("⚔ Camino finalizado: " + _resultado
        + " | Oro: " + string(camino_oro_ganado)
        + " | Combates: " + string(camino_combates_ganados) + "/" + string(camino_combates_totales)
        + " | Capítulo: " + string(camino_capitulo_idx + 1));

    camino_activo          = false;
    camino_capitulos       = [];
    camino_capitulo_idx    = 0;
    camino_capitulo        = undefined;
    camino_mapa            = [];
    camino_tier_actual     = -1;
    camino_nodo_actual     = 0;
    camino_mapa_sel        = 0;
    camino_mapa_conexiones = [];
    camino_encuentro       = undefined;
    camino_fase            = "seleccion_personaje";

    sel_pj_indice   = 0;
    sel_arma_indice = 0;
    camino_armas_disponibles = [];

    camino_perfil_nombre   = "";
    camino_arma            = "";
    camino_pj_clase        = "";
    camino_pj_afinidad     = "";
    camino_pj_personalidad = "";

    camino_oro_ganado       = 0;
    camino_materiales_run   = [];
    camino_combates_ganados = 0;
    camino_derrotas         = 0;
    camino_combates_totales = 0;

    camino_narrativa_lineas  = [];
    camino_narrativa_idx     = 0;
    camino_narrativa_destino = "";

    camino_post_opcion = 0;
    camino_ultimo_ganador = "";
    camino_ultimo_oro = 0;

    camino_equip_objetos           = [];
    camino_equip_indice            = 0;
    camino_equip_runa              = "";
    camino_equip_fase              = "objetos";
    camino_equip_runa_indice       = 0;
    camino_equip_obj_disponibles   = [];
    camino_equip_runas_disponibles = [];

    camino_entre_opcion = 0;
    camino_secreto_disponible = false;

    room_goto(rm_menu);
}
