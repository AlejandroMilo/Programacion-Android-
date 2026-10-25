# Turco — Gestor de turnos del salón

Aplicación Android desarrollada en Flutter para administrar los turnos de un
salón de belleza: agenda diaria, alta y edición de turnos, clientes, catálogo
de servicios y equipo de estilistas.

- **Application ID:** `com.alejandromilo.turco`
- **Plataforma:** Android (Flutter)
- **Idioma:** español
- **Datos:** en memoria (sin base de datos ni almacenamiento local)
- **Entorno:** Flutter 3.47.2 · Dart 3.13.2 (Material 3)

## Cómo ejecutarla

```bash
flutter pub get
flutter run
```

Para generar el APK de release:

```bash
flutter build apk --release
```

El archivo queda en `build/app/outputs/flutter-apk/app-release.apk` y también se
copia en `entrega/app-release.apk`. Como `build/` está ignorado por `.gitignore`,
el APK de la entrega se publica además en la sección **Releases** del
repositorio.

## Entrega

```
entrega/
├── app-release.apk   APK de release firmado en modo debug
└── README.md         Esta documentación
capturas/             Capturas reales de la aplicación
```

Para instalar el APK en un dispositivo o emulador:

```bash
adb install -r entrega/app-release.apk
```

Para regenerar las capturas de `capturas/`:

```bash
flutter test test/capturas.dart --update-goldens
```

> El archivo `test/capturas.dart` no termina en `_test.dart` a propósito, para
> que `flutter test` no intente comparar imágenes en cada corrida.

## Arquitectura

Patrón **MVVM** con `ChangeNotifier`, navegación con `go_router` y tema
centralizado (Material 3, claro/oscuro). No se usan paquetes de estado
(`provider`, `riverpod`, `bloc`, `get`) ni de persistencia.

```
lib/
├── aplicacion/      Arranque, MaterialApp.router y AlcanceTurnos
├── datos/           AlmacenTurnos: datos de prueba y reglas de negocio
├── modelos/         Entidades y reglas de fechas/horarios
├── modelos_vista/   Un ChangeNotifier por pantalla (ModeloVista...)
├── vistas/          Pantallas (agenda, clientes, servicios, estilistas,
│                    detalle y formulario de turno)
├── componentes/     Componentes reutilizables
├── enrutador/       Rutas y configuración de go_router
├── tema/            Paleta, tipografía Poppins y estilos Material 3
└── utilidades/      Utilidades de texto
```

El estado compartido se resuelve con `AlcanceTurnos` (InheritedWidget): las
vistas crean su modelo de vista en `didChangeDependencies` y escuchan los
cambios con `ListenableBuilder`, sin dependencias externas.

### Organización de la pantalla Agenda

- `ListView.builder` para la lista de turnos y para la tira de días.
- `GridView.builder` para el catálogo de servicios, las franjas horarias y los
  chips de servicios del formulario.
- `Wrap` para los grupos de chips y las leyendas.
- `SegmentedButton` de Material 3 para el filtro de estado (y de público y de
  género en las demás pantallas), con la paleta de la guía de estilo.
- `NavigationBar` de Material 3 para los cuatro destinos de la barra inferior.
- `Form` con `TextFormField`, `validator` y `formKey.currentState!.validate()`
  en el formulario de turno y en el de cliente; las reglas de validación
  viven en los modelos de vista.
- `CustomScrollView` con `SliverAppBar` (`pinned`, `expandedHeight`) y
  `SliverList` en la pantalla de estilistas.
- `showDatePicker` para elegir la fecha, `showModalBottomSheet` (con
  `isScrollControlled`) para las hojas de cliente y `PopScope` para avisar de
  los cambios sin guardar.

## Datos de prueba

Al iniciar se cargan datos en memoria:

- **10 clientes** (incluye uno sin turnos).
- **5 estilistas** con las categorías que trabajan.
- **12 servicios** en 5 categorías: al menos 3 para mujeres, 3 para hombres y
  3 unisex.
- **18 turnos**: de hoy y de los días próximos/pasados, con turnos
  programados, completados y cancelados, uno con tres servicios, uno con notas
  de más de 300 caracteres, uno sin notas y uno que termina exactamente a las
  19:00.

Los turnos del día ajustan su estado según la hora actual: los que ya
terminaron se muestran como completados y los que faltan, como programados.

## Reglas de negocio

- Atención de lunes a sábado, de 9:00 a 19:00 (domingos cerrado).
- Un turno no puede superponerse con otro del mismo estilista ni del mismo
  cliente.
- El estilista debe realizar **todos** los servicios elegidos.
- No se permiten turnos en fechas pasadas ni que terminen después del cierre.
- El teléfono del cliente es obligatorio, de 8 dígitos y único.
- Un cliente con turnos programados no puede eliminarse.
- Los turnos completados o cancelados son de solo lectura.
- El ingreso estimado del día suma los turnos programados y completados.

## Funcionalidades

- **Agenda:** navegación por semana, selector de fecha, resumen del día,
  filtros por estilista y estado, acciones rápidas con pulsación larga
  (completar/cancelar) y acceso al detalle.
- **Turnos:** alta y edición con cliente, servicios por categoría, estilista,
  fecha, franja horaria y notas (máx. 500 caracteres); validación con foco en
  el primer campo con error; confirmación al descartar cambios.
- **Detalle:** servicios, totales, notas y acciones de editar, completar y
  cancelar con diálogos de confirmación.
- **Clientes:** búsqueda por nombre o teléfono, filtro por género, alta y
  edición en hoja inferior, historial de turnos y baja con validación.
- **Servicios:** catálogo con la ilustración de cada categoría, filtros por
  categoría y público, y acceso directo para agendar.
- **Estilistas:** equipo, categorías y cantidad de turnos del día; al tocar un
  estilista se abre su agenda.
- **Tema:** claro, oscuro o según el sistema.

## Capturas

En la carpeta `capturas/`:

| Archivo | Pantalla |
| --- | --- |
| `01_agenda.png` | Agenda del día |
| `02_agenda_domingo.png` | Domingo: salón cerrado |
| `03_agenda_lista.png` | Agenda con los turnos del día |
| `04_agenda_acciones_rapidas.png` | Acciones rápidas del turno |
| `05_detalle_turno.png` | Detalle de un turno programado |
| `06_confirmar_cancelar.png` | Confirmación de cancelación |
| `07_nuevo_turno.png` | Formulario de nuevo turno |
| `08_formulario_servicios.png` | Cliente, servicios y estilista |
| `09_formulario_hora.png` | Fecha, franjas horarias y notas |
| `10_descartar_cambios.png` | Aviso de cambios sin guardar |
| `11_formulario_errores.png` | Errores de validación del formulario |
| `12_selector_tema.png` | Selector de tema |
| `13_agenda_oscuro.png` | Tema oscuro |
| `14_clientes.png` | Listado de clientes |
| `15_hoja_cliente.png` | Detalle e historial del cliente |
| `16_cliente_errores.png` | Alta de cliente con errores |
| `17_confirmar_eliminar.png` | Confirmación de eliminación |
| `18_eliminacion_bloqueada.png` | Eliminación bloqueada por turnos |
| `19_servicios.png` | Catálogo de servicios |
| `20_errores_fecha_hora.png` | Errores de fecha y hora con las franjas en rojo |
| `21_estilistas.png` | Equipo de estilistas |

## Pantallas adaptables

- El catálogo de servicios usa 2 columnas por debajo de 600 dp, 3 entre 600 y
  840 dp y 4 por encima de 840 dp.
- En horizontal la agenda se divide en dos columnas (controles y turnos).
- En pantallas muy bajas la cabecera de la agenda se desplaza para evitar
  desbordes, y los controles segmentados se compactan en anchos reducidos.

## Pruebas

```bash
flutter analyze
flutter test
```

Las pruebas cubren las reglas de negocio (superposición de horarios, domingos,
cierre, franjas, cancelación, eliminación de clientes) y un recorrido básico de
la aplicación con cambio de tema.

## Notas

- No hay inicio de sesión: la aplicación abre directamente en la agenda.
- Los datos se reinician al cerrar la aplicación (no hay persistencia).
- Los iconos de cada categoría de servicio y los avatares de los estilistas son
  recursos gráficos del proyecto (`assets/imagenes/`); la tipografía es Poppins
  (incluida en `assets/fuentes/`).

## Guía de estilo

La interfaz sigue al detalle la guía de estilo del diseño (paleta, tipografía,
radios, alturas de los componentes y estados de los diálogos). Esa guía está
en `Turco Parcial Design.pen` y sus valores viven todos en
`lib/tema/tema_app.dart` y `lib/componentes/componentes.dart`: en las pantallas
y widgets no hay colores ni medidas fijas, solo `ColorScheme` y los tokens del
tema.
