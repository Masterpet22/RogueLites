/// @function scr_ia_calcular_espera(velocidad)
/// @description  Calcula frames de espera entre acciones según velocidad del enemigo.
///   Más velocidad → menos espera.  Incluye ±variación aleatoria.
function scr_ia_calcular_espera(_vel) {
    var _base = IA_ACCION_BASE_FRAMES / (1 + _vel * IA_VEL_FACTOR);
    // Variación aleatoria para que no sea robótico
    var _var = _base * IA_VARIACION;
    return round(_base + random_range(-_var, _var));
}


/// @function scr_ia_enemigo(enemigo, jugador)
/// @description  Máquina de estados de la IA enemiga.
///   Llamar una vez por frame desde obj_control_combate.Step.
///
///   Estados:
///     "ia_esperando"   – cuenta regresiva; al llegar a 0 elige habilidad y pasa a preparando.
///     "ia_preparando"  – wind-up visible; al terminar ejecuta la habilidad.
///     "ia_atacando"    – frame de ejecución; aplica daño y vuelve a esperando.
function scr_ia_enemigo(_en, _jug) {

    // Seguridad: ambos deben estar vivos
    if (_en.vida_actual <= 0 || _jug.vida_actual <= 0) return;

    switch (_en.ia_estado) {

        // =============================================
        //  ESTADO 1 — ESPERANDO (cooldown global)
        // =============================================
        case "ia_esperando":

            _en.ia_timer -= 1;

            if (_en.ia_timer <= 0) {

                // Elegir la mejor habilidad disponible (prioridad: mayor índice)
                var _habs = _en.habilidades_arma;
                var _cds  = _en.habilidades_cd;
                var _n    = array_length(_habs);
                var _elegida = -1;

                for (var i = _n - 1; i >= 0; i--) {
                    if (_cds[i] <= 0) {
                        _elegida = i;
                        break;
                    }
                }

                if (_elegida >= 0) {
                    // Tiene habilidad lista → pasar a preparar
                    _en.ia_hab_elegida = _elegida;
                    _en.ia_prep_timer  = IA_PREP_FRAMES;
                    _en.ia_estado      = "ia_preparando";
                    show_debug_message("⚔️ " + _en.nombre + " prepara: "
                        + string(_en.habilidades_arma[_elegida]));
                } else {
                    // Ninguna habilidad disponible → esperar un poco más
                    _en.ia_timer = round(GAME_FPS * 0.25);
                }
            }
            break;

        // =============================================
        //  ESTADO 2 — PREPARANDO (wind-up)
        // =============================================
        case "ia_preparando":

            _en.ia_prep_timer -= 1;

            if (_en.ia_prep_timer <= 0) {
                _en.ia_estado = "ia_atacando";
            }
            break;

        // =============================================
        //  ESTADO 3 — ATACANDO (ejecución)
        // =============================================
        case "ia_atacando":

            // Ejecutar la habilidad elegida
            if (_en.ia_hab_elegida >= 0) {
                scr_usar_habilidad_indice(_en, _jug, _en.ia_hab_elegida);
                show_debug_message("💥 " + _en.nombre + " usa: "
                    + string(_en.habilidades_arma[_en.ia_hab_elegida]));
            }

            // Volver a esperando con nuevo timer basado en velocidad
            _en.ia_hab_elegida = -1;
            _en.ia_timer       = scr_ia_calcular_espera(_en.velocidad);
            _en.ia_estado      = "ia_esperando";
            break;
    }
}
