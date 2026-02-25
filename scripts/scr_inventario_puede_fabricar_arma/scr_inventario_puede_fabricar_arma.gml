/// scr_inventario_puede_fabricar_arma(control_juego, nombre_arma) -> bool
function scr_inventario_puede_fabricar_arma(_ctrl, _arma) {

    var datos_arma = scr_datos_armas(_arma);
    if (datos_arma == undefined) return false;

    var receta = datos_arma.receta;

    // Si la receta está vacía, asumimos que NO es forjable (ej: Hoja Rota)
    if (!is_array(receta) || array_length(receta) <= 0) {
        return false;
    }

    // Recorrer cada requisito {material, cantidad}
    var n = array_length(receta);
    for (var i = 0; i < n; i++) {
        var req = receta[i];

        var mat_nombre = req.material;
        var mat_neces  = req.cantidad;

        var mat_tiene  = scr_inventario_get_material(_ctrl, mat_nombre);

        if (mat_tiene < mat_neces) {
            return false;
        }
    }

    return true;
}