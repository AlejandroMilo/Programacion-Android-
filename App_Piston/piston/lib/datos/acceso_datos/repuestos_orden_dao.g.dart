// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repuestos_orden_dao.dart';

// ignore_for_file: type=lint
mixin _$RepuestosOrdenDaoMixin on DatabaseAccessor<BaseDatos> {
  $ClientesTable get clientes => attachedDatabase.clientes;
  $VehiculosTable get vehiculos => attachedDatabase.vehiculos;
  $MecanicosTable get mecanicos => attachedDatabase.mecanicos;
  $OrdenesServicioTable get ordenesServicio => attachedDatabase.ordenesServicio;
  $RepuestosTable get repuestos => attachedDatabase.repuestos;
  $RepuestosOrdenTable get repuestosOrden => attachedDatabase.repuestosOrden;
  $MovimientosInventarioTable get movimientosInventario =>
      attachedDatabase.movimientosInventario;
  RepuestosOrdenDaoManager get managers => RepuestosOrdenDaoManager(this);
}

class RepuestosOrdenDaoManager {
  final _$RepuestosOrdenDaoMixin _db;
  RepuestosOrdenDaoManager(this._db);
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
  $$RepuestosTableTableManager get repuestos =>
      $$RepuestosTableTableManager(_db.attachedDatabase, _db.repuestos);
  $$RepuestosOrdenTableTableManager get repuestosOrden =>
      $$RepuestosOrdenTableTableManager(
        _db.attachedDatabase,
        _db.repuestosOrden,
      );
  $$MovimientosInventarioTableTableManager get movimientosInventario =>
      $$MovimientosInventarioTableTableManager(
        _db.attachedDatabase,
        _db.movimientosInventario,
      );
}
