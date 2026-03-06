/// @function scr_sincronia_elemental(afinidad_personaje, afinidad_arma)
/// @description Devuelve datos de sincronía elemental si las afinidades son compatibles.
///   Pares compatibles: Fuego↔Tierra, Agua↔Planta, Rayo↔Luz, Sombra↔Arcano
///   Retorna undefined si no hay sincronía (mismo elemento, neutra, o no compatible).

function scr_sincronia_elemental(_afi_pj, _afi_arma) {

    // No hay sincronía si son iguales, o si alguna es Neutra
    if (_afi_pj == _afi_arma) return undefined;
    if (_afi_pj == "Neutra" || _afi_arma == "Neutra") return undefined;

    // Mapa de compatibilidad (bidireccional)
    var _par = "";

    // Fuego ↔ Tierra
    if ((_afi_pj == "Fuego" && _afi_arma == "Tierra") || (_afi_pj == "Tierra" && _afi_arma == "Fuego"))
        _par = "Fuego_Tierra";

    // Agua ↔ Planta
    else if ((_afi_pj == "Agua" && _afi_arma == "Planta") || (_afi_pj == "Planta" && _afi_arma == "Agua"))
        _par = "Agua_Planta";

    // Rayo ↔ Luz
    else if ((_afi_pj == "Rayo" && _afi_arma == "Luz") || (_afi_pj == "Luz" && _afi_arma == "Rayo"))
        _par = "Rayo_Luz";

    // Sombra ↔ Arcano
    else if ((_afi_pj == "Sombra" && _afi_arma == "Arcano") || (_afi_pj == "Arcano" && _afi_arma == "Sombra"))
        _par = "Sombra_Arcano";

    // No compatible
    if (_par == "") return undefined;

    // Calcular potencia de sincronía: S = ((bono1 + bono2) / 2) * mult_personalidad
    // (el multiplicador de personalidad se aplica en scr_crear_personaje_combate)
    var _afi1 = scr_datos_afinidades(_afi_pj);
    var _afi2 = scr_datos_afinidades(_afi_arma);
    var _potencia = (_afi1.bono + _afi2.bono) / 2;

    // Devolver datos de la habilidad de sincronía para este par
    switch (_par) {

        case "Fuego_Tierra":
            return {
                par: _par,
                nombre_habilidad: "sincronia_magma",
                nombre_display:   "Erupción de Magma",
                descripcion:      "Combina fuego y tierra en una erupción devastadora.",
                potencia: _potencia,
            };

        case "Agua_Planta":
            return {
                par: _par,
                nombre_habilidad: "sincronia_brote",
                nombre_display:   "Brote Torrencial",
                descripcion:      "Agua y planta crean un brote que daña y regenera.",
                potencia: _potencia,
            };

        case "Rayo_Luz":
            return {
                par: _par,
                nombre_habilidad: "sincronia_fulgor",
                nombre_display:   "Fulgor Relampagueante",
                descripcion:      "Rayo y luz se fusionan en un destello paralizante.",
                potencia: _potencia,
            };

        case "Sombra_Arcano":
            return {
                par: _par,
                nombre_habilidad: "sincronia_vacio",
                nombre_display:   "Vacío Arcano",
                descripcion:      "Sombra y arcano abren un vacío que debilita al enemigo.",
                potencia: _potencia,
            };
    }

    return undefined;
}
