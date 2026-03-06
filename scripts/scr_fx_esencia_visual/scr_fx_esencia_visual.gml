/// @file scr_fx_esencia_visual.gml
/// @description  Sistema visual de Esencia — la estrella del combate.
///   La esencia debe comunicar visualmente su nivel de carga:
///     - 0–49%:  sin efecto especial
///     - 50–74%: pulso sutil en la barra + leve glow en personaje
///     - 75–99%: pulso intenso + cambio visual + glow más fuerte
///     - 100%:   aura elemental completa + barra brillando
///   Al activar súper:
///     - Hitstop (congelamiento 0.2s)
///     - Screenshake fuerte
///     - Flash elemental de pantalla completa

// ══════════════════════════════════════════════════════════════
//  MACROS DE ESENCIA VISUAL
// ══════════════════════════════════════════════════════════════
#macro ESE_PULSE_SPEED      0.05    // velocidad del pulso (radianes/frame)
#macro ESE_GLOW_ALPHA_MIN   0.0     // alpha mínima del glow
#macro ESE_GLOW_ALPHA_50    0.15    // alpha del glow al 50% esencia
#macro ESE_GLOW_ALPHA_75    0.30    // alpha del glow al 75% esencia
#macro ESE_GLOW_ALPHA_100   0.50    // alpha del glow al 100% esencia
#macro ESE_GLOW_ESCALA      1.15    // escala del sprite de glow respecto al original
#macro ESE_AURA_ESCALA      1.25    // escala del aura al 100%
#macro HITSTOP_SUPER_FRAMES 12      // 0.2s a 60fps — congelamiento al activar súper
#macro SHAKE_SUPER_FRAMES   20      // duración del shake de súper
#macro SHAKE_SUPER_FUERZA   12      // fuerza del shake de súper (px)
#macro FLASH_SUPER_FRAMES   18      // duración del flash elemental de pantalla


// ══════════════════════════════════════════════════════════════
//  scr_fx_esencia_init()
//  Inicializa variables de FX de esencia en el controlador de combate.
//  Llamar en scr_feedback_init() o en el Create de obj_control_combate.
// ══════════════════════════════════════════════════════════════
function scr_fx_esencia_init() {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);

    // Pulso de esencia (oscila con sin())
    _c.ese_pulse_angle = 0;

    // Glow elemental sobre el personaje
    _c.ese_glow_alpha = 0;
    _c.ese_glow_color = c_white;

    // Aura al 100%
    _c.ese_aura_activa = false;
    _c.ese_aura_alpha  = 0;

    // Hitstop global (congela todo el combate N frames)
    _c.hitstop_timer = 0;

    // Flash de pantalla completa (elemental)
    _c.flash_pantalla_timer = 0;
    _c.flash_pantalla_color = c_white;
    _c.flash_pantalla_alpha = 0;
}


// ══════════════════════════════════════════════════════════════
//  scr_fx_esencia_actualizar()
//  Actualizar cada frame en el Step del controlador.
//  Retorna TRUE si el combate está en hitstop (congelar lógica).
// ══════════════════════════════════════════════════════════════
function scr_fx_esencia_actualizar() {
    if (!instance_exists(obj_control_combate)) return false;
    var _c = instance_find(obj_control_combate, 0);

    // ── Hitstop: si hay timer, decrementar y retornar true (congelar lógica) ──
    if (_c.hitstop_timer > 0) {
        _c.hitstop_timer -= 1;
        return true; // señal: NO ejecutar lógica de combate este frame
    }

    // ── Flash de pantalla ──
    if (_c.flash_pantalla_timer > 0) {
        _c.flash_pantalla_timer -= 1;
        _c.flash_pantalla_alpha = clamp(_c.flash_pantalla_timer / FLASH_SUPER_FRAMES, 0, 1) * 0.6;
    } else {
        _c.flash_pantalla_alpha = 0;
    }

    // ── Calcular tier de esencia del jugador ──
    var _pj = _c.personaje_jugador;
    if (!variable_struct_exists(_pj, "esencia") || !variable_struct_exists(_pj, "esencia_llena")) return false;

    var _pct = _pj.esencia / max(1, _pj.esencia_llena);
    var _afinidad = variable_struct_exists(_pj, "afinidad") ? _pj.afinidad : "Neutra";
    var _paleta = scr_paleta_afinidad(_afinidad);

    // ── Pulso ──
    _c.ese_pulse_angle += ESE_PULSE_SPEED;
    if (_c.ese_pulse_angle > pi * 2) _c.ese_pulse_angle -= pi * 2;
    var _pulse = (sin(_c.ese_pulse_angle) + 1) * 0.5; // 0..1

    // ── Glow según tier ──
    if (_pct >= 1.0) {
        // 100% — Aura completa
        _c.ese_glow_alpha = lerp(ESE_GLOW_ALPHA_100, ESE_GLOW_ALPHA_100 + 0.2, _pulse);
        _c.ese_glow_color = _paleta.energia;
        _c.ese_aura_activa = true;
        _c.ese_aura_alpha = lerp(0.2, 0.45, _pulse);
    } else if (_pct >= 0.75) {
        // 75–99% — Glow intenso + pulso rápido
        _c.ese_glow_alpha = lerp(ESE_GLOW_ALPHA_75, ESE_GLOW_ALPHA_75 + 0.15, _pulse);
        _c.ese_glow_color = merge_color(_paleta.secundario, _paleta.energia, _pulse);
        _c.ese_aura_activa = false;
        _c.ese_aura_alpha = 0;
    } else if (_pct >= 0.50) {
        // 50–74% — Pulso sutil
        _c.ese_glow_alpha = lerp(ESE_GLOW_ALPHA_50, ESE_GLOW_ALPHA_50 + 0.08, _pulse);
        _c.ese_glow_color = _paleta.secundario;
        _c.ese_aura_activa = false;
        _c.ese_aura_alpha = 0;
    } else {
        // <50% — Sin glow
        _c.ese_glow_alpha = 0;
        _c.ese_aura_activa = false;
        _c.ese_aura_alpha = 0;
    }

    return false; // no hitstop
}


// ══════════════════════════════════════════════════════════════
//  scr_fx_activar_super(afinidad, [atacante])
//  Llamar cuando se ejecuta una Súper-Habilidad.
//  Activa: hitstop + screenshake + flash elemental + zoom + blur.
//  Si se pasa _atacante, el foco se centra en él (jugador o enemigo).
// ══════════════════════════════════════════════════════════════
function scr_fx_activar_super(_afinidad, _atacante) {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);

    var _paleta = scr_paleta_afinidad(_afinidad);

    // Hitstop: congelar 0.2s
    _c.hitstop_timer = HITSTOP_SUPER_FRAMES;

    // Screenshake fuerte
    _c.fb_shake_timer[0] = SHAKE_SUPER_FRAMES;
    _c.fb_shake_timer[1] = SHAKE_SUPER_FRAMES;

    // Flash elemental de pantalla completa
    _c.flash_pantalla_timer = FLASH_SUPER_FRAMES;
    _c.flash_pantalla_color = _paleta.energia;
    _c.flash_pantalla_alpha = 0.6;

    // ── Zoom dinámico: close-up al atacante, oscurecer al otro ──
    // Determinar quién usa la súper (jugador o enemigo)
    var _es_jugador = true;
    if (_atacante != undefined && variable_struct_exists(_atacante, "es_jugador")) {
        _es_jugador = _atacante.es_jugador;
    }
    _c.foco_quien      = _es_jugador ? 1 : 2;
    _c.foco_escala_obj = 1.2;    // zoom 20%
    _c.foco_dim_obj    = 0.25;   // oscurecer al otro al 25% alpha
    _c.foco_vel        = 0.08;   // interpolación rápida

    // Auto-restaurar foco después del hitstop (programar restauración)
    _c.foco_super_restore_timer = HITSTOP_SUPER_FRAMES + round(GAME_FPS * 0.8);

    // ── Blur del escenario (surface-based) ──
    _c.super_blur_timer = HITSTOP_SUPER_FRAMES + round(GAME_FPS * 0.6);
    _c.super_blur_alpha = 0.85;

    // ── Aberración cromática durante el súper ──
    scr_shader_chromatic_disparar(HITSTOP_SUPER_FRAMES + round(GAME_FPS * 0.5));

    // Efecto FX de súper
    scr_feedback_fx(_es_jugador, "super");
}


// ══════════════════════════════════════════════════════════════
//  scr_fx_hitstop(frames)
//  Activa hitstop genérico (para golpes críticos, impactos fuertes).
// ══════════════════════════════════════════════════════════════
function scr_fx_hitstop(_frames) {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);
    _c.hitstop_timer = max(_c.hitstop_timer, _frames);
}


// ══════════════════════════════════════════════════════════════
//  scr_fx_flash_elemental(afinidad)
//  Flash de pantalla corto con el color de energía de la afinidad.
//  Para habilidades elementales (no súper).
// ══════════════════════════════════════════════════════════════
function scr_fx_flash_elemental(_afinidad) {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);

    var _paleta = scr_paleta_afinidad(_afinidad);
    _c.flash_pantalla_timer = round(FLASH_SUPER_FRAMES * 0.5);
    _c.flash_pantalla_color = _paleta.energia;
    _c.flash_pantalla_alpha = 0.35;
}


// ══════════════════════════════════════════════════════════════
//  scr_fx_esencia_dibujar_glow()
//  Dibuja el glow elemental sobre el sprite del jugador.
//  Usa additive blending para efecto de energía.
//  Llamar en Draw GUI DESPUÉS de scr_feedback_dibujar_sprites().
// ══════════════════════════════════════════════════════════════
function scr_fx_esencia_dibujar_glow() {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);

    // Ocultar efecto de esencia cuando el combate terminó
    if (_c.combate_terminado) return;

    if (_c.ese_glow_alpha <= 0) return;

    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();

    // Sprite del jugador
    var _spr_j = (variable_struct_exists(_c, "personaje_jugador") && variable_struct_exists(_c.personaje_jugador, "sprite_cuerpo"))
                 ? _c.personaje_jugador.sprite_cuerpo : spr_jugador;

    var _display_h = 345;
    var _escala_base = _display_h / sprite_get_height(_spr_j);

    // Posición del jugador anclada al suelo (misma línea que en scr_feedback_dibujar_sprites)
    var _suelo_y = _gui_h * 0.82;
    var _pj_x = _gui_w * 0.22 + _c.fb_shake_offset_x[0];
    var _pj_y = scr_sprite_y_anclado_suelo(_spr_j, _suelo_y, _escala_base) + _c.fb_shake_offset_y[0];

    // ── Glow: dibujar sprite más grande con additive blending ──
    gpu_set_blendmode(bm_add);
    var _escala_glow = _escala_base * ESE_GLOW_ESCALA;
    var _pj_y_glow = scr_sprite_y_anclado_suelo(_spr_j, _suelo_y, _escala_glow) + _c.fb_shake_offset_y[0];
    draw_sprite_ext(_spr_j, 0, _pj_x, _pj_y_glow,
        _escala_glow, _escala_glow, 0,
        _c.ese_glow_color, _c.ese_glow_alpha);

    // ── Aura al 100%: segunda capa más grande ──
    if (_c.ese_aura_activa) {
        var _escala_aura = _escala_base * ESE_AURA_ESCALA;
        var _pj_y_aura = scr_sprite_y_anclado_suelo(_spr_j, _suelo_y, _escala_aura) + _c.fb_shake_offset_y[0];
        draw_sprite_ext(_spr_j, 0, _pj_x, _pj_y_aura,
            _escala_aura, _escala_aura, 0,
            _c.ese_glow_color, _c.ese_aura_alpha * 0.5);
    }

    gpu_set_blendmode(bm_normal);
}


// ══════════════════════════════════════════════════════════════
//  scr_fx_esencia_dibujar_barra_pulse()
//  Modifica visualmente la barra de esencia según el tier.
//  Devuelve un struct con modificadores para dibujar la barra.
//  @returns {struct} { escala_x, escala_y, color_tint, alpha_extra, pulsa }
// ══════════════════════════════════════════════════════════════
function scr_fx_esencia_dibujar_barra_pulse() {
    if (!instance_exists(obj_control_combate)) {
        return { escala_x: 1, escala_y: 1, color_tint: c_white, alpha_extra: 0, pulsa: false };
    }
    var _c = instance_find(obj_control_combate, 0);
    var _pj = _c.personaje_jugador;
    var _pct = _pj.esencia / max(1, _pj.esencia_llena);

    var _pulse = (sin(_c.ese_pulse_angle) + 1) * 0.5;
    var _afinidad = variable_struct_exists(_pj, "afinidad") ? _pj.afinidad : "Neutra";
    var _paleta = scr_paleta_afinidad(_afinidad);

    if (_pct >= 1.0) {
        return {
            escala_x: 1.0 + _pulse * 0.04,
            escala_y: 1.0 + _pulse * 0.06,
            color_tint: _paleta.energia,
            alpha_extra: _pulse * 0.3,
            pulsa: true,
        };
    } else if (_pct >= 0.75) {
        return {
            escala_x: 1.0 + _pulse * 0.02,
            escala_y: 1.0 + _pulse * 0.03,
            color_tint: merge_color(_paleta.secundario, _paleta.energia, _pulse),
            alpha_extra: _pulse * 0.15,
            pulsa: true,
        };
    } else if (_pct >= 0.50) {
        return {
            escala_x: 1.0 + _pulse * 0.01,
            escala_y: 1.0 + _pulse * 0.015,
            color_tint: _paleta.secundario,
            alpha_extra: _pulse * 0.08,
            pulsa: true,
        };
    }

    return { escala_x: 1, escala_y: 1, color_tint: c_white, alpha_extra: 0, pulsa: false };
}


// ══════════════════════════════════════════════════════════════
//  scr_fx_dibujar_flash_pantalla()
//  Dibuja el flash de pantalla completa (para súper y habilidades).
//  Llamar como ÚLTIMA capa en Draw GUI.
// ══════════════════════════════════════════════════════════════
function scr_fx_dibujar_flash_pantalla() {
    if (!instance_exists(obj_control_combate)) return;
    var _c = instance_find(obj_control_combate, 0);

    if (_c.flash_pantalla_alpha <= 0) return;

    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();

    draw_set_alpha(_c.flash_pantalla_alpha);
    draw_set_color(_c.flash_pantalla_color);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}
