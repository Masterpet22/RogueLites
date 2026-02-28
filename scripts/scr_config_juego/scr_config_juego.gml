/// scr_config_juego
/// Macros globales del proyecto.
/// Usar GAME_FPS en lugar de room_speed en todo el proyecto.

#macro GAME_FPS 60

// ── Esencia dinámica ──
#macro ESENCIA_PCT_DANO       0.05   // 5% del daño final se suma como esencia
#macro ESENCIA_MULT_VEL       0.3    // velocidad × 0.3 se suma por acción
#macro ESENCIA_MULT_PODER_MAG 0.2    // poder × 0.2 extra en habilidades mágicas
#macro ESENCIA_CRIT_BONUS     1.5    // ×1.5 esencia en crítico positivo

// ── Crítico dinámico por ataque ──
#macro CRIT_BASE_CHANCE  3       // probabilidad base de crítico (%)
#macro CRIT_ATK_DIVISOR  3       // cada X puntos de ataque → +1% crit

// ── Velocidad → Cooldown Reduction ──
#macro CDR_POR_VEL  0.02   // 2% CDR por punto de velocidad

// ── IA Enemigo — Máquina de estados ──
#macro IA_ACCION_BASE_FRAMES  180   // base de espera entre acciones (3 s a 60 fps)
#macro IA_VEL_FACTOR          0.12  // cada punto de velocidad reduce la espera
#macro IA_PREP_FRAMES         30    // wind-up antes de atacar (0.5 s)
#macro IA_VARIACION           0.15  // ±15 % aleatorio sobre el timer de espera

// ── Notificaciones de combate ──
#macro NOTIF_DURACION  120    // duración de cada notificación (2 s a 60 fps)
#macro NOTIF_MAX       2      // máximo de notificaciones visibles a la vez

// ── Estados alterados ──
#macro ESTADO_DUR_MAX_SEG  5   // duración máxima de cualquier estado (segundos)
