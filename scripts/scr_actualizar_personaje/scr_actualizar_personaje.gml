/// scr_actualizar_personaje(personaje)
function scr_actualizar_personaje(_p) {

    // Cooldown viejo (si lo sigues usando)
    if (is_undefined(_p.cooldowns) == false) {
        if (_p.cooldowns.ataque_basico > 0) {
            _p.cooldowns.ataque_basico -= 1;
            if (_p.cooldowns.ataque_basico < 0) {
                _p.cooldowns.ataque_basico = 0;
            }
        }
    }

    // Nuevo: cooldowns por habilidad de arma
    //   CDR dinámica: cada punto de velocidad reduce CD un CDR_POR_VEL extra
    //   cd_tick = 1 + (velocidad * CDR_POR_VEL)   →  vel 5 = 1.10, vel 10 = 1.20
    if (is_array(_p.habilidades_cd)) {
        var _cd_tick = 1 + (_p.velocidad * CDR_POR_VEL);
        var n = array_length(_p.habilidades_cd);
        for (var i = 0; i < n; i++) {
            if (_p.habilidades_cd[i] > 0) {
                _p.habilidades_cd[i] -= _cd_tick;
                if (_p.habilidades_cd[i] < 0) _p.habilidades_cd[i] = 0;
            }
        }
    }

    // ── GCD (Global Cooldown) ──
    if (_p.gcd_timer > 0) {
        _p.gcd_timer -= 1;
        if (_p.gcd_timer < 0) _p.gcd_timer = 0;
    }

    // ── Energía: regeneración pasiva + agotamiento ──
    scr_energia_actualizar(_p);

    // ── Parry: actualizar timers ──
    scr_parry_actualizar(_p);
}