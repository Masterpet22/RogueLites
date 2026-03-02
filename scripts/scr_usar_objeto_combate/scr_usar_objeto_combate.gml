/// @function scr_usar_objeto_combate(slot_index)
/// @description Usa el objeto equipado en el slot indicado (0, 1 o 2).
///              Aplica el efecto sobre el personaje del jugador y marca el slot como usado.
/// @param {real} _slot  Índice del slot (0-2)
function scr_usar_objeto_combate(_slot) {

    if (!instance_exists(obj_control_combate)) return;
    var _ctrl = instance_find(obj_control_combate, 0);

    // Validar que el array de objetos equipados exista
    if (!is_array(_ctrl.objetos_equipados)) return;
    if (_slot < 0 || _slot >= array_length(_ctrl.objetos_equipados)) return;

    var _nombre = _ctrl.objetos_equipados[_slot];

    // Slot vacío o ya fue usado
    if (_nombre == "" || _nombre == undefined) return;
    if (_ctrl.objetos_usados[_slot]) return;

    // Obtener datos del objeto
    var _datos = scr_datos_objetos(_nombre);
    if (_datos == undefined) return;

    var _pj = _ctrl.personaje_jugador;

    // Aplicar efecto según tipo
    switch (_datos.efecto) {

        case "curar_vida":
            _pj.vida_actual = min(_pj.vida_actual + _datos.valor_efecto, _pj.vida_max);
            scr_notif_agregar(_pj.nombre, "usa " + _nombre + " (+" + string(_datos.valor_efecto) + " HP)", c_lime);
            break;

        case "restaurar_esencia":
            var _cantidad = round(_pj.esencia_llena * _datos.valor_efecto / 100);
            _pj.esencia = min(_pj.esencia + _cantidad, _pj.esencia_llena);
            scr_notif_agregar(_pj.nombre, "usa " + _nombre + " (+" + string(_cantidad) + " Esencia)", c_aqua);
            scr_feedback_agregar(true, _cantidad, "esencia");
            scr_feedback_flash(true, make_color_rgb(140, 100, 255));
            break;

        case "buff_ataque":
            _pj.ataque_base += _datos.valor_efecto;
            scr_notif_agregar(_pj.nombre, "usa " + _nombre + " (ATQ +" + string(_datos.valor_efecto) + ")", c_orange);
            scr_feedback_agregar(true, _datos.valor_efecto, "buff");
            scr_feedback_flash(true, c_aqua);
            break;

        case "buff_defensa":
            _pj.defensa_bonus_temp += _datos.valor_efecto;
            scr_notif_agregar(_pj.nombre, "usa " + _nombre + " (DEF +" + string(_datos.valor_efecto) + ")", c_orange);
            scr_feedback_agregar(true, _datos.valor_efecto, "buff");
            scr_feedback_flash(true, c_aqua);
            break;

        default:
            show_debug_message("Efecto de objeto desconocido: " + _datos.efecto);
            break;
    }

    // Marcar slot como usado (no se puede reusar)
    _ctrl.objetos_usados[_slot] = true;

    show_debug_message("Objeto usado: " + _nombre + " (slot " + string(_slot) + ")");
}
