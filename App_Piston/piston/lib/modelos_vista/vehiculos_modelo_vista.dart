import 'dart:async';

import 'package:flutter/foundation.dart';

import '../aplicacion/sesion.dart';
import '../datos/base_datos.dart';
import '../modelos/orden_servicio.dart';
import '../modelos/vehiculo.dart';

class VehiculosModeloVista extends ChangeNotifier {
  VehiculosModeloVista(this._db, this._sesion) {
    _suscribir();
    _cargarClientes();
  }

  final BaseDatos _db;
  final Sesion _sesion;

  StreamSubscription<List<VehiculoConDueno>>? _suscripcion;
  String _busqueda = '';
  List<VehiculoConDueno> vehiculos = const [];
  List<Cliente> clientes = const [];
  bool cargando = true;
  String? error;

  String get busqueda => _busqueda;
  bool get puedeGestionar => _sesion.puede(Permiso.gestionarVehiculos);

  Future<void> _cargarClientes() async {
    try {
      clientes = await _db.clientesDao.todos();
      notifyListeners();
    } catch (_) {
      // El formulario mostrará la lista vacía si falla.
    }
  }

  void _suscribir() {
    _suscripcion?.cancel();
    _suscripcion = _db.vehiculosDao
        .observar(busqueda: _busqueda)
        .listen(
          (lista) {
            vehiculos = lista;
            cargando = false;
            error = null;
            notifyListeners();
          },
          onError: (Object e) {
            cargando = false;
            error = 'No se pudieron cargar los vehículos: $e';
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

  Future<Vehiculo?> porId(int id) => _db.vehiculosDao.porId(id);

  Future<List<ResultadoOrden>> historial(int vehiculoId) async {
    final ordenes = await _db.ordenesDao.deVehiculo(vehiculoId);
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

  Future<int> crear({
    required int clienteId,
    required String matricula,
    required String marca,
    required String modelo,
    required int anio,
    required int kilometraje,
  }) async {
    _sesion.exigir(Permiso.gestionarVehiculos);
    if (await _db.vehiculosDao.porMatricula(matricula) != null) {
      throw StateError('Ya existe un vehículo con esa matrícula');
    }
    return _db.vehiculosDao.crear(
      clienteId: clienteId,
      matricula: matricula,
      marca: marca,
      modelo: modelo,
      anio: anio,
      kilometraje: kilometraje,
    );
  }

  Future<void> actualizar({
    required Vehiculo vehiculo,
    required int clienteId,
    required String matricula,
    required String marca,
    required String modelo,
    required int anio,
    required int kilometraje,
  }) async {
    _sesion.exigir(Permiso.gestionarVehiculos);
    final existente = await _db.vehiculosDao.porMatricula(matricula);
    if (existente != null && existente.id != vehiculo.id) {
      throw StateError('Ya existe otro vehículo con esa matrícula');
    }
    await _db.vehiculosDao.actualizar(
      vehiculo.copyWith(
        clienteId: clienteId,
        matricula: matricula.trim().toUpperCase(),
        marca: marca.trim(),
        modelo: modelo.trim(),
        anio: anio,
        kilometraje: kilometraje,
      ),
    );
  }

  Future<void> cambiarActivo(Vehiculo vehiculo, bool activo) async {
    _sesion.exigir(Permiso.gestionarVehiculos);
    await _db.vehiculosDao.cambiarActivo(vehiculo.id, activo);
  }

  @override
  void dispose() {
    _suscripcion?.cancel();
    super.dispose();
  }
}
