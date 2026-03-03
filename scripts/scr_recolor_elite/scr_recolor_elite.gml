/// @file scr_recolor_elite.gml
/// @description  Sistema de efectos visuales para enemigos élite.
///   Los élites tienen su propio sprite (generado aparte) y se les aplican
///   efectos visuales adicionales vía código:
///     - Escala 1.3x (30% más grandes que los comunes)
///     - Aura de glow pulsante con el color de energía de su afinidad


/// scr_recolor_elite_datos(nombre_enemigo)
/// Devuelve un struct con los datos de recolor para un enemigo élite.
/// Si el enemigo no es élite o no necesita recolor, devuelve undefined.
/// @param {string} _nombre  Nombre completo del enemigo (ej: "Soldado Igneo Elite")
/// @returns {struct|undefined}
function scr_recolor_elite_datos(_nombre) {

    switch (_nombre) {

        case "Soldado Igneo Elite":
            return {
                // Color del aura/glow pulsante
                aura_color:     make_color_rgb(255, 100, 0),
                // Intensidad del aura (0.0 - 1.0)
                aura_intensidad: 0.35,
                // Escala extra (multiplicador sobre la escala base)
                escala_mult:    1.3,
                // Sprite base a usar (el del enemigo común)
                sprite_comun:   "Soldado Igneo",
            };

        case "Vigia Boreal Elite":
            return {
                aura_color:     make_color_rgb(100, 200, 255),
                aura_intensidad: 0.30,
                escala_mult:    1.3,
                sprite_comun:   "Vigia Boreal",
            };

        case "Halito Verde Elite":
            return {
                aura_color:     make_color_rgb(80, 255, 50),
                aura_intensidad: 0.35,
                escala_mult:    1.3,
                sprite_comun:   "Halito Verde",
            };

        case "Bestia Tronadora Elite":
            return {
                aura_color:     make_color_rgb(100, 150, 255),
                aura_intensidad: 0.40,
                escala_mult:    1.3,
                sprite_comun:   "Bestia Tronadora",
            };

        case "Guardian Terracota Elite":
            return {
                aura_color:     make_color_rgb(0, 200, 120),
                aura_intensidad: 0.30,
                escala_mult:    1.3,
                sprite_comun:   "Guardian Terracota",
            };

        case "Naufrago de la Oscuridad Elite":
            return {
                aura_color:     make_color_rgb(150, 80, 255),
                aura_intensidad: 0.40,
                escala_mult:    1.3,
                sprite_comun:   "Naufrago de la Oscuridad",
            };

        case "Paladin Marchito Elite":
            return {
                aura_color:     make_color_rgb(255, 200, 80),
                aura_intensidad: 0.30,
                escala_mult:    1.3,
                sprite_comun:   "Paladin Marchito",
            };

        case "Errante Runico Elite":
            return {
                aura_color:     make_color_rgb(100, 0, 255),
                aura_intensidad: 0.35,
                escala_mult:    1.3,
                sprite_comun:   "Errante Runico",
            };

        default:
            return undefined;
    }
}


/// scr_recolor_elite_dibujar(sprite, x, y, escala_base, recolor_datos, flip, blend_override, alpha)
/// Dibuja un sprite de enemigo élite con todos los efectos de recolor aplicados.
/// @param {sprite}  _spr           Sprite a dibujar
/// @param {real}    _x             Posición X
/// @param {real}    _y             Posición Y
/// @param {real}    _escala_base   Escala base calculada (display_h / sprite_h)
/// @param {struct}  _rc            Datos de recolor (de scr_recolor_elite_datos)
/// @param {bool}    _flip          true = flip horizontal (xscale negativa)
/// @param {real}    _blend         Color de blend base (c_white normal, o flash color)
/// @param {real}    _alpha         Alpha base (1.0 normal, o flash alpha)
function scr_recolor_elite_dibujar(_spr, _x, _y, _escala_base, _rc, _flip, _blend, _alpha) {

    var _esc = _escala_base * _rc.escala_mult;
    var _xsc = _flip ? -_esc : _esc;

    // ── ANCLAR AL SUELO: ajustar Y para que la base del sprite se mantenga fija ──
    // Sin esto, al escalar 1.3x el sprite crece hacia abajo y se ve hundido.
    // Calculamos cuánto crece la parte inferior y lo compensamos subiendo Y.
    var _dist_abajo = sprite_get_height(_spr) - sprite_get_yoffset(_spr);
    var _y_adj = _y - _dist_abajo * (_esc - _escala_base);

    // ── 1. AURA DE GLOW (dibujada detrás, additive blending) ──
    var _aura_pulse = 0.5 + 0.5 * sin(current_time / 400);  // pulso suave
    var _aura_alpha = _rc.aura_intensidad * _aura_pulse;
    var _aura_esc   = _esc * (1.05 + 0.05 * _aura_pulse);   // ligeramente más grande que el sprite
    var _aura_xsc   = _flip ? -_aura_esc : _aura_esc;

    gpu_set_blendmode(bm_add);
    draw_sprite_ext(_spr, 0, _x, _y_adj, _aura_xsc, _aura_esc, 0, _rc.aura_color, _aura_alpha);
    gpu_set_blendmode(bm_normal);

    // ── 2. SPRITE PRINCIPAL (sin tint, usa sprite propio del élite) ──
    draw_sprite_ext(_spr, 0, _x, _y_adj, _xsc, _esc, 0, _blend, _alpha);
}
