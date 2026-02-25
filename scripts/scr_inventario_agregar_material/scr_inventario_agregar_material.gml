/// scr_inventario_agregar_material(control_juego, nombre_material, cantidad)
function scr_inventario_agregar_material(_ctrl, _mat, _cant) {

    if (!ds_map_exists(_ctrl.inventario_materiales, _mat)) {
        ds_map_add(_ctrl.inventario_materiales, _mat, 0);
    }

    var actual = _ctrl.inventario_materiales[? _mat];
    _ctrl.inventario_materiales[? _mat] = max(0, actual + _cant);
}
