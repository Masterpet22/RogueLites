/// scr_inventario_marcar_arma_obtenida(control_juego, nombre_arma)
function scr_inventario_marcar_arma_obtenida(_ctrl, _arma) {

    var perfil = scr_get_perfil_activo(_ctrl);

    if (!ds_map_exists(perfil.armas_obtenidas, _arma)) {
        ds_map_add(perfil.armas_obtenidas, _arma, true);
    } else {
        perfil.armas_obtenidas[? _arma] = true;
    }
}