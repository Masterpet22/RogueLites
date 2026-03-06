/// scr_crear_personaje_combate(nombre, es_jugador, clase, afinidad, arma, personalidad)
function scr_crear_personaje_combate(_nombre, _es_jugador, _clase, _afinidad, _arma, _personalidad) {

    var _clase_data     = scr_datos_clases(_clase);
    var _afinidad_data  = scr_datos_afinidades(_afinidad);
    var _arma_data      = scr_datos_armas(_arma);
    var _pers_data      = scr_datos_personalidades(_personalidad);

    // ===================================================================
    // Stats base de clase, modificados por personalidad
    // ===================================================================
    var _vida_max_base = round(_clase_data.vida * _pers_data.mult_vida);
    var _atq_base      = round(_clase_data.ataque * _pers_data.mult_ataque);
    var _def_base      = round(_clase_data.defensa * _pers_data.mult_defensa);
    var _defm_base     = round(_clase_data.defensa_magica * _pers_data.mult_defensa);
    var _vel_base      = round(_clase_data.velocidad * _pers_data.mult_velocidad);
    var _pelem_base    = round(_clase_data.poder_elemental * _pers_data.mult_poder_elemental);

    // ===================================================================
    // Construir array de habilidades:
    //   Slot 0  = habilidad fija de CLASE  (siempre presente)
    //   Slots 1-3 = habilidades de ARMA    (R1 da 1, R2 da 2, R3 da 3)
    //   Máximo 4 habilidades en total.
    // ===================================================================
    var _hab_clase = _clase_data.habilidad_fija;     // string
    var _hab_arma  = _arma_data.habilidades_arma;    // array

    var _habilidades = [_hab_clase];  // slot 0 siempre es la de clase

    var _max_arma = min(array_length(_hab_arma), 3); // máximo 3 del arma
    for (var _i = 0; _i < _max_arma; _i++) {
        array_push(_habilidades, _hab_arma[_i]);
    }

    var _cant_hab = array_length(_habilidades);
    var _hab_cd   = array_create(_cant_hab, 0);

    // ===================================================================
    // Buff de sinergia: si afinidad del arma == afinidad del personaje
    //   +15% a TODOS los bonus del arma (ATK, PODER, DEF, HP)
    // ===================================================================
    var _afinidad_arma = _arma_data.afinidad;
    var _sinergia = (_afinidad_arma == _afinidad);   // true/false
    var _mult_sin = _sinergia ? 1.15 : 1.0;

    // Bonus defensivos del arma (con fallback para armas sin el campo)
    var _def_arma = variable_struct_exists(_arma_data, "defensa_bonus") ? _arma_data.defensa_bonus : 0;
    var _hp_arma  = variable_struct_exists(_arma_data, "vida_bonus")    ? _arma_data.vida_bonus    : 0;

    var _atq_total   = _atq_base  + round(_arma_data.ataque_bonus * _mult_sin);
    var _pelem_total = _pelem_base + round(_arma_data.poder_elemental_bonus * _mult_sin);
    var _def_total   = _def_base  + round(_def_arma * _mult_sin);
    var _defm_total  = _defm_base + round(_def_arma * 0.5 * _mult_sin);
    var _vida_total  = _vida_max_base + round(_hp_arma * _mult_sin);

    var personaje = {
        nombre:         _nombre,
        es_jugador:     _es_jugador,

        clase:          _clase,
        afinidad:       _afinidad,
        afinidad_secundaria: "Neutra",
        arma:           _arma,
        personalidad:   _personalidad,

        clase_data:     _clase_data,
        afinidad_data:  _afinidad_data,
        arma_data:      _arma_data,
        pers_data:      _pers_data,

        sinergia_arma:  _sinergia,

        vida_max:       _vida_total,
        vida_actual:    _vida_total,
        vida_visual:    _vida_total,       // interpolación suave para barra de vida

        ataque_base:    _atq_total,
        defensa_base:   _def_total,
        defensa_magica_base: _defm_total,
        velocidad:      _vel_base,
        poder_elemental:_pelem_total,

        esencia:        0,
        esencia_llena:  100,

        // ── Sistema de Energía ──
        energia:           ENERGIA_MAX,
        energia_max:       ENERGIA_MAX,
        energia_agotamiento_timer: 0,
        energia_gastada_acum: 0,   // acumulador para generar esencia

        // ── Parry ──
        parry_estado:      "inactivo",  // inactivo | ventana | vulnerable
        parry_timer:       0,

        // ── GCD (Global Cooldown) ──
        gcd_timer:         0,

        // ── Daño Progresivo (Carga) ──
        carga_activa:      false,
        carga_indice:      -1,
        carga_timer:       0,
        carga_mult_temp:   1.0,
        carga_nivel_temp:  1,
        carga_drenaje_acum: 0,

        // ── Stun / Micro-stun ──
        stun_activo:       false,
        stun_timer:        0,
        stun_tipo:         "",
        micro_stun_timer:  0,

        // ── Tracking de habilidad actual ──
        hab_actual_id:     "",

		// Buffs / estados
        estados:             [],     // array de estados alterados
        defensa_bonus_temp:  0,
        defensa_magica_bonus_temp: 0,

        // Habilidades combinadas: [clase, arma1, arma2?, arma3?]
        habilidades_arma: _habilidades,   // array de IDs (slot 0 = clase)
        habilidades_cd:   _hab_cd,        // array de cooldowns

        // La habilidad básica es la de clase (slot 0)
        habilidad_basica: _hab_clase,

        // Cooldowns antiguos (puedes mantenerlos por compat)
        cooldowns: {
            ataque_basico: 0,
        },

        // Pasivas
        pasiva_activa: false,
        pasiva_timer: 0,
        pasiva_cooldown: 0,

        estado:         "normal",

        // ── Sprites individuales ──
        sprite_cuerpo:  scr_sprite_personaje(_nombre, false),
        sprite_rostro:  scr_sprite_personaje(_nombre, true),
    };

    return personaje;
}