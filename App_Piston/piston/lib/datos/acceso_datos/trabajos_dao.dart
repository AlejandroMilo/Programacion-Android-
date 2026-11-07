import 'package:drift/drift.dart';

import '../base_datos.dart';

part 'trabajos_dao.g.dart';

@DriftAccessor(tables: [Trabajos, OrdenesServicio])
class TrabajosDao extends DatabaseAccessor<BaseDatos>
    with _$TrabajosDaoMixin {
  TrabajosDao(super.db);

  Stream<List<Trabajo>> observarPorOrden(int ordenId) {
    return (select(trabajos)
          ..where((t) => t.ordenId.equals(ordenId))
          ..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
        .watch();
  }

  Future<List<Trabajo>> porOrden(int ordenId) {
    return (select(trabajos)
          ..where((t) => t.ordenId.equals(ordenId))
          ..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
        .get();
  }

  Future<int> crear({
    required int ordenId,
    required String descripcion,
    required double precioManoObra,
    int? mecanicoId,
  }) {
    return transaction(() async {
      final id = await into(trabajos).insert(
        TrabajosCompanion.insert(
          ordenId: ordenId,
          descripcion: descripcion.trim(),
          precioManoObra: precioManoObra,
          mecanicoId: Value(mecanicoId),
          fecha: Value(DateTime.now()),
        ),
      );
      await (update(ordenesServicio)..where((o) => o.id.equals(ordenId)))
          .write(
            OrdenesServicioCompanion(actualizadoEn: Value(DateTime.now())),
          );
      return id;
    });
  }

  Future<void> eliminar(int id) => (delete(trabajos)..where((t) => t.id.equals(id))).go();

  Future<double> totalManoObra(int ordenId) async {
    final lista = await porOrden(ordenId);
    return lista.fold<double>(
      0,
      (total, trabajo) => total + trabajo.precioManoObra,
    );
  }
}
