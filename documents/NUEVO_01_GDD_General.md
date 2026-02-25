# ARCADIUM — Game Design Document (GDD)

> Versión consolidada · Febrero 2026

---

## 1. Concepto General

### 1.1. Género y Formato

- **Roguelite táctico 1v1 en tiempo real.**
- Combate estático: los personajes NO se mueven físicamente.
- Control basado en **habilidades con cooldown**.
- Motor: GameMaker Studio 2.

### 1.2. Fantasía del Jugador

Ser un **Conductor** capaz de dominar una afinidad elemental, forjar armas legendarias, sobrevivir arenas ruinosas y derrotar al Devorador.

### 1.3. Pilares de Diseño

| Pilar                | Descripción                                                                  |
| -------------------- | ---------------------------------------------------------------------------- |
| Profundidad táctica  | Combate estratégico sin necesidad de movimiento                              |
| Identidad única      | Cada run se define por la combinación Clase + Afinidad + Personalidad + Arma |
| Clímax por ESENCIA   | El medidor de Esencia genera momentos decisivos de poder                     |
| Progresión por forja | Materiales y armas como núcleo roguelite                                     |

### 1.4. Bucles de Juego

**Bucle de Combate (micro):**

1. Elegir habilidades → 2. Aplicar daño/efectos → 3. Gestionar cooldowns → 4. Activar pasivas elementales → 5. Construir ESENCIA → 6. Usar Súper-Habilidad.

**Bucle de Progresión (macro):**

1. Derrotar enemigos → 2. Recibir materiales → 3. Forjar armas → 4. Obtener nuevas habilidades → 5. Enfrentar jefes → 6. Avanzar narrativa y poder.

### 1.5. Meta Final

Derrotar al **Devorador**.

---

## 2. Mundo y Lore

### 2.1. Arcadium

Mundo antiguo en ruinas, antes alimentado por ocho Corrientes elementales. El evento conocido como **La Ruptura** trajo a **El Devorador**, una entidad que consume Esencia y corrompe las Corrientes.

### 2.2. Dominios Ruinosos

No hay reinos estables, solo territorios arruinados:

| Afinidad | Dominio                                   |
| -------- | ----------------------------------------- |
| Fuego    | Forjas volcánicas destruidas              |
| Agua     | Ciudades congeladas en canales rotos      |
| Planta   | Bosques parasitados                       |
| Rayo     | Ruinas suspendidas en tormentas perpetuas |
| Tierra   | Templos derrumbados y golems rotos        |
| Sombra   | Ciudades subterráneas devoradas           |
| Luz      | Templos santos fracturados                |
| Arcano   | Observatorios fractales destruidos        |

### 2.3. Los Conductores

Individuos capaces de manipular una Corriente elemental. Cada Conductor posee:

- **Afinidad fija** (elemento).
- **Clase** (rol de combate).
- **Personalidad** (modificador de stats y súper).
- **Conexión con la ESENCIA** (medidor de poder).

### 2.4. El Devorador

- No posee afinidad elemental.
- Absorbe Esencia, corrompe habilidades y altera las Corrientes.
- Es el **jefe final** del modo Historia.

### 2.5. Camino del Héroe (Modo Roguelite)

- Cada run muestra "fragmentos de memoria" del personaje.
- Las victorias desbloquean recuerdos y contexto narrativo.
- Cada victoria construye progresivamente su historia.

---

## 3. Sistema de Afinidades

### 3.1. Las 8 Afinidades

Fuego · Agua · Planta · Rayo · Tierra · Sombra · Luz · Arcano

### 3.2. Mecánica de Afinidad

Cada afinidad define:

| Componente             | Descripción                                                                                   |
| ---------------------- | --------------------------------------------------------------------------------------------- |
| **Activador**          | Condición en tiempo real que dispara la pasiva (recibir daño, usar habilidades, combos, etc.) |
| **Bono**               | Efecto positivo al activarse (daño extra, defensa, velocidad, crítico, etc.)                  |
| **Penalización**       | Contrapartida asociada                                                                        |
| **Cooldown interno**   | Evita activación constante                                                                    |
| **Relación elemental** | Ventajas y desventajas frente a otras afinidades                                              |

### 3.3. Tabla de Relaciones Elementales

Las afinidades tienen multiplicadores de daño entre sí (ventaja, desventaja, neutral), implementados mediante `scr_multiplicador_afinidad`.

---

## 4. Sistema de Clases

### 4.1. Las 6 Clases

| Clase            | Rol               | Estilo de juego                    |
| ---------------- | ----------------- | ---------------------------------- |
| **Vanguardia**   | Tanque agresivo   | Absorbe daño y contraataca         |
| **Filotormenta** | Ofensivo veloz    | Velocidad y combos rápidos         |
| **Quebrador**    | Golpes pesados    | Lentos pero devastadores           |
| **Centinela**    | Defensa extrema   | Protección total y soporte         |
| **Duelista**     | Precisión         | Parries y contraataques precisos   |
| **Canalizador**  | Control elemental | Maestro de habilidades elementales |

### 4.2. Cada Clase Define

- **Stats base:** vida, ataque, defensa, velocidad, poder elemental.
- **1 habilidad fija** de clase (siempre disponible).
- **Método de carga de ESENCIA** (único por clase).
- **Rol táctico** en combate.

---

## 5. Personalidades

4 personalidades que modifican estadísticas y determinan la variante de la Súper-Habilidad:

| Personalidad  | Efecto                                                  |
| ------------- | ------------------------------------------------------- |
| **Agresivo**  | Favorece ataque/velocidad, penaliza defensa             |
| **Metódico**  | Favorece defensa/consistencia                           |
| **Temerario** | Gran poder a cambio de riesgos altos                    |
| **Resuelto**  | Estabilidad, penalizaciones menores, efectos constantes |

---

## 6. Sistema de ESENCIA

### 6.1. Concepto

Barra de poder universal que se llena según la **clase** del personaje. Al llegar al 100% permite usar la **Súper-Habilidad**.

### 6.2. Carga por Clase

| Clase        | Condición de carga                       |
| ------------ | ---------------------------------------- |
| Vanguardia   | Al recibir daño                          |
| Filotormenta | Al usar habilidades en secuencia         |
| Quebrador    | Al acertar golpes fuertes                |
| Centinela    | Al mitigar daño                          |
| Duelista     | Al contraatacar o esquivar con precisión |
| Canalizador  | Al usar habilidades elementales          |

### 6.3. Súper-Habilidades

- Cada clase tiene un concepto base de súper.
- Cada personalidad genera una variante distinta.
- **Total: 24 Súper-Habilidades** (6 clases × 4 personalidades).
- Tras usar la súper, la ESENCIA vuelve a 0.

---

## 7. Sistema de Combate 1v1

### 7.1. Características

- **Tiempo real**, sin pausas ni turnos.
- Escena fija: jugador a la izquierda, enemigo a la derecha.
- Sin movimiento ni plataformas.
- Selección de habilidades por teclas (ESPACIO, Q, W…).
- Cada habilidad con cooldown independiente.
- IA enemiga basada en cooldowns y patrones.

### 7.2. Tipos de Habilidades en Combate

| Tipo                    | Fuente                             | Disponibilidad            |
| ----------------------- | ---------------------------------- | ------------------------- |
| Habilidad fija de clase | Clase del personaje                | Siempre disponible        |
| Habilidades de arma     | Arma equipada (1 a 3 según rareza) | Según cooldown            |
| Súper-Habilidad         | Clase + Personalidad               | Al llenar ESENCIA al 100% |

### 7.3. Flujo de Combate

1. Se crean structs de jugador y enemigo con stats, habilidades y estados.
2. El jugador elige habilidades según cooldown disponible.
3. El enemigo usa IA basada en patrones y cooldowns.
4. Afinidades activan pasivas según condiciones de combate.
5. Se aplican daños, estados alterados y cambios de ESENCIA.
6. Si la vida de alguien llega a 0 → fin de combate.
7. Se calcula y entrega drop de materiales.

---

## 8. Personajes Base

| #   | Nombre     | Clase        | Afinidad  | Personalidad |
| --- | ---------- | ------------ | --------- | ------------ |
| 1   | **Kael**   | Vanguardia   | Fuego     | Resuelto     |
| 2   | **Lys**    | Filotormenta | Rayo      | Agresivo     |
| 3   | **Torvan** | Quebrador    | Tierra    | Metódico     |
| 4   | **Maelis** | Centinela    | Luz       | Metódico     |
| 5   | **Saren**  | Duelista     | Oscuridad | Resuelto     |
| 6   | **Nerya**  | Canalizador  | Arcano    | Metódico     |

Cada uno tiene habilidad fija de clase, afinidad pasiva y Súper-Habilidad personalizada.

---

## 9. Enemigos

### 9.1. Enemigos Comunes (8)

Un enemigo por afinidad. Cada uno con 1 habilidad fija + 1 secundaria. Dropean material común (+ chance de raro).

| Enemigo                  | Afinidad |
| ------------------------ | -------- |
| Soldado Ígneo            | Fuego    |
| Vigía Boreal             | Agua     |
| Hálito Verde             | Planta   |
| Bestia Tronadora         | Rayo     |
| Guardián Terracota       | Tierra   |
| Náufrago de la Oscuridad | Sombra   |
| Paladín Marchito         | Luz      |
| Errante Rúnico           | Arcano   |

### 9.2. Enemigos Élite (8)

- Versión avanzada de los comunes.
- Tienen mecánica extra (buffs, escalados, eco de habilidades).
- Dropean material **raro** de su afinidad (casi siempre) + común secundario.

### 9.3. Jefes (6)

#### Jefes Duales (1–4)

Combinan 2 afinidades con 4 habilidades (2 por afinidad) y mecánica temática. Dropean **material único** para armas legendarias.

| #   | Jefe                        | Afinidades      |
| --- | --------------------------- | --------------- |
| 1   | Titán de las Forjas Rotas   | Fuego + Tierra  |
| 2   | Coloso del Fango Viviente   | Agua + Planta   |
| 3   | Sentinela del Cielo Roto    | Rayo + Luz      |
| 4   | Oráculo Quebrado del Abismo | Sombra + Arcano |

#### Jefe 5 — El Devorador (Jefe Final)

- Sin afinidad elemental.
- 4 habilidades únicas.
- Roba Esencia y desactiva efectos de afinidad.
- Copia patrones del jugador.

#### Jefe 6 — El Primer Conductor (Jefe Secreto)

- Sin afinidad visible.
- Imita estilos de clase del jugador.
- Manipula ESENCIA y ritmo del combate.
- El jefe más difícil del juego.

---

## 10. Sistema de Materiales

### 10.1. Por Afinidad (×8)

| Tipo           | Fuente           | Total |
| -------------- | ---------------- | ----- |
| Material común | Enemigos comunes | 8     |
| Material raro  | Enemigos élite   | 8     |

### 10.2. Por Jefe

- 1 **material único** (legendario) por jefe — usado para armas R3.

---

## 11. Sistema de Armas

### 11.1. Reglas Globales

- Cada arma tiene **1 afinidad elemental**.
- Las armas determinan las habilidades ofensivas del personaje.
- Cada arma otorga bonos a ataque y poder elemental.

### 11.2. Rarezas

| Rareza          | Habilidades   | Materiales             |
| --------------- | ------------- | ---------------------- |
| R1              | 1 habilidad   | Solo comunes           |
| R2              | 2 habilidades | Comunes + raros        |
| R3 (legendaria) | 3 habilidades | Raros + únicos de jefe |

### 11.3. Distribución

- 1 arma R1, 1 arma R2 y 1 arma R3 por afinidad.
- **Total: 24 armas** (8 afinidades × 3 rarezas).

### 11.4. Ejemplo: Afinidad Fuego

| Arma                   | Rareza | Habilidades                            | Receta                                    |
| ---------------------- | ------ | -------------------------------------- | ----------------------------------------- |
| Filo Ígneo             | R1     | Quemadura básica                       | Fragmentos Ígneos                         |
| Mandoble Carmesí       | R2     | Quemadura mejorada + Daño en vida baja | Fragmentos Ígneos + Brasa Carmesí         |
| Espada Solar del Titán | R3     | 3 habilidades de fuego/venganza        | Comunes + Raros + Núcleo de Forja Antigua |

---

## 12. Sistema de Forja

### 12.1. Mecánica

El jugador gasta materiales para crear armas según recetas predefinidas.

### 12.2. Recetas por Rareza

| Rareza | Ingredientes                      |
| ------ | --------------------------------- |
| R1     | Solo materiales comunes           |
| R2     | Comunes + raros                   |
| R3     | Raros + materiales únicos de jefe |

### 12.3. Flujo

1. Vencer enemigos → 2. Obtener materiales → 3. Ir a la forja → 4. Seleccionar receta → 5. Forjar arma.

---

## 13. Interacción de Sistemas

Enemigos → Materiales → Forja → Armas → Habilidades → Combate
↑ ↓
Clases ← Afinidades ← Personalidades ← ESENCIA ←

| Sistema        | Relación                                         |
| -------------- | ------------------------------------------------ |
| Enemigos       | Dropean materiales al ser derrotados             |
| Materiales     | Permiten forjar armas en la forja                |
| Armas          | Otorgan habilidades ofensivas al personaje       |
| Habilidades    | Se usan en combate con cooldowns                 |
| Afinidades     | Activan pasivas y modifican cálculos de daño     |
| Clases         | Definen carga de Esencia y rol táctico           |
| Personalidades | Alteran stats y determinan variante de súper     |
| ESENCIA        | Libera Súper-Habilidades como clímax del combate |

---

## 14. Plan de Escalado

| Fase | Contenido                                     |
| ---- | --------------------------------------------- |
| 1    | Prototipo base: combate + arma R1 + 1 enemigo |
| 2    | Forja mínima funcional                        |
| 3    | Integración de afinidades                     |
| 4    | Primer jefe                                   |
| 5    | Enemigos por afinidad (×8)                    |
| 6    | Armas R2                                      |
| 7    | Jefes duales                                  |
| 8    | Armas legendarias (R3)                        |
| 9    | Camino del Héroe (roguelite)                  |
| 10   | El Devorador (jefe final)                     |
