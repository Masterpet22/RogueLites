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
    PERSONALIDAD_POPUP,
    ARMA_POPUP,
    OBJETOS_POPUP,
    RUNA_POPUP
}

// Estado inicial: solo personaje
estado = SelState.PERSONAJE;

// --- SISTEMA DE PERSONALIDAD ---
personalidades_lista = ["Agresivo", "Metodico", "Temerario", "Resuelto"];
indice_personalidad = 0;

// --- SISTEMA DE EQUIPAR OBJETOS ---
// Objetos seleccionados para llevar al combate (máx 3)
objetos_seleccionados = [];   // array de nombres de objeto
objetos_disponibles = [];     // objetos que el jugador posee (cantidad > 0)
indice_objeto = 0;            // cursor en la lista de objetos disponibles

// --- SISTEMA DE EQUIPAR RUNAS ---
runas_disponibles = [];       // runas que el jugador posee
runa_seleccionada = "";       // runa elegida para el combate (solo 1)
indice_runa = 0;              // cursor en la lista de runas

// --- GUÍA DE AYUDA (igual que menú principal) ---
mostrar_guia = false;
guia_anim = 0;
guia_anim_vel = 0.06;
guia_ico_size = 36;
guia_ico_margin = 14;

// Grid layout para retratos
sel_cols = 4; // columnas de retratos