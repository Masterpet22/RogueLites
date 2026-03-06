# ARCADIUM — Diseño Técnico Completo (TDD)

> Technical Design Document · Febrero 2026

---

## 1. Resumen Técnico

**Motor:** GameMaker Studio 2  
**Lenguaje:** GML (GameMaker Language)  
**Patrón arquitectónico:** Controladores centralizados + structs de datos + actores visuales separados  
**Persistencia:** `obj_control_juego` como singleton persistente entre rooms

---

## 2. Estructuras de Datos Fundamentales

### 2.1. Perfil de Personaje (Persistente)

Creado por `scr_crear_perfil_personaje`. Vive dentro de `obj_control_juego.perfiles_personaje` (ds_map).

```gml
{
    nombre: string,
    clase: string,
    afinidad: string,
    armas_obtenidas: ds_map,   // clave: "NombreArma", valor: true
    arma_equipada: string
}
```

### 2.2. Personaje en Combate (Temporal)

Creado por `scr_crear_personaje_combate`. Vive solo durante `rm_combate`.

```gml
{
    nombre: string,
    clase: string,
    afinidad: string,
    arma: string,

    // Stats
    vida_max: real,
    vida_actual: real,
    ataque_base: real,
    defensa_base: real,
    poder_elemental: real,

    // Habilidades
    habilidades_arma: array,       // ["hab0", "hab1", ...]
    habilidades_cd: array,         // [0, 0, 0] — timers de cooldown

    // Estados alterados
    estados: array,                // lista de structs de estado activo
    defensa_bonus_temp: real,      // buff temporal de defensa

    // Pasivas de afinidad
    pasiva_activa: bool,
    pasiva_timer: real,
    pasiva_cooldown: real,

    // Esencia
    esencia: real,                 // 0–100
    esencia_max: 100,

    // Combos (para Filotormenta / Rayo)
    combo: real,
    timer_combo: real
}
```

### 2.3. Enemigo en Combate (Temporal)

Creado por `scr_crear_enemigo_combate`. Estructura análoga al personaje con adición de:

```gml
{
    // ... misma base que personaje ...
    habilidad_fija: string,
    material_drop: string,

    // IA
    ia_timer: real,
    ia_cooldown: real,
    patron: array,              // (solo jefes) secuencia de acciones
    p_index: real,              // (solo jefes) índice actual del patrón

    // Parry Enemigo
    parry_chance: real,         // 0.06 común, 0.12 élite, 0.20 jefe
    parry_cd_timer: real,       // cooldown entre parries

    // Anti-Spam IA
    antispam_ultima_hab: string,
    antispam_repeticiones: real,
    antispam_bloqueo_bonus: real,  // bonus al parry si spamea

    // Combo tracking
    combo: real,
    timer_combo: real
}
```

### 2.4. Arma (Datos)

Devuelta por `scr_datos_armas`:

```gml
{
    afinidad: string,
    rareza: real,                  // 1, 2 o 3
    ataque_bonus: real,
    poder_elemental_bonus: real,
    habilidades_arma: array,       // ["id_hab_0", "id_hab_1", ...]
    receta: array                  // [{ material: string, cantidad: real }, ...]
}
```

### 2.5. Clase (Datos)

Devuelta por `scr_datos_clases`:

```gml
{
    vida: real,
    ataque: real,
    defensa: real,
    velocidad: real,
    poder_elemental: real,
    carga_esencia: string,         // método de carga
    habilidad_fija: string         // ID de la habilidad de clase
}
```

### 2.6. Afinidad (Datos)

Devuelta por `scr_datos_afinidades`:

```gml
{
    activador: string,
    bono: real,
    penalizacion: real,
    cooldown: real
}
```

### 2.7. Enemigo (Datos)

Devuelto por `scr_datos_enemigos`:

```gml
{
    vida: real,
    ataque: real,
    defensa: real,
    defensa_magica: real,
    velocidad: real,
    poder_elemental: real,
    afinidad: string,
    habilidad_fija: string,
    habilidad_secundaria: string,  // habilidad 2
    habilidad_3: string,           // habilidad 3 (comunes/élites/jefes)
    habilidad_4: string,           // habilidad 4 (solo jefes)
    drops: [                       // array con probabilidades
        { material: string, cant_min: real, cant_max: real, chance: real }
    ]
}
```

> **Nota:** Todos los enemigos comunes tienen mínimo 3 habilidades (básico + fija + secundaria). Los jefes tienen 4+.

### 2.8. Estado Alterado (Datos)

Devuelto por `scr_datos_estados`. Tipos: `"dot"`, `"hot"`, `"buff_defensa"`, `"buff_defensa_magica"`, `"buff_velocidad"`, `"debuff_velocidad"`, `"debuff_defensa"`, `"debuff_poder"`.

```gml
{
    id: string,
    tipo: string,
    tick_interval: real,       // solo dot/hot
    potencia_base: real,       // solo dot/hot
    defensa_bonus: real,       // solo buff_defensa
    velocidad_bonus: real,     // solo buff_velocidad
    velocidad_penalty: real,   // solo debuff_velocidad
    defensa_penalty: real,     // solo debuff_defensa
    poder_penalty: real        // solo debuff_poder
}
```

Estado Alterado activo (en combate):

```gml
{
    id: string,
    tipo: string,
    tiempo_rest: real,
    tick_interval: real,
    tick_timer: real,
    potencia: real,
    defensa_bonus: real,
    defensa_magica_bonus: real,
    velocidad_bonus: real,
    velocidad_penalty: real,
    defensa_penalty: real,
    poder_penalty: real,
    activo: bool
}
```

8 estados implementados: `quemadura_fuego`, `muro_tierra`, `aceleracion_rayo`, `veneno`, `regeneracion`, `ralentizacion`, `vulnerabilidad`, `supresion_arcana`.

### 2.9. Personalidad (Datos)

Devuelta por `scr_datos_personalidades`:

```gml
{
    ataque_mod: real,       // ej. 0.20 = +20%
    defensa_mod: real,      // ej. -0.20 = -20%
    vida_mod: real,         // ej. -0.10 = -10%
    velocidad_mod: real,    // ej. 0.15 = +15%
    poder_mod: real         // ej. 0.10 = +10%
}
```

4 personalidades: `Agresivo`, `Metódico`, `Temerario`, `Resuelto`.

### 2.10. Objeto Consumible (Datos)

Devuelto por `scr_datos_objetos`:

```gml
{
    tipo: "consumible",
    descripcion: string,
    efecto: string,       // "curar_hp", "restaurar_esencia", "buff_ataque", "buff_defensa"
    valor: real,           // magnitud del efecto
    precio: real,
    venta: real
}
```

5 consumibles: `Pocion Basica`, `Pocion Media`, `Elixir de Esencia`, `Tonico de Ataque`, `Tonico de Defensa`.

### 2.11. Objeto Rúnico (Datos)

Devuelto por `scr_datos_objetos`:

```gml
{
    tipo: "runico",
    descripcion: string,
    efecto_positivo: string,
    efecto_negativo: string,
    valor_positivo: real,
    valor_negativo: real,
    precio: real,
    venta: real
}
```

6 rúnicos: `Runa de Furia`, `Runa de Fortaleza`, `Runa de Celeridad`, `Runa del Ultimo Aliento`, `Runa Vampirica`, `Runa de Cristal`.

### 2.12. Datos de Torre

Devueltos por `scr_datos_torre`:

```gml
// Ala
{
    nombre: string,
    subtitulo: string,
    afinidades: [string, string, string],
    enemigos_comunes: [string, string, string],
    jefe: string
}

// Dificultad
{
    pisos: real,
    tienda_cada: real,
    mult_vida_enemigo: real,
    mult_oro: real,
    incluir_elites: bool,
    incluir_jefe: bool,
    recompensa_completar: real
}
```

3 alas: `Oeste`, `Este`, `Central`. 3 dificultades: `Normal`, `Difícil`, `Extremo`.

---

## 3. Ciclo de Combate (Frame a Frame)

### 3.1. Pipeline del Step

┌──────────────────────────────────────────────────────┐
│ obj_control_combate — Step Event │
├──────────────────────────────────────────────────────┤
│ 1. INPUT │
│ └─ Detectar teclas (ESPACIO, Q, W, E...) │
│ └─ scr_usar_habilidad_indice(jugador, indice) │
│ │
│ 2. EJECUCIÓN DE HABILIDAD │
│ └─ scr_ejecutar_habilidad(atacante, defensor, id)│
│ └─ scr_calcular_dano(atacante, defensor) │
│ └─ scr_multiplicador_afinidad(atk_af, def_af) │
│ └─ scr_aplicar_estado(defensor, id_estado, ...) │
│ │
│ 3. PASIVAS DE AFINIDAD │
│ └─ scr_activar_pasiva_afinidad(personaje, evento)│
│ │
│ 4. ACTUALIZACIÓN DE PERSONAJES │
│ └─ scr_actualizar_personaje(jugador) │
│ └─ scr_actualizar_personaje(enemigo) │
│ └─ scr_actualizar_pasivas(personaje) │
│ └─ scr_actualizar_estados(personaje) │
│ └─ scr_actualizar_esencia(personaje) │
│ │
│ 5. IA DEL ENEMIGO │
│ └─ Decrementa ia_timer │
│ └─ Si ia_timer <= 0 → usa habilidad (prioridad) │
│ └─ Evalúa parry_chance + anti-spam │
│ └─ Resetea ia_timer = ia_cooldown │
│ │
│ 5b. BARKS + DIÁLOGO MID-COMBAT │
│ └─ scr_barks_actualizar (texto flotante) │
│ └─ scr_dial_mid_actualizar (50% HP, bloqueante) │
│ └─ Si diálogo activo → exit (pausa combate) │
│ │
│ 6. VERIFICAR FIN DE COMBATE │
│ └─ Si vida_actual <= 0 → determinar ganador │
│ └─ Calcular y asignar drops │
│ │
│ 7. RENDER (obj_control_ui_combate — Draw) │
│ └─ Barras de vida │
│ └─ Slots de habilidades + cooldowns │
│ └─ Barra de ESENCIA │
│ └─ Nombre + arma equipada │
└──────────────────────────────────────────────────────┘

### 3.2. Cálculo de Daño

```gml
// scr_calcular_dano(_atacante, _defensor)
var dano_fisico = max(1, _atacante.ataque_base - _defensor.defensa_base - _defensor.defensa_bonus_temp);
var dano_elemental = round(_atacante.poder_elemental * scr_multiplicador_afinidad(_atacante.afinidad, _defensor.afinidad));
return dano_fisico + dano_elemental;
```

### 3.3. Multiplicador de Afinidad

Tabla de relaciones elementales que devuelve un multiplicador (ej. 1.5 ventaja, 0.5 desventaja, 1.0 neutral).

### 3.4. Sistema de Cooldowns

Cada habilidad tiene un cooldown en frames:

```gml
// scr_cooldown_habilidad(_id_habilidad)
case "ataque_basico": return room_speed * 1.0;
case "ataque_fuego_basico": return room_speed * 1.2;
case "ataque_fuego_mejorado": return room_speed * 1.0;
case "explosion_carmesi": return room_speed * 2.0;
```

El array `habilidades_cd` se decrementa cada frame y se resetea al usar la habilidad.

---

## 4. Sistema de Pasivas de Afinidad

### 4.1. Activación

```gml
// scr_activar_pasiva_afinidad(_personaje, _evento)
// _evento puede ser: "uso_habilidad", "recibir_dano", "hit_rapido", etc.

// Ejemplo para Fuego:
if (_personaje.afinidad == "Fuego" && _evento == "uso_habilidad") {
    if (!_personaje.pasiva_activa && _personaje.pasiva_cooldown <= 0) {
        _personaje.pasiva_activa = true;
        _personaje.pasiva_timer = room_speed * 3;  // duración
    }
}
```

### 4.2. Actualización

```gml
// scr_actualizar_pasivas(_personaje)
if (_personaje.pasiva_activa) {
    _personaje.pasiva_timer--;
    // Aplicar bono activo (ej. +20% daño para Fuego)
    if (_personaje.pasiva_timer <= 0) {
        _personaje.pasiva_activa = false;
        _personaje.pasiva_cooldown = room_speed * 5;  // CD antes de reactivar
    }
}
if (_personaje.pasiva_cooldown > 0) _personaje.pasiva_cooldown--;
```

### 4.3. Afinidades Implementadas

| Afinidad | Activador              | Bono         |
| -------- | ---------------------- | ------------ |
| Fuego    | Uso de habilidad       | +20% daño    |
| Rayo     | Golpes rápidos (combo) | (stub)       |
| Tierra   | Recibir daño           | +20% defensa |

---

## 5. Sistema de Estados Alterados

### 5.1. Aplicación

```gml
// scr_aplicar_estado(_personaje, _id_estado, _duracion, _poder)
var datos = scr_datos_estados(_id_estado);
var estado_activo = {
    id: datos.id,
    tipo: datos.tipo,
    tiempo_rest: _duracion,
    tick_interval: datos.tick_interval,
    tick_timer: datos.tick_interval,
    potencia: round(datos.potencia_base * (_poder / 10)),
    defensa_bonus: datos.defensa_bonus,
    activo: true
};
array_push(_personaje.estados, estado_activo);
```

### 5.2. Actualización por Frame

```gml
// scr_actualizar_estados(_personaje)
for (var i = array_length(_personaje.estados) - 1; i >= 0; i--) {
    var e = _personaje.estados[i];
    if (!e.activo) continue;

    e.tiempo_rest--;

    if (e.tipo == "dot") {
        e.tick_timer--;
        if (e.tick_timer <= 0) {
            _personaje.vida_actual -= e.potencia;
            e.tick_timer = e.tick_interval;
        }
    }

    if (e.tipo == "buff_defensa") {
        _personaje.defensa_bonus_temp = e.defensa_bonus;
    }

    if (e.tiempo_rest <= 0) {
        e.activo = false;
        if (e.tipo == "buff_defensa") _personaje.defensa_bonus_temp = 0;
    }
}
```

---

## 6. Sistema de ESENCIA

### 6.1. Carga

```gml
// scr_actualizar_esencia(_personaje, _evento, _valor)
switch (_personaje.clase) {
    case "Vanguardia":   // _evento == "recibir_dano"
        _personaje.esencia += _valor * 0.5;
        break;
    case "Filotormenta":  // _evento == "uso_habilidad"
        _personaje.esencia += 8;
        break;
    case "Quebrador":     // _evento == "golpe_fuerte"
        _personaje.esencia += _valor * 0.8;
        break;
    case "Centinela":     // _evento == "mitigar_dano"
        _personaje.esencia += _valor * 0.6;
        break;
    case "Duelista":      // _evento == "contraataque"
        _personaje.esencia += 15;
        break;
    case "Canalizador":   // _evento == "hab_elemental"
        _personaje.esencia += 10;
        break;
}
_personaje.esencia = clamp(_personaje.esencia, 0, 100);
```

### 6.2. Activación de Súper

Cuando `esencia >= 50` (50%), el jugador puede activar la Súper-Habilidad (tecla TAB). La potencia escala por tier:

```gml
// scr_ejecutar_super(_jugador, _enemigo)
var _pct = _jugador.esencia / _jugador.esencia_max;
var _tier_mult = 0.50;  // 50-74%
if (_pct >= 0.75) _tier_mult = 0.75;  // 75-99%
if (_pct >= 1.00) _tier_mult = 1.00;  // 100%

// Selección por clase + personalidad (24 variantes)
var _clave = _jugador.clase + "_" + _jugador.personalidad;
switch (_clave) {
    case "Vanguardia_Agresivo":
        var _dano = round(_jugador.ataque_base * 3.5 * _tier_mult);
        // penetración total (ignora defensa)
        _enemigo.vida_actual -= _dano;
        break;
    // ... 23 variantes más
}
_jugador.esencia = 0;
```

Tras usarla, ESENCIA vuelve a 0.

---

## 7. Sistema de Inventario y Forja

### 7.1. Inventario

```gml
// scr_inventario_agregar_material(_control, _material, _cantidad)
var actual = ds_map_find_value(_control.inventario_materiales, _material);
if (is_undefined(actual)) actual = 0;
ds_map_replace(_control.inventario_materiales, _material, actual + _cantidad);

// scr_inventario_get_material(_control, _material)
var val = ds_map_find_value(_control.inventario_materiales, _material);
return is_undefined(val) ? 0 : val;
```

### 7.2. Verificación de Forja

```gml
// scr_inventario_puede_fabricar_arma(_control, _nombre_arma)
var arma = scr_datos_armas(_nombre_arma);
for (var i = 0; i < array_length(arma.receta); i++) {
    var req = arma.receta[i];
    if (scr_inventario_get_material(_control, req.material) < req.cantidad) {
        return false;
    }
}
return true;
```

### 7.3. Proceso de Forja

```gml
// scr_fabricar_arma(_control, _nombre_arma, _perfil)
// 1. Verificar materiales
if (!scr_inventario_puede_fabricar_arma(_control, _nombre_arma)) return false;

// 2. Gastar materiales
var arma = scr_datos_armas(_nombre_arma);
for (var i = 0; i < array_length(arma.receta); i++) {
    var req = arma.receta[i];
    var actual = scr_inventario_get_material(_control, req.material);
    ds_map_replace(_control.inventario_materiales, req.material, actual - req.cantidad);
}

// 3. Marcar arma como obtenida
ds_map_add(_perfil.armas_obtenidas, _nombre_arma, true);

// 4. Equipar
_perfil.arma_equipada = _nombre_arma;
return true;
```

---

## 8. IA del Enemigo

### 8.1. IA Multi-Habilidad (Todos los enemigos)

La IA recorre `habilidades_arma` de mayor a menor índice (prioridad: secundaria > fija > básica). Usa la primera habilidad con cooldown disponible. Los cooldowns se gestionan automáticamente por `scr_actualizar_personaje`.

```gml
// En obj_control_combate Step
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

Composición de habilidades por categoría:

- **Comunes:** `["ataque_basico", habilidad_fija, habilidad_secundaria]` — 3 habilidades
- **Élites:** `["ataque_basico", habilidad_fija, habilidad_secundaria, habilidad_3]` — 3–4 habilidades (aplican estados)
- **Jefes:** `["ataque_basico", habilidad_fija, habilidad_secundaria, habilidad_3, habilidad_4]` — 4–5 habilidades (con mecánicas temáticas)

> **Nota:** Cada enemigo tiene mínimo 3 habilidades con cooldowns independientes. Los jefes nuevos (Heraldo, Leviatán) tienen 4 habilidades propias.

### 8.2. IA de Jefes (Patrones)

```gml
// Jefes con patrón secuencial
var accion = enemigo.patron[enemigo.p_index];
ejecutar_accion_boss(accion);
enemigo.p_index = (enemigo.p_index + 1) mod array_length(enemigo.patron);
```

---

## 9. UI del Combate

### 9.1. HUD (`obj_control_ui_combate` — Draw Event)

| Elemento              | Posición               | Descripción                  |
| --------------------- | ---------------------- | ---------------------------- |
| Barra de vida jugador | Arriba-izquierda       | Color verde→rojo según %     |
| Barra de vida enemigo | Arriba-derecha         | Color verde→rojo según %     |
| Nombre + arma         | Debajo de barras       | Texto informativo            |
| Slots de habilidades  | Centro-abajo           | Nombre + tecla asignada      |
| Overlay de cooldown   | Sobre slots            | Contador visual cuando en CD |
| Barra de ESENCIA      | Debajo de vida jugador | Se llena progresivamente     |

### 9.2. Sistema Visual de Esencia (FX)

La Esencia es la estrella visual del combate. Su sistema de FX (`scr_fx_esencia_visual`) comunica progresión de carga:

| Tier     | Rango  | Efecto Visual                                                      |
| -------- | ------ | ------------------------------------------------------------------ |
| Inactivo | 0–49%  | Sin efecto especial                                                |
| Pulso    | 50–74% | Barra pulsa sutilmente, leve glow elemental sobre personaje        |
| Intenso  | 75–99% | Pulso más rápido, glow con color secundario→energía, cambio sonoro |
| Máximo   | 100%   | Aura elemental completa (additive blending), barra brillando       |

Al activar Súper:

- **Hitstop:** 0.2s de congelamiento total (12 frames a 60fps)
- **Screenshake:** Sacudida fuerte durante 0.33s
- **Flash elemental:** Pantalla completa con color de energía de la afinidad
- **Foco dinámico:** La cámara se centra en quien ejecuta la súper (`foco_quien` = 1 jugador / 2 enemigo), determinado dinámicamente por `_atacante.es_jugador`
- **Blur de escenario:** Overlay oscuro (25% alpha) + tinte elemental (8% alpha) sobre el fondo, dura ~0.6s tras el hitstop, fade-out gradual en los últimos 10 frames

### 9.3. Sistema de Paleta por Afinidad

Cada afinidad tiene 3 colores fijos (`scr_paleta_afinidad`):

| Propiedad  | Uso                                     |
| ---------- | --------------------------------------- |
| Dominante  | Flash de daño, tint base                |
| Secundario | Glow medio (50-75% esencia)             |
| Energía    | Glow máximo, flash de súper, partículas |

Los colores se usan automáticamente en:

- Flash de sprite al recibir daño (color del atacante)
- Glow de esencia sobre el sprite del jugador (additive blending)
- Flash de pantalla al activar súper
- Hitstop automático en golpes fuertes (>15% vida max)

### 9.4. Teclas de Habilidades

| Tecla   | Slot                               |
| ------- | ---------------------------------- |
| ESPACIO | Habilidad de arma 0                |
| Q       | Habilidad de arma 1 (R2+)          |
| W       | Habilidad de arma 2 (R3)           |
| E       | Habilidad fija de clase            |
| R       | Súper-Habilidad (si ESENCIA ≥ 50%) |
| 1       | Objeto consumible slot 1           |
| 2       | Objeto consumible slot 2           |
| 3       | Objeto consumible slot 3           |

---

## 10. Gestión de Memoria y CleanUp

### 10.1. `obj_control_juego` — CleanUp Event

```gml
// Destruir inventario
if (ds_exists(inventario_materiales, ds_type_map)) {
    ds_map_destroy(inventario_materiales);
}

// Destruir perfiles y sus submapas
var key = ds_map_find_first(perfiles_personaje);
while (!is_undefined(key)) {
    var perfil = ds_map_find_value(perfiles_personaje, key);
    if (ds_exists(perfil.armas_obtenidas, ds_type_map)) {
        ds_map_destroy(perfil.armas_obtenidas);
    }
    key = ds_map_find_next(perfiles_personaje, key);
}
ds_map_destroy(perfiles_personaje);
```

> **Regla:** Todo `ds_map` y `ds_list` creado en Create debe destruirse en CleanUp. Sin excepciones.

---

## 11. Diagrama de Dependencias entre Scripts

scr_datos_clases ──────────────┐
scr_datos_afinidades ──────────┤
scr_datos_armas ───────────────┼──→ scr_crear_personaje_combate ──→ obj_control_combate
scr_datos_enemigos ────────────┤ │
scr_datos_estados ─────────────┤ │
scr_datos_personalidades ──────┤ ↓
scr_datos_objetos ─────────────┘ scr_ejecutar_habilidad
│ │
scr_config_juego (macros) scr_calcular_dano scr_aplicar_estado
│ │ │
↓ scr_multiplicador_af. scr_actualizar_estados
scr_formula_dano ──→ scr_calcular_dano │
scr_formula_beneficio scr_activar_pasiva_afinidad
│
scr_mecanicas_combate ──→ obj_control_combate scr_actualizar_pasivas
scr_ejecutar_super ─────→ obj_control_combate
scr_usar_objeto_combate ─→ obj_control_combate
scr_datos_torre ────────→ obj_control_torre
scr_datos_tienda ───────→ obj_ui_tienda

---

## 12. Armas Implementadas (Detalle Técnico)

### 12.1. Hoja Rota (Arma Inicial)

```gml
case "Hoja Rota":
    return {
        afinidad: "Fuego",
        rareza: 1,
        ataque_bonus: 0,
        poder_elemental_bonus: 0,
        habilidades_arma: ["ataque_basico"],
        receta: []
    };
```

### 12.2. Filo Ígneo (R1 — Fuego)

```gml
case "Filo Igneo":
    return {
        afinidad: "Fuego",
        rareza: 1,
        ataque_bonus: 4,
        poder_elemental_bonus: 3,
        habilidades_arma: ["ataque_fuego_basico"],
        receta: [
            { material: "Fragmento Igneo", cantidad: 5 }
        ]
    };
```

### 12.3. Mandoble Carmesí (R2 — Fuego)

```gml
case "Mandoble Carmesi":
    return {
        afinidad: "Fuego",
        rareza: 2,
        ataque_bonus: 8,
        poder_elemental_bonus: 6,
        habilidades_arma: ["ataque_fuego_mejorado", "explosion_carmesi"],
        receta: [
            { material: "Fragmento Igneo", cantidad: 10 },
            { material: "Brasa Carmesi", cantidad: 3 }
        ]
    };
```

### 12.4. Habilidades Implementadas

| ID                      | Nombre visual  | Efecto                           | Cooldown |
| ----------------------- | -------------- | -------------------------------- | -------- |
| `ataque_basico`         | Ataque         | Daño físico puro                 | 1.0s     |
| `ataque_fuego_basico`   | Fuego Básico   | Daño físico + elemental fuego    | 1.2s     |
| `ataque_fuego_mejorado` | Fuego Mejorado | Daño físico + elemental mejorado | 1.0s     |
| `explosion_carmesi`     | Explosión      | Daño + aplica quemadura (DoT)    | 2.0s     |

---

## 13. Macros Globales (`scr_config_juego`)

```gml
// General
#macro GAME_FPS            60
#macro ESTADO_DUR_MAX_SEG  5

// Esencia
#macro ESENCIA_PCT_DANO       0.05
#macro ESENCIA_MULT_VEL       0.3
#macro ESENCIA_MULT_PODER_MAG 0.2
#macro ESENCIA_CRIT_BONUS     1.5

// Críticos
#macro CRIT_BASE_CHANCE    3
#macro CRIT_ATK_DIVISOR    3
#macro CRIT_POS_CHANCE     5
#macro CRIT_POS_MULT       1.50
#macro CRIT_NEG_CHANCE     3
#macro CRIT_NEG_MULT       0.60

// IA
#macro IA_ACCION_BASE_FRAMES 180
#macro IA_VEL_FACTOR         0.12
#macro IA_PREP_FRAMES        30
#macro IA_VARIACION          0.15

// Fórmula de daño
#macro FACTOR_DEF_GLOBAL   0.50
#macro VAR_RANGO           0.15
#macro VAR_MIN_ABS         2
#macro CDR_POR_VEL         0.02
```

---

## 14. Sistema de Mecánicas Especiales (Técnico)

Las mecánicas especiales se definen en el array `mecanicas` de cada enemigo élite/jefe y se procesan por `scr_mecanicas_combate` durante el Step del combate.

```gml
// scr_mecanicas_combate(_enemigo, _jugador, _contexto)
for (var i = 0; i < array_length(_enemigo.mecanicas); i++) {
    var _mec = _enemigo.mecanicas[i];
    switch (_mec) {
        case "mec_ventana_invertida":
            // Mult. daño varía: esperando ×0.50, preparando ×1.00, atacando ×0.30
            break;
        case "mec_penalizacion_repeticion":
            // Si jugador repite afinidad 3 veces → −25% daño por stack
            break;
        case "mec_reflejo_diferido":
            // Acumula 40% del daño recibido, max 200, lo devuelve al atacar
            break;
        case "mec_escalado_vida_jugador":
            // Daño enemigo: si jugador HP lleno ×1.50, si bajo ×0.60
            break;
        case "mec_afinidad_reactiva":
            // −60% al elemento más usado por el jugador
            break;
        case "mec_absorcion_esencia":
            // Súper al 100% → enemigo roba 30% HP; <100% → enemigo vulnerable 5s
            break;
    }
}
```

---

## 15. Sistema de Barks y Diálogo Mid-Combat

### 15.1. Barks de Combate (`scr_barks_combate`)

Sistema de texto flotante **no bloqueante** que muestra comentarios cortos de los personajes durante el combate.

**Inicialización** (`scr_barks_init`):

- `bark_activo`, `bark_quien` (1=jugador, 2=enemigo), `bark_texto`, `bark_timer`, `bark_alpha`
- `bark_disparado_*` — flags para evitar repetir barks en el mismo combate

**Actualización** (`scr_barks_actualizar`):

- Se evalúan condiciones cada frame (inicio de combate, uso de súper, 50% HP, etc.)
- Al dispararse, se asigna texto + duración y se muestra sobre el sprite correspondiente

**Render** (`scr_barks_dibujar`):

- Texto con `draw_text_ext` sobre el actor, con alpha progresivo y sombra

### 15.2. Diálogo Mid-Combat (50% HP)

Sistema **bloqueante** que pausa el combate cuando cualquiera de los dos alcanza 50% HP. Se activa **una sola vez** por combate.

**Macros:**

- `DIAL_MID_DURACION` = 180 frames (3 segundos)
- `DIAL_MID_FADE` = 15 frames (fade-in/fade-out)

**Variables** (en `scr_barks_init`):

- `dial_mid_activo`, `dial_mid_disparado`, `dial_mid_frases`, `dial_mid_indice`, `dial_mid_timer`

**Funciones:**

| Función                   | Descripción                                                                                                                                                 |
| ------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `scr_dial_mid_iniciar`    | Selecciona hablante aleatorio, determina si gana/pierde por % HP, elige frases                                                                              |
| `scr_dial_mid_actualizar` | Update bloqueante: si activo retorna `true` (pausa Step), avanza timer, Enter skip                                                                          |
| `scr_dial_mid_activo`     | Query rápido: `return _c.dial_mid_activo`                                                                                                                   |
| `scr_dial_mid_dibujar`    | Renderiza cuadro de diálogo: overlay oscuro, rectángulo redondeado, borde color (azul=jugador, rojo=enemigo), nombre, texto, indicador [ENTER] con parpadeo |

**Frases ganadoras:** "¡Ya eres mío!", "¿Eso es todo lo que tienes?", "Siento tu debilidad...", etc.
**Frases perdedoras:** "No... aún no termino...", "Esto no puede acabar así...", "¡No pienso rendirme!", etc.

**Integración:**

- En `obj_control_combate/Step_0.gml`: se llama `scr_dial_mid_actualizar()` tras `scr_barks_actualizar`. Si retorna `true`, se ejecuta `exit` (pausa el combate).
- En `obj_control_ui_combate/Draw_64.gml`: se llama `scr_dial_mid_dibujar()` al final del draw.

---

## 16. Sincronía Elemental

Cuando el jugador y su arma comparten la misma afinidad, se activa un bonus pasivo:

- **Bonus de daño elemental** escalado
- **Bonus a la carga de ESENCIA**

Se verifica en `scr_crear_personaje_combate` al crear el struct de combate, y se aplica en `scr_calcular_dano` y `scr_actualizar_esencia`.

---

## 17. Sistema de Parry Enemigo + Anti-Spam IA

### 17.1. Parry Enemigo

Los enemigos pueden bloquear parcialmente ataques del jugador. La probabilidad varía por rareza:

| Rareza | `parry_chance` | Reducción de daño |
| ------ | -------------- | ----------------- |
| Común  | 0.06 (6%)      | 70%               |
| Élite  | 0.12 (12%)     | 70%               |
| Jefe   | 0.20 (20%)     | 70%               |

El cooldown entre parries (`parry_cd_timer`) evita parries consecutivos inmediatos.

### 17.2. Anti-Spam IA

Si el jugador repite la misma habilidad consecutivamente:

```gml
// En scr_ejecutar_habilidad, al recibir habilidad del jugador:
if (_id == _def.antispam_ultima_hab) {
    _def.antispam_repeticiones++;
    _def.antispam_bloqueo_bonus += 0.02;  // +2% parry por repetición
} else {
    _def.antispam_ultima_hab = _id;
    _def.antispam_repeticiones = 0;
    _def.antispam_bloqueo_bonus = 0;
}
```

El bonus de anti-spam se suma a `parry_chance` para penalizar el spam de una sola habilidad.

---

## 18. Sistema de Combos

### 18.1. Mecánica

Cada vez que el jugador golpea exitosamente dentro de una ventana de tiempo, el contador de combos se incrementa:

```gml
_p.combo++;
_p.timer_combo = room_speed * 1.0;  // ventana de 1 segundo
```

El combo se reinicia cuando:

- La ventana de tiempo expira (`timer_combo` llega a 0)
- El enemigo realiza un parry exitoso

### 18.2. Efectos del Combo

- **Pasiva de Rayo:** Se activa al alcanzar combo ≥ 3 (`scr_activar_pasiva_afinidad(_p, "hit_rapido")`)
- **Feedback visual:** Se muestra el contador de combo en la UI (×2, ×3, ×4...)

---

## 19. Zoom Dinámico + Blur en Súper

### 19.1. Centralización Dinámica

`scr_fx_activar_super(_afinidad, _atacante)` ahora recibe el struct del atacante y determina el foco:

```gml
var _es_jugador = variable_struct_exists(_atacante, "es_jugador") ? _atacante.es_jugador : true;
_c.foco_quien = _es_jugador ? 1 : 2;  // 1=jugador, 2=enemigo
```

### 19.2. Blur de Escenario

Variables en `scr_feedback_init`:

- `super_blur_timer` — frames restantes del efecto
- `super_blur_alpha` — opacidad del overlay (máx 0.85)
- `super_blur_surface` — reservado para futuro blur por shader

Activación en `scr_fx_activar_super`:

```gml
_c.super_blur_timer = HITSTOP_SUPER_FRAMES + round(GAME_FPS * 0.6);
_c.super_blur_alpha = 0.85;
```

Render en `obj_control_ui_combate/Draw_64.gml` (después del fondo, antes de la UI):

```gml
if (_c.super_blur_timer > 0) {
    // Overlay oscuro
    draw_set_alpha(0.25 * _c.super_blur_alpha);
    draw_set_colour(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    // Tinte elemental
    draw_set_alpha(0.08 * _c.super_blur_alpha);
    draw_set_colour(_c.flash_color);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
}
```

---

## 20. Jefes Nuevos (Heraldo de la Llama Negra / Leviatan Esporal)

### 20.1. Heraldo de la Llama Negra

| Campo       | Valor                                                                         |
| ----------- | ----------------------------------------------------------------------------- |
| Afinidades  | Fuego + Sombra                                                                |
| HP          | Alto                                                                          |
| Habilidades | Pulso de Fuego Negro, Llama Consumidora, Sombra Abrasadora, Detonación Oscura |

### 20.2. Leviatán Esporal

| Campo       | Valor                                                         |
| ----------- | ------------------------------------------------------------- |
| Afinidades  | Planta + Agua                                                 |
| HP          | Muy alto                                                      |
| Habilidades | Zarpa Esporal, Marea de Esporas, Raíz Abisal, Diluvio Fúngico |

Ambos jefes están registrados en `obj_control_juego/Create_0.gml` y `obj_enemy_select/Create_0.gml`, con cooldowns en `scr_cooldown_habilidad` e implementaciones en `scr_ejecutar_habilidad`.
