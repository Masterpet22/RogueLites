/// CREATE - obj_menu

opcion = 0; // 0 = Camino del Héroe, 1 = Combatir, 2 = Torre, 3 = Forja, 4 = Tienda
opciones = ["Camino del Héroe", "Combatir", "Torre", "Forja", "Tienda"];

// Guía de controles — cerrada por defecto, se abre con icono o H
mostrar_guia = false;
guia_anim = 0;            // progreso de animación 0→1 (apertura vertical)
guia_anim_vel = 0.06;     // velocidad de animación

// Posición del icono "?" (esquina inferior derecha)
guia_ico_size = 36;
guia_ico_margin = 14;

// ── FX del menú: partículas de fondo flotantes ──
menu_particulas = [];
menu_fx_timer = 0;