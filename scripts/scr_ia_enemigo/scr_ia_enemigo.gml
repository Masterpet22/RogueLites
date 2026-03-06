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

    // ¿Este enemigo usa patrón secuencial? (jefes)
    var _usa_patron = variable_struct_exists(_en, "patron")
                      && is_array(_en.patron)
                      && array_length(_en.patron) > 0;

    switch (_en.ia_estado) {

        // =============================================
        //  ESTADO 1 — ESPERANDO (cooldown global)
        // =============================================
        case "ia_esperando":

            _en.ia_timer -= 1;

            if (_en.ia_timer <= 0) {

                if (_usa_patron) {
                    // ── Patrón secuencial (jefes) ──
                    // Leer la siguiente acción del patrón
                    var _hab_id = _en.patron[_en.p_index];
                    _en.ia_patron_hab = _hab_id;
                    _en.ia_hab_elegida = -1; // señal de que usamos patrón
                    _en.ia_prep_timer  = IA_PREP_FRAMES;
                    _en.ia_estado      = "ia_preparando";
                    show_debug_message("👑 " + _en.nombre + " prepara (patrón "
                        + string(_en.p_index) + "): " + _hab_id);
                } else {
                    // ── Selección por prioridad (comunes/élites) ──
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
                        _en.ia_hab_elegida = _elegida;
                        _en.ia_prep_timer  = IA_PREP_FRAMES;
                        _en.ia_estado      = "ia_preparando";
                        show_debug_message("⚔️ " + _en.nombre + " prepara: "
                            + string(_en.habilidades_arma[_elegida]));
                    } else {
                        _en.ia_timer = round(GAME_FPS * 0.25);
                    }
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

            if (_usa_patron) {
                // ── Ejecución por patrón ──
                var _hab_id = _en.ia_patron_hab;
                scr_ejecutar_habilidad(_en, _jug, _hab_id);
                show_debug_message("💥 " + _en.nombre + " ejecuta (patrón): " + _hab_id);

                // Avanzar índice del patrón (cíclico)
                _en.p_index = (_en.p_index + 1) mod array_length(_en.patron);
            } else {
                // ── Ejecución por prioridad ──
                var _idx = _en.ia_hab_elegida;
                if (_idx >= 0) {
                    scr_usar_habilidad_indice(_en, _jug, _idx);
                    show_debug_message("💥 " + _en.nombre + " usa: "
                        + string(_en.habilidades_arma[_idx]));
                }
            }

            // Mecánica: Reflejo Diferido — descargar daño acumulado al jugador
            scr_mec_reflejo_descargar(_en, _jug);

            // Volver a esperando con nuevo timer basado en velocidad
            _en.ia_hab_elegida = -1;
            _en.ia_timer       = scr_ia_calcular_espera(_en.velocidad);
            _en.ia_estado      = "ia_esperando";
            break;
    }
}
