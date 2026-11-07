// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mecanicos_dao.dart';

// ignore_for_file: type=lint
mixin _$MecanicosDaoMixin on DatabaseAccessor<BaseDatos> {
  $MecanicosTable get mecanicos => attachedDatabase.mecanicos;
  MecanicosDaoManager get managers => MecanicosDaoManager(this);
}

class MecanicosDaoManager {
  final _$MecanicosDaoMixin _db;
  MecanicosDaoManager(this._db);
  $$MecanicosTableTableManager get mecanicos =>
      $$MecanicosTableTableManager(_db.attachedDatabase, _db.mecanicos);
}
