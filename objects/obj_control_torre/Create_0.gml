/// CREATE — obj_control_torre
/// Controlador del Modo Torre. Persiste entre rooms durante una run de torre.

// Evitar duplicados (es persistente)
if (instance_number(obj_control_torre) > 1) {
    instance_destroy();
    exit;
}

// ── Estado de la Torre ──
// Estos se setean antes de entrar al modo torre desde la selección
torre_activa     = false;
torre_ala        = undefined;    // struct de ala (de scr_torre_get_alas)
torre_dificultad = undefined;    // struct de dificultad
torre_piso       = 0;            // piso actual (1-based, 0 = no empezado)
torre_pisos_total = 0;

// ── Estado de la run ──
torre_fase = "seleccion_ala";
// Fases: "seleccion_ala" → "seleccion_dificultad" → "seleccion_personaje"
//        → "pre_combate" → "combate" → "post_combate" → "tienda" → "pre_combate" …
//        → "victoria" / "derrota"

// ── Selección UI ──
sel_ala_indice   = 0;
sel_dif_indice   = 0;
sel_pj_indice    = 0;
sel_arma_indice  = 0;

// ── Datos de personaje seleccionado para la run ──
torre_perfil_nombre = "";
torre_arma          = "";
torre_pj_clase      = "";
torre_pj_afinidad   = "";
torre_pj_personalidad = "";

// ── Tracking de la run ──
torre_oro_ganado      = 0;    // oro total ganado en esta run
torre_materiales_run  = [];   // array de { material, cantidad } ganados
torre_racha_hp_alta   = 0;    // combates seguidos sin bajar del 50% HP
torre_bonus_racha     = false;

// ── Datos del piso actual ──
torre_piso_data = undefined;  // struct de scr_torre_generar_piso

// ── HP del jugador persistente entre pisos ──
torre_pj_vida_actual = 0;
torre_pj_vida_max    = 0;

// ── Tienda de piso ──
torre_tienda_items = [];
torre_tienda_indice = 0;
torre_tienda_mensaje = "";
torre_tienda_msg_timer = 0;

// ── Datos para el popup post-combate ──
torre_post_opcion = 0;  // 0 = Siguiente piso, 1 = Abandonar

// ── Equipar objetos pre-combate ──
torre_equip_objetos   = [];     // objetos seleccionados (max 3)
torre_equip_indice    = 0;
torre_equip_runa      = "";     // runa seleccionada
torre_equip_fase      = "objetos"; // "objetos" → "runa" → listo
torre_equip_runa_indice = 0;
torre_equip_obj_disponibles  = [];  // nombres de objetos disponibles en inventario
torre_equip_runas_disponibles = []; // nombres de runas disponibles en inventario
