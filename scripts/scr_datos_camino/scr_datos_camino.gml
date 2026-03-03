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
            jefe: "",
            jefe_es_elite: true,
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
            jefe: "",
            jefe_es_elite: true,
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
            jefe_es_elite: false,
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
            jefe_es_elite: false,
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
            jefe_es_elite: false,
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
        // Mínimo 3 nodos para poder ofrecer al menos 2 opciones por nodo padre
        var _num_nodos = 3 + irandom(1); // 3 o 4 nodos

        for (var n = 0; n < _num_nodos; n++) {
            var _tipo = scr_camino_tipo_nodo_random(_capitulo, t, _num_decisiones);
            array_push(_tier, scr_camino_crear_nodo(_tipo, _capitulo));
        }
        array_push(_mapa, _tier);
    }

    // ── Tier final: jefe del capítulo ──
    // Caps con jefe dedicado O caps con jefe_es_elite (cap 1-2)
    if (_capitulo.jefe != "" || (variable_struct_exists(_capitulo, "jefe_es_elite") && _capitulo.jefe_es_elite)) {
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

        // Asegurar que cada nodo actual tenga al menos 2 conexiones salientes
        for (var n = 0; n < array_length(_curr); n++) {
            while (array_length(_curr[n].conexiones) < 2) {
                var _rnd = irandom(array_length(_next) - 1);
                var _dup2 = false;
                for (var c = 0; c < array_length(_curr[n].conexiones); c++) {
                    if (_curr[n].conexiones[c] == _rnd) { _dup2 = true; break; }
                }
                if (!_dup2) array_push(_curr[n].conexiones, _rnd);
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
        if (_roll < 50) return "combate";
        if (_tiene_elite && _roll < 65) return "elite";
        if (_roll < 75) return "cofre";
        if (_roll < 85) return "evento";
        if (_roll < 93) return "descanso";
        return "combate";
    }

    // Último tier antes del jefe: oportunidad de prepararse
    if (_tier >= _total_tiers - 1) {
        if (_roll < 25) return "combate";
        if (_tiene_elite && _roll < 38) return "elite";
        if (_roll < 50) return "descanso";
        if (_roll < 65) return "tienda";
        if (_roll < 78) return "forja";
        if (_roll < 88) return "evento";
        return "cofre";
    }

    // Tiers intermedios: distribución general
    if (_roll < 35) return "combate";
    if (_tiene_elite && _roll < 48) return "elite";
    if (_roll < 58) return "tienda";
    if (_roll < 68) return "forja";
    if (_roll < 78) return "evento";
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
            // Caps 1-2: el jefe es un élite con multiplicadores extra
            if (variable_struct_exists(_capitulo, "jefe_es_elite") && _capitulo.jefe_es_elite) {
                var _pool = _capitulo.enemigos_elite;
                _nodo.nombre = _pool[irandom(array_length(_pool) - 1)];
                _nodo.hp_mult *= 1.25;
                _nodo.oro_mult *= 1.5;
                _nodo.descripcion = "Elite reforzado — jefe del capítulo";
            } else {
                _nodo.nombre = _capitulo.jefe;
                _nodo.oro_mult *= 1.5;
                _nodo.descripcion = "Jefe del capítulo";
            }
            break;
        case "evento":
            _nodo.nombre = "Evento";
            _nodo.descripcion = "Descubre un fragmento de lore y obtén un arma";
            // Rareza según capítulo: cap 1-2 → R1, cap 3-4 → R2, cap 5 → R3
            if (_capitulo.numero <= 2) _nodo.recompensa_rareza = 1;
            else if (_capitulo.numero <= 4) _nodo.recompensa_rareza = 2;
            else _nodo.recompensa_rareza = 3;
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


// ═══════════════════════════════════════════════════════════════
//  ARMAS POR RAREZA (para nodos de evento)
// ═══════════════════════════════════════════════════════════════

/// @function scr_camino_armas_por_rareza(_rareza)
/// @description Retorna un array de nombres de armas de la rareza dada
/// @param {real} _rareza  1, 2 o 3
/// @returns {array}
function scr_camino_armas_por_rareza(_rareza) {
    var _todas = scr_lista_armas_disponibles();
    var _resultado = [];

    for (var i = 0; i < array_length(_todas); i++) {
        var _datos = scr_datos_armas(_todas[i]);
        if (_datos.rareza == _rareza) {
            array_push(_resultado, _todas[i]);
        }
    }

    return _resultado;
}


/// @function scr_camino_arma_aleatoria_rareza(_rareza)
/// @description Retorna el nombre de un arma aleatoria de la rareza dada
/// @param {real} _rareza  1, 2 o 3
/// @returns {string}
function scr_camino_arma_aleatoria_rareza(_rareza) {
    var _pool = scr_camino_armas_por_rareza(_rareza);
    if (array_length(_pool) == 0) return "Hoja Rota";
    return _pool[irandom(array_length(_pool) - 1)];
}


/// @function scr_camino_lore_evento(_capitulo)
/// @description Retorna líneas de lore para un nodo de evento según capítulo
/// @param {struct} _capitulo
/// @returns {array}
function scr_camino_lore_evento(_capitulo) {
    switch (_capitulo.numero) {
        case 1:
            return [
                "Entre los escombros de la forja, encuentras una cámara oculta.",
                "Grabados en la pared muestran a los Conductores originales forjando armas elementales.",
                "Una de ellas brilla aún con poder residual. Puedes sentir el calor de las Corrientes.",
            ];
        case 2:
            return [
                "Un altar cubierto de musgo emerge del pantano.",
                "Los antiguos dejaron ofrendas aquí: armas imbuidas con la esencia de la vida.",
                "Una de ellas responde a tu presencia de Conductor.",
            ];
        case 3:
            return [
                "En lo alto de una torre fracturada, un relicario resiste la tormenta.",
                "Dentro, un arma envuelta en energía crepitante aguarda a un portador digno.",
                "Los grabados hablan de la Era de los Conductores, cuando el cielo aún estaba intacto.",
            ];
        case 4:
            return [
                "El observatorio arcano guarda secretos de la Ruptura.",
                "Proyecciones fantasmales muestran el momento en que el mundo se fracturó.",
                "Entre las ruinas, un arma de poder impresionante late con energía sombría.",
            ];
        case 5:
            return [
                "En el corazón de la Convergencia, las ocho Corrientes se entrelazan.",
                "Aquí fue forjada la primera arma, la que definió a los Conductores.",
                "Su poder trasciende los elementos. Un arma legendaria que fue creada para este momento.",
            ];
        default:
            return [
                "Un evento misterioso ocurre.",
                "Algo antiguo despierta y te ofrece un regalo.",
            ];
    }
}
