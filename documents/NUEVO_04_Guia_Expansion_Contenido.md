# ARCADIUM — Guía de Expansión de Contenido

> Versión consolidada · Febrero 2026

Guía oficial paso a paso para agregar contenido nuevo al proyecto sin romper la arquitectura existente. Cubre personajes, armas, enemigos, materiales, estados, afinidades y modos de juego.

---

## 1. Agregar un Nuevo Personaje

### Paso 1 — Registrar perfil en `obj_control_juego` (Create)

```gml
var p_nuevo = scr_crear_perfil_personaje("NombrePj", "Clase", "Afinidad");
ds_map_add(p_nuevo.armas_obtenidas, "Hoja Rota", true);
ds_map_add(perfiles_personaje, "NombrePj", p_nuevo);
```

### Paso 2 — Validar la clase en `scr_datos_clases`

```gml
case "ClaseDelPj":
    return {
        vida: 120,
        ataque: 14,
        defensa: 8,
        velocidad: 10,
        poder_elemental: 12,
        carga_esencia: "recibir_dano",
        habilidad_fija: "golpe_clase"
    };
```

### Paso 3 — Validar la afinidad en `scr_datos_afinidades`

Si la afinidad ya existe (Fuego, Agua, etc.), no se necesita este paso. Si es nueva, ver sección 5.

### Paso 4 — Listo

El personaje aparecerá automáticamente en `rm_select`. No se necesita editar nada más.

### Checklist rápido — Personaje

- [ ] Perfil registrado en `obj_control_juego`
- [ ] Clase definida en `scr_datos_clases`
- [ ] Afinidad existente o creada
- [ ] Habilidad fija de clase implementada en `scr_ejecutar_habilidad`

---

## 2. Agregar una Nueva Arma

### Paso 1 — Definir en `scr_datos_armas`

```gml
case "Espada Arcana":
    return {
        afinidad: "Arcano",
        rareza: 2,
        ataque_bonus: 7,
        poder_elemental_bonus: 4,
        habilidades_arma: ["corte_arcano", "onda_arcana"],
        receta: [
            { material: "Fragmento Arcano", cantidad: 6 },
            { material: "Esencia Runica", cantidad: 2 }
        ]
    };
```

### Paso 2 — Implementar habilidades en `scr_ejecutar_habilidad`

```gml
case "corte_arcano":
{
    var d = scr_calcular_dano(_atacante, _defensor);
    _defensor.vida_actual -= d;
}
break;

case "onda_arcana":
{
    var d = scr_calcular_dano(_atacante, _defensor);
    var extra = round(_atacante.poder_elemental * 0.8);
    _defensor.vida_actual -= (d + extra);
}
break;
```

### Paso 3 — Registrar cooldowns en `scr_cooldown_habilidad`

```gml
case "corte_arcano": return room_speed * 0.6;
case "onda_arcana":  return room_speed * 1.8;
```

### Paso 4 — Registrar nombres visuales en `scr_nombre_habilidad`

```gml
case "corte_arcano": return "Corte Arc.";
case "onda_arcana":  return "Onda Arc.";
```

### Paso 5 — Añadir a la lista de forja en `obj_ui_forja` (Create)

```gml
armas_forjables = [
    "Filo Igneo",
    "Mandoble Carmesi",
    "Espada Arcana"        // ← nueva
];
```

### Paso 6 — Listo

El arma aparece en la forja, se puede equipar y funciona en combate con su UI.

### Checklist rápido — Arma

- [ ] Entrada en `scr_datos_armas`
- [ ] Habilidades en `scr_ejecutar_habilidad`
- [ ] Cooldowns en `scr_cooldown_habilidad`
- [ ] Nombres en `scr_nombre_habilidad`
- [ ] Añadida a `armas_forjables` en `obj_ui_forja`

---

## 3. Agregar Enemigos

### 3.1. Enemigo Común

#### Paso 1 — Datos en `scr_datos_enemigos`

```gml
case "Bestia Tronadora":
    return {
        vida: 75, ataque: 12, defensa: 1, defensa_magica: 2,
        velocidad: 7, poder_elemental: 3,
        afinidad: "Rayo",
        habilidad_fija: "chispazo",
        drops: [
            { material: "Chispa Voltica",    cant_min: 1, cant_max: 3, chance: 100 },
            { material: "Colmillo de Rayo",  cant_min: 1, cant_max: 1, chance: 12  },
        ]
    };
```

#### Paso 2 — Registrar en `obj_enemy_select`

```gml
array_push(enemigos_comunes, "Bestia Tronadora");
```

#### Paso 3 — Implementar habilidad del enemigo (si es nueva)

```gml
case "golpe_rayo":
{
    var d = scr_calcular_dano(_atacante, _defensor);
    _defensor.vida_actual -= d;
    scr_activar_pasiva_afinidad(_atacante, "uso_habilidad");
}
break;
```

### 3.2. Enemigo Élite

Los élites tienen `habilidad_secundaria` que aplica un estado alterado. La IA la prioriza automáticamente.

```gml
case "Bestia Tronadora Elite":
    return {
        vida: 140, ataque: 18, defensa: 3, defensa_magica: 4,
        velocidad: 8, poder_elemental: 5,
        afinidad: "Rayo",
        habilidad_fija: "tormenta_electrica",
        habilidad_secundaria: "impulso_voltaico",   // aplica aceleracion_rayo
        drops: [
            { material: "Colmillo de Rayo",  cant_min: 1, cant_max: 2, chance: 100 },
            { material: "Chispa Voltica",    cant_min: 2, cant_max: 4, chance: 60  },
        ]
    };
```

```gml
array_push(enemigos_elite, "Bestia Tronadora Elite");
```

### 3.3. Jefe

```gml
case "Titan de las Forjas Rotas":
    return {
        vida: 300,
        ataque: 20,
        defensa: 12,
        afinidad: "Fuego+Tierra",
        habilidad_fija: "golpe_dual",
        material_drop: "Nucleo de Forja Antigua"  // material único
    };
```

```gml
array_push(enemigos_jefe, "Titan de las Forjas Rotas");
```

Para implementar IA de patrón en jefes, añadir al struct:

```gml
patron: ["golpe", "buff", "golpe_fuerte"],
p_index: 0
```

### Integración automática

El combate funciona sin cambios adicionales:

```gml
// rm_combate — obj_control_combate Create
var enemigo_nombre = control_juego.enemigo_seleccionado;
personaje_enemigo = scr_crear_enemigo_combate(enemigo_nombre);
```

Los drops se asignan automáticamente:

```gml
scr_inventario_agregar_material(control_juego, personaje_enemigo.material_drop, cantidad);
```

### Checklist rápido — Enemigo

- [ ] Datos en `scr_datos_enemigos`
- [ ] Registrado en `obj_enemy_select` (categoría correcta)
- [ ] Habilidad(es) implementadas en `scr_ejecutar_habilidad`
- [ ] Material de drop existente o creado

---

## 4. Agregar Materiales

### Paso 1 — Definir en `scr_datos_materiales`

```gml
case "Fragmento Sombrio":
    return { afinidad: "Sombra", rareza: "comun" };

case "Velo Oscuro":
    return { afinidad: "Sombra", rareza: "raro" };
```

### Paso 2 — Asignar a enemigos como drop

```gml
material_drop: "Fragmento Sombrio"     // en scr_datos_enemigos
```

### Paso 3 — Usar en recetas de armas

```gml
receta: [
    { material: "Fragmento Sombrio", cantidad: 6 },
    { material: "Velo Oscuro", cantidad: 2 }
]
```

---

## 5. Agregar una Nueva Afinidad

> Solo necesario si se añade un elemento más allá de los 8 existentes.

| Paso | Script/Objeto                 | Acción                                                           |
| ---- | ----------------------------- | ---------------------------------------------------------------- |
| 1    | `scr_datos_afinidades`        | Añadir nueva entrada con activador, bono, penalización, cooldown |
| 2    | `scr_multiplicador_afinidad`  | Añadir multiplicadores vs todas las afinidades existentes        |
| 3    | `scr_activar_pasiva_afinidad` | Añadir lógica de activación según condición                      |
| 4    | `scr_actualizar_pasivas`      | Añadir lógica de bono activo y duración                          |
| 5    | `scr_datos_estados`           | Crear estados asociados si los requiere                          |

---

## 6. Agregar Estados Alterados

### Paso 1 — Definir en `scr_datos_estados`

Tipos soportados: `"dot"`, `"hot"`, `"buff_defensa"`, `"buff_defensa_magica"`, `"buff_velocidad"`, `"debuff_velocidad"`, `"debuff_defensa"`, `"debuff_poder"`.

```gml
case "veneno":
    return {
        id: _id,
        tipo: "dot",
        tick_interval: round(GAME_FPS * 1.0),
        potencia_base: 2,
    };
```

### Paso 2 — Aplicar desde una habilidad

```gml
// Dentro de scr_ejecutar_habilidad, en el case de la habilidad:
scr_aplicar_estado(_defensor, "veneno", round(GAME_FPS * 3), round(_atacante.poder_elemental * 0.2));
```

### Paso 3 — Verificar tipo en `scr_actualizar_estados`

Si el tipo es nuevo (no es "dot" ni "buff_defensa"), añadir la lógica correspondiente en el switch/if del script.

### Tipos de estado implementados

| Tipo               | Efecto                      | Estados usando          |
| ------------------ | --------------------------- | ----------------------- |
| `dot`              | Daño periódico por tick     | quemadura_fuego, veneno |
| `hot`              | Curación periódica por tick | regeneracion            |
| `buff_defensa`     | +defensa temporal           | muro_tierra             |
| `buff_velocidad`   | +velocidad temporal         | aceleracion_rayo        |
| `debuff_velocidad` | -velocidad temporal         | ralentizacion           |
| `debuff_defensa`   | -defensa temporal           | vulnerabilidad          |
| `debuff_poder`     | -poder_elemental temporal   | supresion_arcana        |

---

## 7. Agregar un Modo de Juego

### Paso 1 — Crear Room y Objeto

- Room: `rm_modo_juego`
- Objeto: `obj_modo_juego`

### Paso 2 — Configurar flujo de navegación

rm_menu → rm_modo_juego → rm_select → rm_enemy_select → rm_combate

### Paso 3 — Definir reglas del modo

Cada modo solo altera:

- **Qué enemigos se generan** (aleatorios, secuenciales, etc.)
- **Cuántos combates** hay consecutivos
- **Cómo se manejan recompensas** (multiplicadores, drops garantizados)
- **Condiciones de victoria/derrota** (streak, supervivencia, etc.)

### Modos sugeridos

| Modo                             | Descripción                                       |
| -------------------------------- | ------------------------------------------------- |
| **Historia**                     | Secuencia fija de enemigos → jefes → El Devorador |
| **Roguelite (Camino del Héroe)** | Enemigos aleatorios, run con progresión temporal  |
| **Arena**                        | Combates consecutivos con dificultad creciente    |

---

## 8. Tabla de Contenido Planificado

### Armas pendientes (por afinidad)

| Afinidad | R1            | R2                   | R3                          |
| -------- | ------------- | -------------------- | --------------------------- |
| Fuego    | ✔ Filo Ígneo  | ✔ Mandoble Carmesí   | Espada Solar del Titán      |
| Agua     | Hoja Coral    | Tridente Abisal      | Lanza del Maremoto          |
| Planta   | Vara Espinosa | Látigo de Cepa       | Cetro del Bosque Primigenio |
| Rayo     | Daga Voltaica | Garras del Relámpago | Espada del Trueno Eterno    |
| Tierra   | Mazo Pétreo   | Garrote de Roca Viva | Martillo del Coloso         |
| Sombra   | Filo Sombrío  | Guadaña Penumbral    | Espada del Abismo           |
| Luz      | Espadín Áureo | Lanza Solar          | Hoja de la Aurora           |
| Arcano   | Vara Rúnica   | Espada Arcana        | Bastón del Primer Conductor |

### Enemigos pendientes

| Afinidad | Común                    | Élite                    |
| -------- | ------------------------ | ------------------------ |
| Fuego    | Soldado Ígneo            | Soldado Ígneo Élite      |
| Agua     | Vigía Boreal             | Vigía Boreal Élite       |
| Planta   | Hálito Verde             | Hálito Verde Élite       |
| Rayo     | Bestia Tronadora         | Bestia Tronadora Élite   |
| Tierra   | Guardián Terracota       | Guardián Terracota Élite |
| Sombra   | Náufrago de la Oscuridad | Náufrago Élite           |
| Luz      | Paladín Marchito         | Paladín Marchito Élite   |
| Arcano   | Errante Rúnico           | Errante Rúnico Élite     |

### Jefes pendientes

| #   | Jefe                        | Afinidades      | Material Único          |
| --- | --------------------------- | --------------- | ----------------------- |
| 1   | Titán de las Forjas Rotas   | Fuego + Tierra  | Núcleo de Forja Antigua |
| 2   | Coloso del Fango Viviente   | Agua + Planta   | Corazón de Fango        |
| 3   | Sentinela del Cielo Roto    | Rayo + Luz      | Fragmento Celestial     |
| 4   | Oráculo Quebrado del Abismo | Sombra + Arcano | Cristal del Vacío       |
| 5   | El Devorador                | Ninguna         | —                       |
| 6   | El Primer Conductor         | Ninguna         | —                       |

---

## 9. Resumen Rápido (Referencia)

### PERSONAJE

1. Perfil en `obj_control_juego`
2. Clase en `scr_datos_clases`
3. Afinidad verificada
4. → Aparece automáticamente en selección

### ARMA

1. Datos en `scr_datos_armas`
2. Habilidades en `scr_ejecutar_habilidad`
3. Cooldowns en `scr_cooldown_habilidad`
4. Nombres en `scr_nombre_habilidad`
5. Añadir a `obj_ui_forja`
6. → Funciona en forja, equipamiento y combate

### ENEMIGO

1. Datos en `scr_datos_enemigos`
2. Registro en `obj_enemy_select`
3. Habilidad implementada
4. → Combate y drops funcionan automáticamente

### MATERIAL

1. Definir en `scr_datos_materiales`
2. Asignar como drop de enemigo
3. Usar en recetas de arma
