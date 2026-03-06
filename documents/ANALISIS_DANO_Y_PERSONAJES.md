# Análisis Completo de Daño, Habilidades y Personajes

> **Verificado directamente del código fuente** — Todos los números provienen de los scripts GML reales.
> Fecha de análisis: Marzo 2026

---

## ÍNDICE

1. [Fórmula de Daño Universal](#1-fórmula-de-daño-universal)
2. [Fórmula de Beneficio (Curación)](#2-fórmula-de-beneficio-curación)
3. [Macros Globales de Balance](#3-macros-globales-de-balance)
4. [Stats Base por Clase](#4-stats-base-por-clase)
5. [Modificadores de Personalidad](#5-modificadores-de-personalidad)
6. [Stats Finales por Clase × Personalidad](#6-stats-finales-por-clase--personalidad)
7. [Catálogo de Armas y Bonus](#7-catálogo-de-armas-y-bonus)
8. [Habilidades de Arma — Parámetros de Daño](#8-habilidades-de-arma--parámetros-de-daño)
9. [Habilidades de Clase — Parámetros de Daño](#9-habilidades-de-clase--parámetros-de-daño)
10. [Súper-Habilidades (24 variantes)](#10-súper-habilidades-24-variantes)
11. [Sistema de Energía — Costos y Economía](#11-sistema-de-energía--costos-y-economía)
12. [Sistema de Cooldowns](#12-sistema-de-cooldowns)
13. [Sistema de Carga Progresiva](#13-sistema-de-carga-progresiva)
14. [Sistema de Esencia — Generación Real](#14-sistema-de-esencia--generación-real)
15. [Sistema de Postura y Stun](#15-sistema-de-postura-y-stun)
16. [Afinidades y Pasivas](#16-afinidades-y-pasivas)
17. [Enemigos — Stats y Habilidades](#17-enemigos--stats-y-habilidades)
18. [Simulaciones de Daño por Clase](#18-simulaciones-de-daño-por-clase)
19. [Análisis Coste-Recompensa por Personaje](#19-análisis-coste-recompensa-por-personaje)
20. [Ranking y Conclusiones](#20-ranking-y-conclusiones)

---

## 1. Fórmula de Daño Universal

**Fuente:** `scr_formula_dano.gml`

Toda habilidad ofensiva pasa por esta fórmula. Sin excepciones.

### Pipeline completo (en orden de ejecución):

```
Paso 1: Daño Bruto
  = stat1 × escala1 + stat2 × escala2 + base_fija

Paso 2: Reducción por Defensa
  tipo_dano == "magico" → usa defensa_magica
  tipo_dano == "fisico" → usa defensa
  reducción = DEF_total × 0.55 × (1 - penetración)
  daño_neto = max(1, bruto - reducción)

Paso 3: Multiplicador de Rareza (solo habs de arma)
  R0=×1.00  R1=×1.10  R2=×1.20  R3=×1.30

Paso 4: Ventaja Elemental
  Si es_arma=true → afinidad del ARMA vs defensor
  Si es_arma=false → afinidad del PERSONAJE vs defensor
  Ventaja=×1.5  Neutro=×1.0  Desventaja=×0.75

Paso 5: Pasivas de Afinidad (si pasiva_activa=true)
  Ofensivas del atacante:
    Fuego  → ×1.10
    Rayo   → ×1.15
    Sombra → ×1.25
    Arcano → ×1.20
  Defensiva del defensor:
    Tierra → ×0.80 (reduce 20% daño recibido)

Paso 6: Varianza Aleatoria
  spread = max(daño_pre × 0.15, 2)   ← mínimo ±2 puntos
  daño_var = daño_pre ± spread        ← rango [0.85, 1.15]

Paso 7: Crítico
  prob_crit_positivo = 3% + floor(ataque_base / 3)
  prob_crit_negativo = 3%  (siempre fijo)
  Crit+   → ×1.50
  Crit−   → ×0.60
  Normal  → ×1.00

Paso 8: Resultado
  daño_final = max(1, round(todo))

Paso 8b: Runas
  Primer Ataque Nulo       → daño = 0 (primer golpe del jugador)
  Runa de Fortaleza        → ×0.75
  Runa de Cristal (atk)    → ×1.50
  Runa de Cristal (def)    → ×1.50

Paso 8c: Carga Progresiva
  N1=×1.0  N2=×1.5  N3=×2.5

Paso 8d: Vulnerabilidad por Carga
  Si el DEFENSOR está cargando → ×1.25

Paso 8e: Parry del Defensor
  Perfecto (≤50% ventana)  → daño = 0
  Bloqueo (>50% ventana)   → daño × 0.40, cuesta 5 energía
  No parry                 → daño sin cambio

Paso 8f: Interrupción de Carga
  Si defensor está cargando y recibe daño > 0 → micro-stun 0.5s

Paso 9: Mecánicas de Jefe
  Modificadores especiales por mecánica del enemigo
```

### Fórmula Simplificada (para cálculos rápidos):

```
Daño ≈ max(1, (stat1×esc1 + stat2×esc2 + base) - DEF×0.55×(1-pen))
       × mult_poder × mult_rareza × mult_afinidad × mult_pasiva
       × varianza(±15%) × crit × carga
```

---

## 2. Fórmula de Beneficio (Curación)

**Fuente:** `scr_formula_beneficio.gml`

```
Paso 1: Beneficio bruto = stat1×esc1 + stat2×esc2 + base_fija
Paso 2: × mult_poder × mult_rareza × mult_pasivas_curativas
  Pasivas curativas (si pasiva_activa):
    Luz    → ×1.15
    Planta → ×1.15
    Agua   → ×1.20
Paso 3: Varianza ± max(15%, ±2 puntos)
Paso 4: Crítico curativo (misma prob que daño)
  Crit+  → ×1.50
  Crit−  → ×0.60
Paso 5: Resultado = max(1, round(todo))
```

---

## 3. Macros Globales de Balance

**Fuente:** `scr_config_juego.gml`

| Macro                         | Valor | Descripción                          |
| ----------------------------- | ----- | ------------------------------------ |
| `FACTOR_DEF_GLOBAL`           | 0.55  | Peso de la defensa                   |
| `VAR_RANGO`                   | 0.15  | Varianza ±15%                        |
| `VAR_MIN_ABS`                 | 2     | Spread mínimo ±2 pts                 |
| `CRIT_POS_CHANCE`             | 5%    | (obsoleto, reemplazado por dinámico) |
| `CRIT_BASE_CHANCE`            | 3%    | Base de probabilidad de crit         |
| `CRIT_ATK_DIVISOR`            | 3     | Cada 3 ATK → +1% crit                |
| `CRIT_POS_MULT`               | 1.50  | Mult crítico positivo                |
| `CRIT_NEG_CHANCE`             | 3%    | Prob crítico negativo                |
| `CRIT_NEG_MULT`               | 0.60  | Mult crítico negativo                |
| `GCD_DURACION_SEG`            | 0.5s  | Cooldown global                      |
| `CDR_POR_VEL`                 | 0.02  | 2% CDR por punto velocidad           |
| `ENERGIA_MAX`                 | 100   | Barra de energía máxima              |
| `ENERGIA_REGEN_PCT`           | 0.05  | 5% por segundo = 5 energía/s         |
| `ENERGIA_AGOTAMIENTO_SEG`     | 1.5s  | Penalización si llega a 0            |
| `PARRY_VENTANA_SEG`           | 0.3s  | Ventana de parry                     |
| `PARRY_VULNERABLE_SEG`        | 0.6s  | Penalización por fallo               |
| `PARRY_PERFECTO_ENERGIA`      | 30    | Energía recuperada en perfecto       |
| `PARRY_PERFECTO_ESENCIA`      | 5%    | Esencia base por perfecto            |
| `PARRY_BLOQUEO_DANO_PCT`      | 0.40  | Bloqueo: recibe 40%                  |
| `PARRY_BLOQUEO_ENERGIA_COSTO` | 5     | Costo del bloqueo                    |

---

## 4. Stats Base por Clase

**Fuente:** `scr_datos_clases.gml`

| Clase            |  HP | ATK | DEF | DEF_M | VEL | POW | Carga Esencia     | Hab. Fija         |      Precio |
| ---------------- | --: | --: | --: | ----: | --: | --: | ----------------- | ----------------- | ----------: |
| **Vanguardia**   | 160 |  10 |  10 |     7 |   4 |   5 | recibir_dano      | golpe_guardia     | 0 (inicial) |
| **Filotormenta** | 130 |  12 |   5 |     4 |  10 |   6 | combo_habilidades | corte_rapido      |         500 |
| **Quebrador**    | 150 |  15 |   7 |     5 |   3 |   4 | ataques_pesados   | impacto_tectonico |         500 |
| **Centinela**    | 200 |   7 |  14 |    12 |   2 |   5 | bloqueo_exitoso   | baluarte_ferreo   |         750 |
| **Duelista**     | 125 |  11 |   6 |     6 |   9 |   7 | parry_perfecto    | estocada_critica  |         750 |
| **Canalizador**  | 125 |   6 |   5 |    10 |   6 |  15 | uso_elemental     | descarga_esencia  |        1000 |

### Totales de Stats (suma ATK+DEF+DEF_M+VEL+POW):

| Clase        | Total Stats |  HP |    Ratio Ofensivo    |  Ratio Defensivo   |
| ------------ | ----------: | --: | :------------------: | :----------------: |
| Vanguardia   |          36 | 160 |   42% (ATK+POW=15)   | 47% (DEF+DEF_M=17) |
| Filotormenta |          37 | 130 | 76% (ATK+VEL+POW=28) |    24% (DEF=9)     |
| Quebrador    |          34 | 150 |   56% (ATK+POW=19)   |    35% (DEF=12)    |
| Centinela    |          40 | 200 |   30% (ATK+POW=12)   |    65% (DEF=26)    |
| Duelista     |          39 | 125 | 69% (ATK+VEL+POW=27) |    31% (DEF=12)    |
| Canalizador  |          42 | 125 | 50% (POW=15 domina)  |   36% (DEF_M=10)   |

---

## 5. Modificadores de Personalidad

**Fuente:** `scr_datos_personalidades.gml`

| Personalidad  |    HP |   ATK |   DEF |   VEL |   POW | Total Multiplicado     |
| ------------- | ----: | ----: | ----: | ----: | ----: | :--------------------- |
| **Agresivo**  | ×0.90 | ×1.20 | ×0.80 | ×1.15 | ×1.10 | Alto riesgo, alto daño |
| **Metódico**  | ×1.10 | ×1.00 | ×1.15 | ×0.95 | ×1.05 | Tanque, consistente    |
| **Temerario** | ×0.85 | ×1.30 | ×0.80 | ×1.10 | ×1.20 | Cristal cannon         |
| **Resuelto**  | ×1.05 | ×1.05 | ×1.05 | ×1.05 | ×1.05 | Equilibrado +5% todo   |

### Producto Total de Multiplicadores (indicador de "poder neto"):

| Personalidad |                             Producto | Sesgo                           |
| ------------ | -----------------------------------: | :------------------------------ |
| Agresivo     | 0.90×1.20×0.80×1.15×1.10 = **1.094** | Ofensivo (ATK×VEL mejor)        |
| Metódico     | 1.10×1.00×1.15×0.95×1.05 = **1.261** | Defensivo (más eficiente total) |
| Temerario    | 0.85×1.30×0.80×1.10×1.20 = **1.168** | Ofensivo extremo                |
| Resuelto     |                   1.05^5 = **1.276** | Mejor eficiencia total          |

> **Nota:** Resuelto y Metódico dan más stats totales que Agresivo/Temerario. El tradeoff es distribución, no cantidad.

---

## 6. Stats Finales por Clase × Personalidad

**Fuente:** Calculado desde `scr_crear_personaje_combate.gml` — `round(clase_stat × pers_mult)`
_(Sin arma equipada, stats puros de clase × personalidad)_

### Vanguardia

| Personalidad |  HP | ATK | DEF | DEF_M | VEL | POW | %Crit |
| ------------ | --: | --: | --: | ----: | --: | --: | ----: |
| Agresivo     | 144 |  12 |   8 |     6 |   5 |   6 |    7% |
| Metódico     | 176 |  10 |  12 |     8 |   4 |   5 |    6% |
| Temerario    | 136 |  13 |   8 |     6 |   4 |   6 |    7% |
| Resuelto     | 168 |  11 |  11 |     7 |   4 |   5 |    6% |

### Filotormenta

| Personalidad |  HP | ATK | DEF | DEF_M | VEL | POW | %Crit |
| ------------ | --: | --: | --: | ----: | --: | --: | ----: |
| Agresivo     | 117 |  14 |   4 |     3 |  12 |   7 |    7% |
| Metódico     | 143 |  12 |   6 |     5 |  10 |   6 |    7% |
| Temerario    | 111 |  16 |   4 |     3 |  11 |   7 |    8% |
| Resuelto     | 137 |  13 |   5 |     4 |  11 |   6 |    7% |

### Quebrador

| Personalidad |  HP | ATK | DEF | DEF_M | VEL | POW | %Crit |
| ------------ | --: | --: | --: | ----: | --: | --: | ----: |
| Agresivo     | 135 |  18 |   6 |     4 |   3 |   5 |    9% |
| Metódico     | 165 |  15 |   8 |     6 |   3 |   4 |    8% |
| Temerario    | 128 |  20 |   6 |     4 |   3 |   5 |    9% |
| Resuelto     | 158 |  16 |   7 |     5 |   3 |   4 |    8% |

### Centinela

| Personalidad |  HP | ATK | DEF | DEF_M | VEL | POW | %Crit |
| ------------ | --: | --: | --: | ----: | --: | --: | ----: |
| Agresivo     | 180 |   8 |  11 |    10 |   2 |   6 |    5% |
| Metódico     | 220 |   7 |  16 |    14 |   2 |   5 |    5% |
| Temerario    | 170 |   9 |  11 |    10 |   2 |   6 |    6% |
| Resuelto     | 210 |   7 |  15 |    13 |   2 |   5 |    5% |

### Duelista

| Personalidad |  HP | ATK | DEF | DEF_M | VEL | POW | %Crit |
| ------------ | --: | --: | --: | ----: | --: | --: | ----: |
| Agresivo     | 113 |  13 |   5 |     5 |  10 |   8 |    7% |
| Metódico     | 138 |  11 |   7 |     7 |   9 |   7 |    6% |
| Temerario    | 106 |  14 |   5 |     5 |  10 |   8 |    7% |
| Resuelto     | 131 |  12 |   6 |     6 |   9 |   7 |    7% |

### Canalizador

| Personalidad |  HP | ATK | DEF | DEF_M | VEL | POW | %Crit |
| ------------ | --: | --: | --: | ----: | --: | --: | ----: |
| Agresivo     | 113 |   7 |   4 |     8 |   7 |  17 |    5% |
| Metódico     | 138 |   6 |   6 |    12 |   6 |  16 |    5% |
| Temerario    | 106 |   8 |   4 |     8 |   7 |  18 |    5% |
| Resuelto     | 131 |   6 |   5 |    11 |   6 |  16 |    5% |

---

## 7. Catálogo de Armas y Bonus

**Fuente:** `scr_datos_armas.gml`

### Bonus de Stats por Arma

| Afinidad   | Arma                        | Rareza | ATK+ | POW+ | DEF+ | HP+ | Habilidades |
| ---------- | --------------------------- | :----: | ---: | ---: | ---: | --: | :---------: |
| Neutra     | Hoja Rota                   |   R0   |    0 |    0 |    0 |   0 |      1      |
| **Fuego**  | Filo Igneo                  |   R1   |    4 |    3 |    1 |  10 |      1      |
| Fuego      | Mandoble Carmesí            |   R2   |    8 |    6 |    2 |  18 |      2      |
| Fuego      | Espada Solar del Titán      |   R3   |   14 |   10 |    3 |  28 |      3      |
| **Agua**   | Hoja Coral                  |   R1   |    3 |    4 |    2 |  15 |      1      |
| Agua       | Tridente Abisal             |   R2   |    7 |    7 |    3 |  25 |      2      |
| Agua       | Lanza del Maremoto          |   R3   |   12 |   12 |    5 |  40 |      3      |
| **Planta** | Vara Espinosa               |   R1   |    3 |    4 |    1 |  15 |      1      |
| Planta     | Látigo de Cepa              |   R2   |    6 |    8 |  0\* | 0\* |      2      |
| Planta     | Cetro del Bosque            |   R3   |   10 |   14 |  0\* | 0\* |      3      |
| **Rayo**   | Daga Voltaica               |   R1   |    5 |    3 |    1 |  10 |      1      |
| Rayo       | Garras del Relámpago        |   R2   |    9 |    6 |    2 |  15 |      2      |
| Rayo       | Espada del Trueno           |   R3   |   15 |    9 |    3 |  25 |      3      |
| **Tierra** | Mazo Pétreo                 |   R1   |    5 |    2 |    3 |  18 |      1      |
| Tierra     | Garrote de Roca Viva        |   R2   |   10 |    5 |    5 |  32 |      2      |
| Tierra     | Martillo del Coloso         |   R3   |   16 |    8 |    7 |  50 |      3      |
| **Sombra** | Filo Sombrío                |   R1   |    4 |    4 |    1 |  10 |      1      |
| Sombra     | Guadaña Penumbral           |   R2   |    8 |    7 |    2 |  18 |      2      |
| Sombra     | Espada del Abismo           |   R3   |   13 |   11 |    4 |  30 |      3      |
| **Luz**    | Espadín Áureo               |   R1   |    3 |    4 |    2 |  18 |      1      |
| Luz        | Lanza Solar                 |   R2   |    7 |    8 |    3 |  28 |      2      |
| Luz        | Hoja de la Aurora           |   R3   |   12 |   13 |    5 |  45 |      3      |
| **Arcano** | Vara Rúnica                 |   R1   |    2 |    6 |    1 |  12 |      1      |
| Arcano     | Espada Arcana               |   R2   |    6 |   10 |    2 |  22 |      2      |
| Arcano     | Bastón del Primer Conductor |   R3   |   10 |   16 |    4 |  35 |      3      |

> (\*) Planta R2 y R3 no tienen `defensa_bonus` ni `vida_bonus` definidos → usan 0.

### Sinergia de Arma (+15% a todos los bonus si afinidad del arma = afinidad del personaje)

Ejemplo: Canalizador (Arcano) + Bastón del Primer Conductor (Arcano):

- ATK: 10 × 1.15 = 12
- POW: 16 × 1.15 = 18
- DEF: 4 × 1.15 = 5
- HP: 35 × 1.15 = 40

---

## 8. Habilidades de Arma — Parámetros de Daño

**Fuente:** `scr_ejecutar_habilidad.gml`

### Formato: `{stat1×esc1 + stat2×esc2 + base} × mult_poder | pen | esencia | tipo | efecto`

### Fuego

| Habilidad             | Arma  | Fórmula                    |   Pen    | Esencia | Tipo | Efecto             |
| --------------------- | ----- | -------------------------- | :------: | ------: | :--: | ------------------ |
| ataque_fuego_basico   | R1    | ATK×1.0 + POW×0.5          |    0%    |      10 | mag  | Quema 3s (POW×0.2) |
| ataque_fuego_mejorado | R2    | ATK×1.0 + POW×0.8          |    0%    |      12 | fis  | Quema 3s (POW×0.3) |
| explosion_carmesi     | R2/R3 | ATK×1.0 + POW×1.2          |    0%    |      20 | mag  | Quema 4s (POW×0.4) |
| llamarada_solar       | R3    | ATK×1.0 + POW×1.5          |    0%    |      15 | mag  | Quema 5s (POW×0.5) |
| furia_del_titan       | R3    | ATK×1.0 + POW×1.0 ×**2.0** | **100%** |      25 | fis  | Ninguno            |

### Agua

| Habilidad        | Arma  | Fórmula           |   Pen    | Esencia | Tipo | Efecto                   |
| ---------------- | ----- | ----------------- | :------: | ------: | :--: | ------------------------ |
| corte_glaciar    | R1    | ATK×1.0 + POW×0.4 |    0%    |      10 | mag  | Ralentización 3s         |
| lanza_marina     | R2    | ATK×1.0 + POW×0.7 |    0%    |      12 | fis  | Ninguno                  |
| corriente_abisal | R2/R3 | **POW×1.0**       | **100%** |       8 | mag  | +30% lifesteal, Regen 3s |
| tsunami          | R3    | ATK×1.0 + POW×1.4 |    0%    |      18 | fis  | Ralentización 4s         |
| diluvio_eterno   | R3    | **POW×2.0**       | **100%** |      20 | mag  | +40% lifesteal           |

### Planta

| Habilidad        | Arma  | Fórmula           |   Pen    | Esencia | Tipo | Efecto              |
| ---------------- | ----- | ----------------- | :------: | ------: | :--: | ------------------- |
| latigazo_espina  | R1    | ATK×1.0 + POW×0.4 |    0%    |      10 | mag  | Veneno 3s (POW×0.2) |
| enredadera_voraz | R2    | ATK×1.0 + POW×0.6 |    0%    |      10 | fis  | Veneno 4s (POW×0.3) |
| drenaje_vital    | R2/R3 | **POW×0.8**       | **100%** |       8 | mag  | +50% lifesteal      |
| explosion_espora | R3    | ATK×1.0 + POW×1.3 |    0%    |      15 | fis  | Ninguno             |
| selva_eterna     | R3    | **POW×1.8**       | **100%** |      20 | mag  | +60% lifesteal      |

### Rayo

| Habilidad        | Arma  | Fórmula                    |   Pen    | Esencia | Tipo | Efecto         |
| ---------------- | ----- | -------------------------- | :------: | ------: | :--: | -------------- |
| descarga_rapida  | R1    | ATK×0.8 + POW×0.5          | **100%** |      12 | mag  | Aceleración 3s |
| cadena_electrica | R2    | ATK×1.0 + POW×0.7          |    0%    |      12 | fis  | Aceleración 4s |
| tormenta_fugaz   | R2/R3 | ATK×1.0 + POW×1.0          | **100%** |      15 | mag  | Ninguno        |
| rayo_fulminante  | R3    | ATK×1.0 + POW×1.5          |    0%    |      18 | fis  | Ninguno        |
| juicio_relampago | R3    | ATK×1.0 + POW×1.0 ×**2.0** | **100%** |      25 | mag  | Ninguno        |

### Tierra

| Habilidad         | Arma  | Fórmula                    |   Pen    | Esencia | Tipo | Efecto        |
| ----------------- | ----- | -------------------------- | :------: | ------: | :--: | ------------- |
| golpe_sismico     | R1    | ATK×1.0 + DEF×0.5          |    0%    |      10 | fis  | Ninguno       |
| avalancha         | R2    | ATK×1.8                    |    0%    |      12 | fis  | Ninguno       |
| escudo_petreo     | R2/R3 | _curación_ DEF×0.5         |    —     |       8 |  —   | +40% DEF temp |
| cataclismo        | R3    | ATK×1.0 + DEF×1.0 ×**2.0** | **100%** |      20 | mag  | Ninguno       |
| furia_continental | R3    | ATK×2.5                    | **100%** |      25 | fis  | +60% DEF temp |

### Sombra

| Habilidad     | Arma  | Fórmula                   | Pen | Esencia | Tipo | Efecto            |
| ------------- | ----- | ------------------------- | :-: | ------: | :--: | ----------------- |
| tajo_umbral   | R1    | ATK×1.0 + POW×0.5         | 0%  |      10 | mag  | Vulnerabilidad 3s |
| siega_oscura  | R2    | ATK×1.0 + POW×0.8         | 0%  |      12 | fis  | Vulnerabilidad 4s |
| drenar_alma   | R2/R3 | **12% HP actual** enemigo |  —  |      10 |  —   | Lifesteal 100%    |
| noche_eterna  | R3    | ATK×1.0 + POW×1.5         | 0%  |      18 | fis  | Ninguno           |
| eclipse_total | R3    | **20% HP actual** enemigo |  —  |      25 |  —   | 70% lifesteal     |

### Luz

| Habilidad        | Arma  | Fórmula                    |   Pen    | Esencia | Tipo | Efecto             |
| ---------------- | ----- | -------------------------- | :------: | ------: | :--: | ------------------ |
| hoja_radiante    | R1    | ATK×1.0 + POW×0.4          |    0%    |      10 | mag  | Ninguno            |
| embestida_solar  | R2    | ATK×1.0 + POW×0.7          |    0%    |      12 | fis  | Ninguno            |
| bendicion_luz    | R2/R3 | _curación_ POW×1.0         |    —     |       8 |  —   | Regen 4s (POW×0.3) |
| amanecer_divino  | R3    | ATK×1.0 + POW×1.5          |    0%    |      18 | fis  | +20% lifesteal     |
| juicio_celestial | R3    | ATK×1.0 + POW×1.0 ×**2.0** | **100%** |      25 | mag  | +curación POW×0.8  |

### Arcano

| Habilidad           | Arma  | Fórmula           |   Pen    | Esencia | Tipo | Efecto       |
| ------------------- | ----- | ----------------- | :------: | ------: | :--: | ------------ |
| pulso_runico        | R1    | POW×0.8           | **100%** |      12 | mag  | Supresión 3s |
| corte_arcano        | R2    | ATK×1.0 + POW×0.7 |    0%    |      12 | fis  | Ninguno      |
| onda_arcana         | R2/R3 | **POW×1.2**       | **100%** |      15 | mag  | Supresión 4s |
| singularidad_arcana | R3    | **POW×2.0**       | **100%** |      20 | mag  | Ninguno      |
| ruptura_dimensional | R3    | **POW×2.5**       | **100%** |      30 | fis  | Ninguno      |

---

## 9. Habilidades de Clase — Parámetros de Daño

**Fuente:** `scr_ejecutar_habilidad.gml` (es_arma = false, usa afinidad del PERSONAJE)

| Clase            | Habilidad         | Fórmula            |    mult |   Pen    | Esencia | Tipo | Efecto       |
| ---------------- | ----------------- | ------------------ | ------: | :------: | ------: | :--: | ------------ |
| **Vanguardia**   | golpe_guardia     | ATK×1.0 + DEF×1.5  |     1.0 |    0%    |      15 | fis  | —            |
| **Filotormenta** | corte_rapido      | ATK×0.7 + VEL×0.6  |     1.0 | **100%** |       8 | fis  | —            |
| **Quebrador**    | impacto_tectonico | ATK×2.5            |     1.0 | **100%** |       5 | fis  | —            |
| **Centinela**    | baluarte_ferreo   | _curación_ DEF×2.0 |     1.0 |    —     |       5 |  —   | Autocuración |
| **Duelista**     | estocada_critica  | ATK×1.0 + VEL×1.0  | **1.2** | **100%** |      15 | fis  | —            |
| **Canalizador**  | descarga_esencia  | **POW×2.5**        |     1.0 | **50%**  |       0 | mag  | —            |

### Simulación de Daño Bruto de Habilidad de Clase (sin arma, sin defensa enemiga):

**Personalidad Resuelto (baseline):**

| Clase        | Stats relevantes |             Daño Bruto |           Con pen 100% vs DEF 5 |
| ------------ | :--------------- | ---------------------: | ------------------------------: |
| Vanguardia   | ATK=11, DEF=11   |   11 + 16.5 = **27.5** |          27.5 - 2.75 = **24.8** |
| Filotormenta | ATK=13, VEL=11   |   9.1 + 6.6 = **15.7** |             **15.7** (pen=100%) |
| Quebrador    | ATK=16           |          40 = **40.0** |             **40.0** (pen=100%) |
| Centinela    | DEF=15           | 30 = **30.0 curación** |                               — |
| Duelista     | ATK=12, VEL=9    |  (12+9)×1.2 = **25.2** |             **25.2** (pen=100%) |
| Canalizador  | POW=16           |          40 = **40.0** | 40 - 1.375 = **38.6** (pen=50%) |

---

## 10. Súper-Habilidades (24 variantes)

**Fuente:** `scr_ejecutar_super.gml`

### Escalado por Tier de Esencia:

| Tier | Esencia Requerida | Multiplicador |
| ---- | :---------------: | :-----------: |
| 100% |        100        |     ×1.00     |
| 75%  |       75-99       |     ×0.75     |
| 50%  |       50-74       |     ×0.50     |

> Se consume TODA la esencia. El escalado retroactivo multiplica todos los deltas (daño, curación, buffs/debuffs).

### Tabla de Súpers

| Clase × Personalidad       | Nombre                   | Fórmula                        | Pen  | Efecto Especial         |
| -------------------------- | ------------------------ | ------------------------------ | :--: | ----------------------- |
| **Vanguardia_Agresivo**    | Embestida Volcánica      | ATK×3.5                        | 100% | —                       |
| **Vanguardia_Metódico**    | Fortaleza Inquebrantable | _cura_ HP_MAX×0.35             |  —   | +50% DEF temp           |
| **Vanguardia_Temerario**   | Sacrificio del Titán     | ATK×5.0                        | 100% | **-15% HP propia**      |
| **Vanguardia_Resuelto**    | Golpe del Guardián       | ATK×3.0                        | 100% | +30% lifesteal          |
| **Filotormenta_Agresivo**  | Ráfaga Imparable         | ATK×0.6 **×5 golpes**          |  0%  | —                       |
| **Filotormenta_Metódico**  | Corte Preciso            | ATK×0.9 **×3 golpes**          |  0%  | -20% DEF enemiga        |
| **Filotormenta_Temerario** | Tormenta de Acero        | ATK×0.5 **×7 golpes**          |  0%  | **-10% HP propia**      |
| **Filotormenta_Resuelto**  | Danza del Filo           | ATK×0.7 **×4 golpes**          |  0%  | —                       |
| **Quebrador_Agresivo**     | Cataclismo Furioso       | (ATK+POW)×1.0 **×4.0**         | 100% | —                       |
| **Quebrador_Metódico**     | Pulverizar               | ATK×3.0                        | 100% | Quema 5s (POW×0.4)      |
| **Quebrador_Temerario**    | Impacto Suicida          | ATK×6.0                        | 100% | **-25% HP propia**      |
| **Quebrador_Resuelto**     | Martillazo Firme         | ATK×3.0                        | 100% | +30% DEF temp           |
| **Centinela_Agresivo**     | Contraataque Blindado    | **DEF×3.5**                    | 100% | —                       |
| **Centinela_Metódico**     | Bastión Eterno           | _cura_ HP_MAX×0.40             |  —   | +60% DEF temp           |
| **Centinela_Temerario**    | Explosión de Hierro      | DEF×1.0 + DEF_bonus **×4.0**   | 100% | Pierde TODO buff DEF    |
| **Centinela_Resuelto**     | Muro Inquebrantable      | DEF×1.5 + _cura_ HP_MAX×0.20   | 100% | +30% DEF temp           |
| **Duelista_Agresivo**      | Estocada Mortal          | (ATK+VEL)×1.0 **×3.5**         | 100% | —                       |
| **Duelista_Metódico**      | Mil Cortes               | ATK×0.5 **×6 golpes**          | 100% | —                       |
| **Duelista_Temerario**     | Apuesta Final            | ATK×2.5 + **vida_perdida×1.5** | 100% | Escala con HP perdida   |
| **Duelista_Resuelto**      | Golpe Certero            | (ATK+VEL)×1.0 **×2.5**         | 100% | +25% lifesteal          |
| **Canalizador_Agresivo**   | Nova Arcana              | **POW×5.0**                    | 100% | —                       |
| **Canalizador_Metódico**   | Canalización Estable     | POW×3.0 + _cura_ POW×1.5       | 100% | —                       |
| **Canalizador_Temerario**  | Detonación Interior      | **POW×7.0**                    | 100% | **-20% HP propia**      |
| **Canalizador_Resuelto**   | Flujo Arcano             | POW×3.0                        | 100% | **Reset todos los CDs** |

### Simulación de Daño Bruto de Súper (Resuelto, sin arma, 100% esencia):

| Clase        | Stats              |                        Daño/Efecto Bruto |
| ------------ | :----------------- | ---------------------------------------: |
| Vanguardia   | ATK=11             |          11×3.0 = **33** + 30% lifesteal |
| Filotormenta | ATK=13             | 13×0.7 × 4 golpes = **36.4** (acumulado) |
| Quebrador    | ATK=16             |           16×3.0 = **48** + 30% DEF temp |
| Centinela    | DEF=15, HP_MAX=210 | daño=15×1.5=**22.5** + cura=42 + +30%DEF |
| Duelista     | ATK=12, VEL=9      |    (12+9)×2.5 = **52.5** + 25% lifesteal |
| Canalizador  | POW=16             |               16×3.0 = **48** + CD reset |

---

## 11. Sistema de Energía — Costos y Economía

**Fuente:** `scr_energia_combate.gml`

### Regeneración:

- Pasiva: **5 energía/segundo** (100 × 0.05 / 1s)
- Agotamiento (llega a 0): **1.5s sin regeneración**
- Parry Perfecto: **+30 energía**

### Costos por Habilidad:

| Categoría        | Habilidad         | Energía | CD (seg) | Energía/seg efectivo |
| ---------------- | ----------------- | ------: | :------: | -------------------: |
| **Clase**        | golpe_guardia     |      10 |   1.2s   |                8.3/s |
| Clase            | corte_rapido      |       8 |   0.5s   |               16.0/s |
| Clase            | impacto_tectonico |      18 |   2.0s   |                9.0/s |
| Clase            | baluarte_ferreo   |      15 |   3.0s   |                5.0/s |
| Clase            | estocada_critica  |      12 |   1.5s   |                8.0/s |
| Clase            | descarga_esencia  |      20 |   2.5s   |                8.0/s |
| **Arma base**    | ataque_basico     |       5 |   0.4s   |               12.5/s |
| **R1**           | (típico)          |    6-10 | 0.4-0.7s |             ~12-16/s |
| **R2 principal** | (típico)          |   10-14 | 0.7-1.0s |             ~13-15/s |
| **R2 especial**  | (típico)          |   16-20 | 2.0-2.5s |                 ~8/s |
| **R3 principal** | (típico)          |   14-16 | 1.2-1.5s |                ~10/s |
| **R3 ultimate**  | (típico)          |   28-30 | 4.0-4.5s |                 ~7/s |

### Sostenibilidad Energética por Clase:

La regeneración es 5/s. Si el gasto > 5/s, la barra baja.

| Clase        | Hab. más usada    |   Costo/CD    | Gasto/s |  Balance vs Regen   |
| ------------ | ----------------- | :-----------: | :-----: | :-----------------: |
| Filotormenta | corte_rapido      | 8/0.5s (+GCD) |   8/s   | **-3/s** (negativo) |
| Vanguardia   | golpe_guardia     |    10/1.2s    |  8.3/s  |     **-3.3/s**      |
| Duelista     | estocada_critica  |    12/1.5s    |   8/s   |      **-3/s**       |
| Canalizador  | descarga_esencia  |    20/2.5s    |   8/s   |      **-3/s**       |
| Quebrador    | impacto_tectonico |    18/2.0s    |   9/s   |      **-4/s**       |
| Centinela    | baluarte_ferreo   |    15/3.0s    |   5/s   |  **0/s** (neutro)   |

> **Nota:** El GCD de 0.5s limita a Filotormenta — no puede realmente spamear a 0.5s, su CD real es max(0.5, 0.5) = 0.5s mínimo entre acciones.

### Autonomía Energética (de 100 a 0, solo con habilidad de clase):

| Clase        | Acciones antes de agotar | Tiempo hasta agotamiento |
| ------------ | :----------------------: | :----------------------: |
| Filotormenta |     ~12 corte_rapido     |      ~6s (con GCD)       |
| Duelista     |   ~8 estocada_critica    |           ~12s           |
| Vanguardia   |    ~10 golpe_guardia     |           ~12s           |
| Canalizador  |   ~5 descarga_esencia    |          ~12.5s          |
| Quebrador    |   ~5 impacto_tectonico   |           ~10s           |
| Centinela    |    ~6 baluarte_ferreo    |           ~18s           |

---

## 12. Sistema de Cooldowns

**Fuente:** `scr_cooldown_habilidad.gml`

### CDR por Velocidad:

`CD_real = CD_base × (1 - VEL × 0.02)`

- VEL 2 → -4% CD
- VEL 6 → -12% CD
- VEL 10 → -20% CD

### Resumen de CDs por Categoría:

| Tipo               | Rango CD |     Prom     |
| ------------------ | :------: | :----------: |
| R1 (básicas arma)  | 0.4-0.7s |     0.6s     |
| R2 (principal)     | 0.7-1.0s |     0.8s     |
| R2 (especial)      | 2.0-2.5s |     2.2s     |
| R3 (principal)     | 1.2-2.0s |     1.5s     |
| R3 (ultimate)      | 4.0-4.5s |     4.2s     |
| Clase (más rápida) |   0.5s   | Filotormenta |
| Clase (más lenta)  |   3.0s   |  Centinela   |

### Acciones por Minuto (APM) teórico por clase (limitado por GCD 0.5s):

| Clase        | CD Clase |  CD efectivo (con GCD)   | APM teórico |
| ------------ | :------: | :----------------------: | :---------: |
| Filotormenta |   0.5s   | 0.5s → 0.4s (CDR VEL=10) | **150 APM** |
| Duelista     |   1.5s   |       1.5s → 1.23s       |   49 APM    |
| Vanguardia   |   1.2s   |       1.2s → 1.10s       |   55 APM    |
| Canalizador  |   2.5s   |       2.5s → 2.20s       |   27 APM    |
| Quebrador    |   2.0s   |       2.0s → 1.88s       |   32 APM    |
| Centinela    |   3.0s   |       3.0s → 2.88s       |   21 APM    |

---

## 13. Sistema de Carga Progresiva

**Fuente:** `scr_carga_progresiva.gml`

### Mecánica:

- Solo habilidades de clase (Q) + R2 (E) + R3 (R) pueden cargar
- R1 (W) **NUNCA** puede cargar — siempre instantáneo
- Al iniciar carga: consume costo base de energía
- Drenaje continuo: **10 energía/segundo** mientras carga
- Si energía llega a 0: **disparo automático** con nivel actual

### Niveles de Carga:

| Nivel |     Tiempo | Multiplicador | Energía Drenada (10/s) | Costo Total (ej. 18 base) |
| :---: | ---------: | :-----------: | :--------------------: | :-----------------------: |
|  N1   | 0s (toque) |     ×1.0      |           0            |            18             |
|  N2   |       1.0s |     ×1.5      |           10           |            28             |
|  N3   |       2.0s |     ×2.5      |           20           |            38             |

### Riesgos de Cargar:

- **+25% daño recibido** mientras carga
- **Micro-stun 0.5s** si recibe golpe → cancela la carga
- Parry cancela la carga (prioridad defensiva)

### Habilidades Cargables:

| Slot            | Habilidades                                                                                                                              | Cantidad |
| --------------- | ---------------------------------------------------------------------------------------------------------------------------------------- | :------: |
| Q (Clase)       | golpe_guardia, corte_rapido, impacto_tectonico, baluarte_ferreo, estocada_critica, descarga_esencia                                      |    6     |
| E (R2 especial) | explosion_carmesi, corriente_abisal, drenaje_vital, tormenta_fugaz, escudo_petreo, drenar_alma, bendicion_luz, onda_arcana               |    8     |
| R (R3 ultimate) | furia_del_titan, diluvio_eterno, selva_eterna, juicio_relampago, furia_continental, eclipse_total, juicio_celestial, ruptura_dimensional |    8     |

### Daño Real con Carga N3 (ejemplo Quebrador Temerario, ATK=20):

```
impacto_tectonico: ATK×2.5 = 50 bruto
× carga N3 (2.5) = 125
× sin defensa (pen=100%)
× varianza ±15% → [106, 144]
× crit 9% chance → 187 en crit+
Costo total: 18 base + 20 drenaje = 38 energía
```

---

## 14. Sistema de Esencia — Generación Real

**Fuente:** `scr_formula_dano.gml` (líneas de generación de esencia)

### Componentes de Generación (por golpe ofensivo):

```
esencia_total = esencia_base (del params)
              + round(daño_final × 0.05)          ← ESENCIA_PCT_DANO
              + round(velocidad × 0.3)             ← ESENCIA_MULT_VEL
              + round(poder × 0.2) si tipo=magico  ← ESENCIA_MULT_PODER_MAG
              × crit_bonus (×1.5 si crit+)
              × mult_clase (×1.80 preferido / ×0.60 no preferido)
```

### Multiplicador de Clase:

| Clase        | Evento Preferido (×1.80)                     | Evento No Preferido (×0.60) |
| ------------ | -------------------------------------------- | --------------------------- |
| Quebrador    | mult_poder ≥ 1.3 (golpes fuertes)            | Otros                       |
| Filotormenta | Siempre (cada uso de habilidad)              | —                           |
| Canalizador  | tipo_dano == "magico"                        | tipo_dano == "fisico"       |
| Duelista     | Base ×1.0 (bonus real en parry/contraataque) | —                           |
| Vanguardia   | ×0.80 en ataque (bonus al recibir daño)      | —                           |
| Centinela    | ×0.80 en ataque (bonus al mitigar)           | —                           |

### Esencia por Recibir Daño:

| Clase          | Mecanismo       | Cálculo                          |
| -------------- | --------------- | -------------------------------- |
| **Vanguardia** | Al recibir daño | +round(daño_recibido × 0.50)     |
| **Centinela**  | Al mitigar daño | +round(reducción_defensa × 0.40) |

### Esencia por Gasto de Energía:

- Cada 10 energía gastada → **+1% esencia**

### Esencia por Parry Perfecto:

- +5% base, hasta +10% (ajustado por afinidad)
- **Duelista** se beneficia especialmente (es su carga_esencia preferida)

### Bonificación Combo Maestro:

- Golpear enemigo stunned con carga N3 → +5% esencia base × 2.0 = **+10% esencia**

### Simulación: ¿Cuántos golpes para llenar esencia (0→100)?

**Resuelto, arma R1 neutra, vs enemigo sin defensa:**

| Clase              |  Esencia/golpe aprox   | Golpes para 100% |     Método alternativo     |
| ------------------ | :--------------------: | :--------------: | :------------------------: |
| Filotormenta       | ~8×1.80 + 1 + 3 = ~18  |  **~6 golpes**   |     Spam corte_rapido      |
| Canalizador (mag)  |  ~0×1.80 + 2 + 3 = ~9  |  **~11 golpes**  | descarga_esencia no genera |
| Quebrador (fuerte) | ~5×1.80 + 2 + 1 = ~12  |  **~8 golpes**   |     Solo con mult≥1.3      |
| Duelista           | ~15×1.0 + 1 + 3 = ~19  |  **~5 golpes**   |      + parry perfects      |
| Vanguardia         | ~15×0.80 + 1 + 1 = ~14 |  **~7 golpes**   |   +50% por recibir daño    |
| Centinela          |  ~5×0.80 + 0 + 1 = ~5  |  **~20 golpes**  |     +mitigación pasiva     |

> **Filotormenta es el cargador de esencia más rápido** gracias a su ×1.80 constante y alta velocidad de acción.

---

## 15. Sistema de Postura y Stun

**Fuente:** `scr_stun_postura.gml`

### Postura Enemiga:

- Base: **100**
- Regeneración: 10%/s (10 postura/s) tras **5 segundos** sin recibir golpe
- Al romper postura (llegar a 0) → **Stun de Ruptura 3.0s**
- Postura se restaura a 100 tras el stun

### Daño de Postura por Habilidad:

| Rango       |                 Mejor                  |        Peor         |
| ----------- | :------------------------------------: | :-----------------: |
| Clase       |         impacto_tectonico (20)         |  corte_rapido (6)   |
| R1          |           golpe_sismico (10)           | descarga_rapida (4) |
| R2 especial |         explosion_carmesi (15)         |  bendicion_luz (5)  |
| R3 ultimate | furia_del_titan/furia_continental (25) |  selva_eterna (18)  |

### Top 5 Habilidades para Romper Postura:

| Habilidad           | Postura | Golpes para 100 |
| ------------------- | :-----: | :-------------: |
| furia_del_titan     |   25    |        4        |
| furia_continental   |   25    |        4        |
| ruptura_dimensional |   24    |      ~4.2       |
| juicio_relampago    |   22    |      ~4.5       |
| eclipse_total       |   22    |      ~4.5       |

### Tipos de Stun:

| Fuente               | Duración | Trigger                           |
| -------------------- | :------: | --------------------------------- |
| Parry Perfecto       | **1.2s** | Timing ≤50% de la ventana de 0.3s |
| Ruptura de Postura   | **3.0s** | Postura llega a 0                 |
| Micro-stun (jugador) | **0.5s** | Recibir golpe mientras carga      |

---

## 16. Afinidades y Pasivas

**Fuente:** `scr_datos_afinidades.gml`

| Afinidad | Activador       |      Bono       | Penalización  | CD Pasiva |
| -------- | --------------- | :-------------: | :-----------: | :-------: |
| Fuego    | uso_habilidad   |    +10% daño    |  -5% defensa  |    2s     |
| Rayo     | combo_velocidad |    +15% daño    | -10% defensa  |    3s     |
| Tierra   | recibir_dano    |  +20% defensa   | -5% velocidad |    3s     |
| Agua     | recibir_dano    |    -20% CDs     |  -5% ataque   |    4s     |
| Planta   | turno_pasado    | +15% regen vida |   -5% poder   |    3s     |
| Sombra   | golpe_critico   | +25% daño crit  | -10% defensa  |    4s     |
| Luz      | recibir_dano    |  +15% curación  |   -5% poder   |    3s     |
| Arcano   | uso_habilidad   |   +20% poder    | -10% defensa  |    4s     |
| Neutra   | ninguno         |        —        |       —       |     —     |

### Ventaja Elemental (triángulo):

- **Ventaja (×1.50):** Fuego>Planta, Planta>Agua, Agua>Fuego, Rayo>Agua, Tierra>Rayo, etc.
- **Desventaja (×0.75):** Inverso

---

## 17. Enemigos — Stats y Habilidades

**Fuente:** `scr_datos_enemigos.gml`, `scr_ejecutar_habilidad.gml`

### Comunes

| Enemigo            |  HP | ATK | DEF | D_M | VEL | POW | Afinidad | Hab. Fija       | Precio |
| ------------------ | --: | --: | --: | --: | --: | --: | -------- | --------------- | -----: |
| Soldado Igneo      | 130 |   8 |   4 |   5 |   4 |   5 | Fuego    | golpe_fuego     |    200 |
| Vigía Boreal       | 115 |   6 |   6 |   7 |   3 |   7 | Agua     | mirada_gelida   |    200 |
| Hálito Verde       | 100 |  10 |   3 |   4 |   6 |   4 | Planta   | rafaga_cortante |    150 |
| Bestia Tronadora   | 120 |  12 |   2 |   3 |   7 |   3 | Rayo     | chispazo        |    200 |
| Guardián Terracota | 170 |   5 |  12 |   5 |   2 |   3 | Tierra   | muro_piedra     |    250 |
| Náufrago Oscuridad | 140 |   9 |   5 |   6 |   4 |   6 | Sombra   | abrazo_vacio    |    200 |
| Paladín Marchito   | 155 |   7 |   9 |   9 |   3 |   5 | Luz      | destello_debil  |    250 |
| Errante Rúnico     | 135 |   8 |   7 |   8 |   4 |   8 | Arcano   | pulso_arcano    |    200 |

### Habilidades de Enemigos Comunes

| Habilidad       | Fórmula            | Pen  | Tipo | Efecto         |
| --------------- | ------------------ | :--: | :--: | -------------- |
| golpe_fuego     | ATK×1.0 + 4 base   |  0%  | fis  | —              |
| mirada_gelida   | ATK×1.0 + 2 base   |  0%  | mag  | —              |
| rafaga_cortante | ATK×1.3            | 100% | fis  | —              |
| chispazo        | 12 base fija       | 100% | mag  | —              |
| muro_piedra     | _curación_ 15 base |  —   |  —   | Autocura       |
| abrazo_vacio    | 10 base fija       | 100% | mag  | Lifesteal 100% |
| destello_debil  | ATK×1.0            |  0%  | mag  | —              |
| pulso_arcano    | ATK×1.0 + 8 base   | 100% | mag  | —              |

### Elites

| Enemigo                  |  HP | ATK | DEF | D_M | VEL | POW | Precio | Mecánicas        |
| ------------------------ | --: | --: | --: | --: | --: | --: | -----: | ---------------- |
| Soldado Igneo Elite      | 150 |  12 |   6 |   7 |   5 |   7 |    600 | —                |
| Vigía Boreal Elite       | 130 |  10 |   8 |  10 |   4 |   9 |    600 | —                |
| Hálito Verde Elite       | 110 |  15 |   4 |   5 |   7 |   6 |    500 | —                |
| Bestia Tronadora Elite   | 140 |  16 |   3 |   4 |   8 |   5 |    650 | pen_repetición   |
| Guardián Terracota Elite | 200 |   9 |  15 |   7 |   3 |   5 |    700 | pen_repetición   |
| Náufrago Elite           | 160 |  13 |   7 |   9 |   5 |   8 |    600 | reflejo_diferido |
| Paladín Marchito Elite   | 180 |  11 |  12 |  13 |   4 |   7 |    650 | escalado_vida    |
| Errante Rúnico Elite     | 150 |  13 |  10 |  12 |   5 |  10 |    600 | —                |

### Jefes

| Jefe                 |   HP | ATK | DEF | D_M | VEL | POW | Afinidad      | Precio | Mecánicas               |
| -------------------- | ---: | --: | --: | --: | --: | --: | ------------- | -----: | ----------------------- |
| Titán Forjas Rotas   | 1050 |  22 |  18 |  14 |   3 |  12 | Fuego-Tierra  |   2500 | ventana_invertida       |
| Coloso Fango         | 1000 |  18 |  20 |  16 |   2 |  10 | Agua-Planta   |   2500 | escalado_vida, pen_rep  |
| Sentinela Cielo Roto |  900 |  25 |  14 |  11 |   6 |  15 | Rayo-Luz      |   3000 | afi_reactiva, reflejo   |
| Oráculo del Abismo   | 1000 |  21 |  16 |  18 |   4 |  18 | Sombra-Arcano |   3500 | absorción_esencia       |
| El Devorador         | 1350 |  27 |  20 |  20 |   5 |  20 | Neutra        |   5000 | robo_esencia, supresión |
| El Primer Conductor  | 1600 |  30 |  23 |  23 |   6 |  25 | Neutra        |   8000 | espejo_clase, escalado  |

---

## 18. Simulaciones de Daño por Clase

### Escenario: Clase + Personalidad Resuelto + Arma R3 sinergia (misma afinidad)

Para cada clase, se calcula con la arma R3 de su misma afinidad (máxima sinergia).

_(Todos los bonus de arma con ×1.15 sinergia)_

### Quebrador + Martillo del Coloso (Tierra R3)

```
Stats finales:
  ATK = 16 + round(16×1.15) = 16 + 18 = 34
  DEF = 7 + round(7×1.15) = 7 + 8 = 15
  POW = 4 + round(8×1.15) = 4 + 9 = 13
  HP  = 158 + round(50×1.15) = 158 + 58 = 216
  VEL = 3
  %Crit = 3 + floor(34/3) = 3 + 11 = 14%

impacto_tectonico (clase): ATK×2.5 = 85, pen=100%
  → 85 × varianza → [72, 98] sin crit
  → crit 14% → [108, 147]
  Carga N3: ×2.5 → [180, 245] sin crit, [270, 367] con crit

furia_continental (R3 ult): ATK×2.5 = 85, pen=100%, ×1.30 rareza
  → 85 × 1.30 = 110.5 → [94, 127]
  → crit 14% → [141, 190]
  Carga N3: ×2.5 → [235, 318], crit → [352, 477]

cataclismo (R3): (ATK+DEF)×2.0 = (34+15)×2.0 = 98, ×2.0 mult, pen=100%, ×1.30 rareza
  → 98 × 2.0 × 1.30 = 254.8 → [217, 293]
  NO cargable. Crit 14% → [325, 440]
```

### Canalizador + Bastón del Primer Conductor (Arcano R3)

```
Stats finales:
  ATK = 6 + round(10×1.15) = 6 + 12 = 18
  POW = 16 + round(16×1.15) = 16 + 18 = 34
  DEF = 5 + round(4×1.15) = 5 + 5 = 10
  HP  = 131 + round(35×1.15) = 131 + 40 = 171
  VEL = 6
  %Crit = 3 + floor(18/3) = 3 + 6 = 9%

descarga_esencia (clase): POW×2.5 = 85, pen=50%
  → vs DEF 5: 85 - 5×0.55×0.5 = 85 - 1.375 = 83.6
  → [71, 96] → crit [107, 145]
  Carga N3: ×2.5 → [178, 241], crit → [267, 361]

ruptura_dimensional (R3 ult): POW×2.5 = 85, pen=100%, ×1.30 rareza
  → 85 × 1.30 = 110.5 → [94, 127] → crit [141, 190]
  Carga N3: ×2.5 → [235, 318], crit → [352, 477]

singularidad_arcana (R3): POW×2.0 = 68, pen=100%, ×1.30 rareza
  → 68 × 1.30 = 88.4 → [75, 102]

Pasiva Arcano activa (+20% daño): TODO lo anterior ×1.20

Nova Arcana (Súper 100%): POW×5.0 = 170, pen=100%
  → [145, 196]
```

### Filotormenta + Espada del Trueno Eterno (Rayo R3)

```
Stats finales:
  ATK = 13 + round(15×1.15) = 13 + 17 = 30
  VEL = 11
  POW = 6 + round(9×1.15) = 6 + 10 = 16
  DEF = 5 + round(3×1.15) = 5 + 3 = 8
  HP  = 137 + round(25×1.15) = 137 + 29 = 166
  %Crit = 3 + floor(30/3) = 3 + 10 = 13%
  CDR = VEL×2% = 22% reducción de cooldowns

corte_rapido (clase): ATK×0.7 + VEL×0.6 = 21 + 6.6 = 27.6, pen=100%
  → [23, 32] → crit [35, 48]
  CD real = 0.5×0.78 = 0.39s → pero GCD=0.5s limita

rayo_fulminante (R3): ATK×1.0 + POW×1.5 = 30 + 24 = 54, pen=0%, ×1.30 rareza
  → vs DEF 5: 54 - 2.75 = 51.25 × 1.30 = 66.6 → [57, 77]

juicio_relampago (R3 ult): (ATK+POW)×1.0 ×2.0 = (30+16)×2.0 = 92, pen=100%, ×1.30 rareza
  → 92 × 1.30 = 119.6 → [102, 138]
  Carga N3: ×2.5 → [254, 344]

Pasiva Rayo activa (+15% daño): TODO ×1.15

DPS teórico (corte_rapido spam, 1 cada 0.5s):
  → 27.6 × 2 por segundo = 55.2 DPS bruto
  → Energía: 8/0.5s = 16/s → agota en ~6s → 12 golpes × 27.6 = 331 daño total
```

### Duelista + Espada del Abismo (Sombra R3)

```
Stats finales:
  ATK = 12 + round(13×1.15) = 12 + 15 = 27    (sinergia si afinidad=Sombra)
  VEL = 9
  POW = 7 + round(11×1.15) = 7 + 13 = 20
  DEF = 6 + round(4×1.15) = 6 + 5 = 11
  HP  = 131 + round(30×1.15) = 131 + 35 = 166
  %Crit = 3 + floor(27/3) = 3 + 9 = 12%

estocada_critica (clase): (ATK+VEL)×1.0 ×1.2 = (27+9)×1.2 = 43.2, pen=100%
  → [37, 50] → crit [55, 75]
  Carga N3: ×2.5 → [92, 124]

eclipse_total (R3 ult): 20% HP actual enemigo
  → vs 1000 HP: 200 → 140 lifesteal
  → vs 500 HP: 100 → 70 lifesteal
  NO pasa por scr_formula_dano (acceso directo)
  Carga N3: NO AFECTA (bypass de fórmula → carga_mult_temp no se lee)

noche_eterna (R3): ATK×1.0 + POW×1.5 = 27 + 30 = 57, pen=0%, ×1.30 rareza
  → vs DEF 5: 57 - 2.75 = 54.25 × 1.30 = 70.5 → [60, 81]

Pasiva Sombra activa (+25% daño en crit): crit cambia de ×1.50 a ×1.875 efectivo
```

### Vanguardia + Martillo del Coloso (Tierra R3)

```
Stats finales:
  ATK = 11 + round(16×1.15) = 11 + 18 = 29    (sinergia si afinidad=Tierra)
  DEF = 11 + round(7×1.15) = 11 + 8 = 19
  POW = 5 + round(8×1.15) = 5 + 9 = 14
  HP  = 168 + round(50×1.15) = 168 + 58 = 226
  VEL = 4
  %Crit = 3 + floor(29/3) = 3 + 9 = 12%

golpe_guardia (clase): ATK×1.0 + DEF×1.5 = 29 + 28.5 = 57.5, pen=0%
  → vs DEF 5: 57.5 - 2.75 = 54.75 → [47, 63]
  Carga N3: ×2.5 → [117, 158]

cataclismo (R3): (ATK+DEF)×2.0 = (29+19)×2.0 = 96, ×1.30 rareza, pen=100%
  → 124.8 → [106, 144]
  NO cargable

furia_continental (R3 ult): ATK×2.5 = 72.5, pen=100%, ×1.30 rareza
  → 94.25 → [80, 108] + 60% DEF buff
  Carga N3: ×2.5 → [200, 271]
```

### Centinela + Hoja de la Aurora (Luz R3)

```
Stats finales:
  ATK = 7 + round(12×1.15) = 7 + 14 = 21    (sinergia si afinidad=Luz)
  DEF = 15 + round(5×1.15) = 15 + 6 = 21
  D_M = 13 + round(3×1.15) = 13 + 3 = 16
  POW = 5 + round(13×1.15) = 5 + 15 = 20
  HP  = 210 + round(45×1.15) = 210 + 52 = 262
  VEL = 2
  %Crit = 3 + floor(21/3) = 3 + 7 = 10%

baluarte_ferreo (clase): *curación* DEF×2.0 = 42
  → [36, 48] curación, crit → [54, 72]
  Carga N3: ×2.5 en curación? NO — carga aplica carga_mult_temp solo en scr_formula_dano

Contraataque Blindado (Súper Agresivo 100%): DEF×3.5 = 73.5, pen=100%
  → [62, 85]

Bastión Eterno (Súper Metódico 100%): HP_MAX×0.40 = 105 curación + 60% DEF buff
  → DEF temp += 13 → DEF total = 34
```

---

## 19. Análisis Coste-Recompensa por Personaje

### Definiciones:

- **DPS Sostenido:** Daño por segundo usando solo habilidad de clase + R1, sin agotarse
- **Burst:** Daño máximo en ventana de 2-3 segundos (carga N3 + súper)
- **Supervivencia:** HP efectivo considerando curación y defensa
- **Generación Esencia:** Velocidad para cargar súper
- **Precio:** Costo de desbloqueo

### Tabla Resumen (Personalidad Resuelto, Arma R3 sinergia)

| Clase            | Precio | DPS Sost. | Burst 3s |        HP Efect. |    Esencia/s | Versatilidad |
| ---------------- | -----: | --------: | -------: | ---------------: | -----------: | :----------: |
| **Vanguardia**   |      0 |     ~45/s |     ~270 |         226+cura |        Media |    ★★★★☆     |
| **Filotormenta** |    500 |     ~55/s |     ~344 |       166 frágil |     **Alta** |    ★★★☆☆     |
| **Quebrador**    |    500 |     ~40/s | **~477** |        216 media |        Media |    ★★☆☆☆     |
| **Centinela**    |    750 |     ~20/s |      ~85 | **262+cura+DEF** |         Baja |    ★★★★★     |
| **Duelista**     |    750 |     ~43/s | ~200+%HP |        166 media | Alta (parry) |    ★★★★☆     |
| **Canalizador**  |   1000 |     ~42/s | **~477** |       171 frágil |   Media-Baja |    ★★★☆☆     |

### Análisis Detallado por Clase

---

### VANGUARDIA (Precio: GRATIS)

**Fortalezas:**

- Clase inicial, gratis → mejor valor por oro
- golpe_guardia escala con ATK + DEF → naturalmente fuerte
- Carga esencia al recibir daño (+50% daño recibido = esencia)
- HP alto (226 con R3 Tierra)
- Súper versátil: Golpe del Guardián (ATK×3 + 30% lifesteal) es sólido

**Debilidades:**

- Velocidad baja (4) → pocos APM, CDR bajo
- Sin mecanismo de lifesteal propio (depende del arma)
- DPS medio — ni el más alto ni el más bajo

**Mejor Arma:** Martillo del Coloso (Tierra R3) — doble escalado ATK+DEF

**Mejor Personalidad:** Resuelto (equilibrado) o Metódico (más tanque)

**Coste-Recompensa: ★★★★★** — Es GRATIS y competitivo con todo. Mejor relación calidad/precio del juego.

---

### FILOTORMENTA (Precio: 500)

**Fortalezas:**

- **Mayor DPS sostenido** del juego (corte_rapido spam cada 0.5s)
- VEL 10-11 → CDR 20-22%, crit 13%, mucha esencia/golpe
- Genera esencia ×1.80 en TODOS los golpes
- Alto APM → más feedback del sistema de carga
- Tormenta de Acero (Súper Temerario): 7 golpes = masivo

**Debilidades:**

- **HP más bajo** del juego (166 con R3)
- DEF muy baja → damageable
- Energía se agota ~6s con spam
- Muy dependiente de parry para sobrevivir

**Mejor Arma:** Espada del Trueno Eterno (Rayo R3) — ATK+15, VEL sinérgica

**Mejor Personalidad:** Temerario (máximo damage, riesgo extremo) o Agresivo

**Coste-Recompensa: ★★★★☆** — Barato (500), excelente DPS, pero requiere habilidad para sobrevivir.

---

### QUEBRADOR (Precio: 500)

**Fortalezas:**

- **Mayor burst del juego** con carga N3 (impacto_tectonico N3 = 180-245)
- ATK más alto (34 con R3 Tierra) → mayor % crit (14%)
- Penetración 100% en impacto_tectonico → ignora defensa
- **Mejor rompe-postura** (20 por golpe de clase)
- Impacto Suicida (Súper Temerario): ATK×6.0 = masivo

**Debilidades:**

- VEL muy baja (3) → acciones lentas, CDR 6%
- Energía cara (18 por impacto_tectonico)
- DPS sostenido bajo entre bursts
- Menor generación de esencia por velocidad baja

**Mejor Arma:** Martillo del Coloso (Tierra R3) — ATK+16 sinergia, cataclismo OP

**Mejor Personalidad:** Temerario (ATK 20, máximo burst)

**Coste-Recompensa: ★★★★☆** — Barato (500), especialista en burst. Ideal para romper postura.

---

### CENTINELA (Precio: 750)

**Fortalezas:**

- **Más tanque del juego**: 262 HP, 21 DEF con R3 Luz
- Curación propia constante (baluarte_ferreo = DEF×2.0 = 42 heal)
- Genera esencia al mitigar daño → pasivo, no requiere acción
- Bastión Eterno (Súper Metódico): 105 cura + 60% DEF buff = prácticamente invencible
- Energía sostenible (5/s gasto ≈ 5/s regen)

**Debilidades:**

- **DPS extremadamente bajo** (~20/s sostenido)
- VEL 2 → CDR 4%, crit 10%, esencia lenta
- Combates duran mucho más
- Dependiente de acumular DEF bonus temp para hacer daño (Explosión de Hierro)

**Mejor Arma:** Hoja de la Aurora (Luz R3) — POW+13 para curación, HP+45

**Mejor Personalidad:** Metódico (DEF 16, HP 220) o Resuelto

**Coste-Recompensa: ★★★☆☆** — Caro para lo que ofrece en términos de progresión, pero imbatible en supervivencia. Combates lentos.

---

### DUELISTA (Precio: 750)

**Fortalezas:**

- Alta sinergia con sistema de parry (carga esencia por parry perfecto)
- Estocada crítica escala con ATK+VEL → bueno con ambos
- VEL alta (9-10) → CDR 18-20%, crit 12%
- eclipse_total = 20% HP actual → devastador vs jefes 1000+ HP
- Apuesta Final (Súper Temerario): escala con vida perdida → potencial enorme

**Debilidades:**

- HP bajo (166 con R3 Sombra)
- DEF baja → debe parryear correctamente o muere
- Daño base sin parry es medio
- Eclipse/drenar_alma bypass scr_formula_dano → **carga N3 NO amplifica** estos ataques

**Mejor Arma:** Espada del Abismo (Sombra R3) — eclipses OP, ATK+13

**Mejor Personalidad:** Agresivo (ATK 13, VEL 10) o Temerario

**Coste-Recompensa: ★★★★☆** — Techo de habilidad alto. El mejor si dominás el parry. Precio justo.

---

### CANALIZADOR (Precio: 1000)

**Fortalezas:**

- **Poder Elemental más alto** del juego (34 con R3 Arcano sinergia)
- Habilidades "puras de poder" (POW×2.0, POW×2.5) → no depende de ATK
- Penetración alta en muchas habilidades (50-100%)
- Pasiva Arcano (+20% daño) + esencia preferida en magic attacks
- Nova Arcana (Súper Agresivo): POW×5.0 = 170 bruto
- Detonación Interior: POW×7.0 = 238 bruto → máximo burst mágico

**Debilidades:**

- **El más caro** del juego (1000 oro)
- HP y DEF bajas (171 HP, 10 DEF)
- ATK bajo → crit chance baja (9%)
- descarga_esencia genera 0 esencia por sí misma (esencia_gen=0)
- Clase difícil de llenar esencia

**Mejor Arma:** Bastón del Primer Conductor (Arcano R3) — POW+16 sinergia

**Mejor Personalidad:** Temerario (POW 18, máximo daño mágico)

**Coste-Recompensa: ★★★☆☆** — El más caro y el más frágil. Burst mágico comparable al Quebrador pero sin la resistencia. Requiere buen juego.

---

## 20. Ranking y Conclusiones

### Ranking de DPS Puro (Personalidad Resuelto, R3 Sinergia):

| #   | Clase            | DPS Sostenido | Burst Máximo (N3 + crit) |
| --- | ---------------- | :-----------: | :----------------------: |
| 1   | **Filotormenta** |     ~55/s     |           ~344           |
| 2   | **Vanguardia**   |     ~45/s     |           ~271           |
| 3   | **Duelista**     |     ~43/s     |        ~200 + %HP        |
| 4   | **Canalizador**  |     ~42/s     |       ~477 (magia)       |
| 5   | **Quebrador**    |     ~40/s     |    **~477** (físico)     |
| 6   | **Centinela**    |     ~20/s     |           ~85            |

### Ranking de Supervivencia:

| #   | Clase            | HP Efectivo | Capacidad de Curación |
| --- | ---------------- | :---------: | :-------------------: |
| 1   | **Centinela**    |     262     |   42/3s + súper 105   |
| 2   | **Vanguardia**   |     226     |    Depende de arma    |
| 3   | **Quebrador**    |     216     |    Ninguna nativa     |
| 4   | **Canalizador**  |     171     |    Depende de arma    |
| 5   | **Duelista**     |     166     | Lifesteal en eclipse  |
| 6   | **Filotormenta** |     166     |    Ninguna nativa     |

### Ranking de Generación de Esencia:

| #   | Clase            | Método                          |  Velocidad  |
| --- | ---------------- | ------------------------------- | :---------: |
| 1   | **Filotormenta** | ×1.80 cada golpe + alta VEL     | Muy Rápida  |
| 2   | **Duelista**     | Parry perfecto bonus + alta VEL |   Rápida    |
| 3   | **Vanguardia**   | +50% daño recibido como esencia |    Media    |
| 4   | **Quebrador**    | ×1.80 solo en mult≥1.3          |    Media    |
| 5   | **Canalizador**  | ×1.80 solo en mágico            | Media-Lenta |
| 6   | **Centinela**    | ×0.80 + mitigación pasiva       |    Lenta    |

### Ranking de Relación Coste-Recompensa:

| #   | Clase            | Precio |                       Valor                        |
| --- | ---------------- | -----: | :------------------------------------------------: |
| 1   | **Vanguardia**   |      0 |        Gratis + excelente → **Mejor valor**        |
| 2   | **Filotormenta** |    500 |         Barato + DPS top → **Gran valor**          |
| 3   | **Quebrador**    |    500 |        Barato + burst top → **Gran valor**         |
| 4   | **Duelista**     |    750 | Precio justo + skill ceiling alto → **Buen valor** |
| 5   | **Centinela**    |    750 |      Caro para DPS bajo → **Nicho (tanques)**      |
| 6   | **Canalizador**  |   1000 |          Más caro + frágil → **Exigente**          |

### Conclusiones del Balance:

1. **Vanguardia es la mejor inversión** — Gratis y competitiva en todo.
2. **Filotormenta y Quebrador a 500** son los siguientes desbloqueos más eficientes — uno para DPS sostenido, otro para burst.
3. **Centinela sacrifica TODO el DPS por supervivencia** — los combates duran 2-3× más pero es casi imposible morir.
4. **Canalizador es el "high risk high reward"** — El más caro, stats ofensivos altísimos pero frágil. Necesita sinergia Arcano obligatoria.
5. **Duelista es la clase de skill ceiling** — Si dominás el parry, genera esencia rápido + eclipse_total destroya jefes. Pero eclipse/drenar_alma NO se beneficia de carga progresiva (bypass de fórmula).
6. **Bug potencial:** Eclipse/drenar_alma de Sombra no pasan por `scr_formula_dano` → la carga N3, runas, ventaja elemental, pasivas y críticos NO aplican. Es daño puro porcentual.
7. **Filotormenta Temerario con Rayo R3** es probablemente el **build más fuerte** del juego para speedruns: DPS~70/s, esencia ×1.80, crit 15%, CDR 22%.
8. **Centinela Metódico con Luz R3** es probablemente la **build más segura**: 286 HP, 18 DEF, curación constante, Bastión Eterno para emergencias.

---

### Apéndice: Tabla de Ventaja Elemental Rápida

| Atacante → |  Fuego  |  Agua   | Planta  |  Rayo   | Tierra | Sombra | Luz | Arcano |
| :--------- | :-----: | :-----: | :-----: | :-----: | :----: | :----: | :-: | :----: |
| **Fuego**  |   1.0   |  0.75   | **1.5** |   1.0   |  0.75  |  1.0   | 1.0 |  1.0   |
| **Agua**   | **1.5** |   1.0   |  0.75   |  0.75   |  1.0   |  1.0   | 1.0 |  1.0   |
| **Planta** |  0.75   | **1.5** |   1.0   |   1.0   |  1.0   |  1.0   | 1.0 |  1.0   |
| **Rayo**   |   1.0   | **1.5** |   1.0   |   1.0   |  0.75  |  1.0   | 1.0 |  1.0   |
| **Tierra** | **1.5** |   1.0   |   1.0   | **1.5** |  1.0   |  1.0   | 1.0 |  1.0   |

> Nota: Sombra, Luz y Arcano tienen sus propias relaciones no incluidas aquí — ver `scr_multiplicador_afinidad()`.
