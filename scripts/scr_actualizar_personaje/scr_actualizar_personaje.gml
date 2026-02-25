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
    if (is_array(_p.habilidades_cd)) {
        var n = array_length(_p.habilidades_cd);
        for (var i = 0; i < n; i++) {
            if (_p.habilidades_cd[i] > 0) {
                _p.habilidades_cd[i] -= 1;
                if (_p.habilidades_cd[i] < 0) _p.habilidades_cd[i] = 0;
            }
        }
    }

    // Aquí podríamos tocar otras cosas del personaje (estados, DOT, etc.)
}