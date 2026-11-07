import 'dart:async';

import 'package:flutter/foundation.dart';

import '../aplicacion/sesion.dart';
import '../datos/base_datos.dart';
import '../modelos/orden_servicio.dart';

/// Trabajos de mano de obra de una orden.
class TrabajosModeloVista extends ChangeNotifier {
  TrabajosModeloVista(this._db, this._sesion, this.ordenId) {
    _suscribir();
  }

  final BaseDatos _db;
  final Sesion _sesion;
  final int ordenId;

  StreamSubscription<List<Trabajo>>? _suscripcion;
  List<Trabajo> trabajos = const [];
  bool cargando = true;
  String? error;

  double get total =>
      trabajos.fold<double>(0, (suma, t) => suma + t.precioManoObra);

  void _suscribir() {
    _suscripcion = _db.trabajosDao.observarPorOrden(ordenId).listen(
      (lista) {
        trabajos = lista;
        cargando = false;
        notifyListeners();
      },
      onError: (Object e) {
        cargando = false;
        error = 'No se pudieron cargar los trabajos: $e';
        notifyListeners();
      },
    );
  }

  void _validar(OrdenResumen orden) {
    _sesion.exigir(Permiso.registrarTrabajos);
    _sesion.exigirOperarOrden(orden);
    if (!orden.estado.esEditable) {
      throw StateError('La orden ya está cerrada');
    }
  }

  Future<void> agregar({
    required OrdenResumen orden,
    required String descripcion,
    required double precio,
  }) async {
    _validar(orden);
    if (descripcion.trim().isEmpty) {
      throw ArgumentError('Escribe la descripción del trabajo');
    }
    if (precio < 0) throw ArgumentError('El precio no puede ser negativo');
    await _db.trabajosDao.crear(
      ordenId: ordenId,
      descripcion: descripcion,
      precioManoObra: precio,
      mecanicoId: orden.mecanico?.id ?? _sesion.mecanicoId,
    );
  }

  Future<void> eliminar({
    required OrdenResumen orden,
    required int trabajoId,
  }) async {
    _validar(orden);
    await _db.trabajosDao.eliminar(trabajoId);
  }

  @override
  void dispose() {
    _suscripcion?.cancel();
    super.dispose();
  }
}
