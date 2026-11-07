// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reportes_dao.dart';

// ignore_for_file: type=lint
mixin _$ReportesDaoMixin on DatabaseAccessor<BaseDatos> {
  $ClientesTable get clientes => attachedDatabase.clientes;
  $VehiculosTable get vehiculos => attachedDatabase.vehiculos;
  $MecanicosTable get mecanicos => attachedDatabase.mecanicos;
  $OrdenesServicioTable get ordenesServicio => attachedDatabase.ordenesServicio;
  $TrabajosTable get trabajos => attachedDatabase.trabajos;
  $RepuestosTable get repuestos => attachedDatabase.repuestos;
  $RepuestosOrdenTable get repuestosOrden => attachedDatabase.repuestosOrden;
  $PagosTable get pagos => attachedDatabase.pagos;
  ReportesDaoManager get managers => ReportesDaoManager(this);
}

class ReportesDaoManager {
  final _$ReportesDaoMixin _db;
  ReportesDaoManager(this._db);
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
  $$RepuestosTableTableManager get repuestos =>
      $$RepuestosTableTableManager(_db.attachedDatabase, _db.repuestos);
  $$RepuestosOrdenTableTableManager get repuestosOrden =>
      $$RepuestosOrdenTableTableManager(
        _db.attachedDatabase,
        _db.repuestosOrden,
      );
  $$PagosTableTableManager get pagos =>
      $$PagosTableTableManager(_db.attachedDatabase, _db.pagos);
}
