import 'package:drift/drift.dart';

import '../../modelos/vehiculo.dart';
import '../base_datos.dart';

part 'vehiculos_dao.g.dart';

@DriftAccessor(tables: [Vehiculos, Clientes])
class VehiculosDao extends DatabaseAccessor<BaseDatos>
    with _$VehiculosDaoMixin {
  VehiculosDao(super.db);

  Stream<List<VehiculoConDueno>> observar({
    String busqueda = '',
    int? clienteId,
    bool incluirInactivos = true,
  }) {
    final consulta = select(vehiculos).join([
      innerJoin(clientes, clientes.id.equalsExp(vehiculos.clienteId)),
    ]);
    final texto = busqueda.trim().toLowerCase();
    if (texto.isNotEmpty) {
      final patron = '%$texto%';
      consulta.where(
        vehiculos.matricula.lower().like(patron) |
            vehiculos.marca.lower().like(patron) |
            vehiculos.modelo.lower().like(patron) |
            clientes.nombre.lower().like(patron),
      );
    }
    if (clienteId != null) {
      consulta.where(vehiculos.clienteId.equals(clienteId));
    }
    if (!incluirInactivos) {
      consulta.where(vehiculos.activo.equals(true));
    }
    consulta.orderBy([OrderingTerm.asc(vehiculos.matricula)]);
    return consulta.watch().map(
      (filas) => filas
          .map(
            (fila) => VehiculoConDueno(
              vehiculo: fila.readTable(vehiculos),
              cliente: fila.readTable(clientes),
            ),
          )
          .toList(),
    );
  }

  Future<List<Vehiculo>> deCliente(int clienteId) {
    return (select(vehiculos)
          ..where((v) => v.clienteId.equals(clienteId))
          ..orderBy([(v) => OrderingTerm.asc(v.matricula)]))
        .get();
  }

  Future<Vehiculo?> porId(int id) {
    return (select(vehiculos)..where((v) => v.id.equals(id)))
        .getSingleOrNull();
  }

  Future<Vehiculo?> porMatricula(String matricula) {
    return (select(vehiculos)
          ..where((v) => v.matricula.lower().equals(matricula.trim().toLowerCase())))
        .getSingleOrNull();
  }

  Future<int> crear({
    required int clienteId,
    required String matricula,
    required String marca,
    required String modelo,
    required int anio,
    int kilometraje = 0,
  }) {
    return into(vehiculos).insert(
      VehiculosCompanion.insert(
        clienteId: clienteId,
        matricula: matricula.trim().toUpperCase(),
        marca: marca.trim(),
        modelo: modelo.trim(),
        anio: anio,
        kilometraje: Value(kilometraje),
      ),
    );
  }

  Future<void> actualizar(Vehiculo vehiculo) =>
      update(vehiculos).replace(vehiculo);

  Future<void> actualizarKilometraje(int id, int kilometraje) {
    return (update(vehiculos)..where((v) => v.id.equals(id)))
        .write(VehiculosCompanion(kilometraje: Value(kilometraje)));
  }

  Future<void> cambiarActivo(int id, bool activo) {
    return (update(vehiculos)..where((v) => v.id.equals(id)))
        .write(VehiculosCompanion(activo: Value(activo)));
  }
}
