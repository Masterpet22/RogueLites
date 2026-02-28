# ARCADIUM

**Roguelite táctico 1v1 en tiempo real** desarrollado en GameMaker Studio 2.

![GameMaker](https://img.shields.io/badge/Engine-GameMaker%20Studio%202-green)
![Estado](https://img.shields.io/badge/Estado-En%20desarrollo-yellow)
![Licencia](https://img.shields.io/badge/Licencia-MIT-blue)

---

## Descripción

ARCADIUM es un juego de combate estático 1v1 en tiempo real donde los personajes no se mueven físicamente. El control se basa en **habilidades con cooldown** asignadas a teclas, combinando profundidad táctica con una progresión roguelite centrada en la forja de armas.

El jugador asume el rol de un **Conductor**: un individuo capaz de dominar una afinidad elemental, forjar armas legendarias y sobrevivir en las arenas ruinosas de Arcadium. El objetivo final es derrotar al **Devorador**, una entidad que consume Esencia y corrompe las Corrientes elementales del mundo.

---

## Características principales

- **Combate en tiempo real** sin movimiento ni turnos — todo se basa en habilidades, cooldowns y timing.
- **8 afinidades elementales** (Fuego, Agua, Planta, Rayo, Tierra, Sombra, Luz, Arcano) con pasivas únicas y relaciones de ventaja/desventaja.
- **6 clases jugables** con rol y mecánicas distintas: Vanguardia, Filotormenta, Quebrador, Centinela, Duelista y Canalizador.
- **8 personajes** con combinaciones únicas de clase, afinidad y personalidad.
- **4 personalidades** que modifican estadísticas y determinan la variante de Súper-Habilidad.
- **Sistema de ESENCIA** — barra de poder que se llena según la clase y desbloquea Súper-Habilidades devastadoras.
- **24 armas** (3 rarezas × 8 afinidades) que cambian las habilidades ofensivas del personaje.
- **Sistema de forja** — materiales obtenidos al vencer enemigos permiten crear armas más poderosas.
- **20 enemigos** entre comunes, élites y jefes duales-elementales.
- **Tienda** para desbloquear personajes, enemigos y objetos consumibles.
- **Objetos equipables** para llevar al combate (hasta 3 por pelea).

---

## Controles

### Selección

| Tecla  | Acción                              |
| ------ | ----------------------------------- |
| ↑ / ↓  | Navegar opciones                    |
| Enter  | Confirmar selección                 |
| Tab    | Seleccionar/deseleccionar (objetos) |
| Escape | Volver atrás                        |

### Combate

| Tecla     | Acción                                     |
| --------- | ------------------------------------------ |
| Espacio   | Habilidad de clase                         |
| Q         | Habilidad de arma 1                        |
| W         | Habilidad de arma 2                        |
| E         | Habilidad de arma 3                        |
| R         | Súper-Habilidad (requiere ESENCIA al 100%) |
| 1 / 2 / 3 | Usar objeto equipado (slot 1, 2, 3)        |

---

## Personajes

| Nombre | Clase        | Afinidad | Personalidad |
| ------ | ------------ | -------- | ------------ |
| Kael   | Vanguardia   | Fuego    | Resuelto     |
| Lys    | Filotormenta | Rayo     | Agresivo     |
| Torvan | Quebrador    | Tierra   | Metódico     |
| Maelis | Centinela    | Luz      | Metódico     |
| Saren  | Duelista     | Sombra   | Resuelto     |
| Nerya  | Canalizador  | Arcano   | Metódico     |
| Thalys | Centinela    | Agua     | Temerario    |
| Brenn  | Quebrador    | Planta   | Agresivo     |

---

## Estructura del proyecto

RogueLites/
├── documents/ # Documentación de diseño (GDD, TDD, etc.)
├── fonts/ # Fuentes del juego
├── objects/ # Objetos de GameMaker
│ ├── obj*control_juego/ # Controlador global persistente
│ ├── obj_control_combate/ # Lógica del combate 1v1
│ ├── obj_control_ui_combate/ # UI durante el combate
│ ├── obj_menu/ # Menú principal
│ ├── obj_select/ # Selección de personaje + arma + objetos
│ ├── obj_enemy_select/ # Selección de enemigo
│ ├── obj_ui_tienda/ # Tienda
│ └── obj_ui_forja/ # Forja de armas
├── rooms/ # Salas del juego
│ ├── rm_boot/ # Arranque
│ ├── rm_menu/ # Menú principal
│ ├── rm_select/ # Selección de personaje
│ ├── rm_enemy_select/# Selección de enemigo
│ ├── rm_combate/ # Combate
│ ├── rm_tienda/ # Tienda
│ └── rm_forja/ # Forja
├── scripts/ # Lógica del juego
│ ├── scr_datos*_/ # Datos de clases, afinidades, armas, enemigos, etc.
│ ├── scr*inventario*_/ # Gestión de inventario
│ ├── scr*ejecutar*\*/ # Ejecución de habilidades y súper
│ ├── scr_ia_enemigo/ # IA del enemigo
│ └── scr_config_juego/ # Macros y configuración global
└── sprites/ # Sprites (pendiente)

---

## Bucle de juego

Menú → Seleccionar personaje → Elegir arma → Equipar objetos → Elegir enemigo → ¡Combate!
│
Tienda ← Oro ←──── Recompensas (materiales + oro) ──────────┘
│
Forja → Nuevas armas → Más poder

---

## Requisitos

- **GameMaker Studio 2** (IDE versión 2024.14 o superior)
- Runtime compatible con la versión del IDE

---

## Cómo ejecutar

1. Clona el repositorio:
   bash
   git clone https://github.com/tu-usuario/RogueLites.git

2. Abre `RogueLites.yyp` con GameMaker Studio 2.
3. Presiona **F5** para compilar y ejecutar.

---

## Estado del desarrollo

- [x] Combate 1v1 en tiempo real con cooldowns
- [x] 8 personajes con afinidades, clases y personalidades
- [x] Sistema de habilidades (clase + arma + súper)
- [x] IA enemiga con máquina de estados
- [x] Sistema de ESENCIA y Súper-Habilidades
- [x] Forja de armas con materiales
- [x] Tienda (personajes, enemigos, objetos)
- [x] Sistema de objetos equipables para combate
- [x] Enemigos comunes, élite y jefes duales
- [x] Sistema de estados alterados
- [x] Notificaciones de combate
- [ ] Sprites y arte visual
- [ ] Sonido y música
- [ ] Jefe final: El Devorador
- [ ] Jefe secreto: El Primer Conductor
- [ ] Modo Roguelite (Camino del Héroe)
- [ ] Narrativa y fragmentos de memoria

---

## Documentación

La carpeta `documents/` contiene documentación detallada del diseño:

| Documento                              | Contenido                           |
| -------------------------------------- | ----------------------------------- |
| `NUEVO_01_GDD_General.md`              | Game Design Document completo       |
| `NUEVO_02_Manual_de_Desarrollo.md`     | Manual de desarrollo y convenciones |
| `NUEVO_03_Diseno_Tecnico_TDD.md`       | Diseño técnico detallado            |
| `NUEVO_04_Guia_Expansion_Contenido.md` | Guía para expandir contenido        |
| `NUEVO_05_Doc_Gameplay_Programmer.md`  | Documentación para programadores    |

---

## Licencia

Este proyecto está bajo la licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.
