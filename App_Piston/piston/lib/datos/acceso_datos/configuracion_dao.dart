import 'package:drift/drift.dart';

import '../base_datos.dart';

part 'configuracion_dao.g.dart';

@DriftAccessor(tables: [Configuracion])
class ConfiguracionDao extends DatabaseAccessor<BaseDatos>
    with _$ConfiguracionDaoMixin {
  ConfiguracionDao(super.db);

  Stream<Map<String, String>> observar() {
    return select(configuracion).watch().map(
      (items) => {for (final item in items) item.clave: item.valor},
    );
  }

  Future<Map<String, String>> leer() async {
    final items = await select(configuracion).get();
    return {for (final item in items) item.clave: item.valor};
  }

  Future<String?> valor(String clave) async {
    final item = await (select(configuracion)
          ..where((c) => c.clave.equals(clave)))
        .getSingleOrNull();
    return item?.valor;
  }

  Future<void> guardar(String clave, String valor) {
    return into(configuracion).insertOnConflictUpdate(
      ConfiguracionCompanion.insert(clave: clave, valor: valor),
    );
  }

  Future<void> guardarVarios(Map<String, String> valores) {
    return transaction(() async {
      for (final entrada in valores.entries) {
        await guardar(entrada.key, entrada.value);
      }
    });
  }
}
