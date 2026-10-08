
import '../modelos/proyecto.dart';
import '../modelos/nota.dart';
import '../modelos/etiqueta.dart';

class DatosPrueba {
  static final List<Proyecto> proyectos = [
    Proyecto(
      id: 'proyecto_flutter',
      nombre: 'Desarrollo móvil',
      descripcion: 'Aplicaciones creadas con Flutter y Dart.',
    ),
    Proyecto(
      id: 'proyecto_web',
      nombre: 'Desarrollo web',
      descripcion: 'Prácticas y proyectos de HTML, CSS y JavaScript.',
    ),
    Proyecto(
      id: 'proyecto_python',
      nombre: 'Programación con Python',
      descripcion: 'Ejercicios, algoritmos y automatización.',
    ),
  ];

  static final List<Etiqueta> etiquetas = [
    Etiqueta(id: 'etiqueta_importante', nombre: 'Importante'),
    Etiqueta(id: 'etiqueta_estudio', nombre: 'Estudio'),
    Etiqueta(id: 'etiqueta_pendiente', nombre: 'Pendiente'),
    Etiqueta(id: 'etiqueta_ideas', nombre: 'Ideas'),
    Etiqueta(id: 'etiqueta_codigo', nombre: 'Código'),
    Etiqueta(id: 'etiqueta_personal', nombre: 'Personal'),
    Etiqueta(id: 'etiqueta_revision', nombre: 'Revisión'),
    Etiqueta(id: 'etiqueta_archivo', nombre: 'Archivo'),
  ];

  static final List<Nota> notas = [
    // PROYECTO 1: DESARROLLO MÓVIL

    Nota(
      id: 'nota_01',
      proyectoId: 'proyecto_flutter',
      titulo: 'Configurar el entorno de Flutter',
      descripcion: '''
Instalar Flutter y configurar las herramientas necesarias para desarrollar aplicaciones móviles.

Pasos:
1. Instalar el SDK de Flutter.
2. Configurar las variables de entorno.
3. Instalar Android Studio o las herramientas de Android.
4. Comprobar la instalación con flutter doctor.
5. Crear un proyecto de prueba.
6. Ejecutar la aplicación en un emulador o teléfono.

Antes de continuar, comprobar que todas las herramientas necesarias estén funcionando correctamente.

Si flutter doctor marca algún problema, revisar la versión del SDK de Java, el directorio del Android SDK y las variables de entorno antes de continuar. También conviene activar el modo depuración para obtener mensajes de error más detallados y comprobar que el emulador reconoce la aceleración de hardware.
''',
      etiquetasIds: ['etiqueta_importante', 'etiqueta_estudio'],
    ),
    Nota(
      id: 'nota_02',
      proyectoId: 'proyecto_flutter',
      titulo: 'Aprender los fundamentos de Dart',
      descripcion: '''
Dart es el lenguaje que utilizaremos para desarrollar ReNotes.

Los conceptos que debo practicar incluyen variables, tipos de datos, funciones, clases, constructores, listas, mapas y programación orientada a objetos.

También es importante comprender la diferencia entre los atributos finales y los atributos modificables, así como aprender a utilizar null safety.

Después de estudiar cada concepto, crear pequeños ejemplos que permitan comprobar cómo funciona antes de incorporarlo a la aplicación principal.
''',
      etiquetasIds: ['etiqueta_estudio', 'etiqueta_codigo'],
    ),
    Nota(
      id: 'nota_03',
      proyectoId: 'proyecto_flutter',
      titulo: 'Diseñar la interfaz de ReNotes',
      descripcion: '''
La interfaz de ReNotes utilizará una combinación de grafito, gris carbón, borgoña y dorado arena.

El fondo principal será oscuro para proporcionar una apariencia elegante. Las tarjetas tendrán un tono ligeramente más claro para separarse visualmente del fondo.

Los botones principales utilizarán el color dorado arena, mientras que los elementos seleccionados y algunos iconos podrán utilizar el borgoña.

La interfaz debe ser clara, fácil de utilizar y adaptable a diferentes tamaños de pantalla. Los textos largos deberán poder desplazarse sin provocar desbordamientos.
''',
      etiquetasIds: ['etiqueta_ideas', 'etiqueta_codigo'],
    ),
    Nota(
      id: 'nota_04',
      proyectoId: 'proyecto_flutter',
      titulo: 'Organizar las pantallas y la navegación',
      descripcion: '''
ReNotes tendrá seis pantallas principales: proyectos, notas de un proyecto, editor de notas, detalle de una nota, etiquetas y búsqueda global.

La barra de navegación inferior permitirá acceder a Proyectos, Etiquetas y Buscar. Al cambiar de sección, se conservará el estado de las pestañas siempre que corresponda.

Desde un proyecto se podrán consultar sus notas. Desde una nota se podrá abrir el detalle o el editor. Las acciones de creación, modificación y eliminación deberán actualizar las vistas relacionadas.

La navegación entre pantallas se resolverá con Navigator.push, de modo que solo exista un único método de navegación en toda la aplicación. Al volver desde el detalle o desde el editor se recuperará la lista anterior conservando el texto de búsqueda, los filtros activos y la posición del scroll.
''',
      etiquetasIds: ['etiqueta_pendiente', 'etiqueta_importante'],
    ),
    Nota(
      id: 'nota_05',
      proyectoId: 'proyecto_flutter',
      titulo: 'Lista de mejoras futuras',
      descripcion: '''
Ideas para mejorar ReNotes después de implementar los requisitos principales.

- Mejorar la presentación de las tarjetas.
- Añadir mensajes claros cuando no existan resultados.
- Comprobar la accesibilidad de los colores y los textos.
- Probar la aplicación en diferentes tamaños de pantalla.
- Revisar que los formularios validen correctamente los campos.
- Evitar que una acción de eliminación se realice accidentalmente.
- Comprobar que las etiquetas se mantengan sincronizadas con las notas.
- Verificar que la búsqueda encuentre palabras dentro de los títulos y descripciones.

Estas ideas se revisarán después de terminar las funciones obligatorias.
''',
      etiquetasIds: ['etiqueta_ideas'],
    ),

    // PROYECTO 2: DESARROLLO WEB

    Nota(
      id: 'nota_06',
      proyectoId: 'proyecto_web',
      titulo: 'Estructura básica de HTML',
      descripcion: '''
HTML permite definir la estructura y el contenido de una página web.

Una página suele contener la declaración del tipo de documento, el elemento html, la cabecera head y el cuerpo body.

Dentro del cuerpo se pueden utilizar encabezados, párrafos, enlaces, imágenes, listas, formularios y otros elementos semánticos.

Es recomendable utilizar etiquetas que describan correctamente el propósito de cada sección. Una estructura semántica bien organizada facilita el mantenimiento del proyecto y ayuda a las tecnologías de asistencia a interpretar el contenido.
''',
      etiquetasIds: ['etiqueta_estudio', 'etiqueta_codigo'],
    ),
    Nota(
      id: 'nota_07',
      proyectoId: 'proyecto_web',
      titulo: 'Crear estilos con CSS',
      descripcion: '''
CSS permite controlar la apariencia de los documentos HTML.

Debo practicar selectores, propiedades, márgenes, rellenos, bordes, colores, tipografías y modelos de disposición como Flexbox y Grid.

También es importante comprender el diseño adaptable para que una página se visualice correctamente en teléfonos, tabletas y ordenadores.

Al crear una interfaz, conviene definir una paleta de colores y mantener una jerarquía visual consistente. Los componentes relacionados deben compartir estilos para que el proyecto sea más fácil de modificar.
''',
      etiquetasIds: ['etiqueta_estudio', 'etiqueta_revision'],
    ),
    Nota(
      id: 'nota_08',
      proyectoId: 'proyecto_web',
      titulo: 'Practicar JavaScript',
      descripcion: '''
JavaScript permite añadir comportamiento e interactividad a las páginas web.

Los temas de estudio incluyen variables, funciones, condiciones, bucles, arreglos, objetos, eventos y manipulación del DOM.

Una buena práctica consiste en separar la estructura HTML, los estilos CSS y la lógica JavaScript en archivos diferentes cuando el proyecto lo permita.

También debo practicar la validación de formularios y la actualización de elementos de la página como respuesta a las acciones del usuario.

Estudiaré además la diferencia entre var, let y const, el uso de funciones flecha y la manipulación del DOM con querySelector. Como práctica final crearé una página sencilla con un formulario que valide los campos antes de enviarlos y que muestre los errores directamente en pantalla.
''',
      etiquetasIds: ['etiqueta_codigo', 'etiqueta_pendiente'],
    ),
    Nota(
      id: 'nota_09',
      proyectoId: 'proyecto_web',
      titulo: 'Planificar una página de portafolio',
      descripcion: '''
El portafolio mostrará los proyectos que he desarrollado y las tecnologías que conozco.

La página podrá incluir una presentación, una sección de habilidades, tarjetas de proyectos y enlaces a repositorios de código.

El diseño debe tener una navegación sencilla y una presentación coherente en diferentes dispositivos. Cada proyecto debería incluir un nombre, una breve descripción, las tecnologías utilizadas y un enlace cuando esté disponible.

Antes de programar, conviene preparar un esquema de las secciones y definir los colores, las tipografías y el estilo de las tarjetas.
''',
      etiquetasIds: ['etiqueta_ideas', 'etiqueta_personal'],
    ),
    Nota(
      id: 'nota_10',
      proyectoId: 'proyecto_web',
      titulo: 'Revisar accesibilidad y diseño adaptable',
      descripcion: '''
Al terminar una página web, revisar que los textos sean legibles, que los enlaces se puedan identificar y que los controles tengan nombres comprensibles.

La página debe poder utilizarse con teclado y no depender únicamente del color para transmitir información.

También es necesario comprobar cómo se comporta el contenido en pantallas estrechas. Las imágenes deben adaptarse al espacio disponible y los elementos no deben desbordarse horizontalmente.

Por último, probar los formularios, los enlaces y la navegación para detectar problemas antes de publicar el proyecto.
''',
      etiquetasIds: ['etiqueta_revision', 'etiqueta_importante'],
    ),

    // PROYECTO 3: PROGRAMACIÓN CON PYTHON

    Nota(
      id: 'nota_11',
      proyectoId: 'proyecto_python',
      titulo: 'Fundamentos de Python',
      descripcion: '''
Python es un lenguaje de programación que se puede utilizar para crear scripts, automatizar tareas, procesar información y desarrollar diferentes tipos de aplicaciones.

Debo practicar variables, tipos de datos, operadores, condiciones, bucles, funciones, listas, tuplas, conjuntos y diccionarios.

También necesito aprender a organizar el código en módulos y utilizar excepciones para gestionar situaciones inesperadas.

La mejor forma de consolidar estos conocimientos es crear ejercicios pequeños y comprobar sus resultados antes de avanzar hacia proyectos más complejos.
''',
      etiquetasIds: ['etiqueta_estudio', 'etiqueta_codigo'],
    ),
    Nota(
      id: 'nota_12',
      proyectoId: 'proyecto_python',
      titulo: 'Automatizar tareas repetitivas',
      descripcion: '''
La automatización permite reducir el trabajo manual en tareas que se repiten.

Algunos ejemplos de práctica son organizar archivos por extensión, renombrar grupos de documentos, analizar archivos de texto y generar informes sencillos.

Antes de ejecutar un script que modifique archivos, debo probarlo con datos de ejemplo y comprobar qué elementos va a cambiar.

También es importante controlar los errores y mostrar mensajes claros para que sea posible comprender qué ocurrió durante la ejecución.

Para los ejercicios utilizaré funciones pequeñas y reutilizables, y guardaré cada script en un archivo independiente con un nombre que indique su propósito. Llevaré también un registro de los casos de prueba empleados, de modo que pueda repetir la comprobación completa siempre que el código cambie.
''',
      etiquetasIds: ['etiqueta_ideas', 'etiqueta_pendiente'],
    ),
    Nota(
      id: 'nota_13',
      proyectoId: 'proyecto_python',
      titulo: 'Practicar listas y diccionarios',
      descripcion: '''
Las listas permiten almacenar elementos ordenados, mientras que los diccionarios permiten asociar claves con valores.

Puedo practicar recorriendo colecciones, buscando elementos, contando apariciones y transformando datos.

Un ejercicio útil consiste en representar una colección de notas mediante diccionarios que contengan un identificador, un título y una descripción. Después se pueden filtrar las notas por título o agruparlas según una propiedad.

Estos ejercicios ayudan a comprender cómo estructurar la información antes de diseñar programas más grandes.
''',
      etiquetasIds: ['etiqueta_codigo', 'etiqueta_estudio'],
    ),
    Nota(
      id: 'nota_14',
      proyectoId: 'proyecto_python',
      titulo: 'Errores y depuración',
      descripcion: '''
Cuando un programa presenta un error, conviene leer el mensaje completo y localizar la línea que lo provoca.

Debo distinguir entre errores de sintaxis, errores durante la ejecución y resultados que no coinciden con lo esperado.

Para investigar un problema puedo imprimir valores intermedios, revisar las condiciones, comprobar los tipos de datos y dividir una operación compleja en pasos más pequeños.

También conviene probar casos normales, entradas vacías y valores inesperados. Una vez corregido el error, debo volver a ejecutar las pruebas para verificar que la solución funciona.
''',
      etiquetasIds: ['etiqueta_revision', 'etiqueta_importante'],
    ),
    Nota(
      id: 'nota_15',
      proyectoId: 'proyecto_python',
      titulo: 'Idea pendiente de desarrollar',
      descripcion: '''
Investigar posibles proyectos pequeños para practicar Python y elegir uno que permita aplicar los conceptos aprendidos.

La idea seleccionada deberá tener un objetivo claro, tareas que se puedan dividir en pasos y resultados que sea posible comprobar.

Antes de comenzar, preparar una lista de requisitos y un plan de implementación. Después desarrollar una primera versión sencilla y ampliarla gradualmente.

Conviene comparar dos o tres ideas y descartar las que dependan de servicios externos o de datos que todavía no están disponibles. Elegiré la que permita tener una primera versión funcional en poco tiempo y que ofrece resultados comprobables sin necesidad de infraestructura adicional.
''',
      etiquetasIds: [],
    ),
  ];
}
