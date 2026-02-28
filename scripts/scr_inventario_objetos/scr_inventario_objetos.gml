/// @function scr_inventario_agregar_objeto(control_juego, nombre_objeto, cantidad)
/// @description Agrega (o resta) una cantidad de un objeto al inventario de objetos.
function scr_inventario_agregar_objeto(_ctrl, _obj, _cant) {

    if (!ds_map_exists(_ctrl.inventario_objetos, _obj)) {
        ds_map_add(_ctrl.inventario_objetos, _obj, 0);
    }

    var actual = _ctrl.inventario_objetos[? _obj];
    _ctrl.inventario_objetos[? _obj] = max(0, actual + _cant);
}

/// @function scr_inventario_get_objeto(control_juego, nombre_objeto)
/// @description Retorna la cantidad del objeto en el inventario (0 si no existe).
function scr_inventario_get_objeto(_ctrl, _obj) {

    if (!ds_map_exists(_ctrl.inventario_objetos, _obj)) {
        return 0;
    }
    return _ctrl.inventario_objetos[? _obj];
}
