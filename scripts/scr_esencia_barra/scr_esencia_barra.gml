/// @file scr_esencia_barra.gml
/// @description  Barra de esencia — sistema visual premium.
///   La esencia es la mecánica distintiva del juego: debe verse épica.
///   Esta barra reemplaza la barrita simple anterior con:
///     - Barra ancha y prominente centrada en la parte inferior
///     - Relleno con gradiente elemental del personaje
///     - Glow pulsante detrás de la barra que reacciona al tier
///     - Partículas de energía flotando dentro al crecer
///     - Segmentos con marcas de tier 50% / 75% / 100%
///     - Texto estilizado con brillo
///     - Efecto de "power up" al cambiar de tier
///     - Icono de Súper con pulso al estar disponible


// ══════════════════════════════════════════════════════════════
//  MACROS DE BARRA DE ESENCIA
// ══════════════════════════════════════════════════════════════
#macro ESE_BAR_W       420    // ancho de la barra
#macro ESE_BAR_H       18     // alto de la barra (era 10, ahora más gruesa)
#macro ESE_BAR_MARGIN  30     // margen izquierdo
#macro ESE_BAR_BOTTOM  45     // distancia desde el fondo de la GUI


// ══════════════════════════════════════════════════════════════
//  scr_esencia_barra_init()
//  Inicializa variables de animación de la barra. Llamar en Create
//  del obj_control_ui_combate o donde se inicialice la UI de combate.
// ══════════════════════════════════════════════════════════════
function scr_esencia_barra_init() {
    // Valor mostrado de esencia (lerp suave hacia el real)
    ese_bar_display = 0;
    // Tier anterior (para detectar cambios de tier)
    ese_bar_tier_prev = 0;
    // Flash al subir de tier
    ese_bar_flash_timer = 0;
    // Partículas internas de la barra
    ese_bar_particulas = [];
    // Shake de la barra
    ese_bar_shake_x = 0;
    ese_bar_shake_y = 0;
}


// ══════════════════════════════════════════════════════════════
//  scr_esencia_barra_actualizar(personaje_jugador)
//  Actualizar animaciones cada frame. Llamar en Step o en Draw.
// ══════════════════════════════════════════════════════════════
function scr_esencia_barra_actualizar(_pj) {
    if (!variable_struct_exists(_pj, "esencia")) return;

    // ── Lerp suave del valor mostrado ──
    var _target = _pj.esencia;
    if (!variable_instance_exists(id, "ese_bar_display")) scr_esencia_barra_init();
    ese_bar_display = lerp(ese_bar_display, _target, 0.12);
    if (abs(ese_bar_display - _target) < 0.5) ese_bar_display = _target;

    // ── Detectar tier actual ──
    var _pct = _pj.esencia / max(1, _pj.esencia_llena);
    var _tier = 0;
    if (_pct >= 1.0) _tier = 3;
    else if (_pct >= 0.75) _tier = 2;
    else if (_pct >= 0.50) _tier = 1;

    // ── Flash al subir de tier ──
    if (_tier > ese_bar_tier_prev && ese_bar_tier_prev >= 0) {
        ese_bar_flash_timer = 20;
        ese_bar_shake_x = choose(-1, 1) * 3;
        ese_bar_shake_y = choose(-1, 1) * 2;
    }
    ese_bar_tier_prev = _tier;

    // ── Decrementar flash ──
    if (ese_bar_flash_timer > 0) ese_bar_flash_timer -= 1;

    // ── Shake decay ──
    ese_bar_shake_x *= 0.8;
    ese_bar_shake_y *= 0.8;
    if (abs(ese_bar_shake_x) < 0.3) ese_bar_shake_x = 0;
    if (abs(ese_bar_shake_y) < 0.3) ese_bar_shake_y = 0;

    // ── Generar partículas internas ──
    if (_pct >= 0.50) {
        // Más partículas cuanto más esencia hay
        var _spawn_chance = 0.12;
        if (_tier == 3) _spawn_chance = 0.4;
        else if (_tier == 2) _spawn_chance = 0.25;
        if (random(1) < _spawn_chance) {
            var _ratio = clamp(ese_bar_display / max(1, _pj.esencia_llena), 0, 1);
            array_push(ese_bar_particulas, {
                x: random(_ratio),          // posición normalizada 0..1 dentro de la barra llena
                y: random(1),               // posición Y normalizada dentro de la barra
                vx: random_range(0.002, 0.008),  // velocidad horizontal
                vy: random_range(-0.02, 0.02),   // fluctuación vertical
                life: irandom_range(25, 50),
                life_max: 50,
                size: random_range(1.5, 3.5),
            });
        }
    }

    // ── Actualizar partículas ──
    for (var i = array_length(ese_bar_particulas) - 1; i >= 0; i--) {
        var _p = ese_bar_particulas[i];
        _p.x += _p.vx;
        _p.y += _p.vy;
        _p.vy *= 0.95;
        _p.life -= 1;
        if (_p.life <= 0 || _p.x > 1.05) {
            array_delete(ese_bar_particulas, i, 1);
        }
    }
}


// ══════════════════════════════════════════════════════════════
//  scr_esencia_barra_dibujar(personaje_jugador)
//  Dibujar la barra de esencia completa. Llamar en Draw GUI.
// ══════════════════════════════════════════════════════════════
function scr_esencia_barra_dibujar(_pj) {
    if (!variable_struct_exists(_pj, "esencia")) return;

    // Inicializar si es la primera vez
    if (!variable_instance_exists(id, "ese_bar_display")) scr_esencia_barra_init();

    // Actualizar animaciones
    scr_esencia_barra_actualizar(_pj);

    var _h_gui = display_get_gui_height();

    // ── Posiciones ──
    var _bx = ESE_BAR_MARGIN + ese_bar_shake_x;
    var _by = _h_gui - ESE_BAR_BOTTOM + ese_bar_shake_y;
    var _bw = ESE_BAR_W;
    var _bh = ESE_BAR_H;

    // Ratios
    var _ratio_display = clamp(ese_bar_display / max(1, _pj.esencia_llena), 0, 1);
    var _ratio_real    = clamp(_pj.esencia / max(1, _pj.esencia_llena), 0, 1);

    // Tier y colores
    var _tier = 0;
    var _afinidad = variable_struct_exists(_pj, "afinidad") ? _pj.afinidad : "Neutra";
    var _paleta = scr_paleta_afinidad(_afinidad);

    if (_ratio_real >= 1.0) _tier = 3;
    else if (_ratio_real >= 0.75) _tier = 2;
    else if (_ratio_real >= 0.50) _tier = 1;

    // Colores por tier
    var _col_base, _col_brillo, _col_glow;
    switch (_tier) {
        case 3:  // 100% — SÚPER CARGADO
            _col_base   = _paleta.energia;
            _col_brillo = c_white;
            _col_glow   = _paleta.energia;
            break;
        case 2:  // 75%+
            _col_base   = _paleta.secundario;
            _col_brillo = _paleta.energia;
            _col_glow   = _paleta.secundario;
            break;
        case 1:  // 50%+
            _col_base   = merge_color(_paleta.dominante, _paleta.secundario, 0.5);
            _col_brillo = _paleta.secundario;
            _col_glow   = _paleta.dominante;
            break;
        default: // <50%
            _col_base   = _paleta.dominante;
            _col_brillo = _paleta.dominante;
            _col_glow   = make_color_rgb(40, 30, 80);
            break;
    }

    // Pulso temporal
    var _t = current_time;
    var _pulse = 0.5 + 0.5 * sin(_t / 350);
    var _pulse_rapido = 0.5 + 0.5 * sin(_t / 180);

    // ════════════════════════════════════════
    //  1. GLOW DETRÁS DE LA BARRA (additive) + Shader elemental
    // ════════════════════════════════════════
    if (_tier >= 1) {
        var _glow_alpha = 0.0;
        var _glow_expand = 0;
        switch (_tier) {
            case 1: _glow_alpha = 0.08 + 0.04 * _pulse; _glow_expand = 2; break;
            case 2: _glow_alpha = 0.15 + 0.08 * _pulse; _glow_expand = 4; break;
            case 3: _glow_alpha = 0.25 + 0.15 * _pulse; _glow_expand = 6; break;
        }

        // Shader tint elemental sobre el glow
        var _glow_shader_on = false;
        if (_tier >= 2 && shader_is_compiled(shd_color_tint)) {
            var _rgb = scr_color_afinidad_rgb(_afinidad);
            var _glow_mix = (_tier == 3) ? 0.6 : 0.4;
            _glow_mix += 0.15 * _pulse;
            scr_shader_tint_set(_rgb[0], _rgb[1], _rgb[2], _glow_mix);
            _glow_shader_on = true;
        }

        gpu_set_blendmode(bm_add);
        draw_set_color(_col_glow);
        draw_set_alpha(_glow_alpha);
        draw_roundrect_ext(
            _bx - _glow_expand, _by - _glow_expand,
            _bx + _bw + _glow_expand, _by + _bh + _glow_expand,
            6, 6, false
        );
        draw_set_alpha(1);
        gpu_set_blendmode(bm_normal);
        if (_glow_shader_on) shader_reset();
    }

    // ════════════════════════════════════════
    //  2. FLASH AL SUBIR DE TIER
    // ════════════════════════════════════════
    if (ese_bar_flash_timer > 0) {
        var _flash_alpha = (ese_bar_flash_timer / 20) * 0.5;
        gpu_set_blendmode(bm_add);
        draw_set_color(c_white);
        draw_set_alpha(_flash_alpha);
        draw_roundrect_ext(
            _bx - 4, _by - 4,
            _bx + _bw + 4, _by + _bh + 4,
            5, 5, false
        );
        draw_set_alpha(1);
        gpu_set_blendmode(bm_normal);
    }

    // ════════════════════════════════════════
    //  3. FONDO DE LA BARRA (oscuro, con borde)
    // ════════════════════════════════════════
    // Fondo oscuro
    draw_set_color(make_color_rgb(15, 12, 25));
    draw_set_alpha(0.85);
    draw_roundrect_ext(_bx, _by, _bx + _bw, _by + _bh, 3, 3, false);
    draw_set_alpha(1);

    // ════════════════════════════════════════
    //  4. RELLENO DE ESENCIA (gradiente elemental + shader tint)
    // ════════════════════════════════════════
    if (_ratio_display > 0) {
        var _fill_w = _bw * _ratio_display;

        // Shader tint elemental sobre el relleno
        var _fill_shader_on = false;
        if (shader_is_compiled(shd_color_tint)) {
            var _rgb = scr_color_afinidad_rgb(_afinidad);
            // Mezcla más intensa a mayor tier: T0=0.15, T1=0.25, T2=0.35, T3=0.5
            var _fill_mix = 0.15 + _tier * 0.12;
            // Pulso sutil del tinte
            _fill_mix += 0.05 * _pulse;
            scr_shader_tint_set(_rgb[0], _rgb[1], _rgb[2], _fill_mix);
            _fill_shader_on = true;
        }

        // Relleno principal — color base
        draw_set_color(_col_base);
        draw_set_alpha(0.9);
        draw_roundrect_ext(_bx, _by, _bx + _fill_w, _by + _bh, 3, 3, false);

        // Brillo superior (highlight en el tercio superior de la barra)
        draw_set_color(_col_brillo);
        var _brillo_extra = 0;
        if (_tier >= 2) _brillo_extra = 0.1 * _pulse;
        draw_set_alpha(0.25 + _brillo_extra);
        draw_rectangle(_bx + 2, _by + 1, _bx + _fill_w - 2, _by + _bh * 0.35, false);
        draw_set_alpha(1);

        if (_fill_shader_on) shader_reset();

        // ── Borde brillante del frente de la barra (edge glow) ──
        if (_ratio_display < 0.98) {
            var _edge_x = _bx + _fill_w;
            var _edge_alpha = 0.4 + 0.3 * _pulse_rapido;
            if (_tier >= 2) _edge_alpha = 0.6 + 0.3 * _pulse_rapido;
            draw_set_color(_col_brillo);
            draw_set_alpha(_edge_alpha);
            draw_line_width(_edge_x, _by + 1, _edge_x, _by + _bh - 1, 2);
            draw_set_alpha(1);
        }
    }

    // ════════════════════════════════════════
    //  5. PARTÍCULAS INTERNAS (con shader tint elemental)
    // ════════════════════════════════════════
    if (array_length(ese_bar_particulas) > 0) {
        // Shader tint elemental sobre las partículas
        var _part_shader_on = false;
        if (_tier >= 1 && shader_is_compiled(shd_color_tint)) {
            var _rgb = scr_color_afinidad_rgb(_afinidad);
            scr_shader_tint_set(_rgb[0], _rgb[1], _rgb[2], 0.3 + _tier * 0.1);
            _part_shader_on = true;
        }

        gpu_set_blendmode(bm_add);
        for (var i = 0; i < array_length(ese_bar_particulas); i++) {
            var _p = ese_bar_particulas[i];
            var _px = _bx + _p.x * _bw;
            var _py = _by + _p.y * _bh;
            var _pa = (_p.life / _p.life_max) * (0.5 + 0.3 * _pulse_rapido);
            draw_set_color(_col_brillo);
            draw_set_alpha(_pa);
            draw_circle(_px, _py, _p.size, false);
        }
        draw_set_alpha(1);
        gpu_set_blendmode(bm_normal);
        if (_part_shader_on) shader_reset();
    }

    // ════════════════════════════════════════
    //  6. MARCADORES DE TIER (50%, 75%)
    // ════════════════════════════════════════
    var _marks = [0.50, 0.75];
    for (var m = 0; m < 2; m++) {
        var _mx = _bx + _bw * _marks[m];
        var _mark_tier = m + 1; // mark 0 = tier 1 (50%), mark 1 = tier 2 (75%)

        if (_ratio_real >= _marks[m]) {
            // Marca activa — color brillante
            draw_set_color(_col_brillo);
            draw_set_alpha(0.8);
        } else {
            // Marca inactiva — tenue
            draw_set_color(make_color_rgb(100, 90, 120));
            draw_set_alpha(0.5);
        }
        draw_line_width(_mx, _by - 1, _mx, _by + _bh + 1, 1.5);

        // Pequeño diamante encima de la marca
        var _dy = _by - 3;
        var _ds = 2;
        draw_triangle(_mx - _ds, _dy, _mx + _ds, _dy, _mx, _dy - _ds, false);
    }
    draw_set_alpha(1);

    // ════════════════════════════════════════
    //  7. BORDE EXTERIOR DE LA BARRA
    // ════════════════════════════════════════
    var _borde_col = (_tier >= 1) ? _col_base : make_color_rgb(80, 70, 100);
    if (_tier == 3) {
        // Borde pulsante brillante al 100%
        _borde_col = merge_color(_col_base, c_white, _pulse * 0.4);
    }
    draw_set_color(_borde_col);
    draw_set_alpha(0.9);
    draw_roundrect_ext(_bx, _by, _bx + _bw, _by + _bh, 3, 3, true);
    draw_set_alpha(1);

    // ════════════════════════════════════════
    //  8. TEXTO + ICONO DE SÚPER
    // ════════════════════════════════════════
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);

    var _text_x = _bx + _bw + 12;
    var _text_y = _by + _bh * 0.5;

    // Label
    var _pct_num = round(_pj.esencia);
    var _label = "";

    if (_tier >= 1) {
        // Icono de súper con pulso
        var _ico_size = 28;
        if (_tier == 3) _ico_size = 32;
        var _ico_scale = _ico_size / sprite_get_width(spr_ico_super);
        var _ico_x = _text_x;
        var _ico_y = _text_y - _ico_size * 0.4;

        // Glow detrás del icono al 100%
        if (_tier == 3) {
            var _ico_glow_s = _ico_scale * (1.3 + 0.2 * _pulse);
            gpu_set_blendmode(bm_add);
            draw_sprite_ext(spr_ico_super, 0, _ico_x, _ico_y,
                _ico_glow_s, _ico_glow_s, 0, _col_glow, 0.35 * _pulse);
            gpu_set_blendmode(bm_normal);
        }

        draw_sprite_ext(spr_ico_super, 0, _ico_x, _ico_y,
            _ico_scale, _ico_scale, 0, _col_base, 1);

        _text_x = _ico_x + _ico_size + 6;

        // Texto con tier
        if (_tier == 3) {
            _label = "ESENCIA MAX — [TAB] SÚPER";
            draw_set_color(merge_color(_col_base, c_white, _pulse * 0.5));
        } else if (_tier == 2) {
            _label = string(_pct_num) + "/" + string(_pj.esencia_llena) + "  [TAB] SÚPER 75%";
            draw_set_color(_col_base);
        } else {
            _label = string(_pct_num) + "/" + string(_pj.esencia_llena) + "  [TAB] SÚPER 50%";
            draw_set_color(_col_base);
        }
    } else {
        // Sin súper disponible
        _label = "ESENCIA  " + string(_pct_num) + "/" + string(_pj.esencia_llena);
        draw_set_color(make_color_rgb(140, 130, 160));
    }

    draw_text(_text_x, _text_y, _label);

    // Sombra del texto para legibilidad
    var _prev_col = draw_get_color();
    draw_set_color(c_black);
    draw_set_alpha(0.4);
    draw_text(_text_x + 1, _text_y + 1, _label);
    draw_set_alpha(1);
    draw_set_color(_prev_col);
    draw_text(_text_x, _text_y, _label);

    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // ════════════════════════════════════════
    //  9. EFECTO ESPECIAL AL 100%: onda de energía + chromatic
    // ════════════════════════════════════════
    if (_tier == 3) {
        // Onda que se expande periódicamente
        var _wave_cycle = (_t mod 2500) / 2500.0;  // 0..1 cada 2.5 segundos
        if (_wave_cycle < 0.4) {
            var _wave_progress = _wave_cycle / 0.4;
            var _wave_alpha = (1 - _wave_progress) * 0.2;
            var _wave_expand = _wave_progress * 6;

            // Shader tint con color elemental sobre la onda
            var _wave_shader_on = false;
            if (shader_is_compiled(shd_color_tint)) {
                var _rgb = scr_color_afinidad_rgb(_afinidad);
                scr_shader_tint_set(_rgb[0], _rgb[1], _rgb[2], 0.5);
                _wave_shader_on = true;
            }

            gpu_set_blendmode(bm_add);
            draw_set_color(_col_glow);
            draw_set_alpha(_wave_alpha);
            draw_roundrect_ext(
                _bx - _wave_expand, _by - _wave_expand,
                _bx + _bw + _wave_expand, _by + _bh + _wave_expand,
                6, 6, true
            );
            draw_set_alpha(1);
            gpu_set_blendmode(bm_normal);
            if (_wave_shader_on) shader_reset();
        }

        // Barra de energía elemental pulsante al borde (línea inferior brillante)
        var _line_pulse = 0.5 + 0.5 * sin(_t / 150);
        var _rgb = scr_color_afinidad_rgb(_afinidad);
        gpu_set_blendmode(bm_add);
        draw_set_color(make_color_rgb(
            round(_rgb[0] * 255),
            round(_rgb[1] * 255),
            round(_rgb[2] * 255)
        ));
        draw_set_alpha(0.15 + 0.12 * _line_pulse);
        draw_line_width(_bx + 4, _by + _bh + 2, _bx + _bw - 4, _by + _bh + 2, 1.5);
        draw_set_alpha(1);
        gpu_set_blendmode(bm_normal);
    }
}
