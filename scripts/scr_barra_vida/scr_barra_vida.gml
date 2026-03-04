/// @file scr_barra_vida.gml
/// @description  Sistema de barra de vida multicapa estilo juegos de pelea.
///   - Cada capa representa hasta 500 HP.
///   - Color basado en la afinidad del personaje/enemigo.
///   - Reducción suave (lerp) al recibir daño.
///   - Barra-sobre-barra apilada visualmente.

#macro BARRA_VIDA_HP_POR_CAPA   500    // HP máximos por cada barra
#macro BARRA_VIDA_LERP_SPEED    0.04   // Velocidad de interpolación suave (0-1)


/// @function scr_barra_vida_init(personaje_struct)
/// @description  Inicializa las variables auxiliares de barra de vida en el struct.
///   Llamar después de crear el personaje/enemigo.
/// @param {struct} _pj  Struct del personaje o enemigo
function scr_barra_vida_init(_pj) {
    _pj.vida_visual = _pj.vida_actual;   // valor interpolado (sigue a vida_actual)
}


/// @function scr_barra_vida_update(personaje_struct)
/// @description  Actualiza la interpolación suave de vida_visual → vida_actual.
///   Llamar cada frame en Step.
/// @param {struct} _pj  Struct del personaje o enemigo
function scr_barra_vida_update(_pj) {
    // Inicializar si no existe
    if (!variable_struct_exists(_pj, "vida_visual")) {
        _pj.vida_visual = _pj.vida_actual;
    }

    // Si la vida sube (curación), subir instantáneamente
    if (_pj.vida_visual < _pj.vida_actual) {
        _pj.vida_visual = _pj.vida_actual;
    }

    // Si la vida baja (daño), interpolar suavemente
    if (_pj.vida_visual > _pj.vida_actual) {
        _pj.vida_visual = lerp(_pj.vida_visual, _pj.vida_actual, BARRA_VIDA_LERP_SPEED);

        // Snap final para no quedarse arrastrando décimas
        if (abs(_pj.vida_visual - _pj.vida_actual) < 1) {
            _pj.vida_visual = _pj.vida_actual;
        }
    }
}


/// @function scr_barra_vida_draw(x, y, w, h, personaje_struct, invertir)
/// @description  Dibuja la barra de vida multicapa con colores de afinidad.
/// @param {real}   _x        Posición X (izquierda de la barra)
/// @param {real}   _y        Posición Y (parte superior de la barra)
/// @param {real}   _w        Ancho total de la barra
/// @param {real}   _h        Alto de la barra
/// @param {struct} _pj       Struct del personaje o enemigo
/// @param {bool}   _invertir Si true, la barra se llena de derecha a izquierda (para enemigos)
function scr_barra_vida_draw(_x, _y, _w, _h, _pj, _invertir) {

    // Inicializar vida_visual si falta
    if (!variable_struct_exists(_pj, "vida_visual")) {
        _pj.vida_visual = _pj.vida_actual;
    }

    var _vida_max    = max(1, _pj.vida_max);
    var _vida_actual = max(0, _pj.vida_actual);
    var _vida_visual = max(0, _pj.vida_visual);

    // ── Obtener colores de la afinidad ──
    var _afi = _pj.afinidad;
    var _paleta = scr_paleta_afinidad(_afi);
    var _col_lleno     = _paleta.dominante;   // Color principal de la barra actual
    var _col_secundario = _paleta.secundario; // Color de la barra inferior (capa previa)
    var _col_dano      = _paleta.energia;     // Color de la franja de daño suave

    // ── Calcular capas ──
    var _num_capas = ceil(_vida_max / BARRA_VIDA_HP_POR_CAPA);
    _num_capas = max(1, _num_capas);

    // Capa actual de vida_actual (1-based)
    var _capa_actual = clamp(ceil(_vida_actual / BARRA_VIDA_HP_POR_CAPA), 0, _num_capas);
    if (_vida_actual <= 0) _capa_actual = 0;

    // Capa actual de vida_visual
    var _capa_visual = clamp(ceil(_vida_visual / BARRA_VIDA_HP_POR_CAPA), 0, _num_capas);
    if (_vida_visual <= 0) _capa_visual = 0;

    // HP dentro de la capa actual (para vida_actual)
    var _hp_en_capa     = (_capa_actual > 0) ? (_vida_actual - (_capa_actual - 1) * BARRA_VIDA_HP_POR_CAPA) : 0;
    var _hp_max_en_capa = BARRA_VIDA_HP_POR_CAPA;

    // Si es la última capa, el máximo puede ser menor
    if (_capa_actual == _num_capas) {
        _hp_max_en_capa = _vida_max - (_num_capas - 1) * BARRA_VIDA_HP_POR_CAPA;
    }
    _hp_max_en_capa = max(1, _hp_max_en_capa);

    // Ratio de llenado de la barra real
    var _ratio_actual = clamp(_hp_en_capa / _hp_max_en_capa, 0, 1);

    // HP dentro de la capa para vida_visual (daño suave)
    var _hp_visual_en_capa = 0;
    var _ratio_visual = 0;

    if (_capa_visual == _capa_actual && _capa_actual > 0) {
        // Ambos en la misma capa
        _hp_visual_en_capa = _vida_visual - (_capa_actual - 1) * BARRA_VIDA_HP_POR_CAPA;
        _ratio_visual = clamp(_hp_visual_en_capa / _hp_max_en_capa, 0, 1);
    } else if (_capa_visual > _capa_actual) {
        // La visual aún está en una capa superior → barra visual llena
        _ratio_visual = 1;
    } else {
        _ratio_visual = _ratio_actual;
    }

    // ── Colores según capa (alternar tono para distinguir capas) ──
    // Capa inferior se muestra como el color secundario de afinidad
    var _col_barra_actual = _col_lleno;
    var _col_barra_bajo   = _col_secundario;

    // Si quedan capas debajo, oscurecer ligeramente la capa inferior
    var _tiene_capa_bajo = (_capa_actual > 1);

    // ══════════════════════════════════════════════════════════════
    //  DIBUJO
    // ══════════════════════════════════════════════════════════════

    // 1. FONDO OSCURO (barra vacía)
    draw_set_color(make_color_rgb(20, 20, 20));
    draw_set_alpha(0.85);
    draw_rectangle(_x, _y, _x + _w, _y + _h, false);
    draw_set_alpha(1);

    // 2. CAPA INFERIOR (si hay capas debajo, mostrar barra llena con color secundario)
    if (_tiene_capa_bajo) {
        draw_set_color(_col_barra_bajo);
        draw_set_alpha(0.6);
        if (_invertir) {
            draw_rectangle(_x, _y, _x + _w, _y + _h, false);
        } else {
            draw_rectangle(_x, _y, _x + _w, _y + _h, false);
        }
        draw_set_alpha(1);
    }

    // 3. FRANJA DE DAÑO SUAVE (vida_visual > vida_actual dentro de la capa)
    if (_ratio_visual > _ratio_actual && _capa_visual == _capa_actual) {
        draw_set_color(_col_dano);
        draw_set_alpha(0.7);
        if (_invertir) {
            var _dano_x1 = _x + _w * (1 - _ratio_visual);
            var _dano_x2 = _x + _w * (1 - _ratio_actual);
            draw_rectangle(_dano_x1, _y, _dano_x2, _y + _h, false);
        } else {
            var _dano_x1 = _x + _w * _ratio_actual;
            var _dano_x2 = _x + _w * _ratio_visual;
            draw_rectangle(_dano_x1, _y, _dano_x2, _y + _h, false);
        }
        draw_set_alpha(1);
    }

    // Si la capa visual es superior a la actual, dibujar franja de daño cruzando capas
    if (_capa_visual > _capa_actual && _vida_visual > _vida_actual) {
        draw_set_color(_col_dano);
        draw_set_alpha(0.7);
        if (_invertir) {
            var _cross_x1 = _x + _w * (1 - 1);  // empieza llena
            var _cross_x2 = _x + _w * (1 - _ratio_actual);
            draw_rectangle(_cross_x1, _y, _cross_x2, _y + _h, false);
        } else {
            var _cross_x1 = _x + _w * _ratio_actual;
            var _cross_x2 = _x + _w;
            draw_rectangle(_cross_x1, _y, _cross_x2, _y + _h, false);
        }
        draw_set_alpha(1);
    }

    // 4. BARRA DE VIDA ACTUAL (capa actual)
    if (_ratio_actual > 0) {
        draw_set_color(_col_barra_actual);
        draw_set_alpha(1);
        if (_invertir) {
            draw_rectangle(_x + _w * (1 - _ratio_actual), _y, _x + _w, _y + _h, false);
        } else {
            draw_rectangle(_x, _y, _x + _w * _ratio_actual, _y + _h, false);
        }
    }

    // 5. MARCAS DE SEPARACIÓN (divisiones cada 500 HP si hay más de una capa)
    //    Solo se muestran sobre la barra llena para dar referencia visual
    // (omitidas en capa actual, ya que la barra actual ES la capa)

    // 6. BORDE / MARCO
    draw_set_color(make_color_rgb(200, 200, 200));
    draw_set_alpha(0.9);
    draw_rectangle(_x, _y, _x + _w, _y + _h, true);
    draw_set_alpha(1);

    // 7. INDICADOR DE CAPAS — pequeñas muescas debajo de la barra
    if (_num_capas > 1) {
        var _muesca_y = _y + _h + 2;
        var _muesca_h = 3;
        var _muesca_w = max(4, _w / _num_capas - 2);
        var _muesca_gap = _w / _num_capas;

        for (var _c = 0; _c < _num_capas; _c++) {
            var _mx = _x + _c * _muesca_gap + 1;

            if (_c < _capa_actual) {
                // Capa llena
                draw_set_color(_col_barra_actual);
                draw_set_alpha(0.8);
            } else if (_c == _capa_actual - 1) {
                // Capa actual (parcial) — con el color de energía
                draw_set_color(_col_dano);
                draw_set_alpha(1);
            } else {
                // Capa vacía
                draw_set_color(make_color_rgb(50, 50, 50));
                draw_set_alpha(0.5);
            }

            draw_rectangle(_mx, _muesca_y, _mx + _muesca_w, _muesca_y + _muesca_h, false);
        }
        draw_set_alpha(1);
    }

    // 8. TEXTO DE HP
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_set_alpha(1);

    var _hp_text = string(max(0, _vida_actual)) + " / " + string(_vida_max);

    // Si hay múltiples capas, mostrar también el indicador de capa
    if (_num_capas > 1 && _capa_actual > 0) {
        _hp_text = _hp_text + "  [x" + string(_capa_actual) + "]";
    }

    draw_text(_x + _w / 2, _y + _h / 2, _hp_text);

    // Restaurar defaults
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_set_alpha(1);
}
