/// scr_crear_perfil_personaje(nombre, clase, afinidad, personalidad)
function scr_crear_perfil_personaje(_nombre, _clase, _afinidad, _personalidad) {

    return {
        nombre: _nombre,
        clase: _clase,
        afinidad: _afinidad,
        personalidad: _personalidad,

        // Armas obtenidas por este personaje
        armas_obtenidas: ds_map_create(), // "Filo Igneo": true

        // Arma equipada del personaje
        arma_equipada: "Hoja Rota", // básica inicial
    };
}