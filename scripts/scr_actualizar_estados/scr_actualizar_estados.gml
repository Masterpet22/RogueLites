/// scr_actualizar_estados(personaje)
function scr_actualizar_estados(_p) {

    if (!is_array(_p.estados)) return;

    var n = array_length(_p.estados);

    for (var i = 0; i < n; i++) {

        var est = _p.estados[i];
        if (!est.activo) continue;

        // Reducir duración
        est.tiempo_rest--;
        
        // Aplicar lógica según tipo
        if (est.tipo == "dot") {

            est.tick_timer--;
            if (est.tick_timer <= 0) {

                // Aplicar daño de efecto
                var dano = max(1, est.potencia);
                _p.vida_actual = max(0, _p.vida_actual - dano);

                // Reiniciar timer
                est.tick_timer = est.tick_interval;

                // Debug
                show_debug_message("Estado DOT " + est.id + " hace " + string(dano) + " de daño.");
            }
        }

        // Si ya se acabó la duración → limpiar
        if (est.tiempo_rest <= 0) {

            est.activo = false;

            if (est.tipo == "buff_defensa" && est.defensa_bonus != 0) {
                _p.defensa_bonus_temp -= est.defensa_bonus;
            }
            if (est.tipo == "buff_defensa_magica" && est.defensa_magica_bonus != 0) {
                _p.defensa_magica_bonus_temp -= est.defensa_magica_bonus;
            }
            if (est.tipo == "buff_velocidad" && est.velocidad_bonus != 0) {
                _p.velocidad -= est.velocidad_bonus;
            }
        }

        _p.estados[i] = est;
    }
}