// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagos_dao.dart';

// ignore_for_file: type=lint
mixin _$PagosDaoMixin on DatabaseAccessor<BaseDatos> {
  $ClientesTable get clientes => attachedDatabase.clientes;
  $VehiculosTable get vehiculos => attachedDatabase.vehiculos;
  $MecanicosTable get mecanicos => attachedDatabase.mecanicos;
  $OrdenesServicioTable get ordenesServicio => attachedDatabase.ordenesServicio;
  $PagosTable get pagos => attachedDatabase.pagos;
  $TrabajosTable get trabajos => attachedDatabase.trabajos;
  $RepuestosTable get repuestos => attachedDatabase.repuestos;
  $RepuestosOrdenTable get repuestosOrden => attachedDatabase.repuestosOrden;
  PagosDaoManager get managers => PagosDaoManager(this);
}

class PagosDaoManager {
  final _$PagosDaoMixin _db;
  PagosDaoManager(this._db);
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
  $$PagosTableTableManager get pagos =>
      $$PagosTableTableManager(_db.attachedDatabase, _db.pagos);
  $$TrabajosTableTableManager get trabajos =>
      $$TrabajosTableTableManager(_db.attachedDatabase, _db.trabajos);
  $$RepuestosTableTableManager get repuestos =>
      $$RepuestosTableTableManager(_db.attachedDatabase, _db.repuestos);
  $$RepuestosOrdenTableTableManager get repuestosOrden =>
      $$RepuestosOrdenTableTableManager(
        _db.attachedDatabase,
        _db.repuestosOrden,
      );
}
