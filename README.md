# RadioStations
Swift Radio Stations

## Tarea 2- iOS avanzado

# Audio, JSON y CoreData

## Resumen

El objetivo de esta tarea es que el alumno se familiarice con una de las librerías de persistencia
de datos más importante en el desarrollo de apps para iOS, ​CoreData​, seguir trabajando con las
APIs que nos ofrece Swift para trabajar con el formato JSON, realizar peticiones a servicios web
desde Swift, reproducir audio con ​AVKit​, además de seguir trabajando con elementos de ​UIKit​.
En esta tarea, el alumno desarrollará una app en la que podrá seleccionar una emisora de radio
online, de un género musical específico, y reproducir en streaming esa emisora desde la misma
app. Además, el usuario podrá marcar cuáles serán sus emisoras favoritas para acceder a ellas
con mayor facilidad.


## Paso 0 - Creación del proyecto y organización de ficheros

1. Abrimos Xcode para crear un proyecto nuevo con la plantilla ​“Single View App”
2. Debemos darle un nombre al proyecto, en el caso de esta práctica, se ha llamado
    **RadioStation**

### 3. Seleccionamos Swift como lenguaje y ​desactivamos las casillas de ​“Core Data”​,​ ​“Unit

### Tests”​ y ​“UI Tests”

```
a. Más tarde añadiremos soporte a Core Data de forma manual
```
### 4. En el último paso, desactivaremos la casilla de ​“Create Git repository on my Mac”​, ya que

```
no vamos a utilizar un VCS en esta tarea
```
5. En la sección de la derecha de Xcode (Navigator) crearemos un nuevo grupo al que

### llamaremos Supporting Files, donde moveremos los ficheros “​AppDelegate.swift​” y

### “LaunchScreen.storyboard”​, además de crear los grupos ​Model​, ​View​, ​Controller​ y

```
Extensions
```

6. Para adelantar en la búsqueda de imágenes que más tarde necesitaremos durante el
    desarrollo del proyecto, busca y añade las siguientes imágenes (deberás añadirlas en

### ”Assets.xcassets”​ ):

```
a. Una imagen de fondo, que utilizaremos en todas las vistas de la app
b. Un icono para añadir a favoritos
c. Un icono para eliminar de favoritos
d. Un icono para pausar la reproducción
e. Un icono para ejecutar la reproducción
```

f. Un icono de sustitución, para utilizarlo cuando una emisora no tenga una imagen
g. Un icono para un ​Bar Button Item​, que nos permitirá ir a las emisoras favoritas
i. El tamaño de estos dos deberán ser de 72x72 (@3x) y 48x48 (@2x)
h. Opcionalmente, puedes añadir un icono para la app
i. Puedes utilizar la web de ​App Icon Generator​ para generar los distintos
tamaños


## Paso 1 - Creación y protocolos de TagsViewController

La vista con la que arrancará la app deberá mostrar un listado de etiquetas de estaciones que
posteriormente nos devolverá la API que más tarde veremos. Para ello, y dado que ya hemos
trabajado bastante con los Table Views, vamos a seguir una aproximación diferente para mostrar
el Table View de esta vista:

1. El primer paso consiste en renombrar el fichero y la clase ViewController por
    TagsViewController (y mover ese fichero al grupo ​Controller​ que hemos creado en el
    paso anterior)
2. El siguiente paso reside en arrastrar un Table View Controller en ​“Main.storyboard”
3. Seguidamente, moveremos la flecha del View Controller por defecto a este
    TableViewController, y eliminaremos el primer View Controller


4. Luego, hay que modificar TagsViewController para que, en vez de heredar de
    UIViewController, lo haga de ​UITableViewController
       a. De otro modo, no podríamos asignar ese controlador a la vista que hemos creado
          en ​“Main.storyboard”

### 5. Finalmente, en ​“Main.storyboard” ​asignamos la clase TagsViewController a la vista, y

embebemos esa vista en un Navigation Controller
Uno de los beneficios de utilizar esta aproximación es que, por defecto, la Table View ocupará
toda la pantalla, pero el más importante es que por defecto adopta los protocolos necesarios
para mostrar información en la misma (En la ​documentación​ se especifica cuáles son estos
beneficios con más detalle).
Dado que estamos siguiendo otras aproximaciones para la creación de tablas, vamos a crear la
celda también de otro modo, para lo que deberás eliminar esa celda de la Table View.


Dado que UITableViewController asume que los protocolos ​delegate​ y el ​dataSource​ son
implementados por la clase, el siguiente paso será crear los métodos básicos que permitan
mostrar una serie de elementos y seleccionar una fila:
**Ejercicio** ​:
Define y añade una implementación básica de los métodos siguientes, a través de una extensión
de la clase:

- Delegate​:
    **- tableView(_:didSelectRowAt:)**
       - Lo único que deberás hacer aquí será forzar la de-selección de la celda
- DataSource
    **- cellForRow(at:)**
       - Deberás crear una celda sin reuse identifier, ya que luego lo añadiremos
    **- tableView(_:numberOfRowsInSection:)**
    **- tableView(_:heightForRowAt:)**
       - Si quieres modificar la altura de la celda
Dado que esta clase, por heredar de UITableViewController, asume que implementamos el
delegate y el dataSource, la sintaxis para crear una extensión con tal de implementar ambos
protocolos varía, no siendo necesario especificar qué protocolo vamos a implementar. En este
caso, hacer una extensión de la clase nos sirve para organizar el código.
Además, los métodos deberán ser anotados como ​override​, dado que estamos sobreescribiendo
la implementación base de UITableViewController.


Como ves, mostramos unos géneros de forma temporal, almacenados en un array, y deberíamos
obtener un resultado parecido al siguiente:


El siguiente paso consiste en modificar unos parámetros del ​Navigation Item​ y el ​Navigation Bar

### que hay en TagsViewController, de entre los cuales deberás, a través de ​“Main.storyboard”​:

1. Modificar el título del Navigation Item
2. Modificar el estilo del Navigation Bar a Black
3. Especificar que se prefieren títulos grandes en el Navigation Bar
4. Modificar el color de los textos del Navigation Bar


El siguiente paso consiste en la creación de una celda propia, sin embargo, en este caso vamos

### a seguir una aproximación diferente, creando un fichero ​.xib​ individual para el diseño de la celda:

### 1. En el grupo ​View​, crea un nuevo fichero de tipo ​User Interface -> Empty​, y nombra el

```
fichero como TagCell
```
### 2. Al abrir ese fichero, Xcode mostrará una vista similar un ​.storyboard​, con lo que el

```
siguiente paso será arrastrar un ​TableViewCell​, y asignarle un Identifier (e.g. “TagCell”)
```
3. Luego, diseña la celda como veas conveniente, utilizando constraints, y teniendo en
    cuenta que vamos a necesitar 2 elementos:
       a. 1 Label para mostrar el género
       b. 1 Label para mostrar la letra inicial del género


### 4. Seguidamente, vamos a crear un fichero ​Cocoa Touch Class​ en el grupo ​View​, llamado

```
TagCell, que deberá heredar de la clase UITableViewCell
```
### a. Asegúrate que la casilla ​“Also create XIB file”​ está deseleccionada

### 5. Una vez creada la clase TagCell, asígnala a la celda desde ​“TagCell.xib”​, y crea los

```
@IBOutlets para ambos Label
```

El último paso de este apartado reside en mostrar esa celda en la TableView, sin embargo, y
como el proceso seguido ha sido diferente, hay que realizar algunas modificaciones a nuestro
código, específicamente en TagsViewController:

### 1. En ​ viewDidLoad() ​, deberás ​registrar​ la celda, a través del nombre del fichero ​.xib​, así

```
como su identificador
```
2. En ​ **cellForRow(at:)** ​ deberás utilizar la clase propia que has creado para la celda. Has de
    mostrar el nombre de la etiqueta en cada una de las filas, reutilizando las celdas
    mediante el identificador


**Ejercicio** ​:
Llegado este punto, vamos a ‘customizar’ un poco más esta vista, para lo que se pide:

1. Añadir una imagen de fondo a la TableView, desde código, teniendo en cuenta que
    deberás:
       a. Crear un ​UIImageView​ desde código donde ​mostrar​ la imagen de fondo que
          añadiste en el paso 0
       b. Especificar el tamaño del UIImageView, a través de su ​frame​, al frame de la
          TableView
       c. Establecer el ​vista de fondo​ de la TableView a esa UIImageView
       d. Buscar cómo ​visualizar la imagen de forma correcta​, dado que por defecto, saldrá
          deformada
2. Deberás hacer que las celdas pares sean de color ​transparente​ y las impares de color
    negro, pero con ​opacidad​ baja
3. Finalmente, deberás mostrar la letra inicial de cada etiqueta en su @IBOutlet
    correspondiente


## Paso 2 - Registro y acceso a la API de ​Community Radio

## Browser​ para la obtención de categorías/etiquetas para el

## streaming

Community Radio Browser ofrece un servicio a modo de directorio de radios que emiten por
streaming, además de presentar una API para que los desarrolladores hagan consultas del tipo
“Emisoras más populares”, “Emisoras por etiqueta”, e incluso permite la creación de emisoras
nuevas. Cabe destacar que el resultado de las llamadas a esta API son en formato JSON, por lo
que se requiere que el alumno conozca la estructura es este formato.
La documentación de la API para desarrolladores la puedes encontrar en los siguientes enlaces:
(​link panel​, ​link documentación​)
Antes de empezar a realizar peticiones a la API desde nuestra app, vamos a organizar el código
donde realizaremos esas peticiones, por lo que el primer paso será:

### 1. Crear un fichero ​“RadioAPI.swift”​ vacío, en el grupo ​Model

2. En ese fichero, definiremos un enum RadioAPI con 2 variables estáticas
    a. En una, almacenaremos la URL base para el acceso a la API
       i. [http://de1.api.radio-browser.info/](http://de1.api.radio-browser.info/)
    b. En la otra, almacenaremos el formato de la respuesta, que forma parte de las
       peticiones que más tarde haremos (La API soporta los formatos JSON y XML)
          i. json
3. El siguiente paso es montar la URL para realizar una petición a la API que nos devuelva
    cuáles son las etiquetas posibles que puede devolver la API para la posterior búsqueda
    de la emisora:


4. A continuación, deberás modificar el modelo de datos donde almacenas, de forma literal,
    los géneros, y utilizar un [String], con lo que al ejecutar la app, la TableView deberá
    aparecer vacía
5. Antes de realizar la petición a la API, por motivos de seguridad, Apple exige que las
    conexiones que hagan nuestras apps al exterior sean seguras, por lo que deberemos
    añadir las siguientes entradas al el fichero ​Info.plist
       a. NSAppTransportSecurity
          i. NSAllowsArbitraryLoads
6. La petición a esta URL (TagsURL) devuelve un fichero en formato JSON del siguiente

### estilo, es decir, un array de objetos, con los campos ​name​ y ​stationcount​. A nosotros nos

```
interesa quedarnos con el campo ​name
[
{“name” : ”10s”, “stationcount” : 1},
{“name”: “80s pop”, “stationcount”: 3},
{“name”: “jazz”, “stationcount”: 553}
]
```

7. Deberás, a continuación, implementar el siguiente método en “RadioAPI.swift”, dentro del
    enum:
       a. Declaración de la función, que acepta una closure, la cual invocaremos al
          recuperar las categorías musicales. La anotación @escaping se utiliza porque la
          closure podrá ser invocada incluso ​después de que la función finalice
       b. El ​constructor​ del struct ​URL​ devuelve un opcional, siendo nil el valor si la URL
          está mal formada
       c. Utilizamos el ​singleton​ shared de la clase ​URLSession​ para realizar una petición
          simple. La función ​ **dataTask(with:completionHandler:)** ​ nos permite crear una
          tarea, lista para realizar la petición, e invoca un completion handler tras realizarla
       d. Rodeamos el siguiente código en un bloque do {} catch {} porque algunas líneas
          pueden lanzar una excepción
       e. Intentamos convertir la respuesta, que ya sabemos que es un array de objetos, en
          un [Any]
       f. Ese array de objetos [Any] sabemos que en realidad es un listado de objetos tipo
          clave-valor, por lo que intentamos convertir cada uno de esos objetos en un
          diccionario [String: Any]

### g. Iteramos por esos objetos para extraer la propiedad/campo ​name​, que es la que

```
nos interesa
h. Invocamos ese closure con los resultados parseados desde el JSON
i. Por defecto, una ​URLSessionDataTask​ no se invoca automáticamente, sino que
deberemos ​ejecutarla​ cuando creamos conveniente
```

**Ejercicio** ​:
Ahora deberás modificar el método ​ **didViewLoad()** ​ de TagsViewController para recuperar el
listado de etiquetas a través de la función que acabamos de definir, y actualizar la TableView con
ese contenido.
Recuerda que en iOS, ​solo el hilo principal puede actualizar la interfaz​.


## Paso 3 - Creación de StationsViewController

El siguiente paso reside en mostrar, para una etiqueta elegida, el listado de emisoras que

### pertenezcan a tal categoría. El primer paso será crear la vista en ​“Main.storyboard”​ y crear una

clase StationsViewController para asignarla como View Controller para esa vista:

### 1. En ​“Main.storyboard”​, arrastramos un View Controller

2. Creamos un fichero, en el grupo Controller, con la clase StationsViewController, que
    heredará de UIViewController
3. Asignamos en Main.storyboard la clase StationsViewController como clase para la vista
    que acabamos de crear
4. Vamos a arrastrar un Table View a la vista, y haremos que ocupe todo el espacio
    disponible mediante constraints
5. Vamos a asignar el delegate y el dataSource de esa Table View, pero esta vez, desde
    “Main.storyboard”
       a. Para hacerlo, deberás hacer ctrl + drag desde la Table View hasta el View
          Controller


6. No te olvides de conectar, mediante un IBOutlet, la TableView y el controlador
7. Finalmente, crearemos un segue desde el View Controller de la vista TagsViewController
    hasta StationsViewController, al que vamos a identificar como ​ **“showStationsForTag”**
       a. Al hacer esto, esta vista quedará embebida en el Navigation Controller


### 8. Antes de avanzar, si cambiamos el dispositivo del ​“Main.storyboard”​ a un iPhone X, por

```
ejemplo, veremos que la Table View no se habrá anclado bien a los bordes, por lo que
habría que eliminar los constraints top y bottom, redimensionar el Table View, y volver a
establecer los constraints
```

**Ejercicio** ​:
Desde TagsViewController, a través del segue, navega a StationsViewController al seleccionar
un elemento de la lista.

### Para que la app funcione al realizar la transición, deberás añadir ahora los protocolos ​delegate​ y

### dataSource​ del Table View en StationsViewController, con la implementación por defecto que

encuentres oportuna.
**Ejercicio** ​:
Deberás añadir la misma imagen de fondo que has utilizado en StationsViewController.
Asegúrate de que las celdas de la TableView sean transparentes para poder ver el fondo, así
como hacer que el fondo de la Table View también sea transparente.


## Paso 4 - Paso de datos a StationsViewController

En este paso, el objetivo es mostrar en la TableView de StationsViewController el listado de
emisoras que nos devuelva la API, según la categoría/etiqueta musical seleccionada.
**Ejercicio** ​:
Antes de continuar, declara una variable ​tag: String?​ en la clase StationsViewController, y asigna
al título del NavigationItem el valor de esta variable. Si no tiene valor tal variable, asígnale un
valor por defecto al título. Puedes utilizar el operador de ​nil-coalescing​ ?? para contemplar este
caso.
**Ejercicio** ​:
Implementa el método ​ **prepare(for:sender:)** ​ en TagsViewController para, mediante el
identificador del segue, establecer la variable genre de StationsViewController para que
aparezca el género en el título.
Recuerda que puedes utilizar el parámetro sender para pasar sun dato al método
**performSegue(withIdentifier:sender:)**


1. Comparar el identificador del segue
2. Convertir el ViewController destino del segue a StationsViewController
3. Convertir sender a String
4. Asignar el valor de la propiedad genre de StationsViewController
Lo único que necesitamos ahora es recuperar, mediante la API, las estaciones pertenecientes a
la etiqueta seleccionada. Si nos fijamos, la API nos indica que para esta petición, debemos
especificar el identificador de la categoría, dato que actualmente no estamos almacenando (​link​).
La URL tiene el siguiente formato:
[http://de1.api.radio-browser.info/​](http://de1.api.radio-browser.info/​) **{format}** ​/stations/bytag/​ **{searchterm** ​ **}**

### Donde ​format​ será json y ​searchterm​ la etiqueta seleccionada.


Para almacenar esta información, deberemos realizar las siguientes modificaciones en nuestro
código:
**Ejercicio** ​:

### En ​“RadioAPI.swift”​, fuera del enum, declara un ​struct Tag​, que conforme con el protocolo

Decodable​, con 2 campos:

1. name: String
2. stationcount: Int
Utilizamos el protocolo Decodable porque vamos a convertir la respuesta del JSON en objetos
de tipo Tag.
Para utilizar este tipo que acabamos de crear, reemplaza el contenido del bloque do {} catch {} de
la función ​ **getTags()** ​ en RadioAPI por el código siguiente:
Hemos sustituido el proceso de conversión manual del JSON utilizando el protocolo Decodable
para que la conversión se haga de forma automática. Para que el resultado tenga éxito, deberás
asegurarte que los campos del tipo Tag coinciden en nombre y tipo con los del JSON.


1. Actualizado el método, deberás modificar el tipo del parámetro ​onComplete​ de la función
    **getTags()** ​ para que acepte una closure de tipo ([Tag]) -> Void)
2. En TagsViewController, modifica el tipo de la variable ​tags: [String]​ para que sea de tipo
    [Tag]
3. Actualiza el método ​ **cellForRow(at:)** ​ de la misma clase para que utilice la propiedad ​name
    del struct Tag
4. Finalmente, deberás pasar, mediante el segue ​ **“showStationsForTag”** ​, el objeto Tag para
    la celda seleccionada, desde TagsViewController a StationsViewController
       a. No te olvides de actualizar el tipo de la propiedad ​tag​ de StationsViewController
          para que sea del tipo Tag, y mostrar la propiedad ​name​ del struct Tag en el título
          del Navigation Item
Si ejecutamos la app, el comportamiento debería ser el mismo, es decir, al seleccionar una
etiqueta musical, StationsViewController debería mostrar en la barra de navegación la etiqueta
seleccionada. Sin embargo, estamos utilizando una aproximación OOP que permite trabajar con
formatos JSON de una forma más cómoda.
**Ejercicio** ​:
Modifica la aplicación para que muestre el
número de emisoras para cada etiqueta en
TagsViewController.


## Paso 5 - Mostrar las emisoras en StationsViewController

El siguiente paso es mostrar las emisoras para una etiqueta seleccionada:
**Ejercicio** ​:
En RadioAPI, genera una función estática ​ **stationsForTagURL(categoryID: String) -> String** ​ que
forme la URL de forma correcta para realizar la ​petición​ y mostrar las emisoras según la categoría
seleccionada.
Puedes comprobar que la url se genera de forma correcta imprimiendola por consola al mostrar
StationsViewController y comprobando la url en un navegador.

1. Dado el el identificador de las emisoras es el nombre de las mismas, te habrás dado
    cuenta que en ellas pueden aparecer caracteres indeseados al crear una URL, tales como
    símbolos, espacios en blanco...; sin embargo, el tipo String ofrece un ​método​ para
    corregir este problema
Al igual que hemos utilizado el struct Tag para convertir un JSON a un tipo en Swift, el siguiente
paso será aprovechar esta misma funcionalidad y generar un struct que nos permita trabajar más
cómodamente con las emisoras que nos devuelve la API, ya que si echas un vistazo al JSON
generado en este caso, la estructura de este es bastante más compleja que en la petición por
etiquetas:


**Ejercicio** ​:
En RadioAPI, declara un struct que conforme con el protocolo Decodable.

1. struct Station
    a. name: String
    b. url_resolved: String
    c. favicon: String
Los nombres de estas propiedades deben coincidir con los campos el objeto JSON devuelto por
la API.
Como el objetivo es mostrar un listado de emisoras en StationsViewController, vamos a declarar
una propiedad ​station: [Station]?​ en esa clase:


Luego, en la función ​ **viewDidLoad()** ​ deberás seguir los siguientes pasos para recolectar las
emisoras según el género seleccionado:

1. Invocamos a la función ​ **getStations()** ​ de RadioAPI, función que todavía no hemos definido
2. El resultado de la función, al ser asíncrona, es devuelto a través de una closure, y
    asignamos ese resultado al modelo de datos de la Table View
3. Finalmente, como hiciste en TagsViewController, deberás forzar a la Table View a que
    actualice​ la información en el hilo principal, ya que es el único capaz de actualizar la
    interfaz gráfica
**Ejercicio** ​:
Modifica las funciones ​ **numberOfRows(inSection:)** ​ y ​ **cellForRow(at:)** ​ para que trabajen sobre la
propiedad ​stations: [Station]?​, teniendo en cuenta que esa variable puede ser nula


El último paso reside en implementar la función que nos permita recuperar las emisoras a través
de la API, en RadioAPI:

1. Creamos un objeto URL con la url para realizar la petición al servicio
2. Creamos un URLSessionDataTask con el objetivo de realizar la petición
3. Recuperamos el JSON como respuesta de la petición, e intentamos convertirlo a un
    [Station]
4. Invocamos el closure con la información obtenida
5. Finalmente, ejecutamos esa petición al servidor
En este momento, ejecutamos la app, StationsViewController mostrará un listado con las
emisoras que pertenezcan a la etiqueta seleccionada:


**Ejercicio** ​:
Es momento de crear un diseño para la celda de este listado. En este caso, se pide que la celda
muestre una imagen (según la emisora, más tarde veremos como descargar imágenes a través
de una url), así como un label para mostrar el nombre de la emisora.

### Puedes crear la celda dentro de la Table View, en ​“Main.storyboard”​, o crear un fichero ​.xib​ a

parte, como también hemos visto en esta tarea.
Recuerda crear una clase UITableViewCell para conectar los @IBOutlets, asignar un reuse
identifier a la celda, y utilizar tal identificador en ​ **cellForRow(at:)** ​.
Si quieres modificar la altura de la celda, deberás implementar el método
**tableView(_:heightForRowAt:)** ​ del dataSource de la TableView.


## Paso 6 - Creación de RadioPlayerViewController

La última vista que vamos a necesitar será el reproductor de la emisora en sí.
**Ejercicio** ​:

### Ahora deberás crear un ViewController en ​“Main.storyboard”​ para la clase

RadioPlayerViewController, y necesitarás los siguientes elementos de interfaz:
● Image View para el fondo
● Image View para la imagen de la emisora
● Button para reproducir/pausar la emisión
● Slider para modificar el volumen
○ Su valor mínimo deberá ser 0 y su máximo 1
● Button para añadir o eliminar de favoritos


También deberás crear el segue ​ **“showPlayer”** ​ desde StationsViewController a
RadioPlayerViewController, y ejecutarlo al seleccionar una celda del Table View de
StationsViewController.


Como viene siendo habitual, el siguiente paso es conectar, mediante @IBOutlet’s y @IBAction’s
los elementos de la interfaz de RadioPlayerViewController:


**Ejercicio** ​:
Para poder reproducir una emisora en RadioPlayerViewController, deberás pasar la información
sobre la emisora desde StationsViewController a RadioPlayerViewController. En este ejercicio
deberás ser capaz de recuperar la información sobre la emisora seleccionada, e imprimir por
consola tal información en la función ​ **viewDidLoad()** ​ de RadioPlayerViewController.
● Recuerda utilizar el tipo Station, que es el que mantiene información sobre las emisoras
(nombre, url de streaming, imagen...)
● Deberás aprovechar el sender y los segues para realizar el paso de la información
● No te olvides de actualizar el título del NavigationItem de RadioPlayerViewController para
que muestre el nombre de la emisora seleccionada


## Paso 7 - Descarga de la imagen de la emisora

En este paso, queremos mostrar la imagen asociada a la emisora seleccionada, sin embargo, la
clase UIImageView no ofrece ninguna funcionalidad para mostrar una imagen a partir de una url.
No obstante, en este paso vamos a aprovechar la capacidad que nos ofrece Swift para crear
extensiones de clases existentes, y vamos a añadir esa funcionalidad a la clase UIImageView.

### 1. Crea un fichero tipo Swift, llamado ​“UIImageView+UrlImage.swift”​, en el grupo ​Extensions

2. En este fichero, añade el siguiente código:
    1. Creamos una extensión para la clase UIImageView
    2. Si la url pasada por argumento no es válida (nula o sin longitud, por ejemplo),
       mostramos una imagen por defecto
    3. Al realizar la petición y recuperar la imagen en forma de ​Data​, utilizamos el
       constructor​ de la clase UIImage que nos permite convertir estos bytes en una
       imagen, y la asignamos a la propiedad image de la clase UIImageView
          a. Accesible desde self porque estamos creando una extensión de la clase


3. En la función ​ **viewDidLoad()** ​ de RadioPlayerViewController, utiliza esta función para
    mostrar la imagen de la emisora en el @IBOutlet ​stationPicture


**Ejercicio** ​:
Utilizando el método de extensión que acabamos de crear sobre la clase UIImageView, muestra
en StationsViewController las imágenes de todas las emisoras para la etiqueta seleccionada.


## Paso 8 - Reproducción de la emisora por streaming

Para la reproducción de audio por streaming, vamos a utilizar la librería ​AVKit​, que entre otras
funcionalidades, se encarga de la reproducción de vídeos y audio. Para conseguirlo, deberás
hacer las siguientes modificaciones a RadioPlayerViewController:

1. Importar la librería AVKit en la parte superior del fichero
2. Declarar un ​enum PlayerState​, con dos casos posibles:
    a. .playing
    b. .paused
3. Declarar una ​propiedad lazy​ ​player: AVPlayer​ como la siguiente:
    a. Una propiedad lazy nos permite inicializar un tipo solo en caso de que sea
       necesario. En este caso, solo crearemos un objeto de tipo AVPlayer si el usuario
       quiere reproducir la emisora. En caso contrario, nos ahorramos esa operación
4. Crea una extensión de la clase RadioPlayerViewController (por motivos de organización
    de código), e implementa la siguiente función:


5. En esta misma extensión de la clase, define las siguientes funciones, sin implementarlas:
    **a. playStream(from url: String)**
    **b. pauseStream()**
    **c. changeVolume(value: Float)**
    **d. updatePlayerUI(for state: PlayerState)
Ejercicio** ​:
Deberás implementar las siguientes @IBActions:
**● playStopButtonPressed(_ sender: UIButton)**
○ Deberás detectar si el objeto player se está reproduciendo o no para ejecutar la
función ​ **playStream(from:)** ​ o ​ **pauseStream()** ​ según el caso, ya que el mismo botón
sirve para ejecutar como pausar el streaming
**● volumeSliderChanged(_ sender: UISlider)**
○ Invoca el método ​ **changeVolume(value:)** ​ con el valor del slider
**● favButtonPressed(_ sender: UIButton)**
○ Por ahora, lo dejamos sin implementar


El siguiente paso es implementar esos métodos de extensión que hemos declarado:

**1. playStream(from:)**
    a. Tras montar la url del streaming, utilizamos el objeto de tipo AVPlayer para
       reproducir audio a través de esa url y actualizamos la interfaz del usuario
**2. pauseStream()**
    a. Pausar el reproductor
    b. Actualizar la interfaz para el estado .paused
**3. changeVolume(value:)**
    a. Actualizar el volumen del reproductor
**4. updatePlayerUI(for:)**
    a. Actualizamos la imagen del botón play/pause según el estado del reproductor
Con todos estos cambios, la aplicación deberá ser capaz de reproducir/pausar una emisora en
streaming, así como cambiar el volumen de la reproducción.


## Paso 9 - Almacenamiento persistente con CoreData

Esta aplicación debe permitir que el usuario marque una emisora como favorita para poder
acceder a ellas con mayor facilidad. En tareas anteriores hemos visto como conseguir una
persistencia de datos básica mediante ​UserDefaults​, sin embargo, en esta vamos a utilizar el
framework ​CoreData​ que, internamente, está utilizando una BD SQLite, y ofrece una mayor
funcionalidad que UserDefaults, si bien es cierto que la complejidad de su uso es más alta.
El primer paso consiste en definir el modelo de datos a almacenar persistentemente. En este
caso, para una emisora, queremos almacenar su nombre, la url de su imagen, la url de streaming
y si el usuario la ha marcado como favorita o no. La estrategia a seguir para guardar una entrada
en ese almacenamiento reside en que solo será añadida una vez el usuario la marque como
favorita.

### Dado que al crear el proyecto no marcamos la casilla ​“Use Core Data”​, vamos a preparar el

proyecto para que pueda hacer uso de esta librería:

### En primer lugar, vamos a crear un fichero de tipo Data Model al que llamaremos ​“RadioStation”​, y

que será el fichero clave donde daremos forma al modelo de datos:


Si seleccionamos ese fichero, Xcode nos mostrará una interfaz como esta:
Es en este fichero donde crearemos el modelo de datos donde almacenaremos la información
sobre la emisora. En CoreData, ese modelo se llama entity, que vendría a ser como una clase de
POO, una plantilla.
Vamos a añadir un entity nuevo, llamado ​StationEntity​ para evitar conflictos de nombres con el
struct Station:


El siguiente paso es crear las propiedades de esa entidad, o lo que vendría siendo las columnas
en una BD como SQLite. Estas propiedades deberán tener un nombre y un tipo:
En CoreData, podemos marcar un atributo como opcional, aunque ​Apple desaconseja su uso​ por
la forma de trabajar de SQLite, pero no está de más conocer tal posibilidad. Por defecto, todas
las propiedades son opcionales, por lo que vamos a desmarcar esta opción para todas excepto

### para ​imageUrl​:

El último paso a realizar en este fichero es definir si esta entidad utiliza alguna propiedad como
constraint para evitar entradas duplicadas de una entidad. En este caso, vamos a hacer que ese

### contraint sea la propiedad ​name​:


### Si hubiéramos activado la casilla ​“Use Core Data”​ durante la creación del proyecto, Xcode habría

generado este fichero de forma automática, así como haber generado una serie de funciones

### auxiliares en el fichero ​“AppDelegate.swift”​, ya que trabajar con CoreData desde código nos

permite hacer multitud de cosas; sin embargo, ‘hacer las preparaciones previas’ para trabajar con
CoreData puede resultar un poco verboso. Por ello, vamos a añadir esas funciones manualmente
al fichero “AppDelegate.swift”, tras importar CoreData en la parte superior del fichero:

1. Creamos un ​NSPersistentContainer​, que nos permite acceder a la pila de utilidades de
    CoreData, solo en caso de que lo necesitemos durante el uso de la app (lazy). El nombre
    pasado como argumento debe coincidir con el nombre del fichero en el que definimos las
    entidades
2. Intentamos cargar el almacenamiento persistente en ese NSPersistentContainer
3. Las políticas de merging permiten definir qué ocurre cuando hay dos objetos, uno en
    memoria y otro en el almacenamiento, con un conflicto. En este caso,
    NSMergeByPropertyObjectTrumpMergePolicy​ hace que el objeto en memoria
    sobre-escriba al que hay en almacenamiento (por ejemplo, al observar que una URL de
    streaming devuelta por el JSON es diferente a la que hay en CoreData, este actualiza el
    objeto del almacenamiento persistente)


Utilizaremos esta función para guardar cambios en almacenamiento persistente.


Una vez preparado el proyecto para utilizar CoreData, es el momento de almacenar
persistentemente una emisora marcada como favorita.
**Ejercicio** ​:
En RadioPlayerViewController:

1. Declara un ​enum FavState
    a. isFavourite
    b. notFavourite
2. Implementa una función ​ **updateFavouriteUI(for state: FavState)**
    a. Esta función deberá actualizar la imagen de fondo del botón para añadir/eliminar
       de favoritos, en base al parámetro state, al igual que en la función
       **updatePlayerUI(for state: PlayerState)**
          i. Si la emisora ya es favorita, debería mostrar la imagen de eliminar de
             favoritos
ii. Si la emisora no es favorita, debería mostrar la imagen de añadir a
favoritos
    b. En este caso, puedes hacer que el cambio entre una imagen y otra, en vez de ser
       tan brusco, ocurra ​mediante una transición​, utilizando la función
       **UIView.transition(with:duration:options:animations:completion:)** ​ del tipo UIView


A continuación, vamos a implementar una función ​ **addToFavourites()** ​ que será la encargada de
almacenar en CoreData la información sobre la emisora que acabamos de establecer como
favorita. No te olvides de importar CoreData en RadioPlayerViewController:

1. Utilizamos la propiedad lazy que hemos creado en AppDelegate para obtener una
    referencia al ​viewContext​, y que se utiliza, entre otros usos, para la creación de objetos a
    partir de una definición de una entidad
2. Recuperamos la ‘plantilla’/entidad del modelo de CoreData con tal de crear un objeto de
    tipo ​NSManagedObject​. Este tipo es una clase genérica que se utiliza para trabajar con el
    modelo de objetos de CoreData. De hecho, todos los objetos almacenados en CoreData
    heredan de la clase NSManagedObject
3. Establecemos cada una de las propiedades del objeto, a modo clave-valor, según los
    hemos definido en el fichero ​“RadioStation.xcdatamodeld”
4. Guardamos los cambios para que se almacene el objeto
En este momento, si invocamos el método ​ **addToFavourites()** ​ desde ​ **favButtonPressed()** ​,
estaremos añadiendo una entrada a CoreData.


Para ver que los registros se han guardado, puedes editar la configuración del esquema con los
argumentos que aparecen en la captura, que mostrará la carpeta donde se encuentra el fichero
.sqlite al añadir un registro.


A continuación, vamos a preparar la vista de RadioPlayerViewController para que, de un inicio,
muestre el icono correcto, dependiendo de si la emisora es favorita o no:

1. Declara una propiedad ​isFavourite: FavState!
2. Declara una función ​ **setupView()** ​, mueve el contenido de ​ **viewDidLoad()** ​ a esa función
    (excepto la llamada a ​ **super.viewDidLoad()** ​), y llámala en el ​ **viewDidLoad()**
3. Al final de la función ​ **setupView()** ​, añade el siguiente código para recuperar de CoreData
    la entrada sobre la emisora y comprobar si es una emisora marcada como favorita:
       1. Creamos una ​NSFetchRequest​, que no es más que una descripción de una serie
          de criterios para recuperar datos del almacenamiento persistente
       2. Como en SQLite, podemos utilizar ​predicados​ para filtrar los resultados. En este
          caso, nos interesa comprobar si la estación con ese nombre tiene el campo
          isFavourite​ a 1 (true)
       3. La función ​ **count()** ​ devuelve el ​número de objetos que satisfacen los predicados
          que acabamos de establecer
       4. Si hay un elemento que satisface esos predicados, significa que esa emisora ha
          sido marcada como favorita, por lo que deberemos actualizar la interfaz y el
          estado
4. No te olvides de añadir la siguiente línea en la función ​ **addToFavourites()** ​ para actualizar
    el estado


En este momento, si accedemos a una emisora marcada como favorita, debería aparecer el
icono de eliminar de favoritos:
A continuación, solo queda escribir el código necesario para eliminar una emisora como favorita
al pulsar otra vez sobre este botón:
**Ejercicio** ​:
En la función ​ **favButtonPressed()** ​, dependiendo del estado (variable ​isFavourite: FavState!​),
deberás invocar bien la función ​ **removeFromFavourites()** ​ o ​ **addToFavourites()** ​.
El siguiente paso será implementar la función ​ **removeFromFavourites()** ​.


Finalmente, vamos a implementar la función ​ **removeFromFavourites()** ​:

1. En este caso, realizamos una request, pero lo que queremos obtener es una registro, por
    eso especificamos que el resultado de la request sea un NSManagedObject
2. Actualizamos el registro de CoreData


### Si observamos el fichero ​.sqlite​, podemos ver qué emisoras son favoritas y cuáles no tras utilizar

la app:


## Paso 10 - Visualización de las emisoras favoritas

En la última parte de la tarea el objetivo es mostrar una vista filtrada de las emisoras marcadas
como favoritas:
**Ejercicio** ​:
Deberás añadir un BarButtonItem en TagsViewController con un icono que indique acceso a las
emisoras favoritas, conectarlo con un @IBAction, y crear un segue desde TagsViewController
hasta StationsViewController con el identificador ​ **“showFavourites”** ​.


CoreData nos puede generar un modelo de datos para que podamos trabajar con las entidades
de forma más cómoda desde código sin tener que utilizar la clase NSManagedObject. Para que
funcione correctamente en nuestra app, deberemos seguir los siguientes pasos:

1. Especificamos que la generación del código para la entidad ​StationEntity​ sea de tipo
    Manual/None y hacemos un build del proyecto (⌘ + B)

### 2. Navegamos a ​Editor -> Create NSManagedObject Subclass...​ para generar el modelo


3. Es importante que seleccionemos el grupo donde queremos almacenar la clase generada
    ya que, a veces, Xcode no establece una ruta correcta


Al finalizar este proceso, deberemos ver en el grupo ​Model​ dos ficheros:
● StationEntity+CoreDataClass.swift, con la definición de la clase que hereda de
NSManagedObject
● StationEntity+CoreDataProperties.swift, una extensión de la clase con una función que
simplifica el acceso a los registros de esa entidad, así como las propiedades definidas
para la entidad
Para evitar conflictos de nombres y simplificar el uso de esta clase, deberemos realizar los
siguientes 2 cambios al fichero StationEntity+CoreDataProperties.swift:

1. Renombrar ​ **fetchRequest()** ​ por ​ **createFetchRequest()** ​, ya que existe una colisión de
    nombres con fetchRequest
2. Eliminar el? de todas las propiedades


Al realizar estos pasos, simplificamos la recuperación de registros en CoreData, pues el próximo
paso reside en pasar, desde GenresViewController a StationsViewController un [Station] con las
emisoras favoritas al pulsar el Bar Button Item. Dado que CoreData trabaja con el tipo
StationEntity (lo acabamos de crear) pero nuestra app espera trabajar con el tipo Station, en el
siguiente paso vamos a crear un ​constructor​ en el ​struct Station​ que utilice un objeto
StationEntity como base:


**Ejercicio** ​:
Deberás escribir una función estática ​ **fetchFavouriteStations() -> [Station]?** ​ en el enum

### DirbleAPI, ​“Dirble.swift”​, que realice la petición a CoreData para recuperar las emisoras favoritas,

utilizando la función ​ **createFetchRequest()** ​ de StationEntity.

### No te olvides de importar CoreData y UIKit en el fichero ​“Dirble.swift”​.

1. Obtén una NSFetchRequest a través de la clase StationEntity
2. Crea un NSPredicate para obtener solo las emisoras favoritas
3. Utiliza el constructor que has creado en el struct Station para convertir el [StationEntity]
    devuelto por la petición a [Station]
       a. Puedes utilizar la función ​ **map(_:)** ​ para ​simplificar la conversión​ entre
          [StationEntity] y [Station]
**Ejercicio** ​:
Al detectar la pulsación sobre el botón de favoritos (Bar Button Item) en TagsViewController,
recupera esas emisoras favoritas y ejecuta el segue con el identificador ​ **“showFavourites”** ​,
pasando como sender ese [Station]? con las emisoras recuperadas.


**Ejercicio cont** ​. :
En el método ​ **prepare(for:sender:)** ​ de la clase TagsViewController deberás tener en cuenta si el
identificador del segue es ​ **“showFavourites”** ​, y, en caso afirmativo, asignar la propiedad stations
de la clase StationsViewController.
El último cambio necesario en nuestra app hay que realizarlo en StationsViewController, y reside

### en establecer el título de la barra de navegación a “Favoritos” cuando la propiedad ​tag​ sea nil.


