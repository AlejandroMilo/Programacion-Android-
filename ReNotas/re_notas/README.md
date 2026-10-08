# ReNotes — Notas de Investigación

Aplicación **Flutter para Android** que permite organizar el trabajo de
investigación en proyectos, escribir notas largas dentro de cada proyecto y
clasificarlas con etiquetas que el propio usuario crea y reutiliza.

Todos los datos viven **en memoria** mientras la app está abierta y se cargan
de un conjunto de datos de prueba incluido en el proyecto. No hay servidor,
base de datos, almacenamiento local ni autenticación.

---

## Requisitos previos

| Componente | Versión mínima |
|---|---|
| **Flutter SDK** | 3.13.2 o superior (probado con Flutter 3.47.2, Dart 3.13.2) |
| **Android Studio** | Con el Android SDK instalado (probado con SDK 36) |
| **Java (JDK)** | 17 o superior, incluido con Android Studio |
| **Dispositivo** | Emulador Android o teléfono con depuración USB activada |

Puedes comprobar que todo está bien instalado con:

```bash
flutter doctor
```

La línea *Android toolchain* debe aparecer marcada con `[√]`.

---

## Cómo inicializar y ejecutar el proyecto

### 1. Clonar el repositorio

```bash
git clone https://github.com/AlejandroMilo/Programacion-Android-.git
cd Programacion-Android-
```

### 2. Entrar en la carpeta del proyecto Flutter

```bash
cd ReNotas/re_notas
```

### 3. Descargar las dependencias

```bash
flutter pub get
```

### 4. Comprobar que hay un dispositivo disponible

```bash
flutter devices
```

Si no hay ninguno, abre un emulador con:

```bash
flutter emulators
flutter emulators --launch <nombre_del_emulador>
```

También puedes crear uno desde Android Studio: **Device Manager → Create
device**.

### 5. Ejecutar la aplicación

```bash
flutter run
```

Con el emulador o el teléfono conectado, la app se instala y arranca
automaticamente. Para reiniciar en caliente durante el desarrollo usa la
tecla `r`; para recargar completo, `R`.

---

## Generar un APK instalable

```bash
# Versión de depuración (rápida, para probar)
flutter build apk --debug

# Versión de publicación
flutter build apk --release
```

El archivo se genera en:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## Ejecutar las pruebas

```bash
flutter test
```

---

## Estructura del proyecto

```
re_notas/
├── lib/
│   ├── main.dart                  # Arranque, temas claro/oscuro y BottomNavigationBar
│   ├── diseno/
│   │   └── sistema.dart           # Paleta, espaciado, radios, SnackBar, estados vacíos
│   ├── modelos/                   # Entidades: Proyecto, Nota, Etiqueta
│   │   ├── proyecto.dart
│   │   ├── nota.dart              # Incluye favorita y fijada
│   │   └── etiqueta.dart
│   ├── datos/
│   │   └── datos_prueba.dart      # Datos de prueba cargados al iniciar
│   ├── estado/
│   │   └── estado_aplicacion.dart # Estado en memoria (ChangeNotifier)
│   ├── componentes/               # Widgets reutilizables
│   │   ├── barra_navegacion.dart
│   │   ├── etiqueta_visual.dart
│   │   ├── tarjeta_nota.dart
│   │   └── tarjeta_resultado_nota.dart
│   └── pantallas/                 # Las seis pantallas
│       ├── proyectos.dart         # RF1
│       ├── notas_proyecto.dart    # RF2
│       ├── editar_nota.dart       # RF3 (autocompletado de etiquetas)
│       ├── detalle_nota.dart      # RF4
│       ├── etiquetas.dart         # RF5
│       └── busqueda.dart          # RF6
├── test/
└── pubspec.yaml
```

---

## Funcionalidades

- **Proyectos**: crear, editar y eliminar proyectos. Al eliminar un proyecto
  se eliminan sus notas; las etiquetas se conservan.
- **Notas**: crear, editar y eliminar notas con título obligatorio y
  descripción de texto largo sin límite de caracteres.
- **Búsqueda dentro de cada proyecto** por título o contenido.
- **Filtro por etiquetas** dentro de cada proyecto.
- **Autocompletado de etiquetas** al escribir: ignora mayúsculas y acentos,
  busca en cualquier parte del nombre, no sugiere las etiquetas que la nota ya
  tiene y ofrece crear la etiqueta si no existe. Se puede confirmar tocando la
  sugerencia, con **Enter** o escribiendo una **coma**.
- **Etiquetas globales**: se reutilizan entre proyectos y nunca se duplican.
  Se pueden renombrar y eliminar (el cambio se refleja en todas las notas).
- **Agrupación de notas** por varias etiquetas, eligiendo si se muestran las
  que tienen *todas* las etiquetas seleccionadas o *al menos una*.
- **Búsqueda global** en las notas de todos los proyectos, con filtro por
  proyecto y por etiquetas.
- **Navegación** con `BottomNavigationBar` (Proyectos, Etiquetas, Buscar) que
  conserva el estado de cada pestaña.
- **Notas favoritas y fijadas**: estrella para favoritas, chincheta para
  fijar arriba, con filtros en el proyecto y en la búsqueda.
- **Deshacer al eliminar**: cada borrado de proyecto, nota o etiqueta ofrece
  "Deshacer" en el aviso.
- **Orden de proyectos**: más recientes, por nombre o con más notas.
- **Deslizar para eliminar** en proyectos y notas, con confirmación.
- **Tema claro y oscuro** desde la barra de la pantalla de proyectos.
- **Diseño uniforme**: bordes de 16–20 px, sombras suaves, animación de
  200 ms al abrir pantallas, fechas relativas ("hace 2 h") y contador de
  caracteres en el editor.

---

## Capturas de pantalla

Las capturas de las seis pantallas y del autocompletado de etiquetas están en
la carpeta [`../Capturas de pantalla/`](../Capturas%20de%20pantalla/).

---

## Tecnologías

- Flutter 3.47.2 / Dart 3.13.2
- Estado con `ChangeNotifier` del propio SDK de Flutter (sin paquetes
  externos de estado).
- Navegación con `Navigator.push`.
- Widgets del SDK: `ListView.builder`, `ListView.separated`, `Wrap`,
  `Autocomplete`, `BottomNavigationBar`, `PopScope`.
- Sin paquetes de almacenamiento local ni bases de datos.

---

## Asignatura

**Programación para Dispositivos Móviles** — Proyecto práctico *App ReNotes*.
