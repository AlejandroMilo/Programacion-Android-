import 'package:flutter/foundation.dart';

import '../aplicacion/sesion.dart';
import '../datos/base_datos.dart';
import '../modelos/orden_servicio.dart';
import '../modelos/resumen_taller.dart';

/// Cobros pendientes y registro de pagos.
class PagosModeloVista extends ChangeNotifier {
  PagosModeloVista(this._db, this._sesion);

  final BaseDatos _db;
  final Sesion _sesion;

  String _busqueda = '';
  List<ResultadoOrden> pendientes = const [];
  List<DeudaCliente> deudas = const [];
  double cobradoHoy = 0;
  bool cargando = true;
  String? error;

  String get busqueda => _busqueda;

  List<ResultadoOrden> get filtrados {
    final texto = _busqueda.trim().toLowerCase();
    if (texto.isEmpty) return pendientes;
    return pendientes
        .where(
          (r) =>
              r.orden.numero.toLowerCase().contains(texto) ||
              r.orden.cliente.nombre.toLowerCase().contains(texto) ||
              r.orden.matricula.toLowerCase().contains(texto),
        )
        .toList();
  }

  bool get puedeCobrar => _sesion.puede(Permiso.registrarPagos);

  Future<void> cargar() async {
    _sesion.exigir(Permiso.verPagos);
    cargando = true;
    error = null;
    notifyListeners();
    try {
      pendientes = await _db.reportesDao.ordenesConSaldo();
      deudas = await _db.reportesDao.deudas();
      final ahora = DateTime.now();
      final pagosHoy = await _db.pagosDao.pagosDelPeriodo(ahora, ahora);
      cobradoHoy = pagosHoy.fold<double>(
        0,
        (total, pago) => total + pago.importe,
      );
    } catch (e) {
      error = 'No se pudieron cargar los pagos: $e';
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  void cambiarBusqueda(String valor) {
    _busqueda = valor;
    notifyListeners();
  }

  Future<void> registrarPago({
    required ResultadoOrden resultado,
    required double importe,
    required String metodo,
    String? nota,
  }) async {
    _sesion.exigir(Permiso.registrarPagos);
    if (resultado.orden.estado == EstadoOrden.cancelada) {
      throw StateError('No se puede cobrar una orden cancelada');
    }
    await _db.pagosDao.registrar(
      ordenId: resultado.orden.id,
      importe: importe,
      metodo: metodo,
      nota: nota,
      registradoPor: _sesion.nombre,
    );
    await cargar();
  }

  Future<List<Pago>> pagosDe(int ordenId) => _db.pagosDao.porOrden(ordenId);

  Future<List<ResultadoOrden>> historialDe(int ordenId) async {
    final orden = await _db.ordenesDao.porId(ordenId);
    if (orden == null) return const [];
    return [
      ResultadoOrden(
        orden: orden,
        totales: await _db.ordenesDao.totales(ordenId),
      ),
    ];
  }
}
