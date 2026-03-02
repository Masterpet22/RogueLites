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
//  GENERACIÓN DE ENCUENTROS POR CAPÍTULO
// ═══════════════════════════════════════════════════════════════

/// @function scr_camino_generar_encuentros(_capitulo)
/// @description Genera la lista de encuentros (combates) para un capítulo
/// @param {struct} _capitulo  Struct del capítulo (de scr_camino_get_capitulos)
/// @returns {array}  Array de structs { nombre_enemigo, hp_mult, oro_mult, es_jefe, es_elite, tipo }
function scr_camino_generar_encuentros(_capitulo) {
    var _encuentros = [];

    // ── Combates comunes ──
    var _n_comunes   = _capitulo.combates_comunes;
    var _pool_comun  = _capitulo.enemigos_comunes;

    for (var i = 0; i < _n_comunes; i++) {
        if (array_length(_pool_comun) == 0) break;
        var _idx = irandom(array_length(_pool_comun) - 1);
        array_push(_encuentros, {
            nombre_enemigo: _pool_comun[_idx],
            hp_mult:        _capitulo.hp_mult,
            oro_mult:       _capitulo.oro_mult,
            es_jefe:        false,
            es_elite:       false,
            tipo:           "comun",
        });
    }

    // ── Combates élite ──
    var _n_elite   = _capitulo.combates_elite;
    var _pool_elite = _capitulo.enemigos_elite;

    for (var i = 0; i < _n_elite; i++) {
        if (array_length(_pool_elite) == 0) break;
        var _idx = irandom(array_length(_pool_elite) - 1);

        // Insertar en posición aleatoria DESPUÉS de los primeros 2 comunes
        var _pos = min(2 + irandom(array_length(_encuentros) - 1), array_length(_encuentros));
        array_insert(_encuentros, _pos, {
            nombre_enemigo: _pool_elite[_idx],
            hp_mult:        _capitulo.hp_mult * 1.1,
            oro_mult:       _capitulo.oro_mult * 1.2,
            es_jefe:        false,
            es_elite:       true,
            tipo:           "elite",
        });
    }

    // ── Boss del capítulo ──
    if (_capitulo.jefe != "") {
        array_push(_encuentros, {
            nombre_enemigo: _capitulo.jefe,
            hp_mult:        _capitulo.hp_mult,
            oro_mult:       _capitulo.oro_mult * 1.5,
            es_jefe:        true,
            es_elite:       false,
            tipo:           "jefe",
        });
    }

    return _encuentros;
}


// ═══════════════════════════════════════════════════════════════
//  FRAGMENTOS NARRATIVOS ENTRE ENCUENTROS
// ═══════════════════════════════════════════════════════════════

/// @function scr_camino_fragmento_combate(_capitulo, _encuentro_idx)
/// @description Retorna un fragmento narrativo breve para mostrar entre combates
/// @param {struct} _capitulo        Capítulo actual
/// @param {real}   _encuentro_idx   Índice del combate completado (0-based)
/// @returns {string}  Texto narrativo
function scr_camino_fragmento_combate(_capitulo, _encuentro_idx) {

    // Fragmentos genéricos que aplican a todo capítulo
    var _fragmentos = [
        "Los ecos de la batalla resuenan en las ruinas...",
        "El camino se despeja momentáneamente. Pero la amenaza persiste.",
        "Cada victoria trae más claridad a tus recuerdos fragmentados.",
        "Las Corrientes elementales pulsan con más fuerza a tu alrededor.",
        "Tu Esencia se fortalece. Puedes sentir las corrientes de " + _capitulo.afinidades[0 mod max(1, array_length(_capitulo.afinidades))] + ".",
        "Otro enemigo cae. El Devorador sabe que te acercas.",
        "Los fragmentos de memoria se vuelven más nítidos con cada combate.",
        "El poder de los Conductores antiguos fluye a través de ti.",
    ];

    return _fragmentos[_encuentro_idx mod array_length(_fragmentos)];
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
