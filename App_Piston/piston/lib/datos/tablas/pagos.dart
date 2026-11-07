import 'package:drift/drift.dart';

import 'ordenes_servicio.dart';

@DataClassName('Pago')
class Pagos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ordenId => integer().references(OrdenesServicio, #id)();
  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();
  RealColumn get importe => real()();
  TextColumn get metodo => text().withLength(min: 1, max: 30)();
  TextColumn get nota => text().nullable()();
  TextColumn get registradoPor => text().nullable()();
}
