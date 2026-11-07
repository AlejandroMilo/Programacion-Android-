import 'package:drift/drift.dart';

import 'mecanicos.dart';
import 'ordenes_servicio.dart';

@DataClassName('Trabajo')
class Trabajos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ordenId => integer().references(OrdenesServicio, #id)();
  TextColumn get descripcion => text().withLength(min: 1, max: 200)();
  RealColumn get precioManoObra => real()();
  IntColumn get mecanicoId =>
      integer().nullable().references(Mecanicos, #id)();
  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();
}
