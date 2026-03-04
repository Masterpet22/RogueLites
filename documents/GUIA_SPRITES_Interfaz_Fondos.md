# ARCADIUM — Guía Visual de Sprites de Interfaz y Fondos

> Referencia completa para la creación y mantenimiento de sprites de UI, fondos, iconos y efectos visuales.
> Excluye personajes jugables, enemigos y jefes (ver `GUIA_SPRITES_Personajes_Enemigos.md`).
> Fecha: Marzo 2026

---

## Índice

1. [Dirección Artística de Interfaz](#1-dirección-artística-de-interfaz)
2. [Fondos de Room (`spr_bg_*`)](#2-fondos-de-room-spr_bg_)
3. [Barras de UI (`spr_barra_*`)](#3-barras-de-ui-spr_barra_)
4. [Paneles, Slots, Marcos y Botones](#4-paneles-slots-marcos-y-botones)
5. [Iconos de Afinidad (`spr_ico_afinidad_*`)](#5-iconos-de-afinidad-spr_ico_afinidad_)
6. [Iconos de Estados Alterados](#6-iconos-de-estados-alterados)
7. [Iconos de Objetos Consumibles](#7-iconos-de-objetos-consumibles)
8. [Iconos de Runas](#8-iconos-de-runas)
9. [Iconos de Habilidades y Súper](#9-iconos-de-habilidades-y-súper)
10. [Efectos Visuales (`spr_fx_*`)](#10-efectos-visuales-spr_fx_)
11. [Rooms y Composición Visual](#11-rooms-y-composición-visual)
12. [Tabla Resumen de Dimensiones](#12-tabla-resumen-de-dimensiones)
13. [Assets Pendientes](#13-assets-pendientes)

---

## 1. Dirección Artística de Interfaz

### Filosofía Visual

La UI de ARCADIUM sigue los mismos principios que el arte de personajes: **claridad sobre complejidad**. Todo elemento de interfaz debe ser legible al instante, con colores elementales vibrantes sobre fondos apagados.

### Reglas Generales

- **Fondos siempre 20–30% más apagados** que los personajes y elementos de UI en primer plano.
- **Colores de afinidad** se usan consistentemente en todos los elementos (barras, iconos, marcos, glow).
- **Estilo:** Stylized Clean Fantasy 2D. Líneas limpias, formas geométricas claras, sin ornamentación excesiva.
- **Paleta de UI base:** Fondos oscuros, texto blanco/cyan para resaltado, marcos dorados para elementos especiales.
- **Resolución GUI:** 1280×720 (todos los elementos se posicionan en este espacio).

### Paleta de Afinidades (Referencia Rápida)

| Afinidad | Dominante           | Secundario            | Energía (Glow)         |
| -------- | ------------------- | --------------------- | ---------------------- |
| Fuego    | `#8B1A1A` Rojo osc  | `#CC5500` Naranja     | `#FFD700` Amarillo     |
| Agua     | `#003366` Azul prof | `#B0E0E6` Azul hielo  | `#F0F8FF` Blanco esc   |
| Planta   | `#228B22` Verde bos | `#32CD32` Verde lima  | `#ADFF2F` Amarillo esp |
| Rayo     | `#0080FF` Azul eléc | `#7B2D8E` Violeta     | `#FFFFFF` Blanco brill |
| Tierra   | `#8B7355` Marrón    | `#00A86B` Verde jade  | `#C2B280` Arena dorada |
| Sombra   | `#0D0D0D` Negro     | `#301934` Violeta osc | `#CC99FF` Púrpura pál  |
| Luz      | `#FFFFF0` Blanco    | `#FFD700` Dorado      | `#FFBF00` Ámbar        |
| Arcano   | `#4B0082` Púrpura   | `#00FFFF` Cian        | `#FF00FF` Magenta      |

---

## 2. Fondos de Room (`spr_bg_*`)

> Todos los fondos son **1920×1080 px**, 1 frame, origin en Top-Left (0, 0). Se dibujan con `draw_sprite_stretched` para cubrir la GUI completa (1280×720).

### 2.1. Fondo de Menú Principal

| Propiedad       | Valor                                                                                                                                                                                                                                                                                                      |
| --------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Nombre**      | `spr_bg_menu`                                                                                                                                                                                                                                                                                              |
| **Tamaño**      | 1920×1080                                                                                                                                                                                                                                                                                                  |
| **Frames**      | 1 (estático)                                                                                                                                                                                                                                                                                               |
| **Carpeta**     | `sprites/fondos`                                                                                                                                                                                                                                                                                           |
| **Room**        | `rm_menu`                                                                                                                                                                                                                                                                                                  |
| **Objeto**      | `obj_menu` (Draw GUI)                                                                                                                                                                                                                                                                                      |
| **Descripción** | Fondo oscuro y atmosférico del menú principal. Debe ser lo suficientemente neutro para no competir con el logo `spr_logo_arcadium` que se superpone centrado en la parte superior, ni con las opciones del menú (botones centrados). Tonalidad general oscura con elementos sutiles del mundo de Arcadium. |

### 2.2. Fondo de Selección de Personaje

| Propiedad       | Valor                                                                                                                                                                                                                                                                                                              |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Nombre**      | `spr_bg_select`                                                                                                                                                                                                                                                                                                    |
| **Tamaño**      | 1920×1080                                                                                                                                                                                                                                                                                                          |
| **Frames**      | 1 (estático)                                                                                                                                                                                                                                                                                                       |
| **Carpeta**     | `sprites/fondos`                                                                                                                                                                                                                                                                                                   |
| **Room**        | `rm_select`                                                                                                                                                                                                                                                                                                        |
| **Objeto**      | `obj_select` (Draw GUI)                                                                                                                                                                                                                                                                                            |
| **Descripción** | Fondo para la pantalla de selección de personaje. Muestra una vista general de Arcadium o un hall de los Conductores. Debe dejar espacio visual limpio para la cuadrícula de 8 personajes (retratos con marco + nombre) y el panel de información lateral derecho con stats y detalles del personaje seleccionado. |

### 2.3. Fondo de Selección de Enemigo

| Propiedad       | Valor                                                                                                                                                                                                                               |
| --------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Nombre**      | `spr_bg_enemy_select`                                                                                                                                                                                                               |
| **Tamaño**      | 1920×1080                                                                                                                                                                                                                           |
| **Frames**      | 1 (estático)                                                                                                                                                                                                                        |
| **Carpeta**     | `sprites/fondos`                                                                                                                                                                                                                    |
| **Room**        | `rm_enemy_select`                                                                                                                                                                                                                   |
| **Objeto**      | `obj_enemy_select` (Draw GUI)                                                                                                                                                                                                       |
| **Descripción** | Fondo para la selección de enemigo/arena. Tono amenazante, más oscuro que la selección de personaje. Debe permitir la visualización de la lista de enemigos disponibles (hasta 20) con sus retratos, nombres y nivel de dificultad. |

### 2.4. Fondos de Combate (5 Arenas)

Los fondos de combate representan escenarios distintos de los Dominios Ruinosos de Arcadium. Se seleccionan dinámicamente según `combate_arena_idx`.

#### Arena 1 — `spr_bg_combate_1`

| Propiedad       | Valor                                                                                                                                                                                                                                                                       |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Tamaño**      | 1920×1080                                                                                                                                                                                                                                                                   |
| **Carpeta**     | `sprites/fondos/fondos_combate`                                                                                                                                                                                                                                             |
| **Room**        | `rm_combate`                                                                                                                                                                                                                                                                |
| **Descripción** | Arena de combate por defecto. Escenario ruinoso genérico que funciona como arena neutral. Colores apagados, elementos en segundo plano (ruinas, columnas rotas, cielo tormentoso). El personaje (izquierda) y enemigo (derecha) deben destacar claramente sobre este fondo. |

#### Arena 2 — `spr_bg_combate_2`

| Propiedad       | Valor                                                                                                                                                                                                                                  |
| --------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Tamaño**      | 1920×1080                                                                                                                                                                                                                              |
| **Carpeta**     | `sprites/fondos/fondos_combate`                                                                                                                                                                                                        |
| **Descripción** | Segunda arena de combate. Variación del escenario con diferente dominio elemental. Mantener la zona central despejada para los combatientes. Suelo definido, fondo lejano con elemento icónico del dominio, niebla/partículas sutiles. |

#### Arena 3 — `spr_bg_combate_3`

| Propiedad       | Valor                                                                                                                                                                                               |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Tamaño**      | 1920×1080                                                                                                                                                                                           |
| **Carpeta**     | `sprites/fondos/fondos_combate`                                                                                                                                                                     |
| **Descripción** | Tercera arena de combate. Otro dominio elemental diferente. Mismas reglas de composición: zona central despejada, elemento icónico en segundo plano, tonos 20–30% más apagados que el primer plano. |

#### Arena 4 — `spr_bg_combate_4`

| Propiedad       | Valor                                                                                                                                                                              |
| --------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Tamaño**      | 1920×1080                                                                                                                                                                          |
| **Carpeta**     | `sprites/fondos/fondos_combate`                                                                                                                                                    |
| **Descripción** | Cuarta arena de combate. Dominio elemental distinto. Incluir un gran elemento icónico, niebla ligera para separar capas, partículas suaves coherentes con la afinidad del dominio. |

#### Arena 5 — `spr_bg_combate_5`

| Propiedad       | Valor                                                                                                                                                              |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Tamaño**      | 1920×1080                                                                                                                                                          |
| **Carpeta**     | `sprites/fondos/fondos_combate`                                                                                                                                    |
| **Descripción** | Quinta arena de combate. Posible arena final o especial (jefes). Más dramática y oscura, con elementos de la narrativa del Devorador o las Corrientes fracturadas. |

**Guía de Composición de Fondos de Combate:**

| Dominio | Elemento Icónico               | Partículas             | Tono General      |
| ------- | ------------------------------ | ---------------------- | ----------------- |
| Fuego   | Forja volcánica en ruinas      | Brasas flotantes       | Rojo oscuro/negro |
| Agua    | Canal congelado roto           | Cristales de hielo     | Azul profundo     |
| Planta  | Selva corrompida               | Esporas, hojas         | Verde oscuro      |
| Rayo    | Ruinas suspendidas en tormenta | Chispas eléctricas     | Azul/violeta      |
| Tierra  | Templo derrumbado              | Polvo, arena           | Marrón/gris       |
| Sombra  | Ciudad subterránea devorada    | Humo oscuro ascendente | Negro/violeta     |
| Luz     | Catedral fracturada            | Motas de luz dorada    | Blanco/dorado     |
| Arcano  | Observatorio fracturado        | Runas flotantes        | Púrpura/cian      |

> **Regla clave:** Si sobrecargas el fondo, rompes la claridad del combate. Menos es más.

### 2.5. Fondo de Forja

| Propiedad       | Valor                                                                                                                                                                                                                                                                                                                   |
| --------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Nombre**      | `spr_bg_forja`                                                                                                                                                                                                                                                                                                          |
| **Tamaño**      | 1920×1080                                                                                                                                                                                                                                                                                                               |
| **Frames**      | 1 (estático)                                                                                                                                                                                                                                                                                                            |
| **Carpeta**     | `sprites/fondos`                                                                                                                                                                                                                                                                                                        |
| **Room**        | `rm_forja`                                                                                                                                                                                                                                                                                                              |
| **Objeto**      | `obj_ui_forja` (Draw GUI)                                                                                                                                                                                                                                                                                               |
| **Descripción** | Interior de una forja de Arcadium. Ambiente cálido con yunque, herramientas, fuego de forja. Sobre este fondo se superpone la interfaz de crafting: lista de armas disponibles a la izquierda, panel de detalle a la derecha con materiales necesarios y botón de fabricar. Debe transmitir oficio artesanal y calidez. |

### 2.6. Fondo de Tienda

| Propiedad       | Valor                                                                                                                                                                                                                                                                                                          |
| --------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Nombre**      | `spr_bg_tienda`                                                                                                                                                                                                                                                                                                |
| **Tamaño**      | 1920×1080                                                                                                                                                                                                                                                                                                      |
| **Frames**      | 1 (estático)                                                                                                                                                                                                                                                                                                   |
| **Carpeta**     | `sprites/fondos`                                                                                                                                                                                                                                                                                               |
| **Room**        | `rm_tienda`                                                                                                                                                                                                                                                                                                    |
| **Objeto**      | `obj_ui_tienda` (Draw GUI)                                                                                                                                                                                                                                                                                     |
| **Descripción** | Interior de una tienda/mercado de Arcadium. Estanterías, objetos, ambiente comercial. Sobre este fondo se muestra la UI de compra con tabs (Personajes, Enemigos, Objetos, Runas), lista de items, panel de detalle y oro disponible. Tono más luminoso que el combate pero coherente con la estética general. |

### 2.7. Fondo de Torre / Camino

| Propiedad       | Valor                                                                                                                                                                                                                                                                                                                                               |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Nombre**      | `spr_bg_torre`                                                                                                                                                                                                                                                                                                                                      |
| **Tamaño**      | 1920×1080                                                                                                                                                                                                                                                                                                                                           |
| **Frames**      | 1 (estático)                                                                                                                                                                                                                                                                                                                                        |
| **Carpeta**     | `sprites/fondos`                                                                                                                                                                                                                                                                                                                                    |
| **Room**        | `rm_torre` y `rm_camino` (reutilizado temporalmente)                                                                                                                                                                                                                                                                                                |
| **Objeto**      | `obj_control_torre` / `obj_control_camino` (Draw GUI)                                                                                                                                                                                                                                                                                               |
| **Descripción** | Vista de una torre o estructura vertical de Arcadium. Representa la progresión por pisos/niveles del Modo Torre. Se usa también temporalmente en el Camino del Héroe (roguelite) hasta que se cree `spr_bg_camino`. Debe transmitir verticalidad, desafío y progresión ascendente. La UI superpone opciones de ala/dificultad y selección de pisos. |

---

## 3. Barras de UI (`spr_barra_*`)

> Todas las barras son **512×48 px**, 1 frame, origin en Top-Left (0, 0). Se escalan en código al tamaño necesario.

### 3.1. Barra de Vida — Fondo

| Propiedad        | Valor                                                                                                                                                                                                                                                                                                      |
| ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Nombre**       | `spr_barra_vida_bg`                                                                                                                                                                                                                                                                                        |
| **Tamaño asset** | 512×48                                                                                                                                                                                                                                                                                                     |
| **Tamaño en UI** | 280×16 (estirada con `draw_sprite_stretched`)                                                                                                                                                                                                                                                              |
| **Carpeta**      | `sprites/ui`                                                                                                                                                                                                                                                                                               |
| **Objeto**       | `obj_control_ui_combate` (Draw GUI)                                                                                                                                                                                                                                                                        |
| **Descripción**  | Fondo/marco de la barra de vida. Rectángulo con borde definido, interior oscuro (gris oscuro o negro). Se dibuja tanto para el jugador (parte superior izquierda de la pantalla de combate) como para el enemigo (parte superior derecha, espejado). Sirve como contenedor visual para el relleno de vida. |

### 3.2. Barra de Vida — Relleno

| Propiedad        | Valor                                                                                                                                                                                                                                                                                                                                                  |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Nombre**       | `spr_barra_vida`                                                                                                                                                                                                                                                                                                                                       |
| **Tamaño asset** | 512×48                                                                                                                                                                                                                                                                                                                                                 |
| **Tamaño en UI** | Se estira proporcional a `vida_actual / vida_max`                                                                                                                                                                                                                                                                                                      |
| **Carpeta**      | `sprites/ui`                                                                                                                                                                                                                                                                                                                                           |
| **Objeto**       | `obj_control_ui_combate` (Draw GUI)                                                                                                                                                                                                                                                                                                                    |
| **Descripción**  | Relleno de color de la barra de vida. Se estira horizontalmente según el porcentaje de HP restante. Para el jugador ocupa desde la izquierda; para el enemigo se dibuja de derecha a izquierda. El color se tinta programáticamente: verde a vida alta, transición a amarillo y luego rojo a vida baja. Design limpio, gradiente suave o color sólido. |

### 3.3. Barra de Esencia — Fondo

| Propiedad        | Valor                                                                                                                                                                                                                                                                                                                                             |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Nombre**       | `spr_barra_esencia_bg`                                                                                                                                                                                                                                                                                                                            |
| **Tamaño asset** | 512×48                                                                                                                                                                                                                                                                                                                                            |
| **Carpeta**      | `sprites/ui`                                                                                                                                                                                                                                                                                                                                      |
| **Estado**       | Asset existe pero **se dibuja proceduralmente** en `scr_esencia_barra`                                                                                                                                                                                                                                                                            |
| **Descripción**  | Fondo de la barra de Esencia. Similar en forma a la barra de vida pero potencialmente con un diseño más ornamentado o místico, ya que la Esencia es la mecánica central del juego. El código actual dibuja la barra de esencia con efectos avanzados (glow, pulsos, partículas) de forma procedural, pero el asset puede usarse como base visual. |

### 3.4. Barra de Esencia — Relleno

| Propiedad        | Valor                                                     |
| ---------------- | --------------------------------------------------------- |
| **Nombre**       | `spr_barra_esencia`                                       |
| **Tamaño asset** | 512×48                                                    |
| **Carpeta**      | `sprites/ui`                                              |
| **Estado**       | Asset existe pero **se dibuja proceduralmente**           |
| **Descripción**  | Relleno de la barra de Esencia. Sistema visual por tiers: |

| Tier   | Rango  | Efecto Visual                                                                                   |
| ------ | ------ | ----------------------------------------------------------------------------------------------- |
| Base   | 0–49%  | Sin efecto especial, relleno simple                                                             |
| Tier 1 | 50–74% | Barra pulsa sutilmente, leve glow elemental sobre personaje                                     |
| Tier 2 | 75–99% | Pulso más rápido, glow con color secundario→energía                                             |
| Tier 3 | 100%   | Aura elemental completa (additive blending), barra brillando, texto "ESENCIA MAX — [TAB] SÚPER" |

> Se incluyen marcadores visuales (diamantes) en 50% y 75% de la barra.

### 3.5. Barra de Cooldown

| Propiedad        | Valor                                                                                                                                                                                                                                                                                                       |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Nombre**       | `spr_barra_cooldown`                                                                                                                                                                                                                                                                                        |
| **Tamaño asset** | 512×48                                                                                                                                                                                                                                                                                                      |
| **Carpeta**      | `sprites/ui`                                                                                                                                                                                                                                                                                                |
| **Estado**       | Asset existe pero **el cooldown se dibuja programáticamente**                                                                                                                                                                                                                                               |
| **Descripción**  | Barra de cooldown genérica. En la implementación actual, el cooldown de las habilidades se representa como un overlay negro semitransparente (`draw_set_alpha(0.5)`) sobre los slots de habilidad, no como una barra independiente. El asset puede usarse para un rediseño futuro del sistema de cooldowns. |

---

## 4. Paneles, Slots, Marcos y Botones

### 4.1. Panel de Información

| Propiedad       | Valor                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Nombre**      | `spr_panel_info`                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| **Tamaño**      | 640×480                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| **Origin**      | Top-Left (0, 0)                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| **Carpeta**     | `sprites/ui`                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| **Uso**         | Menú de pausa en combate (300×180), panel de detalle en tienda (42% ancho pantalla)                                                                                                                                                                                                                                                                                                                                                                     |
| **Descripción** | Panel rectangular genérico con bordes decorativos fantasía. Sirve como fondo para cualquier ventana modal o panel de información superpuesto. Se escala según contexto. En el menú de pausa se centra en pantalla con opciones (Reanudar, Reiniciar, Rendirse, Salir). En la tienda muestra nombre, descripción, precio y botón de compra del item seleccionado. Estilo: bordes limpios, fondo semi-opaco oscuro, esquinas con motivo decorativo sutil. |

### 4.2. Slot de Objeto

| Propiedad       | Valor                                                                                                                                                                                                                                                                                                                                                                |
| --------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Nombre**      | `spr_slot_objeto`                                                                                                                                                                                                                                                                                                                                                    |
| **Tamaño**      | 192×128                                                                                                                                                                                                                                                                                                                                                              |
| **Origin**      | Top-Left (0, 0)                                                                                                                                                                                                                                                                                                                                                      |
| **Carpeta**     | `sprites/ui`                                                                                                                                                                                                                                                                                                                                                         |
| **Uso**         | 3 slots de consumibles en la columna izquierda del combate (teclas 1, 2, 3)                                                                                                                                                                                                                                                                                          |
| **Descripción** | Marco/contenedor para un objeto consumible. Rectangular con bordes definidos. Dentro se dibuja el icono del objeto (30×30 px) centrado en un espacio de 50px. Cuando el objeto se ha usado, se aplica un overlay negro semitransparente sobre el slot completo para indicar que está consumido. Cada slot muestra la tecla de acceso rápido (1, 2, 3) en la esquina. |

### 4.3. Slot de Runa

| Propiedad       | Valor                                                                                                                                                                                                                                                                       |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Nombre**      | `spr_slot_runa`                                                                                                                                                                                                                                                             |
| **Tamaño**      | 192×128                                                                                                                                                                                                                                                                     |
| **Origin**      | Top-Left (0, 0)                                                                                                                                                                                                                                                             |
| **Carpeta**     | `sprites/ui`                                                                                                                                                                                                                                                                |
| **Uso**         | Slot de runa equipada en la parte superior de la columna de items en combate                                                                                                                                                                                                |
| **Descripción** | Marco/contenedor para la runa equipada. Similar al slot de objeto pero con un diseño ligeramente diferente que denote su naturaleza especial (quizá bordes rúnicos o un brillo sutil). Máximo 1 runa por combate. Muestra el icono de la runa equipada (30×30 px centrado). |

### 4.4. Marco de Retrato

| Propiedad       | Valor                                                                                                                                                                                                                        |
| --------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Nombre**      | `spr_marco_retrato`                                                                                                                                                                                                          |
| **Tamaño**      | 280×280                                                                                                                                                                                                                      |
| **Origin**      | Top-Left (0, 0)                                                                                                                                                                                                              |
| **Carpeta**     | `sprites/ui`                                                                                                                                                                                                                 |
| **Uso**         | Combate (retratos de jugador y enemigo), selección de personaje                                                                                                                                                              |
| **Descripción** | Marco decorativo cuadrado para encuadrar los retratos (`spr_rostro_*`) de personajes y enemigos. El rostro se dibuja a 84px dentro del marco con 8px de borde visible. El borde se colorea programáticamente según contexto: |

| Contexto               | Color del Borde                               |
| ---------------------- | --------------------------------------------- |
| Jugador en combate     | Azul                                          |
| Enemigo en combate     | Rojo con aura                                 |
| Jefe en combate        | Color de afinidad (doble marco con 2 colores) |
| Selección de personaje | Cyan si seleccionado, neutro si no            |

### 4.5. Botón de Menú

| Propiedad        | Valor                                                                                                                                                                                                                |
| ---------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Nombre**       | `spr_boton_menu`                                                                                                                                                                                                     |
| **Tamaño**       | 384×96                                                                                                                                                                                                               |
| **Origin**       | Top-Left (0, 0)                                                                                                                                                                                                      |
| **Tamaño en UI** | 192×36 (estirado, centrado horizontalmente)                                                                                                                                                                          |
| **Carpeta**      | `sprites/ui`                                                                                                                                                                                                         |
| **Uso**          | Cada opción del menú principal                                                                                                                                                                                       |
| **Descripción**  | Botón rectangular para las opciones del menú principal (Jugar, Selección, Tienda, Forja, Torre, Camino, Opciones, Salir). Diseño limpio con bordes definidos, apariencia de piedra/metal fantasía. Estados visuales: |

| Estado       | Apariencia                                          |
| ------------ | --------------------------------------------------- |
| Normal       | Texto negro sobre botón neutro                      |
| Seleccionado | Texto cyan, posible glow o cambio de tono del botón |

### 4.6. Cursor de Selección

| Propiedad        | Valor                                                                                                                                                                                                                                                                                                                                                          |
| ---------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Nombre**       | `spr_cursor_select`                                                                                                                                                                                                                                                                                                                                            |
| **Tamaño**       | 64×64                                                                                                                                                                                                                                                                                                                                                          |
| **Origin**       | Top-Left (0, 0)                                                                                                                                                                                                                                                                                                                                                |
| **Tamaño en UI** | 16–19 px (escalado según pantalla)                                                                                                                                                                                                                                                                                                                             |
| **Carpeta**      | `sprites/ui`                                                                                                                                                                                                                                                                                                                                                   |
| **Uso**          | Forja, selección de personaje, selección de enemigo                                                                                                                                                                                                                                                                                                            |
| **Descripción**  | Indicador/flecha de selección que aparece junto al item actualmente seleccionado en listas navegables. Color amarillo para máxima visibilidad. Diseño simple: flecha apuntando a la derecha o triángulo indicador. Se escala a 16–19px dependiendo del contexto de la pantalla. Debe ser inmediatamente reconocible como "esto es lo que tienes seleccionado". |

### 4.7. Logo de Arcadium

| Propiedad        | Valor                                                                                                                                                                                                                                                                                                                                                     |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Nombre**       | `spr_logo_arcadium`                                                                                                                                                                                                                                                                                                                                       |
| **Tamaño**       | 1024×512                                                                                                                                                                                                                                                                                                                                                  |
| **Origin**       | Middle-Center (512, 256) — **Único sprite UI con origin centrado**                                                                                                                                                                                                                                                                                        |
| **Tamaño en UI** | Se escala a 410px de ancho, centrado horizontalmente en la parte superior del menú                                                                                                                                                                                                                                                                        |
| **Carpeta**      | `sprites/ui`                                                                                                                                                                                                                                                                                                                                              |
| **Uso**          | Menú principal (parte superior)                                                                                                                                                                                                                                                                                                                           |
| **Descripción**  | Logo/título del juego "ARCADIUM". Lettering estilizado fantasía con elementos que evoquen las Corrientes elementales y el mundo del juego. Debe funcionar sobre el fondo oscuro del menú. Formato panorámico (2:1), con transparencia alrededor del texto/logo. Al tener origin centrado, se posiciona fácilmente con coordenadas del centro de pantalla. |

---

## 5. Iconos de Afinidad (`spr_ico_afinidad_*`)

> Todos los iconos de afinidad son **128×128 px**, 1 frame, origin en Top-Left (0, 0). Se dibujan a **16×16 px** junto a textos de afinidad en el HUD de combate y en la pantalla de selección.

| Sprite                    | Afinidad | Paleta Dominante                              | Descripción del Icono                                                                                         |
| ------------------------- | -------- | --------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| `spr_ico_afinidad_fuego`  | Fuego    | Rojo oscuro `#8B1A1A`, naranja quemado        | Llama estilizada. Forma triangular ascendente con tonos rojos-naranjas y un núcleo brillante amarillo-dorado. |
| `spr_ico_afinidad_agua`   | Agua     | Azul profundo `#003366`                       | Gota de agua o forma fluida ondulante. Tonos azules profundos con reflejos blancos de hielo/escarcha.         |
| `spr_ico_afinidad_planta` | Planta   | Verde bosque `#228B22`                        | Hoja, brote o espiral vegetal. Verdes vivos con detalles en verde lima y amarillo de esporas.                 |
| `spr_ico_afinidad_rayo`   | Rayo     | Azul eléctrico `#0080FF`, amarillo `#FFD700`  | Rayo/relámpago zigzagueante. Azul eléctrico con destellos blancos brillantes e interior violeta.              |
| `spr_ico_afinidad_tierra` | Tierra   | Terracota `#CC7755`, marrón `#8B7355`         | Roca, cristal de jade o montaña. Marrones y verdes jade con detalles en arena dorada.                         |
| `spr_ico_afinidad_sombra` | Sombra   | Violeta oscuro `#4A0066`, negro `#0D0D0D`     | Ojo en sombras, humo oscuro o símbolo etéreo. Negros y violetas con glow púrpura pálido.                      |
| `spr_ico_afinidad_luz`    | Luz      | Blanco envejecido `#E8E8D0`, dorado `#FFD700` | Sol, estrella o halo luminoso. Blancos marfil y dorados con resplandor ámbar cálido.                          |
| `spr_ico_afinidad_arcano` | Arcano   | Violeta profundo `#4B0082`, cian `#00FFFF`    | Runa, glifo o forma geométrica mística. Púrpuras profundos con cian y magenta brillantes.                     |

---

## 6. Iconos de Estados Alterados

> Todos son **128×128 px**, 1 frame, origin en Top-Left. Se dibujan a **28×28 px** debajo del retrato del personaje con marco coloreado según tipo y timer restante.

| Sprite                   | Estado             | Tipo              | Efecto en Juego                                  | Color del Marco |
| ------------------------ | ------------------ | ----------------- | ------------------------------------------------ | --------------- |
| `spr_ico_quemadura`      | `quemadura_fuego`  | DoT (Daño/tiempo) | 3 daño/s por tick. Aplicado por armas de fuego.  | Rojo            |
| `spr_ico_veneno`         | `veneno`           | DoT (Daño/tiempo) | 2 daño/s por tick. Aplicado por armas de planta. | Rojo            |
| `spr_ico_regeneracion`   | `regeneracion`     | HoT (Cura/tiempo) | 3 curación/s por tick. Armas de agua/luz.        | Verde           |
| `spr_ico_muro_tierra`    | `muro_tierra`      | Buff Defensa      | +4 defensa temporal. Armas de tierra.            | Cyan            |
| `spr_ico_aceleracion`    | `aceleracion_rayo` | Buff Velocidad    | +3 velocidad temporal. Armas de rayo.            | Cyan            |
| `spr_ico_ralentizacion`  | `ralentizacion`    | Debuff Velocidad  | −3 velocidad temporal. Armas de agua.            | Naranja         |
| `spr_ico_vulnerabilidad` | `vulnerabilidad`   | Debuff Defensa    | −4 defensa temporal. Armas de sombra.            | Naranja         |
| `spr_ico_supresion`      | `supresion_arcana` | Debuff Poder      | −3 poder elemental temporal. Armas arcanas.      | Naranja         |

**Diseño de los iconos de estado:**

- Cada icono debe representar visualmente el efecto: llama para quemadura, gota tóxica para veneno, corazón/hoja para regeneración, escudo de piedra para muro, rayo para aceleración, cadenas/hielo para ralentización, escudo roto para vulnerabilidad, ojo tachado/candado para supresión.
- Máxima duración de estados: 5 segundos.
- Se muestran hasta 8 iconos simultáneos debajo del retrato.

---

## 7. Iconos de Objetos Consumibles

> Todos son **128×128 px**, 1 frame, origin en Top-Left. Se dibujan a **30×30 px** dentro de los `spr_slot_objeto` en combate.

| Sprite                   | Objeto            | Efecto                               | Precio  | Descripción Visual                                                                                                     |
| ------------------------ | ----------------- | ------------------------------------ | ------- | ---------------------------------------------------------------------------------------------------------------------- |
| `spr_ico_pocion_basica`  | Poción Básica     | Restaura 30 HP                       | 50 oro  | Frasco pequeño con líquido rojo/rosa. Forma simple, cristal transparente, tapón de corcho.                             |
| `spr_ico_pocion_media`   | Poción Media      | Restaura 80 HP                       | 150 oro | Frasco más grande o más ornamentado con líquido rojo intenso. Más detalle que la básica para denotar mayor calidad.    |
| `spr_ico_elixir_esencia` | Elixir de Esencia | Restaura 50% barra de esencia        | 120 oro | Frasco con líquido brillante/etéreo del color de esencia. Diseño más místico que las pociones, quizá con runas o glow. |
| `spr_ico_tonico_ataque`  | Tónico de Ataque  | +5 ataque temporal (dura 1 combate)  | 100 oro | Frasco con líquido rojo-naranja agresivo. Posible icono de espada/puño superpuesto o forma angular.                    |
| `spr_ico_tonico_defensa` | Tónico de Defensa | +5 defensa temporal (dura 1 combate) | 100 oro | Frasco con líquido azul-plateado. Posible icono de escudo superpuesto o forma robusta.                                 |

**Uso en combate:**

- Se acceden con teclas 1, 2, 3.
- Al consumir un objeto, el slot se oscurece con overlay negro (usado).
- Se compran en la tienda antes del combate.

---

## 8. Iconos de Runas

> Todos son **128×128 px**, 1 frame, origin en Top-Left. Se dibujan a **30×30 px** dentro de `spr_slot_runa` en combate.

| Sprite                        | Runa                    | Ventaja                      | Desventaja                | Precio |
| ----------------------------- | ----------------------- | ---------------------------- | ------------------------- | ------ |
| `spr_ico_runa_furia`          | Runa de Furia           | +30% daño infligido          | −20% vida máxima          | 200    |
| `spr_ico_runa_fortaleza`      | Runa de Fortaleza       | +40% vida máxima             | −25% daño infligido       | 200    |
| `spr_ico_runa_celeridad`      | Runa de Celeridad       | +50% velocidad               | −30% defensa              | 180    |
| `spr_ico_runa_ultimo_aliento` | Runa del Último Aliento | Sobrevive golpe letal (1 HP) | Primer ataque hace 0 daño | 300    |
| `spr_ico_runa_vampirica`      | Runa Vampírica          | 15% lifesteal                | −40% generación esencia   | 250    |
| `spr_ico_runa_cristal`        | Runa de Cristal         | +50% daño infligido          | +50% daño recibido        | 250    |

**Diseño de los iconos de runa:**

- Cada runa debe ser una gema/piedra grabada con un símbolo que represente su efecto.
- **Furia:** Gema roja con llamas/espada, agresividad pura.
- **Fortaleza:** Gema azul-acero con escudo/montaña, solidez.
- **Celeridad:** Gema blanca-azul con alas/relámpago, velocidad.
- **Último Aliento:** Gema negra-dorada con calavera/cadena rota, supervivencia desesperada.
- **Vampírica:** Gema rojo-oscuro con colmillo/gota de sangre, absorción.
- **Cristal:** Gema transparente-prismática con fisuras visibles, poder al límite del quiebre.

> Máximo 1 runa equipada por combate. Se consume al terminar la pelea.

---

## 9. Iconos de Habilidades y Súper

> Todos son **192×192 px** (más grandes que los iconos estándar), 1 frame, origin en Top-Left.

| Sprite               | Tecla | Uso                                          | Descripción                                                                                                                                                                                                                                                                                      |
| -------------------- | ----- | -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `spr_ico_hab_clase`  | E     | Habilidad fija de clase (siempre disponible) | Icono genérico de habilidad de clase. Marco naranja en la UI de combate. Representa la habilidad innata del rol (Vanguardia, Filotormenta, etc.). Debe ser un símbolo abstracto del concepto de "clase" o "rol" — podría ser un emblema, un puño estilizado, o un símbolo de escuela de combate. |
| `spr_ico_hab_arma_1` | Q     | 1ª habilidad de arma                         | Icono para la primera habilidad otorgada por el arma equipada. Diseño que evoque un ataque o efecto ofensivo básico. Esta habilidad está siempre disponible con cualquier rango de arma.                                                                                                         |
| `spr_ico_hab_arma_2` | W     | 2ª habilidad de arma (requiere Rango 2+)     | Icono para la segunda habilidad de arma. Más elaborado que el primero, denotando mayor poder. Se desbloquea con armas de Rango 2 o superior.                                                                                                                                                     |
| `spr_ico_hab_arma_3` | R     | 3ª habilidad de arma (requiere Rango 3)      | Icono para la tercera y más poderosa habilidad de arma. Diseño más impactante y complejo. Solo disponible con armas de Rango 3 (máximo).                                                                                                                                                         |
| `spr_ico_super`      | TAB   | Súper-Habilidad (requiere Esencia al 100%)   | Icono de la Súper-Habilidad. Se muestra junto a la barra de esencia. Al alcanzar 100% de esencia, el icono pulsa con glow elemental usando additive blending (28–32px con efecto). Diseño épico: estrella de poder, explosión elemental, o símbolo mítico del sistema de Conductores.            |

**Layout en pantalla de combate (barra inferior):**

```
[E: Clase]  [Q: Arma1]  [W: Arma2]  [R: Arma3]       [TAB: Súper]
```

- Se escalan a 48×48 px en la barra inferior.
- Cooldown representado como overlay negro semitransparente.
- El icono de Súper solo se activa cuando la esencia llega al 100%.

---

## 10. Efectos Visuales (`spr_fx_*`)

> Todos los FX son **256×256 px**, 1 frame, origin en **Middle-Center** (128, 128). El origin centrado permite posicionarlos directamente sobre el personaje/enemigo afectado. Están en la carpeta `sprites/fx`.

### 10.1. Efecto de Impacto

| Propiedad       | Valor                                                                                                                                                                                                                                                                                                                               |
| --------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Nombre**      | `spr_fx_impacto`                                                                                                                                                                                                                                                                                                                    |
| **Tamaño**      | 256×256                                                                                                                                                                                                                                                                                                                             |
| **Descripción** | Efecto visual al golpear al oponente. Flash de contacto / onda de impacto. Se posiciona sobre el personaje afectado con offset aleatorio (±30px X, ±40px Y) para variación visual. Colores neutros (blanco/gris) para funcionar con cualquier afinidad. Diseño: explosión circular, estrella de impacto, o onda de choque radiante. |

### 10.2. Efecto Crítico

| Propiedad       | Valor                                                                                                                                                                                                                                                                                                             |
| --------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Nombre**      | `spr_fx_critico`                                                                                                                                                                                                                                                                                                  |
| **Tamaño**      | 256×256                                                                                                                                                                                                                                                                                                           |
| **Descripción** | Efecto visual de golpe crítico. Más grande, más brillante y más dramático que el impacto normal. Probabilidad base de crítico: 3%, multiplicador ×1.50. Diseño: impacto con fragmentos/estrellas adicionales, múltiples capas de destello, color dorado/amarillo brillante para diferenciarse del impacto normal. |

### 10.3. Efecto de Curación

| Propiedad       | Valor                                                                                                                                                                                                                                                                                     |
| --------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Nombre**      | `spr_fx_curacion`                                                                                                                                                                                                                                                                         |
| **Tamaño**      | 256×256                                                                                                                                                                                                                                                                                   |
| **Descripción** | Efecto visual al curar HP (pociones, regeneración, lifesteal). Se posiciona sobre el personaje curado con offset aleatorio menor que los impactos. Diseño suave y reconfortante: cruces verdes ascendentes, destellos de vida, partículas luminosas suaves. Color principal verde/blanco. |

### 10.4. Efecto de Esquiva

| Propiedad       | Valor                                                                                                                                                                                                                                     |
| --------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Nombre**      | `spr_fx_esquiva`                                                                                                                                                                                                                          |
| **Tamaño**      | 256×256                                                                                                                                                                                                                                   |
| **Descripción** | Efecto visual al esquivar/evitar un ataque. Diseño etéreo, de desvanecimiento o afterimage. El personaje "desaparece" momentáneamente. Color azul claro/gris/transparente. Efecto de duplicación fantasmal o estela de movimiento rápido. |

### 10.5. Efecto de Esencia

| Propiedad       | Valor                                                                                                                                                                                                                                                                                           |
| --------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Nombre**      | `spr_fx_esencia`                                                                                                                                                                                                                                                                                |
| **Tamaño**      | 256×256                                                                                                                                                                                                                                                                                         |
| **Descripción** | Efecto visual cuando se genera esencia por acciones de combate. Offset reducido respecto al personaje. Diseño: partículas luminosas ascendentes que fluyen hacia la barra de esencia. Color variable según la afinidad del personaje (se tinta por código). Forma de energía etérea/espiritual. |

### 10.6. Efecto de Súper-Habilidad

| Propiedad       | Valor                                                                                                                                                                                                                                                                                                                                                                          |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Nombre**      | `spr_fx_super`                                                                                                                                                                                                                                                                                                                                                                 |
| **Tamaño**      | 256×256                                                                                                                                                                                                                                                                                                                                                                        |
| **Descripción** | Efecto visual al activar la Súper-Habilidad. El más espectacular de todos los FX. Acompañado por: hitstop (0.2s de pausa dramática), screenshake (0.33s), flash elemental de pantalla completa (color de energía de la afinidad del personaje). Diseño: explosión de aura total, anillos de energía expansivos, símbolo de poder máximo. Debe sentirse como un momento clímax. |

**Efectos Adicionales Procedurales** (sin sprite dedicado, generados por código):

- Glow elemental sobre personaje (additive blending con colores de afinidad).
- Flash de pantalla al activar súper (color de energía de la afinidad).
- Partículas internas en barra de esencia (movimiento horizontal).
- Pulsos y marcadores de tier en barra de esencia (50%, 75%).
- Hitstop automático en golpes fuertes (>15% vida máxima del objetivo).

---

## 11. Rooms y Composición Visual

### Configuración Técnica Común (Todas las Rooms)

| Propiedad                | Valor                                                      |
| ------------------------ | ---------------------------------------------------------- |
| **Tamaño de room**       | 1280×720                                                   |
| **Capas**                | 2: `"Instances"` (depth 0) + `"Background"` (depth 100)    |
| **Background en editor** | Sin sprite asignado (`spriteId: null`), color negro sólido |
| **Views**                | 8 definidas, todas deshabilitadas. Viewport: 1366×768      |
| **Física**               | Deshabilitada                                              |
| **Persistencia**         | Ninguna                                                    |

> Los fondos (`spr_bg_*`) se asignan y dibujan **por código** desde los objetos controladores con `draw_sprite_stretched`, no desde el editor de rooms.

### Composición por Room

#### `rm_boot` — Arranque

| Elemento              | Detalle                                                                                                     |
| --------------------- | ----------------------------------------------------------------------------------------------------------- |
| **Fondo**             | Ninguno (pantalla negra, transición inmediata)                                                              |
| **Objeto**            | `obj_control_juego` en (0, 0)                                                                               |
| **Función**           | Inicialización de variables globales, datos del juego, inventario. Transiciona automáticamente a `rm_menu`. |
| **Sprites UI usados** | Ninguno                                                                                                     |

#### `rm_menu` — Menú Principal

| Elemento       | Detalle                                                                                                           |
| -------------- | ----------------------------------------------------------------------------------------------------------------- |
| **Fondo**      | `spr_bg_menu` (pantalla completa)                                                                                 |
| **Objeto**     | `obj_menu` en (0, 0)                                                                                              |
| **Sprites UI** | `spr_logo_arcadium` (centrado arriba), `spr_boton_menu` (por cada opción)                                         |
| **Layout**     | Logo en parte superior centrado (410px ancho). Botones apilados verticalmente debajo. Oro del jugador en esquina. |

#### `rm_select` — Selección de Personaje

| Elemento       | Detalle                                                                                                                                    |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| **Fondo**      | `spr_bg_select` (pantalla completa)                                                                                                        |
| **Objeto**     | `obj_select` en (128, 64)                                                                                                                  |
| **Sprites UI** | `spr_marco_retrato` (×8 personajes), `spr_cursor_select`, iconos de afinidad                                                               |
| **Layout**     | Cuadrícula de 8 retratos con nombre debajo. Cursor indica selección. Panel lateral derecho con stats y detalle del personaje seleccionado. |

#### `rm_enemy_select` — Selección de Enemigo

| Elemento       | Detalle                                                                                                                             |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| **Fondo**      | `spr_bg_enemy_select` (pantalla completa)                                                                                           |
| **Objeto**     | `obj_enemy_select` en (0, 0)                                                                                                        |
| **Sprites UI** | `spr_marco_retrato`, `spr_cursor_select`, iconos de afinidad                                                                        |
| **Layout**     | Lista vertical o cuadrícula de hasta 20 enemigos (comunes, élites, jefes). Cursor amarillo, panel de info del enemigo seleccionado. |

#### `rm_combate` — Combate

| Elemento           | Detalle                                                                                                                                                                                                                                             |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Fondo**          | `spr_bg_combate_1` a `_5` (según `combate_arena_idx`)                                                                                                                                                                                               |
| **Objetos**        | `obj_control_combate` (0, 0) + `obj_control_ui_combate` (0, 64)                                                                                                                                                                                     |
| **Sprites UI**     | Todo el HUD: barras de vida, barra de esencia, marcos de retrato, slots de habilidad, slots de objetos/runas, iconos de estados, iconos de habilidad, todos los FX                                                                                  |
| **Layout del HUD** | Jugador arriba-izquierda (retrato + barra vida + estados). Enemigo arriba-derecha (retrato + barra vida + estados). Barra de esencia centrada. Habilidades en barra inferior (E, Q, W, R + TAB). Columna izquierda: runa + 3 consumibles (1, 2, 3). |

#### `rm_forja` — Forja de Armas

| Elemento       | Detalle                                                                                                                                                                                                                                |
| -------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Fondo**      | `spr_bg_forja` (pantalla completa)                                                                                                                                                                                                     |
| **Objeto**     | `obj_ui_forja` en (0, 0)                                                                                                                                                                                                               |
| **Sprites UI** | `spr_cursor_select`, posibles iconos de materiales                                                                                                                                                                                     |
| **Layout**     | Lista de armas disponibles para fabricar a la izquierda con cursor. Panel de detalle a la derecha: nombre del arma, materiales necesarios, habilidades que otorga, botón fabricar. Indicador de materiales disponibles vs. necesarios. |

#### `rm_tienda` — Tienda

| Elemento       | Detalle                                                                                                                                                                                  |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Fondo**      | `spr_bg_tienda` (pantalla completa)                                                                                                                                                      |
| **Objeto**     | `obj_ui_tienda` en (0, 0)                                                                                                                                                                |
| **Sprites UI** | `spr_panel_info` (panel de detalle), iconos de objetos/runas, marcos de retrato                                                                                                          |
| **Layout**     | Tabs en la parte superior (Personajes, Enemigos, Objetos, Runas). Lista de items por tab. Panel de detalle (42% pantalla) al seleccionar un item. Oro disponible visible. Botón comprar. |

#### `rm_torre` — Modo Torre

| Elemento       | Detalle                                                                                                             |
| -------------- | ------------------------------------------------------------------------------------------------------------------- |
| **Fondo**      | `spr_bg_torre` (pantalla completa)                                                                                  |
| **Objeto**     | `obj_control_torre` en (0, 0)                                                                                       |
| **Sprites UI** | Interfaz de selección de ala/dificultad                                                                             |
| **Layout**     | Selección de ala (elemento/dominio) y nivel de dificultad. Progresión visual por pisos. Información de recompensas. |

#### `rm_camino` — Camino del Héroe (Roguelite)

| Elemento       | Detalle                                                                                                                               |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| **Fondo**      | `spr_bg_torre` (reutilizado, pendiente `spr_bg_camino`)                                                                               |
| **Objeto**     | `obj_control_camino` en (0, 0)                                                                                                        |
| **Sprites UI** | Interfaz de progresión del camino                                                                                                     |
| **Layout**     | Mapa de nodos con caminos ramificados. Nodos de combate, tienda, evento, descanso, jefe. Progresión visual del personaje por el mapa. |

---

## 12. Tabla Resumen de Dimensiones

| Categoría                                         | Tamaño (px) | Cantidad       | Origin            | Tamaño en UI         |
| ------------------------------------------------- | ----------- | -------------- | ----------------- | -------------------- |
| Fondos (`spr_bg_*`)                               | 1920×1080   | 11             | Top-Left          | 1280×720 (stretched) |
| Barras                                            | 512×48      | 5              | Top-Left          | Variable (stretched) |
| Botón menú                                        | 384×96      | 1              | Top-Left          | 192×36               |
| Cursor                                            | 64×64       | 1              | Top-Left          | 16–19 px             |
| Logo                                              | 1024×512    | 1              | **Middle-Center** | 410 px ancho         |
| Marco retrato                                     | 280×280     | 1              | Top-Left          | ~84+8 px             |
| Panel info                                        | 640×480     | 1              | Top-Left          | Variable             |
| Slots (objeto/runa)                               | 192×128     | 2              | Top-Left          | ~50 px               |
| Iconos pequeños (afinidad/estado/consumible/runa) | 128×128     | 27             | Top-Left          | 16–30 px             |
| Iconos habilidad/súper                            | 192×192     | 5              | Top-Left          | 28–48 px             |
| Efectos FX                                        | 256×256     | 6              | **Middle-Center** | Variable             |
| **TOTAL**                                         |             | **61 sprites** |                   |                      |

---

## 13. Assets Pendientes

| Asset                       | Estado                          | Notas                                                                                                                              |
| --------------------------- | ------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `spr_bg_camino`             | **No existe**                   | Se reutiliza `spr_bg_torre`. Crear un fondo específico para el Camino del Héroe con temática de mapa/camino.                       |
| `spr_barra_esencia` / `_bg` | Existe pero **sin uso directo** | La barra de esencia se dibuja proceduralmente con FX avanzados. Los assets podrían usarse como base visual en una refactorización. |
| `spr_barra_cooldown`        | Existe pero **sin uso directo** | El cooldown se dibuja como overlay programático. El asset podría incorporarse para un sistema de cooldown visual más elaborado.    |
| Prompts IA para fondos/UI   | **No documentados**             | El archivo de prompts solo cubre personajes. Crear prompts específicos para fondos, iconos y elementos UI.                         |

---

> **Nota:** Este documento complementa `GUIA_SPRITES_Personajes_Enemigos.md` (personajes jugables, enemigos y jefes) y `PROMPTS_IA_Generacion_Sprites.md` (prompts para generación con IA de personajes).
