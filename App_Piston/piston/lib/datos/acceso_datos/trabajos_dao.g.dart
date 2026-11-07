// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trabajos_dao.dart';

// ignore_for_file: type=lint
mixin _$TrabajosDaoMixin on DatabaseAccessor<BaseDatos> {
  $ClientesTable get clientes => attachedDatabase.clientes;
  $VehiculosTable get vehiculos => attachedDatabase.vehiculos;
  $MecanicosTable get mecanicos => attachedDatabase.mecanicos;
  $OrdenesServicioTable get ordenesServicio => attachedDatabase.ordenesServicio;
  $TrabajosTable get trabajos => attachedDatabase.trabajos;
  TrabajosDaoManager get managers => TrabajosDaoManager(this);
}

class TrabajosDaoManager {
  final _$TrabajosDaoMixin _db;
  TrabajosDaoManager(this._db);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
  $$VehiculosTableTableManager get vehiculos =>
      $$VehiculosTableTableManager(_db.attachedDatabase, _db.vehiculos);
  $$MecanicosTableTableManager get mecanicos =>
      $$MecanicosTableTableManager(_db.attachedDatabase, _db.mecanicos);
  $$OrdenesServicioTableTableManager get ordenesServicio =>
      $$OrdenesServicioTableTableManager(
        _db.attachedDatabase,
        _db.ordenesServicio,
      );
  $$TrabajosTableTableManager get trabajos =>
      $$TrabajosTableTableManager(_db.attachedDatabase, _db.trabajos);
}
