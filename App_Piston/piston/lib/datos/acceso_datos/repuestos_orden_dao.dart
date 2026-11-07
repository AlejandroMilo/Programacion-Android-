import 'package:drift/drift.dart';

import '../../modelos/repuesto_utilizado.dart';
import '../base_datos.dart';

part 'repuestos_orden_dao.g.dart';

@DriftAccessor(
  tables: [RepuestosOrden, Repuestos, MovimientosInventario, OrdenesServicio],
)
class RepuestosOrdenDao extends DatabaseAccessor<BaseDatos>
    with _$RepuestosOrdenDaoMixin {
  RepuestosOrdenDao(super.db);

  Stream<List<RepuestoUtilizado>> observarPorOrden(int ordenId) {
    final consulta = select(repuestosOrden).join([
      innerJoin(repuestos, repuestos.id.equalsExp(repuestosOrden.repuestoId)),
    ])
      ..where(repuestosOrden.ordenId.equals(ordenId))
      ..orderBy([OrderingTerm.desc(repuestosOrden.fecha)]);
    return consulta.watch().map(
      (filas) => filas
          .map(
            (fila) => RepuestoUtilizado(
              linea: fila.readTable(repuestosOrden),
              repuesto: fila.readTable(repuestos),
            ),
          )
          .toList(),
    );
  }

  Future<List<RepuestoUtilizado>> porOrden(int ordenId) async {
    final filas = await (select(repuestosOrden)
          ..where((r) => r.ordenId.equals(ordenId))
          ..orderBy([(r) => OrderingTerm.desc(r.fecha)]))
        .get();
    final resultado = <RepuestoUtilizado>[];
    for (final linea in filas) {
      final repuesto = await (select(repuestos)
            ..where((r) => r.id.equals(linea.repuestoId)))
          .getSingleOrNull();
      if (repuesto != null) {
        resultado.add(RepuestoUtilizado(linea: linea, repuesto: repuesto));
      }
    }
    return resultado;
  }

  Future<double> totalRepuestos(int ordenId) async {
    final fila = await customSelect(
      'SELECT COALESCE(SUM(cantidad * precio_unitario), 0) AS total '
      'FROM repuestos_orden WHERE orden_id = ?',
      variables: [Variable.withInt(ordenId)],
      readsFrom: {repuestosOrden},
    ).getSingle();
    return (fila.read<double>('total')).toDouble();
  }

  /// Agrega (o aumenta) un repuesto en la orden y descuenta el inventario una
  /// sola vez por la cantidad nueva. Si no hay existencias, no escribe nada.
  Future<void> agregar({
    required int ordenId,
    required int repuestoId,
    required int cantidad,
    String? usuario,
  }) {
    if (cantidad <= 0) throw ArgumentError('La cantidad debe ser positiva');
    return transaction(() async {
      final repuesto = await (select(repuestos)
            ..where((r) => r.id.equals(repuestoId)))
          .getSingleOrNull();
      if (repuesto == null) throw StateError('El repuesto no existe');
      if (!repuesto.activo) throw StateError('El repuesto está desactivado');
      if (repuesto.existencias < cantidad) {
        throw StateError(
          'Stock insuficiente de ${repuesto.nombre}: '
          'quedan ${repuesto.existencias}',
        );
      }

      final existente = await (select(repuestosOrden)
            ..where(
              (r) =>
                  r.ordenId.equals(ordenId) &
                  r.repuestoId.equals(repuestoId),
            ))
          .getSingleOrNull();

      if (existente == null) {
        await into(repuestosOrden).insert(
          RepuestosOrdenCompanion.insert(
            ordenId: ordenId,
            repuestoId: repuestoId,
            cantidad: cantidad,
            precioUnitario: repuesto.precioVenta,
            fecha: Value(DateTime.now()),
          ),
        );
      } else {
        await (update(repuestosOrden)
              ..where((r) => r.id.equals(existente.id)))
            .write(
              RepuestosOrdenCompanion(
                cantidad: Value(existente.cantidad + cantidad),
              ),
            );
      }

      await (update(repuestos)..where((r) => r.id.equals(repuestoId))).write(
        RepuestosCompanion(
          existencias: Value(repuesto.existencias - cantidad),
        ),
      );
      await into(movimientosInventario).insert(
        MovimientosInventarioCompanion.insert(
          repuestoId: repuestoId,
          ordenId: Value(ordenId),
          tipo: 'salida',
          cantidad: -cantidad,
          nota: Value('Consumo en orden'),
          usuario: Value(usuario),
        ),
      );
      await (update(ordenesServicio)..where((o) => o.id.equals(ordenId)))
          .write(
            OrdenesServicioCompanion(actualizadoEn: Value(DateTime.now())),
          );
    });
  }

  /// Devuelve al inventario el repuesto de una línea y la elimina de la orden.
  Future<void> quitarLinea(int lineaId, {String? usuario}) {
    return transaction(() async {
      final linea = await (select(repuestosOrden)
            ..where((r) => r.id.equals(lineaId)))
          .getSingleOrNull();
      if (linea == null) return;
      final repuesto = await (select(repuestos)
            ..where((r) => r.id.equals(linea.repuestoId)))
          .getSingleOrNull();
      if (repuesto != null) {
        await (update(repuestos)..where((r) => r.id.equals(repuesto.id))).write(
          RepuestosCompanion(
            existencias: Value(repuesto.existencias + linea.cantidad),
          ),
        );
        await into(movimientosInventario).insert(
          MovimientosInventarioCompanion.insert(
            repuestoId: repuesto.id,
            ordenId: Value(linea.ordenId),
            tipo: 'entrada',
            cantidad: linea.cantidad,
            nota: Value('Devolución de orden'),
            usuario: Value(usuario),
          ),
        );
      }
      await (delete(repuestosOrden)..where((r) => r.id.equals(lineaId))).go();
      await (update(ordenesServicio)..where((o) => o.id.equals(linea.ordenId)))
          .write(
            OrdenesServicioCompanion(actualizadoEn: Value(DateTime.now())),
          );
    });
  }
}
