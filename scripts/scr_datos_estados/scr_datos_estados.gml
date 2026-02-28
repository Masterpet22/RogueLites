/// scr_datos_estados(id_estado)
/// Devuelve la configuración base de un estado alterado.
function scr_datos_estados(_id) {

    switch (_id) {

        case "quemadura_fuego":
            return {
                id: _id,
                tipo: "dot", // daño en el tiempo
                tick_interval: round(GAME_FPS * 1.0), // cada 1s (antes 0.5s)
                potencia_base: 3, // daño base por tick
            };

        case "muro_tierra":
            return {
                id: _id,
                tipo: "buff_defensa",
                defensa_bonus: 4,          // +4 defensa mientras dure
            };

        case "aceleracion_rayo":
            return {
                id: _id,
                tipo: "buff_velocidad",
                velocidad_bonus: 3,        // +3 velocidad mientras dure
            };

        case "veneno":
            return {
                id: _id,
                tipo: "dot",
                tick_interval: round(GAME_FPS * 1.0), // cada 1s
                potencia_base: 2,                     // daño base por tick (más suave que quemadura)
            };

        case "regeneracion":
            return {
                id: _id,
                tipo: "hot",                          // curación en el tiempo
                tick_interval: round(GAME_FPS * 1.0), // cada 1s
                potencia_base: 3,                     // curación base por tick
            };

        case "ralentizacion":
            return {
                id: _id,
                tipo: "debuff_velocidad",
                velocidad_penalty: 3,                 // -3 velocidad mientras dure
            };

        case "vulnerabilidad":
            return {
                id: _id,
                tipo: "debuff_defensa",
                defensa_penalty: 4,                   // -4 defensa mientras dure
            };

        case "supresion_arcana":
            return {
                id: _id,
                tipo: "debuff_poder",
                poder_penalty: 3,                     // -3 poder_elemental mientras dure
            };

        // Aquí vas añadiendo más estados en el futuro

    }

    show_error("Estado no definido: " + string(_id), false);
    return undefined;
}
