/// CREATE — obj_ui_forja

control_juego = instance_find(obj_control_juego, 0);

if (!instance_exists(control_juego)) {
    show_error("No existe obj_control_juego en rm_forja.", true);
}

// Estado de navegación
enum ForjaState {
    PERSONAJE,
    ARMAS
}

estado = ForjaState.PERSONAJE;

// Lista de personajes disponibles
personajes = scr_ds_map_keys_array(control_juego.perfiles_personaje);
indice_personaje = 0;
personaje_objetivo = "";

// Cuando elijas un personaje, llenamos esta lista:
armas_forjables = [];
indice_arma = 0;

// Mensajes UI
mensaje = "";
mensaje_timer = 0;
