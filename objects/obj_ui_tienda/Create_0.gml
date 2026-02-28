/// CREATE — obj_ui_tienda

control_juego = instance_find(obj_control_juego, 0);

if (!instance_exists(control_juego)) {
    show_error("No existe obj_control_juego en rm_tienda.", true);
}

// ── Estado de navegación ──
enum TiendaState {
    CATEGORIA,
    LISTA
}

estado = TiendaState.CATEGORIA;

// Datos del catálogo
catalogo = scr_datos_tienda();

// Categorías
categorias = catalogo.categorias; // ["Personajes", "Enemigos", "Objetos"]
indice_categoria = 0;

// Lista de items dentro de la categoría seleccionada
items_lista   = [];
indice_item   = 0;

// Mensajes UI
mensaje       = "";
mensaje_timer = 0;
mensaje_color = c_lime;
