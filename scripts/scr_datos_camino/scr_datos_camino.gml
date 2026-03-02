/// SCRIPT — scr_datos_camino
/// Define los datos del modo "Camino del Héroe" (modo principal roguelite narrativo).
/// Estructura: 4 capítulos por dominio elemental dual + capítulo final vs El Devorador.

// ═══════════════════════════════════════════════════════════════
//  CAPÍTULOS
// ═══════════════════════════════════════════════════════════════

/// @function scr_camino_get_capitulos()
/// @description Retorna array con los 5 capítulos del Camino del Héroe
function scr_camino_get_capitulos() {
    return [
        // ── CAPÍTULO 1: Fuego + Tierra ──
        {
            id: "cap_1",
            numero: 1,
            nombre: "Las Forjas Rotas",
            subtitulo: "Dominio de Fuego y Tierra",
            descripcion: "Las ruinas volcánicas arden con el eco de la Ruptura. Golems y soldados te bloquean el paso.",
            color: make_color_rgb(200, 80, 40),
            afinidades: ["Fuego", "Tierra"],
            enemigos_comunes: ["Soldado Igneo", "Guardian Terracota"],
            enemigos_elite:   ["Soldado Igneo Elite", "Guardian Terracota Elite"],
            jefe: "Titan de las Forjas Rotas",
            combates_comunes: 3,
            combates_elite: 1,
            hp_mult: 1.0,
            oro_mult: 1.0,
            decisiones: 4,
            narrativa_intro: [
                "Fragmentos de recuerdos parpadean en tu mente...",
                "Una forja antigua. Martillos que golpean incansablemente.",
                "El calor del metal fundido. El temblor de la tierra.",
                "Tu primer paso como Conductor comienza aquí.",
            ],
            narrativa_victoria: [
                "El Titán cae y la forja se silencia por primera vez en siglos.",
                "Entre los escombros, un recuerdo emerge: siempre hubo fuego en tu sangre.",
                "Las Corrientes de Fuego y Tierra se estabilizan momentáneamente.",
            ],
        },

        // ── CAPÍTULO 2: Agua + Planta ──
        {
            id: "cap_2",
            numero: 2,
            nombre: "El Fango Viviente",
            subtitulo: "Dominio de Agua y Planta",
            descripcion: "Canales rotos y bosques parasitados se entrelazan en un pantano corrupto.",
            color: make_color_rgb(40, 160, 120),
            afinidades: ["Agua", "Planta"],
            enemigos_comunes: ["Vigia Boreal", "Halito Verde"],
            enemigos_elite:   ["Vigia Boreal Elite", "Halito Verde Elite"],
            jefe: "Coloso del Fango Viviente",
            combates_comunes: 3,
            combates_elite: 1,
            hp_mult: 1.15,
            oro_mult: 1.15,
            decisiones: 4,
            narrativa_intro: [
                "El aire se vuelve húmedo, pesado, tóxico.",
                "Raíces retorcidas atraviesan los restos de una ciudad sumergida.",
                "La naturaleza aquí no es aliada... ha sido corrompida.",
                "Otro fragmento de memoria: alguien te enseñó a sentir las Corrientes.",
            ],
            narrativa_victoria: [
                "El Coloso se desmorona en lodo y esporas moribundas.",
                "Un recuerdo más claro: un maestro, una voz que te guiaba.",
                "Las Corrientes de Agua y Planta respiran de nuevo.",
            ],
        },

        // ── CAPÍTULO 3: Rayo + Luz ──
        {
            id: "cap_3",
            numero: 3,
            nombre: "El Cielo Roto",
            subtitulo: "Dominio de Rayo y Luz",
            descripcion: "Torres suspendidas entre tormentas perpetuas y templos santos fracturados por la Ruptura.",
            color: make_color_rgb(100, 180, 240),
            afinidades: ["Rayo", "Luz"],
            enemigos_comunes: ["Bestia Tronadora", "Paladin Marchito"],
            enemigos_elite:   ["Bestia Tronadora Elite", "Paladin Marchito Elite"],
            jefe: "Sentinela del Cielo Roto",
            combates_comunes: 4,
            combates_elite: 1,
            hp_mult: 1.30,
            oro_mult: 1.25,
            decisiones: 5,
            narrativa_intro: [
                "El cielo se quiebra con cada relámpago.",
                "Templos que alguna vez brillaron ahora son cáscaras vacías.",
                "Los paladines que juraron proteger estas tierras perdieron su luz.",
                "Tu memoria se aclara: fuiste entrenado para esto. Para llegar hasta aquí.",
            ],
            narrativa_victoria: [
                "La Sentinela se apaga como un rayo final en la tormenta.",
                "Un recuerdo completo: tu nombre, tu propósito, tu juramento.",
                "Las Corrientes de Rayo y Luz se reconectan, débiles pero persistentes.",
            ],
        },

        // ── CAPÍTULO 4: Sombra + Arcano ──
        {
            id: "cap_4",
            numero: 4,
            nombre: "El Abismo Quebrado",
            subtitulo: "Dominio de Sombra y Arcano",
            descripcion: "Ciudades subterráneas devoradas y observatorios fractales son todo lo que queda antes del Devorador.",
            color: make_color_rgb(140, 80, 200),
            afinidades: ["Sombra", "Arcano"],
            enemigos_comunes: ["Naufrago de la Oscuridad", "Errante Runico"],
            enemigos_elite:   ["Naufrago de la Oscuridad Elite", "Errante Runico Elite"],
            jefe: "Oraculo Quebrado del Abismo",
            combates_comunes: 4,
            combates_elite: 2,
            hp_mult: 1.45,
            oro_mult: 1.35,
            decisiones: 5,
            narrativa_intro: [
                "La oscuridad aquí es tangible. Puedes sentirla arrastrándose.",
                "Símbolos arcanos brillan tenuemente en las ruinas fracturadas.",
                "Los observatorios que predijeron la Ruptura están destruidos.",
                "Tu memoria es casi completa: el Devorador espera más allá.",
            ],
            narrativa_victoria: [
                "El Oráculo se desvanece entre sombras y destellos arcanos.",
                "Ahora lo recuerdas todo: quién eres, qué eres, por qué estás aquí.",
                "Las ocho Corrientes pulsan en sincronía. El camino al Devorador se abre.",
            ],
        },

        // ── CAPÍTULO FINAL: El Devorador ──
        {
            id: "cap_final",
            numero: 5,
            nombre: "La Convergencia",
            subtitulo: "El Devorador despierta",
            descripcion: "El centro de Arcadium. Todas las Corrientes convergen aquí. El Devorador espera.",
            color: make_color_rgb(180, 30, 30),
            afinidades: [],
            enemigos_comunes: [],
            enemigos_elite: [],
            jefe: "El Devorador",
            combates_comunes: 0,
            combates_elite: 0,
            hp_mult: 1.60,
            oro_mult: 2.0,
            decisiones: 2,
            narrativa_intro: [
                "Las ocho Corrientes convergen. El mundo tiembla.",
                "El Devorador emerge: una entidad sin forma, sin afinidad, sin piedad.",
                "Absorbe la Esencia de todo lo que toca.",
                "Este es el momento. El clímax de tu viaje.",
                "Conductor... demuestra que el mundo aún merece existir.",
            ],
            narrativa_victoria: [
                "El Devorador se fragmenta, su esencia se dispersa en las Corrientes.",
                "La Ruptura comienza a sanar. Las Corrientes fluyen de nuevo.",
                "Tu nombre resonará en Arcadium por siempre.",
                "El Camino del Héroe ha llegado a su fin... ¿o es solo el principio?",
            ],
        },
    ];
}


// ═══════════════════════════════════════════════════════════════
//  GENERACIÓN DE MAPA RAMIFICADO POR CAPÍTULO
// ═══════════════════════════════════════════════════════════════

/// @function scr_camino_generar_mapa(_capitulo)
/// @description Genera un mapa de caminos ramificados para un capítulo
/// @param {struct} _capitulo  Struct del capítulo
/// @returns {array}  Array de tiers; cada tier = array de nodos (structs)
function scr_camino_generar_mapa(_capitulo) {
    var _mapa = [];
    var _num_decisiones = _capitulo.decisiones;

    // ── Generar tiers de decisión (0 a num_decisiones-1) ──
    for (var t = 0; t < _num_decisiones; t++) {
        var _tier = [];
        var _num_nodos = (t == 0) ? 3 : 3 + irandom(1); // 3 o 4 nodos

        for (var n = 0; n < _num_nodos; n++) {
            var _tipo = scr_camino_tipo_nodo_random(_capitulo, t, _num_decisiones);
            array_push(_tier, scr_camino_crear_nodo(_tipo, _capitulo));
        }
        array_push(_mapa, _tier);
    }

    // ── Tier final: jefe del capítulo ──
    if (_capitulo.jefe != "") {
        array_push(_mapa, [scr_camino_crear_nodo("jefe", _capitulo)]);
    }

    // ── Generar conexiones entre tiers ──
    for (var t = 0; t < array_length(_mapa) - 1; t++) {
        var _curr = _mapa[t];
        var _next = _mapa[t + 1];

        for (var n = 0; n < array_length(_curr); n++) {
            _curr[n].conexiones = [];
        }

        // Si el siguiente tier es el jefe (1 nodo), todos conectan al jefe
        if (array_length(_next) == 1) {
            for (var n = 0; n < array_length(_curr); n++) {
                _curr[n].conexiones = [0];
            }
            continue;
        }

        // Asegurar que cada nodo del siguiente tier tenga al menos 1 conexión entrante
        for (var n = 0; n < array_length(_next); n++) {
            var _from = irandom(array_length(_curr) - 1);
            var _ya_existe = false;
            for (var c = 0; c < array_length(_curr[_from].conexiones); c++) {
                if (_curr[_from].conexiones[c] == n) { _ya_existe = true; break; }
            }
            if (!_ya_existe) array_push(_curr[_from].conexiones, n);
        }

        // Asegurar que cada nodo actual tenga al menos 1 conexión saliente
        for (var n = 0; n < array_length(_curr); n++) {
            if (array_length(_curr[n].conexiones) == 0) {
                array_push(_curr[n].conexiones, irandom(array_length(_next) - 1));
            }
        }

        // Agregar conexiones extra para más ramificación
        for (var n = 0; n < array_length(_curr); n++) {
            var _extras = irandom(1);
            for (var e = 0; e < _extras; e++) {
                if (array_length(_curr[n].conexiones) >= 3) break;
                var _target = irandom(array_length(_next) - 1);
                var _dup = false;
                for (var c = 0; c < array_length(_curr[n].conexiones); c++) {
                    if (_curr[n].conexiones[c] == _target) { _dup = true; break; }
                }
                if (!_dup) array_push(_curr[n].conexiones, _target);
            }
        }

        // Ordenar conexiones por índice
        for (var n = 0; n < array_length(_curr); n++) {
            array_sort(_curr[n].conexiones, true);
        }
    }

    return _mapa;
}


/// @function scr_camino_tipo_nodo_random(_capitulo, _tier, _total_tiers)
/// @description Elige un tipo de nodo aleatorio con pesos según posición en el mapa
function scr_camino_tipo_nodo_random(_capitulo, _tier, _total_tiers) {
    var _tiene_enemigos = (array_length(_capitulo.enemigos_comunes) > 0);
    var _tiene_elite    = (array_length(_capitulo.enemigos_elite) > 0);
    var _roll = irandom(99);

    // Sin enemigos (capítulo final): solo nodos no-combate
    if (!_tiene_enemigos) {
        if (_roll < 35) return "descanso";
        if (_roll < 65) return "cofre";
        if (_roll < 82) return "tienda";
        return "forja";
    }

    // Primer tier: más combate para empezar con acción
    if (_tier == 0) {
        if (_roll < 55) return "combate";
        if (_tiene_elite && _roll < 70) return "elite";
        if (_roll < 80) return "cofre";
        if (_roll < 90) return "descanso";
        return "combate";
    }

    // Último tier antes del jefe: oportunidad de prepararse
    if (_tier >= _total_tiers - 1) {
        if (_roll < 30) return "combate";
        if (_tiene_elite && _roll < 45) return "elite";
        if (_roll < 60) return "descanso";
        if (_roll < 75) return "tienda";
        if (_roll < 90) return "forja";
        return "cofre";
    }

    // Tiers intermedios: distribución general
    if (_roll < 40) return "combate";
    if (_tiene_elite && _roll < 55) return "elite";
    if (_roll < 67) return "tienda";
    if (_roll < 79) return "forja";
    if (_roll < 90) return "descanso";
    return "cofre";
}


/// @function scr_camino_crear_nodo(_tipo, _capitulo)
/// @description Crea un struct de nodo para el mapa ramificado
function scr_camino_crear_nodo(_tipo, _capitulo) {
    var _nodo = {
        tipo: _tipo,
        nombre: "",
        descripcion: "",
        hp_mult: _capitulo.hp_mult,
        oro_mult: _capitulo.oro_mult,
        recompensa_oro: 0,
        conexiones: [],
        visitado: false,
    };

    switch (_tipo) {
        case "combate":
            var _pool = _capitulo.enemigos_comunes;
            if (array_length(_pool) > 0) _nodo.nombre = _pool[irandom(array_length(_pool) - 1)];
            _nodo.descripcion = "Combate contra un enemigo";
            break;
        case "elite":
            var _pool = _capitulo.enemigos_elite;
            if (array_length(_pool) > 0) _nodo.nombre = _pool[irandom(array_length(_pool) - 1)];
            _nodo.hp_mult *= 1.1;
            _nodo.oro_mult *= 1.2;
            _nodo.descripcion = "Enemigo elite — mayor riesgo y recompensa";
            break;
        case "tienda":
            _nodo.nombre = "Mercader";
            _nodo.descripcion = "Compra objetos y consumibles";
            break;
        case "forja":
            _nodo.nombre = "Forja";
            _nodo.descripcion = "Fabrica y mejora armas";
            break;
        case "descanso":
            _nodo.nombre = "Descanso";
            _nodo.descripcion = "Un momento de respiro y narrativa";
            break;
        case "cofre":
            var _oro_base = 20 + _capitulo.numero * 15;
            _nodo.recompensa_oro = _oro_base + irandom(round(_oro_base * 0.5));
            _nodo.nombre = "Cofre";
            _nodo.descripcion = "Contiene " + string(_nodo.recompensa_oro) + " oro";
            break;
        case "jefe":
            _nodo.nombre = _capitulo.jefe;
            _nodo.oro_mult *= 1.5;
            _nodo.descripcion = "Jefe del capitulo";
            break;
    }

    return _nodo;
}


// ═══════════════════════════════════════════════════════════════
//  FRAGMENTOS NARRATIVOS
// ═══════════════════════════════════════════════════════════════

/// @function scr_camino_fragmento_combate(_capitulo, _idx)
/// @description Retorna un fragmento narrativo breve
function scr_camino_fragmento_combate(_capitulo, _idx) {
    var _fragmentos = [
        "Los ecos de la batalla resuenan en las ruinas...",
        "El camino se despeja momentáneamente. Pero la amenaza persiste.",
        "Cada victoria trae más claridad a tus recuerdos fragmentados.",
        "Las Corrientes elementales pulsan con más fuerza a tu alrededor.",
        "Otro enemigo cae. El Devorador sabe que te acercas.",
        "Los fragmentos de memoria se vuelven más nítidos con cada combate.",
        "El poder de los Conductores antiguos fluye a través de ti.",
        "El silencio aquí es pesado, cargado de memorias.",
    ];

    return _fragmentos[_idx mod array_length(_fragmentos)];
}


// ═══════════════════════════════════════════════════════════════
//  RECOMPENSAS DE CAPÍTULO
// ═══════════════════════════════════════════════════════════════

/// @function scr_camino_recompensa_capitulo(_capitulo)
/// @description Calcula la recompensa por completar un capítulo
/// @param {struct} _capitulo  Capítulo completado
/// @returns {struct}  { oro, bonus_texto }
function scr_camino_recompensa_capitulo(_capitulo) {
    var _base_oro = 0;
    switch (_capitulo.numero) {
        case 1: _base_oro = 100; break;
        case 2: _base_oro = 175; break;
        case 3: _base_oro = 250; break;
        case 4: _base_oro = 350; break;
        case 5: _base_oro = 600; break;  // Final
        default: _base_oro = 100; break;
    }

    return {
        oro: _base_oro,
        bonus_texto: "Capítulo " + string(_capitulo.numero) + " completado: +" + string(_base_oro) + " oro",
    };
}


// ═══════════════════════════════════════════════════════════════
//  DESBLOQUEO DEL JEFE SECRETO
// ═══════════════════════════════════════════════════════════════

/// @function scr_camino_check_secreto(_camino_ctrl)
/// @description Verifica si se cumple la condición para desbloquear al Primer Conductor
/// @param {struct} _camino_ctrl  Referencia al obj_control_camino
/// @returns {bool}
function scr_camino_check_secreto(_camino_ctrl) {
    // Condición: completar el juego sin perder ningún combate (run perfecta)
    return (_camino_ctrl.camino_derrotas == 0 && _camino_ctrl.camino_capitulo_idx >= 4);
}
