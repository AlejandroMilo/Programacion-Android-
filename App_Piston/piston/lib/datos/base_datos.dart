import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../modelos/estado_orden.dart';
import '../modelos/rol_usuario.dart';
import 'acceso_datos/clientes_dao.dart';
import 'acceso_datos/configuracion_dao.dart';
import 'acceso_datos/mecanicos_dao.dart';
import 'acceso_datos/ordenes_dao.dart';
import 'acceso_datos/pagos_dao.dart';
import 'acceso_datos/reportes_dao.dart';
import 'acceso_datos/repuestos_dao.dart';
import 'acceso_datos/repuestos_orden_dao.dart';
import 'acceso_datos/trabajos_dao.dart';
import 'acceso_datos/usuarios_dao.dart';
import 'acceso_datos/vehiculos_dao.dart';
import 'tablas/clientes.dart';
import 'tablas/configuracion.dart';
import 'tablas/mecanicos.dart';
import 'tablas/movimientos_inventario.dart';
import 'tablas/ordenes_servicio.dart';
import 'tablas/pagos.dart';
import 'tablas/repuestos.dart';
import 'tablas/repuestos_orden.dart';
import 'tablas/trabajos.dart';
import 'tablas/usuarios.dart';
import 'tablas/vehiculos.dart';

export '../modelos/estado_orden.dart';
export '../modelos/rol_usuario.dart';
export '../modelos/repuesto.dart';
export '../modelos/pago.dart';
export '../modelos/vehiculo.dart';
export '../modelos/orden_servicio.dart';
export '../modelos/mecanico.dart';
export 'tablas/clientes.dart';
export 'tablas/configuracion.dart';
export 'tablas/mecanicos.dart';
export 'tablas/movimientos_inventario.dart';
export 'tablas/ordenes_servicio.dart';
export 'tablas/pagos.dart';
export 'tablas/repuestos.dart';
export 'tablas/repuestos_orden.dart';
export 'tablas/trabajos.dart';
export 'tablas/usuarios.dart';
export 'tablas/vehiculos.dart';

part 'base_datos.g.dart';

/// Base de datos local (SQLite mediante Drift) de El Pistón.
///
/// Una sola instancia se crea al arrancar y se entrega a los DAOs y modelos de
/// vista. Es la capa de datos de la arquitectura MVVM.
@DriftDatabase(
  tables: [
    Usuarios,
    Clientes,
    Vehiculos,
    Mecanicos,
    OrdenesServicio,
    Trabajos,
    Repuestos,
    RepuestosOrden,
    Pagos,
    MovimientosInventario,
    Configuracion,
  ],
  daos: [
    UsuariosDao,
    ClientesDao,
    VehiculosDao,
    MecanicosDao,
    OrdenesDao,
    TrabajosDao,
    RepuestosDao,
    RepuestosOrdenDao,
    PagosDao,
    ReportesDao,
    ConfiguracionDao,
  ],
)
class BaseDatos extends _$BaseDatos {
  BaseDatos() : super(driftDatabase(name: 'el_piston'));

  /// Constructor para pruebas con una base en memoria.
  BaseDatos.paraPruebas(super.ejecutor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrador) => migrador.createAll(),
    beforeOpen: (detalles) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
