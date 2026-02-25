/// scr_multiplicador_afinidad(afinidad_atacante, afinidad_defensor)
function scr_multiplicador_afinidad(_atk, _def) {

    // Normalizado
    _atk = string(_atk);
    _def = string(_def);

    return _multiplicador_simple(_atk, _def);
}

/// @description Multiplicador base entre dos afinidades simples
function _multiplicador_simple(_atk, _def) {

    switch (_atk) {

        case "Fuego":
            if (_def == "Planta") return 1.5;
            if (_def == "Agua")   return 0.75;
        break;

        case "Agua":
            if (_def == "Fuego")  return 1.4;
            if (_def == "Rayo")   return 0.8;
        break;

        case "Planta":
            if (_def == "Agua")   return 1.3;
            if (_def == "Fuego")  return 0.7;
        break;

        case "Rayo":
            if (_def == "Agua")   return 1.4;
            if (_def == "Tierra") return 0.75;
        break;

        case "Tierra":
            if (_def == "Rayo")   return 1.5;
        break;

        case "Sombra":
            if (_def == "Luz") return 1.4;
        break;

        case "Luz":
            if (_def == "Sombra") return 1.4;
        break;

        case "Arcano":
            return 1.1;
    }

    return 1.0; // neutro
}

/// @description Multiplicador que soporta afinidad dual (jefes)
/// Devuelve el mejor multiplicador entre ambas afinidades
function scr_multiplicador_afinidad_dual(_atacante, _defensor) {

    var _atk1 = _atacante.afinidad;
    var _def1 = _defensor.afinidad;

    // Obtener secundarias si existen
    var _atk2 = variable_struct_exists(_atacante, "afinidad_secundaria") ? _atacante.afinidad_secundaria : "none";
    var _def2 = variable_struct_exists(_defensor, "afinidad_secundaria") ? _defensor.afinidad_secundaria : "none";

    // Calcular todos los cruces posibles y quedarse con el mejor (atacante)
    var _best = _multiplicador_simple(_atk1, _def1);

    if (_atk2 != "none") {
        _best = max(_best, _multiplicador_simple(_atk2, _def1));
    }
    if (_def2 != "none") {
        _best = max(_best, _multiplicador_simple(_atk1, _def2));
    }
    if (_atk2 != "none" && _def2 != "none") {
        _best = max(_best, _multiplicador_simple(_atk2, _def2));
    }

    return _best;
}