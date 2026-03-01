/// @function scr_datos_torre()
/// @description Retorna toda la configuración del Modo Torre: alas, dificultades, pools de enemigos.

// ═══════════════════════════════════════════════════════════════
//  CONFIGURACIÓN DEL MODO TORRE
// ═══════════════════════════════════════════════════════════════

/// @function scr_torre_get_alas()
/// @description Retorna array con las 3 alas disponibles
function scr_torre_get_alas() {
    return [
        {
            id: "oeste",
            nombre: "Ala Oeste",
            subtitulo: "Naturaleza Bruta",
            descripcion: "Enemigos de Fuego, Tierra y Planta acechan en los pasillos volcánicos.",
            color: make_color_rgb(200, 80, 40),
            afinidades: ["Fuego", "Tierra", "Planta"],
            enemigos_comunes: ["Soldado Igneo", "Guardian Terracota", "Halito Verde"],
            enemigos_elite:   ["Soldado Igneo Elite", "Guardian Terracota Elite", "Halito Verde Elite"],
            jefe_final:       "Titan de las Forjas Rotas",
        },
        {
            id: "este",
            nombre: "Ala Este",
            subtitulo: "Elementos Etéreos",
            descripcion: "Corrientes de rayo, mareas y sombras se entrelazan en este ala mística.",
            color: make_color_rgb(60, 140, 220),
            afinidades: ["Rayo", "Agua", "Sombra"],
            enemigos_comunes: ["Bestia Tronadora", "Vigia Boreal", "Naufrago de la Oscuridad"],
            enemigos_elite:   ["Bestia Tronadora Elite", "Vigia Boreal Elite", "Naufrago de la Oscuridad Elite"],
            jefe_final:       "Sentinela del Cielo Roto",
        },
        {
            id: "central",
            nombre: "Ala Central",
            subtitulo: "Convergencia",
            descripcion: "La Torre Central reúne lo sagrado y lo arcano. Solo los más fuertes llegan al final.",
            color: make_color_rgb(180, 150, 255),
            afinidades: ["Luz", "Arcano"],
            enemigos_comunes: ["Paladin Marchito", "Errante Runico"],
            enemigos_elite:   ["Paladin Marchito Elite", "Errante Runico Elite"],
            jefe_final:       "Oraculo Quebrado del Abismo",
        },
    ];
}

/// @function scr_torre_get_dificultades()
/// @description Retorna array con las 3 dificultades del modo torre
function scr_torre_get_dificultades() {
    return [
        {
            id: "facil",
            nombre: "Normal",
            color: c_lime,
            pisos_total:      10,
            tienda_cada:      3,     // tienda después del piso 3, 6, 9
            hp_bonus_pct:     0,     // +0% HP enemigos
            oro_bonus_pct:    10,    // +10% oro ganado
            usa_elites:       false,
            tiene_jefe_final: false,
        },
        {
            id: "media",
            nombre: "Difícil",
            color: c_orange,
            pisos_total:      14,
            tienda_cada:      4,     // tienda después del piso 4, 8, 12
            hp_bonus_pct:     25,    // +25% HP enemigos
            oro_bonus_pct:    0,
            usa_elites:       true,
            tiene_jefe_final: false,
        },
        {
            id: "dificil",
            nombre: "Extremo",
            color: c_red,
            pisos_total:      18,
            tienda_cada:      5,     // tienda después del piso 5, 10, 15
            hp_bonus_pct:     50,    // +50% HP enemigos
            oro_bonus_pct:    -15,   // -15% oro pero más drops
            usa_elites:       true,
            tiene_jefe_final: true,  // jefe en el último piso
        },
    ];
}

/// @function scr_torre_generar_piso(_ala, _dificultad, _piso_actual)
/// @description Genera el enemigo para un piso dado
/// @param {struct} _ala       Struct del ala (de scr_torre_get_alas)
/// @param {struct} _dificultad Struct de dificultad (de scr_torre_get_dificultades)
/// @param {int}    _piso_actual Número del piso (1-based)
/// @returns {struct} { nombre_enemigo, hp_mult, oro_mult, es_jefe, es_elite }
function scr_torre_generar_piso(_ala, _dificultad, _piso_actual) {

    var _total = _dificultad.pisos_total;
    var _es_ultimo = (_piso_actual == _total);
    var _es_jefe = (_es_ultimo && _dificultad.tiene_jefe_final);

    // Jefe final del ala
    if (_es_jefe) {
        return {
            nombre_enemigo: _ala.jefe_final,
            hp_mult:        1 + (_dificultad.hp_bonus_pct / 100),
            oro_mult:       1 + (_dificultad.oro_bonus_pct / 100),
            es_jefe:        true,
            es_elite:       false,
        };
    }

    // Decidir si es elite (solo en dificultades que usan elites)
    var _es_elite = false;
    if (_dificultad.usa_elites) {
        // Probabilidad de elite aumenta con el piso
        var _prob_elite = 10 + (_piso_actual / _total) * 40; // 10% al inicio, ~50% al final
        if (irandom(99) < _prob_elite) {
            _es_elite = true;
        }
    }

    // Elegir enemigo aleatorio de la pool correspondiente
    var _pool = _es_elite ? _ala.enemigos_elite : _ala.enemigos_comunes;
    var _idx = irandom(array_length(_pool) - 1);
    var _nombre = _pool[_idx];

    return {
        nombre_enemigo: _nombre,
        hp_mult:        1 + (_dificultad.hp_bonus_pct / 100),
        oro_mult:       1 + (_dificultad.oro_bonus_pct / 100),
        es_jefe:        false,
        es_elite:       _es_elite,
    };
}

/// @function scr_torre_es_piso_tienda(_dificultad, _piso_actual)
/// @description Retorna si después de este piso hay tienda
function scr_torre_es_piso_tienda(_dificultad, _piso_actual) {
    // No hay tienda después del último piso
    if (_piso_actual >= _dificultad.pisos_total) return false;
    return (_piso_actual mod _dificultad.tienda_cada == 0);
}

/// @function scr_torre_recompensa_completar(_ala, _dificultad)
/// @description Recompensa bonus por completar un ala completa
function scr_torre_recompensa_completar(_ala, _dificultad) {
    var _oro_base = 0;
    switch (_dificultad.id) {
        case "facil":   _oro_base = 150; break;
        case "media":   _oro_base = 350; break;
        case "dificil": _oro_base = 600; break;
    }

    return {
        oro: _oro_base,
        texto: "¡Ala " + _ala.nombre + " completada! +" + string(_oro_base) + " oro",
    };
}

/// @function scr_torre_catalogo_tienda_piso(_piso, _total)
/// @description Retorna consumibles disponibles en la tienda de piso.
///              A medida que avanzas, aparecen mejores items.
function scr_torre_catalogo_tienda_piso(_piso, _total) {
    var _progreso = _piso / _total; // 0.0 a 1.0

    var _items = [];

    // Siempre disponibles
    array_push(_items, { nombre: "Pocion Basica",       precio: 30 });
    array_push(_items, { nombre: "Tonico de Defensa",   precio: 50 });

    // Desde 30% de progreso
    if (_progreso >= 0.3) {
        array_push(_items, { nombre: "Pocion Media",        precio: 60 });
        array_push(_items, { nombre: "Tonico de Ataque",    precio: 55 });
    }

    // Desde 50% de progreso
    if (_progreso >= 0.5) {
        array_push(_items, { nombre: "Elixir de Esencia",   precio: 70 });
    }

    // Runas — desde 40% de progreso
    if (_progreso >= 0.4) {
        array_push(_items, { nombre: "Runa de Furia",       precio: 80 });
        array_push(_items, { nombre: "Runa de Fortaleza",   precio: 80 });
        array_push(_items, { nombre: "Runa de Celeridad",   precio: 75 });
    }

    if (_progreso >= 0.6) {
        array_push(_items, { nombre: "Runa Vampirica",           precio: 100 });
        array_push(_items, { nombre: "Runa del Ultimo Aliento",  precio: 120 });
        array_push(_items, { nombre: "Runa de Cristal",          precio: 90 });
    }

    return _items;
}
