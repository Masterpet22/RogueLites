/// STEP - obj_control_combate

// Si el combate terminó
if (combate_terminado)
{
    // Actualizar secuencia dramática de fin de combate
    scr_fin_combate_actualizar();

    // Bloquear input durante la secuencia dramática
    if (fin_dramatico_timer > 0 || fin_hitstop_timer > 0) { exit; }

    // Fase 1: Diálogo post-combate — esperar Enter para mostrar resultados
    if (fin_fase == 1) {
        if (keyboard_check_pressed(vk_enter)) {
            fin_fase = 2;
            // Restaurar foco para mostrar resultados limpios
            foco_quien       = 0;
            foco_escala_obj  = 1.0;
            foco_dim_obj     = 1.0;
            foco_offset_pj_x_obj = 0;
            foco_offset_en_x_obj = 0;
        }
        exit;
    }

    // Determinar si estamos en modo especial (torre o camino)
    var _es_torre = (instance_exists(obj_control_juego)
        && variable_struct_exists(obj_control_juego, "modo_torre")
        && obj_control_juego.modo_torre);
    var _es_camino = (instance_exists(obj_control_juego)
        && variable_struct_exists(obj_control_juego, "modo_camino")
        && obj_control_juego.modo_camino);

    if (_es_torre || _es_camino) {
        // MODO TORRE / CAMINO: confirmar con Enter/Escape (flujo original)
        if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_escape)) {
            if (_es_torre && instance_exists(obj_control_torre)) {
                with (obj_control_torre) {
                    scr_torre_post_combate(other.ganador, other.personaje_jugador, other.oro_recompensa);
                }
            } else if (_es_camino && instance_exists(obj_control_camino)) {
                with (obj_control_camino) {
                    scr_camino_post_combate(other.ganador, other.personaje_jugador, other.oro_recompensa);
                }
            }
        }
    } else {
        // MODO COMBATE NORMAL: menú de opciones (Repetir / Selección / Menú)
        if (instance_exists(obj_control_ui_combate)) {
            // Navegación
            if (keyboard_check_pressed(vk_up)) {
                obj_control_ui_combate.postcombate_opcion = max(0, obj_control_ui_combate.postcombate_opcion - 1);
            }
            if (keyboard_check_pressed(vk_down)) {
                obj_control_ui_combate.postcombate_opcion = min(2, obj_control_ui_combate.postcombate_opcion + 1);
            }

            // Confirmar
            if (keyboard_check_pressed(vk_enter)) {
                switch (obj_control_ui_combate.postcombate_opcion) {
                    case 0: // Repetir combate (revancha)
                        if (instance_exists(obj_control_juego)) {
                            obj_control_juego.combate_arena_revancha = combate_arena_idx;
                        }
                        scr_transicion_ir(rm_combate);
                        break;
                    case 1: // Volver a selección de personaje
                        scr_transicion_ir(rm_select);
                        break;
                    case 2: // Volver al menú principal
                        scr_transicion_ir(rm_menu);
                        break;
                }
            }
            // Escape = volver al menú directamente
            if (keyboard_check_pressed(vk_escape)) {
                scr_transicion_ir(rm_menu);
            }
        }
    }
    exit;
}

// ── PAUSADO: no actualizar nada ──
if (instance_exists(obj_control_ui_combate) && obj_control_ui_combate.pausado) {
    exit;
}

// ── DIÁLOGOS PRE-COMBATE: bloquear combate mientras estén activos ──
if (scr_dialogos_actualizar()) {
    // Solo actualizar FX visuales durante diálogos
    scr_fx_zoom_actualizar();
    scr_fx_particulas_actualizar();
    exit;
}

// 1. Actualizar personajes (cooldowns, etc.)
scr_actualizar_personaje(personaje_jugador);
scr_actualizar_personaje(personaje_enemigo);
scr_actualizar_pasivas(personaje_jugador);
scr_actualizar_pasivas(personaje_enemigo);
scr_actualizar_estados(personaje_jugador);
scr_actualizar_estados(personaje_enemigo);

// Actualizar combo timers
if (personaje_jugador.combo_timer > 0) {
    personaje_jugador.combo_timer--;
    if (personaje_jugador.combo_timer <= 0) personaje_jugador.combo_contador = 0;
}
if (personaje_enemigo.combo_timer > 0) {
    personaje_enemigo.combo_timer--;
    if (personaje_enemigo.combo_timer <= 0) personaje_enemigo.combo_contador = 0;
}

// Actualizar barks de combate
scr_barks_actualizar();

// Reducir timer del enemigo manualmente si no se hace en scr_actualizar
// (Ya no se necesita — los CDs del enemigo los gestiona scr_actualizar_personaje)


// 2. Input del jugador
/// STEP — obj_control_combate

// ... al principio ya tienes checks de combate_terminado, actualización, etc.

// Helper local para ejecutar habilidad por índice (LEGACY — ya no se usa directamente)
function usar_habilidad_indice(_indice) {

    var habs = personaje_jugador.habilidades_arma;
    var cds  = personaje_jugador.habilidades_cd;

    if (!is_array(habs)) return;
    var n = array_length(habs);
    if (_indice < 0 || _indice >= n) return; // no existe esa habilidad

    // Chequear cooldown
    if (cds[_indice] > 0) return;

    var id_hab = habs[_indice];

    // Ejecutar
    scr_ejecutar_habilidad(personaje_jugador, personaje_enemigo, id_hab);

    // Cooldown simple: 0.5 s para todo (luego lo afinamos por habilidad)
    cds[_indice] = round(GAME_FPS * 0.5);
}


// ══════════════════════════════════════════════════════════════
//  PARRY → Spacebar
// ══════════════════════════════════════════════════════════════
if (keyboard_check_pressed(vk_space)) {
    scr_parry_intentar(personaje_jugador);
}

// ══════════════════════════════════════════════════════════════
//  MICRO-STUN CHECK: si el jugador está en micro-stun, no puede actuar
// ══════════════════════════════════════════════════════════════
var _puede_actuar = scr_jugador_puede_actuar(personaje_jugador);

// ══════════════════════════════════════════════════════════════
//  CARGA PROGRESIVA: Liberar tecla → disparar carga
// ══════════════════════════════════════════════════════════════
if (personaje_jugador.carga_activa && _puede_actuar) {
    var _carga_key = -1;
    switch (personaje_jugador.carga_indice) {
        case 0: _carga_key = ord("Q"); break;
        case 1: _carga_key = ord("W"); break;
        case 2: _carga_key = ord("E"); break;
        case 3: _carga_key = ord("R"); break;
    }
    // Si soltó la tecla → disparar
    if (_carga_key != -1 && keyboard_check_released(_carga_key)) {
        scr_carga_disparar(personaje_jugador);
    }
}


// INPUT HABILIDADES JUGADOR
if (_puede_actuar && !personaje_jugador.carga_activa) {

    // Slot 0 (Clase) → Q — mantener para carga o toque rápido
    if (keyboard_check_pressed(ord("Q"))) {
        var _hab_q = personaje_jugador.habilidades_arma[0];
        if (scr_carga_es_cargable(_hab_q)) {
            scr_carga_iniciar(personaje_jugador, 0);
        } else {
            scr_usar_habilidad_indice(personaje_jugador, personaje_enemigo, 0);
        }
    }

    // Slot 1 (Arma hab 1) → W — siempre toque rápido (R1 no carga)
    if (keyboard_check_pressed(ord("W"))) {
        scr_usar_habilidad_indice(personaje_jugador, personaje_enemigo, 1);
    }

    // Slot 2 (Arma hab 2, R2+) → E — mantener para carga
    if (keyboard_check_pressed(ord("E"))) {
        if (array_length(personaje_jugador.habilidades_arma) > 2) {
            var _hab_e = personaje_jugador.habilidades_arma[2];
            if (scr_carga_es_cargable(_hab_e)) {
                scr_carga_iniciar(personaje_jugador, 2);
            } else {
                scr_usar_habilidad_indice(personaje_jugador, personaje_enemigo, 2);
            }
        }
    }

    // Slot 3 (Arma hab 3, R3) → R — mantener para carga
    if (keyboard_check_pressed(ord("R"))) {
        if (array_length(personaje_jugador.habilidades_arma) > 3) {
            var _hab_r = personaje_jugador.habilidades_arma[3];
            if (scr_carga_es_cargable(_hab_r)) {
                scr_carga_iniciar(personaje_jugador, 3);
            } else {
                scr_usar_habilidad_indice(personaje_jugador, personaje_enemigo, 3);
            }
        }
    }

} else if (personaje_jugador.carga_activa) {
    // Si está cargando y presiona Parry → prioridad defensa (ya gestionado en scr_parry_intentar)
}

// SÚPER-HABILIDAD → TAB (requiere al menos 50% de esencia)
if (_puede_actuar && keyboard_check_pressed(vk_tab)) {
    // Chequear GCD y Parry antes del Súper
    if (personaje_jugador.gcd_timer > 0 || !scr_parry_puede_actuar(personaje_jugador)) {
        // Bloqueado por GCD o Parry
    } else if (personaje_jugador.carga_activa) {
        // No se puede usar Súper mientras carga
    } else if (personaje_jugador.esencia >= personaje_jugador.esencia_llena * 0.5) {
        scr_ejecutar_super(personaje_jugador, personaje_enemigo);
        // Activar GCD tras usar Súper
        personaje_jugador.gcd_timer = round(GAME_FPS * GCD_DURACION_SEG);
    } else {
        // Feedback: no hay suficiente esencia
        if (instance_exists(obj_control_ui_combate)) {
            obj_control_ui_combate.super_deny_timer = 25; // ~0.4 segundos de feedback
        }
        var _pct_actual = round((personaje_jugador.esencia / max(1, personaje_jugador.esencia_llena)) * 100);
        scr_notif_agregar(personaje_jugador.nombre, "Esencia insuficiente (" + string(_pct_actual) + "%)", c_red);
    }
}

// OBJETOS EQUIPADOS → teclas 1, 2, 3
if (_puede_actuar) {
    if (keyboard_check_pressed(ord("1"))) {
        scr_usar_objeto_combate(0);
    }
    if (keyboard_check_pressed(ord("2"))) {
        scr_usar_objeto_combate(1);
    }
    if (keyboard_check_pressed(ord("3"))) {
        scr_usar_objeto_combate(2);
    }
}


// 3. IA del enemigo — Máquina de estados (esperando → preparando → atacando)
// Si el enemigo está stunned, no ejecutar IA
if (!scr_esta_stunned(personaje_enemigo)) {
    scr_ia_enemigo(personaje_enemigo, personaje_jugador);
}

// 3b. Actualizar mecánicas especiales del enemigo
scr_mec_actualizar(personaje_enemigo);

// 3c. Timer de combate (tracking para logros)
personaje_enemigo.combate_timer += 1;

// 3d. Actualizar notificaciones
scr_notif_actualizar();

// 3e. Actualizar feedback visual (números flotantes, shake, flash, tracking de vida)
scr_feedback_actualizar();

// 3f. Actualizar FX de impacto (zoom de cámara + partículas)
scr_fx_zoom_actualizar();
scr_fx_particulas_actualizar();


// 4. Comprobar fin de combate

// ─── Runa del Último Aliento: sobrevivir un golpe letal (una vez) ───
if (personaje_jugador.vida_actual <= 0 && runa_ultimo_aliento_disponible) {
    personaje_jugador.vida_actual = 1;
    runa_ultimo_aliento_disponible = false;
    scr_notif_agregar("Jugador", "¡Último Aliento! Sobrevive con 1 HP", c_purple);
}

// ─── Runa Vampírica: 15% lifesteal del daño infligido ───
// Se procesa cada frame comparando vida previa del enemigo
if (runa_vampirica && variable_struct_exists(personaje_enemigo, "vida_prev_runa")) {
    var _dano_hecho = personaje_enemigo.vida_prev_runa - personaje_enemigo.vida_actual;
    if (_dano_hecho > 0) {
        var _heal = max(1, round(_dano_hecho * 0.15));
        personaje_jugador.vida_actual = min(personaje_jugador.vida_actual + _heal, personaje_jugador.vida_max);
    }
}
// Guardar vida previa del enemigo para siguiente frame
personaje_enemigo.vida_prev_runa = personaje_enemigo.vida_actual;

if (personaje_jugador.vida_actual <= 0 || personaje_enemigo.vida_actual <= 0) {

    if (!combate_terminado) { // Para que solo entre una vez
        combate_terminado = true;

        // --- CONSUMIR OBJETOS EQUIPADOS DEL INVENTARIO ---
        if (instance_exists(obj_control_juego) && is_array(objetos_equipados)) {
            var _es_torre = (variable_struct_exists(obj_control_juego, "modo_torre") && obj_control_juego.modo_torre);
            var _es_camino = (variable_struct_exists(obj_control_juego, "modo_camino") && obj_control_juego.modo_camino);
            for (var i = 0; i < array_length(objetos_equipados); i++) {
                var _obj_eq = objetos_equipados[i];
                if (_obj_eq != "" && _obj_eq != undefined) {
                    if (_es_torre || _es_camino) {
                        // Torre/Camino: solo consumir los que se usaron
                        if (is_array(objetos_usados) && objetos_usados[i]) {
                            scr_inventario_agregar_objeto(obj_control_juego, _obj_eq, -1);
                        }
                    } else {
                        // Modo normal: siempre se consumen
                        scr_inventario_agregar_objeto(obj_control_juego, _obj_eq, -1);
                    }
                }
            }
            show_debug_message("Objetos consumidos tras combate: " + string(objetos_equipados));
        }

        // --- CONSUMIR RUNA EQUIPADA DEL INVENTARIO ---
        if (runa_activa != "" && instance_exists(obj_control_juego)) {
            scr_inventario_agregar_objeto(obj_control_juego, runa_activa, -1);
            show_debug_message("Runa consumida tras combate: " + runa_activa);
            obj_control_juego.runa_equipada = "";
        }

        if (personaje_jugador.vida_actual <= 0 && personaje_enemigo.vida_actual <= 0) {
            ganador = "Empate";
        }
        else if (personaje_enemigo.vida_actual <= 0) {
            ganador = "Jugador";

            // --- RECOMPENSA CON PROBABILIDADES ---
            if (instance_exists(obj_control_juego)) {

                var _drops = personaje_enemigo.material_drop; // Array de { material, cant_min, cant_max, chance }
                var _log = "";

                for (var i = 0; i < array_length(_drops); i++) {
                    var _d = _drops[i];
                    var _roll = irandom(99); // 0–99

                    if (_roll < _d.chance) {
                        var _cant = irandom_range(_d.cant_min, _d.cant_max);
                        scr_inventario_agregar_material(obj_control_juego, _d.material, _cant);
                        _log += string(_cant) + "x " + _d.material + "  ";
                    }
                }

                // --- RECOMPENSA DE ORO ---
                var _oro_min = variable_struct_exists(personaje_enemigo, "oro_min") ? personaje_enemigo.oro_min : 10;
                var _oro_max = variable_struct_exists(personaje_enemigo, "oro_max") ? personaje_enemigo.oro_max : 25;
                var _oro_ganado = irandom_range(_oro_min, _oro_max);

                // MODO TORRE: aplicar multiplicador de oro
                if (variable_struct_exists(obj_control_juego, "modo_torre") && obj_control_juego.modo_torre) {
                    _oro_ganado = round(_oro_ganado * obj_control_juego.torre_oro_mult);
                }

                // MODO CAMINO: aplicar multiplicador de oro
                if (variable_struct_exists(obj_control_juego, "modo_camino") && obj_control_juego.modo_camino) {
                    _oro_ganado = round(_oro_ganado * obj_control_juego.camino_oro_mult);
                }

                obj_control_juego.oro += _oro_ganado;
                oro_recompensa = _oro_ganado;  // guardamos para mostrar en UI
                _log += " | +" + string(_oro_ganado) + " oro";

                if (_log == "") _log = "(nada extra)";
                show_debug_message("¡Ganaste! Drops: " + _log);

            } else {
                show_debug_message("ERROR: No se encontró obj_control_juego para dar la recompensa.");
            }
        }
        else {
            ganador = "Enemigo";
        }

        show_debug_message("Combate terminado. Ganador: " + ganador);

        // Activar secuencia dramática (zoom, flash, hitstop)
        scr_fin_combate_activar(ganador);
    }
}