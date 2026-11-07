import 'package:flutter/foundation.dart';

import '../aplicacion/sesion.dart';
import '../datos/base_datos.dart';
import '../modelos/orden_servicio.dart';

class HistorialModeloVista extends ChangeNotifier {
  HistorialModeloVista(
    this._db,
    this._sesion, {
    this.clienteId,
    this.vehiculoId,
  });

  final BaseDatos _db;
  final Sesion _sesion;
  final int? clienteId;
  final int? vehiculoId;

  String _busqueda = '';
  DateTime? _desde;
  DateTime? _hasta;
  List<ResultadoOrden> resultados = const [];
  bool cargando = true;
  String? error;

  String get busqueda => _busqueda;
  DateTime? get desde => _desde;
  DateTime? get hasta => _hasta;

  Future<void> cargar() async {
    _sesion.exigir(Permiso.verHistorial);
    cargando = true;
    notifyListeners();
    try {
      final ordenes = await _db.ordenesDao.historial(
        clienteId: clienteId,
        vehiculoId: vehiculoId,
        desde: _desde,
        hasta: _hasta,
      );
      final texto = _busqueda.trim().toLowerCase();
      final filtradas = texto.isEmpty
          ? ordenes
          : ordenes
                .where(
                  (o) =>
                      o.numero.toLowerCase().contains(texto) ||
                      o.cliente.nombre.toLowerCase().contains(texto) ||
                      o.matricula.toLowerCase().contains(texto),
                )
                .toList();
      final resultado = <ResultadoOrden>[];
      for (final orden in filtradas) {
        resultado.add(
          ResultadoOrden(
            orden: orden,
            totales: await _db.ordenesDao.totales(orden.id),
          ),
        );
      }
      resultados = resultado;
      error = null;
    } catch (e) {
      error = 'No se pudo cargar el historial: $e';
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  void cambiarBusqueda(String valor) {
    _busqueda = valor;
    cargar();
  }

  void cambiarFechas(DateTime? desde, DateTime? hasta) {
    _desde = desde;
    _hasta = hasta;
    cargar();
  }
}
