# ARCADIUM — Manual de Desarrollo

> Versión consolidada · Febrero 2026

---

## 1. Visión General del Proyecto

### 1.1. Resumen

Arcadium es un roguelite táctico 1v1 en tiempo real desarrollado en **GameMaker Studio 2**. El combate es estático (sin movimiento), basado en habilidades con cooldown, con progresión mediante forja de armas y sistema de Esencia.

### 1.2. Estado Actual del MVP

| Componente                                          | Estado       |
| --------------------------------------------------- | ------------ |
| Combate funcional 1v1                               | ✔ Completado |
| Armas con efecto en daño real                       | ✔ Completado |
| Afinidades con pasivas                              | ✔ Completado |
| Perfiles de personaje escalables                    | ✔ Completado |
| Forja completa y funcional                          | ✔ Completado |
| Pantalla de selección profesional                   | ✔ Completado |
| HUD de combate limpio y expandible                  | ✔ Completado |
| IA básica del enemigo                               | ✔ Completado |
| Arquitectura escalable                              | ✔ Completado |
| Estados alterados (quemadura, buff defensa)         | ✔ Completado |
| Armas R1 y R2 funcionales                           | ✔ Completado |
| Selector de enemigos por categoría                  | ✔ Completado |
| Overhaul de stats (def. mágica, crit, CDR, esencia) | ✔ Completado |
| Sistema daño físico/mágico (tipo_dano)              | ✔ Completado |
| 8 estados alterados con handlers completos          | ✔ Completado |
| IA multi-habilidad para enemigos                    | ✔ Completado |
| Enemigos élite con hab. secundaria + estados        | ✔ Completado |
| Velocidad/poder_elemental por enemigo               | ✔ Completado |

### 1.3. Funcionalidades Pendientes

| Prioridad | Funcionalidad                                                                        |
| --------- | ------------------------------------------------------------------------------------ |
| Alta      | Habilidades activas adicionales (más slots, UI)                                      |
| Alta      | Más armas por afinidad                                                               |
| Alta      | Armas R3 con 3 habilidades                                                           |
| ~~Alta~~  | ~~Estados alterados: shock, ralentización, vulnerabilidad~~ → HECHO (8 estados)      |
| ~~Alta~~  | ~~Sistema de Tienda~~ → HECHO (4 categorías: personajes, enemigos, objetos, rúnicos) |
| ~~Alta~~  | ~~Sistema de Objetos Consumibles~~ → HECHO (5 consumibles)                           |
| ~~Alta~~  | ~~Sistema de Rúnicos~~ → HECHO (6 runas con trade-offs)                              |
| ~~Alta~~  | ~~24 Súper-habilidades~~ → HECHO (6 clases × 4 personalidades)                       |
| ~~Alta~~  | ~~Mecánicas de combate especiales~~ → HECHO (6 mecánicas élite/jefe)                 |
| ~~Media~~ | ~~Modo Torre~~ → HECHO (3 alas, 3 dificultades, tienda de piso)                      |
| Media     | Mejorar UI visual (iconos, barras estilizadas)                                       |
| ~~Media~~ | ~~Enemigos por afinidad completos (×8)~~ → HECHO                                     |
| ~~Media~~ | ~~Enemigos élite y jefes~~ → HECHO (8 élites + 6 jefes definidos)                    |
| Media     | Animaciones de combate (impacto, casteo)                                             |
| Baja      | Sistema de historia / Camino del Héroe                                               |
| Baja      | Sistema de builds profundas                                                          |
| Baja      | El Devorador (jefe final)                                                            |

---

## 2. Arquitectura del Proyecto

### 2.1. Rooms

| Room              | Función                                     |
| ----------------- | ------------------------------------------- |
| `rm_boot`         | Inicialización del juego, salto al menú     |
| `rm_menu`         | Menú principal (combate / forja / historia) |
| `rm_select`       | Selección de personaje + popup de arma      |
| `rm_enemy_select` | Selector de enemigos (categorías + lista)   |
| `rm_combate`      | Escena del combate 1v1 en tiempo real       |
| `rm_forja`        | Sistema de forja de armas                   |
| `rm_tienda`       | Tienda de desbloqueo (personajes, objetos)  |
| `rm_torre`        | Modo Torre (roguelite por pisos)            |

### 2.2. Objetos Principales

#### Controladores

| Objeto                   | Tipo            | Responsabilidad                                                                                            |
| ------------------------ | --------------- | ---------------------------------------------------------------------------------------------------------- |
| `obj_control_juego`      | **Persistente** | Estado global: perfiles, inventario materiales, armas por personaje, personaje/enemigo seleccionado        |
| `obj_control_combate`    | Por room        | Carga structs de jugador y enemigo, ejecuta ciclo de combate (Step), actualiza pasivas, estados, cooldowns |
| `obj_control_ui_combate` | Por room        | HUD: barras de vida, habilidades, cooldowns, ESENCIA                                                       |

#### UI / Flujo

| Objeto              | Responsabilidad                                                        |
| ------------------- | ---------------------------------------------------------------------- |
| `obj_menu`          | Navegación del menú principal                                          |
| `obj_select`        | Selección de personaje + popup de armas desbloqueadas                  |
| `obj_enemy_select`  | Selector de enemigos por categoría (comunes, élite, jefes)             |
| `obj_ui_forja`      | UI de forja escalable por personaje                                    |
| `obj_ui_tienda`     | UI de tienda con 4 categorías (personajes, enemigos, objetos, rúnicos) |
| `obj_control_torre` | Controlador del Modo Torre (pisos, alas, dificultad, HP persistente)   |

#### Actores (Solo Visual)

| Objeto              | Responsabilidad                                          |
| ------------------- | -------------------------------------------------------- |
| `obj_actor_jugador` | Representación visual del jugador (sprites, animaciones) |
| `obj_actor_enemigo` | Representación visual del enemigo                        |

> **Importante:** Los actores NO contienen lógica de combate. Toda la lógica está en los structs manejados por `obj_control_combate`.

### 2.3. Organización de Scripts

scripts/
├── datos/ # Base de datos interna
│ ├── scr_datos_clases
│ ├── scr_datos_afinidades
│ ├── scr_datos_materiales
│ ├── scr_datos_armas
│ ├── scr_datos_enemigos
│ ├── scr_datos_estados
│ └── scr_datos_recetas_forja (reemplazado por recetas en armas)
│
├── personaje/ # Creación y gestión de personajes
│ ├── scr_crear_perfil_personaje
│ ├── scr_get_perfil_activo
│ ├── scr_crear_personaje_combate
│ └── scr_crear_enemigo_combate
│
├── combate/ # Lógica de combate
│ ├── scr_ejecutar_habilidad
│ ├── scr_usar_habilidad_indice
│ ├── scr_calcular_dano
│ ├── scr_multiplicador_afinidad
│ ├── scr_actualizar_personaje
│ ├── scr_actualizar_esencia
│ ├── scr_activar_pasiva_afinidad
│ ├── scr_actualizar_pasivas
│ ├── scr_aplicar_estado
│ ├── scr_actualizar_estados
│ ├── scr_cooldown_habilidad
│ └── scr_nombre_habilidad
│
├── inventario/ # Inventario y forja
│ ├── scr_inventario_agregar_material
│ ├── scr_inventario_get_material
│ ├── scr_inventario_marcar_arma_obtenida
│ ├── scr_inventario_puede_fabricar_arma
│ └── scr_fabricar_arma
│
├── objetos/ # Sistema de objetos y rúnicos
│ ├── scr_datos_objetos
│ ├── scr_inventario_objetos
│ └── scr_usar_objeto_combate
│
├── tienda/ # Tienda de desbloqueo
│ ├── scr_datos_tienda
│ └── scr_lista_armas_disponibles
│
├── torre/ # Modo Torre
│ └── scr_datos_torre
│
├── mecanicas/ # Mecánicas especiales y fórmulas
│ ├── scr_mecanicas_combate
│ ├── scr_ejecutar_super
│ ├── scr_formula_dano
│ ├── scr_formula_beneficio
│ ├── scr_config_juego
│ └── scr_get_stat
│
├── feedback/ # Feedback visual
│ ├── scr_feedback_combate
│ └── scr_notificacion_combate
│
├── datos_extra/ # Datos adicionales
│ ├── scr_datos_personalidades
│ └── scr_datos_materiales
│
└── utilidades/
└── scr_ds_map_keys_array # Helper para iterar ds_map

---

## 3. Flujo de Navegación

rm_boot
└──→ rm_menu
├──→ rm_select (personaje + arma)
│ └──→ rm_enemy_select (enemigo)
│ └──→ rm_combate (1v1)
│ └──→ rm_menu (al terminar)
├──→ rm_forja
│ └──→ rm_menu (ESC para volver)
├──→ rm_tienda
│ └──→ rm_menu (ESC para volver)
└──→ rm_torre
├──→ rm_combate (piso actual)
├──→ tienda de piso (cada N pisos)
└──→ rm_menu (al terminar/morir)

### 3.1. Pantalla de Selección

- **Navegación ↑↓** entre personajes.
- **ENTER** abre popup de armas desbloqueadas del personaje.
- **Navegación ←→** entre armas en el popup.
- **ENTER** confirma y avanza al selector de enemigos.
- **ESC** vuelve al menú.

Estados internos:

```gml
enum SelState {
    PERSONAJE,
    ARMA_POPUP
}
```

---

## 4. Sistema de Perfiles

### 4.1. Estructura del Perfil

Cada personaje tiene un perfil persistente gestionado por `obj_control_juego`:

```gml
{
    nombre,
    clase,
    afinidad,
    armas_obtenidas : ds_map,  // "NombreArma" : true
    arma_equipada
}
```

### 4.2. Gestión

- `obj_control_juego` mantiene `perfiles_personaje` (ds_map) e `inventario_materiales` (ds_map).
- Los materiales son **globales** (compartidos entre personajes).
- Las armas son **por personaje** (cada perfil tiene su propio ds_map).
- Cleanup profesional destruye todos los ds_maps en el evento CleanUp.

---

## 5. Sistemas Implementados

### 5.1. Combate

- Combate en tiempo real 1v1.
- Habilidades por arma según rareza (R1=1, R2=2, R3=3).
- Control por teclas: ESPACIO, Q, W.
- Cooldowns independientes por habilidad.
- Daño elemental con multiplicadores.
- Estados alterados (DoT, buffs de defensa).
- Pasivas de afinidad activadas por eventos.
- IA básica para enemigos.
- Sistema de Esencia funcional.

### 5.2. Forja

- UI lista las armas forjables.
- Muestra receta con materiales y cantidades requeridas.
- Verifica inventario antes de permitir forja.
- ENTER = forjar, ESC = volver.
- Al forjar: gasta materiales → añade arma al perfil → la equipa.

### 5.3. Inventario

- Materiales se obtienen al vencer enemigos.
- Gestión a través de scripts `scr_inventario_*`.
- Verificación y gasto automático durante la forja.

### 5.5. Objetos Consumibles

- 5 objetos consumibles comprables en tienda.
- Se equipan antes del combate (máx. 3 por combate).
- Se usan con teclas 1, 2, 3 durante el combate.
- Tipos: Pociones (HP), Elixir de Esencia, Tónicos (buffs temporales).
- Se consumen al usarse.

### 5.6. Rúnicos

- 6 runas especiales con ventaja/desventaja.
- Se equipan antes del combate (máx. 1 por combate).
- Se aplican automáticamente al inicio del combate.
- Se consumen al terminar el combate (gane o pierda).

### 5.7. Tienda

- 4 categorías: Personajes, Enemigos, Objetos, Rúnicos.
- Compra con oro ganado en combates.
- UI gestionada por `obj_ui_tienda`.
- Datos definidos en `scr_datos_tienda`.

### 5.8. Modo Torre

- Modalidad roguelite con pisos consecutivos.
- 3 alas (Oeste/Este/Central) con enemigos temáticos.
- 3 dificultades (Normal 10 pisos / Difícil 14 / Extremo 18).
- HP persistente entre pisos.
- Tienda de piso con catálogo progresivo.
- Jefes finales en dificultad Extremo.
- Controlado por `obj_control_torre`.

### 5.9. Súper-Habilidades

- 24 variantes (6 clases × 4 personalidades).
- Se activan con TAB cuando esencia ≥ 50%.
- Potencia escala por tier: 50% → ×0.50, 75% → ×0.75, 100% → ×1.00.
- Tras uso, esencia vuelve a 0.
- Implementadas en `scr_ejecutar_super`.

### 5.10. Mecánicas Especiales de Combate

- 6 mecánicas para enemigos élite y jefes.
- Ventana invertida, penalización por repetición, reflejo diferido, escalado por vida, afinidad reactiva, absorción de esencia.
- Implementadas en `scr_mecanicas_combate`.

### 5.4. Estados Alterados

Estados implementados (8 tipos):

- **quemadura_fuego** — DoT de fuego (tick cada 1s).
- **muro_tierra** — Buff de defensa (+4 defensa temporal).
- **aceleracion_rayo** — Buff de velocidad (+3 velocidad temporal).
- **veneno** — DoT de planta (tick cada 1s, más suave que quemadura).
- **regeneracion** — HoT: curación periódica (tick cada 1s).
- **ralentizacion** — Debuff de velocidad (-3 velocidad temporal).
- **vulnerabilidad** — Debuff de defensa (-4 defensa temporal).
- **supresion_arcana** — Debuff de poder (-3 poder_elemental temporal).

Tipos soportados: `dot`, `hot`, `buff_defensa`, `buff_defensa_magica`, `buff_velocidad`, `debuff_velocidad`, `debuff_defensa`, `debuff_poder`.

Estructura de un estado activo:

```gml
{
    id,
    tipo,              // "dot", "hot", "buff_defensa", "debuff_velocidad", etc.
    tiempo_rest,
    tick_interval,
    tick_timer,
    potencia,
    defensa_bonus,
    defensa_magica_bonus,
    velocidad_bonus,
    velocidad_penalty,
    defensa_penalty,
    poder_penalty,
    activo
}
```

---

## 6. Convenciones y Buenas Prácticas

### 6.1. Nomenclatura

| Tipo             | Prefijo      | Ejemplo               |
| ---------------- | ------------ | --------------------- |
| Room             | `rm_`        | `rm_combate`          |
| Objeto           | `obj_`       | `obj_control_combate` |
| Script de datos  | `scr_datos_` | `scr_datos_armas`     |
| Script de lógica | `scr_`       | `scr_calcular_dano`   |
| Sprite           | `spr_`       | `spr_golpe`           |

### 6.2. Principios Arquitectónicos

1. **Separación lógica/visual**: Los actores solo manejan sprites. La lógica vive en structs.
2. **Datos como structs**: Los scripts `scr_datos_*` devuelven structs limpios y escalables.
3. **Persistencia centralizada**: `obj_control_juego` es el único persistente. Todo pasa por él.
4. **CleanUp obligatorio**: Destruir todo ds_map y ds_list en el evento CleanUp.
5. **Recetas integradas**: Las recetas de forja están dentro de la definición de cada arma, no en un script separado.

### 6.3. Control de Versiones

- Mantener documentación actualizada con cada hito completado.
- Cada sistema nuevo debe probarse aislado antes de integrarse.
- Seguir el plan de escalado del GDD para priorizar desarrollo.

---

## 7. Roadmap de Desarrollo

### Fase 1 — MVP (COMPLETADA)

- [x] Arquitectura base (rooms, objetos, scripts).
- [x] Sistema de datos completo.
- [x] Combate funcional con habilidades y cooldowns.
- [x] Forja con materiales.
- [x] Perfiles de personaje.
- [x] Pantalla de selección.
- [x] Afinidades con pasivas reales.
- [x] Estados alterados básicos.
- [x] Armas R1 y R2.
- [x] IA básica.

### Fase 2 — Contenido Base

- [x] Completar los 8 enemigos comunes (uno por afinidad).
- [x] 8 enemigos élite con habilidad secundaria + estados alterados.
- [ ] Arma R3 con 3 habilidades (estructura lista, balance pendiente).
- [x] 8 estados alterados implementados y asociados a habilidades.
- [x] IA multi-habilidad con priorización (secundaria > fija > básica).
- [x] Overhaul de stats: defensa_magica, tipo_dano, CDR, crit dinámico, esencia dinámica.
- [ ] Animaciones básicas (impacto, casteo).
- [x] 5 objetos consumibles implementados.
- [x] 6 rúnicos implementados.
- [x] Sistema de tienda con 4 categorías.
- [x] 8 personalidades (Agresivo, Metódico, Temerario, Resuelto).
- [x] 8 personajes jugables (Kael, Lys, Torvan, Nerya, Saren, Maelis, Thalys, Brenn).

### Fase 3 — Jefes y Profundidad

- [x] 6 jefes definidos con mecánicas temáticas (Titán, Coloso, Sentinela, Bestia, Oráculo, Devorador).
- [x] 6 mecánicas especiales de combate para élites/jefes.
- [ ] Armas legendarias R3 para cada afinidad.
- [x] Sistema de ESENCIA avanzado con las 24 súper-habilidades.
- [ ] Mejorar IA de enemigos (patrones, escalado).

### Fase 4 — Modos de Juego

- [x] Modo Torre implementado (3 alas, 3 dificultades, tienda de piso).
- [ ] Camino del Héroe (modo narrativo).
- [ ] Sistema de historia con fragmentos de memoria.
- [ ] El Devorador (jefe final — datos definidos, implementación pendiente).
- [ ] El Primer Conductor (jefe secreto — datos definidos, implementación pendiente).

### Fase 5 — Pulido

- [ ] UI visual definitiva (iconos, barras estilizadas).
- [ ] VFX para habilidades.
- [ ] Balance de combate.
- [ ] Builds profundas y sinergias.
