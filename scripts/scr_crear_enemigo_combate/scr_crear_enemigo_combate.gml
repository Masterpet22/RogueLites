/// scr_crear_enemigo_combate(nombre_enemigo)
function scr_crear_enemigo_combate(_nombre_enemigo) {

    var _data_enemigo  = scr_datos_enemigos(_nombre_enemigo);

    // Detectar afinidad dual (jefes: "Fuego-Tierra" → separar)
    var _afi_raw = _data_enemigo.afinidad;
    var _afi_primaria   = _afi_raw;
    var _afi_secundaria = "none";

    var _sep = string_pos("-", _afi_raw);
    if (_sep > 0) {
        _afi_primaria   = string_copy(_afi_raw, 1, _sep - 1);
        _afi_secundaria = string_delete(_afi_raw, 1, _sep);
    }

    var _afinidad_data  = scr_datos_afinidades(_afi_primaria);
    var _afinidad_data2 = (_afi_secundaria != "none") ? scr_datos_afinidades(_afi_secundaria) : undefined;

    // Determinar rango del enemigo según sus datos
    var _rango = "Común";
    if (variable_struct_exists(_data_enemigo, "patron")) {
        _rango = "Jefe";
    } else if (variable_struct_exists(_data_enemigo, "habilidad_secundaria")) {
        _rango = "Elite";
    }

    // Leer velocidad y poder elemental desde datos (fallback si no existen)
    var _vel  = (variable_struct_exists(_data_enemigo, "velocidad")       ? _data_enemigo.velocidad       : 4);
    var _pow  = (variable_struct_exists(_data_enemigo, "poder_elemental") ? _data_enemigo.poder_elemental : 5);

    // Construir array de habilidades dinámicamente
    var _habs = ["ataque_basico", _data_enemigo.habilidad_fija];
    var _cds  = [0, 0];
    if (variable_struct_exists(_data_enemigo, "habilidad_secundaria")) {
        array_push(_habs, _data_enemigo.habilidad_secundaria);
        array_push(_cds, 0);
    }

    var enemigo = {
        nombre:         _nombre_enemigo,
        es_jugador:     false,

        clase:          "Enemigo",
        rango:          _rango,
        afinidad:       _afi_primaria,
        afinidad_secundaria: _afi_secundaria,
        arma:           undefined,

        clase_data:     undefined,
        afinidad_data:  _afinidad_data,
        afinidad_data2: _afinidad_data2,
        arma_data:      undefined,

        vida_max:       _data_enemigo.vida,
        vida_actual:    _data_enemigo.vida,
        ataque_base:    _data_enemigo.ataque,
        defensa_base:   _data_enemigo.defensa,
        defensa_magica_base: _data_enemigo.defensa_magica,
        velocidad:      _vel,
        poder_elemental:_pow,

        esencia:        0,
        esencia_llena:  100,
		habilidades_arma: _habs,
		habilidades_cd:   _cds,

        material_drop:  _data_enemigo.drops,  // Array de drops con probabilidades

        // Recompensa de oro al derrotar
        oro_min: variable_struct_exists(_data_enemigo, "oro_min") ? _data_enemigo.oro_min : 10,
        oro_max: variable_struct_exists(_data_enemigo, "oro_max") ? _data_enemigo.oro_max : 25,

        // Para futuro por si queremos algo especial
        habilidad_fija: _data_enemigo.habilidad_fija,

        // Por ahora el enemigo usará el mismo ID simple que el jugador
        habilidad_basica: "ataque_basico",
		// PASIVAS DE AFINIDAD
		pasiva_activa: false,
		pasiva_timer: 0,
		pasiva_cooldown: 0,
		// Buffs / estados
        estados:             [],     // array de estados alterados
        defensa_bonus_temp:  0,
        defensa_magica_bonus_temp: 0,

        cooldowns: {
            ataque_basico: 0,
        },

        estado:         "normal",

        // ── Sprites individuales ──
        sprite_cuerpo:  scr_sprite_enemigo(_nombre_enemigo, _rango, false),
        sprite_rostro:  scr_sprite_enemigo(_nombre_enemigo, _rango, true),

        // ── Datos de recolor élite (undefined si no es élite o no necesita recolor) ──
        recolor_elite:  (_rango == "Elite") ? scr_recolor_elite_datos(_nombre_enemigo) : undefined,

        // ── Datos de FX visual de jefe (undefined si no es jefe) ──
        fx_jefe:        (_rango == "Jefe") ? scr_fx_jefe_datos(_nombre_enemigo) : undefined,

        // ── Máquina de estados IA ──
        ia_estado:        "ia_esperando",       // ia_esperando | ia_preparando | ia_atacando
        ia_timer:         scr_ia_calcular_espera(_vel),  // frames hasta próxima acción
        ia_prep_timer:    0,                     // frames de wind-up restantes
        ia_hab_elegida:   -1,                    // índice de habilidad elegida en preparación
        ia_patron_hab:    "",                    // ID de habilidad elegida por patrón

        // ── Timer de combate (para logros/tracking) ──
        combate_timer:    0,                     // frames transcurridos (se incrementa en Step)
        timer_limite:     variable_struct_exists(_data_enemigo, "timer_limite")
                          ? _data_enemigo.timer_limite : 0,  // 0 = sin límite
    };

    // ── Inicializar patrón secuencial (jefes) ──
    if (variable_struct_exists(_data_enemigo, "patron") && is_array(_data_enemigo.patron)) {
        enemigo.patron  = _data_enemigo.patron;
        enemigo.p_index = 0;
    }

    // ── Inicializar mecánicas especiales ──
    var _mecs = variable_struct_exists(_data_enemigo, "mecanicas") ? _data_enemigo.mecanicas : [];
    scr_mec_inicializar(enemigo, _mecs);

    return enemigo;
}