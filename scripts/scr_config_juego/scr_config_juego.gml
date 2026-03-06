/// scr_config_juego
/// Macros globales del proyecto.
/// Usar GAME_FPS en lugar de room_speed en todo el proyecto.

#macro GAME_FPS 60

// ── Sistema de Energía ──
#macro ENERGIA_MAX              100    // capacidad máxima de la barra de energía
#macro ENERGIA_REGEN_PCT        0.05   // regeneración pasiva: 5% por segundo
#macro ENERGIA_AGOTAMIENTO_SEG  1.5    // penalización si llega a 0 (segundos sin regen)
#macro ENERGIA_ESENCIA_RATIO    10     // cada 10 energía gastada → +1% esencia

// ── Parry ──
#macro PARRY_VENTANA_SEG        0.3    // ventana activa para parry (segundos)
#macro PARRY_VULNERABLE_SEG     0.6    // penalización por fallo (segundos)
#macro PARRY_PERFECTO_ENERGIA   15     // % de energía recuperada en parry perfecto (ajustado de 30)
#macro PARRY_PERFECTO_ESENCIA   5      // % base de esencia por parry perfecto
#macro PARRY_PERFECTO_ESENCIA_MAX 10   // % máximo de esencia (ajustado por afinidad)
#macro PARRY_BLOQUEO_DANO_PCT   0.40   // bloqueo temprano: recibe 40% del daño
#macro PARRY_BLOQUEO_ENERGIA_COSTO 5   // bloqueo temprano: pierde 5 de energía

// ── GCD (Global Cooldown) ──
#macro GCD_DURACION_SEG         0.5    // duración del cooldown global (segundos)

// ── Daño Progresivo (Carga) ──
#macro CARGA_DRENAJE_ENERGIA    10     // energía por segundo mientras carga
#macro CARGA_NIVEL2_SEG         1.0    // segundos para alcanzar nivel 2
#macro CARGA_NIVEL3_SEG         2.0    // segundos para alcanzar nivel 3 (máximo)
#macro CARGA_MULT_N1            1.0    // multiplicador nivel 1 (toque rápido)
#macro CARGA_MULT_N2            1.5    // multiplicador nivel 2 (1s carga)
#macro CARGA_MULT_N3            2.5    // multiplicador nivel 3 (2s carga, máximo)
#macro CARGA_VULN_RECIBIDO      1.25   // +25% daño recibido mientras carga
#macro CARGA_MICRO_STUN_SEG     0.5    // micro-stun si recibe golpe cargando

// ── Stun (Aturdimiento) ──
#macro STUN_PARRY_SEG           1.2    // duración stun por parry perfecto
#macro STUN_POSTURA_SEG         3.0    // duración stun por ruptura de postura (3-4s)
#macro STUN_ESENCIA_MULT        2.0    // multiplicador de esencia al golpear stunned con carga máx

// ── Postura (Barra de Postura del Enemigo) ──
#macro POSTURA_BASE             100    // postura base por defecto
#macro POSTURA_REGEN_SEG        5      // postura se regenera tras X segundos sin recibir
#macro POSTURA_REGEN_RATE       0.10   // % de postura regenerada por segundo

// ── Esencia dinámica ──
#macro ESENCIA_PCT_DANO       0.05   // 5% del daño final se suma como esencia
#macro ESENCIA_MULT_VEL       0.3    // velocidad × 0.3 se suma por acción
#macro ESENCIA_MULT_PODER_MAG 0.2    // poder × 0.2 extra en habilidades mágicas
#macro ESENCIA_CRIT_BONUS     1.5    // ×1.5 esencia en crítico positivo

// ── Esencia por clase: bonus/pen según método de carga ──
#macro ESENCIA_CLASE_BONUS    1.80   // ×1.80 esencia en el evento preferido de la clase
#macro ESENCIA_CLASE_BASE     0.60   // ×0.60 esencia en eventos NO preferidos

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

// ══════════════════════════════════════════════════════════════
//  FLAGS GLOBALES — Efectos visuales (activables/desactivables)
// ══════════════════════════════════════════════════════════════
#macro FX_CAMERA_SHAKE_ON   true    // sacudida de cámara al impactar
#macro FX_HITSTOP_ON        true    // micro-pausa al conectar golpe
#macro FX_ZOOM_IMPACTO_ON   true    // zoom dinámico al impactar
#macro FX_PARTICULAS_ON     true    // partículas de golpe/curación
#macro FX_FLASH_DANO_ON     true    // flash rojo/blanco al recibir daño
#macro FX_FLASH_CURA_ON     true    // efecto visual de curación
#macro FX_TRANSICIONES_ON   true    // fade in/out entre rooms
#macro FX_DIALOGOS_PRE_ON   true    // diálogos pre-combate

// ── Intensidades de FX (escalables) ──
#macro FX_SHAKE_MULT        1.0     // multiplicador global de shake (0.5 = suave, 2.0 = fuerte)
#macro FX_ZOOM_INTENSIDAD   0.03    // cuánto zoom-in al impactar (3%)
#macro FX_ZOOM_VELOCIDAD    0.12    // velocidad de retorno del zoom (ease-out)
#macro FX_TRANSICION_VEL    0.04    // velocidad del fade (0→1 en ~25 frames)
