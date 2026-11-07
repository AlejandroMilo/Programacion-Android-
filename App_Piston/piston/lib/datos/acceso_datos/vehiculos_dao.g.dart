// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehiculos_dao.dart';

// ignore_for_file: type=lint
mixin _$VehiculosDaoMixin on DatabaseAccessor<BaseDatos> {
  $ClientesTable get clientes => attachedDatabase.clientes;
  $VehiculosTable get vehiculos => attachedDatabase.vehiculos;
  VehiculosDaoManager get managers => VehiculosDaoManager(this);
}

class VehiculosDaoManager {
  final _$VehiculosDaoMixin _db;
  VehiculosDaoManager(this._db);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
  $$VehiculosTableTableManager get vehiculos =>
      $$VehiculosTableTableManager(_db.attachedDatabase, _db.vehiculos);
}
