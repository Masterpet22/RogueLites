# ARCADIUM — Documentación para Gameplay Programmer

> Versión consolidada · Febrero 2026

Documento orientado al programador de gameplay. Contiene todo lo necesario para implementar, modificar y expandir la mecánica de combate, habilidades, IA, estados alterados, Esencia y sistemas interactivos.

---

## 1. Visión General del Combate

### 1.1. Premisa

- Combate **1v1 en tiempo real**, sin movimiento.
- Escena fija: jugador (izquierda) vs enemigo (derecha).
- El jugador selecciona habilidades por teclas; cada una con cooldown independiente.
- La IA del enemigo opera con timers y patrones.
- La lógica vive en **structs**, no en los objetos visuales.

### 1.2. Objetos Relevantes

| Objeto                                    | Rol para el gameplay programmer                                                                  |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------ |
| `obj_control_combate`                     | **Tu objeto principal.** Aquí vive el Step del combate, la creación de structs y toda la lógica. |
| `obj_control_ui_combate`                  | HUD. Dibuja barras, habilidades, cooldowns. Lee datos de los structs del combate.                |
| `obj_actor_jugador` / `obj_actor_enemigo` | Solo visual. Lanza animaciones y VFX. **No tocar para lógica.**                                  |

### 1.3. Structs Clave

Toda la lógica opera sobre dos structs creados al inicio del combate:

```gml
// En obj_control_combate — Create
jugador = scr_crear_personaje_combate(perfil_activo);
enemigo = scr_crear_enemigo_combate(enemigo_seleccionado);
```

Ambos contienen: vida, stats, habilidades, cooldowns, estados, pasivas, esencia, combos.

---

## 2. Pipeline del Frame de Combate

┌─ INPUT ─────────────────────────────────────────────┐
│ Detectar tecla → scr_usar_habilidad_indice │
└──────────────────────────────────────────────────────┘
│
▼
┌─ EJECUCIÓN ─────────────────────────────────────────┐
│ scr_ejecutar_habilidad(atacante, defensor, id_hab) │
│ ├─ scr_calcular_dano(atacante, defensor) │
│ ├─ scr_multiplicador_afinidad(af_atk, af_def) │
│ └─ scr_aplicar_estado(defensor, id_estado, ...) │
└──────────────────────────────────────────────────────┘
│
▼
┌─ PASIVAS ───────────────────────────────────────────┐
│ scr_activar_pasiva_afinidad(personaje, evento) │
└──────────────────────────────────────────────────────┘
│
▼
┌─ UPDATE ────────────────────────────────────────────┐
│ scr_actualizar_personaje(personaje) │
│ ├─ Decrementar cooldowns de habilidades │
│ ├─ scr_actualizar_pasivas(personaje) │
│ ├─ scr_actualizar_estados(personaje) │
│ └─ scr_actualizar_esencia(personaje) │
└──────────────────────────────────────────────────────┘
│
▼
┌─ IA ENEMIGO ────────────────────────────────────────┐
│ Decrementar ia_timer │
│ Si ia_timer <= 0 → ejecutar habilidad → reset timer│
└──────────────────────────────────────────────────────┘
│
▼
┌─ CHECK FIN ─────────────────────────────────────────┐
│ vida_actual <= 0 → ganador → drops → fin │
└──────────────────────────────────────────────────────┘

---

## 3. Implementar Habilidades

### 3.1. Anatomía de una Habilidad

Toda habilidad tiene 4 componentes registrados en scripts separados:

| Componente | Script                   | Qué define                          |
| ---------- | ------------------------ | ----------------------------------- |
| Lógica     | `scr_ejecutar_habilidad` | Daño, efectos, estados, condiciones |
| Cooldown   | `scr_cooldown_habilidad` | Duración en frames antes de reusar  |
| Nombre     | `scr_nombre_habilidad`   | Texto para mostrar en la UI         |
| Asignación | `scr_datos_armas`        | Qué arma(s) la incluyen             |

### 3.2. Habilidad Simple (Solo Daño)

```gml
// En scr_ejecutar_habilidad
case "corte_arcano":
{
    var d = scr_calcular_dano(_atacante, _defensor);
    _defensor.vida_actual -= d;
    scr_activar_pasiva_afinidad(_atacante, "uso_habilidad");
    scr_actualizar_esencia(_atacante, "uso_habilidad", d);
}
break;
```

### 3.3. Habilidad con Estado Alterado

```gml
case "explosion_carmesi":
{
    var d = scr_calcular_dano(_atacante, _defensor);
    _defensor.vida_actual -= d;
    scr_aplicar_estado(_defensor, "quemadura", room_speed * 3, _atacante.poder_elemental);
    scr_activar_pasiva_afinidad(_atacante, "uso_habilidad");
}
break;
```

### 3.4. Habilidad con Buff al Atacante

```gml
case "muro_de_piedra":
{
    scr_aplicar_estado(_atacante, "buff_defensa_fuerte", room_speed * 4, 0);
    scr_activar_pasiva_afinidad(_atacante, "uso_habilidad");
}
break;
```

### 3.5. Habilidad Condicional (Daño Extra en Vida Baja)

```gml
case "golpe_desesperado":
{
    var d = scr_calcular_dano(_atacante, _defensor);
    if (_atacante.vida_actual < _atacante.vida_max * 0.3) {
        d = round(d * 2.0);  // Doble daño si vida < 30%
    }
    _defensor.vida_actual -= d;
}
break;
```

### 3.6. Habilidad con Daño Elemental Extra

```gml
case "impacto_arcano":
{
    var d = scr_calcular_dano(_atacante, _defensor);
    var extra = round(_atacante.poder_elemental * 1.1);
    _defensor.vida_actual -= (d + extra);
    scr_aplicar_estado(_defensor, "debilidad_magica", room_speed * 3, 3);
}
break;
```

---

## 4. Cálculo de Daño — Detalle

### 4.1. Fórmula Base

```gml
function scr_calcular_dano(_atk, _def) {
    var fisico = max(1, _atk.ataque_base - _def.defensa_base - _def.defensa_bonus_temp);
    var mult = scr_multiplicador_afinidad(_atk.afinidad, _def.afinidad);
    var elemental = round(_atk.poder_elemental * mult);
    return fisico + elemental;
}
```

### 4.2. Factores que Modifican el Daño

| Factor                 | Fuente                                 | Efecto                                            |
| ---------------------- | -------------------------------------- | ------------------------------------------------- |
| `ataque_base`          | Clase + arma (`ataque_bonus`)          | Daño físico                                       |
| `defensa_base`         | Clase del defensor                     | Reduce daño físico                                |
| `defensa_bonus_temp`   | Estados alterados (buff)               | Reduce daño temporalmente                         |
| `poder_elemental`      | Clase + arma (`poder_elemental_bonus`) | Daño elemental                                    |
| Multiplicador afinidad | Tabla elemental                        | ×1.5 (ventaja), ×0.5 (desventaja), ×1.0 (neutral) |
| Pasiva activa          | Afinidad del atacante                  | Ej: Fuego +20% daño total                         |

### 4.3. Orden de Aplicación

1. Calcular daño físico: `ataque_base - defensa_base - defensa_bonus_temp` (mínimo 1).
2. Calcular daño elemental: `poder_elemental × multiplicador_afinidad`.
3. Sumar ambos.
4. Aplicar modificadores de pasiva (si está activa).
5. Resultado final se resta a `vida_actual` del defensor.

---

## 5. Sistema de Cooldowns

### 5.1. Funcionamiento

```gml
// Cada habilidad tiene un slot en el array habilidades_cd
// Se setea al usar la habilidad:
personaje.habilidades_cd[indice] = scr_cooldown_habilidad(id_hab);

// Se decrementa cada frame en scr_actualizar_personaje:
for (var i = 0; i < array_length(p.habilidades_cd); i++) {
    if (p.habilidades_cd[i] > 0) p.habilidades_cd[i]--;
}

// Se verifica antes de usar:
if (personaje.habilidades_cd[indice] <= 0) {
    // Puede usar la habilidad
}
```

### 5.2. Convenciones de Cooldown

| Tipo de habilidad   | Rango típico                  |
| ------------------- | ----------------------------- |
| Ataque básico       | 0.6s – 1.0s                   |
| Ataque elemental    | 1.0s – 1.5s                   |
| Habilidad fuerte    | 1.5s – 2.5s                   |
| Habilidad defensiva | 2.0s – 3.0s                   |
| Súper-Habilidad     | Controlada por ESENCIA, no CD |

> Recordar: `room_speed * 1.0` = 1 segundo.

---

## 6. Sistema de ESENCIA (Súper-Habilidades)

### 6.1. Carga

Cada clase carga ESENCIA de forma diferente. La carga se dispara desde `scr_ejecutar_habilidad` y/o `scr_actualizar_personaje`.

```gml
function scr_actualizar_esencia(_p, _evento, _valor) {
    switch (_p.clase) {
        case "Vanguardia":
            if (_evento == "recibir_dano") _p.esencia += _valor * 0.5;
            break;
        case "Filotormenta":
            if (_evento == "uso_habilidad") _p.esencia += 8;
            break;
        case "Quebrador":
            if (_evento == "golpe_fuerte") _p.esencia += _valor * 0.8;
            break;
        case "Centinela":
            if (_evento == "mitigar_dano") _p.esencia += _valor * 0.6;
            break;
        case "Duelista":
            if (_evento == "contraataque") _p.esencia += 15;
            break;
        case "Canalizador":
            if (_evento == "hab_elemental") _p.esencia += 10;
            break;
    }
    _p.esencia = clamp(_p.esencia, 0, 100);
}
```

### 6.2. Activación

```gml
// En input del jugador:
if (keyboard_check_pressed(ord("R")) && jugador.esencia >= 100) {
    scr_ejecutar_super(jugador, enemigo);
    // La esencia se consume dentro de scr_ejecutar_super
    // Los FX visuales (hitstop, screenshake, flash) se activan automáticamente
}
```

### 6.3. FX Visual de la Súper (Automático)

Al ejecutar una súper, `scr_ejecutar_super` llama a `scr_fx_activar_super(_afinidad, _atacante)` que activa:

- **Hitstop:** 12 frames (~0.2s) de congelamiento total del combate
- **Screenshake:** 20 frames de sacudida fuerte (12px)
- **Flash elemental:** Pantalla completa con el color de energía de la afinidad del atacante
- **Foco dinámico:** Centraliza la cámara en quien ejecuta la súper (`foco_quien` se determina por `_atacante.es_jugador`)
- **Blur de escenario:** Overlay oscuro (25% alpha) + tinte elemental (8% alpha) sobre el fondo; dura ~0.6s tras el hitstop, fade-out gradual

Estos efectos se gestionan automáticamente por `scr_fx_esencia_visual` y `scr_feedback_combate`.

> **Nota:** El foco ya no está fijo en el jugador. Si un enemigo (jefe) ejecuta súper, el foco se centra en él.

### 6.4. Implementar una Súper-Habilidad

Las súpers varían por **Clase × Personalidad** (24 combinaciones).

```gml
function scr_ejecutar_super(_atk, _def) {
    var key = _atk.clase + "_" + _atk.personalidad;

    switch (key) {
        case "Vanguardia_Resuelto":
            // Golpe masivo + cura parcial
            var d = round(_atk.ataque_base * 3);
            _def.vida_actual -= d;
            _atk.vida_actual = min(_atk.vida_max, _atk.vida_actual + round(d * 0.3));
            break;

        case "Filotormenta_Agresivo":
            // Ráfaga de 5 golpes rápidos
            for (var i = 0; i < 5; i++) {
                var d = scr_calcular_dano(_atk, _def);
                _def.vida_actual -= round(d * 0.6);
            }
            break;

        // ... 22 variantes más
    }
}
```

---

## 7. Sistema de Estados Alterados

### 7.1. Tipos Existentes

| ID                 | Tipo               | Efecto                         |
| ------------------ | ------------------ | ------------------------------ |
| `quemadura_fuego`  | `dot`              | Daño periódico (tick 1s)       |
| `veneno`           | `dot`              | Daño periódico suave (tick 1s) |
| `regeneracion`     | `hot`              | Curación periódica (tick 1s)   |
| `muro_tierra`      | `buff_defensa`     | +4 defensa temporal            |
| `aceleracion_rayo` | `buff_velocidad`   | +3 velocidad temporal          |
| `ralentizacion`    | `debuff_velocidad` | -3 velocidad temporal          |
| `vulnerabilidad`   | `debuff_defensa`   | -4 defensa temporal            |
| `supresion_arcana` | `debuff_poder`     | -3 poder_elemental temporal    |

### 7.2. Cómo Crear un Estado Nuevo

**_Ejemplo: Shock Eléctrico (DoT rápido)_**

1. Definir en `scr_datos_estados`:

```gml
case "shock_electrico":
    return {
        id: "shock_electrico",
        tipo: "dot",
        tick_interval: room_speed * 0.4,
        potencia_base: 2,
        defensa_bonus: 0
    };
```

1. Aplicar desde habilidad:

```gml
scr_aplicar_estado(_defensor, "shock_electrico", room_speed * 2, _atacante.poder_elemental);
```

**_Ejemplo: Debuff de Defensa_**

```gml
case "armadura_rota":
    return {
        id: "armadura_rota",
        tipo: "debuff_defensa",
        tick_interval: 0,
        potencia_base: 0,
        defensa_bonus: -5       // negativo = reduce defensa
    };
```

Si creas un tipo nuevo, añadir lógica en `scr_actualizar_estados`:

```gml
if (e.tipo == "debuff_defensa") {
    _personaje.defensa_bonus_temp = e.defensa_bonus;
}
```

### 7.3. Tipos Sugeridos para Implementar

| Tipo             | Efecto                  | Implementación                                  |
| ---------------- | ----------------------- | ----------------------------------------------- |
| `dot`            | Daño por tick           | Ya implementado                                 |
| `buff_defensa`   | +defensa                | Ya implementado                                 |
| `debuff_defensa` | -defensa                | Mismo sistema, valor negativo                   |
| `slow`           | +% cooldown habilidades | Multiplicar CDs al aplicar                      |
| `stun`           | Bloquea acciones        | Flag `stunned = true`, verificar antes de input |
| `vulnerability`  | +% daño recibido        | Multiplicador en `scr_calcular_dano`            |
| `regen`          | Curación por tick       | Inverso de `dot`                                |

---

## 8. Pasivas de Afinidad

### 8.1. Flujo

1. **Evento ocurre** (usar habilidad, recibir daño, combo, etc.).
2. Se llama `scr_activar_pasiva_afinidad(personaje, evento)`.
3. Si el evento coincide con el activador de la afinidad y no está en cooldown → activar.
4. Cada frame, `scr_actualizar_pasivas` maneja el timer y aplica el bono.
5. Al expirar, entra en cooldown.

### 8.2. Implementar una Pasiva Nueva

```gml
// En scr_activar_pasiva_afinidad
case "Agua":
    if (_evento == "recibir_dano" && !_p.pasiva_activa && _p.pasiva_cooldown <= 0) {
        _p.pasiva_activa = true;
        _p.pasiva_timer = room_speed * 4;
        // Efecto: reducir cooldowns un 20%
    }
    break;
```

```gml
// En scr_actualizar_pasivas — aplicar bono mientras activa
if (_p.afinidad == "Agua" && _p.pasiva_activa) {
    // Los cooldowns se reducen más rápido
    for (var i = 0; i < array_length(_p.habilidades_cd); i++) {
        if (_p.habilidades_cd[i] > 0) _p.habilidades_cd[i] -= 0.2;  // 20% más rápido
    }
}
```

### 8.3. Pasivas Implementadas

| Afinidad | Activador              | Bono         | Estado       |
| -------- | ---------------------- | ------------ | ------------ |
| Fuego    | Uso de habilidad       | +20% daño    | Implementado |
| Rayo     | Golpes rápidos (combo) | Pendiente    | Stub         |
| Tierra   | Recibir daño           | +20% defensa | Implementado |

---

## 9. IA del Enemigo

### 9.1. IA Multi-Habilidad (Todos los enemigos)

La IA usa `scr_usar_habilidad_indice` con prioridad descendente. Los cooldowns se gestionan por `scr_actualizar_personaje`.

```gml
// Prioriza habilidades de mayor índice: secundaria > fija > básica
if (personaje_enemigo.vida_actual > 0 && personaje_jugador.vida_actual > 0) {
    var _habs_e = personaje_enemigo.habilidades_arma;
    var _cds_e  = personaje_enemigo.habilidades_cd;
    var _n_e    = array_length(_habs_e);
    for (var i = _n_e - 1; i >= 0; i--) {
        if (_cds_e[i] <= 0) {
            scr_usar_habilidad_indice(personaje_enemigo, personaje_jugador, i);
            break;
        }
    }
}
```

Composición de habilidades:

- **Comunes:** `["ataque_basico", habilidad_fija, habilidad_secundaria]` — 3 habilidades
- **Élites:** `["ataque_basico", habilidad_fija, habilidad_secundaria, habilidad_3]` — 3–4 habilidades (secundaria aplica estados)
- **Jefes:** 4–5 habilidades con mecánicas temáticas

### 9.2. IA por Patrones (Jefes)

```gml
// Definir patrón en el struct del jefe:
patron: ["golpe", "buff", "golpe_fuerte", "habilidad_especial"],
p_index: 0

// En Step:
var accion = enemigo.patron[enemigo.p_index];
switch (accion) {
    case "golpe":
        scr_ejecutar_habilidad(enemigo, jugador, "golpe_basico_jefe");
        break;
    case "buff":
        scr_aplicar_estado(enemigo, "buff_defensa", room_speed * 3, 0);
        break;
    case "golpe_fuerte":
        scr_ejecutar_habilidad(enemigo, jugador, "golpe_devastador");
        break;
    case "habilidad_especial":
        // Mecánica temática del jefe
        break;
}
enemigo.p_index = (enemigo.p_index + 1) mod array_length(enemigo.patron);
```

### 9.3. IA Reactiva (El Devorador)

Para el jefe final, implementar respuestas al jugador:

```gml
// Copia patrones: usa la última habilidad que usó el jugador
if (jugador.ultima_habilidad_usada != "") {
    scr_ejecutar_habilidad(enemigo, jugador, jugador.ultima_habilidad_usada);
}

// Roba Esencia
jugador.esencia = max(0, jugador.esencia - 15);

// Desactiva pasiva
jugador.pasiva_activa = false;
jugador.pasiva_cooldown = room_speed * 8;
```

---

## 10. Mecánicas Avanzadas de Combate

### 10.1. Sistema de Combos (Implementado)

El sistema de combos está completamente implementado. Funciona para todas las clases y afinidades:

```gml
// En el struct del personaje:
combo: 0,
timer_combo: 0

// Al usar habilidad exitosamente (en scr_ejecutar_habilidad):
_atk.combo++;
_atk.timer_combo = room_speed * 1.0;  // ventana de 1 segundo

// En scr_actualizar_personaje:
if (_p.timer_combo > 0) {
    _p.timer_combo--;
} else {
    _p.combo = 0;
}

// Activar pasiva de Rayo por combo:
if (_p.combo >= 3) {
    scr_activar_pasiva_afinidad(_p, "hit_rapido");
}
```

**Reset de combo:** El combo se reinicia a 0 cuando:

- La ventana de tiempo expira (`timer_combo` = 0)
- El enemigo realiza un parry exitoso contra el jugador

**Feedback visual:** El contador de combo se muestra en la UI del combate (×2, ×3, etc.).

### 10.2. Habilidades con Carga (Hold/Charge)

```gml
// Añadir al struct:
cargando: false,
tiempo_carga: 0

// En Step (input):
if (keyboard_check(vk_space)) {
    jugador.cargando = true;
    jugador.tiempo_carga++;
}
if (keyboard_check_released(vk_space) && jugador.cargando) {
    var fuerza = min(jugador.tiempo_carga, 60);  // cap a 1 segundo
    var d = scr_calcular_dano(jugador, enemigo);
    d = round(d * (1 + fuerza / 60));  // hasta ×2 daño
    enemigo.vida_actual -= d;
    jugador.cargando = false;
    jugador.tiempo_carga = 0;
}
```

### 10.3. Parries y Contraataques (Implementado)

**Parry del Jugador (Duelista):**

```gml
// Estado de parry (ventana corta):
jugador.en_parry = true;
jugador.parry_timer = room_speed * 0.3;  // ventana de 0.3s

// Verificar en la habilidad del enemigo:
if (_defensor.en_parry) {
    // Contraataque: devolver daño amplificado
    _atacante.vida_actual -= round(dano_total * 1.5);
    scr_actualizar_esencia(_defensor, "contraataque", dano_total);
    return;  // No recibe daño
}
```

**Parry del Enemigo (Todos los enemigos):**

Los enemigos también pueden realizar parries con probabilidad basada en rareza:

| Rareza | `parry_chance` | Reducción de daño |
| ------ | -------------- | ----------------- |
| Común  | 6%             | 70%               |
| Élite  | 12%            | 70%               |
| Jefe   | 20%            | 70%               |

El parry enemigo se evalúa en `scr_ejecutar_habilidad` antes de aplicar daño. Si el parry tiene éxito:

- Daño se reduce al 30% del original
- El combo del jugador se resetea a 0
- Se aplica cooldown al parry (`parry_cd_timer`)

**Sistema Anti-Spam:**

Si el jugador repite la misma habilidad, el enemigo gana +2% de parry_chance por repetición consecutiva (`antispam_bloqueo_bonus`). Esto incentiva al jugador a variar sus habilidades.

### 10.4. Integrar Animaciones sin Romper Lógica

**Regla de oro:** Animaciones van en los actores (`obj_actor_*`), nunca en los structs.

```gml
// Después de ejecutar habilidad en la lógica:
with (obj_actor_jugador) {
    sprite_index = spr_golpe;
    image_index = 0;
}

// Después de recibir daño:
with (obj_actor_enemigo) {
    sprite_index = spr_impacto;
    image_index = 0;
}
```

### 10.5. Efectos Visuales (VFX)

```gml
// Crear partícula al usar habilidad de fuego:
var fx = instance_create_layer(
    obj_actor_enemigo.x,
    obj_actor_enemigo.y,
    "FX",
    obj_particle_fuego
);
fx.power = _atacante.poder_elemental;
fx.duracion = room_speed * 0.5;
```

---

## 11. Referencia Rápida de Scripts

### Combate Core

| Script                        | Input        | Output         | Descripción                              |
| ----------------------------- | ------------ | -------------- | ---------------------------------------- |
| `scr_crear_personaje_combate` | perfil       | struct combate | Crea struct completo para combate        |
| `scr_crear_enemigo_combate`   | nombre       | struct combate | Crea struct de enemigo                   |
| `scr_ejecutar_habilidad`      | atk, def, id | void           | **Punto central** de toda habilidad      |
| `scr_calcular_dano`           | atk, def     | real           | Devuelve daño total (físico + elemental) |
| `scr_multiplicador_afinidad`  | af1, af2     | real           | Multiplicador elemental                  |
| `scr_usar_habilidad_indice`   | personaje, i | void           | Wrapper para input → habilidad           |
| `scr_actualizar_personaje`    | personaje    | void           | Update frame: CDs, pasivas, estados      |

### Subsistemas

| Script                        | Descripción                                  |
| ----------------------------- | -------------------------------------------- |
| `scr_actualizar_esencia`      | Carga ESENCIA según clase y evento           |
| `scr_activar_pasiva_afinidad` | Dispara pasiva si coincide evento + afinidad |
| `scr_actualizar_pasivas`      | Timer y bono de pasiva activa                |
| `scr_aplicar_estado`          | Añade estado alterado a un personaje         |
| `scr_actualizar_estados`      | Tick de DoT, buffs, expiración               |
| `scr_cooldown_habilidad`      | Devuelve CD en frames para cada ID           |
| `scr_nombre_habilidad`        | Devuelve nombre visual para UI               |

### FX Visual y Feedback

| Script                  | Descripción                                             |
| ----------------------- | ------------------------------------------------------- |
| `scr_feedback_combate`  | Números flotantes, shake, flash, tracking de vida, blur |
| `scr_fx_esencia_visual` | Glow elemental, hitstop, flash pantalla, aura esencia   |
| `scr_paleta_afinidad`   | Colores dominante/secundario/energía por afinidad       |
| `scr_barks_combate`     | Barks flotantes + diálogo mid-combat (50% HP)           |

### Datos

| Script                 | Devuelve                                            |
| ---------------------- | --------------------------------------------------- |
| `scr_datos_clases`     | Struct de clase (stats, hab fija, carga esencia)    |
| `scr_datos_afinidades` | Struct de afinidad (activador, bono, CD)            |
| `scr_datos_armas`      | Struct de arma (rareza, bonus, habilidades, receta) |
| `scr_datos_enemigos`   | Struct de enemigo (stats, hab, drop)                |
| `scr_datos_estados`    | Struct de estado (tipo, tick, potencia)             |
| `scr_datos_materiales` | Struct de material (afinidad, rareza)               |
| `scr_paleta_afinidad`  | Struct de colores (dominante, secundario, energía)  |

---

## 12. Checklist para Implementar una Feature de Combate

□ ¿Necesita nueva habilidad?
→ scr_ejecutar_habilidad (case)
→ scr_cooldown_habilidad (case)
→ scr_nombre_habilidad (case)
→ Asignar a un arma en scr_datos_armas

□ ¿Necesita nuevo estado alterado?
→ scr_datos_estados (definición)
→ scr_aplicar_estado (aplicación)
→ scr_actualizar_estados (si tipo nuevo)

□ ¿Modifica el cálculo de daño?
→ scr_calcular_dano

□ ¿Afecta la carga de ESENCIA?
→ scr_actualizar_esencia

□ ¿Necesita nueva pasiva de afinidad?
→ scr_activar_pasiva_afinidad

□ ¿Necesita efecto visual especial?
→ scr_feedback_fx (tipo de FX)
→ scr_fx_flash_elemental (flash por afinidad)
→ scr_fx_hitstop (congelamiento en impacto)
→ scr_paleta_afinidad (colores por afinidad)
→ scr_actualizar_pasivas

□ ¿Necesita feedback visual?
→ obj*actor_jugador / obj_actor_enemigo (sprite)
→ Crear obj_particle*\* para VFX

□ ¿Afecta la IA del enemigo?
→ obj_control_combate (Step, sección IA)

---

## 13. Sistema de Barks de Combate

### 13.1. Concepto

Textos flotantes no bloqueantes que aparecen sobre los personajes durante el combate. Gestionados por `scr_barks_combate`.

### 13.2. Scripts

| Función                | Descripción                                             |
| ---------------------- | ------------------------------------------------------- |
| `scr_barks_init`       | Inicializa variables de barks y diálogo mid-combat      |
| `scr_barks_actualizar` | Evalúa condiciones de trigger (inicio, súper, 50% HP)   |
| `scr_barks_dibujar`    | Renderiza texto flotante sobre actor con alpha y sombra |

### 13.3. Agregar un Bark Nuevo

1. Añadir flag `bark_disparado_*` en `scr_barks_init`
2. Añadir condición de trigger en `scr_barks_actualizar`
3. Asignar `bark_texto`, `bark_quien`, `bark_timer`

---

## 14. Diálogo Mid-Combat (50% HP)

Sistema bloqueante que pausa el combate cuando cualquiera alcanza 50% HP. Se activa una sola vez por combate.

### 14.1. Scripts

| Función                   | Descripción                                                    |
| ------------------------- | -------------------------------------------------------------- |
| `scr_dial_mid_iniciar`    | Selecciona hablante aleatorio, detecta tono ganador/perdedor   |
| `scr_dial_mid_actualizar` | Update bloqueante: retorna `true` mientras diálogo esté activo |
| `scr_dial_mid_dibujar`    | Renderiza cuadro de diálogo completo con fade y nombre         |

### 14.2. Integración en el Pipeline

```gml
// En obj_control_combate/Step_0.gml, después de scr_barks_actualizar():
if (scr_dial_mid_actualizar()) {
    scr_fx_zoom_actualizar();
    scr_fx_particulas_actualizar();
    exit;  // Pausa el combate
}
```

---

## 15. Sincronía Elemental

Bonus pasivo cuando la afinidad del personaje coincide con la de su arma equipada. Se calcula al crear el struct de combate y se aplica automáticamente en el cálculo de daño y carga de esencia.
