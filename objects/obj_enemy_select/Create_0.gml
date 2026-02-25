/// CREATE — obj_enemy_select

control_juego = instance_find(obj_control_juego, 0);

if (!instance_exists(control_juego)) {
    show_error("No existe obj_control_juego en rm_enemy_select", true);
}

// Enemigos por categoría
enemigos_comunes = [
    "Soldado Igneo",
    "Vigia Boreal",
    "Halito Verde",
    "Bestia Tronadora",
    "Guardian Terracota",
    "Naufrago de la Oscuridad",
    "Paladin Marchito",
    "Errante Runico"
];

enemigos_elite = [
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
enemigos_jefe = [
    "Titan de las Forjas Rotas",  // Fuego + Tierra
	"Coloso del Fango Viviente", // Agua + Planta
	"Sentinela del Cielo Roto",	 // Rayo + Luz
	"Oraculo Quebrado del Abismo" // Sombra + Arcano
];

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