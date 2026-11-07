import 'package:drift/drift.dart';

import 'clientes.dart';

@DataClassName('Vehiculo')
class Vehiculos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get clienteId => integer().references(Clientes, #id)();
  TextColumn get matricula => text().withLength(min: 3, max: 20).unique()();
  TextColumn get marca => text().withLength(min: 1, max: 50)();
  TextColumn get modelo => text().withLength(min: 1, max: 50)();
  IntColumn get anio => integer()();
  IntColumn get kilometraje => integer().withDefault(const Constant(0))();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get creadoEn =>
      dateTime().withDefault(currentDateAndTime)();
}
