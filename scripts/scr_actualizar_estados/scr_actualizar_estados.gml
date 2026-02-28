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

        // Curación en el tiempo (HOT)
        if (est.tipo == "hot") {

            est.tick_timer--;
            if (est.tick_timer <= 0) {

                var cura = max(1, est.potencia);
                _p.vida_actual = min(_p.vida_max, _p.vida_actual + cura);

                est.tick_timer = est.tick_interval;

                show_debug_message("Estado HOT " + est.id + " cura " + string(cura) + " HP.");
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
            if (est.tipo == "debuff_velocidad" && est.velocidad_penalty != 0) {
                _p.velocidad += est.velocidad_penalty;
            }
            if (est.tipo == "debuff_defensa" && est.defensa_penalty != 0) {
                _p.defensa_bonus_temp += est.defensa_penalty;
            }
            if (est.tipo == "debuff_poder" && est.poder_penalty != 0) {
                _p.poder_elemental += est.poder_penalty;
            }
        }

        _p.estados[i] = est;
    }
}