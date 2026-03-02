# ARCADIUM — Guía Visual de Sprites

> Referencia para la creación de sprites de personajes jugables, enemigos y jefes.
> Fecha: Marzo 2026

---

## Notas Generales de Estilo

- **Perspectiva:** Vista lateral estática (jugador a la izquierda, enemigo a la derecha).
- **Estilo artístico:** Pixel art o estilizado 2D. Mundo en ruinas, tonos oscuros con acentos elementales vibrantes.
- **Poses necesarias por personaje:** Idle, ataque, recibir daño, habilidad especial, súper-habilidad, muerte/derrota.
- **Poses necesarias por enemigo:** Idle, ataque, recibir daño, habilidad especial, muerte.
- **Escala sugerida:** Personajes jugables ~64–80px de alto. Enemigos comunes similares. Élites ligeramente mayores. Jefes ~120–160px.

---

# PARTE 1 — PERSONAJES JUGABLES (8)

---

## 1. KAEL — Vanguardia · Fuego · Resuelto

### Concepto

Guerrero equilibrado y confiable. Es el primer personaje disponible, por lo que su diseño debe ser icónico y accesible. Evoca la imagen del "héroe clásico" pero con un toque de ceniza y brasa.

### Complexión y Silueta

- **Estatura:** Media-alta, proporciones heroicas estándar.
- **Complexión:** Atlética pero no excesivamente musculosa. Porte firme y seguro.
- **Silueta clave:** Hombros anchos, postura erguida y equilibrada, piernas plantadas con firmeza.

### Vestimenta y Armadura

- **Armadura media** de placas oxidadas con bordes rojos/naranjas. Aspecto de metal que ha visto muchas batallas.
- **Pechera** con grabados de llamas desgastados. Hombreras asimétricas (una más grande que la otra).
- **Capa corta** que cae por un solo hombro, de tela oscura con bordes chamuscados.
- **Guantes pesados** y botas reforzadas con detalles de metal ennegrecido.
- **Cinturón ancho** con hebilla de emblema de fuego.

### Paleta de Colores

- **Primarios:** Rojo oscuro (#8B1A1A), naranja apagado (#CC5500), gris carbón (#3C3C3C).
- **Acentos:** Brasa anaranjada/amarilla, detalles dorados oxidados.
- **Piel:** Tono moreno cálido.
- **Cabello:** Negro con reflejos cobrizos.

### Rostro y Expresión

- Rostro angular pero no afilado. Mandíbula marcada.
- **Ojos:** Ámbar/anaranjados, mirada firme y decidida (personalidad Resuelto).
- **Cabello:** Corto-medio, ligeramente despeinado hacia atrás, como si el calor lo mantuviera en esa forma.
- **Cicatriz leve** en la mejilla o ceja (opcional, marca la historia de combate).
- Expresión: Determinación calmada, ni agresivo ni pasivo.

### Arma por Defecto

- **Hoja Rota:** Espada corta con filo mellado y hoja agrietada. Aspecto de arma que ha sobrevivido mucho.

### Efectos Elementales

- Pequeñas brasas/chispas de fuego flotando alrededor en idle.
- Al atacar, rastros de llama en el arco del arma.
- Pasiva activa: brillo incandescente momentáneo en el cuerpo.

### Notas para el Sprite

- Al ser el primer personaje, debe ser el más "legible" visualmente.
- Su pose idle debe transmitir confianza y estabilidad.
- Contraste claro entre la armadura oscura y los acentos de fuego.

---

## 2. LYS — Filotormenta · Rayo · Agresivo

### Concepto

Luchadora ultrarrápida y agresiva. Encarna la velocidad del rayo y la ferocidad. Silueta esbelta y dinámica, como si estuviera siempre a punto de atacar.

### Complexión y Silueta

- **Estatura:** Media, más baja que Kael.
- **Complexión:** Delgada y fibrosa, musculatura de velocista. Cero volumen innecesario.
- **Silueta clave:** Inclinada hacia adelante, peso en la parte delantera, postura agresiva y tensa.

### Vestimenta y Armadura

- **Armadura ultraligera:** Protecciones mínimas de metal conductivo/plateado solo en antebrazos y espinillas.
- **Traje ajustado** de tela técnica oscura (negro/azul oscuro) que permite libertad total de movimiento.
- **Bufanda larga** o cinta eléctrica que flota detrás de ella, con destellos de electricidad estática.
- **Sin capa.** Todo en ella está diseñado para la velocidad.
- **Botas ligeras** con suelas reforzadas, diseñadas para impulso rápido.

### Paleta de Colores

- **Primarios:** Azul eléctrico (#0080FF), negro profundo (#1A1A2E), plateado (#C0C0C0).
- **Acentos:** Destellos amarillo-eléctrico (#FFD700), blanco brillante.
- **Piel:** Tono claro, casi pálido por la electricidad constante.
- **Cabello:** Blanco plateado con puntas azul eléctrico.

### Rostro y Expresión

- Rostro afilado, facciones estilizadas y angulares.
- **Ojos:** Azul eléctrico intenso, casi brillantes. Mirada agresiva y desafiante (personalidad Agresivo).
- **Cabello:** Corto por un lado, largo por el otro (asimétrico), siempre con mechones levantados por la estática.
- Expresión: Sonrisa confiada/desafiante, como si disfrutara del combate.

### Arma por Defecto

- **Hoja Rota:** En sus manos parece más una daga improvisada que una espada, sujetada con agarre invertido.

### Efectos Elementales

- Arcos eléctricos corriendo por su cuerpo y bufanda en idle.
- Al atacar: estelas de relámpago, movimiento "borroso" por velocidad.
- Pasiva activa: campo eléctrico visible rodeándola.

### Notas para el Sprite

- Transmitir velocidad incluso en la pose estática (inclinación, líneas de acción).
- La bufanda eléctrica es su elemento visual más distintivo.
- Sus ataques deben sentirse "rápidos": pocos frames, alto impacto visual.

---

## 3. TORVAN — Quebrador · Tierra · Metódico

### Concepto

Coloso imparable. El golpe más fuerte del grupo. Enorme, lento, devastador. Diseño inspirado en golem/gladiador con elementos de roca y jade.

### Complexión y Silueta

- **Estatura:** El más alto y grande del grupo.
- **Complexión:** Extremadamente musculoso y ancho. Brazos enormes, tórax como barril.
- **Silueta clave:** Cuadrada y maciza. Hombros más anchos que la cabeza por mucho. Piernas gruesas como pilares.

### Vestimenta y Armadura

- **Armadura pesada parcial:** Gran hombrera de roca/jade en un hombro, pechera de placas de piedra grabada.
- **Brazos parcialmente descubiertos** mostrando musculatura con venas de mineral/jade incrustadas en la piel.
- **Falda de combate** (tipo gladiador romano) de cuero reforzado con placas de piedra.
- **Cinturón masivo** con cadenas rotas colgando.
- **Pies descalzos o con sandalias pesadas** — conectado a la tierra.
- **Vendajes** en antebrazos y nudillos, manchados de polvo de roca.

### Paleta de Colores

- **Primarios:** Marrón tierra (#8B7355), verde jade (#00A86B), gris piedra (#808080).
- **Acentos:** Detalles de jade brillante, marrón oscuro, dorado terroso.
- **Piel:** Tono oscuro/bronceado, aspecto curtido por el sol y la piedra.
- **Cabello:** Rapado o muy corto, negro.

### Rostro y Expresión

- Rostro cuadrado y ancho. Mandíbula maciza, nariz ancha.
- **Ojos:** Verde jade, mirada calculadora y paciente (personalidad Metódico).
- **Cabello:** Rapado con tatuajes/grabados en el cráneo que parecen runas de tierra.
- **Barba corta** o perilla recortada cuidadosamente (reflejo de lo metódico).
- Expresión: Calma absoluta, concentración silenciosa.

### Arma por Defecto

- **Hoja Rota:** Sujeta con una mano como si fuera un cuchillo de mantequilla. Se nota que necesita algo más grande.

### Efectos Elementales

- Pequeñas piedras/guijarros flotando alrededor de sus pies en idle.
- Al atacar: grietas en el suelo, polvo de roca, impactos sísmicos.
- Pasiva activa: capa de roca/jade formándose sobre la piel como armadura natural.

### Notas para el Sprite

- Debe ser notablemente más grande que los demás personajes.
- Cada animación de ataque debe sentirse PESADA (anticipación larga, impacto brutal).
- Las incrustaciones de jade en su piel son su elemento visual más distintivo.

---

## 4. MAELIS — Centinela · Luz · Metódico

### Concepto

Protectora sagrada. La fortaleza viviente del grupo. Diseño inspirado en paladín/templaria con estética de catedral fracturada y luz dorada.

### Complexión y Silueta

- **Estatura:** Alta, segundo personaje más alto.
- **Complexión:** Robusta y proporcionada, constitución atlética-fuerte. No delgada, no excesivamente musculosa.
- **Silueta clave:** Rectangular y imponente por la armadura. Gran escudo integrado en el diseño como parte de su silueta.

### Vestimenta y Armadura

- **Armadura completa pesada** de estilo templario, blanca y dorada pero agrietada y reparada.
- **Pechera con grabado de sol/estrella** parcialmente borrado, reminiscencia de una orden sagrada caída.
- **Hombreras grandes simétricas** con forma de arco de catedral.
- **Escudo integrado en el brazo izquierdo** — circular/torre, con símbolo de luz agrietado.
- **Falda de armadura larga** hasta las rodillas con tassets de placas.
- **Capa larga blanca** con borde dorado, raída en los extremos inferiores.
- **Casco abierto tipo corona** o tiara metálica que deja ver el rostro.

### Paleta de Colores

- **Primarios:** Blanco marfil (#FFFFF0), dorado (#FFD700), gris perla (#D3D3D3).
- **Acentos:** Azul cielo claro, toques de ámbar.
- **Piel:** Tono medio/oliva.
- **Cabello:** Rubio dorado, largo y recogido en trenza baja.

### Rostro y Expresión

- Rostro ovalado, facciones finas pero no delicadas. Porte noble.
- **Ojos:** Dorados/ámbar, mirada serena y analítica (personalidad Metódico).
- **Cabello:** Rubio dorado, largo, recogido en trenza funcional que cae por un hombro.
- **Marca luminosa** sutil en la frente (como un tercer ojo apagado, marca de Conductor de Luz).
- Expresión: Serenidad inquebrantable, compasión controlada.

### Arma por Defecto

- **Hoja Rota:** Sujeta detrás del escudo como arma de respaldo, secundaria a su defensa.

### Efectos Elementales

- Aura dorada tenue rodeándola en idle, más intensa cerca del escudo.
- Al defender: destellos de luz, runas sagradas apareciendo brevemente.
- Pasiva activa: halo de luz formándose sobre su cabeza.

### Notas para el Sprite

- El escudo debe ser un elemento visual dominante en su silueta.
- La armadura agrietada pero funcional cuenta una historia visual.
- Los efectos de luz deben ser cálidos (dorados), no fríos (blancos puros).

---

## 5. SAREN — Duelista · Sombra · Resuelto

### Concepto

Espadachín de las sombras, preciso y letal. Elegante como un esgrimista, mortífero como un asesino. Diseño inspirado en mosquetero/espadachín oscuro con estética de sombras y vacío.

### Complexión y Silueta

- **Estatura:** Media, complexión estilizada.
- **Complexión:** Delgado pero fibroso, musculatura de esgrimista. Proporciones elegantes.
- **Silueta clave:** Vertical y estilizada, una mano extendida con elegancia, la otra sujetando el arma en posición de guardia lateral.

### Vestimenta y Armadura

- **Sin armadura pesada.** Gabardina/abrigo largo de cuero negro que llega hasta los tobillos, abierta por delante.
- **Chaleco ajustado** de tela oscura con bordados violeta/gris que recuerdan a constelaciones apagadas.
- **Guantes largos de cuero** hasta el codo, el derecho con refuerzo metálico en los dedos.
- **Pantalones ajustados** metidos en botas altas de cuero con tacón sutil.
- **Cinturón diagonal** del hombro a la cadera con funda de espada.
- **Máscara opcional** — media máscara que cubre la parte inferior del rostro, o bufanda oscura.

### Paleta de Colores

- **Primarios:** Negro profundo (#0D0D0D), violeta oscuro (#301934), gris grafito (#36454F).
- **Acentos:** Púrpura sombra (#7B2D8E), plateado apagado.
- **Piel:** Pálida, casi etérea, como si la sombra le hubiera drenado algo de color.
- **Cabello:** Negro azabache, liso y largo hasta los hombros.

### Rostro y Expresión

- Rostro estrecho, pómulos altos, facciones afiladas y aristocráticas.
- **Ojos:** Violeta oscuro, mirada penetrante pero controlada (personalidad Resuelto).
- **Cabello:** Negro liso, partido al medio, enmarcando el rostro.
- **Ojeras leves** — aspecto de alguien que ha pasado mucho tiempo en la oscuridad.
- Expresión: Calma fría, resolución silenciosa. Ni sonríe ni frunce el ceño.

### Arma por Defecto

- **Hoja Rota:** Sujetada como un estoque, en posición de esgrima clásica a pesar de ser un arma mellada.

### Efectos Elementales

- Sombras espesas ondulando a sus pies como humo oscuro en idle.
- Al atacar: rastros de sombra negra/violeta siguiendo el filo, como tinta en agua.
- Pasiva activa: su silueta se fragmenta momentáneamente (efecto "afterimage" de sombra).

### Notas para el Sprite

- La elegancia es clave. Cada pose debe verse fluida y controlada.
- La gabardina larga da mucho juego de animación (ondear, abrir, etc.).
- Las sombras a sus pies son su firma visual más importante.

---

## 6. NERYA — Canalizador · Arcano · Metódico

### Concepto

Maga erudita del conocimiento arcano. Maestra de las energías elementales puras. Diseño inspirado en hechicera/erudita con estética de observatorio destruido y fractales de energía.

### Complexión y Silueta

- **Estatura:** Media-baja, la más baja del grupo.
- **Complexión:** Esbelta, proporción delicada. Aspecto de académica más que de guerrera.
- **Silueta clave:** Vertical y contenida, manos cerca del cuerpo o levantadas canalizando energía. El bastón/vara como extensión de su silueta.

### Vestimenta y Armadura

- **Sin armadura.** Túnica/vestido largo de hechicera en tonos oscuros y violeta.
- **Capa con capucha** ornamentada con runas brillantes que se encienden al canalizar.
- **Hombreras de tela reforzada** con glifos arcanos grabados.
- **Cinturón con bolsas y frascos** — aspecto de investigadora/alquimista.
- **Guantes sin dedos** con runas tatuadas directamente en la piel.
- **Botas suaves/sandalias** de hechicera, nada pesado.
- **Joyas mínimas:** Un broche de cristal fracturado en el cuello de la capa que brilla con energía arcana.

### Paleta de Colores

- **Primarios:** Violeta profundo (#4B0082), azul medianoche (#191970), negro.
- **Acentos:** Cian arcano (#00FFFF), magenta energético (#FF00FF), blanco estrella.
- **Piel:** Clara con un leve tinte azulado/etéreo (efecto de la exposición arcana prolongada).
- **Cabello:** Azul oscuro/índigo, largo y flotante como si la gravedad lo afectara menos.

### Rostro y Expresión

- Rostro ovalado, facciones delicadas y jóvenes pero con mirada vieja/sabia.
- **Ojos:** Heterocromía — un ojo cian, otro violeta (marca del dominio arcano). Brillan al canalizar.
- **Cabello:** Largo hasta media espalda, suelto pero con aspecto etéreo/flotante.
- **Marcas de runas** que aparecen en la piel del rostro cuando usa poderes.
- Expresión: Concentración intelectual, curiosidad analítica (personalidad Metódico).

### Arma por Defecto

- **Hoja Rota:** Flota a su lado sostenida por energía arcana en vez de ser sujetada con la mano.

### Efectos Elementales

- Glifos/runas arcanas flotando y rotando lentamente a su alrededor en idle.
- Al atacar: explosiones geométricas de energía, fractales luminosos.
- Pasiva activa: ojos que brillan intensamente, pelo completamente flotante, runas cubriendo sus brazos.

### Notas para el Sprite

- Es la más "mágica" visualmente. Priorizar efectos de partículas arcanas.
- El cabello flotante y los ojos heterocromáticos la hacen instantáneamente reconocible.
- Sus animaciones deben tener gestos de manos (canalizar, dirigir energía) más que movimientos de arma.

---

## 7. THALYS — Centinela · Agua · Temerario

### Concepto

Guardián acuático blindado que se lanza al combate con una audacia imprudente a pesar de su papel defensivo. Es un tanque que protege con la ferocidad del mar embravecido, no con cautela.

### Complexión y Silueta

- **Estatura:** Alta, más alto que Kael, similar a Torvan.
- **Complexión:** Fornido y amplio, con musculatura de defensor pesado. Cuerpo robusto pero no tosco — equilibrio entre fuerza y resistencia.
- **Silueta clave:** Postura ligeramente inclinada hacia adelante (temerario), escudo al frente, peso firme en las piernas.

### Vestimenta y Armadura

- **Armadura pesada** de placas con textura de coral endurecido y metal tratado con agua de mar. Tono azul-verdoso oxidado.
- **Pechera masiva** con grabados de olas estilizadas. Protección completa en torso y hombros.
- **Escudo integrado** en el brazo izquierdo — no lo lleva aparte, es una extensión de la armadura. Forma de concha marina curva con borde afilado.
- **Hombreras amplias** con formas orgánicas (conchas, coral), asimétricas.
- **Capa corta trasera** de tela empapada, como si siempre estuviera mojada, con algas adheridas en los bordes.
- **Botas blindadas** con pequeñas formaciones de coral/percebes incrustados.

### Paleta de Colores

- **Primarios:** Azul profundo (#003366), verde mar (#2E8B57), gris acero marino (#708090).
- **Acentos:** Cian espuma (#00CED1), blanco perla (#FAFAFA), coral naranja oxidado.
- **Piel:** Tono pálido con reflejos azulados, como alguien que vive bajo el agua.
- **Cabello:** Corto, oscuro húmedo, azul-negro (#1C2526), siempre con apariencia de mojado.

### Rostro y Expresión

- Rostro ancho con mandíbula fuerte, nariz ancha.
- **Ojos:** Azul oscuro profundo, mirada desafiante y temeraria — ojos con un brillo de imprudencia.
- **Cabello:** Corto y echado hacia atrás, pegado a la cabeza como mojado permanentemente.
- **Barba corta** recortada, con gotas de agua congeladas como pequeñas perlas.
- Expresión: Sonrisa desafiante, como quien disfruta antes de una batalla peligrosa.

### Arma por Defecto

- **Escudo-Concha:** Escudo pesado con forma orgánica de concha de mar endurecida, filo cortante en el borde, usado tanto para defender como para golpear.

### Efectos Elementales

- Gotas de agua flotando alrededor en idle, pequeñas burbujas ascendentes.
- Al atacar, salpicaduras de agua de alta presión y olas cortas.
- Pasiva activa: su armadura brilla con un resplandor de agua profunda, como luz submarina.

### Notas para el Sprite

- Debe verse como un muro viviente del océano — intimidante pero imprudente.
- El contraste entre su rol defensivo (armadura masiva) y su personalidad temeraria (postura agresiva) es clave.
- Los detalles marinos (coral, conchas, algas) deben ser sutiles, no abrumadores.

---

## 8. BRENN — Quebrador · Planta · Agresivo

### Concepto

Guerrero brutal de las selvas corrompidas, un berserker de la naturaleza que canaliza el poder destructivo de la flora salvaje. Rompe al enemigo con fuerza aplastante vegetal.

### Complexión y Silueta

- **Estatura:** Media-alta, complexión masiva.
- **Complexión:** Extremadamente musculoso, el más corpulento del roster junto con Torvan. Músculos abultados con raíces y corteza creciendo sobre la piel.
- **Silueta clave:** Postura agresiva, hombros elevados, cuerpo ligeramente encorvado como a punto de cargar, puños apretados.

### Vestimenta y Armadura

- **Armadura ligera/media** de corteza de árbol vivo y cuero endurecido. La "armadura" es parcialmente orgánica — la corteza crece directamente sobre su piel.
- **Pechera** de corteza gruesa con grietas por donde se ven raíces pulsantes verde brillante. Sin hombreras convencionales — tiene formaciones de madera petrificada naturales.
- **Brazos:** En gran parte expuestos, cubiertos de tatuajes tribales verdes que son en realidad enredaderas vivas grabadas en la piel. Puños envueltos en vendas de fibra vegetal.
- **Cinturón de raíces** tejidas, con esporas luminosas colgando como trofeos.
- **Piernas parcialmente cubiertas** por corteza y cuero. Pies envueltos en raíces que se agarran al suelo.
- **Sin capa.** Todo su aspecto es primitivo y bestial.

### Paleta de Colores

- **Primarios:** Verde oscuro (#006400), marrón corteza (#5C4033), verde musgo (#4A5D23).
- **Acentos:** Verde neón de savia (#39FF14), amarillo esporas (#ADFF2F), rojo burdeos en tatuajes de ira.
- **Piel:** Morena oscura/bronceada, parcialmente verde por la simbiosis con la planta.
- **Cabello:** Dreads o rastas gruesas con enredaderas y hojas entrelazadas, verde-marrón.

### Rostro y Expresión

- Rostro ancho y primitivo, mandíbula cuadrada prominente, cejas gruesas.
- **Ojos:** Verde brillante intenso, casi luminiscente, pupilas más pequeñas de lo normal — mirada salvaje.
- **Cabello:** Rastas pesadas que caen hacia los lados y atrás, con hojas pequeñas y brotes creciendo entre ellas.
- **Marca facial:** Líneas de savia verde que recorren desde la frente hasta la barbilla, parecen pintura de guerra pero son orgánicas.
- Expresión: Agresión pura, enseñando los dientes, ceño fruncido permanente.

### Arma por Defecto

- **Mazo de Raíz:** Garrote masivo hecho de una raíz petrificada arrancada del suelo. Irregular, con nudos y espinas naturales. Más primitivo que forjado.

### Efectos Elementales

- Pequeñas esporas, hojas y pétalos flotando a su alrededor en idle.
- Al atacar, explosión de astillas de madera y hojas, el suelo se agrieta con raíces.
- Pasiva activa: raíces brotando brevemente del suelo bajo sus pies, cuerpo cubierto de un brillo verde savia.

### Notas para el Sprite

- Es el personaje más "salvaje" y bestial visualmente. Primitivo y feroz.
- Contraste entre la brutalidad del Quebrador y la estética natural de Planta.
- Los elementos vegetales deben parecer agresivos (espinas, corteza agrietada, savia tóxica), no decorativos.
- Las rastas con vegetación y los tatuajes de savia verde lo hacen reconocible al instante.

---

# PARTE 2 — ENEMIGOS COMUNES (8)

> Cada enemigo común representa una afinidad. Son combatientes regulares de las ruinas de Arcadium, corrompidos o atrapados. Tamaño similar a los personajes jugables.

---

## 1. SOLDADO ÍGNEO — Fuego

### Concepto

Guerrero de las forjas volcánicas destruidas, eternamente ardiendo. Un soldado atrapado entre la vida y la muerte por el fuego que consume su armadura.

### Apariencia

- **Cuerpo:** Humanoide acorazado de estatura media. Armadura de placas fundidas y parcialmente derretidas. El metal gotea magma en las juntas.
- **Cabeza:** Yelmo cerrado con visor en T. Desde dentro emana un brillo anaranjado como si su rostro fuera pura brasa.
- **Brazos:** El brazo del arma está envuelto en llamas bajas. El otro brazo tiene la armadura fundida al cuerpo.
- **Piernas:** Grebas pesadas con grietas por las que sale luz de magma.
- **Arma:** Espada ancha con filo de roca volcánica al rojo vivo.

### Paleta de Colores

- Metal oscuro ennegrecido (#2D2D2D), rojo magma (#FF4500), naranja brasa (#FF8C00), amarillo incandescente en las grietas.

### Animación Clave

- **Idle:** Llamas bajas parpadeando en las grietas de la armadura. Respiración pesada (subida de hombros).
- **Ataque (golpe_fuego):** Espadazo horizontal con estela de fuego.

---

## 2. VIGÍA BOREAL — Agua

### Concepto

Centinela de las ciudades congeladas, atrapado en un estado semi-helado. Mitad ahogado, mitad congelado, vigilando eternamente los canales rotos.

### Apariencia

- **Cuerpo:** Humanoide esbelto envuelto en una armadura de hielo cristalizado y metal oxidado por el agua. Cuerpo parcialmente translúcido en las extremidades (hielo vivo).
- **Cabeza:** Capucha congelada que forma un casco de escarcha. Un ojo visible, brillando azul gélido; el otro cubierto por hielo.
- **Brazos:** Uno normal (con armadura de escamas heladas), el otro completamente de hielo desde el codo, más grande/deformado.
- **Piernas:** Placas metálicas con escarcha perpetua. Deja un rastro de cristales de hielo.
- **Arma:** Alabarda/lanza de hielo cristalino con punta translúcida y afilada.

### Paleta de Colores

- Azul hielo (#B0E0E6), azul profundo (#00008B), blanco escarcha (#F0F8FF), cian claro (#E0FFFF), gris metal oxidado.

### Animación Clave

- **Idle:** Cristales de hielo cayendo lentamente desde su cuerpo. Vapor frío emanando.
- **Ataque (mirada_gelida):** Ojo visible brillando intensamente, onda de frío expandiéndose.

---

## 3. HÁLITO VERDE — Planta

### Concepto

Criatura selvática nacida de los bosques parasitados. Mezcla entre humanoide y planta, ágil y venenosa. Como un cazador corrompido por la vegetación.

### Apariencia

- **Cuerpo:** Humanoide delgado y ágil, más bajo que la media. La piel está parcialmente cubierta de corteza, musgo y enredaderas.
- **Cabeza:** Rostro parcialmente oculto por una máscara de corteza/madera con forma de hoja. Ojos verdes brillantes visibles entre las grietas.
- **Brazos:** Delgados y alargados. Un brazo tiene dedos que terminan en garras de espinas. El otro tiene enredaderas enroscadas que usa como látigo.
- **Espalda:** Brotes de hongos luminiscentes y hojas que crecen directamente de su espalda/hombros.
- **Piernas:** Piernas ligeras, pies descalzos con raíces que se extienden brevemente al suelo.
- **Arma:** Garras de espina naturales (integradas en el cuerpo).

### Paleta de Colores

- Verde bosque (#228B22), verde lima (#32CD32), marrón corteza (#8B4513), amarillo esporas (#ADFF2F), violeta tóxico en los hongos.

### Animación Clave

- **Idle:** Hojas temblando, esporas flotando suavemente. Enredaderas ondulando.
- **Ataque (rafaga_cortante):** Zarpazo rápido con las garras de espina, dejando rastro verde.

---

## 4. BESTIA TRONADORA — Rayo

### Concepto

Criatura bestial de las ruinas suspendidas en tormentas perpetuas. Mitad animal, mitad tormenta viva. Rápida, salvaje y cargada de electricidad.

### Apariencia

- **Cuerpo:** Cuadrúpedo/semi-erguido, silueta de lobo/pantera. Musculoso, compacto y aerodinámico. Se mantiene sobre las patas traseras en combate.
- **Cabeza:** Cabeza lobuna con mandíbula abierta llena de colmillos eléctricos. Crestas óseas en la cabeza como pararrayos naturales. Ojos amarillos brillantes.
- **Lomo:** Crestas de cristal conductivo creciendo a lo largo de la columna. Chispas saltando entre ellas constantemente.
- **Garras:** Largas y metálicas, cargadas de electricidad visible.
- **Cola:** Cola gruesa que termina en una protuberancia cristalina que genera arcos eléctricos.
- **Pelaje:** Corto, azul oscuro con marcas amarillas tipo relámpago natural.

### Paleta de Colores

- Azul oscuro pelaje (#1A1A3E), amarillo eléctrico (#FFD700), blanco arco (#FFFFFF), cian (#00FFFF), negro garras.

### Animación Clave

- **Idle:** Chispas saltando entre las crestas. Cola oscilando. Postura tensa lista para saltar.
- **Ataque (chispazo):** Salto hacia delante con garras electrificadas, arco eléctrico visible.

---

## 5. GUARDIÁN TERRACOTA — Tierra

### Concepto

Golem viviente de los templos derrumbados. Antiguo protector de piedra ahora sin propósito, atacando a todo lo que se acerca a las ruinas. Lento e implacable.

### Apariencia

- **Cuerpo:** Humanoide masivo, ~1.5x el tamaño de un personaje normal. Cuerpo de terracota, arcilla endurecida y piedra tallada. Articulaciones visibles con juntas de arena y grava.
- **Cabeza:** Cabeza esférica/cuadrada de terracota con un solo "ojo" (cristal de jade incrustado) y una boca tallada que no se mueve.
- **Torso:** Pecho amplio con grabados de runas de tierra apagadas. Algunas piezas de terracota faltantes, revelando un interior de arena/grava brillante.
- **Brazos:** Enormes y desproporcionados respecto al cuerpo. El brazo derecho es más grande (brazo de escudo/golpe). Puños como mazas.
- **Piernas:** Cortas y gruesas, pilares de piedra. Se mueve con pasos pesados y arrastrados.
- **Detalles:** Musgo y pequeñas plantas creciendo en las grietas de su cuerpo (abandonado hace mucho).

### Paleta de Colores

- Terracota (#CC7755), marrón arcilla (#A0522D), verde jade (#00A86B) en el ojo, gris piedra (#808080), arena (#C2B280).

### Animación Clave

- **Idle:** Partículas de arena cayendo lentamente. Movimiento mínimo, casi estatua.
- **Ataque (muro_piedra):** Levanta los brazos y los clava en el suelo, creando una pared de roca.

---

## 6. NÁUFRAGO DE LA OSCURIDAD — Sombra

### Concepto

Ser que fue tragado por las ciudades subterráneas devoradas y devuelto como una entidad de sombra. Humanoide distorsionado, como una silueta rota que apenas mantiene su forma.

### Apariencia

- **Cuerpo:** Humanoide alto y delgado, casi esquelético. Su cuerpo es semitraslúcido/etéreo, como si estuviera hecho de sombra sólida. Los bordes del cuerpo se deshilachan como humo oscuro.
- **Cabeza:** Sin rostro definido. Donde debería estar la cara hay un vacío oscuro con dos puntos de luz violeta pálida como ojos. La "cabeza" se deforma y ondula constantemente.
- **Brazos:** Largos, terminan en manos con dedos alargados como garras de sombra. El brazo izquierdo es más largo y oscuro que el derecho.
- **Torso:** Restos de lo que fue ropa/armadura humana (fragmentos de tela, pedazos de metal) flotando integrados en la masa de sombra.
- **Piernas:** Se difuminan hacia abajo, como si su cuerpo se fundiera con el suelo oscuro. No tiene pies definidos.
- **Aura:** Partículas de oscuridad ascendiendo constantemente como humo inverso.

### Paleta de Colores

- Negro puro (#000000), violeta oscuro (#1A0033), púrpura sombra (#4A0066), puntos de luz violeta pálido (#CC99FF).

### Animación Clave

- **Idle:** Cuerpo ondulando como llama oscura. Partículas de sombra ascendiendo.
- **Ataque (abrazo_vacio):** Se expande abruptamente, brazos estirándose de forma antinatural.

---

## 7. PALADÍN MARCHITO — Luz

### Concepto

Ex-paladín de los templos santos fracturados, corrompido por la soledad y la fe rota. Conserva su armadura sagrada pero está deteriorada y su luz es intermitente, enferma.

### Apariencia

- **Cuerpo:** Humanoide grande, postura ligeramente encorvada (cansancio eterno). Armadura de paladín completa pero muy dañada.
- **Cabeza:** Yelmo de paladín con visor en cruz, parcialmente roto. Desde dentro emana una luz dorada débil e intermitente, como una vela que se apaga.
- **Torso:** Armadura blanca/dorada descolorida, manchas oscuras de corrosión. El símbolo sagrado del pecho está rajado por la mitad.
- **Brazos:** Armadura completa con detalles dorados oxidados. Un brazo sostiene una espada; el otro, un escudo roto (solo la mitad inferior).
- **Capa:** Capa larga blanca, ahora gris/amarillenta, raída y con agujeros.
- **Piernas:** Grebas pesadas, una rodilla tiene la placa faltante revelando la pierna ennegrecida debajo.
- **Arma:** Espada sagrada con filo que brilla y se apaga intermitentemente.

### Paleta de Colores

- Blanco envejecido (#E8E8D0), dorado oxidado (#B8860B), gris enfermizo (#A9A9A9), negro corrosión, destellos tenues de luz dorada.

### Animación Clave

- **Idle:** Luz parpadeante desde el visor. Cabeza ligeramente caída, postura de cansancio.
- **Ataque (destello_debil):** Flash de luz tenue desde la espada, más triste que amenazante.

---

## 8. ERRANTE RÚNICO — Arcano

### Concepto

Hechicero nómada de los observatorios fractales destruidos. Atrapado entre dimensiones, su cuerpo muestra fragmentos de realidades distintas. Enigmático y errático.

### Apariencia

- **Cuerpo:** Humanoide de estatura media, envuelto en ropas de mago/erudito. Partes del cuerpo "glitchean" — se pixelan/distorsionan brevemente como fallos de la realidad.
- **Cabeza:** Rostro visible pero parcialmente cubierto por una máscara de fragmentos de cristal que flotan frente a la cara. Un ojo visible mira fijamente; el otro lado es un vacío fractal.
- **Brazos:** Manos desnudas cubiertas de runas tatuadas que brillan intermitentemente en cian/magenta. El brazo derecho tiene fragmentos de cristal incrustados.
- **Torso:** Túnica de erudito azul-violeta raída. Un cinturón con pergaminos enrollados y cristales rotos colgando.
- **Piernas:** Cubiertas por la túnica larga. Se mueve deslizándose más que caminando.
- **Efecto especial:** Fragmentos de geometría fractal flotando a su alrededor — triángulos, runas, glifos que aparecen y desaparecen.

### Paleta de Colores

- Violeta profundo (#4B0082), cian arcano (#00FFFF), magenta (#FF00FF), negro, destellos blancos estrellas.

### Animación Clave

- **Idle:** Fragmentos geométricos rotando a su alrededor. Glitch ocasional en su silueta.
- **Ataque (pulso_arcano):** Manos extendidas, onda de energía geométrica expandiéndose.

---

# PARTE 3 — ENEMIGOS ÉLITE (8)

> Versiones avanzadas de los comunes. Más grandes (~1.2x), más detallados, con un segundo efecto visual que los distingue e indicadores de élite (corona, aura, marcas especiales).

---

## 1. SOLDADO ÍGNEO ÉLITE

- Todo lo del Soldado Ígneo, pero con **armadura más intacta y ornamentada**, con grabados de llamas doradas.
- **Corona de fuego** flotando sobre el yelmo (llamas que forman una corona de 3 puntas).
- El fuego ya no son brasas bajas: son **llamas activas** que cubren un brazo entero.
- **Aura de calor** visible (distorsión del aire alrededor).
- **Habilidades visibles:** Pilares de fuego surgiendo del suelo (pilar_llama). Llamarada masiva (llamarada_furia).

## 2. VIGÍA BOREAL ÉLITE

- Hielo más definido y cristalino. La mitad del cuerpo es **hielo perfecto y translúcido**.
- **Cristales de hielo** grandes creciendo desde los hombros como hombreras naturales.
- El ojo visible ahora es **completamente blanco-azul**, sin pupila.
- **Escarcha constante** cayendo a su alrededor como nieve ligera.
- **Habilidades visibles:** Prisión de hielo rodeando al objetivo (prision_glaciar). Ventisca (ventisca_polar).

## 3. HÁLITO VERDE ÉLITE

- Vegetación más agresiva: **espinas más largas**, enredaderas más gruesas, hongos más grandes y brillantes.
- **Flores tóxicas** brotando de los hombros y la espalda, liberando esporas visibles.
- Los ojos brillan con un **verde ácido más intenso**.
- La máscara de corteza ahora cubre más rostro y tiene **cuernos de madera**.
- **Habilidades visibles:** Tornado de hojas y espinas (tornado_esmeralda). Nube de esporas (esporas_toxicas).

## 4. BESTIA TRONADORA ÉLITE

- Más grande y feroz. Las **crestas cristalinas** son más largas, casi como cuernos eléctricos.
- **Arcos eléctricos constantes** entre las crestas, formando casi una red de relámpagos.
- Ojos brillando como **faros amarillos** en la oscuridad.
- **Marcas de rayo** en el pelaje que brillan con cada latido.
- **Mecánica visual:** Timer visible (indicador de penalización por repetición).
- **Habilidades visibles:** Tormenta eléctrica desde arriba (tormenta_electrica). Impulso de velocidad con afterimage eléctrico (impulso_voltaico).

## 5. GUARDIÁN TERRACOTA ÉLITE

- Significativamente más grande. Las piezas de terracota están **reforzadas con jade cristalizado**.
- **Dos ojos** de jade en lugar de uno, más brillantes.
- Las runas de tierra en su pecho **brillan activamente** en verde jade.
- **Cristales de jade** creciendo de los hombros y puños como protuberancias.
- **Mecánica visual:** Timer visible (restricción temporal).
- **Habilidades visibles:** Terremoto con grietas expandiéndose (terremoto). Cubrirse de roca extra (fortaleza_petrea).

## 6. NÁUFRAGO DE LA OSCURIDAD ÉLITE

- Forma más definida pero **más aterradora**. La sombra es más densa, más negra.
- **Múltiples pares de ojos** violeta apareciendo y desapareciendo en su masa oscura.
- **Tentáculos de sombra** emergiendo de su espalda, ondulando.
- Los restos de ropa/armadura son más reconocibles — era alguien importante antes.
- **Mecánica visual:** Eco de habilidades (reflejo_diferido) — se ve un "doble" fantasmal actuando con delay.
- **Habilidades visibles:** Esfera de vacío absorbente (agujero_negro). Marca oscura en el suelo del jugador (marca_sombria).

## 7. PALADÍN MARCHITO ÉLITE

- La armadura está **parcialmente restaurada** con luz marchita — se ve que intenta regenerarse pero falla.
- **Alas de luz fracturadas** — dos proyecciones de luz dorada desde la espalda, rotas e intermitentes.
- El escudo ahora está **completo pero agrietado**, con el símbolo sagrado brillando débilmente.
- **Halo roto** flotando inclinado sobre la cabeza.
- **Mecánica visual:** Se potencia según la vida del jugador (escalado_vida_jugador).
- **Habilidades visibles:** Rayo de luz sagrada desde arriba (juicio_sagrado). Curación oscura a sí mismo (plegaria_marchita).

## 8. ERRANTE RÚNICO ÉLITE

- Los **glitches son más frecuentes y dramáticos** — partes enteras del cuerpo desaparecen y reaparecen.
- **Anillo de fragmentos cristalinos** orbitando a su alrededor como un sistema planetario.
- La máscara de cristal ahora es un **casco completo fractal** que cambia de forma.
- Manos rodeadas de **esferas de energía arcana** permanentes.
- **Habilidades visibles:** Cometa de energía arcana (cometa_runico). Glifos apareciendo bajo el jugador (sello_arcano).

---

# PARTE 4 — JEFES (6)

> Los jefes son significativamente más grandes que los personajes normales (~1.5–2x). Diseños complejos que combinan dos afinidades. Presencia intimidante y épica.

---

## 1. TITÁN DE LAS FORJAS ROTAS — Fuego + Tierra

### Concepto

Un coloso de metal fundido y roca volcánica. Antiguo guardián de las grandes forjas de Arcadium, ahora enloquecido y destruyendo todo. Fusión de herrero divino y volcán viviente.

### Apariencia

- **Tamaño:** ~2x un personaje normal. El más ancho de los jefes.
- **Cuerpo:** Humanoide masivo, torso superior extremadamente desarrollado. Cuerpo de roca volcánica negra con venas de magma brillante recorriéndolo. Placas de metal forjado incrustadas en la roca como armadura natural.
- **Cabeza:** Pequeña en proporción al cuerpo. Yelmo de herrero fundido a la cara. Boca visible como una abertura de la que sale fuego al atacar. Ojos de magma líquida.
- **Brazo derecho:** Termina en un **martillo colosal** de roca obsidiana y metal fundido. El martillo tiene runas de forja casi apagadas.
- **Brazo izquierdo:** Garra de piedra volcánica con dedos de metal que gotean magma.
- **Torso:** Pecho con una **grieta enorme** que revela el interior: un núcleo de magma brillante (su punto débil visual).
- **Piernas:** Pilares de roca gruesos, las rodillas son masas de metal soldado. Cada paso deja marcas ardientes.
- **Espalda:** Chimeneas de roca de las que sale humo y ceniza constantemente.

### Paleta de Colores

- Roca negra volcánica (#1A1A1A), magma brillante (#FF4500 → #FFD700), metal forjado gris oscuro, jade oscuro en runas de tierra, rojo profundo.

### Habilidades Visuales

1. **Erupción forjada:** Magma subiendo desde el suelo en múltiples puntos.
2. **Martillo incandescente:** Golpe masivo con el martillo, onda expansiva de fuego y roca.
3. **Muro magmático:** Barrera de roca fundida surgiendo frente a él.
4. **Cataclismo forjado (Súper):** Se envuelve en magma, golpea el suelo creando una explosión total.

---

## 2. COLOSO DEL FANGO VIVIENTE — Agua + Planta

### Concepto

Una monstruosidad pantanosa, mezcla de criatura marina ancestral y vegetación parasitaria. Grotesco y opresivo, como un manglar que cobró vida.

### Apariencia

- **Tamaño:** ~1.8x un personaje normal. El más voluminoso verticalmente (cuenta con vegetación encima).
- **Cuerpo:** Masa amorfa humanoide de fango, agua estancada y raíces retorcidas. Difícil distinguir dónde termina el fango y empieza la planta.
- **Cabeza:** No tiene cabeza definida. En su lugar, una **masa de raíces retorcidas** que forman una "cara" con una boca hundida y dos cavidades que brillan verde/azul como ojos.
- **Brazos:** Tentáculos/raíces gruesas que terminan en masas de fango. Gotea agua turbia constantemente. Las raíces tienen pequeñas flores marchitas.
- **Torso:** Tronco central de madera podrida con fango chorreando. Corales y conchas marinas incrustados. Un **corazón vegetal** visible pulsando tenue dentro del tronco (cristal verdoso).
- **Piernas:** No tiene piernas claras. Se apoya en una **masa de raíces** que se extienden por el suelo como un sistema raíz. Se mueve arrastrándose.
- **Detalles:** Pequeños peces/criaturas acuáticas atrapadas en el fango de su cuerpo. Algas colgando. Lirios flotando en los charcos que deja.

### Paleta de Colores

- Verde pantano (#556B2F), marrón fango (#5C4033), azul agua turbia (#2E4057), verde brillante (#00CC44) en el corazón, blanco/azul en las flores muertas.

### Habilidades Visuales

1. **Maremoto vegetal:** Ola de fango y raíces avanzando.
2. **Torrente fangoso:** Chorro de agua lodosa a presión.
3. **Esporas regenerativas:** Flores brillando, liberando esporas que lo curan.
4. **Aplastamiento pantano (Súper):** Todo su cuerpo se expande y cae como un alud de fango y raíces.

---

## 3. SENTINELA DEL CIELO ROTO — Rayo + Luz

### Concepto

Ser celestial caído, fusión de tormenta divina y luz sagrada. Un ángel destruido reconstruido con relámpagos. Imponente, trágico y devastador.

### Apariencia

- **Tamaño:** ~1.7x un personaje normal. El más vertical/estilizado de los jefes.
- **Cuerpo:** Humanoide esbelto pero no frágil. Armadura de cristal luminoso fracturada, con electricidad rellenando las grietas. Flota ligeramente sobre el suelo.
- **Cabeza:** Rostro andrógino y hermoso pero fracturado — la mitad izquierda es rostro perfecto de luz dorada, la mitad derecha es una máscara de cristal roto con relámpagos visibles dentro.
- **Alas:** Dos pares de alas. El par superior es de **relámpagos solidificados** — arcos eléctricos que forman la estructura del ala. El par inferior es de **luz sagrada** — proyecciones doradas translúcidas, rotas en los bordes.
- **Brazo derecho:** Garra de cristal eléctrico, arcos de rayo saltando entre los dedos.
- **Brazo izquierdo:** Brazo de luz solidificada, más suave en forma, sosteniendo una **lanza de luz/rayo** combinada.
- **Torso:** Armadura celestial blanca/dorada con circuitos de electricidad recorriéndola como venas. Un **núcleo de tormenta** brillante en el pecho.
- **Piernas:** Armadura de cristal, terminando en puntas. No toca el suelo.

### Paleta de Colores

- Blanco celestial (#FFFFFF), dorado sagrado (#FFD700), azul eléctrico (#0080FF), amarillo rayo (#FFFF00), cian brillante, cristal transparente.

### Habilidades Visuales

1. **Fulgor celestial:** Explosión combinada de luz y rayo desde el pecho.
2. **Relámpago sagrado:** Rayo cayendo del cielo con aura dorada.
3. **Destello purificador:** Flash de luz cegadora que cubre toda la pantalla.
4. **Tormenta divina (Súper):** Cielo oscureciéndose, múltiples rayos sagrados cayendo en secuencia.

---

## 4. ORÁCULO QUEBRADO DEL ABISMO — Sombra + Arcano

### Concepto

Entidad que existía entre las sombras y el conocimiento arcano. El más enigmático y aterrador de los jefes. Un sabio que miró demasiado profundo en el vacío y el vacío lo consumió.

### Apariencia

- **Tamaño:** ~1.6x un personaje normal, pero su aura/efectos lo hacen parecer más grande.
- **Cuerpo:** Humanoide flotante envuelto en ropas de oráculo desintegradas. Su cuerpo alterna entre sombra sólida y geometría arcana fractal. Constantemente cambiando en los bordes.
- **Cabeza:** Capucha enorme de la que no se ve rostro, solo un **vacío absoluto** con runas arcanas flotando dentro. Ocasionalmente, múltiples ojos de distintos colores parpadean en ese vacío.
- **Brazos:** Cuatro brazos (dos normales, dos sombríos/fantasmales). Los brazos reales canalizan energía arcana (glifos, geometría). Los brazos de sombra se mueven independientemente, alcanzando, agarrando el aire.
- **Torso:** Túnica de oráculo que se deshace en humo oscuro hacia abajo. Cadenas de runas arcanas rodeando el torso como cinturones flotantes.
- **Parte inferior:** Sin piernas. El cuerpo se disuelve en un **portal/vórtice de sombra y energía arcana** debajo de él. Fragmentos de cristal y runas orbitan el vórtice.
- **Efecto constante:** Realidad "rompiéndose" a su alrededor — pequeñas grietas en el espacio que muestran vacío/estrellas.

### Paleta de Colores

- Negro abismo (#000000), violeta profundo (#2D0048), cian arcano (#00FFFF), magenta (#FF00FF), púrpura (#7B2D8E), destellos de estrella blanca.

### Habilidades Visuales

1. **Vacío rúnico:** Portal de sombra que absorbe y dispara energía arcana.
2. **Pulso abismal:** Onda oscura que distorsiona el espacio visible.
3. **Sifón sombrío:** Tentáculos de sombra con runas que drenan energía del jugador.
4. **Apocalipsis rúnico (Súper):** El espacio se fragmenta completamente, lluvia de fragmentos arcanos y sombras.

---

## 5. EL DEVORADOR — Sin Afinidad (Jefe Final)

### Concepto

La amenaza suprema de Arcadium. Una entidad que consume Esencia pura, sin elemento definido. Su diseño debe evocar **hambre absoluta, vacío y corrupción universal**. No pertenece a ningún elemento porque los devora todos.

### Apariencia

- **Tamaño:** ~2x un personaje normal. Presencia abrumadora.
- **Cuerpo:** Humanoide distorsionado pero vagamente simétrico. Cuerpo de **materia oscura iridiscente** — negro que refleja todos los colores elementales como petróleo. Imposible definir si es orgánico, mineral o energía.
- **Cabeza:** Cabeza sin rostro, una **esfera oscura perfecta** donde deberían estar los rasgos. La esfera absorbe la luz alrededor. Tiene una boca vertical que se abre en el centro de la esfera revelando un vacío interior con fragmentos de todos los colores elementales consumidos.
- **Brazos:** Dos brazos principales largos y segmentados como extremidades de insecto, terminando en manos con garras de 6 dedos. Múltiples brazos más pequeños/vestigiales brotando de la espalda, moviéndose erráticamente.
- **Torso:** Torso con una **cavidad central** — un agujero/vacío en el centro del pecho que funciona como su "boca" principal, absorbiendo energía visible (partículas de colores fluyendo hacia él).
- **Piernas:** Dos piernas principales, pero con apéndices extra que se mueven como tentáculos. El suelo se corrompe donde pisa (efecto de decoloración).
- **Detalles:** Fragmentos de los 8 elementos atrapados en su cuerpo como trofeos — una llama apagándose, un cristal de hielo derritiéndose, una raíz marchitándose, etc.

### Paleta de Colores

- Negro iridiscente (#0D0D0D con reflejos multicolor), violeta corrupción (#3D0066), todos los colores elementales apareciendo y desvaneciéndose. Sin color propio — roba los de otros.

### Habilidades Visuales

1. **Absorción de Esencia:** Succiona la barra de esencia del jugador. Efecto visual de energía fluyendo hacia su cavidad central.
2. **Copia de patrones:** Reproduce brevemente los ataques del jugador con color distorsionado/invertido.
3. **Corrupción elemental:** Desactiva los efectos de afinidad del jugador. Onda de color enfermizo.
4. **Devoración total (Súper):** Pantalla oscureciéndose progresivamente mientras su cavidad central brilla con todos los colores. Explosión inversa (implosión) devastadora.

---

## 6. EL PRIMER CONDUCTOR — Sin Afinidad Visible (Jefe Secreto)

### Concepto

El guerrero más antiguo de Arcadium, el primer ser que dominó todas las corrientes. Ahora existe fuera del tiempo, probando a todo Conductor que llegue a él. Su diseño debe ser **misterioso, reverencial y abrumadoramente poderoso** pero no malvado.

### Apariencia

- **Tamaño:** Exactamente igual que un personaje jugable. Su poder no necesita tamaño.
- **Cuerpo:** Humanoide perfecto. Armadura/ropa que combina elementos de TODAS las 6 clases del jugador — placas de Vanguardia, velocidad de Filotormenta, peso de Quebrador, escudo de Centinela, elegancia de Duelista, runas de Canalizador. Todo integrado armoniosamente.
- **Cabeza:** Rostro cubierto por una **máscara sin rasgos** — lisa, blanca, vagamente humana. Sin ojos, boca ni nariz definidos. La máscara tiene las 8 runas de afinidad grabadas formando un círculo en la frente, pero apagadas.
- **Arma:** Varias armas flotando a su espalda en un arco, semitransparentes — espada, lanza, martillo, bastón, dagas, escudo. Usa la que corresponda imitando al jugador.
- **Torso:** Armadura que combina los diseños de todos los personajes. Los colores cambian sutilmente reflejando la clase/afinidad que está imitando actualmente.
- **Capa/Efecto:** Una capa larga que no es de tela sino de **energía pura** — transparente con los 8 colores elementales fluyendo en ella como aurora boreal.
- **Piernas:** Armadura completa, equilibrada, se mantiene firme en el suelo.
- **Detalle clave:** Sea cual sea la clase del jugador, El Primer Conductor adopta una postura que la espeja/refleja.

### Paleta de Colores

- Blanco ceniza (#F5F5F5), gris neutro (#808080), todos los colores elementales como acentos que cambian. Su color "propio" no existe — es un espejo.

### Habilidades Visuales

1. **Imitación de clase:** Cambia postura y arma visible según lo que copia.
2. **Manipulación de Esencia:** La barra de esencia del jugador fluctúa visualmente.
3. **Eco de Corrientes:** Las 8 runas de su máscara se encienden una por una antes de un ataque masivo.
4. **Resonancia del Primer Conductor (Súper):** Todas las armas flotantes se activan simultáneamente, ejecutando un combo de todas las clases.

---

# REFERENCIA RÁPIDA — Tamaños Relativos

```
Escala estimada (px de alto):

Hálito Verde        ████████░░  ~58px    (el más bajo)
Nerya               █████████░  ~62px
Lys                 █████████░  ~64px
Saren               █████████░  ~66px
Kael                ██████████  ~70px
Brenn               ██████████  ~70px    (corpulento)
Primer Conductor    ██████████  ~70px    (mismo tamaño jugable)
Soldado Ígneo       ██████████  ~70px
Vigía Boreal        ██████████  ~68px
Bestia Tronadora    ██████████  ~70px    (erguida)
Náufrago Oscuridad  ███████████ ~78px    (alto y delgado)
Errante Rúnico      ██████████  ~70px
Paladín Marchito    ███████████ ~76px
Maelis              ███████████ ~76px
Thalys              ███████████ ~78px    (alto, blindado)
Torvan              ████████████ ~82px   (el más grande jugable)
Guardián Terracota  █████████████ ~100px
Élites              ~1.2x de su versión común
Coloso Fango        ██████████████████ ~140px
Sentinela Cielo     █████████████████ ~130px
Oráculo Abismo      ████████████████ ~120px (+ aura)
Titán Forjas        ██████████████████ ~150px
Devorador           ██████████████████ ~150px
```

---

# REFERENCIA RÁPIDA — Paletas por Afinidad

| Afinidad | Color Primario   | Color Secundario   | Acento          |
| -------- | ---------------- | ------------------ | --------------- |
| Fuego    | Rojo oscuro      | Naranja            | Amarillo brasa  |
| Agua     | Azul profundo    | Azul hielo         | Blanco escarcha |
| Planta   | Verde bosque     | Verde lima         | Marrón corteza  |
| Rayo     | Azul oscuro      | Amarillo eléctrico | Cian/blanco     |
| Tierra   | Marrón tierra    | Verde jade         | Gris piedra     |
| Sombra   | Negro puro       | Violeta oscuro     | Púrpura pálido  |
| Luz      | Blanco marfil    | Dorado             | Ámbar           |
| Arcano   | Violeta profundo | Cian               | Magenta         |

---

# GUÍA DE POSES NECESARIAS

### Para cada Personaje Jugable (8):

1. **Idle** — Pose neutral en guardia
2. **Ataque básico** — Golpe con arma
3. **Habilidad de clase** — Efecto único según clase
4. **Habilidad de arma** — Ataque elemental
5. **Súper-habilidad** — Pose épica + efecto masivo
6. **Recibir daño** — Retroceso/impacto
7. **Victoria** — Celebración contenida
8. **Derrota** — Caer/desvanecerse
9. **Retrato/Rostro** — Para UI (selección, HUD)

### Para cada Enemigo Común (8):

1. **Idle** — Pose amenazante
2. **Ataque principal** — Habilidad fija
3. **Recibir daño** — Retroceso
4. **Derrota** — Desintegración elemental

### Para cada Enemigo Élite (8):

- Todo lo de los comunes +

5. **Ataque secundario** — Segunda habilidad
6. **Entrada/Aparición** — Presentación dramática

### Para cada Jefe (6):

1. **Idle** — Presencia intimidante
2. **Ataque 1-4** — Una por cada habilidad (4 distintas)
3. **Recibir daño** — Estremecimiento
4. **Fase de furia** — Cambio visual cuando baja de vida
5. **Derrota** — Desintegración épica/cinemática
6. **Entrada** — Aparición con presentación dramática
