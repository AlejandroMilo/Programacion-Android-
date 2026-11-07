import 'dart:async';

import 'package:flutter/foundation.dart';

import '../aplicacion/sesion.dart';
import '../datos/base_datos.dart';
import '../modelos/estado_orden.dart';
import '../modelos/orden_servicio.dart';

/// Filtros y listado reactivo de órdenes.
class OrdenesModeloVista extends ChangeNotifier {
  OrdenesModeloVista(this._db, this._sesion) {
    if (_sesion.esMecanico) {
      _mecanicoId = _sesion.mecanicoId;
    }
    _cargarMecanicos();
    _suscribir();
  }

  final BaseDatos _db;
  final Sesion _sesion;

  StreamSubscription<List<OrdenResumen>>? _suscripcion;
  String _busqueda = '';
  EstadoOrden? _estado;
  int? _mecanicoId;
  DateTime? _desde;
  DateTime? _hasta;

  List<OrdenResumen> ordenes = const [];
  Map<int, TotalesOrden> totales = {};
  List<Mecanico> mecanicos = const [];
  bool cargando = true;
  String? error;

  double? totalDe(int ordenId) => totales[ordenId]?.total;

  String get busqueda => _busqueda;
  EstadoOrden? get estado => _estado;
  int? get mecanicoId => _mecanicoId;
  DateTime? get desde => _desde;
  DateTime? get hasta => _hasta;
  bool get esMecanico => _sesion.esMecanico;
  bool get hayFiltros =>
      _busqueda.isNotEmpty ||
      _estado != null ||
      (_mecanicoId != null && !_sesion.esMecanico) ||
      _desde != null ||
      _hasta != null;

  Future<void> _cargarMecanicos() async {
    try {
      mecanicos = await _db.mecanicosDao.todos(soloActivos: true);
      notifyListeners();
    } catch (_) {
      // Si falla, el filtro por mecánico simplemente no se muestra.
    }
  }

  void _suscribir() {
    _suscripcion?.cancel();
    _suscripcion = _db.ordenesDao
        .observar(
          busqueda: _busqueda,
          estado: _estado,
          mecanicoId: _mecanicoId,
          desde: _desde,
          hasta: _hasta,
        )
        .listen(
          (lista) async {
            ordenes = lista;
            totales = {};
            for (final orden in lista) {
              try {
                final t = await _db.ordenesDao.totales(orden.id);
                totales[orden.id] = t;
              } catch (_) {
                // Si falla un total, se omite para esa orden.
              }
            }
            cargando = false;
            error = null;
            notifyListeners();
          },
          onError: (Object e) {
            cargando = false;
            error = 'No se pudieron cargar las órdenes: $e';
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

  void cambiarEstado(EstadoOrden? valor) {
    if (_estado == valor) return;
    _estado = valor;
    cargando = true;
    notifyListeners();
    _suscribir();
  }

  void cambiarMecanico(int? valor) {
    if (_sesion.esMecanico) return;
    if (_mecanicoId == valor) return;
    _mecanicoId = valor;
    cargando = true;
    notifyListeners();
    _suscribir();
  }

  void cambiarFechas(DateTime? desde, DateTime? hasta) {
    _desde = desde;
    _hasta = hasta;
    cargando = true;
    notifyListeners();
    _suscribir();
  }

  void limpiarFiltros() {
    _busqueda = '';
    _estado = null;
    _desde = null;
    _hasta = null;
    if (!_sesion.esMecanico) _mecanicoId = null;
    cargando = true;
    notifyListeners();
    _suscribir();
  }

  void refrescar() {
    cargando = true;
    error = null;
    notifyListeners();
    _suscribir();
  }

  Future<OrdenResumen?> porId(int id) => _db.ordenesDao.porId(id);

  @override
  void dispose() {
    _suscripcion?.cancel();
    super.dispose();
  }
}
