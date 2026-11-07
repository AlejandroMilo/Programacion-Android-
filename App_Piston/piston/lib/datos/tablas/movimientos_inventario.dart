import 'package:drift/drift.dart';

import 'ordenes_servicio.dart';
import 'repuestos.dart';

@DataClassName('MovimientoInventario')
class MovimientosInventario extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get repuestoId => integer().references(Repuestos, #id)();
  IntColumn get ordenId =>
      integer().nullable().references(OrdenesServicio, #id)();
  TextColumn get tipo => text().withLength(min: 1, max: 20)();
  IntColumn get cantidad => integer()();
  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();
  TextColumn get nota => text().nullable()();
  TextColumn get usuario => text().nullable()();
}
