import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';

import '../aplicacion/sesion.dart';
import '../datos/base_datos.dart';
import '../modelos/orden_servicio.dart';

class ClientesModeloVista extends ChangeNotifier {
  ClientesModeloVista(this._db, this._sesion) {
    _suscribir();
  }

  final BaseDatos _db;
  final Sesion _sesion;

  StreamSubscription<List<Cliente>>? _suscripcion;
  String _busqueda = '';
  List<Cliente> clientes = const [];
  bool cargando = true;
  String? error;

  String get busqueda => _busqueda;
  bool get puedeGestionar => _sesion.puede(Permiso.gestionarClientes);

  void _suscribir() {
    _suscripcion?.cancel();
    _suscripcion = _db.clientesDao
        .observar(busqueda: _busqueda)
        .listen(
          (lista) {
            clientes = lista;
            cargando = false;
            error = null;
            notifyListeners();
          },
          onError: (Object e) {
            cargando = false;
            error = 'No se pudieron cargar los clientes: $e';
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

  Future<Cliente?> porId(int id) => _db.clientesDao.porId(id);

  Future<List<Vehiculo>> vehiculos(int clienteId) =>
      _db.vehiculosDao.deCliente(clienteId);

  Future<List<ResultadoOrden>> historial(int clienteId) async {
    final ordenes = await _db.ordenesDao.deCliente(clienteId);
    final resultado = <ResultadoOrden>[];
    for (final orden in ordenes) {
      resultado.add(
        ResultadoOrden(
          orden: orden,
          totales: await _db.ordenesDao.totales(orden.id),
        ),
      );
    }
    return resultado;
  }

  Future<double> saldo(int clienteId) async {
    final historial = await this.historial(clienteId);
    return historial
        .where((r) => r.orden.estado.estaAbierta || r.totales.saldo > 0)
        .fold<double>(0, (total, r) => total + r.totales.saldo);
  }

  Future<int> crear({
    required String nombre,
    required String telefono,
    String? direccion,
  }) async {
    _sesion.exigir(Permiso.gestionarClientes);
    if (await _db.clientesDao.telefonoEnUso(telefono)) {
      throw StateError('Ya existe un cliente con ese teléfono');
    }
    return _db.clientesDao.crear(
      nombre: nombre,
      telefono: telefono,
      direccion: direccion,
    );
  }

  Future<void> actualizar({
    required Cliente cliente,
    required String nombre,
    required String telefono,
    String? direccion,
  }) async {
    _sesion.exigir(Permiso.gestionarClientes);
    if (await _db.clientesDao.telefonoEnUso(
      telefono,
      exceptoId: cliente.id,
    )) {
      throw StateError('Ya existe otro cliente con ese teléfono');
    }
    await _db.clientesDao.actualizar(
      cliente.copyWith(
        nombre: nombre.trim(),
        telefono: telefono.trim(),
        direccion: Value(
          direccion == null || direccion.trim().isEmpty
              ? null
              : direccion.trim(),
        ),
      ),
    );
  }

  Future<void> cambiarActivo(Cliente cliente, bool activo) async {
    _sesion.exigir(Permiso.gestionarClientes);
    await _db.clientesDao.cambiarActivo(cliente.id, activo);
  }

  @override
  void dispose() {
    _suscripcion?.cancel();
    super.dispose();
  }
}
