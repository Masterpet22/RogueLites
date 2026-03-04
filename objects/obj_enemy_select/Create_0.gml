/// CREATE — obj_enemy_select

control_juego = instance_find(obj_control_juego, 0);

if (!instance_exists(control_juego)) {
    show_error("No existe obj_control_juego en rm_enemy_select", true);
}

// Enemigos por categoría — solo los desbloqueados
var _all_comunes = [
    "Soldado Igneo",
    "Vigia Boreal",
    "Halito Verde",
    "Bestia Tronadora",
    "Guardian Terracota",
    "Naufrago de la Oscuridad",
    "Paladin Marchito",
    "Errante Runico"
];

var _all_elite = [
    "Soldado Igneo Elite",
    "Vigia Boreal Elite",
    "Halito Verde Elite",
    "Bestia Tronadora Elite",
    "Guardian Terracota Elite",
    "Naufrago de la Oscuridad Elite",
    "Paladin Marchito Elite",
    "Errante Runico Elite"
];

// Jefe dual-elemental
var _all_jefe = [
    "Titan de las Forjas Rotas",  // Fuego + Tierra
	"Coloso del Fango Viviente", // Agua + Planta
	"Sentinela del Cielo Roto",	 // Rayo + Luz
	"Oraculo Quebrado del Abismo" // Sombra + Arcano
];

// Filtrar: solo mostrar los desbloqueados
enemigos_comunes = [];
for (var i = 0; i < array_length(_all_comunes); i++) {
    if (ds_map_exists(control_juego.enemigos_desbloqueados, _all_comunes[i])) {
        array_push(enemigos_comunes, _all_comunes[i]);
    }
}

enemigos_elite = [];
for (var i = 0; i < array_length(_all_elite); i++) {
    if (ds_map_exists(control_juego.enemigos_desbloqueados, _all_elite[i])) {
        array_push(enemigos_elite, _all_elite[i]);
    }
}

enemigos_jefe = [];
for (var i = 0; i < array_length(_all_jefe); i++) {
    if (ds_map_exists(control_juego.enemigos_desbloqueados, _all_jefe[i])) {
        array_push(enemigos_jefe, _all_jefe[i]);
    }
}

// Random será virtual — lo manejamos sin lista propia

enum EnemySelState {
    CATEGORIA,
    LISTA,
    CONFIRMAR
}

estado = EnemySelState.CATEGORIA;

// Índices
indice_categoria = 0;
indice_enemigo   = 0;

// Categorías visibles
categorias = [
    "Común",
    "Élite",
    "Jefe",
    "Random"
];

enemigos_actuales = []; // se llenará dinámicamente

// --- GUÍA DE AYUDA ---
mostrar_guia = false;
guia_anim = 0;
guia_anim_vel = 0.06;
guia_ico_size = 36;
guia_ico_margin = 14;

// Grid de retratos
sel_cols = 4;