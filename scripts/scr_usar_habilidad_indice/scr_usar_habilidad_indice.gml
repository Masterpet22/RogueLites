/// scr_usar_habilidad_indice(atacante, defensor, indice)
function scr_usar_habilidad_indice(_atacante, _defensor, _indice) {

    // Seguridad
    if (!is_array(_atacante.habilidades_arma)) return;
    if (!is_array(_atacante.habilidades_cd))   return;

    var habs = _atacante.habilidades_arma;
    var cds  = _atacante.habilidades_cd;

    var n = array_length(habs);
    if (_indice < 0 || _indice >= n) return;

    var id_hab = habs[_indice];

    // Cooldown actual
    if (cds[_indice] > 0) return;

    // Ejecutar habilidad
    scr_ejecutar_habilidad(_atacante, _defensor, id_hab);

    // Notificación de acción
    var _nombre_hab = scr_nombre_habilidad(id_hab);
    var _col = _atacante.es_jugador ? c_lime : c_red;
    scr_notif_agregar(_atacante.nombre, "usa " + _nombre_hab, _col);

    // Asignar cooldown usando los datos de la habilidad
    var cd_base = scr_cooldown_habilidad(id_hab);
    cds[_indice] = cd_base;
}