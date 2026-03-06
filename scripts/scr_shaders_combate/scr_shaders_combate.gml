/// @file scr_shaders_combate.gml
/// @description  Sistema de shaders visuales para combate.
///   Provee funciones para inicializar, aplicar y quitar cada shader.
///   Se integra con scr_feedback_combate y scr_fx_impacto.
///
///   Shaders disponibles:
///     shd_flash         — Flash blanco/color al recibir golpe
///     shd_glow          — Brillo elemental alrededor del sprite
///     shd_outline       — Borde sólido (selección, turno activo)
///     shd_desaturate    — Escala de grises (muerte, pausa)
///     shd_color_tint    — Tinte elemental multiplicativo
///     shd_chromatic     — Aberración cromática (súper)
///     shd_energy_aura   — Aura de energía pulsante (carga esencia)
///     shd_shockwave     — Onda de choque radial (impacto fuerte)


// ══════════════════════════════════════════════════════════════
//  scr_shaders_init()
//  Cachea las ubicaciones de los uniforms de todos los shaders.
//  Llamar en obj_control_combate Create_0 (después de scr_feedback_init).
// ══════════════════════════════════════════════════════════════
function scr_shaders_init() {

    // ── shd_flash ──
    global.u_flash_color = shader_get_uniform(shd_flash, "u_flash_color");
    global.u_flash_mix   = shader_get_uniform(shd_flash, "u_flash_mix");

    // ── shd_glow ──
    global.u_glow_color     = shader_get_uniform(shd_glow, "u_glow_color");
    global.u_glow_intensity = shader_get_uniform(shd_glow, "u_glow_intensity");
    global.u_glow_texel     = shader_get_uniform(shd_glow, "u_texel_size");

    // ── shd_outline ──
    global.u_outline_color = shader_get_uniform(shd_outline, "u_outline_color");
    global.u_outline_texel = shader_get_uniform(shd_outline, "u_texel_size");

    // ── shd_desaturate ──
    global.u_desat_amount = shader_get_uniform(shd_desaturate, "u_desat_amount");

    // ── shd_color_tint ──
    global.u_tint_color = shader_get_uniform(shd_color_tint, "u_tint_color");
    global.u_tint_mix   = shader_get_uniform(shd_color_tint, "u_tint_mix");

    // ── shd_chromatic ──
    global.u_chrom_offset = shader_get_uniform(shd_chromatic, "u_chrom_offset");
    global.u_chrom_angle  = shader_get_uniform(shd_chromatic, "u_chrom_angle");

    // ── shd_energy_aura ──
    global.u_aura_color     = shader_get_uniform(shd_energy_aura, "u_aura_color");
    global.u_aura_intensity = shader_get_uniform(shd_energy_aura, "u_aura_intensity");
    global.u_aura_radius    = shader_get_uniform(shd_energy_aura, "u_aura_radius");
    global.u_aura_texel     = shader_get_uniform(shd_energy_aura, "u_texel_size");

    // ── shd_shockwave ──
    global.u_wave_center   = shader_get_uniform(shd_shockwave, "u_wave_center");
    global.u_wave_radius   = shader_get_uniform(shd_shockwave, "u_wave_radius");
    global.u_wave_width    = shader_get_uniform(shd_shockwave, "u_wave_width");
    global.u_wave_strength = shader_get_uniform(shd_shockwave, "u_wave_strength");

    // ── Estado de shockwave activo ──
    global.shockwave_activo   = false;
    global.shockwave_timer    = 0;
    global.shockwave_duracion = 20;
    global.shockwave_cx       = 0.5;
    global.shockwave_cy       = 0.5;

    // ── Estado de aberración cromática ──
    global.chromatic_activo = false;
    global.chromatic_timer  = 0;
    global.chromatic_max    = 0.004;
}


// ══════════════════════════════════════════════════════════════
//  FUNCIONES DE APLICACIÓN DE SHADERS
//  Patrón: scr_shader_NOMBRE_set(args) → shader_set + uniforms
//          shader_reset() para terminar
// ══════════════════════════════════════════════════════════════


/// @function scr_shader_flash_set(r, g, b, mix)
/// @description Aplica flash de color. Llamar antes de draw_sprite_ext.
///              Llamar shader_reset() después.
function scr_shader_flash_set(_r, _g, _b, _mix) {
    shader_set(shd_flash);
    shader_set_uniform_f(global.u_flash_color, _r, _g, _b, 1.0);
    shader_set_uniform_f(global.u_flash_mix, _mix);
}


/// @function scr_shader_glow_set(r, g, b, intensity, spr)
/// @description Aplica glow elemental. spr es el sprite para calcular texel_size.
function scr_shader_glow_set(_r, _g, _b, _intensity, _spr) {
    shader_set(shd_glow);
    shader_set_uniform_f(global.u_glow_color, _r, _g, _b, 1.0);
    shader_set_uniform_f(global.u_glow_intensity, _intensity);
    var _tw = 1.0 / sprite_get_width(_spr);
    var _th = 1.0 / sprite_get_height(_spr);
    shader_set_uniform_f(global.u_glow_texel, _tw, _th);
}


/// @function scr_shader_outline_set(r, g, b, a, spr)
/// @description Aplica borde sólido al sprite. spr para texel_size.
function scr_shader_outline_set(_r, _g, _b, _a, _spr) {
    shader_set(shd_outline);
    shader_set_uniform_f(global.u_outline_color, _r, _g, _b, _a);
    var _tw = 1.0 / sprite_get_width(_spr);
    var _th = 1.0 / sprite_get_height(_spr);
    shader_set_uniform_f(global.u_outline_texel, _tw, _th);
}


/// @function scr_shader_desaturate_set(amount)
/// @description Desaturación parcial o total. 0=color, 1=gris.
function scr_shader_desaturate_set(_amount) {
    shader_set(shd_desaturate);
    shader_set_uniform_f(global.u_desat_amount, _amount);
}


/// @function scr_shader_tint_set(r, g, b, mix)
/// @description Aplica tinte multiplicativo de color.
function scr_shader_tint_set(_r, _g, _b, _mix) {
    shader_set(shd_color_tint);
    shader_set_uniform_f(global.u_tint_color, _r, _g, _b, 1.0);
    shader_set_uniform_f(global.u_tint_mix, _mix);
}


/// @function scr_shader_chromatic_set(offset, angle)
/// @description Aplica aberración cromática. offset ~0.003..0.008.
function scr_shader_chromatic_set(_offset, _angle) {
    shader_set(shd_chromatic);
    shader_set_uniform_f(global.u_chrom_offset, _offset);
    shader_set_uniform_f(global.u_chrom_angle, _angle);
}


/// @function scr_shader_energy_aura_set(r, g, b, intensity, radius, spr)
/// @description Aplica aura de energía pulsante alrededor del sprite.
function scr_shader_energy_aura_set(_r, _g, _b, _intensity, _radius, _spr) {
    shader_set(shd_energy_aura);
    shader_set_uniform_f(global.u_aura_color, _r, _g, _b, 1.0);
    shader_set_uniform_f(global.u_aura_intensity, _intensity);
    shader_set_uniform_f(global.u_aura_radius, _radius);
    var _tw = 1.0 / sprite_get_width(_spr);
    var _th = 1.0 / sprite_get_height(_spr);
    shader_set_uniform_f(global.u_aura_texel, _tw, _th);
}


/// @function scr_shader_shockwave_set(cx, cy, radius, width, strength)
/// @description Aplica onda de choque a una surface o fondo.
///              cx,cy en UV (0..1). Llamar shader_reset() después.
function scr_shader_shockwave_set(_cx, _cy, _radius, _width, _strength) {
    shader_set(shd_shockwave);
    shader_set_uniform_f(global.u_wave_center, _cx, _cy);
    shader_set_uniform_f(global.u_wave_radius, _radius);
    shader_set_uniform_f(global.u_wave_width, _width);
    shader_set_uniform_f(global.u_wave_strength, _strength);
}


// ══════════════════════════════════════════════════════════════
//  FUNCIONES DE EFECTO AUTOMÁTICO
//  Se integran con el sistema de feedback existente.
// ══════════════════════════════════════════════════════════════


/// @function scr_shader_shockwave_disparar(x_gui, y_gui)
/// @description Inicia una onda de choque centrada en las coords GUI dadas.
function scr_shader_shockwave_disparar(_gx, _gy) {
    global.shockwave_activo   = true;
    global.shockwave_timer    = global.shockwave_duracion;
    global.shockwave_cx       = _gx / display_get_gui_width();
    global.shockwave_cy       = _gy / display_get_gui_height();
}


/// @function scr_shader_chromatic_disparar(duracion)
/// @description Inicia aberración cromática temporal (para súpers).
function scr_shader_chromatic_disparar(_duracion) {
    global.chromatic_activo = true;
    global.chromatic_timer  = _duracion;
}


/// @function scr_shaders_actualizar()
/// @description Actualizar timers de efectos shader. Llamar en Step.
function scr_shaders_actualizar() {
    // Shockwave
    if (global.shockwave_activo) {
        global.shockwave_timer--;
        if (global.shockwave_timer <= 0) {
            global.shockwave_activo = false;
        }
    }

    // Aberración cromática
    if (global.chromatic_activo) {
        global.chromatic_timer--;
        if (global.chromatic_timer <= 0) {
            global.chromatic_activo = false;
        }
    }
}


/// @function scr_shaders_dibujar_fondo_fx()
/// @description Aplicar shockwave al fondo si está activa.
///              Llamar ANTES de dibujar el fondo de combate.
///              Devuelve true si se activó un shader (hay que hacer shader_reset después).
function scr_shaders_dibujar_fondo_fx() {
    if (global.shockwave_activo && global.shockwave_timer > 0) {
        var _t = global.shockwave_timer / global.shockwave_duracion;
        var _radius = (1.0 - _t) * 0.6;       // expande de 0 a 0.6
        var _width  = 0.08;
        var _str    = _t * 0.012;              // se debilita al expandirse
        scr_shader_shockwave_set(
            global.shockwave_cx, global.shockwave_cy,
            _radius, _width, _str
        );
        return true;
    }
    return false;
}


/// @function scr_shader_aplicar_flash_golpe(idx, spr)
/// @description Aplica shd_flash al sprite de body si fb_flash_timer > 0.
///              idx: 0=jugador, 1=enemigo.  Devuelve true → hay shader activo.
function scr_shader_aplicar_flash_golpe(_idx, _spr) {
    if (!instance_exists(obj_control_combate)) return false;
    var _c = instance_find(obj_control_combate, 0);

    if (_c.fb_flash_timer[_idx] > 0) {
        var _ratio = _c.fb_flash_timer[_idx] / FB_FLASH_FRAMES;
        var _col = _c.fb_flash_color[_idx];
        var _r = color_get_red(_col) / 255;
        var _g = color_get_green(_col) / 255;
        var _b = color_get_blue(_col) / 255;
        scr_shader_flash_set(_r, _g, _b, _ratio * 0.85);
        return true;
    }
    return false;
}


/// @function scr_shader_aplicar_chromatic_pantalla()
/// @description Si hay chromatic activo, aplica aberración a lo que se dibuje.
///              Devuelve true → hay shader activo.
function scr_shader_aplicar_chromatic_pantalla() {
    if (global.chromatic_activo && global.chromatic_timer > 0) {
        var _t = global.chromatic_timer / 30; // normalizar
        var _off = global.chromatic_max * clamp(_t, 0, 1);
        var _ang = current_time * 0.003;
        scr_shader_chromatic_set(_off, _ang);
        return true;
    }
    return false;
}


/// @function scr_color_afinidad_rgb(afinidad)
/// @description Devuelve array [r,g,b] normalizado (0..1) para el color de una afinidad.
function scr_color_afinidad_rgb(_afinidad) {
    switch (_afinidad) {
        case "Fuego":    return [1.0, 0.3, 0.1];
        case "Agua":     return [0.2, 0.6, 1.0];
        case "Tierra":   return [0.7, 0.5, 0.2];
        case "Viento":   return [0.5, 0.9, 0.6];
        case "Luz":      return [1.0, 0.95, 0.6];
        case "Oscuridad": return [0.5, 0.2, 0.7];
        default:         return [0.8, 0.8, 0.8]; // Neutra
    }
}
