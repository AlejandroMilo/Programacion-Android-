# ExRE — Explorador de Recursos de Estudio

Aplicación móvil desarrollada con **Flutter** para Android como parte de una práctica de desarrollo de aplicaciones móviles.

ExRE permite explorar recursos de estudio organizados por categorías, consultar su información, marcarlos como favoritos y registrar cuáles han sido completados.

## Descripción

**ExRE (Explorador de Recursos de Estudio)** es una aplicación educativa que presenta una colección de recursos de aprendizaje almacenados localmente.

La aplicación permite:

* Consultar un catálogo de recursos de estudio.
* Buscar recursos por título, categoría o autor.
* Filtrar recursos por categoría.
* Visualizar los recursos mediante una galería.
* Consultar el detalle de cada recurso.
* Marcar recursos como favoritos.
* Marcar recursos como completados o pendientes.
* Consultar el progreso general de estudio.
* Mostrar el estado del ciclo de vida de la aplicación.

La aplicación utiliza datos locales de prueba y no requiere servidor, autenticación ni base de datos remota.

## Tecnologías utilizadas

* **Flutter**
* **Dart**
* **Material 3**
* Aplicación destinada a **Android**
* Datos locales en memoria
* Navegación mediante `Navigator` y navegación inferior

## Pantallas

La aplicación está formada por seis pantallas principales:

1. **Inicio**

    * Presenta el propósito de ExRE.
    * Muestra accesos rápidos a las diferentes secciones.
    * Muestra estadísticas de recursos, favoritos y recursos completados.
    * Informa sobre el estado actual del ciclo de vida de la aplicación.

2. **Catálogo**

    * Presenta los recursos en una lista vertical.
    * Permite buscar por título, categoría o autor.
    * Permite seleccionar una categoría.
    * Permite acceder al detalle de cada recurso.

3. **Galería**

    * Presenta los recursos en formato de cuadrícula.
    * Utiliza `GridView.builder`.
    * La cuadrícula utiliza dos o más columnas.
    * Permite abrir el detalle de un recurso.

4. **Detalle**

    * Muestra la información completa del recurso.
    * Incluye título, categoría, autor, duración, nivel y descripción.
    * Permite marcar o quitar un recurso de favoritos.
    * Permite marcar el recurso como completado o pendiente.
    * Incluye contenido/enlace simulado.

5. **Favoritos**

    * Muestra únicamente los recursos marcados como favoritos.
    * Permite acceder al detalle.
    * Permite eliminar recursos de favoritos.
    * Incluye un estado vacío cuando no existen favoritos.

6. **Progreso**

    * Muestra el progreso de estudio.
    * Diferencia entre recursos completados y pendientes.
    * Permite visualizar las estadísticas de progreso.

## Recursos de estudio

La aplicación contiene recursos de estudio almacenados localmente.

Cada recurso dispone de:

* Identificador único.
* Título.
* Categoría.
* Autor.
* Duración en minutos.
* Nivel: básico, intermedio o avanzado.
* Descripción.
* Tipo de recurso.
* Color representativo.
* Estado inicial pendiente.

Las categorías utilizadas incluyen:

* Flutter
* Android
* Layouts
* Scrollables
* Slivers
* Navegación

## Estado de la aplicación

El estado principal se concentra en `EstadoApp`.

Se gestionan:

* Lista de recursos.
* Identificadores de favoritos.
* Identificadores de recursos completados.
* Texto de búsqueda.
* Categoría seleccionada.
* Recurso seleccionado.
* Último estado del ciclo de vida.
* Historial breve de estados del ciclo de vida.

Los cambios de favoritos y progreso se reflejan en las diferentes pantallas de la aplicación.

## Ciclo de vida

La aplicación observa los cambios del ciclo de vida mediante `WidgetsBindingObserver`.

Se registran estados como:

* Activa (`resumed`)
* Inactiva (`inactive`)
* Oculta (`hidden`)
* En pausa (`paused`)
* Desconectada (`detached`)

También se conserva un historial breve de los últimos estados registrados.

## Estructura del proyecto
d
exre_proyecto/
├── android/
├── lib/
│   ├── datos/
│   │   └── recurso.dart
│   │
│   ├── estado/
│   │   └── estado_app.dart
│   │
│   ├── modelos/
│   │   └── recursos_estudiados.dart
│   │
│   ├── pantallas/
│   │   ├── catalogo.dart
│   │   ├── detalle.dart
│   │   ├── favoritos.dart
│   │   ├── galeria.dart
│   │   ├── inicio.dart
│   │   └── progreso.dart
│   │
│   ├── tema/
│   │   └── tema_app.dart
│   │
│   ├── widgets/
│   │   └── barra_navegacion_inferior.dart
│   │
│   └── main.dart
│
├── pubspec.yaml
└── README.md
```

## Navegación

La navegación principal se realiza mediante una barra de navegación inferior.

Desde **Inicio** se puede acceder a:

* Catálogo
* Galería
* Favoritos
* Progreso

Desde **Catálogo**, **Galería** y **Favoritos** se puede acceder al **Detalle** de un recurso.

Desde **Detalle** se puede regresar a la pantalla anterior.

## Requisitos

Para ejecutar el proyecto se necesita:

* Flutter instalado.
* Dart incluido con Flutter.
* Android Studio.
* Android SDK configurado.
* Un dispositivo Android físico o un emulador.

Para comprobar la instalación de Flutter:
flutter doctor


Para comprobar los dispositivos disponibles:
flutter devices


## Instalación
Clonar o abrir el proyecto y situarse en la carpeta raíz:
cd exre_proyecto

Instalar las dependencias:
flutter pub get

Comprobar el proyecto:
flutter analyze


## Ejecución
Para ejecutar la aplicación en el dispositivo disponible:
flutter run


También se puede especificar un dispositivo:
flutter run -d ID_DEL_DISPOSITIVO


## Compilación para Android
Para generar una versión APK de lanzamiento:
flutter build apk --release


El APK generado se encuentra normalmente en:
build/app/outputs/flutter-apk/app-release.apk


## Diseño

La interfaz utiliza un diseño visual oscuro basado en tonos índigo.

La aplicación utiliza:

* Fondo oscuro.
* Superficies diferenciadas para tarjetas.
* Color primario índigo.
* Texto principal claro.
* Texto secundario para información complementaria.
* Color específico para favoritos.
* Color específico para estados de éxito.
* Tarjetas, chips y navegación inferior.

El diseño está orientado a mantener una interfaz clara y consistente en dispositivos móviles.

## Componentes y listas

La aplicación utiliza los componentes de desplazamiento requeridos para presentar los recursos.

Entre ellos:

* `ListView`
* `ListView.builder`
* `ListView.separated`
* `GridView.builder`
* `SliverGridDelegateWithFixedCrossAxisCount`

La galería utiliza una cuadrícula con columnas y espaciado uniforme.

## Alcance del proyecto

Este proyecto utiliza datos locales de prueba y está diseñado para demostrar:

* Desarrollo de interfaces con Flutter.
* Organización de código por capas.
* Navegación entre pantallas.
* Gestión de estado mediante las herramientas propias de Flutter.
* Uso de listas y cuadrículas.
* Filtrado y búsqueda.
* Gestión de favoritos.
* Seguimiento de progreso.
* Manejo del ciclo de vida de una aplicación.

No se utilizan servicios de servidor, autenticación ni bases de datos remotas.
