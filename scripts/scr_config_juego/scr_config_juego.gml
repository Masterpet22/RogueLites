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

// ── Estados alterados ──
#macro ESTADO_DUR_MAX_SEG  5   // duración máxima de cualquier estado (segundos)
