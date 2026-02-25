/// scr_crear_personaje_combate(nombre, es_jugador, clase, afinidad, arma)
function scr_crear_personaje_combate(_nombre, _es_jugador, _clase, _afinidad, _arma) {

    var _clase_data     = scr_datos_clases(_clase);
    var _afinidad_data  = scr_datos_afinidades(_afinidad);
    var _arma_data      = scr_datos_armas(_arma);

    var _vida_max = _clase_data.vida;

    // Habilidades de arma (array)
    var _hab_arma = _arma_data.habilidades_arma;
    var _cant_hab = array_length(_hab_arma);

    // Array de cooldowns, mismo tamaño
    var _hab_cd = array_create(_cant_hab, 0);

    var personaje = {
        nombre:         _nombre,
        es_jugador:     _es_jugador,

        clase:          _clase,
        afinidad:       _afinidad,
        arma:           _arma,

        clase_data:     _clase_data,
        afinidad_data:  _afinidad_data,
        arma_data:      _arma_data,

        vida_max:       _vida_max,
        vida_actual:    _vida_max,

        ataque_base:    _clase_data.ataque + _arma_data.ataque_bonus,
        defensa_base:   _clase_data.defensa,
        velocidad:      _clase_data.velocidad,
        poder_elemental:_clase_data.poder_elemental + _arma_data.poder_elemental_bonus,

        esencia:        0,
        esencia_llena:  100,
		// Buffs / estados
        estados:             [],     // array de estados alterados
        defensa_bonus_temp:  0,

        // Habilidades de arma
        habilidades_arma: _hab_arma,   // array de IDs
        habilidades_cd:   _hab_cd,     // array de cooldowns

        // Para comodidad, la primera se considera “básica”
        habilidad_basica: (_cant_hab > 0) ? _hab_arma[0] : "",

        // Cooldowns antiguos (puedes mantenerlos por compat)
        cooldowns: {
            ataque_basico: 0,
        },

        // Pasivas
        pasiva_activa: false,
        pasiva_timer: 0,
        pasiva_cooldown: 0,

        estado:         "normal",
    };

    return personaje;
}