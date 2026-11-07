import 'package:drift/drift.dart';

import '../base_datos.dart';

part 'mecanicos_dao.g.dart';

@DriftAccessor(tables: [Mecanicos])
class MecanicosDao extends DatabaseAccessor<BaseDatos>
    with _$MecanicosDaoMixin {
  MecanicosDao(super.db);

  Stream<List<Mecanico>> observar({bool soloActivos = true}) {
    final consulta = select(mecanicos)
      ..orderBy([(m) => OrderingTerm.asc(m.nombre)]);
    if (soloActivos) consulta.where((m) => m.activo.equals(true));
    return consulta.watch();
  }

  Future<List<Mecanico>> todos({bool soloActivos = false}) {
    final consulta = select(mecanicos)
      ..orderBy([(m) => OrderingTerm.asc(m.nombre)]);
    if (soloActivos) consulta.where((m) => m.activo.equals(true));
    return consulta.get();
  }

  Future<Mecanico?> porId(int id) {
    return (select(mecanicos)..where((m) => m.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> crear({
    required String nombre,
    String? telefono,
    String? especialidad,
  }) {
    return into(mecanicos).insert(
      MecanicosCompanion.insert(
        nombre: nombre.trim(),
        telefono: Value(
          telefono == null || telefono.trim().isEmpty ? null : telefono.trim(),
        ),
        especialidad: Value(
          especialidad == null || especialidad.trim().isEmpty
              ? null
              : especialidad.trim(),
        ),
      ),
    );
  }

  Future<void> actualizar(Mecanico mecanico) =>
      update(mecanicos).replace(mecanico);

  Future<void> cambiarActivo(int id, bool activo) {
    return (update(mecanicos)..where((m) => m.id.equals(id)))
        .write(MecanicosCompanion(activo: Value(activo)));
  }
}
