import 'dart:async';

import 'package:flutter/foundation.dart';

import '../aplicacion/sesion.dart';
import '../datos/base_datos.dart';

class InventarioModeloVista extends ChangeNotifier {
  InventarioModeloVista(this._db, this._sesion) {
    _suscribir();
  }

  final BaseDatos _db;
  final Sesion _sesion;

  StreamSubscription<List<Repuesto>>? _suscripcion;
  String _busqueda = '';
  List<Repuesto> repuestos = const [];
  bool cargando = true;
  String? error;

  String get busqueda => _busqueda;
  bool get puedeGestionar => _sesion.puede(Permiso.gestionarInventario);
  int get bajos => repuestos.where((r) => r.stockBajo).length;
  int get agotados => repuestos.where((r) => r.sinStock).length;

  void _suscribir() {
    _suscripcion?.cancel();
    _suscripcion = _db.repuestosDao
        .observar(busqueda: _busqueda)
        .listen(
          (lista) {
            repuestos = lista;
            cargando = false;
            error = null;
            notifyListeners();
          },
          onError: (Object e) {
            cargando = false;
            error = 'No se pudo cargar el inventario: $e';
            notifyListeners();
          },
        );
  }

  void cambiarBusqueda(String valor) {
    if (_busqueda == valor) return;
    _busqueda = valor;
    cargando = true;
    notifyListeners();
    _suscribir();
  }

  Future<Repuesto?> porId(int id) => _db.repuestosDao.porId(id);

  Future<int> crear({
    required String nombre,
    required String codigo,
    required double precioVenta,
    required int existencias,
    required int umbral,
  }) async {
    _sesion.exigir(Permiso.gestionarInventario);
    if (await _db.repuestosDao.porCodigo(codigo) != null) {
      throw StateError('Ya existe un repuesto con ese código');
    }
    return _db.repuestosDao.crear(
      nombre: nombre,
      codigo: codigo,
      precioVenta: precioVenta,
      existencias: existencias,
      umbral: umbral,
    );
  }

  Future<void> actualizar({
    required Repuesto repuesto,
    required String nombre,
    required String codigo,
    required double precioVenta,
    required int umbral,
  }) async {
    _sesion.exigir(Permiso.gestionarInventario);
    final existente = await _db.repuestosDao.porCodigo(codigo);
    if (existente != null && existente.id != repuesto.id) {
      throw StateError('Ya existe otro repuesto con ese código');
    }
    await _db.repuestosDao.actualizar(
      repuesto.copyWith(
        nombre: nombre.trim(),
        codigo: codigo.trim().toUpperCase(),
        precioVenta: precioVenta,
        umbral: umbral,
      ),
    );
  }

  Future<void> ajustarStock({
    required Repuesto repuesto,
    required int delta,
    String? nota,
  }) async {
    _sesion.exigir(Permiso.gestionarInventario);
    await _db.repuestosDao.ajustarStock(
      repuestoId: repuesto.id,
      delta: delta,
      nota: nota,
      usuario: _sesion.nombre,
    );
  }

  Future<void> cambiarActivo(Repuesto repuesto, bool activo) async {
    _sesion.exigir(Permiso.gestionarInventario);
    await _db.repuestosDao.cambiarActivo(repuesto.id, activo);
  }

  Future<List<MovimientoInventario>> movimientos(int repuestoId) =>
      _db.repuestosDao.movimientos(repuestoId);

  @override
  void dispose() {
    _suscripcion?.cancel();
    super.dispose();
  }
}
