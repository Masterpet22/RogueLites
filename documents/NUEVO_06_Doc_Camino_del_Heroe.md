# Camino del Héroe (Modo Historia) — Documentación Técnica Completa

> **Versión:** 2.0 (Mapa Ramificado)  
> **Fecha de implementación:** Marzo 2026 (v2: Junio 2026)  
> **Modo:** Principal — **"Camino del Héroe" ES el modo Historia del juego.**  
> **Referencia base:** Patrón de `obj_control_torre` / `rm_torre`

---

## 1. Resumen General

**Camino del Héroe** es el **modo Historia** (principal) del juego ARCADIUM. Es un modo roguelite narrativo estructurado en **5 capítulos** que recorre los 8 dominios elementales del mundo, culminando en el enfrentamiento contra **El Devorador** y un posible jefe secreto.

### Diferencias clave con Torre

| Aspecto               | Torre                          | Camino del Héroe                                        |
| --------------------- | ------------------------------ | ------------------------------------------------------- |
| Estructura            | Pisos infinitos aleatorios     | 5 capítulos con mapa ramificado (estilo Slay the Spire) |
| HP entre combates     | Persistente (no se recupera)   | Se resetea cada combate                                 |
| Derrota               | Fin de la run (permadeath)     | Permite reintentar el mismo combate                     |
| Narrativa             | Ninguna                        | Intro, fragmentos inter-combate, victoria por capítulo  |
| Acceso a forja/tienda | No disponible durante la run   | Disponible entre capítulos                              |
| Jefe secreto          | No tiene                       | "El Primer Conductor" (run perfecta)                    |
| Dificultad progresiva | HP x1.0 → x1.5 lineal por piso | HP x1.0 → x1.60 por capítulo                            |

---

## 2. Archivos Creados

### 2.1 Script de Datos: `scr_datos_camino`

**Ruta:** `scripts/scr_datos_camino/scr_datos_camino.gml`  
**Metadatos:** `scripts/scr_datos_camino/scr_datos_camino.yy`

Contiene todas las funciones de definición de datos del modo:

| Función                                                       | Descripción                                                                             |
| ------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| `scr_camino_get_capitulos()`                                  | Retorna array con los 5 capítulos (structs completos, incluye campo `decisiones`)       |
| `scr_camino_generar_mapa(_capitulo)`                          | Genera mapa ramificado: array de tiers, cada tier con 3-4 nodos + tier jefe, conexiones |
| `scr_camino_tipo_nodo_random(_capitulo, _tier, _total_tiers)` | Devuelve tipo de nodo aleatorio ponderado según posición en el capítulo                 |
| `scr_camino_crear_nodo(_tipo, _capitulo)`                     | Crea struct de nodo con nombre, descripción, multiplicadores y conexiones               |
| `scr_camino_fragmento_combate(_capitulo, _idx)`               | Retorna texto narrativo entre combates                                                  |
| `scr_camino_recompensa_capitulo(_capitulo)`                   | Calcula oro bonus por completar un capítulo                                             |
| `scr_camino_check_secreto(_camino_ctrl)`                      | Verifica si se desbloquea el jefe secreto (0 derrotas)                                  |

#### Estructura de un capítulo (struct)

```gml
{
    id:                 "cap_1",
    numero:             1,
    nombre:             "Las Forjas Rotas",
    subtitulo:          "Dominio de Fuego y Tierra",
    descripcion:        "...",
    color:              make_color_rgb(200, 80, 40),
    afinidades:         ["Fuego", "Tierra"],
    enemigos_comunes:   ["Soldado Igneo", "Guardian Terracota"],
    enemigos_elite:     ["Soldado Igneo Elite", "Guardian Terracota Elite"],
    jefe:               "Titan de las Forjas Rotas",
    decisiones:         4,       // número de tiers de decisión antes del jefe
    combates_comunes:   3,
    combates_elite:     1,
    hp_mult:            1.0,
    oro_mult:           1.0,
    narrativa_intro:    ["línea 1", "línea 2", ...],
    narrativa_victoria: ["línea 1", "línea 2", ...],
}
```

#### Estructura de un nodo del mapa (struct generado)

```gml
{
    tipo:           "combate",   // "combate" | "elite" | "jefe" | "tienda" | "forja" | "descanso" | "cofre"
    nombre:         "Soldado Igneo",
    descripcion:    "Un guerrero envuelto en llamas.",
    hp_mult:        1.0,
    oro_mult:       1.0,
    recompensa_oro: 0,    // solo para cofres
    conexiones:     [0, 1],  // índices de nodos en el tier siguiente
    visitado:       false,
}
```

#### Estructura del mapa (generada por `scr_camino_generar_mapa`)

```
camino_mapa = [
    [nodo, nodo, nodo],     // Tier 0: 3-4 nodos
    [nodo, nodo, nodo, nodo], // Tier 1: 3-4 nodos
    ...,                     // Tiers según cap.decisiones
    [nodo_jefe],             // Último tier: solo el jefe
]
```

Cada nodo tiene campo `conexiones[]` con índices que apuntan a nodos del tier siguiente, creando caminos ramificados.

#### Estructura de un encuentro de combate (struct temporal)

```gml
{
    nombre_enemigo: "Soldado Igneo",
    hp_mult:        1.0,
    oro_mult:       1.0,
    es_jefe:        false,
    es_elite:       false,
    tipo:           "combate",  // "combate" | "elite" | "jefe" | "secreto"
}
```

---

### 2.2 Controlador: `obj_control_camino`

**Ruta:** `objects/obj_control_camino/`  
**Metadatos:** `objects/obj_control_camino/obj_control_camino.yy`  
**Persistente:** Sí (sobrevive entre rooms para gestionar ida a rm_combate y vuelta)

Eventos:

- `Create_0.gml` — Inicialización de estado
- `Step_0.gml` — Lógica y input (650 líneas)
- `Draw_64.gml` — Renderizado GUI (676 líneas)

#### 2.2.1 Create_0.gml — Variables de Estado

```
┌─────────────────────────────────────────┐
│  CATEGORÍA              │  VARIABLES    │
├─────────────────────────────────────────┤
│  Estado general         │  camino_activo, camino_fase                              │
│  Capítulos/progreso     │  camino_capitulos[], camino_capitulo_idx, camino_capitulo │
│  Mapa ramificado        │  camino_mapa[], camino_tier_actual, camino_nodo_actual, camino_mapa_sel, camino_mapa_conexiones[] │
│  Encuentro actual       │  camino_encuentro (struct temporal de combate activo)     │
│  Selección UI           │  sel_pj_indice, sel_arma_indice, camino_armas_disponibles │
│  Personaje seleccionado │  camino_perfil_nombre, camino_arma, camino_pj_clase, etc. │
│  Tracking de run        │  camino_oro_ganado, camino_combates_ganados, camino_derrotas, camino_combates_totales │
│  Narrativa              │  camino_narrativa_lineas[], camino_narrativa_idx, camino_narrativa_destino │
│  Post-combate           │  camino_post_opcion, camino_ultimo_ganador, camino_ultimo_oro │
│  Equipamiento           │  camino_equip_objetos[], camino_equip_indice, camino_equip_runa, etc. │
│  Entre capítulos        │  camino_entre_opcion │
│  Jefe secreto           │  camino_secreto_disponible, camino_secreto_completado │
└─────────────────────────────────────────┘
```

**Protección anti-duplicados:** `if (instance_number(obj_control_camino) > 1) { instance_destroy(); exit; }`

#### 2.2.2 Step_0.gml — Máquina de Estados

**Guardias de seguridad:**

- Si `camino_fase == "combate"` y estamos en `rm_camino`: resetea a selección (safety net)
- Si `camino_fase == "combate"` y NO estamos en `rm_camino`: `exit` (el combate controla)
- Si `room != rm_camino`: `exit` (dejar que forja/tienda funcionen)

**Fases implementadas (16 estados):**

```
seleccion_personaje ─► seleccion_arma ─► [scr_camino_iniciar_run()]
                                              │
                                              ▼
                                   narrativa_linea (intro capítulo)
                                              │
                                              ▼
                                     ┌─── MAPA RAMIFICADO ───┐
                                     │  (elegir nodo: ◄►)  │
                                     └─────────┬─────────┘
                                              │
                            ┌──────┼──────┼──────┼─────┐
                          combate  tienda  forja  descanso  cofre
                            │     rm_tienda rm_forja  narrativa  +oro
                            ▼        │       │      │          │
                       pre_combate   └───────┼───────┼──────────┘
                            │               │       │
                       equipar ─► combate   │       │
                                    │       │       │
                      [scr_camino_post_combate()]    │
                            │                        │
                       post_combate ─► mapa ◄───────┘
                            │
                     (último tier = jefe?)
                       ┌────┴────┐
                      Sí          No
                       │        (vuelve al mapa)
                victoria_capitulo
                       │
                entre_capitulos ─┬─ Siguiente capítulo ─► mapa
                                ├─ Forja (rm_forja)
                                ├─ Tienda (rm_tienda)
                                └─ Abandonar ─► finalizar

                (último cap?) ─► victoria_final
                                      │
                                (0 derrotas?) ─► secreto_pre_combate
                                      │             │
                                 finalizar    secreto_victoria
                                (victoria)     │
                                          finalizar(victoria_total)

                [DERROTA en cualquier combate]
                         │
                      derrota ─┬─ Reintentar → pre_combate
                              └─ Abandonar  → finalizar("derrota")
```

**Funciones auxiliares definidas en Step_0.gml:**

| Función                                        | Descripción                                                                                                     |
| ---------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| `scr_camino_iniciar_run()`                     | Inicializa datos de run, carga capítulos, inicia capítulo 0                                                     |
| `scr_camino_iniciar_capitulo(_idx)`            | Genera mapa ramificado del capítulo, muestra narrativa intro                                                    |
| `scr_camino_siguiente_capitulo()`              | Avanza al siguiente capítulo                                                                                    |
| `scr_camino_ejecutar_nodo()`                   | Ejecuta el evento del nodo seleccionado: combate, tienda, forja, descanso, cofre                                |
| `scr_camino_lanzar_combate()`                  | Configura `obj_control_juego` (modo_camino, multiplicadores, enemigo, perfil) y ejecuta `room_goto(rm_combate)` |
| `scr_camino_post_combate(_ganador, _pj, _oro)` | Callback desde `obj_control_combate`. Enruta a victoria/derrota/secreto según resultado                         |
| `scr_camino_finalizar(_resultado)`             | Resetea todas las variables del modo (mapa, tier, nodo, etc.), vuelve a `rm_menu`                               |

#### 2.2.3 Draw_64.gml — Interfaz de Usuario

**Resolución:** 1280×720 (GUI fija).  
**Fondo:** `spr_bg_torre` (temporal; se puede reemplazar por `spr_bg_camino`).  
**Font:** `fnt_1`.

**Header común** (siempre visible):

- Oro del jugador (esquina superior derecha)
- Info de run activa: capítulo actual + personaje/arma (esquina superior izquierda)

| Fase                  | UI                                                                                                                                                    |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| `seleccion_personaje` | Título "CAMINO DEL HÉROE" + listado de 8 personajes con paneles estilizados (nombre, clase, afinidad, personalidad, arma). Cursor con borde dorado    |
| `seleccion_arma`      | Lista de armas obtenidas por el personaje seleccionado                                                                                                |
| `narrativa_linea`     | Fondo oscuro cinemático, barras decorativas del color del capítulo, texto centrado con progreso (X/N)                                                 |
| `mapa`                | **Mapa ramificado** del capítulo: nodos coloreados por tipo, conexiones entre tiers, icono del PJ, panel info del nodo seleccionado, leyenda de tipos |
| `pre_combate`         | Info del enemigo (nombre, tipo, HP%), tier actual, progreso de run                                                                                    |
| `equipar`             | Selección de hasta 3 objetos consumibles (TAB toggle) + selección de runa                                                                             |
| `post_combate`        | "¡VICTORIA!" + oro obtenido + stats acumulados + opciones Volver al mapa/Abandonar                                                                    |
| `victoria_capitulo`   | Pantalla de recompensa de capítulo con oro bonus                                                                                                      |
| `entre_capitulos`     | Hub con 4 botones estilizados: Siguiente Capítulo / Forja / Tienda / Abandonar                                                                        |
| `victoria_final`      | "¡EL DEVORADOR HA CAÍDO!" + resumen completo de la aventura                                                                                           |
| `secreto_pre_combate` | Presentación épica del Primer Conductor con advertencia                                                                                               |
| `secreto_victoria`    | "VICTORIA TOTAL" + confirmación de 100%                                                                                                               |
| `derrota`             | "DERROTA" + opciones Reintentar/Abandonar                                                                                                             |

**Mapa ramificado del capítulo (fase `mapa`):**

- Tiers horizontales (izquierda → derecha), cada uno con 3-4 nodos verticales
- Conexiones dibujadas como líneas entre tiers (brillantes = disponibles, tenues = futuras)
- Nodos coloreados según tipo: ! Combate (blanco), \* Elite (naranja), X Jefe (rojo), $ Tienda (cian), F Forja (ámbar), + Descanso (verde), C Cofre (dorado)
- Nodo seleccionado con halo luminoso
- **Icono del jugador:** sprite del personaje (`scr_sprite_personaje`) escalado a ~28px, posicionado sobre el nodo actual
- **Panel info:** a la derecha (260px), muestra tipo, nombre, descripción y multiplicadores del nodo seleccionado
- **Leyenda:** abajo del panel, muestra iconos y nombres de tipos de nodo

---

### 2.3 Room: `rm_camino`

**Ruta:** `rooms/rm_camino/rm_camino.yy`  
**Tamaño:** 1280×720  
**Capas:**

- `Instances` (depth: 0) — Contiene `inst_camino_ctrl` (instancia de `obj_control_camino` en 0,0)
- `Background` (depth: 100) — Fondo negro sólido

---

## 3. Archivos Modificados

### 3.1 `obj_menu` — Menú Principal

**Archivos:** `Create_0.gml`, `Step_0.gml`

**Cambio:** Se agregó "Camino del Héroe" como **primera opción** del menú principal (índice 0), desplazando las demás:

```
Antes:                           Después:
  0: Combatir                      0: Camino del Héroe  ← NUEVO
  1: Torre                         1: Combatir
  2: Forja                         2: Torre
  3: Tienda                        3: Forja
                                   4: Tienda
```

La opción 0 ejecuta `room_goto(rm_camino)`.

---

### 3.2 `obj_control_juego` — Controlador Global

**Archivo:** `Create_0.gml`

**Variables añadidas:**

```gml
// ── MODO CAMINO DEL HÉROE ──
modo_camino = false;
camino_hp_mult = 1;
camino_oro_mult = 1;
```

Estas variables las setea `scr_camino_lanzar_combate()` antes de cada combate y las lee `obj_control_combate` para aplicar multiplicadores.

---

### 3.3 `obj_control_combate` — Controlador de Combate

**Archivo:** `Create_0.gml`

**Cambio:** Se añadió bloque de multiplicador HP para modo camino (después del bloque de torre):

```gml
// 2b2. MODO CAMINO: aplicar multiplicador de HP al enemigo
if (variable_struct_exists(control_juego, "modo_camino") && control_juego.modo_camino) {
    var _mult_c = control_juego.camino_hp_mult;
    personaje_enemigo.vida_max    = round(personaje_enemigo.vida_max * _mult_c);
    personaje_enemigo.vida_actual = personaje_enemigo.vida_max;
}
```

**Archivo:** `Step_0.gml`

**Cambios (3 bloques):**

1. **Delegación post-combate** (cuando `combate_terminado` y se presiona Enter/Escape):

```gml
// MODO CAMINO: delegar al controlador de camino
else if (instance_exists(obj_control_juego)
    && variable_struct_exists(obj_control_juego, "modo_camino")
    && obj_control_juego.modo_camino
    && instance_exists(obj_control_camino)) {
    with (obj_control_camino) {
        scr_camino_post_combate(other.ganador, other.personaje_jugador, other.oro_recompensa);
    }
}
```

2. **Multiplicador de oro en recompensas:**

```gml
// MODO CAMINO: aplicar multiplicador de oro
if (variable_struct_exists(obj_control_juego, "modo_camino") && obj_control_juego.modo_camino) {
    _oro_ganado = round(_oro_ganado * obj_control_juego.camino_oro_mult);
}
```

3. **Consumo de objetos:** En modo Camino (igual que Torre), los objetos solo se consumen si fueron usados durante el combate:

```gml
var _es_camino = (variable_struct_exists(obj_control_juego, "modo_camino") && obj_control_juego.modo_camino);
// ...
if (_es_torre || _es_camino) {
    // Solo consumir los que se usaron
    if (is_array(objetos_usados) && objetos_usados[i]) { ... }
}
```

---

### 3.4 `RogueLites.yyp` — Proyecto

**Recursos añadidos en `resources[]`:**

- `obj_control_camino` → `objects/obj_control_camino/obj_control_camino.yy`
- `rm_camino` → `rooms/rm_camino/rm_camino.yy`
- `scr_datos_camino` → `scripts/scr_datos_camino/scr_datos_camino.yy`

**Room Order (`RoomOrderNodes[]`):**

- `rm_camino` añadido al final de la lista de rooms

---

## 4. Los 5 Capítulos

| #   | Nombre             | Afinidades      | Comunes | Élites | Jefe                        | HP Mult | Oro Mult |
| --- | ------------------ | --------------- | ------- | ------ | --------------------------- | ------- | -------- |
| 1   | Las Forjas Rotas   | Fuego + Tierra  | 3       | 1      | Titán de las Forjas Rotas   | ×1.00   | ×1.00    |
| 2   | El Fango Viviente  | Agua + Planta   | 3       | 1      | Coloso del Fango Viviente   | ×1.15   | ×1.15    |
| 3   | El Cielo Roto      | Rayo + Luz      | 4       | 1      | Sentinela del Cielo Roto    | ×1.30   | ×1.25    |
| 4   | El Abismo Quebrado | Sombra + Arcano | 4       | 2      | Oráculo Quebrado del Abismo | ×1.45   | ×1.35    |
| 5   | La Convergencia    | — (todas)       | 0       | 0      | El Devorador                | ×1.60   | ×2.00    |

**Decisiones por capítulo:** Cap 1: 4, Cap 2: 4, Cap 3: 5, Cap 4: 5, Cap 5: 2 (+ jefe).
**Total de nodos visitados por run:** ~22 nodos (variable según caminos elegidos). No todos son combates — algunos son tienda, forja, descanso o cofre.

### Recompensas por capítulo completado

| Capítulo | Oro Bonus |
| -------- | --------- |
| 1        | +100 G    |
| 2        | +175 G    |
| 3        | +250 G    |
| 4        | +350 G    |
| 5        | +600 G    |

---

## 5. Jefe Secreto: El Primer Conductor

**Condición de desbloqueo:** Completar los 5 capítulos con **0 derrotas** (run perfecta).

**Datos del encuentro secreto:**

- HP multiplicador: ×1.80
- Oro multiplicador: ×3.00
- Tipo: `"secreto"`

**Flujo:**

1. Al completar victoria final, si `camino_derrotas == 0`, se muestra narrativa de introducción del secreto
2. `secreto_pre_combate`: el jugador puede aceptar (Enter) o declinar (Escape → victoria normal)
3. Si acepta: combate contra "El Primer Conductor"
4. `secreto_victoria`: pantalla de "VICTORIA TOTAL" con mensaje de 100%

---

## 6. Flujo Completo del Modo

```
[MENÚ] → "Camino del Héroe" → rm_camino

  1. Seleccionar personaje (8 disponibles)
  2. Seleccionar arma (si tiene más de 1)
  3. scr_camino_iniciar_run() → carga 5 capítulos

  POR CADA CAPÍTULO:
    4. Narrativa intro (línea por línea, Enter avanza, Escape salta)
    5. MAPA RAMIFICADO (fase "mapa"):
       - Se muestra mapa con tiers de nodos (3-4 por tier)
       - El jugador elige camino: ◄► para seleccionar, Enter para avanzar
       - scr_camino_ejecutar_nodo() enruta según tipo de nodo:
         * combate/elite/jefe → pre_combate → equipar → combate
         * tienda → room_goto(rm_tienda) → vuelve al mapa
         * forja → room_goto(rm_forja) → vuelve al mapa
         * descanso → narrativa → vuelve al mapa
         * cofre → +oro + narrativa → vuelve al mapa
    6. POR CADA COMBATE:
       a. Pre-combate (info enemigo + tier actual)
       b. Equipar objetos (hasta 3) + runa
       c. scr_camino_lanzar_combate() → room_goto(rm_combate)
       d. [COMBATE en rm_combate]
       e. obj_control_combate detecta fin → llama scr_camino_post_combate()
       f. VICTORIA: post_combate (Volver al mapa/Abandonar)
          DERROTA: derrota (Reintentar/Abandonar)
       g. Si continúa: vuelve al mapa para siguiente elección
    7. Al llegar al último tier (jefe) y vencer: victoria_capitulo
    8. entre_capitulos: Siguiente / Forja / Tienda / Abandonar
       - Forja: room_goto(rm_forja) (obj_control_camino persiste)
       - Tienda: room_goto(rm_tienda) (obj_control_camino persiste)
       - Al volver a rm_camino: sigue en "entre_capitulos"

  AL COMPLETAR CAPÍTULO 5:
    9. Narrativa victoria del capítulo final
    10. victoria_final con estadísticas
    11. Si 0 derrotas → secreto
    12. scr_camino_finalizar() → reset completo → rm_menu
```

---

## 7. Controles

| Tecla   | Acción                                                  |
| ------- | ------------------------------------------------------- |
| ▲ / ▼   | Navegar entre opciones (selección, equipar, derrota...) |
| ◄ / ►   | Elegir nodo en el mapa ramificado                       |
| Enter   | Confirmar selección / Avanzar narrativa / Avanzar nodo  |
| Escape  | Volver / Saltar narrativa / Abandonar camino            |
| Tab     | Alternar selección de objetos (en fase equipar)         |
| Espacio | Avanzar narrativa (alternativa a Enter)                 |

---

## 8. Integración con Sistemas Existentes

### Combate

- `obj_control_combate.Create_0`: aplica `camino_hp_mult` al HP del enemigo
- `obj_control_combate.Step_0`: aplica `camino_oro_mult` al oro de recompensa
- `obj_control_combate.Step_0`: al terminar combate, delega a `scr_camino_post_combate()` si `modo_camino == true`
- Objetos consumibles: solo se consumen los que fueron usados (igual que Torre)
- Runas: se consumen al terminar el combate (comportamiento estándar)

### Perfil del personaje

- Se usa el mismo sistema de perfiles de `obj_control_juego.perfiles_personaje`
- Se setea `personaje_seleccionado` y `arma_equipada` antes de cada combate

### Forja y Tienda

- Accesibles entre capítulos via `room_goto(rm_forja)` / `room_goto(rm_tienda)`
- `obj_control_camino` persiste durante la visita
- Al presionar Escape en forja/tienda, se comprueba `modo_camino`: si es true, vuelve a `rm_camino` (fase `mapa` o `entre_capitulos` según contexto)

---

## 9. Enemigos Requeridos (Pendientes de Implementación)

Los siguientes enemigos son referenciados en `scr_datos_camino` pero probablemente aún no estén definidos en `scr_datos_enemigos`:

| Capítulo | Enemigos Nuevos Necesarios                                                                                                  |
| -------- | --------------------------------------------------------------------------------------------------------------------------- |
| 1        | Guardian Terracota, Guardian Terracota Elite                                                                                |
| 2        | Vigia Boreal Elite, Halito Verde Elite, Coloso del Fango Viviente                                                           |
| 3        | Bestia Tronadora, Bestia Tronadora Elite, Paladin Marchito, Paladin Marchito Elite, Sentinela del Cielo Roto                |
| 4        | Naufrago de la Oscuridad, Naufrago de la Oscuridad Elite, Errante Runico, Errante Runico Elite, Oraculo Quebrado del Abismo |
| 5        | El Devorador                                                                                                                |
| Secreto  | El Primer Conductor                                                                                                         |

**Nota:** Los enemigos del Capítulo 1 (`Soldado Igneo`, `Soldado Igneo Elite`, `Titan de las Forjas Rotas`) ya existen en el proyecto.

---

## 10. Posibles Mejoras Futuras

1. **Sprite propio:** Crear `spr_bg_camino` para reemplazar `spr_bg_torre` como fondo
2. **Sprites de personaje/enemigo en UI:** Mostrar sprites en las pantallas de selección y pre-combate
3. **Persistencia de progreso:** Guardar progreso del Camino entre sesiones (actualmente se pierde al cerrar)
4. **Desbloqueo progresivo:** Los capítulos 3-5 podrían requerir completar los anteriores al menos una vez
5. **Dificultad adaptativa:** Ajustar multiplicadores según estadísticas del jugador
6. **Más fragmentos narrativos:** Expandir las líneas de narrativa entre combates para mayor variedad
7. **Recompensas materiales:** Añadir drops de materiales específicos como recompensa de capítulo
8. **Logros:** Registrar completaciones, runs perfectas, tiempo total, etc.
