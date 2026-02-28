/// @function scr_datos_tienda()
/// @description Retorna un struct con el catálogo de la tienda organizado por categorías.
///              Cada categoría tiene un array de items con nombre y tipo.

function scr_datos_tienda() {
    return {
        categorias: ["Personajes", "Enemigos", "Objetos"],

        // ── PERSONAJES ──
        // Los personajes desbloqueables (Kael es gratis y ya viene desbloqueado).
        // El precio se lee de scr_datos_clases().
        personajes: [
            { nombre: "Kael",   clase: "Vanguardia",   afinidad: "Fuego",  personalidad: "Resuelto" },
            { nombre: "Lys",    clase: "Filotormenta",  afinidad: "Rayo",   personalidad: "Agresivo" },
            { nombre: "Torvan", clase: "Quebrador",     afinidad: "Tierra", personalidad: "Metodico" },
            { nombre: "Maelis", clase: "Centinela",     afinidad: "Luz",    personalidad: "Metodico" },
            { nombre: "Saren",  clase: "Duelista",      afinidad: "Sombra", personalidad: "Resuelto" },
            { nombre: "Nerya",  clase: "Canalizador",   afinidad: "Arcano", personalidad: "Metodico" },
            { nombre: "Thalys", clase: "Centinela",     afinidad: "Agua",   personalidad: "Temerario" },
            { nombre: "Brenn",  clase: "Quebrador",     afinidad: "Planta", personalidad: "Agresivo" },
        ],

        // ── ENEMIGOS ──
        // Enemigos que se pueden desbloquear para combatir.
        // El precio se lee de scr_datos_enemigos().
        enemigos: [
            "Soldado Igneo",
            "Vigia Boreal",
            "Halito Verde",
            "Bestia Tronadora",
            "Guardian Terracota",
            "Naufrago de la Oscuridad",
            "Paladin Marchito",
            "Errante Runico",
            "Soldado Igneo Elite",
            "Vigia Boreal Elite",
            "Halito Verde Elite",
            "Bestia Tronadora Elite",
            "Guardian Terracota Elite",
            "Naufrago de la Oscuridad Elite",
            "Paladin Marchito Elite",
            "Errante Runico Elite",
            "Titan de las Forjas Rotas",
            "Coloso del Fango Viviente",
            "Sentinela del Cielo Roto",
            "Oraculo Quebrado del Abismo",
        ],

        // ── OBJETOS ──
        // Items consumibles. El precio se lee de scr_datos_objetos().
        objetos: [
            "Pocion Basica",
            "Pocion Media",
            "Elixir de Esencia",
            "Tonico de Ataque",
            "Tonico de Defensa",
        ],
    };
}
