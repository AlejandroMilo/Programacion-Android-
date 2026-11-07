import 'package:drift/drift.dart';

@DataClassName('ConfiguracionItem')
class Configuracion extends Table {
  TextColumn get clave => text()();
  TextColumn get valor => text()();

  @override
  Set<Column> get primaryKey => {clave};
}
