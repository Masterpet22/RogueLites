/// CREATE — obj_control_juego

// Establecer velocidad del juego (usa la macro GAME_FPS = 60)
game_set_speed(GAME_FPS, gamespeed_fps);

// Resolución fija de GUI: 1280×720
display_set_gui_size(1280, 720);
window_set_size(1280, 720);
surface_resize(application_surface, 1280, 720);

// Semilla aleatoria — se llama UNA VEZ al inicio del juego
randomize();

// Mapa de perfiles de personaje
perfiles_personaje = ds_map_create();

// --- KAEL ---
var p_kael = scr_crear_perfil_personaje("Kael", "Vanguardia", "Fuego", "Resuelto");
ds_map_add(p_kael.armas_obtenidas, "Hoja Rota", true);
ds_map_add(perfiles_personaje, "Kael", p_kael);

// --- LYS ---
var p_lys = scr_crear_perfil_personaje("Lys", "Filotormenta", "Rayo", "Agresivo");
ds_map_add(p_lys.armas_obtenidas, "Hoja Rota", true);
ds_map_add(perfiles_personaje, "Lys", p_lys);

// --- TORVAN ---
var p_torvan = scr_crear_perfil_personaje("Torvan", "Quebrador", "Tierra", "Metodico");
ds_map_add(p_torvan.armas_obtenidas, "Hoja Rota", true);
ds_map_add(perfiles_personaje, "Torvan", p_torvan);

// --- MAELIS ---
var p_maelis = scr_crear_perfil_personaje("Maelis", "Centinela", "Luz", "Metodico");
ds_map_add(p_maelis.armas_obtenidas, "Hoja Rota", true);
ds_map_add(perfiles_personaje, "Maelis", p_maelis);

// --- SAREN ---
var p_saren = scr_crear_perfil_personaje("Saren", "Duelista", "Sombra", "Resuelto");
ds_map_add(p_saren.armas_obtenidas, "Hoja Rota", true);
ds_map_add(perfiles_personaje, "Saren", p_saren);

// --- NERYA ---
var p_nerya = scr_crear_perfil_personaje("Nerya", "Canalizador", "Arcano", "Metodico");
ds_map_add(p_nerya.armas_obtenidas, "Hoja Rota", true);
ds_map_add(perfiles_personaje, "Nerya", p_nerya);

// --- THALYS ---
var p_thalys = scr_crear_perfil_personaje("Thalys", "Centinela", "Agua", "Temerario");
ds_map_add(p_thalys.armas_obtenidas, "Hoja Rota", true);
ds_map_add(perfiles_personaje, "Thalys", p_thalys);

// --- BRENN ---
var p_brenn = scr_crear_perfil_personaje("Brenn", "Quebrador", "Planta", "Agresivo");
ds_map_add(p_brenn.armas_obtenidas, "Hoja Rota", true);
ds_map_add(perfiles_personaje, "Brenn", p_brenn);

// Personaje por defecto (luego tendremos menú)
//personaje_seleccionado = "Kael";

// INVENTARIO GLOBAL DE MATERIALES (NO POR PERSONAJE)
inventario_materiales = ds_map_create();   // <- IMPORTANTE

// INVENTARIO GLOBAL DE OBJETOS / CONSUMIBLES
inventario_objetos = ds_map_create();

// ENEMIGOS DESBLOQUEADOS PARA COMBATIR (TODOS — modo prueba)
enemigos_desbloqueados = ds_map_create();
// Comunes
ds_map_add(enemigos_desbloqueados, "Soldado Igneo", true);
ds_map_add(enemigos_desbloqueados, "Vigia Boreal", true);
ds_map_add(enemigos_desbloqueados, "Halito Verde", true);
ds_map_add(enemigos_desbloqueados, "Bestia Tronadora", true);
ds_map_add(enemigos_desbloqueados, "Guardian Terracota", true);
ds_map_add(enemigos_desbloqueados, "Naufrago de la Oscuridad", true);
ds_map_add(enemigos_desbloqueados, "Paladin Marchito", true);
ds_map_add(enemigos_desbloqueados, "Errante Runico", true);
// Elites
ds_map_add(enemigos_desbloqueados, "Soldado Igneo Elite", true);
ds_map_add(enemigos_desbloqueados, "Vigia Boreal Elite", true);
ds_map_add(enemigos_desbloqueados, "Halito Verde Elite", true);
ds_map_add(enemigos_desbloqueados, "Bestia Tronadora Elite", true);
ds_map_add(enemigos_desbloqueados, "Guardian Terracota Elite", true);
ds_map_add(enemigos_desbloqueados, "Naufrago de la Oscuridad Elite", true);
ds_map_add(enemigos_desbloqueados, "Paladin Marchito Elite", true);
ds_map_add(enemigos_desbloqueados, "Errante Runico Elite", true);
// Jefes
ds_map_add(enemigos_desbloqueados, "Titan de las Forjas Rotas", true);
ds_map_add(enemigos_desbloqueados, "Coloso del Fango Viviente", true);
ds_map_add(enemigos_desbloqueados, "Sentinela del Cielo Roto", true);
ds_map_add(enemigos_desbloqueados, "Oraculo Quebrado del Abismo", true);

// ORO DEL JUGADOR
oro = 100;

enemigo_seleccionado = ""; // Inicialización segura
runa_equipada = "";       // Runa rúnica equipada para el próximo combate

// ── MODO TORRE ──
modo_torre = false;
torre_hp_mult = 1;
torre_oro_mult = 1;

// ── MODO CAMINO DEL HÉROE ──
modo_camino = false;
camino_hp_mult = 1;
camino_oro_mult = 1;

// ── ARENA DE COMBATE ──
combate_arena_revancha = -1;   // -1 = nueva arena aleatoria, >= 0 = reusar ese índice
combate_arena_ultimo   = -1;   // último índice usado (para revancha)

room_goto(rm_menu);