/// scr_inventario_tiene_arma(control_juego, nombre_arma) -> bool
function scr_inventario_tiene_arma(_ctrl, _arma) {

    var perfil = scr_get_perfil_activo(_ctrl);

    if (!ds_map_exists(perfil.armas_obtenidas, _arma)) {
        return false;
    }

    return perfil.armas_obtenidas[? _arma];
}