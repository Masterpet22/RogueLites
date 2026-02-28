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

    var enemigo = {
        nombre:         _nombre_enemigo,
        es_jugador:     false,

        clase:          "Enemigo",
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
        velocidad:      4,
        poder_elemental:5,

        esencia:        0,
        esencia_llena:  100,
		habilidades_arma: ["ataque_basico"],   // 1 habilidad, la básica
		habilidades_cd:   [0],                // cooldown correspondiente

        material_drop:  _data_enemigo.drops,  // Array de drops con probabilidades

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
    };

    return enemigo;
}