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

| #   | Nombre     | Clase        | Afinidad | Personalidad |
| --- | ---------- | ------------ | -------- | ------------ |
| 1   | **Kael**   | Vanguardia   | Fuego    | Resuelto     |
| 2   | **Lys**    | Filotormenta | Rayo     | Agresivo     |
| 3   | **Torvan** | Quebrador    | Tierra   | Metódico     |
| 4   | **Maelis** | Centinela    | Luz      | Metódico     |
| 5   | **Saren**  | Duelista     | Sombra   | Resuelto     |
| 6   | **Nerya**  | Canalizador  | Arcano   | Metódico     |
| 7   | **Thalys** | Centinela    | Agua     | Temerario    |
| 8   | **Brenn**  | Quebrador    | Planta   | Agresivo     |

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

## 14. Sistema de Objetos Consumibles

### 14.1. Concepto

Los objetos consumibles se compran en la tienda, se equipan antes de un combate (máx. 3 por combate) y se usan con las teclas 1, 2, 3 durante la pelea. Al usarse, se gastan del inventario.

### 14.2. Lista de Consumibles

| Objeto            | Efecto                               | Precio | Venta |
| ----------------- | ------------------------------------ | ------ | ----- |
| Poción Básica     | Restaura 30 HP                       | 50     | 15    |
| Poción Media      | Restaura 80 HP                       | 150    | 45    |
| Elixir de Esencia | Restaura 50% de la barra de esencia  | 120    | 35    |
| Tónico de Ataque  | +5 ataque durante el combate actual  | 100    | 30    |
| Tónico de Defensa | +5 defensa durante el combate actual | 100    | 30    |

---

## 15. Sistema de Rúnicos

### 15.1. Concepto

Los rúnicos son objetos especiales que se equipan antes del combate (máx. 1). Se aplican automáticamente al inicio del combate y **se consumen al terminar** (gane o pierda). Cada uno ofrece una **ventaja significativa** junto con una **desventaja**.

### 15.2. Lista de Rúnicos

| Rúnico                  | Ventaja                             | Desventaja                 | Precio | Venta |
| ----------------------- | ----------------------------------- | -------------------------- | ------ | ----- |
| Runa de Furia           | +30% daño infligido                 | −20% vida máxima           | 200    | 60    |
| Runa de Fortaleza       | +40% vida máxima                    | −25% daño infligido        | 200    | 60    |
| Runa de Celeridad       | +50% velocidad                      | −30% defensa               | 180    | 55    |
| Runa del Último Aliento | Sobrevive golpe letal (1 vez, 1 HP) | Primer ataque hace 0 daño  | 300    | 90    |
| Runa Vampírica          | 15% lifesteal                       | −40% generación de esencia | 250    | 75    |
| Runa de Cristal         | +50% daño infligido                 | +50% daño recibido         | 250    | 75    |

---

## 16. Estados Alterados

### 16.1. Concepto

Los estados alterados se aplican durante el combate por habilidades, duran un tiempo limitado y modifican stats o causan daño periódico. Máximo 5 segundos por estado (`ESTADO_DUR_MAX_SEG`).

### 16.2. Lista de Estados

| Estado             | Tipo             | Efecto                      | Aplicado por      |
| ------------------ | ---------------- | --------------------------- | ----------------- |
| Quemadura (fuego)  | DoT              | 3 daño/s por tick           | Armas de fuego    |
| Veneno             | DoT              | 2 daño/s por tick           | Armas de planta   |
| Regeneración       | HoT              | 3 curación/s por tick       | Armas de agua/luz |
| Muro de Tierra     | Buff Defensa     | +4 defensa temporal         | Armas de tierra   |
| Aceleración (rayo) | Buff Velocidad   | +3 velocidad temporal       | Armas de rayo     |
| Ralentización      | Debuff Velocidad | −3 velocidad temporal       | Armas de agua     |
| Vulnerabilidad     | Debuff Defensa   | −4 defensa temporal         | Armas de sombra   |
| Supresión Arcana   | Debuff Poder     | −3 poder elemental temporal | Armas arcanas     |

---

## 17. Tabla de Multiplicadores Elementales

### 17.1. Ventajas de Afinidad

| Atacante → Defensor | Multiplicador |
| ------------------- | ------------- |
| Fuego → Planta      | ×1.50         |
| Agua → Fuego        | ×1.40         |
| Planta → Agua       | ×1.30         |
| Rayo → Agua         | ×1.40         |
| Tierra → Rayo       | ×1.50         |
| Sombra → Luz        | ×1.40         |
| Luz → Sombra        | ×1.40         |
| Arcano → Todos      | ×1.10         |

### 17.2. Desventajas de Afinidad

| Atacante → Defensor | Multiplicador |
| ------------------- | ------------- |
| Fuego → Agua        | ×0.75         |
| Agua → Rayo         | ×0.80         |
| Planta → Fuego      | ×0.70         |
| Rayo → Tierra       | ×0.75         |

Neutro siempre ×1.00. Si no hay relación especial, ×1.00.

---

## 18. Súper-Habilidades (24 Variantes)

### 18.1. Mecánica de Activación

- Se activa con **TAB** cuando la esencia ≥ 50%.
- La potencia escala según el tier de esencia al usarla:

| Tier de Esencia | Multiplicador de Potencia |
| --------------- | ------------------------- |
| 50–74%          | ×0.50                     |
| 75–99%          | ×0.75                     |
| 100%            | ×1.00                     |

- Tras usarla, la esencia vuelve a 0.

### 18.2. Tabla de 24 Súper-Habilidades

| Clase        | Personalidad | Tipo                 | Descripción breve                                         |
| ------------ | ------------ | -------------------- | --------------------------------------------------------- |
| Vanguardia   | Agresivo     | Daño físico          | Golpe masivo (3.5× ATQ, penetración total)                |
| Vanguardia   | Metódico     | Curación + buff      | Cura 35% vida máx + 50% defensa extra                     |
| Vanguardia   | Temerario    | Daño extremo         | 5.0× ATQ pero pierde 15% de su propia HP                  |
| Vanguardia   | Resuelto     | Daño + lifesteal     | 3.0× ATQ con 30% del daño como curación                   |
| Filotormenta | Agresivo     | Multi-golpe          | 5 golpes de 0.6× ATQ cada uno                             |
| Filotormenta | Metódico     | Multi-golpe + debuff | 3 golpes de 0.9× ATQ + reduce 20% defensa enemiga         |
| Filotormenta | Temerario    | Multi-golpe extremo  | 7 golpes de 0.5× ATQ, pierde 10% HP propia                |
| Filotormenta | Resuelto     | Multi-golpe estable  | 4 golpes de 0.7× ATQ                                      |
| Quebrador    | Agresivo     | Golpe devastador     | 1.0× ATQ + 1.0× Poder con ×4.0 multiplicador              |
| Quebrador    | Metódico     | Golpe + DoT          | 3.0× ATQ + aplica quemadura de fuego (5s)                 |
| Quebrador    | Temerario    | Golpe asesino        | 6.0× ATQ, pierde 25% HP propia                            |
| Quebrador    | Resuelto     | Golpe + defensa      | 3.0× ATQ + gana 30% defensa extra                         |
| Centinela    | Agresivo     | Contra-daño          | Convierte defensa en daño (3.5× DEF)                      |
| Centinela    | Metódico     | Mega-curación        | Cura 40% vida máx + 60% defensa extra                     |
| Centinela    | Temerario    | Defensa explosiva    | Convierte toda defensa temporal acumulada en daño (×4.0)  |
| Centinela    | Resuelto     | Híbrido              | 1.5× DEF daño + 20% vida máx curación + 30% defensa extra |
| Duelista     | Agresivo     | Golpe preciso        | (1.0× ATQ + 1.0× VEL) con ×3.5 multiplicador              |
| Duelista     | Metódico     | Ráfaga precisa       | 6 golpes de 0.5× ATQ con penetración total                |
| Duelista     | Temerario    | Golpe desesperado    | 2.5× ATQ + 1.5× vida perdida como daño extra              |
| Duelista     | Resuelto     | Estocada equilibrada | (1.0× ATQ + 1.0× VEL) ×2.5 + cura 25% del daño            |
| Canalizador  | Agresivo     | Devastación mágica   | 5.0× Poder Elemental, penetración total                   |
| Canalizador  | Metódico     | Daño + curación      | 3.0× Poder como daño + 1.5× Poder como curación           |
| Canalizador  | Temerario    | Apocalipsis mágico   | 7.0× Poder Elemental, pierde 20% HP propia                |
| Canalizador  | Resuelto     | Daño + reset CD      | 3.0× Poder como daño + resetea todos los cooldowns a 0    |

---

## 19. Mecánicas Especiales de Combate (Élite/Jefes)

### 19.1. Concepto

Los enemigos élite y jefes pueden tener mecánicas especiales que modifican el flujo del combate. Cada mecánica se define en el array `mecanicas` de los datos del enemigo.

### 19.2. Lista de Mecánicas

| Mecánica                        | Descripción                                                                                                                                 | Usado por                                                |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| **Ventana Invertida**           | El daño que recibe varía según su estado IA:                                                                                                | Titán de las Forjas Rotas                                |
|                                 | Esperando ×0.50, Preparando ×1.00, Atacando ×0.30                                                                                           |                                                          |
| **Penalización por Repetición** | Si el jugador repite la misma afinidad 3 veces, el enemigo gana resistencia (−25% por stack)                                                | Bestia Tronadora Elite, Guardián Terracota Elite         |
| **Reflejo Diferido**            | Mientras el enemigo "espera", acumula 40% del daño recibido (máx 200). Lo devuelve al acabar su ataque                                      | Náufrago de la Oscuridad Elite, Sentinela del Cielo Roto |
| **Escalado por Vida Jugador**   | El daño del enemigo escala según % HP del jugador: si está lleno ×1.50, si está bajo ×0.60                                                  | Paladín Marchito Elite, Coloso del Fango Viviente        |
| **Afinidad Reactiva**           | Reduce 60% el daño del elemento más usado por el jugador en los últimos golpes                                                              | Sentinela del Cielo Roto                                 |
| **Absorción de Esencia**        | Si el jugador usa la súper al 100%, el enemigo roba 30% del daño como HP. Si la usa a <100%, el enemigo queda vulnerable (+20% daño por 5s) | Oráculo Quebrado del Abismo                              |

---

## 20. Sistema de Tienda

### 20.1. Concepto

La tienda permite al jugador gastar oro para desbloquear personajes, enemigos, objetos consumibles y rúnicos. El catálogo está dividido en 4 categorías.

### 20.2. Categorías

| Categoría  | Contenido                                        | Precio                     |
| ---------- | ------------------------------------------------ | -------------------------- |
| Personajes | 8 personajes (Kael: gratis, resto: 500–1000 oro) | Según `scr_datos_clases`   |
| Enemigos   | 20 enemigos (para selección libre de combate)    | Según `scr_datos_enemigos` |
| Objetos    | 5 consumibles                                    | 50–150 oro                 |
| Rúnicos    | 6 runas                                          | 180–300 oro                |

---

## 21. Modo Torre

### 21.1. Concepto

El Modo Torre es una modalidad roguelite estilo "run" donde el jugador sube pisos enfrentando enemigos consecutivos, con HP persistente entre combates, tiendas intermedias y un jefe final en la dificultad máxima.

### 21.2. Alas (3)

| Ala         | Subtítulo         | Afinidades            | Enemigos (comunes)                                       | Jefe Final                  |
| ----------- | ----------------- | --------------------- | -------------------------------------------------------- | --------------------------- |
| Ala Oeste   | Naturaleza Bruta  | Fuego, Tierra, Planta | Soldado Ígneo, Guardián Terracota, Hálito Verde          | Titán de las Forjas Rotas   |
| Ala Este    | Elementos Etéreos | Rayo, Agua, Sombra    | Bestia Tronadora, Vigía Boreal, Náufrago de la Oscuridad | Sentinela del Cielo Roto    |
| Ala Central | Convergencia      | Luz, Arcano           | Paladín Marchito, Errante Rúnico                         | Oráculo Quebrado del Abismo |

### 21.3. Dificultades (3)

| Dificultad | Pisos | Tienda cada | HP Bonus | Oro Bonus | Élites | Jefe Final |
| ---------- | ----- | ----------- | -------- | --------- | ------ | ---------- |
| Normal     | 10    | 3 pisos     | +0%      | +0%       | No     | No         |
| Difícil    | 14    | 4 pisos     | +25%     | +25%      | Sí     | No         |
| Extremo    | 18    | 5 pisos     | +50%     | +50%      | Sí     | Sí         |

### 21.4. Flujo del Modo Torre

1. **Selección de Ala** → 2. **Selección de Dificultad** → 3. **Selección de Personaje/Arma** →
2. **Pre-combate** (equipar objetos/runa) → 5. **Combate** → 6. **Post-combate** (resumen) →
3. **Tienda de piso** (si toca) → 8. Repetir hasta victoria/derrota.

### 21.5. Características Especiales

- **HP persistente:** La vida del jugador se mantiene entre pisos (no se restaura automáticamente).
- **Racha HP alta:** Si el jugador termina pisos con ≥80% HP, acumula bonus de racha.
- **Tienda de piso:** Catálogo progresivo — al avanzar más pisos, aparecen mejores items y runas.
- **Multiplicadores de HP enemigo:** Según la dificultad, los enemigos tienen más vida.
- **Recompensa de completar ala:** Normal = 150 oro, Difícil = 350 oro, Extremo = 600 oro.

### 21.6. Tienda de Piso (Catálogo Progresivo)

| Progreso (% del total) | Items disponibles                                          |
| ---------------------- | ---------------------------------------------------------- |
| 0% (inicio)            | Poción Básica, Tónico de Defensa                           |
| ≥30%                   | + Poción Media, Tónico de Ataque                           |
| ≥40%                   | + Runa de Furia, Runa de Fortaleza, Runa de Celeridad      |
| ≥50%                   | + Elixir de Esencia                                        |
| ≥60%                   | + Runa Vampírica, Runa del Último Aliento, Runa de Cristal |

---

## 22. Configuración Global (Macros del Motor)

### 22.1. General

| Macro                | Valor | Descripción                    |
| -------------------- | ----- | ------------------------------ |
| `GAME_FPS`           | 60    | FPS del juego                  |
| `ESTADO_DUR_MAX_SEG` | 5     | Duración máxima de estados (s) |

### 22.2. Esencia

| Macro                    | Valor | Descripción                                   |
| ------------------------ | ----- | --------------------------------------------- |
| `ESENCIA_PCT_DANO`       | 0.05  | % del daño final convertido en esencia        |
| `ESENCIA_MULT_VEL`       | 0.3   | Multiplicador de velocidad para gen. esencia  |
| `ESENCIA_MULT_PODER_MAG` | 0.2   | Multiplicador de poder para gen. esencia mag. |
| `ESENCIA_CRIT_BONUS`     | 1.5   | Bonus de esencia en golpe crítico             |

### 22.3. Críticos

| Macro              | Valor | Descripción                          |
| ------------------ | ----- | ------------------------------------ |
| `CRIT_BASE_CHANCE` | 3     | Probabilidad base de crítico (%)     |
| `CRIT_ATK_DIVISOR` | 3     | Divisor de ATQ para chance extra     |
| `CRIT_POS_CHANCE`  | 5     | Chance de golpe crítico positivo (%) |
| `CRIT_POS_MULT`    | 1.50  | Multiplicador de golpe crítico       |
| `CRIT_NEG_CHANCE`  | 3     | Chance de golpe débil (%)            |
| `CRIT_NEG_MULT`    | 0.60  | Multiplicador de golpe débil         |

### 22.4. IA del Enemigo

| Macro                   | Valor | Descripción                             |
| ----------------------- | ----- | --------------------------------------- |
| `IA_ACCION_BASE_FRAMES` | 180   | Frames base entre acciones              |
| `IA_VEL_FACTOR`         | 0.12  | Factor de velocidad para reducir espera |
| `IA_PREP_FRAMES`        | 30    | Frames de preparación antes de atacar   |
| `IA_VARIACION`          | 0.15  | Variación aleatoria (±15%) en espera IA |

### 22.5. Fórmula de Daño

| Macro               | Valor | Descripción                         |
| ------------------- | ----- | ----------------------------------- |
| `FACTOR_DEF_GLOBAL` | 0.50  | Reducción de defensa en fórmula     |
| `VAR_RANGO`         | 0.15  | Rango de variación de daño (±15%)   |
| `VAR_MIN_ABS`       | 2     | Variación mínima absoluta           |
| `CDR_POR_VEL`       | 0.02  | Reducción de cooldown por velocidad |

---

## 23. Interacción de Sistemas (Actualizado)

Enemigos → Materiales → Forja → Armas → Habilidades → Combate
↑ ↓
Clases ← Afinidades ← Personalidades ← ESENCIA ←

| Sistema        | Relación                                                 |
| -------------- | -------------------------------------------------------- |
| Enemigos       | Dropean materiales al ser derrotados                     |
| Materiales     | Permiten forjar armas en la forja                        |
| Armas          | Otorgan habilidades ofensivas al personaje               |
| Habilidades    | Se usan en combate con cooldowns                         |
| Afinidades     | Activan pasivas y modifican cálculos de daño             |
| Clases         | Definen carga de Esencia y rol táctico                   |
| Personalidades | Alteran stats y determinan variante de súper             |
| ESENCIA        | Libera Súper-Habilidades como clímax del combate         |
| Objetos        | Consumibles que aportan ventaja táctica en combate       |
| Rúnicos        | Modificadores de alto riesgo/recompensa por combate      |
| Tienda         | Desbloquea contenido nuevo con oro ganado                |
| Modo Torre     | Modalidad roguelite con HP persistente y progresión      |
| Mecánicas      | Reglas especiales de élites/jefes que alteran el combate |

---

## 24. Plan de Escalado

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
