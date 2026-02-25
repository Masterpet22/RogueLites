/// CREATE — obj_control_juego

// Mapa de perfiles de personaje
perfiles_personaje = ds_map_create();

// Crear perfil inicial de Kael
var p_kael = scr_crear_perfil_personaje("Kael", "Vanguardia", "Fuego");

// Agregar arma inicial a Kael
ds_map_add(p_kael.armas_obtenidas, "Hoja Rota", true);

// Guardar en el mapa de perfiles
ds_map_add(perfiles_personaje, "Kael", p_kael);
// Crear perfil de Lys
var p_lys = scr_crear_perfil_personaje("Lys", "Filotormenta", "Rayo");

// Arma inicial
ds_map_add(p_lys.armas_obtenidas, "Hoja Rota", true);

// Añadir al mapa de perfiles
ds_map_add(perfiles_personaje, "Lys", p_lys);

// Personaje por defecto (luego tendremos menú)
personaje_seleccionado = "Kael";

// INVENTARIO GLOBAL DE MATERIALES (NO POR PERSONAJE)
inventario_materiales = ds_map_create();   // <- IMPORTANTE
enemigo_seleccionado = ""; // Inicialización segura
room_goto(rm_menu);