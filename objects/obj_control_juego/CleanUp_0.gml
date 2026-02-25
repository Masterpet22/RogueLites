/// CLEAN UP — obj_control_juego

// 1. Destruir materiales globales (si es un DS Map)
if (ds_exists(inventario_materiales, ds_type_map)) {
    ds_map_destroy(inventario_materiales);
}

// 2. Destruir el mapa de perfiles
if (ds_exists(perfiles_personaje, ds_type_map)) {
    
    // Si "armas_obtenidas" dentro del perfil TAMBIÉN es un DS Map, 
    // tenemos que entrar a destruirlo antes de borrar el mapa principal.
    
    var _key = ds_map_find_first(perfiles_personaje);
    var _size = ds_map_size(perfiles_personaje);

    for (var i = 0; i < _size; i++;) {
        var _perfil = perfiles_personaje[? _key];

        // Cambiamos el acceso de [? "key"] a .key porque el error dice que es un STRUCT
        if (variable_struct_exists(_perfil, "armas_obtenidas")) {
            var _armas = _perfil.armas_obtenidas;
            
            // SOLO si "armas_obtenidas" se creó con ds_map_create() se destruye:
            if (ds_exists(_armas, ds_type_map)) {
                ds_map_destroy(_armas);
            }
        }
        
        _key = ds_map_find_next(perfiles_personaje, _key);
    }

    // Finalmente destruir el mapa contenedor
    ds_map_destroy(perfiles_personaje);
}