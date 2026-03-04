/// @file scr_fx_jefe.gml
/// @description  Sistema de efectos visuales para enemigos JEFE.
///   Los jefes son los encuentros finales de cada zona y deben verse
///   imponentes e intimidantes. Efectos aplicados:
///     - Escala 1.5x (50% más grandes que los comunes)
///     - Doble aura pulsante (interna rápida + externa lenta)
///     - Sombra oscura proyectada debajo del sprite
///     - Partículas de energía orbitando alrededor
///     - Colores basados en su afinidad dual


/// scr_fx_jefe_datos(nombre_enemigo)
/// Devuelve un struct con los datos de FX visual para un jefe.
/// @param {string} _nombre  Nombre completo del jefe
/// @returns {struct|undefined}
function scr_fx_jefe_datos(_nombre) {

    switch (_nombre) {

        case "Titan de las Forjas Rotas":
            return {
                // Colores de aura basados en afinidad dual Fuego-Tierra
                aura_color_1:    make_color_rgb(255, 80, 0),     // Fuego — naranja intenso
                aura_color_2:    make_color_rgb(180, 140, 60),   // Tierra — ocre dorado
                aura_intensidad: 0.45,
                // Escala del jefe (multiplicador sobre escala base)
                escala_mult:     1.5,
                // Color de las partículas orbitantes
                particula_color: make_color_rgb(255, 160, 40),
                // Color de la sombra
                sombra_color:    make_color_rgb(80, 30, 0),
            };

        case "Coloso del Fango Viviente":
            return {
                // Agua-Planta
                aura_color_1:    make_color_rgb(40, 180, 255),   // Agua — azul brillante
                aura_color_2:    make_color_rgb(60, 200, 80),    // Planta — verde vivo
                aura_intensidad: 0.40,
                escala_mult:     1.5,
                particula_color: make_color_rgb(80, 220, 160),
                sombra_color:    make_color_rgb(20, 60, 40),
            };

        case "Sentinela del Cielo Roto":
            return {
                // Rayo-Luz
                aura_color_1:    make_color_rgb(200, 200, 255),  // Rayo — blanco eléctrico
                aura_color_2:    make_color_rgb(255, 230, 100),  // Luz — dorado brillante
                aura_intensidad: 0.50,
                escala_mult:     1.5,
                particula_color: make_color_rgb(255, 255, 200),
                sombra_color:    make_color_rgb(60, 60, 100),
            };

        case "Oraculo Quebrado del Abismo":
            return {
                // Sombra-Arcano
                aura_color_1:    make_color_rgb(120, 40, 200),   // Sombra — púrpura oscuro
                aura_color_2:    make_color_rgb(200, 80, 255),   // Arcano — violeta brillante
                aura_intensidad: 0.45,
                escala_mult:     1.5,
                particula_color: make_color_rgb(180, 100, 255),
                sombra_color:    make_color_rgb(40, 10, 60),
            };

        default:
            return undefined;
    }
}


/// scr_fx_jefe_dibujar(sprite, x, y, escala_base, fx_datos, flip, blend, alpha)
/// Dibuja un sprite de jefe con todos los efectos visuales intimidantes.
/// @param {sprite}  _spr           Sprite a dibujar
/// @param {real}    _x             Posición X
/// @param {real}    _y             Posición Y
/// @param {real}    _escala_base   Escala base calculada (display_h / sprite_h)
/// @param {struct}  _jf            Datos de FX jefe (de scr_fx_jefe_datos)
/// @param {bool}    _flip          true = flip horizontal (xscale negativa)
/// @param {real}    _blend         Color de blend base (c_white normal, o flash color)
/// @param {real}    _alpha         Alpha base (1.0 normal, o flash alpha)
function scr_fx_jefe_dibujar(_spr, _x, _y, _escala_base, _jf, _flip, _blend, _alpha) {

    var _esc = _escala_base * _jf.escala_mult;
    var _xsc = _flip ? -_esc : _esc;

    // ── ANCLAR AL SUELO: usar la misma línea de suelo que el sprite base ──
    // La Y recibida ya está anclada para _escala_base, recalcular para _esc.
    var _bbox_bottom = sprite_get_bbox_bottom(_spr);
    var _yoffset     = sprite_get_yoffset(_spr);
    var _dist_base   = _bbox_bottom - _yoffset;
    var _suelo_y_rec = _y + _dist_base * _escala_base;
    var _y_adj       = _suelo_y_rec - _dist_base * _esc;

    // Pulsos de tiempo para animaciones
    var _t = current_time;
    var _pulse_rapido = 0.5 + 0.5 * sin(_t / 300);    // pulso rápido (aura interna)
    var _pulse_lento  = 0.5 + 0.5 * sin(_t / 800);    // pulso lento  (aura externa)
    var _pulse_medio  = 0.5 + 0.5 * sin(_t / 500);    // pulso medio  (partículas)

    // ── 1. SOMBRA OSCURA debajo del sprite ──
    // Elipse oscura aplastada en la base del sprite para darle peso y presencia
    var _sombra_y = _suelo_y_rec - 4;
    var _sombra_w = sprite_get_width(_spr) * _esc * 0.5;
    var _sombra_h = 12 + 4 * _pulse_lento;
    var _sombra_alpha = 0.35 + 0.1 * _pulse_lento;

    draw_set_color(_jf.sombra_color);
    draw_set_alpha(_sombra_alpha);
    draw_ellipse(_x - _sombra_w, _sombra_y - _sombra_h,
                 _x + _sombra_w, _sombra_y + _sombra_h, false);
    draw_set_alpha(1.0);
    draw_set_color(c_white);

    // ── 2. AURA EXTERNA (lenta, color secundario, más grande) ──
    var _aura_ext_alpha = _jf.aura_intensidad * 0.5 * _pulse_lento;
    var _aura_ext_esc   = _esc * (1.12 + 0.06 * _pulse_lento);
    var _aura_ext_xsc   = _flip ? -_aura_ext_esc : _aura_ext_esc;

    gpu_set_blendmode(bm_add);
    draw_sprite_ext(_spr, 0, _x, _y_adj, _aura_ext_xsc, _aura_ext_esc, 0,
                    _jf.aura_color_2, _aura_ext_alpha);

    // ── 3. AURA INTERNA (rápida, color primario, más ceñida) ──
    var _aura_int_alpha = _jf.aura_intensidad * _pulse_rapido;
    var _aura_int_esc   = _esc * (1.04 + 0.04 * _pulse_rapido);
    var _aura_int_xsc   = _flip ? -_aura_int_esc : _aura_int_esc;

    draw_sprite_ext(_spr, 0, _x, _y_adj, _aura_int_xsc, _aura_int_esc, 0,
                    _jf.aura_color_1, _aura_int_alpha);
    gpu_set_blendmode(bm_normal);

    // ── 4. SPRITE PRINCIPAL ──
    draw_sprite_ext(_spr, 0, _x, _y_adj, _xsc, _esc, 0, _blend, _alpha);

    // ── 5. PARTÍCULAS ORBITANTES de energía ──
    // 6 fragmentos de energía que orbitan alrededor del jefe
    var _n_particulas = 6;
    var _radio_base = sprite_get_height(_spr) * _esc * 0.45;
    var _angulo_offset = _t / 25;  // velocidad de rotación orbital

    gpu_set_blendmode(bm_add);
    for (var i = 0; i < _n_particulas; i++) {
        var _ang = (_angulo_offset + (360 / _n_particulas) * i) mod 360;
        var _rad = degtorad(_ang);

        // Órbita elíptica (más ancha que alta)
        var _px = _x + cos(_rad) * _radio_base * 0.7;
        var _py = _y_adj + sin(_rad) * _radio_base * 0.35;

        // Tamaño y alpha varían con posición (las de "atrás" son más tenues)
        var _depth_factor = 0.5 + 0.5 * sin(_rad);  // 0..1 según están delante/detrás
        var _p_size = (3 + 2 * _pulse_medio) * (0.6 + 0.4 * _depth_factor);
        var _p_alpha = (0.4 + 0.4 * _pulse_medio) * (0.4 + 0.6 * _depth_factor);

        // Solo dibujar las partículas que están "detrás" ANTES del sprite
        // y las que están "delante" ya se dibujan aquí (simplificado: todas post-sprite)
        draw_set_color(_jf.particula_color);
        draw_set_alpha(_p_alpha * _alpha);
        draw_circle(_px, _py, _p_size, false);
    }
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    gpu_set_blendmode(bm_normal);
}
