import 'package:drift/drift.dart';

import '../base_datos.dart';

part 'usuarios_dao.g.dart';

@DriftAccessor(tables: [Usuarios])
class UsuariosDao extends DatabaseAccessor<BaseDatos>
    with _$UsuariosDaoMixin {
  UsuariosDao(super.db);

  Stream<List<Usuario>> observar() {
    return (select(usuarios)
          ..orderBy([(u) => OrderingTerm.asc(u.nombreUsuario)]))
        .watch();
  }

  Future<List<Usuario>> todos() => select(usuarios).get();

  Future<Usuario?> porId(int id) {
    return (select(usuarios)..where((u) => u.id.equals(id)))
        .getSingleOrNull();
  }

  Future<Usuario?> porNombreUsuario(String nombre) {
    final normalizado = nombre.trim().toLowerCase();
    return (select(usuarios)
          ..where((u) => u.nombreUsuario.equals(normalizado)))
        .getSingleOrNull();
  }

  Future<int> crear({
    required String nombreUsuario,
    required String nombrePersona,
    required RolUsuario rol,
    required String claveHash,
    required String sal,
    int? mecanicoId,
  }) {
    return into(usuarios).insert(
      UsuariosCompanion.insert(
        nombreUsuario: nombreUsuario.trim().toLowerCase(),
        nombrePersona: nombrePersona.trim(),
        rol: rol,
        claveHash: claveHash,
        sal: sal,
        mecanicoId: Value(mecanicoId),
      ),
    );
  }

  Future<void> actualizar(Usuario usuario) => update(usuarios).replace(usuario);

  Future<void> cambiarActivo(int id, bool activo) {
    return (update(usuarios)..where((u) => u.id.equals(id)))
        .write(UsuariosCompanion(activo: Value(activo)));
  }

  Future<void> actualizarClave(int id, String claveHash, String sal) {
    return (update(usuarios)..where((u) => u.id.equals(id)))
        .write(
          UsuariosCompanion(
            claveHash: Value(claveHash),
            sal: Value(sal),
          ),
        );
  }

  Future<void> actualizarRol(int id, RolUsuario rol) {
    return (update(usuarios)..where((u) => u.id.equals(id)))
        .write(UsuariosCompanion(rol: Value(rol)));
  }

  Future<int> contar() async => (await select(usuarios).get()).length;
}
