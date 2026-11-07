import 'package:drift/drift.dart';

import '../../modelos/estado_orden.dart';
import 'clientes.dart';
import 'mecanicos.dart';
import 'vehiculos.dart';

@DataClassName('OrdenServicio')
class OrdenesServicio extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get numero => text().withLength(min: 3, max: 20).unique()();
  IntColumn get clienteId => integer().references(Clientes, #id)();
  IntColumn get vehiculoId => integer().references(Vehiculos, #id)();
  IntColumn get mecanicoId =>
      integer().nullable().references(Mecanicos, #id)();
  DateTimeColumn get fechaEntrada => dateTime()();
  TextColumn get problema => text()();
  TextColumn get estado => textEnum<EstadoOrden>()();
  IntColumn get kilometrajeEntrada =>
      integer().withDefault(const Constant(0))();
  TextColumn get notas => text().nullable()();
  DateTimeColumn get creadoEn =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get actualizadoEn =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get fechaCierre => dateTime().nullable()();
}
