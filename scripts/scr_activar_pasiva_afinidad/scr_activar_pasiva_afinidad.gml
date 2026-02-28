/// scr_activar_pasiva_afinidad(personaje, tipo_activador)
function scr_activar_pasiva_afinidad(_p, _event) {

    if (_p.pasiva_cooldown > 0) return;

    switch (_p.afinidad) {

        case "Fuego":
            // Activador → usar una habilidad
            if (_event == "uso_habilidad") {

                _p.pasiva_activa = true;
                _p.pasiva_timer = GAME_FPS * 1; // dura 1 s
                _p.pasiva_cooldown = GAME_FPS * 3; // 3 s de cd
            }
        break;

        case "Rayo":
            // Activador → golpe rápido consecutivo
            if (_event == "hit_rapido") {

                _p.pasiva_activa = true;
                _p.pasiva_timer = GAME_FPS * 1;
                _p.pasiva_cooldown = GAME_FPS * 4;
            }
        break;

        case "Tierra":
            if (_event == "recibir_dano") {

                _p.pasiva_activa = true;
                _p.pasiva_timer = GAME_FPS * 2;
                _p.pasiva_cooldown = GAME_FPS * 5;
            }
        break;
    }
}