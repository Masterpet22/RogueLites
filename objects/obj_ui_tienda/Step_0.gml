/// STEP — obj_ui_tienda

// ── ESC: retroceder ──
if (keyboard_check_pressed(vk_escape)) {
    if (estado == TiendaState.LISTA) {
        estado = TiendaState.CATEGORIA;
    } else {
        if (instance_exists(obj_control_juego) && variable_struct_exists(obj_control_juego, "modo_camino") && obj_control_juego.modo_camino) {
            room_goto(rm_camino);
        } else {
            room_goto(rm_menu);
        }
    }
}

// ── Timer de mensajes ──
if (mensaje_timer > 0) {
    mensaje_timer--;
    if (mensaje_timer <= 0) mensaje = "";
}

// ==============================
// ESTADO 1 — Seleccionar categoría
// ==============================
if (estado == TiendaState.CATEGORIA) {

    if (keyboard_check_pressed(vk_up)) {
        indice_categoria = (indice_categoria - 1 + array_length(categorias)) mod array_length(categorias);
    }
    if (keyboard_check_pressed(vk_down)) {
        indice_categoria = (indice_categoria + 1) mod array_length(categorias);
    }

    if (keyboard_check_pressed(vk_enter)) {
        // Construir la lista de items según la categoría
        items_lista = [];
        var _cat = categorias[indice_categoria];

        if (_cat == "Personajes") {
            var _pjs = catalogo.personajes;
            for (var i = 0; i < array_length(_pjs); i++) {
                var _p = _pjs[i];
                var _datos_clase = scr_datos_clases(_p.clase);
                var _ya_tiene = ds_map_exists(control_juego.perfiles_personaje, _p.nombre);
                array_push(items_lista, {
                    nombre: _p.nombre,
                    subtitulo: _p.clase + " [" + _p.afinidad + "]",
                    precio: _datos_clase.precio,
                    comprado: _ya_tiene,
                    tipo: "personaje",
                    datos_extra: _p,
                });
            }
        }
        else if (_cat == "Enemigos") {
            var _ens = catalogo.enemigos;
            for (var i = 0; i < array_length(_ens); i++) {
                var _en_nombre = _ens[i];
                var _datos_en  = scr_datos_enemigos(_en_nombre);
                var _desbloqueado = ds_map_exists(control_juego.enemigos_desbloqueados, _en_nombre);
                array_push(items_lista, {
                    nombre: _en_nombre,
                    subtitulo: "Afinidad: " + _datos_en.afinidad + "  |  Vida: " + string(_datos_en.vida),
                    precio: _datos_en.precio,
                    comprado: _desbloqueado,
                    tipo: "enemigo",
                    datos_extra: _en_nombre,
                });
            }
        }
        else if (_cat == "Objetos") {
            var _objs = catalogo.objetos;
            for (var i = 0; i < array_length(_objs); i++) {
                var _obj_nombre = _objs[i];
                var _datos_obj  = scr_datos_objetos(_obj_nombre);
                var _cant_inv   = scr_inventario_get_objeto(control_juego, _obj_nombre);
                array_push(items_lista, {
                    nombre: _obj_nombre,
                    subtitulo: _datos_obj.descripcion,
                    precio: _datos_obj.precio,
                    comprado: false,  // objetos se pueden comprar infinitamente
                    tipo: "objeto",
                    datos_extra: _obj_nombre,
                    cantidad: _cant_inv,
                });
            }
        }        else if (_cat == "Runicos") {
            var _runs = catalogo.runicos;
            for (var i = 0; i < array_length(_runs); i++) {
                var _run_nombre = _runs[i];
                var _datos_run  = scr_datos_objetos(_run_nombre);
                var _cant_inv   = scr_inventario_get_objeto(control_juego, _run_nombre);
                array_push(items_lista, {
                    nombre: _run_nombre,
                    subtitulo: _datos_run.descripcion,
                    precio: _datos_run.precio,
                    comprado: false,
                    tipo: "runico",
                    datos_extra: _run_nombre,
                    cantidad: _cant_inv,
                });
            }
        }
        indice_item = 0;
        estado = TiendaState.LISTA;
    }
}

// ==============================
// ESTADO 2 — Lista de items
// ==============================
else if (estado == TiendaState.LISTA) {

    if (array_length(items_lista) == 0) {
        estado = TiendaState.CATEGORIA;
        exit;
    }

    if (keyboard_check_pressed(vk_up)) {
        indice_item = (indice_item - 1 + array_length(items_lista)) mod array_length(items_lista);
    }
    if (keyboard_check_pressed(vk_down)) {
        indice_item = (indice_item + 1) mod array_length(items_lista);
    }

    // ── Comprar con ENTER ──
    if (keyboard_check_pressed(vk_enter)) {
        var _item = items_lista[indice_item];

        // Ya comprado (personajes/enemigos)
        if (_item.comprado && _item.tipo != "objeto" && _item.tipo != "runico") {
            mensaje = "Ya tienes este elemento desbloqueado.";
            mensaje_color = c_red;
            mensaje_timer = GAME_FPS * 2;
            exit;
        }

        // Sin oro suficiente
        if (control_juego.oro < _item.precio) {
            mensaje = "No tienes suficiente oro. Necesitas " + string(_item.precio) + " G.";
            mensaje_color = c_red;
            mensaje_timer = GAME_FPS * 2;
            exit;
        }

        // ── COMPRAR ──
        control_juego.oro -= _item.precio;

        switch (_item.tipo) {

            case "personaje":
                var _pd = _item.datos_extra;
                var _perfil_nuevo = scr_crear_perfil_personaje(
                    _pd.nombre, _pd.clase, _pd.afinidad, _pd.personalidad
                );
                ds_map_add(_perfil_nuevo.armas_obtenidas, "Hoja Rota", true);
                ds_map_add(control_juego.perfiles_personaje, _pd.nombre, _perfil_nuevo);
                _item.comprado = true;
                mensaje = "¡Desbloqueaste a " + _pd.nombre + "!";
                mensaje_color = c_lime;
                break;

            case "enemigo":
                var _en = _item.datos_extra;
                ds_map_add(control_juego.enemigos_desbloqueados, _en, true);
                _item.comprado = true;
                mensaje = "¡Desbloqueaste: " + _en + "!";
                mensaje_color = c_lime;
                break;

            case "objeto":
                var _on = _item.datos_extra;
                scr_inventario_agregar_objeto(control_juego, _on, 1);
                _item.cantidad = scr_inventario_get_objeto(control_juego, _on);
                mensaje = "¡Compraste " + _on + "! (x" + string(_item.cantidad) + ")";
                mensaje_color = c_lime;
                break;

            case "runico":
                var _rn = _item.datos_extra;
                scr_inventario_agregar_objeto(control_juego, _rn, 1);
                _item.cantidad = scr_inventario_get_objeto(control_juego, _rn);
                mensaje = "¡Compraste " + _rn + "! (x" + string(_item.cantidad) + ")";
                mensaje_color = make_color_rgb(180, 120, 255);
                break;
        }

        mensaje_timer = GAME_FPS * 2;
    }
}
