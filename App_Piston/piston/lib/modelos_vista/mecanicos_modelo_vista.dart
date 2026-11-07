import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';

import '../aplicacion/sesion.dart';
import '../datos/base_datos.dart';
import '../modelos/mecanico.dart';

class MecanicosModeloVista extends ChangeNotifier {
  MecanicosModeloVista(this._db, this._sesion) {
    _suscribir();
    cargarCarga();
  }

  final BaseDatos _db;
  final Sesion _sesion;

  StreamSubscription<List<Mecanico>>? _suscripcion;
  List<Mecanico> mecanicos = const [];
  List<CargaMecanico> carga = const [];
  bool cargando = true;
  String? error;

  bool get puedeGestionar => _sesion.puede(Permiso.gestionarMecanicos);

  void _suscribir() {
    _suscripcion = _db.mecanicosDao.observar(soloActivos: false).listen(
      (lista) {
        mecanicos = lista;
        cargando = false;
        error = null;
        notifyListeners();
      },
      onError: (Object e) {
        cargando = false;
        error = 'No se pudieron cargar los mecánicos: $e';
        notifyListeners();
      },
    );
  }

  Future<void> cargarCarga() async {
    try {
      carga = await _db.reportesDao.cargaMecanicos();
      notifyListeners();
    } catch (_) {
      // La sección de carga puede quedar vacía.
    }
  }

  CargaMecanico? cargaDe(int mecanicoId) {
    for (final item in carga) {
      if (item.mecanico.id == mecanicoId) return item;
    }
    return null;
  }

  Future<int> crear({
    required String nombre,
    required String telefono,
    required String especialidad,
  }) async {
    _sesion.exigir(Permiso.gestionarMecanicos);
    final id = await _db.mecanicosDao.crear(
      nombre: nombre,
      telefono: telefono,
      especialidad: especialidad,
    );
    await cargarCarga();
    return id;
  }

  Future<void> actualizar({
    required Mecanico mecanico,
    required String nombre,
    required String telefono,
    required String especialidad,
  }) async {
    _sesion.exigir(Permiso.gestionarMecanicos);
    await _db.mecanicosDao.actualizar(
      mecanico.copyWith(
        nombre: nombre.trim(),
        telefono: Value(
          telefono.trim().isEmpty ? null : telefono.trim(),
        ),
        especialidad: Value(
          especialidad.trim().isEmpty ? null : especialidad.trim(),
        ),
      ),
    );
  }

  Future<void> cambiarActivo(Mecanico mecanico, bool activo) async {
    _sesion.exigir(Permiso.gestionarMecanicos);
    await _db.mecanicosDao.cambiarActivo(mecanico.id, activo);
    await cargarCarga();
  }

  Future<List<OrdenResumen>> ordenesAsignadas(int mecanicoId) =>
      _db.ordenesDao.asignadas(mecanicoId);

  @override
  void dispose() {
    _suscripcion?.cancel();
    super.dispose();
  }
}
