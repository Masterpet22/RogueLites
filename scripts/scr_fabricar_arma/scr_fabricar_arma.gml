/// scr_fabricar_arma(control_juego, nombre_arma, nombre_personaje)
function scr_fabricar_arma(_ctrl, _arma, _nombre_pj) {

    if (!scr_inventario_puede_fabricar_arma(_ctrl, _arma)) {
        return false;
    }

    var datos_arma = scr_datos_armas(_arma);
    var receta     = datos_arma.receta;

    // 1. Gastar materiales
    for (var i = 0; i < array_length(receta); i++) {
        var req = receta[i];
        var mat = req.material;
        var nes = req.cantidad;

        var actual = scr_inventario_get_material(_ctrl, mat);
        _ctrl.inventario_materiales[? mat] = max(0, actual - nes);
    }

    // 2. Obtener perfil DESTINO
    var perfil = _ctrl.perfiles_personaje[? _nombre_pj];

    // 3. Añadir arma a ese personaje
    ds_map_add(perfil.armas_obtenidas, _arma, true);

    // 4. Opcional: equiparla automáticamente
    perfil.arma_equipada = _arma;

    return true;
}