import 'dart:math' as math;

import 'package:drift/drift.dart';

import '../base_datos.dart';

part 'repuestos_dao.g.dart';

@DriftAccessor(tables: [Repuestos, MovimientosInventario])
class RepuestosDao extends DatabaseAccessor<BaseDatos>
    with _$RepuestosDaoMixin {
  RepuestosDao(super.db);

  Stream<List<Repuesto>> observar({String busqueda = ''}) {
    final consulta = select(repuestos)
      ..orderBy([(r) => OrderingTerm.asc(r.nombre)]);
    final texto = busqueda.trim().toLowerCase();
    if (texto.isNotEmpty) {
      final patron = '%$texto%';
      consulta.where(
        (r) => r.nombre.lower().like(patron) | r.codigo.lower().like(patron),
      );
    }
    return consulta.watch();
  }

  Future<List<Repuesto>> todos({bool soloActivos = true}) {
    final consulta = select(repuestos)
      ..orderBy([(r) => OrderingTerm.asc(r.nombre)]);
    if (soloActivos) consulta.where((r) => r.activo.equals(true));
    return consulta.get();
  }

  Future<Repuesto?> porId(int id) {
    return (select(repuestos)..where((r) => r.id.equals(id)))
        .getSingleOrNull();
  }

  Future<Repuesto?> porCodigo(String codigo) {
    return (select(repuestos)
          ..where((r) => r.codigo.lower().equals(codigo.trim().toLowerCase())))
        .getSingleOrNull();
  }

  Future<List<Repuesto>> bajoStock() {
    return (select(repuestos)
          ..where((r) => r.activo.equals(true))
          ..where((r) => r.existencias.isSmallerOrEqual(r.umbral))
          ..orderBy([(r) => OrderingTerm.asc(r.existencias)]))
        .get();
  }

  Stream<List<Repuesto>> observarBajoStock() {
    return (select(repuestos)
          ..where((r) => r.activo.equals(true))
          ..where((r) => r.existencias.isSmallerOrEqual(r.umbral))
          ..orderBy([(r) => OrderingTerm.asc(r.existencias)]))
        .watch();
  }

  Future<int> crear({
    required String nombre,
    required String codigo,
    required double precioVenta,
    required int existencias,
    required int umbral,
  }) {
    return transaction(() async {
      final id = await into(repuestos).insert(
        RepuestosCompanion.insert(
          nombre: nombre.trim(),
          codigo: codigo.trim().toUpperCase(),
          precioVenta: precioVenta,
          existencias: Value(existencias),
          umbral: Value(umbral),
        ),
      );
      if (existencias > 0) {
        await into(movimientosInventario).insert(
          MovimientosInventarioCompanion.insert(
            repuestoId: id,
            tipo: 'entrada',
            cantidad: existencias,
            nota: Value('Existencia inicial'),
          ),
        );
      }
      return id;
    });
  }

  Future<void> actualizar(Repuesto repuesto) =>
      update(repuestos).replace(repuesto);

  Future<void> cambiarActivo(int id, bool activo) {
    return (update(repuestos)..where((r) => r.id.equals(id)))
        .write(RepuestosCompanion(activo: Value(activo)));
  }

  /// Ajuste manual de existencias. El delta positivo suma y el negativo resta.
  Future<void> ajustarStock({
    required int repuestoId,
    required int delta,
    String? nota,
    String? usuario,
  }) {
    if (delta == 0) throw ArgumentError('El ajuste no puede ser cero');
    return transaction(() async {
      final repuesto = await porId(repuestoId);
      if (repuesto == null) throw StateError('El repuesto no existe');
      final nuevas = math.max(0, repuesto.existencias + delta);
      final cambioReal = nuevas - repuesto.existencias;
      await (update(repuestos)..where((r) => r.id.equals(repuestoId))).write(
        RepuestosCompanion(existencias: Value(nuevas)),
      );
      await into(movimientosInventario).insert(
        MovimientosInventarioCompanion.insert(
          repuestoId: repuestoId,
          tipo: cambioReal >= 0 ? 'entrada' : 'salida',
          cantidad: cambioReal,
          nota: Value(nota),
          usuario: Value(usuario),
        ),
      );
    });
  }

  Future<List<MovimientoInventario>> movimientos(int repuestoId) {
    return (select(movimientosInventario)
          ..where((m) => m.repuestoId.equals(repuestoId))
          ..orderBy([(m) => OrderingTerm.desc(m.fecha)]))
        .get();
  }

  Stream<List<MovimientoInventario>> observarMovimientos(int repuestoId) {
    return (select(movimientosInventario)
          ..where((m) => m.repuestoId.equals(repuestoId))
          ..orderBy([(m) => OrderingTerm.desc(m.fecha)]))
        .watch();
  }
}
