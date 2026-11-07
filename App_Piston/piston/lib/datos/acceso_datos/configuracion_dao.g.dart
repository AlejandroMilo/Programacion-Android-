// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuracion_dao.dart';

// ignore_for_file: type=lint
mixin _$ConfiguracionDaoMixin on DatabaseAccessor<BaseDatos> {
  $ConfiguracionTable get configuracion => attachedDatabase.configuracion;
  ConfiguracionDaoManager get managers => ConfiguracionDaoManager(this);
}

class ConfiguracionDaoManager {
  final _$ConfiguracionDaoMixin _db;
  ConfiguracionDaoManager(this._db);
  $$ConfiguracionTableTableManager get configuracion =>
      $$ConfiguracionTableTableManager(_db.attachedDatabase, _db.configuracion);
}
