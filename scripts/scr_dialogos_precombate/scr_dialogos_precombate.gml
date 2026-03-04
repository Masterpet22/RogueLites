/// @file scr_dialogos_precombate.gml
/// @description  Sistema de diálogos pre-combate.
///   Antes de que inicie el combate, cada personaje dice una frase corta.
///   - Cámara hace leve zoom al que habla
///   - Glow/luminosidad suave en el sprite activo
///   - Fondo atenuado
///   - 2–3 segundos por frase, transición fluida al combate
///
///   Controlado por flag FX_DIALOGOS_PRE_ON.
///   Se integra en obj_control_combate (Create + Step + Draw GUI).

// ══════════════════════════════════════════════════════════════
//  MACROS DE DIÁLOGOS
// ══════════════════════════════════════════════════════════════
#macro DIAL_DURACION_FRASE   140     // frames por frase (~2.3s a 60fps)
#macro DIAL_FADE_IN          15      // frames de fade-in del texto
#macro DIAL_FADE_OUT         15      // frames de fade-out del texto
#macro DIAL_ZOOM_HABLA       1.12    // zoom hacia quien habla (1.12 = 12%)
#macro DIAL_ZOOM_VELOCIDAD   0.06    // velocidad de interpolación del zoom
#macro DIAL_GLOW_ALPHA       0.25    // alpha del glow sobre quien habla
#macro DIAL_BG_OSCURIDAD     0.35    // oscurecimiento del fondo (0–1)
#macro DIAL_DELAY_FRAMES     90      // delay antes de iniciar diálogos (~1.5s) para esperar transición


// ══════════════════════════════════════════════════════════════
//  scr_dialogos_init()
//  Inicializa el sistema de diálogos. Llamar en Create de obj_control_combate.
// ══════════════════════════════════════════════════════════════
function scr_dialogos_init() {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);

    _c.dial_activo       = false;
    _c.dial_frases       = [];       // array de { quien, nombre, texto, es_jugador }
    _c.dial_indice       = 0;        // frase actual
    _c.dial_timer        = 0;        // timer de la frase actual
    _c.dial_terminado    = false;    // ya terminó la secuencia
    _c.dial_skip_pressed = false;
    _c.dial_delay_timer  = DIAL_DELAY_FRAMES;  // esperar a que termine la transición de room

    // Solo activar si el flag está encendido
    if (!FX_DIALOGOS_PRE_ON) {
        _c.dial_terminado = true;
        return;
    }

    // Generar frases para este combate
    var _pj = _c.personaje_jugador;
    var _en = _c.personaje_enemigo;

    var _frases = [];

    // Frase del jugador
    var _frase_pj = _scr_frase_jugador(_pj.nombre, _pj.clase, _pj.personalidad, _en.nombre);
    array_push(_frases, {
        nombre:     _pj.nombre,
        texto:      _frase_pj,
        es_jugador: true,
    });

    // Frase del enemigo
    var _rango_en = variable_struct_exists(_en, "rango") ? _en.rango : "Comun";
    var _frase_en = _scr_frase_enemigo(_en.nombre, _rango_en);
    array_push(_frases, {
        nombre:     _en.nombre,
        texto:      _frase_en,
        es_jugador: false,
    });

    _c.dial_frases    = _frases;
    _c.dial_activo    = true;
    _c.dial_indice    = 0;
    _c.dial_timer     = DIAL_DURACION_FRASE;
    _c.dial_terminado = false;
}


// ══════════════════════════════════════════════════════════════
//  scr_dialogos_actualizar()
//  Llamar cada frame en Step ANTES de la lógica de combate.
//  Retorna TRUE si los diálogos están activos (bloquear combate).
// ══════════════════════════════════════════════════════════════
function scr_dialogos_actualizar() {
    if (!instance_exists(obj_control_combate)) return false;
    var _c = instance_find(obj_control_combate, 0);

    if (_c.dial_terminado || !_c.dial_activo) return false;

    // Delay inicial: esperar a que termine la transición de room
    if (_c.dial_delay_timer > 0) {
        _c.dial_delay_timer -= 1;
        return true; // bloquear combate mientras esperamos
    }

    // Skip con Enter o clic
    if (keyboard_check_pressed(vk_enter) || mouse_check_button_pressed(mb_left)) {
        _c.dial_skip_pressed = true;
    }

    // Avanzar timer
    _c.dial_timer -= 1;

    // Skip: saltar a siguiente frase
    if (_c.dial_skip_pressed) {
        _c.dial_skip_pressed = false;
        _c.dial_timer = 0;
    }

    // Siguiente frase o terminar
    if (_c.dial_timer <= 0) {
        _c.dial_indice += 1;
        if (_c.dial_indice >= array_length(_c.dial_frases)) {
            // Fin de diálogos → restaurar foco a neutro
            _c.dial_activo    = false;
            _c.dial_terminado = true;
            _c.foco_quien     = 0;
            _c.foco_escala_obj = 1.0;
            _c.foco_dim_obj    = 1.0;
            return false;
        }
        _c.dial_timer = DIAL_DURACION_FRASE;
    }

    // Calcular foco hacia quien habla (énfasis individual, no matrix)
    if (_c.dial_indice < array_length(_c.dial_frases)) {
        var _fr = _c.dial_frases[_c.dial_indice];

        // Foco: agrandar al que habla, atenuar al otro
        _c.foco_quien      = _fr.es_jugador ? 1 : 2;
        _c.foco_escala_obj  = DIAL_ZOOM_HABLA;   // 1.12 = 12% más grande
        _c.foco_dim_obj     = 0.45;               // el otro se atenúa bastante
        _c.foco_vel         = DIAL_ZOOM_VELOCIDAD;
    }

    return true; // diálogos activos → bloquear combate
}


// ══════════════════════════════════════════════════════════════
//  scr_dialogos_dibujar()
//  Dibujar la caja de diálogo y efectos. Llamar en Draw GUI.
// ══════════════════════════════════════════════════════════════
function scr_dialogos_dibujar() {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);

    if (!_c.dial_activo || _c.dial_terminado) return;
    if (_c.dial_delay_timer > 0) return; // no dibujar durante el delay inicial
    if (_c.dial_indice >= array_length(_c.dial_frases)) return;

    var _frase = _c.dial_frases[_c.dial_indice];
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

    // ── Calcular alpha del texto (fade-in / stay / fade-out) ──
    var _elapsed = DIAL_DURACION_FRASE - _c.dial_timer;
    var _alpha_txt = 1.0;

    if (_elapsed < DIAL_FADE_IN) {
        _alpha_txt = _elapsed / DIAL_FADE_IN;
    } else if (_c.dial_timer < DIAL_FADE_OUT) {
        _alpha_txt = _c.dial_timer / DIAL_FADE_OUT;
    }

    // ── Fondo atenuado ──
    draw_set_color(c_black);
    draw_set_alpha(DIAL_BG_OSCURIDAD * _alpha_txt);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);

    // ── Glow sobre quien habla ──
    {
        var _spr, _base_x;
        if (_frase.es_jugador) {
            _spr = (variable_struct_exists(_c.personaje_jugador, "sprite_cuerpo"))
                   ? _c.personaje_jugador.sprite_cuerpo : spr_jugador;
            _base_x = _gw * 0.22;
        } else {
            _spr = (variable_struct_exists(_c.personaje_enemigo, "sprite_cuerpo"))
                   ? _c.personaje_enemigo.sprite_cuerpo : spr_enemigo;
            _base_x = _gw * 0.78;
        }

        var _display_h = 345;
        var _escala = _display_h / sprite_get_height(_spr);
        var _suelo_y = _gh * 0.82;
        var _base_y = scr_sprite_y_anclado_suelo(_spr, _suelo_y, _escala);

        // Glow (additive blending)
        gpu_set_blendmode(bm_add);
        var _glow_escala = _escala * 1.08;
        var _glow_y = scr_sprite_y_anclado_suelo(_spr, _suelo_y, _glow_escala);
        var _flip = _frase.es_jugador ? _glow_escala : -_glow_escala;
        draw_sprite_ext(_spr, 0, _base_x, _glow_y,
            _flip, _glow_escala, 0,
            c_white, DIAL_GLOW_ALPHA * _alpha_txt);
        gpu_set_blendmode(bm_normal);
    }

    // ── Caja de diálogo ──
    var _box_w = _gw * 0.6;
    var _box_h = 72;
    var _box_x = (_gw - _box_w) * 0.5;
    var _box_y = _gh * 0.75;

    // Fondo de la caja
    draw_set_color(c_black);
    draw_set_alpha(0.75 * _alpha_txt);
    draw_roundrect(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h, false);
    draw_set_alpha(1);

    // Borde
    draw_set_color(_frase.es_jugador ? make_color_rgb(60, 140, 220) : make_color_rgb(200, 60, 60));
    draw_set_alpha(_alpha_txt);
    draw_roundrect(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h, true);

    // Nombre
    draw_set_font(fnt_1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(_frase.es_jugador ? make_color_rgb(100, 180, 255) : make_color_rgb(255, 120, 100));
    draw_set_alpha(_alpha_txt);
    draw_text(_box_x + 16, _box_y + 8, _frase.nombre);

    // Texto
    draw_set_color(c_white);
    draw_text(_box_x + 16, _box_y + 30, _frase.texto);

    // Indicador "Enter para continuar"
    if (_c.dial_timer < DIAL_DURACION_FRASE - 30) {
        draw_set_halign(fa_right);
        draw_set_color(c_gray);
        var _blink = ((_c.dial_timer div 20) mod 2 == 0) ? 0.7 : 0.3;
        draw_set_alpha(_blink * _alpha_txt);
        draw_text(_box_x + _box_w - 16, _box_y + _box_h - 20, "[ENTER]");
    }

    // Restaurar
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}


// ══════════════════════════════════════════════════════════════
//  scr_dialogos_zoom_aplicar()  — DESACTIVADO
//  El zoom ahora se hace por foco individual en scr_feedback_dibujar_sprites.
// ══════════════════════════════════════════════════════════════
function scr_dialogos_zoom_aplicar() {
    // No-op: el énfasis ahora es individual por sprite
}


// ══════════════════════════════════════════════════════════════
//  scr_dialogos_zoom_restaurar()  — DESACTIVADO
// ══════════════════════════════════════════════════════════════
function scr_dialogos_zoom_restaurar() {
    // No-op: el énfasis ahora es individual por sprite
}


// ══════════════════════════════════════════════════════════════
//  GENERADORES DE FRASES
// ══════════════════════════════════════════════════════════════

/// @function _scr_frase_jugador(nombre, clase, personalidad, enemigo_nombre)
function _scr_frase_jugador(_nombre, _clase, _pers, _enemigo) {

    // Pool de frases según personalidad
    var _frases;

    switch (_pers) {
        case "Agresivo":
            _frases = [
                "No pienso contenerme.",
                "Esto termina ahora, " + _enemigo + ".",
                "¡Voy a destrozarte!",
                "Tu turno de sufrir.",
                "Ni un paso atrás.",
                "El dolor será breve... para mí.",
            ];
            break;
        case "Metodico":
            _frases = [
                "Analicemos la situación...",
                "Cada movimiento cuenta.",
                "He estudiado tu patrón, " + _enemigo + ".",
                "Procedamos con precisión.",
                "La victoria está en los detalles.",
                "Sin prisas. Sin errores.",
            ];
            break;
        case "Temerario":
            _frases = [
                "¡Esto va a ser divertido!",
                "¿Listo para la fiesta, " + _enemigo + "?",
                "¡Sin plan, sin miedo!",
                "¡El caos es mi estrategia!",
                "¡A ver quién cae primero!",
                "¡Adrenalina pura!",
            ];
            break;
        case "Resuelto":
            _frases = [
                "Protegeré lo que importa.",
                "No fallaré esta vez.",
                "Mi voluntad no se quiebra.",
                "Adelante. Estoy listo.",
                "Por los que dependen de mí.",
                "Haré lo que sea necesario.",
            ];
            break;
        default:
            _frases = [
                "Aquí vamos.",
                "Prepárate, " + _enemigo + ".",
                "No me subestimes.",
            ];
            break;
    }

    return _frases[irandom(array_length(_frases) - 1)];
}


/// @function _scr_frase_enemigo(nombre, rango)
function _scr_frase_enemigo(_nombre, _rango) {

    // Frases según rango
    if (_rango == "Jefe") {
        // Jefes tienen frases más dramáticas
        switch (_nombre) {
            case "Titan de las Forjas Rotas":
                return choose(
                    "La forja reclama otra alma...",
                    "¡Arderás en mi crisol!",
                    "Nadie escapa del fuego eterno."
                );
            case "Coloso del Fango Viviente":
                return choose(
                    "La tierra te reclamará...",
                    "Soy la raíz de tu perdición.",
                    "El pantano devora todo."
                );
            case "Sentinela del Cielo Roto":
                return choose(
                    "El cielo juzga a los indignos.",
                    "¡Sentirás la tormenta divina!",
                    "La luz purifica... con dolor."
                );
            case "Oraculo Quebrado del Abismo":
                return choose(
                    "He visto tu derrota...",
                    "El vacío te susurra, escucha...",
                    "Tu destino ya está escrito."
                );
            case "El Devorador":
                return choose(
                    "Todo será consumido...",
                    "Tu esencia me pertenece.",
                    "No hay escape del vacío."
                );
            case "El Primer Conductor":
                return choose(
                    "Yo creé las reglas. Yo las rompo.",
                    "Eres un eco de lo que fui.",
                    "La sinfonía termina aquí."
                );
            default:
                return choose(
                    "No sobrevivirás a esto.",
                    "Tu final ha llegado.",
                    "Prepárate para el olvido."
                );
        }
    } else if (_rango == "Elite") {
        return choose(
            "No soy como los demás...",
            "Te subestimé la última vez.",
            "Esta vez será diferente.",
            "Mi poder ha crecido.",
            "¡No me vencerás tan fácil!",
        );
    } else {
        // Comunes: frases simples o gruñidos
        return choose(
            "¡Grrrr...!",
            "¡No pasarás!",
            "¡Intruso!",
            "...",
            "¡Te aplastaré!",
            "¡Fuera de aquí!",
        );
    }
}


// ══════════════════════════════════════════════════════════════
//  FRASES DE DERROTA (post-combate)
// ══════════════════════════════════════════════════════════════

/// @function _scr_frase_derrota_jugador(nombre, personalidad)
function _scr_frase_derrota_jugador(_nombre, _pers) {
    switch (_pers) {
        case "Agresivo":
            return choose(
                "No... ¡esto no puede acabar así!",
                "Maldición... mi furia no bastó.",
                "Caigo... pero no sin luchar.",
                "La ira no fue suficiente esta vez..."
            );
        case "Metodico":
            return choose(
                "Mis cálculos... fallaron.",
                "Un error imperdonable...",
                "Debo reanalizar mi estrategia...",
                "No preví este desenlace..."
            );
        case "Temerario":
            return choose(
                "Jaja... me arriesgué demasiado.",
                "Bueno... fue divertido mientras duró.",
                "¡Ups! Quizá debí tener un plan...",
                "Caí... ¡pero volveré más loco!"
            );
        case "Resuelto":
            return choose(
                "Esta vez... no fue suficiente.",
                "Debo hacerme más fuerte...",
                "No... aún queda camino.",
                "Caeré... pero volveré."
            );
        default:
            return choose(
                "No pude... esta vez.",
                "Mi fuerza se desvanece...",
                "Aún no es mi momento..."
            );
    }
}


/// @function _scr_frase_derrota_enemigo(nombre, rango)
function _scr_frase_derrota_enemigo(_nombre, _rango) {
    if (_rango == "Jefe") {
        switch (_nombre) {
            case "Titan de las Forjas Rotas":
                return choose(
                    "La forja... se apaga...",
                    "Imposible... el fuego eterno... muere...",
                    "Mi crisol... destrozado..."
                );
            case "Coloso del Fango Viviente":
                return choose(
                    "La tierra... me reclama de vuelta...",
                    "Mis raíces... se marchitan...",
                    "El pantano... se seca..."
                );
            case "Sentinela del Cielo Roto":
                return choose(
                    "El cielo... se oscurece...",
                    "La tormenta... cesa...",
                    "Mi luz divina... se extingue..."
                );
            case "Oraculo Quebrado del Abismo":
                return choose(
                    "No vi... mi propia caída...",
                    "El vacío... me consume...",
                    "Mi profecía... estaba equivocada..."
                );
            case "El Devorador":
                return choose(
                    "Imposible... yo soy... eterno...",
                    "El vacío... rechaza mi derrota...",
                    "Consumido... por mi propio poder..."
                );
            case "El Primer Conductor":
                return choose(
                    "La sinfonía... se desafina...",
                    "Un eco... supera al maestro...",
                    "Las reglas... ya no me obedecen..."
                );
            default:
                return choose(
                    "No... esto no debía pasar...",
                    "Mi poder... se desvanece...",
                    "Has probado ser digno..."
                );
        }
    } else if (_rango == "Elite") {
        return choose(
            "Mi poder mejorado... no bastó...",
            "Imposible... soy élite...",
            "Fui superado... de nuevo...",
            "No puedo... creerlo...",
            "Esta fuerza... es real..."
        );
    } else {
        return choose(
            "No... imposible...",
            "Mi fuerza... se desvanece...",
            "He sido... superado...",
            "Maldición... eres fuerte...",
            "Derrotado... otra vez...",
            "Grrr... no volverá a pasar..."
        );
    }
}
