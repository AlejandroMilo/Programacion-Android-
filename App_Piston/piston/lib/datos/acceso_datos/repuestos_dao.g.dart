// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repuestos_dao.dart';

// ignore_for_file: type=lint
mixin _$RepuestosDaoMixin on DatabaseAccessor<BaseDatos> {
  $RepuestosTable get repuestos => attachedDatabase.repuestos;
  $ClientesTable get clientes => attachedDatabase.clientes;
  $VehiculosTable get vehiculos => attachedDatabase.vehiculos;
  $MecanicosTable get mecanicos => attachedDatabase.mecanicos;
  $OrdenesServicioTable get ordenesServicio => attachedDatabase.ordenesServicio;
  $MovimientosInventarioTable get movimientosInventario =>
      attachedDatabase.movimientosInventario;
  RepuestosDaoManager get managers => RepuestosDaoManager(this);
}

class RepuestosDaoManager {
  final _$RepuestosDaoMixin _db;
  RepuestosDaoManager(this._db);
  $$RepuestosTableTableManager get repuestos =>
      $$RepuestosTableTableManager(_db.attachedDatabase, _db.repuestos);
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
  $$MovimientosInventarioTableTableManager get movimientosInventario =>
      $$MovimientosInventarioTableTableManager(
        _db.attachedDatabase,
        _db.movimientosInventario,
      );
}
