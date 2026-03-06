/// CREATE — obj_control_juego

// Profundidad muy baja para que Draw GUI dibuje POR ENCIMA de todos los demás objetos
depth = -9999;

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

// ╔══════════════════════════════════════════════════════════════╗
// ║  MODO PRUEBA: Desbloquear TODAS las armas para cada perfil  ║
// ╚══════════════════════════════════════════════════════════════╝
var _todas_armas = scr_lista_armas_disponibles();
var _todos_perfiles = [p_kael, p_lys, p_torvan, p_maelis, p_saren, p_nerya, p_thalys, p_brenn];
for (var _p = 0; _p < array_length(_todos_perfiles); _p++) {
    for (var _a = 0; _a < array_length(_todas_armas); _a++) {
        if (!ds_map_exists(_todos_perfiles[_p].armas_obtenidas, _todas_armas[_a])) {
            ds_map_add(_todos_perfiles[_p].armas_obtenidas, _todas_armas[_a], true);
        }
    }
}

// Personaje por defecto (luego tendremos menú)
//personaje_seleccionado = "Kael";

// INVENTARIO GLOBAL DE MATERIALES (NO POR PERSONAJE)
inventario_materiales = ds_map_create();   // <- IMPORTANTE

// ══ MODO PRUEBA: 500 de cada material ══
// Comunes
ds_map_add(inventario_materiales, "Fragmento Igneo", 500);
ds_map_add(inventario_materiales, "Escama Glaciar", 500);
ds_map_add(inventario_materiales, "Savia Espinosa", 500);
ds_map_add(inventario_materiales, "Chispa Voltica", 500);
ds_map_add(inventario_materiales, "Arcilla Ancestral", 500);
ds_map_add(inventario_materiales, "Fragmento Sombrio", 500);
ds_map_add(inventario_materiales, "Polvo Sagrado", 500);
ds_map_add(inventario_materiales, "Runa Menor", 500);
// Raros
ds_map_add(inventario_materiales, "Brasa Carmesi", 500);
ds_map_add(inventario_materiales, "Perla Abisal", 500);
ds_map_add(inventario_materiales, "Raiz Primigenia", 500);
ds_map_add(inventario_materiales, "Colmillo de Rayo", 500);
ds_map_add(inventario_materiales, "Ladrillo de Jade", 500);
ds_map_add(inventario_materiales, "Materia Oscura", 500);
ds_map_add(inventario_materiales, "Reliquia de Oro", 500);
ds_map_add(inventario_materiales, "Runa Mayor", 500);
// Legendarios
ds_map_add(inventario_materiales, "Nucleo de Forja Antigua", 500);
ds_map_add(inventario_materiales, "Corazon de Fango", 500);
ds_map_add(inventario_materiales, "Fragmento Celestial", 500);
ds_map_add(inventario_materiales, "Cristal del Vacio", 500);
ds_map_add(inventario_materiales, "Esencia del Vacio", 500);
ds_map_add(inventario_materiales, "Eco del Primer Conductor", 500);

// INVENTARIO GLOBAL DE OBJETOS / CONSUMIBLES
inventario_objetos = ds_map_create();

// ══ MODO PRUEBA: 500 de cada objeto/consumible y rúnico ══
ds_map_add(inventario_objetos, "Pocion Basica", 500);
ds_map_add(inventario_objetos, "Pocion Media", 500);
ds_map_add(inventario_objetos, "Elixir de Esencia", 500);
ds_map_add(inventario_objetos, "Tonico de Ataque", 500);
ds_map_add(inventario_objetos, "Tonico de Defensa", 500);
ds_map_add(inventario_objetos, "Runa de Furia", 500);
ds_map_add(inventario_objetos, "Runa de Fortaleza", 500);
ds_map_add(inventario_objetos, "Runa de Celeridad", 500);
ds_map_add(inventario_objetos, "Runa del Ultimo Aliento", 500);
ds_map_add(inventario_objetos, "Runa Vampirica", 500);
ds_map_add(inventario_objetos, "Runa de Cristal", 500);

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
// Jefe Final + Secreto
ds_map_add(enemigos_desbloqueados, "El Devorador", true);
ds_map_add(enemigos_desbloqueados, "El Primer Conductor", true);

// ORO DEL JUGADOR
oro = 50000;

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

// ── SISTEMA DE TRANSICIONES DE ROOM (fade in/out) ──
scr_transicion_init();

// Ir directamente al menú sin transición (es la apertura del juego)
room_goto(rm_menu);