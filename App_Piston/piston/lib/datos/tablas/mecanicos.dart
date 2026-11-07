import 'package:drift/drift.dart';

@DataClassName('Mecanico')
class Mecanicos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 80)();
  TextColumn get telefono => text().nullable()();
  TextColumn get especialidad => text().nullable()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get fechaIngreso =>
      dateTime().withDefault(currentDateAndTime)();
}
