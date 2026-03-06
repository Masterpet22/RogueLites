/// scr_activar_pasiva_afinidad(personaje, tipo_activador)
function scr_activar_pasiva_afinidad(_p, _event) {

    // Si la pasiva ya es permanente (sinergia arma-personaje), siempre está activa
    if (variable_struct_exists(_p, "sinergia_pasiva_permanente") && _p.sinergia_pasiva_permanente) {
        _p.pasiva_activa = true;
        return;
    }

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

        case "Agua":
            // Activador → recibir daño → reduce cooldowns 20% durante la ventana
            if (_event == "recibir_dano") {
                _p.pasiva_activa = true;
                _p.pasiva_timer = GAME_FPS * 4;
                _p.pasiva_cooldown = GAME_FPS * 4;
            }
        break;

        case "Planta":
            // Activador → cada vez que pasa tiempo (tick pasivo) → regeneración
            if (_event == "turno_pasado") {
                _p.pasiva_activa = true;
                _p.pasiva_timer = GAME_FPS * 3;
                _p.pasiva_cooldown = GAME_FPS * 3;
            }
        break;

        case "Sombra":
            // Activador → golpe crítico → +25% daño temporalmente
            if (_event == "golpe_critico") {
                _p.pasiva_activa = true;
                _p.pasiva_timer = GAME_FPS * 2;
                _p.pasiva_cooldown = GAME_FPS * 4;
            }
        break;

        case "Luz":
            // Activador → recibir daño → +15% curación/escudo temporalmente
            if (_event == "recibir_dano") {
                _p.pasiva_activa = true;
                _p.pasiva_timer = GAME_FPS * 3;
                _p.pasiva_cooldown = GAME_FPS * 3;
            }
        break;

        case "Arcano":
            // Activador → usar habilidad → +20% poder elemental temporalmente
            if (_event == "uso_habilidad") {
                _p.pasiva_activa = true;
                _p.pasiva_timer = GAME_FPS * 2;
                _p.pasiva_cooldown = GAME_FPS * 4;
            }
        break;
    }
}