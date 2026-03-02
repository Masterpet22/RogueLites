/// CREATE — obj_control_camino
/// Controlador del Modo "Camino del Héroe". Persiste entre rooms durante una run.

// Evitar duplicados (es persistente)
if (instance_number(obj_control_camino) > 1) {
    instance_destroy();
    exit;
}

// ═══════════════════════════════════════════
//  ESTADO DEL CAMINO
// ═══════════════════════════════════════════

camino_activo = false;

// Fases del flujo:
// "seleccion_personaje" → "seleccion_arma" → "intro_capitulo" → "narrativa_linea"
// → "pre_combate" → "equipar" → "combate" → "post_combate" → "fragmento"
// → (loop por encuentro) → "victoria_capitulo" → "entre_capitulos"
// → (loop por capítulo) → "victoria_final" / "derrota"
// → "secreto_intro" → "secreto_combate" → "secreto_victoria"
camino_fase = "seleccion_personaje";

// ═══════════════════════════════════════════
//  DATOS DE CAPÍTULOS Y PROGRESO
// ═══════════════════════════════════════════

camino_capitulos     = [];       // array de structs (se llena al iniciar)
camino_capitulo_idx  = 0;        // índice del capítulo actual (0-based)
camino_capitulo      = undefined; // struct del capítulo actual

// ── MAPA RAMIFICADO ──
camino_mapa              = [];       // array de tiers, cada tier = array de nodos
camino_tier_actual       = -1;       // -1 = inicio, 0+ = tier actual
camino_nodo_actual       = 0;        // índice del nodo dentro del tier
camino_mapa_sel          = 0;        // cursor de selección del nodo siguiente
camino_mapa_conexiones   = [];       // conexiones disponibles del nodo actual
camino_encuentro         = undefined; // struct del encuentro (para combate)

// ═══════════════════════════════════════════
//  SELECCIÓN UI
// ═══════════════════════════════════════════

sel_pj_indice   = 0;
sel_arma_indice = 0;
camino_armas_disponibles = [];

// ═══════════════════════════════════════════
//  DATOS DEL PERSONAJE SELECCIONADO
// ═══════════════════════════════════════════

camino_perfil_nombre   = "";
camino_arma            = "";
camino_pj_clase        = "";
camino_pj_afinidad     = "";
camino_pj_personalidad = "";

// ═══════════════════════════════════════════
//  TRACKING DE LA RUN
// ═══════════════════════════════════════════

camino_oro_ganado       = 0;
camino_materiales_run   = [];    // { material, cantidad } ganados
camino_combates_ganados = 0;
camino_derrotas         = 0;
camino_combates_totales = 0;

// ═══════════════════════════════════════════
//  NARRATIVA
// ═══════════════════════════════════════════

camino_narrativa_lineas  = [];    // array de strings para la narrativa actual
camino_narrativa_idx     = 0;     // índice de la línea actual
camino_narrativa_destino = "";    // fase a la que ir cuando termine la narrativa

// ═══════════════════════════════════════════
//  POST-COMBATE
// ═══════════════════════════════════════════

camino_post_opcion = 0;           // 0 = Continuar, 1 = Abandonar
camino_ultimo_ganador = "";
camino_ultimo_oro = 0;

// ═══════════════════════════════════════════
//  EQUIPAR OBJETOS / RUNAS PRE-COMBATE
// ═══════════════════════════════════════════

camino_equip_objetos           = [];
camino_equip_indice            = 0;
camino_equip_runa              = "";
camino_equip_fase              = "objetos";  // "objetos" → "runa" → listo
camino_equip_runa_indice       = 0;
camino_equip_obj_disponibles   = [];
camino_equip_runas_disponibles = [];

// ═══════════════════════════════════════════
//  ENTRE CAPÍTULOS (forja / tienda)
// ═══════════════════════════════════════════

camino_entre_opcion = 0;  // 0 = Siguiente capítulo, 1 = Forja, 2 = Tienda, 3 = Abandonar

// ═══════════════════════════════════════════
//  JEFE SECRETO
// ═══════════════════════════════════════════

camino_secreto_disponible = false;
camino_secreto_completado = false;
