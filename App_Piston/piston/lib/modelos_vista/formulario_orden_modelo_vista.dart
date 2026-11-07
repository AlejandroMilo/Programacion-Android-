import 'package:flutter/foundation.dart';

import '../aplicacion/sesion.dart';
import '../datos/base_datos.dart';

/// Datos y acciones del formulario de una orden nueva.
class FormularioOrdenModeloVista extends ChangeNotifier {
  FormularioOrdenModeloVista(this._db, this._sesion);

  final BaseDatos _db;
  final Sesion _sesion;

  List<Cliente> clientes = const [];
  List<Mecanico> mecanicos = const [];
  List<Vehiculo> vehiculos = const [];
  int? clienteId;
  int? vehiculoId;
  bool cargando = true;
  String? error;

  Future<void> cargar({int? clientePreselected, int? vehiculoPreselected}) async {
    cargando = true;
    notifyListeners();
    try {
      clientes = await _db.clientesDao.todos(soloActivos: true);
      mecanicos = await _db.mecanicosDao.todos(soloActivos: true);
      clienteId = clientePreselected;
      if (clienteId != null) {
        vehiculos = await _db.vehiculosDao.deCliente(clienteId!);
        if (vehiculoPreselected != null &&
            !vehiculos.any((v) => v.id == vehiculoPreselected)) {
          vehiculoPreselected = null;
        }
        vehiculoId = vehiculoPreselected;
      }
      error = null;
    } catch (e) {
      error = 'No se pudieron cargar los datos: $e';
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> seleccionarCliente(int? id) async {
    clienteId = id;
    vehiculoId = null;
    vehiculos = id == null
        ? const []
        : await _db.vehiculosDao.deCliente(id);
    notifyListeners();
  }

  void seleccionarVehiculo(int? id) {
    vehiculoId = id;
    notifyListeners();
  }

  Future<int> crearClienteRapido({
    required String nombre,
    required String telefono,
    String? direccion,
  }) async {
    _sesion.exigir(Permiso.gestionarClientes);
    if (await _db.clientesDao.telefonoEnUso(telefono)) {
      throw StateError('Ya existe un cliente con ese teléfono');
    }
    final id = await _db.clientesDao.crear(
      nombre: nombre,
      telefono: telefono,
      direccion: direccion,
    );
    await cargar();
    await seleccionarCliente(id);
    return id;
  }

  Future<int> crearVehiculoRapido({
    required String matricula,
    required String marca,
    required String modelo,
    required int anio,
    required int kilometraje,
  }) async {
    _sesion.exigir(Permiso.gestionarVehiculos);
    final idCliente = clienteId;
    if (idCliente == null) {
      throw StateError('Selecciona primero un cliente');
    }
    if (await _db.vehiculosDao.porMatricula(matricula) != null) {
      throw StateError('Ya existe un vehículo con esa matrícula');
    }
    final id = await _db.vehiculosDao.crear(
      clienteId: idCliente,
      matricula: matricula,
      marca: marca,
      modelo: modelo,
      anio: anio,
      kilometraje: kilometraje,
    );
    vehiculos = await _db.vehiculosDao.deCliente(idCliente);
    vehiculoId = id;
    notifyListeners();
    return id;
  }

  Future<int> guardar({
    required DateTime fechaEntrada,
    required String problema,
    required int kilometrajeEntrada,
    String? notas,
    int? mecanicoId,
  }) async {
    _sesion.exigir(Permiso.crearOrden);
    final idCliente = clienteId;
    final idVehiculo = vehiculoId;
    if (idCliente == null) throw StateError('Selecciona un cliente');
    if (idVehiculo == null) throw StateError('Selecciona un vehículo');
    if (problema.trim().isEmpty) {
      throw StateError('Describe el problema reportado');
    }
    if (kilometrajeEntrada < 0) {
      throw StateError('El kilometraje no puede ser negativo');
    }
    return _db.ordenesDao.crear(
      clienteId: idCliente,
      vehiculoId: idVehiculo,
      mecanicoId: mecanicoId,
      fechaEntrada: fechaEntrada,
      problema: problema,
      kilometrajeEntrada: kilometrajeEntrada,
      notas: notas,
    );
  }
}
