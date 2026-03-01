/// scr_mecanicas_combate
/// Sistema de mecánicas especiales de combate para élites y jefes.
/// Cada enemigo puede tener un array "mecanicas" en sus datos.
///
/// Mecánicas soportadas:
///   "mec_ventana_invertida"        — Daño varía según estado IA del defensor
///   "mec_penalizacion_repeticion"  — Resistencia si repites la misma habilidad 3 veces
///   "mec_reflejo_diferido"         — 40% del daño en Esperando se devuelve al final de Atacando
///   "mec_escalado_vida_jugador"    — Daño del jefe escala según % vida del jugador
///   "mec_afinidad_reactiva"        — Reduce 60% daño del elemento más usado en últimos 6s
///   "mec_absorcion_esencia"        — Penaliza/beneficia según tier de esencia usada

// ══════════════════════════════════════════════════════════════
//  MACROS DE MECÁNICAS
// ══════════════════════════════════════════════════════════════
#macro MEC_VENTANA_ESPERANDO     0.50   // Daño recibido en Esperando (50%)
#macro MEC_VENTANA_PREPARANDO    1.00   // Daño recibido en Preparando (100%)
#macro MEC_VENTANA_ATACANDO      0.30   // Daño recibido en Atacando (30%)

#macro MEC_REPET_UMBRAL          3      // Repeticiones para activar penalización
#macro MEC_REPET_RESISTENCIA     0.25   // 25% resistencia permanente por stack

#macro MEC_REFLEJO_PCT           0.40   // 40% del daño se devuelve
#macro MEC_REFLEJO_MAX_ACUM      200    // Daño máximo acumulable para reflejo

#macro MEC_ESCVIDA_MAX_MULT      1.50   // Daño del jefe con jugador al 100% vida
#macro MEC_ESCVIDA_MIN_MULT      0.60   // Daño del jefe con jugador al 0% vida

#macro MEC_AFI_REACT_REDUCCION   0.60   // 60% reducción al elemento más golpeado
#macro MEC_AFI_REACT_VENTANA     360    // 6 segundos a 60fps
#macro MEC_AFI_REACT_OLVIDO      240    // 4 segundos sin daño para perder resistencia

#macro MEC_ABSORB_100_ROBO       0.30   // Roba 30% del daño como vida si esencia al 100%
#macro MEC_ABSORB_DEBUFF_MULT    1.20   // +20% daño recibido si esencia 50-75%
#macro MEC_ABSORB_DEBUFF_DUR     300    // 5 segundos a 60fps

// ══════════════════════════════════════════════════════════════
//  INICIALIZAR VARIABLES DE MECÁNICAS EN UN ENEMIGO
// ══════════════════════════════════════════════════════════════
/// @function scr_mec_inicializar(enemigo_struct, array_mecanicas)
function scr_mec_inicializar(_en, _mecs) {

    _en.mecanicas = _mecs;

    // --- Ventana Invertida ---
    // No necesita variables extra (usa ia_estado existente)

    // --- Penalización por Repetición ---
    _en.mec_repet_ultima_hab    = "";   // última habilidad usada por el jugador
    _en.mec_repet_contador      = 0;    // veces seguidas
    _en.mec_repet_resistencias  = {};   // struct { "nombre_hab": stacks }

    // --- Reflejo Diferido ---
    _en.mec_reflejo_acumulado   = 0;    // daño acumulado durante Esperando

    // --- Escalado por Vida del Jugador ---
    // No necesita variables extra (calcula en tiempo real)

    // --- Afinidad Reactiva ---
    _en.mec_afi_historial       = [];   // array de { afinidad, frame }
    _en.mec_afi_ultimo_dano_frame = 0;  // último frame en que recibió daño
    _en.mec_afi_resistida       = "";   // afinidad actualmente resistida

    // --- Absorción de Esencia ---
    _en.mec_absorb_debuff_timer = 0;    // timer del debuff +20% daño
}

// ══════════════════════════════════════════════════════════════
//  HELPER: ¿Tiene una mecánica específica?
// ══════════════════════════════════════════════════════════════
/// @function scr_mec_tiene(entidad, nombre_mecanica)
function scr_mec_tiene(_en, _mec) {
    if (!variable_struct_exists(_en, "mecanicas")) return false;
    if (!is_array(_en.mecanicas)) return false;
    for (var i = 0; i < array_length(_en.mecanicas); i++) {
        if (_en.mecanicas[i] == _mec) return true;
    }
    return false;
}

// ══════════════════════════════════════════════════════════════
//  MODIFICADOR DE DAÑO RECIBIDO POR EL ENEMIGO
//  Llamar desde scr_formula_dano DESPUÉS de calcular daño final
// ══════════════════════════════════════════════════════════════
/// @function scr_mec_modificar_dano_recibido(atacante, defensor, dano, afinidad_ataque)
/// @returns  daño modificado
function scr_mec_modificar_dano_recibido(_atk, _def, _dano, _afi_ataque) {

    if (!variable_struct_exists(_def, "mecanicas")) return _dano;

    var _d = _dano;

    // ─── Ventana Real Invertida ───
    if (scr_mec_tiene(_def, "mec_ventana_invertida")) {
        var _mult = 1.0;
        switch (_def.ia_estado) {
            case "ia_esperando":   _mult = MEC_VENTANA_ESPERANDO;  break;
            case "ia_preparando":  _mult = MEC_VENTANA_PREPARANDO; break;
            case "ia_atacando":    _mult = MEC_VENTANA_ATACANDO;   break;
        }
        _d = round(_d * _mult);
        if (_mult != 1.0) {
            show_debug_message("🛡 Ventana Invertida: daño ×" + string(_mult)
                + " (" + _def.ia_estado + ")");
        }
    }

    // ─── Penalización por Repetición ───
    if (scr_mec_tiene(_def, "mec_penalizacion_repeticion")) {
        // Verificar si hay resistencia acumulada contra esta habilidad
        if (variable_struct_exists(_def.mec_repet_resistencias, _afi_ataque)) {
            var _stacks = _def.mec_repet_resistencias[$ _afi_ataque];
            var _red = 1.0 - (_stacks * MEC_REPET_RESISTENCIA);
            _red = max(0.10, _red); // nunca menos de 10% de daño
            _d = round(_d * _red);
            show_debug_message("🔒 Repetición: " + _afi_ataque + " tiene "
                + string(_stacks) + " stacks → daño ×" + string(_red));
        }
    }

    // ─── Afinidad Reactiva ───
    if (scr_mec_tiene(_def, "mec_afinidad_reactiva")) {
        // Registrar este golpe en historial
        array_push(_def.mec_afi_historial, {
            afinidad: _afi_ataque,
            frame: _def.mec_afi_ultimo_dano_frame  // usamos frame counter del enemigo
        });
        _def.mec_afi_ultimo_dano_frame = 0; // reset — se incrementa en update

        // Calcular afinidad más usada en ventana
        var _conteos = {};
        var _ahora = 0; // frame 0 = ahora, contamos hacia atrás
        var _hist = _def.mec_afi_historial;
        // Limpiar entradas antiguas y contar
        var _nuevo_hist = [];
        for (var i = 0; i < array_length(_hist); i++) {
            // Solo entradas de los últimos MEC_AFI_REACT_VENTANA frames
            // Como usamos counter relativo, lo hacemos por edad
            if (i >= array_length(_hist) - 20) { // últimas 20 entradas máximo
                array_push(_nuevo_hist, _hist[i]);
                var _af = _hist[i].afinidad;
                if (variable_struct_exists(_conteos, _af)) {
                    _conteos[$ _af] += 1;
                } else {
                    _conteos[$ _af] = 1;
                }
            }
        }
        _def.mec_afi_historial = _nuevo_hist;

        // Encontrar la más golpeada
        var _max_count = 0;
        var _max_afi = "";
        var _keys = variable_struct_get_names(_conteos);
        for (var i = 0; i < array_length(_keys); i++) {
            if (_conteos[$ _keys[i]] > _max_count) {
                _max_count = _conteos[$ _keys[i]];
                _max_afi = _keys[i];
            }
        }

        if (_max_count >= 2 && _max_afi != "") {
            _def.mec_afi_resistida = _max_afi;
            if (_afi_ataque == _max_afi) {
                _d = round(_d * (1.0 - MEC_AFI_REACT_REDUCCION));
                show_debug_message("🌀 Afinidad Reactiva: " + _max_afi
                    + " resistida → daño ×" + string(1.0 - MEC_AFI_REACT_REDUCCION));
            }
        }
    }

    // ─── Absorción de Esencia (debuff activo: +20% daño) ───
    if (scr_mec_tiene(_def, "mec_absorcion_esencia")) {
        if (_def.mec_absorb_debuff_timer > 0) {
            _d = round(_d * MEC_ABSORB_DEBUFF_MULT);
            show_debug_message("💀 Absorción Esencia: debuff activo → daño ×"
                + string(MEC_ABSORB_DEBUFF_MULT));
        }
    }

    return max(1, _d);
}

// ══════════════════════════════════════════════════════════════
//  MODIFICADOR DE DAÑO INFLIGIDO POR EL ENEMIGO (al jugador)
//  Llamar desde scr_formula_dano cuando el atacante es enemigo
// ══════════════════════════════════════════════════════════════
/// @function scr_mec_modificar_dano_infligido(enemigo, jugador, dano)
/// @returns  daño modificado
function scr_mec_modificar_dano_infligido(_en, _jug, _dano) {

    if (!variable_struct_exists(_en, "mecanicas")) return _dano;

    var _d = _dano;

    // ─── Escalado por Vida del Jugador ───
    if (scr_mec_tiene(_en, "mec_escalado_vida_jugador")) {
        var _vida_pct = clamp(_jug.vida_actual / _jug.vida_max, 0, 1);
        // Interpolar: vida 100% → ×1.50, vida 0% → ×0.60
        var _mult = lerp(MEC_ESCVIDA_MIN_MULT, MEC_ESCVIDA_MAX_MULT, _vida_pct);
        _d = round(_d * _mult);
        show_debug_message("❤ Escalado Vida: jugador al " + string(round(_vida_pct * 100))
            + "% → daño ×" + string_format(_mult, 1, 2));
    }

    return max(1, _d);
}

// ══════════════════════════════════════════════════════════════
//  REGISTRAR HABILIDAD USADA (para Penalización por Repetición)
//  Llamar cada vez que el jugador usa una habilidad contra este enemigo
// ══════════════════════════════════════════════════════════════
/// @function scr_mec_registrar_habilidad(enemigo, nombre_habilidad)
function scr_mec_registrar_habilidad(_en, _hab) {

    if (!scr_mec_tiene(_en, "mec_penalizacion_repeticion")) return;

    if (_en.mec_repet_ultima_hab == _hab) {
        _en.mec_repet_contador += 1;
    } else {
        _en.mec_repet_ultima_hab = _hab;
        _en.mec_repet_contador = 1;
    }

    // Activar penalización
    if (_en.mec_repet_contador >= MEC_REPET_UMBRAL) {
        var _stacks_actual = 0;
        if (variable_struct_exists(_en.mec_repet_resistencias, _hab)) {
            _stacks_actual = _en.mec_repet_resistencias[$ _hab];
        }
        _en.mec_repet_resistencias[$ _hab] = _stacks_actual + 1;
        _en.mec_repet_contador = 0;

        show_debug_message("⚠ Repetición: " + _hab + " penalizada → stack "
            + string(_stacks_actual + 1));

        // Notificación visual
        scr_notif_agregar(_en.nombre, "¡Resistencia a " + _hab + "!", c_orange);
    }
}

// ══════════════════════════════════════════════════════════════
//  HOOK DE REFLEJO DIFERIDO — Acumular daño en Esperando
// ══════════════════════════════════════════════════════════════
/// @function scr_mec_reflejo_acumular(enemigo, dano_recibido)
function scr_mec_reflejo_acumular(_en, _dano) {

    if (!scr_mec_tiene(_en, "mec_reflejo_diferido")) return;
    if (_en.ia_estado != "ia_esperando") return;

    _en.mec_reflejo_acumulado = min(
        _en.mec_reflejo_acumulado + round(_dano * MEC_REFLEJO_PCT),
        MEC_REFLEJO_MAX_ACUM
    );

    show_debug_message("🪞 Reflejo: acumulado " + string(_en.mec_reflejo_acumulado)
        + " (máx " + string(MEC_REFLEJO_MAX_ACUM) + ")");
}

// ══════════════════════════════════════════════════════════════
//  HOOK DE REFLEJO DIFERIDO — Descargar al final de Atacando
//  Llamar desde la IA cuando pasa de ia_atacando → ia_esperando
// ══════════════════════════════════════════════════════════════
/// @function scr_mec_reflejo_descargar(enemigo, jugador)
function scr_mec_reflejo_descargar(_en, _jug) {

    if (!scr_mec_tiene(_en, "mec_reflejo_diferido")) return;
    if (_en.mec_reflejo_acumulado <= 0) return;

    var _reflejo = _en.mec_reflejo_acumulado;
    _jug.vida_actual = max(0, _jug.vida_actual - _reflejo);
    _en.mec_reflejo_acumulado = 0;

    show_debug_message("🪞💥 Reflejo descargado: " + string(_reflejo) + " daño al jugador");
    scr_notif_agregar(_en.nombre, "Reflejo: -" + string(_reflejo) + " HP", c_fuchsia);
}

// ══════════════════════════════════════════════════════════════
//  HOOK DE ABSORCIÓN DE ESENCIA
//  Llamar desde scr_ejecutar_super DESPUÉS de aplicar la súper del jugador
// ══════════════════════════════════════════════════════════════
/// @function scr_mec_absorcion_esencia(enemigo, jugador, tier_nombre, dano_total)
function scr_mec_absorcion_esencia(_en, _jug, _tier, _dano_total) {

    if (!scr_mec_tiene(_en, "mec_absorcion_esencia")) return;

    if (_tier == "100%") {
        // Esencia al 100% → el enemigo roba 30% del daño como vida
        var _robo = round(_dano_total * MEC_ABSORB_100_ROBO);
        _en.vida_actual = min(_en.vida_max, _en.vida_actual + _robo);
        show_debug_message("💚 Absorción: enemigo roba " + string(_robo) + " HP (esencia 100%)");
        scr_notif_agregar(_en.nombre, "¡Absorbe +" + string(_robo) + " HP!", make_color_rgb(0, 200, 80));
    } else {
        // Esencia 50% o 75% → el enemigo recibe debuff +20% daño
        _en.mec_absorb_debuff_timer = MEC_ABSORB_DEBUFF_DUR;
        show_debug_message("💀 Absorción: enemigo debuffed +" + string(round((MEC_ABSORB_DEBUFF_MULT - 1) * 100))
            + "% daño por " + string(MEC_ABSORB_DEBUFF_DUR / GAME_FPS) + "s (esencia " + _tier + ")");
        scr_notif_agregar(_en.nombre, "¡Vulnerable " + string(round(MEC_ABSORB_DEBUFF_DUR / GAME_FPS))
            + "s!", make_color_rgb(255, 100, 100));
    }
}

// ══════════════════════════════════════════════════════════════
//  ACTUALIZACIÓN PER-FRAME DE MECÁNICAS
//  Llamar desde obj_control_combate.Step
// ══════════════════════════════════════════════════════════════
/// @function scr_mec_actualizar(enemigo)
function scr_mec_actualizar(_en) {

    if (!variable_struct_exists(_en, "mecanicas")) return;

    // Afinidad Reactiva: incrementar contador de frames sin daño
    if (scr_mec_tiene(_en, "mec_afinidad_reactiva")) {
        _en.mec_afi_ultimo_dano_frame += 1;
        // Si no recibe daño por MEC_AFI_REACT_OLVIDO frames → pierde resistencia
        if (_en.mec_afi_ultimo_dano_frame >= MEC_AFI_REACT_OLVIDO) {
            if (_en.mec_afi_resistida != "") {
                show_debug_message("🌀 Afinidad Reactiva: resistencia a "
                    + _en.mec_afi_resistida + " expiró");
                _en.mec_afi_resistida = "";
                _en.mec_afi_historial = [];
            }
        }
    }

    // Absorción de Esencia: reducir timer de debuff
    if (scr_mec_tiene(_en, "mec_absorcion_esencia")) {
        if (_en.mec_absorb_debuff_timer > 0) {
            _en.mec_absorb_debuff_timer -= 1;
        }
    }
}

// ══════════════════════════════════════════════════════════════
//  OBTENER TEXTO DE MECÁNICAS ACTIVAS (para HUD)
// ══════════════════════════════════════════════════════════════
/// @function scr_mec_obtener_indicadores(enemigo)
/// @returns  array de { texto, color }
function scr_mec_obtener_indicadores(_en) {

    var _indicadores = [];
    if (!variable_struct_exists(_en, "mecanicas")) return _indicadores;

    // Ventana Invertida — mostrar multiplicador actual
    if (scr_mec_tiene(_en, "mec_ventana_invertida")) {
        var _msg = "";
        var _col = c_white;
        switch (_en.ia_estado) {
            case "ia_esperando":
                _msg = "Ventana: ×0.5 daño";
                _col = c_aqua;
                break;
            case "ia_preparando":
                _msg = "Ventana: ×1.0 daño";
                _col = c_lime;
                break;
            case "ia_atacando":
                _msg = "Ventana: ×0.3 daño";
                _col = c_red;
                break;
        }
        array_push(_indicadores, { texto: _msg, color: _col });
    }

    // Reflejo Diferido
    if (scr_mec_tiene(_en, "mec_reflejo_diferido")) {
        if (_en.mec_reflejo_acumulado > 0) {
            array_push(_indicadores, {
                texto: "Reflejo: " + string(_en.mec_reflejo_acumulado) + " acum.",
                color: c_fuchsia
            });
        }
    }

    // Escalado por Vida
    if (scr_mec_tiene(_en, "mec_escalado_vida_jugador")) {
        array_push(_indicadores, {
            texto: "Escala s/tu vida",
            color: make_color_rgb(255, 180, 80)
        });
    }

    // Afinidad Reactiva
    if (scr_mec_tiene(_en, "mec_afinidad_reactiva")) {
        if (_en.mec_afi_resistida != "") {
            array_push(_indicadores, {
                texto: "Resiste: " + _en.mec_afi_resistida + " (-60%)",
                color: make_color_rgb(100, 200, 255)
            });
        }
    }

    // Absorción de Esencia
    if (scr_mec_tiene(_en, "mec_absorcion_esencia")) {
        if (_en.mec_absorb_debuff_timer > 0) {
            var _secs = _en.mec_absorb_debuff_timer / GAME_FPS;
            array_push(_indicadores, {
                texto: "Vulnerable " + string_format(_secs, 1, 1) + "s",
                color: make_color_rgb(255, 100, 100)
            });
        } else {
            array_push(_indicadores, {
                texto: "Absorbe Esencia 100%",
                color: make_color_rgb(200, 80, 200)
            });
        }
    }

    // Penalización por Repetición
    if (scr_mec_tiene(_en, "mec_penalizacion_repeticion")) {
        var _keys = variable_struct_get_names(_en.mec_repet_resistencias);
        if (array_length(_keys) > 0) {
            var _txt = "Resiste:";
            for (var i = 0; i < array_length(_keys); i++) {
                _txt += " " + _keys[i] + "(×" + string(_en.mec_repet_resistencias[$ _keys[i]]) + ")";
            }
            array_push(_indicadores, { texto: _txt, color: c_orange });
        }
    }

    return _indicadores;
}
