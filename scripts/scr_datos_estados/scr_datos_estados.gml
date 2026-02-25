/// scr_datos_estados(id_estado)
/// Devuelve la configuración base de un estado alterado.
function scr_datos_estados(_id) {

    switch (_id) {

        case "quemadura_fuego":
            return {
                id: _id,
                tipo: "dot", // daño en el tiempo
                tick_interval: round(room_speed * 0.5), // cada 0.5s
                potencia_base: 3, // daño base por tick
            };

        case "muro_tierra":
            return {
                id: _id,
                tipo: "buff_defensa",
                defensa_bonus: 4,          // +4 defensa mientras dure
            };

        // Aquí vas añadiendo más estados en el futuro

    }

    show_error("Estado no definido: " + string(_id), false);
    return undefined;
}
