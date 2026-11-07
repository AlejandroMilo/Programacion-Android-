import 'package:drift/drift.dart';

import 'ordenes_servicio.dart';
import 'repuestos.dart';

@DataClassName('RepuestoOrden')
class RepuestosOrden extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ordenId => integer().references(OrdenesServicio, #id)();
  IntColumn get repuestoId => integer().references(Repuestos, #id)();
  IntColumn get cantidad => integer()();
  RealColumn get precioUnitario => real()();
  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();
}
