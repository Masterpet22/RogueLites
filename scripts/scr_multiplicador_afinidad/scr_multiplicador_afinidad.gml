/// scr_multiplicador_afinidad(afinidad_atacante, afinidad_defensor)
function scr_multiplicador_afinidad(_atk, _def) {

    // Normalizado
    _atk = string(_atk);
    _def = string(_def);

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