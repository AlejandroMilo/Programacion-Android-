import 'package:drift/drift.dart';

import '../base_datos.dart';

part 'clientes_dao.g.dart';

@DriftAccessor(tables: [Clientes])
class ClientesDao extends DatabaseAccessor<BaseDatos>
    with _$ClientesDaoMixin {
  ClientesDao(super.db);

  Stream<List<Cliente>> observar({
    String busqueda = '',
    bool incluirInactivos = true,
  }) {
    final consulta = select(clientes)
      ..orderBy([(c) => OrderingTerm.asc(c.nombre)]);
    final texto = busqueda.trim().toLowerCase();
    if (texto.isNotEmpty) {
      final patron = '%$texto%';
      consulta.where(
        (c) =>
            c.nombre.lower().like(patron) |
            c.telefono.lower().like(patron),
      );
    }
    if (!incluirInactivos) {
      consulta.where((c) => c.activo.equals(true));
    }
    return consulta.watch();
  }

  Future<List<Cliente>> todos({bool soloActivos = false}) {
    final consulta = select(clientes)
      ..orderBy([(c) => OrderingTerm.asc(c.nombre)]);
    if (soloActivos) consulta.where((c) => c.activo.equals(true));
    return consulta.get();
  }

  Future<Cliente?> porId(int id) {
    return (select(clientes)..where((c) => c.id.equals(id)))
        .getSingleOrNull();
  }

  Future<bool> telefonoEnUso(String telefono, {int? exceptoId}) async {
    final consulta = select(clientes)
      ..where((c) => c.telefono.equals(telefono.trim()));
    if (exceptoId != null) {
      consulta.where((c) => c.id.equals(exceptoId).not());
    }
    return (await consulta.get()).isNotEmpty;
  }

  Future<int> crear({
    required String nombre,
    required String telefono,
    String? direccion,
  }) {
    return into(clientes).insert(
      ClientesCompanion.insert(
        nombre: nombre.trim(),
        telefono: telefono.trim(),
        direccion: Value(
          direccion == null || direccion.trim().isEmpty ? null : direccion.trim(),
        ),
      ),
    );
  }

  Future<void> actualizar(Cliente cliente) => update(clientes).replace(cliente);

  Future<void> cambiarActivo(int id, bool activo) {
    return (update(clientes)..where((c) => c.id.equals(id)))
        .write(ClientesCompanion(activo: Value(activo)));
  }
}
