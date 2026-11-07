import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';

import '../aplicacion/sesion.dart';
import '../datos/base_datos.dart';
import '../utilidades/seguridad.dart';

class UsuariosModeloVista extends ChangeNotifier {
  UsuariosModeloVista(this._db, this._sesion) {
    _suscribir();
    _cargarMecanicos();
  }

  final BaseDatos _db;
  final Sesion _sesion;

  StreamSubscription<List<Usuario>>? _suscripcion;
  List<Usuario> usuarios = const [];
  List<Mecanico> mecanicos = const [];
  bool cargando = true;
  String? error;

  bool get puedeGestionar => _sesion.puede(Permiso.gestionarUsuarios);

  void _suscribir() {
    _suscripcion = _db.usuariosDao.observar().listen(
      (lista) {
        usuarios = lista;
        cargando = false;
        error = null;
        notifyListeners();
      },
      onError: (Object e) {
        cargando = false;
        error = 'No se pudieron cargar los usuarios: $e';
        notifyListeners();
      },
    );
  }

  Future<void> _cargarMecanicos() async {
    mecanicos = await _db.mecanicosDao.todos();
    notifyListeners();
  }

  Future<int> crear({
    required String nombreUsuario,
    required String nombrePersona,
    required RolUsuario rol,
    required String clave,
    int? mecanicoId,
  }) async {
    _sesion.exigir(Permiso.gestionarUsuarios);
    final normalizado = nombreUsuario.trim().toLowerCase();
    if (await _db.usuariosDao.porNombreUsuario(normalizado) != null) {
      throw StateError('Ese nombre de usuario ya existe');
    }
    final sal = Seguridad.generarSal();
    return _db.usuariosDao.crear(
      nombreUsuario: normalizado,
      nombrePersona: nombrePersona,
      rol: rol,
      claveHash: Seguridad.hashear(clave, sal),
      sal: sal,
      mecanicoId: mecanicoId,
    );
  }

  Future<void> cambiarRol(Usuario usuario, RolUsuario rol) async {
    _sesion.exigir(Permiso.gestionarUsuarios);
    if (usuario.id == _sesion.usuario?.id && rol != RolUsuario.administrador) {
      throw StateError('No puedes quitarte el rol de administrador');
    }
    await _db.usuariosDao.actualizarRol(usuario.id, rol);
  }

  Future<void> vincularMecanico(Usuario usuario, int? mecanicoId) async {
    _sesion.exigir(Permiso.gestionarUsuarios);
    await _db.usuariosDao.actualizar(
      usuario.copyWith(mecanicoId: Value(mecanicoId)),
    );
  }

  Future<void> cambiarActivo(Usuario usuario, bool activo) async {
    _sesion.exigir(Permiso.gestionarUsuarios);
    if (!activo && usuario.id == _sesion.usuario?.id) {
      throw StateError('No puedes desactivar tu propia cuenta');
    }
    await _db.usuariosDao.cambiarActivo(usuario.id, activo);
  }

  Future<void> restablecerClave(Usuario usuario, String clave) async {
    _sesion.exigir(Permiso.gestionarUsuarios);
    final sal = Seguridad.generarSal();
    await _db.usuariosDao.actualizarClave(
      usuario.id,
      Seguridad.hashear(clave, sal),
      sal,
    );
  }

  @override
  void dispose() {
    _suscripcion?.cancel();
    super.dispose();
  }
}
