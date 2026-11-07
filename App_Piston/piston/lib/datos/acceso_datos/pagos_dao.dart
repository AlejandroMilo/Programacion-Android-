import 'package:drift/drift.dart';

import '../base_datos.dart';

part 'pagos_dao.g.dart';

@DriftAccessor(tables: [Pagos, OrdenesServicio, Trabajos, RepuestosOrden])
class PagosDao extends DatabaseAccessor<BaseDatos> with _$PagosDaoMixin {
  PagosDao(super.db);

  Stream<List<Pago>> observarPorOrden(int ordenId) {
    return (select(pagos)
          ..where((p) => p.ordenId.equals(ordenId))
          ..orderBy([(p) => OrderingTerm.desc(p.fecha)]))
        .watch();
  }

  Future<List<Pago>> porOrden(int ordenId) {
    return (select(pagos)
          ..where((p) => p.ordenId.equals(ordenId))
          ..orderBy([(p) => OrderingTerm.desc(p.fecha)]))
        .get();
  }

  Future<double> totalPagado(int ordenId) async {
    final lista = await porOrden(ordenId);
    return lista.fold<double>(0, (total, pago) => total + pago.importe);
  }

  Future<double> totalOrden(int ordenId) async {
    final fila = await customSelect(
      '''
      SELECT
        COALESCE((SELECT SUM(precio_mano_obra) FROM trabajos WHERE orden_id = ?), 0) +
        COALESCE((SELECT SUM(cantidad * precio_unitario) FROM repuestos_orden WHERE orden_id = ?), 0) AS total
      ''',
      variables: [Variable.withInt(ordenId), Variable.withInt(ordenId)],
      readsFrom: {trabajos, repuestosOrden},
    ).getSingle();
    return ((fila.read<double>('total'))).toDouble();
  }

  Future<double> saldo(int ordenId) async {
    final total = await totalOrden(ordenId);
    final pagado = await totalPagado(ordenId);
    return (total - pagado).clamp(0, double.infinity);
  }

  Future<int> registrar({
    required int ordenId,
    required double importe,
    required String metodo,
    String? nota,
    String? registradoPor,
  }) {
    if (importe <= 0) throw ArgumentError('El importe debe ser mayor que cero');
    return transaction(() async {
      final total = await totalOrden(ordenId);
      final pagado = await totalPagado(ordenId);
      final pendiente = total - pagado;
      if (importe > pendiente + 0.009) {
        throw StateError(
          'El importe supera el saldo pendiente '
          '(\$${pendiente.toStringAsFixed(2)})',
        );
      }
      final id = await into(pagos).insert(
        PagosCompanion.insert(
          ordenId: ordenId,
          importe: importe,
          metodo: metodo,
          nota: Value(
            nota == null || nota.trim().isEmpty ? null : nota.trim(),
          ),
          registradoPor: Value(registradoPor),
          fecha: Value(DateTime.now()),
        ),
      );
      await (update(ordenesServicio)..where((o) => o.id.equals(ordenId)))
          .write(
            OrdenesServicioCompanion(actualizadoEn: Value(DateTime.now())),
          );
      return id;
    });
  }

  Future<List<Pago>> pagosDelPeriodo(DateTime desde, DateTime hasta) {
    final fin = DateTime(hasta.year, hasta.month, hasta.day, 23, 59, 59);
    return (select(pagos)
          ..where(
            (p) =>
                p.fecha.isBiggerOrEqualValue(desde) &
                p.fecha.isSmallerOrEqualValue(fin),
          )
          ..orderBy([(p) => OrderingTerm.desc(p.fecha)]))
        .get();
  }

  Future<double> totalCobrado(DateTime desde, DateTime hasta) async {
    final lista = await pagosDelPeriodo(desde, hasta);
    return lista.fold<double>(0, (total, pago) => total + pago.importe);
  }
}
