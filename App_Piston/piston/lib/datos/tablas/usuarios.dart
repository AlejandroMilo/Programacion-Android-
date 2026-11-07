import 'package:drift/drift.dart';

import '../../modelos/rol_usuario.dart';
import 'mecanicos.dart';

@DataClassName('Usuario')
class Usuarios extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombreUsuario =>
      text().withLength(min: 3, max: 40).unique()();
  TextColumn get nombrePersona => text().withLength(min: 1, max: 80)();
  TextColumn get rol => textEnum<RolUsuario>()();
  TextColumn get claveHash => text()();
  TextColumn get sal => text()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get creadoEn =>
      dateTime().withDefault(currentDateAndTime)();
  IntColumn get mecanicoId =>
      integer().nullable().references(Mecanicos, #id)();
}
