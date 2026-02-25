/// scr_inventario_get_material(control_juego, nombre_material) -> cantidad
function scr_inventario_get_material(_ctrl, _mat) {

    if (!ds_map_exists(_ctrl.inventario_materiales, _mat)) {
        return 0;
    }

    return _ctrl.inventario_materiales[? _mat];
}