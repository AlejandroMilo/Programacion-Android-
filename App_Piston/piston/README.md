# El Pistón — App Móvil de Taller Automotriz

App móvil para la gestión de un taller mecánico ("El Pistón"), desarrollada en **Flutter/Dart** con persistencia local mediante **Drift/SQLite**. Construida como actividad evaluativa del taller, guiada por los requisitos del módulo móvil y las reglas de negocio de Drift.

---

## 📱 Características principales

- **Persistencia local**: toda la información (usuarios, clientes, vehículos, órdenes, trabajos, repuestos, pagos, movimientos de inventario, configuración) se guarda en SQLite mediante Drift y sobrevive al cierre de la app.
- **Identidad visual deportiva**: negro, grafito, naranja y blanco, con tema claro/oscuro configurable y persistente.
- **Roles de usuario**:
  - **Administrador / Dueño**: acceso completo (usuarios, mecánicos, reportes, configuración, inventario, cobros).
  - **Recepcionista**: gestión del taller (clientes, vehículos, inventario, órdenes, pagos).
  - **Mecánico**: acceso operativo (órdenes asignadas, trabajos, cambio de estado permitido).
- **Navegación inferior**: Inicio, Órdenes, Clientes, Inventario, Más.
- **Sección "Más"**: Pagos, Reportes (solo admin), Mecánicos, Usuarios (solo admin), Configuración, Historial, Vehículos.
- **Seguridad**: contraseñas hasheadas con SHA-256 + sal por usuario; nunca se almacenan en texto plano. Los permisos se validan en la lógica de negocio, no solo ocultando botones.

---

## 🗂️ Módulos implementados

| Módulo | Descripción | Rol |
|--------|-------------|-----|
| **Login** | Autenticación con cuentas demo y selector de tema | Todos |
| **Inicio** | Panel con métricas del taller, órdenes recientes y alertas de inventario | Todos |
| **Órdenes** | Listado, filtros (estado, mecánico, fecha), nueva orden, detalle | Todos |
| **Detalle de orden** | Trabajos, repuestos consumidos, pagos, cambio de estado, asignación mecánico | Todos |
| **Clientes** | CRUD de clientes, historial de órdenes, saldo pendiente | Admin / Recepción |
| **Vehículos** | Registro por cliente, historial, kilometraje | Admin / Recepción |
| **Inventario** | Repuestos con stock, umbral bajo/agotado, ajustes, movimientos | Admin / Recepción |
| **Pagos** | Saldos pendientes, registro de cobros, historial por orden | Admin / Recepción |
| **Reportes** | Facturación por período, carga de mecánicos, deudas, inventario, vehículos atendidos | Solo Admin |
| **Mecánicos** | Ficha de mecánicos, carga de trabajo, órdenes asignadas | Todos |
| **Usuarios** | CRUD de cuentas, cambio de rol, restablecimiento de contraseña | Solo Admin |
| **Configuración** | Tema (claro/oscuro/sistema), datos del taller, umbral de inventario | Todos |
| **Historial** | Órdenes filtradas por cliente, vehículo y fecha | Todos |

---

## 🔐 Reglas de negocio

- Una orden puede tener varios trabajos, repuestos y pagos.
- El inventario se descuenta automáticamente al consumir repuestos en una orden.
- No se puede descontar dos veces el mismo repuesto en una misma orden.
- No se puede cobrar más que el saldo pendiente de una orden.
- Las contraseñas se guardan con hash SHA-256 y sal por usuario.
- Los permisos se validan en la capa de lógica (modelos de vista), no solo en la interfaz.
- Un mecánico solo puede operar las órdenes que tiene asignadas.

---

## 🚀 Cuentas de demostración

Al primer arranque se siembran 3 cuentas de prueba:

| Usuario | Contraseña | Rol |
|---------|-----------|-----|
| `admin` | `admin123` | Administrador / Dueño |
| `recepcion` | `recepcion123` | Recepcionista |
| `mecanico` | `mecanico123` | Mecánico |

También se cargan clientes, vehículos, mecánicos, repuestos y órdenes de ejemplo en distintos estados (recibida, diagnóstico, reparación, lista para entregar, entregada, cancelada) con pagos completos, parciales y pendientes.

---

## 🛠️ Arquitectura y tecnologías

- **Flutter 3.47.2** / **Dart 3.13.2**
- **Drift 2.35** + SQLite (persistencia local)
- **Provider** (gestión de estado)
- **MVVM** con capas separadas:
  - `datos/` — base de datos Drift, DAOs, datos de prueba
  - `modelos/` — clases de datos y extensiones de presentación
  - `modelos_vista/` — lógica de presentación (MVVM)
  - `vistas/` — pantallas y formularios de la UI
  - `componentes/` — widgets reutilizables (botones, campos, tarjetas, indicadores, navegación)
  - `utilidades/` — colores, tema, formatos, validaciones, seguridad
- **11 tablas** y **11 DAOs** en Drift, con `PRAGMA foreign_keys = ON`.
- Enums persistidos como texto con `textEnum`.
- Seed de datos en el primer arranque (`SembradorDatos`).

---

## 📦 Estructura del proyecto

```
App_Piston/piston/
├── lib/
│   ├── aplicacion.dart          # Raíz de la app (providers, tema, login/shell)
│   ├── aplicacion/
│   │   ├── sesion.dart          # Sesión, permisos por rol
│   │   └── preferencias.dart    # Tema y datos del taller persistidos
│   ├── datos/
│   │   ├── base_datos.dart      # Base Drift, migración, DAOs, exports
│   │   ├── datos_prueba.dart    # Seed de datos demo
│   │   ├── acceso_datos/        # 11 DAOs
│   │   └── tablas/              # Definición de tablas Drift
│   ├── modelos/                 # Clases de datos y extensiones
│   ├── modelos_vista/           # ViewModels (MVVM)
│   ├── vistas/                  # Pantallas por módulo
│   ├── componentes/             # Widgets reutilizables
│   └── utilidades/              # Colores, tema, formatos, validaciones, seguridad
├── test/
│   └── logica_taller_test.dart  # Pruebas unitarias (totales, estados, roles, reglas)
├── pubspec.yaml
└── README.md
```

---

## 🧪 Pruebas

Ejecutar:

```bash
cd App_Piston/piston
flutter test
```

Pruebas incluidas:
- Cálculo de totales de orden (mano de obra + repuestos, saldo, pagada).
- Transiciones y estados finales de `EstadoOrden`.
- Etiquetas y propiedades de `RolUsuario`.
- Reglas de inventario (stock bajo, agotado, no doble descuento).
- Validación de pago (no exceder saldo).

---

## ▶️ Cómo ejecutar

### Requisitos
- Flutter SDK 3.47.2+
- Un emulador Android o dispositivo físico

### Pasos

```bash
# 1. Entrar al directorio del proyecto
cd App_Piston/piston

# 2. Obtener dependencias
flutter pub get

# 3. Generar código de Drift (si se modifican tablas/DAOs)
dart run build_runner build

# 4. Ejecutar la app
flutter run
```

La base de datos `el_piston` se crea automáticamente en el almacenamiento local del dispositivo y los datos demo se siembran en el primer arranque.

---

## 📸 Capturas de pantalla

Durante la entrega se incluyen capturas de los siguientes flujos:

1. **Pantalla de login** con cuentas demo y selector de tema.
2. **Panel de inicio** con métricas y órdenes recientes.
3. **Listado de órdenes** con filtros por estado y mecánico.
4. **Detalle de orden** con trabajos, repuestos y pagos.
5. **Formulario de nueva orden** (cliente, vehículo, mecánico, problema).
6. **Gestión de clientes** y detalle con historial.
7. **Inventario de repuestos** con alertas de stock bajo.
8. **Pagos** y registro de cobro.
9. **Reportes** (solo administrador): facturación, carga de mecánicos, deudas.
10. **Configuración** de tema y datos del taller.

---

## ✅ Requisitos cumplidos

- [x] Flutter/Dart + Drift/SQLite con persistencia local
- [x] Identidad visual deportiva (negro, grafito, naranja, blanco)
- [x] Tema claro/oscuro configurable y persistente
- [x] 3 roles con permisos diferenciados (admin, recepción, mecánico)
- [x] Navegación inferior: Inicio, Órdenes, Clientes, Inventario, Más
- [x] Módulo "Más" filtrado por rol (Reportes y Usuarios solo admin)
- [x] Módulos: login, inicio, órdenes, clientes, vehículos, inventario, trabajos, pagos, reportes, mecánicos, usuarios, configuración, historial
- [x] Reglas: órdenes con múltiples trabajos/repuestos/pagos, inventario sin doble descuento, cobro limitado al saldo, contraseñas con hash, permisos en lógica
- [x] Datos demo sembrados (3 cuentas)
- [x] Textos en español
- [x] Pruebas unitarias y `flutter test` pasando
- [x] Repositorio con README y documentación

---

## 👨‍💻 Autor

Desarrollado como actividad evaluativa del taller "El Pistón" — curso de desarrollo móvil. Entrega: viernes 6 de noviembre de 2026.
