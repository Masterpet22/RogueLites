/// CREATE — obj_select

control_juego = instance_find(obj_control_juego, 0);

if (!instance_exists(control_juego)) {
    show_error("No existe obj_control_juego en rm_select.", true);
}

// Lista de personajes desde el mapa de perfiles
personajes = scr_ds_map_keys_array(control_juego.perfiles_personaje);
indice_personaje = 0;

// Perfil actual
perfil = control_juego.perfiles_personaje[? personajes[indice_personaje]];

// Índice para arma (se usará en el popup)
indice_arma = 0;

// Estados de selección
enum SelState {
    PERSONAJE,
    ARMA_POPUP,
    OBJETOS_POPUP
}

// Estado inicial: solo personaje
estado = SelState.PERSONAJE;

// --- SISTEMA DE EQUIPAR OBJETOS ---
// Objetos seleccionados para llevar al combate (máx 3)
objetos_seleccionados = [];   // array de nombres de objeto
objetos_disponibles = [];     // objetos que el jugador posee (cantidad > 0)
indice_objeto = 0;            // cursor en la lista de objetos disponibles