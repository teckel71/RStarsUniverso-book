# Descripciones para generar las imágenes de los 30 planetas de *R-Stars*

Documento de trabajo para alimentar un generador de imágenes por IA. El objetivo es obtener **retratos planetarios cinematográficos, en formato apaisado 16:9 y gran resolución**, coherentes con el estilo de las 7 imágenes que ya existen.

Cada entrada incluye: el planeta, su **categoría** y **origen**, y un **prompt** autocontenido listo para copiar y pegar. Las 7 primeras (Sección A) describen las imágenes que ya tenemos, como **test de coherencia** del estilo; las 23 restantes (Sección B) son las nuevas, ordenadas por galaxia.

------------------------------------------------------------------------

## El «estilo de la casa» (común a las 30 imágenes)

Deducido de las 7 imágenes existentes. Todas comparten este lenguaje visual:

-   **Vista orbital desde el espacio**, planeta a media distancia (retrato planetario, no paisaje de superficie), en **encuadre horizontal 16:9**.
-   **Luz rasante y dramática** de una estrella situada fuera de cuadro, que perfila la atmósfera en el limbo (efecto contraluz/rim-light) y deja parte del planeta en penumbra (terminador visible).
-   **Fondo de espacio profundo**: campo de estrellas denso, banda de la **Vía Láctea**, **galaxias espirales** lejanas y, a menudo, jirones de **nebulosa** en un color **complementario** al del planeta.
-   **Cuerpos acompañantes** ocasionales: una o dos lunas menores.
-   **Firma recurrente**: un pequeño **destello estelar de cuatro puntas**, normalmente abajo a la derecha.
-   **Acabado**: fotorrealista, alta resolución, iluminación volumétrica, concept-art astronómico cinematográfico, colores ricos y buen contraste. Sin texto ni marcas de agua.

**Coletilla de estilo** (ya incluida al final de cada prompt; puedes reutilizarla si retocas alguno):

> *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

**Notas de uso.** El *ratio* recomendado es 16:9 (por ejemplo `--ar 16:9` en Midjourney, o 1456×816 / 1920×1080 en otros). Muchos generadores rinden mejor con el *prompt* en inglés: si te interesa, puedo entregarte esta misma lista traducida y optimizada para inglés.

### Tres avisos de coherencia (decisiones que conviene que valides)

1.  **Pandora.** La imagen que había **no** era la jungla exuberante de *Avatar*, sino un **mundo rocoso y árido**, incoherente con la ficha del planeta en el libro («ecosistema protegido, biotecnología»). Por eso su prompt (Sección A) es ya directamente la **versión *Avatar***, pensada para **regenerar** la imagen y sustituir la árida. El texto de los libros no necesita cambios: ya describe Pandora como mundo exuberante.
2.  **Miranda.** Es a la vez una luna real de Urano y el planeta de *Firefly*. En este universo funciona como mundo de «nichos tecnológicos avanzados» (sede de *Hyperdrive Express*), así que la he tratado como el mundo **terraformado tipo *Firefly***, no como la luna real.
3.  **La Tierra (Final).** La he interpretado como una **Tierra real** (morfología auténtica) mostrada en una **era final/futura**, para que se distinga del planeta «Tierra» sin dejar de ser reconocible.

------------------------------------------------------------------------

# Sección A — Los 7 planetas de referencia (test de coherencia)

Descripción de las imágenes **ya existentes**, para fijar el estilo.

### Arrakis · Gran Nube de Magallanes · *Dune* · [imagen existente]

> Planeta desértico visto desde el espacio, gran esfera de tonos arena y ocre dominando el tercio derecho del encuadre; una ancha banda ecuatorial salpicada de manchas incandescentes de color ámbar y naranja —depósitos de especia y calor geotérmico brillando a través del polvo—; superficie de dunas, mares de arena y tenues zonas claras; a la izquierda, una pequeña luna gris craterizada en penumbra; fondo negro con campo de estrellas denso y un tenue jirón de nebulosa azulada a la izquierda; planeta a tres cuartos iluminado, luz cálida y dramática. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

### Caprica · Pequeña Nube de Magallanes · *Battlestar Galactica* · [imagen existente]

> Mundo de tipo terrestre gemelo de la Tierra: océanos azul profundo, continentes pardo-verdosos y remolinos de nubes blancas, con el terminador bien visible (hemisferio izquierdo iluminado, derecho en sombra), ocupando el tercio izquierdo del encuadre; detrás, una espectacular banda de la Vía Láctea con nubes de nebulosa doradas y varias galaxias espirales lejanas; una luna cercana a la derecha y un destello estelar de cuatro puntas abajo a la derecha. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

### Coruscant · Andrómeda · *Star Wars* · [imagen existente]

> Planeta-ciudad global (ecumenópolis): toda la superficie cubierta por un manto continuo de estructuras urbanas y luces doradas, rascacielos y avenidas luminosas de horizonte a horizonte; el planeta está ceñido por un fino **anillo orbital de astilleros** con brazos de atraque y varias lunas menores engarzadas; al fondo, una gran galaxia espiral arriba a la derecha, un denso cúmulo de galaxias y jirones de nebulosa; dominante dorada cálida sobre un negro cósmico profundo. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

### Fhloston Paradise · Gran Nube de Magallanes · *El quinto elemento* · [imagen existente]

> Mundo oceánico paradisíaco: océano turquesa intenso cubierto de grandes remolinos espirales blancos y cian —sistemas de olas y atolones vistos desde arriba—, apenas sin tierra firme; el borde atmosférico aparece retroiluminado por una cálida luz dorada; al fondo, el núcleo de la Vía Láctea en tonos ámbar, dos pequeñas lunas a la izquierda y un destello estelar de cuatro puntas. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

### Mustafar · Andrómeda · *Star Wars* · [imagen existente]

> Planeta volcánico: corteza de roca negra y carbón resquebrajada por ríos de lava incandescente naranja y roja que forman una red brillante sobre toda la esfera; una estrella intensa fuera de cuadro, a la derecha, crea un ardiente halo en el limbo; abajo a la izquierda, una luna gris craterizada en penumbra; campo de estrellas y galaxias lejanas de fondo, con un destello de cuatro puntas. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

### Pandora · Vía Láctea · *Avatar* · [rediseño — sustituye a la imagen árida]

> *(La imagen que había era un mundo rocoso y árido, incoherente con el libro; este prompt la regenera en su versión Avatar, exuberante.)*
>
> Luna-selva exuberante al estilo de *Avatar*, vista desde el espacio: superficie cubierta de densas **selvas tropicales de un verde intenso**, surcada por ríos serpenteantes, mares y lagunas de un **turquesa luminoso** y cordilleras entre las que flotan las célebres **montañas suspendidas** («Montañas Aleluya»), envueltas en nubes y cascadas; el hemisferio nocturno resplandece con una delicada **bioluminiscencia** en tonos azul cian y violeta que dibuja la trama de la vida sobre la superficie; la luna orbita muy cerca de un **enorme gigante gaseoso anillado** —a la manera de Polifemo—, de atmósfera estriada en azules y turquesas, que domina buena parte del fondo; un fino y luminoso halo atmosférico perfila el limbo; ambiente húmedo, vivo y mágico. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

### Tatooine · Andrómeda · *Star Wars* · [imagen existente]

> Planeta desértico centrado, esfera de un cálido dorado uniforme con sutiles regiones de desierto y tierras altas apenas insinuadas; brillante halo atmosférico dorado retroiluminado a lo largo de todo el contorno (se sobreentiende la luz de sus **dos soles** en el tono dorado); el planeta aparece envuelto por una neblina de nebulosa púrpura-magenta; campo de estrellas de fondo. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

------------------------------------------------------------------------

# Sección B — Los 23 planetas nuevos

## Vía Láctea

### Júpiter · **planeta real** · gigante gaseoso

> El planeta real **Júpiter** visto desde el espacio: gigante gaseoso surcado por bandas paralelas de nubes crema, ocre, marrón y blanco (cinturones y zonas), con la **Gran Mancha Roja** como un enorme remolino ovalado; turbulencias, festones y tormentas ciclónicas en la atmósfera; a un lado, una o dos lunas galileanas como pequeños discos —**Ío**, anaranjada y volcánica, y **Europa**, helada y agrietada—; retroiluminado por el Sol, con un fino arco de luz en el limbo. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

### Klendathu · **imaginario (filmografía)** · *Starship Troopers*

> Mundo hostil y árido: esfera de tonos pardo-anaranjados y óxido, superficie de cañones, mesetas rocosas y vastas llanuras desérticas surcadas por formaciones que recuerdan a colonias y madrigueras excavadas; atmósfera enrarecida de tinte rojizo; el planeta está rodeado por un **cinturón de escombros y asteroides** en órbita; luz dura, sombras marcadas y ambiente claramente amenazador. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

### LV-223 · **imaginario (filmografía)** · *Prometheus*

> Luna rocosa gris y estéril, castigada por tormentas: montañas escarpadas y llanuras de roca oscura bajo un cielo tormentoso, con nubes de polvo y relámpagos en su atmósfera tenue; la luna **orbita un gran gigante gaseoso anillado** que domina buena parte del fondo; paleta fría gris-azulada y ambiente opresivo, de descubrimiento inquietante. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

### LV-426 (Acheron) · **imaginario (filmografía)** · *Alien / Aliens*

> Luna desolada azotada por tormentas perpetuas: esfera gris-azulada envuelta en densas nubes arremolinadas y bruma, con la superficie rocosa apenas visible entre los sistemas de tormenta; al fondo, el **gigante gaseoso Calpamos** y una luna hermana; iluminación lúgubre, dominante azul frío y una intensa sensación de aislamiento y desamparo. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

### La Luna · **satélite real** · la Luna de la Tierra

> La **Luna** real vista desde el espacio: esfera gris intensamente craterizada, con los **maria** (mares basálticos oscuros) y sistemas de rayos brillantes de cráteres jóvenes como Tycho y Copérnico; el terminador proyecta sombras largas que resaltan el relieve de cráteres y cordilleras; al fondo, opcionalmente, la **Tierra** como un lejano creciente azul; luz solar rasante. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la superficie; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

### Planet P · **imaginario (filmografía)** · *Starship Troopers*

> Planeta desértico de tonos tostados y ocres: grandes mesetas, cañones y formaciones rocosas erosionadas bajo un cielo pálido y polvoriento, sin vegetación; alguna enorme depresión o cráter que insinúa **nidos subterráneos**; luz cálida de atardecer y sombras alargadas. Se distingue de Klendathu por su tono más claro y arenoso y su aire de páramo solitario. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

### Tierra · **planeta real** · la Tierra

> La **Tierra** vista desde el espacio, el clásico «canica azul»: océanos azul profundo, continentes verdes y pardos, casquetes polares blancos y una atmósfera con remolinos de nubes; un fino y luminoso halo azul de la atmósfera recorta el limbo; iluminación solar natural sobre el hemisferio diurno; al fondo, opcionalmente, la Luna lejana. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

## Galaxia de Andrómeda

### Dagobah · **imaginario (filmografía)** · *Star Wars*

> Mundo pantanoso cubierto de nubes: esfera de tonos verde-oliva, ocre y marrón turbio, con una densa capa nubosa arremolinada que apenas deja entrever ciénagas, marismas y selvas brumosas; atmósfera húmeda y neblinosa; paleta verdosa apagada y misteriosa, luz difusa y tenue, aire de refugio oculto. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

### Endor · **imaginario (filmografía)** · *Star Wars*

> Luna forestal exuberante: esfera de un **verde intenso** cubierta de vastos bosques, con algunos mares y lagos azules y jirones de nube; la luna **orbita un gran gigante gaseoso** que asoma parcialmente al fondo, aportando escala; luz cálida y aspecto vivo, boscoso y apacible. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

### Hoth · **imaginario (filmografía)** · *Star Wars*

> Planeta helado: esfera **blanca y azul pálido** de hielo y nieve, con casquetes glaciares que cubren casi toda la superficie, tormentas de nieve arremolinadas y grietas de hielo azulado; brillo frío y cegador; bajo el manto helado se adivinan tenues cordilleras. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

### Naboo · **imaginario (filmografía)** · *Star Wars*

> Mundo exuberante y apacible, de tipo terrestre: grandes masas de tierra de un **verde intenso**, océanos y lagos de un azul turquesa luminoso, ríos serpenteantes y nubes suaves; ambiente cálido, idílico y fértil, con una sutil bruma atmosférica dorada en el limbo. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

## Galaxia del Triángulo

### La Tierra (Final) · **planeta real (era final)** · homenaje a *Earth: Final Conflict*

> La **Tierra** en una era final y futura, reconocible por sus continentes y océanos pero mostrada en el **terminador crepuscular**: el hemisferio nocturno late con vastas retículas de luces de ciudad y un delicado **anillo de hábitats orbitales** y estructuras en construcción alrededor del planeta; auroras verdes en los polos; atmósfera dorada en el limbo; tono solemne, elegíaco y evocador. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

### Nueva Caprica · **imaginario (filmografía)** · *Battlestar Galactica*

> Mundo frío y marginal: esfera pálida de tonos grises, tostados y ocres apagados, cubierta casi por completo de **nubes y bruma**; escasa tierra visible, con tundra y llanuras heladas asomando entre los claros; atmósfera densa y plomiza; luz fría y difusa, aspecto inhóspito y de frontera olvidada. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

### Qo'noS · **imaginario (filmografía)** · *Star Trek* (mundo klingon)

> Mundo de tinte **verdoso-esmeralda**: atmósfera verde translúcida sobre continentes volcánicos oscuros y mares turbios; actividad tectónica y resplandores de lava en el lado nocturno; en órbita, una **luna fracturada** (Praxis) rodeada de un brillante anillo de escombros; ambiente severo, marcial y dramático. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

### Risa · **imaginario (filmografía)** · *Star Trek* (planeta-paraíso)

> Planeta-paraíso tropical: océanos de un azul turquesa luminoso salpicados de **archipiélagos verdes y atolones**, cielos despejados y clima idílico (controlado artificialmente); nubes cálidas dispersas y una luz dorada de resort; aspecto acogedor, sereno y placentero. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

### Romulus · **imaginario (filmografía)** · *Star Trek*

> Mundo verde y templado, de atmósfera con un sutil **tinte esmeralda**, continentes boscosos y mares azul-verdosos; junto a él, su planeta hermano **Remus**, más oscuro, frío y medio en sombra, formando un sistema binario; luz lateral dramática, estética severa y elegante. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

### Vulcano · **imaginario (filmografía)** · *Star Trek*

> Mundo desértico y caluroso (**Vulcan**): esfera de tonos rojizos, ocres y anaranjados, con vastos desiertos, cordilleras escarpadas y apenas agua; atmósfera fina de tinte rojizo; luz intensa de una estrella cercana; aspecto árido, antiguo y austero, de sabiduría mineral. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

## Gran Nube de Magallanes

### Miranda · **imaginario (filmografía)** · *Firefly / Serenity*

> Mundo **terraformado** de tipo terrestre: océanos azules y continentes verdes bajo una atmósfera limpia y luminosa; sobre el lado nocturno, delicadas retículas de **luces de ciudades tecnológicas** y **estaciones orbitales** relucientes; belleza serena, casi becalmada, de utopía silenciosa; iluminación pulcra y brillante. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

### Mül · **imaginario (filmografía)** · *Valerian* (el planeta-perla)

> Mundo-perla paradisíaco: vastísimos **bajíos de agua turquesa y aguamarina** sobre arenas blancas y nacaradas, islas suaves y lagunas iridiscentes; atmósfera de tonos pastel —rosa, lavanda y oro— al amanecer; luz suave y difusa, con un **brillo perlado y onírico** en toda la escena; serenidad utópica. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

## Pequeña Nube de Magallanes

### Kobol · **imaginario (filmografía)** · *Battlestar Galactica*

> Mundo de tipo terrestre de aspecto **antiguo y misterioso**: continentes verdes cubiertos de vegetación densa y océanos azules, con bruma y nubes dispersas; el lado nocturno permanece **a oscuras** (mundo abandonado, sin luces de ciudad); atmósfera evocadora, con la sensación de ser una cuna olvidada de la humanidad. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

### Mann · **imaginario (filmografía)** · *Interstellar*

> Planeta helado y nublado: esfera **blanca y gris azulado** envuelta en gruesas capas de nubes congeladas, con una superficie de hielo perpetuo, sin agua líquida ni vegetación; luz débil y fría de una estrella lejana; aspecto gélido, remoto y silencioso, de belleza inhóspita. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

### Miller · **imaginario (filmografía)** · *Interstellar*

> Mundo **oceánico global**: superficie de agua somera y brillante que cubre todo el planeta, con reflejos plateados y enormes crestas de olas recorriéndolo; al fondo, dominando el cielo, un **agujero negro supermasivo** con su disco de acreción dorado curvándose sobre sí mismo (estilo *Gargantúa*), que dobla y distorsiona la luz a su alrededor; iluminación intensa y sobrecogedora. *Vista orbital a media distancia, encuadre 16:9; luz rasante que perfila la atmósfera; fondo de espacio profundo con campo de estrellas y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*

### Zegema Beach · **imaginario (filmografía)** · *Starship Troopers* (mundo-balneario)

> Mundo-balneario tropical: océanos turquesa cálidos con largas **cadenas de islas** de arena blanca, lagunas cristalinas y franjas de selva costera; cielos despejados y soleados, con luz dorada de vacaciones; en un extremo del planeta, unas **nubes de tormenta lejanas** introducen una sutil sombra ominosa (la amenaza latente que acabaría cayendo sobre este paraíso); aire de folleto turístico cósmico. *Vista orbital a media distancia, encuadre 16:9; luz rasante de una estrella fuera de cuadro que perfila la atmósfera; fondo de espacio profundo con campo de estrellas, Vía Láctea y galaxias lejanas; fotorrealista, gran resolución, iluminación volumétrica, concept-art astronómico cinematográfico; sin texto ni marcas de agua.*
