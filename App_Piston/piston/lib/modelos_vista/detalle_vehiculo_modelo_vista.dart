import 'package:flutter/foundation.dart';

import '../aplicacion/sesion.dart';
import '../datos/base_datos.dart';
import '../modelos/orden_servicio.dart';

class DetalleVehiculoModeloVista extends ChangeNotifier {
  DetalleVehiculoModeloVista(this._db, this._sesion, this.vehiculoId);

  final BaseDatos _db;
  final Sesion _sesion;
  final int vehiculoId;

  Vehiculo? vehiculo;
  Cliente? cliente;
  List<ResultadoOrden> historial = const [];
  double saldo = 0;
  bool cargando = true;
  String? error;

  bool get puedeGestionar => _sesion.puede(Permiso.gestionarVehiculos);

  Future<void> cargar() async {
    cargando = true;
    notifyListeners();
    try {
      vehiculo = await _db.vehiculosDao.porId(vehiculoId);
      if (vehiculo != null) {
        cliente = await _db.clientesDao.porId(vehiculo!.clienteId);
      }
      final ordenes = await _db.ordenesDao.deVehiculo(vehiculoId);
      final resultado = <ResultadoOrden>[];
      var pendiente = 0.0;
      for (final orden in ordenes) {
        final totales = await _db.ordenesDao.totales(orden.id);
        resultado.add(ResultadoOrden(orden: orden, totales: totales));
        if (orden.estado.estaAbierta || totales.saldo > 0) {
          pendiente += totales.saldo;
        }
      }
      historial = resultado;
      saldo = pendiente;
      error = null;
    } catch (e) {
      error = 'No se pudo cargar el vehículo: $e';
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> cambiarActivo(bool activo) async {
    _sesion.exigir(Permiso.gestionarVehiculos);
    if (vehiculo == null) return;
    await _db.vehiculosDao.cambiarActivo(vehiculoId, activo);
    await cargar();
  }
}
