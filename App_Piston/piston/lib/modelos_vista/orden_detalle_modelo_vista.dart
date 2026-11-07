import 'dart:async';

import 'package:flutter/foundation.dart';

import '../aplicacion/sesion.dart';
import '../datos/base_datos.dart';
import '../modelos/estado_orden.dart';
import '../modelos/orden_servicio.dart';
import '../modelos/repuesto_utilizado.dart';

/// Estado completo de la pantalla de detalle de una orden.
class OrdenDetalleModeloVista extends ChangeNotifier {
  OrdenDetalleModeloVista(this._db, this._sesion, this.ordenId) {
    _suscribir();
  }

  final BaseDatos _db;
  final Sesion _sesion;
  final int ordenId;

  StreamSubscription<OrdenResumen?>? _subOrden;
  StreamSubscription<TotalesOrden>? _subTotales;
  StreamSubscription<List<RepuestoUtilizado>>? _subRepuestos;
  StreamSubscription<List<Pago>>? _subPagos;

  OrdenResumen? orden;
  TotalesOrden totales = const TotalesOrden(
    manoObra: 0,
    repuestos: 0,
    pagado: 0,
  );
  List<RepuestoUtilizado> repuestos = const [];
  List<Pago> pagos = const [];
  List<Repuesto> repuestosDisponibles = const [];
  List<Mecanico> mecanicosDisponibles = const [];
  bool cargando = true;
  String? error;

  bool get esMecanico => _sesion.esMecanico;
  bool get puedeOperar => orden == null ? false : _sesion.puedeOperarOrden(orden!);
  bool get puedeEditar => orden?.estado.esEditable == true && puedeOperar;
  bool get puedeRegistrarTrabajos =>
      puedeEditar && _sesion.puede(Permiso.registrarTrabajos);
  bool get puedeConsumir =>
      puedeEditar && _sesion.puede(Permiso.consumirInventario);
  bool get puedeAsignar =>
      orden?.estado.esEditable == true &&
      _sesion.puede(Permiso.asignarMecanico);
  bool get puedeEditarDatos =>
      orden?.estado.esEditable == true &&
      _sesion.puede(Permiso.editarOrden);
  bool get puedePagar =>
      orden != null &&
      orden!.estado != EstadoOrden.cancelada &&
      _sesion.puede(Permiso.registrarPagos);
  bool get puedeCambiarEstado =>
      puedeEditar && _sesion.puede(Permiso.cambiarEstado);

  bool get estaPagada => totales.estaPagada;
  double get saldo => totales.saldo;

  List<EstadoOrden> get transicionesDisponibles {
    final actual = orden?.estado;
    if (actual == null) return const [];
    var lista = actual.transiciones;
    if (_sesion.esMecanico) {
      lista = lista
          .where((e) => e != EstadoOrden.entregada && e != EstadoOrden.cancelada)
          .toList();
    }
    return lista;
  }

  void _suscribir() {
    _subOrden = _db.ordenesDao.observarPorId(ordenId).listen(
      (valor) {
        orden = valor;
        cargando = false;
        notifyListeners();
      },
      onError: (Object e) {
        cargando = false;
        error = 'No se pudo cargar la orden: $e';
        notifyListeners();
      },
    );
    _subTotales = _db.ordenesDao.observarTotales(ordenId).listen((valor) {
      totales = valor;
      notifyListeners();
    });
    _subRepuestos = _db.repuestosOrdenDao.observarPorOrden(ordenId).listen((
      valor,
    ) {
      repuestos = valor;
      notifyListeners();
    });
    _subPagos = _db.pagosDao.observarPorOrden(ordenId).listen((valor) {
      pagos = valor;
      notifyListeners();
    });
    _cargarRepuestos();
  }

  Future<void> _cargarRepuestos() async {
    repuestosDisponibles = await _db.repuestosDao.todos();
    mecanicosDisponibles = await _db.mecanicosDao.todos(soloActivos: true);
    notifyListeners();
  }

  Future<void> recargarRepuestos() => _cargarRepuestos();

  Future<void> cambiarEstado(EstadoOrden nuevo) async {
    final actual = orden;
    if (actual == null) throw StateError('La orden no está cargada');
    _sesion.exigirOperarOrden(actual);
    _sesion.exigir(Permiso.cambiarEstado);
    if (_sesion.esMecanico &&
        (nuevo == EstadoOrden.entregada || nuevo == EstadoOrden.cancelada)) {
      throw const PermisoDenegado(
        'Solo recepción o administración pueden entregar o cancelar.',
      );
    }
    await _db.ordenesDao.cambiarEstado(ordenId, nuevo);
  }

  Future<void> asignarMecanico(int? mecanicoId) async {
    final actual = orden;
    if (actual == null) throw StateError('La orden no está cargada');
    _sesion.exigir(Permiso.asignarMecanico);
    await _db.ordenesDao.asignarMecanico(ordenId, mecanicoId);
  }

  Future<void> actualizarDatos({
    required DateTime fechaEntrada,
    required String problema,
    required int kilometrajeEntrada,
    String? notas,
    int? mecanicoId,
  }) async {
    final actual = orden;
    if (actual == null) throw StateError('La orden no está cargada');
    _sesion.exigir(Permiso.editarOrden);
    if (!actual.estado.esEditable) {
      throw StateError('La orden ya está cerrada');
    }
    if (problema.trim().isEmpty) {
      throw ArgumentError('Describe el problema reportado');
    }
    await _db.ordenesDao.actualizarOrden(
      id: ordenId,
      mecanicoId: mecanicoId,
      fechaEntrada: fechaEntrada,
      problema: problema,
      kilometrajeEntrada: kilometrajeEntrada,
      notas: notas,
    );
  }

  Future<void> agregarRepuesto(int repuestoId, int cantidad) async {
    final actual = orden;
    if (actual == null) throw StateError('La orden no está cargada');
    _sesion.exigir(Permiso.consumirInventario);
    _sesion.exigirOperarOrden(actual);
    if (!actual.estado.esEditable) {
      throw StateError('La orden ya está cerrada');
    }
    await _db.repuestosOrdenDao.agregar(
      ordenId: ordenId,
      repuestoId: repuestoId,
      cantidad: cantidad,
      usuario: _sesion.nombre,
    );
    await _cargarRepuestos();
  }

  Future<void> quitarRepuesto(int lineaId) async {
    final actual = orden;
    if (actual == null) throw StateError('La orden no está cargada');
    _sesion.exigir(Permiso.consumirInventario);
    _sesion.exigirOperarOrden(actual);
    if (!actual.estado.esEditable) {
      throw StateError('La orden ya está cerrada');
    }
    await _db.repuestosOrdenDao.quitarLinea(
      lineaId,
      usuario: _sesion.nombre,
    );
    await _cargarRepuestos();
  }

  Future<void> registrarPago({
    required double importe,
    required String metodo,
    String? nota,
  }) async {
    final actual = orden;
    if (actual == null) throw StateError('La orden no está cargada');
    _sesion.exigir(Permiso.registrarPagos);
    if (actual.estado == EstadoOrden.cancelada) {
      throw StateError('No se puede cobrar una orden cancelada');
    }
    await _db.pagosDao.registrar(
      ordenId: ordenId,
      importe: importe,
      metodo: metodo,
      nota: nota,
      registradoPor: _sesion.nombre,
    );
  }

  @override
  void dispose() {
    _subOrden?.cancel();
    _subTotales?.cancel();
    _subRepuestos?.cancel();
    _subPagos?.cancel();
    super.dispose();
  }
}
