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
    p_index: real               // (solo jefes) índice actual del patrón
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
    habilidad_secundaria: string,  // solo élites
    drops: [                       // array con probabilidades
        { material: string, cant_min: real, cant_max: real, chance: real }
    ]
}
```

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
│ └─ Si ia_timer <= 0 → usa habilidad_fija │
│ └─ Resetea ia_timer = ia_cooldown │
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

Cuando `esencia >= 100`, el jugador puede activar la Súper-Habilidad (tecla dedicada). Tras usarla, ESENCIA vuelve a 0.

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

- **Comunes:** `["ataque_basico", habilidad_fija]` — 2 habilidades
- **Élites:** `["ataque_basico", habilidad_fija, habilidad_secundaria]` — 3 habilidades (la secundaria aplica estados)
- **Jefes:** `["ataque_basico", habilidad_fija]` — 2 habilidades (con mecánicas temáticas)

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

### 9.2. Teclas de Habilidades

| Tecla   | Slot                                |
| ------- | ----------------------------------- |
| ESPACIO | Habilidad de arma 0                 |
| Q       | Habilidad de arma 1 (R2+)           |
| W       | Habilidad de arma 2 (R3)            |
| E       | Habilidad fija de clase             |
| R       | Súper-Habilidad (si ESENCIA = 100%) |

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
scr_datos_estados ─────────────┘ │
↓
scr_ejecutar_habilidad
│ │
scr_calcular_dano scr_aplicar_estado
│ │
scr_multiplicador_afinidad scr_actualizar_estados
│
scr_activar_pasiva_afinidad
│
scr_actualizar_pasivas

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
