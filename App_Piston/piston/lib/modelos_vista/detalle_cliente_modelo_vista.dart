import 'package:flutter/foundation.dart';

import '../aplicacion/sesion.dart';
import '../datos/base_datos.dart';
import '../modelos/orden_servicio.dart';

class DetalleClienteModeloVista extends ChangeNotifier {
  DetalleClienteModeloVista(this._db, this._sesion, this.clienteId);

  final BaseDatos _db;
  final Sesion _sesion;
  final int clienteId;

  Cliente? cliente;
  List<Vehiculo> vehiculos = const [];
  List<ResultadoOrden> historial = const [];
  double saldo = 0;
  bool cargando = true;
  String? error;

  bool get puedeGestionar => _sesion.puede(Permiso.gestionarClientes);

  Future<void> cargar() async {
    cargando = true;
    notifyListeners();
    try {
      cliente = await _db.clientesDao.porId(clienteId);
      vehiculos = await _db.vehiculosDao.deCliente(clienteId);
      final ordenes = await _db.ordenesDao.deCliente(clienteId);
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
      error = 'No se pudo cargar el cliente: $e';
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> cambiarActivo(bool activo) async {
    _sesion.exigir(Permiso.gestionarClientes);
    await _db.clientesDao.cambiarActivo(clienteId, activo);
    await cargar();
  }
}
