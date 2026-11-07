import 'package:drift/drift.dart';

@DataClassName('Repuesto')
class Repuestos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 100)();
  TextColumn get codigo => text().withLength(min: 1, max: 40).unique()();
  RealColumn get precioVenta => real()();
  IntColumn get existencias => integer().withDefault(const Constant(0))();
  IntColumn get umbral => integer().withDefault(const Constant(5))();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
}
