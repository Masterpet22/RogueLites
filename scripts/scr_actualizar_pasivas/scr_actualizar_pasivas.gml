/// scr_actualizar_pasivas(personaje)
function scr_actualizar_pasivas(_p) {

    // Timer activo
    if (_p.pasiva_timer > 0) {
        _p.pasiva_timer--;

        if (_p.pasiva_timer <= 0) {
            _p.pasiva_activa = false;
        }
    }

    // Cooldown interno
    if (_p.pasiva_cooldown > 0) {
        _p.pasiva_cooldown--;
    }
}
