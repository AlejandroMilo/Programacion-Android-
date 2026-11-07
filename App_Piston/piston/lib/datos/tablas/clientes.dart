import 'package:drift/drift.dart';

@DataClassName('Cliente')
class Clientes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 100)();
  TextColumn get telefono => text().withLength(min: 7, max: 20)();
  TextColumn get direccion => text().nullable()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get fechaRegistro =>
      dateTime().withDefault(currentDateAndTime)();
}
