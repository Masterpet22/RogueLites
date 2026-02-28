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

        // Aquí vas añadiendo más estados en el futuro

    }

    show_error("Estado no definido: " + string(_id), false);
    return undefined;
}
