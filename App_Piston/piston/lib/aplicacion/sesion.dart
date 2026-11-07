import 'package:flutter/foundation.dart';

import '../datos/base_datos.dart';
import '../modelos/orden_servicio.dart';
import '../modelos/rol_usuario.dart';
import '../utilidades/seguridad.dart';

/// Permisos funcionales. Se comprueban en los modelos de vista, no solo
/// ocultando botones en la interfaz.
enum Permiso {
  verInicio,
  crearOrden,
  editarOrden,
  asignarMecanico,
  cambiarEstado,
  registrarTrabajos,
  consumirInventario,
  gestionarClientes,
  gestionarVehiculos,
  gestionarInventario,
  registrarPagos,
  verPagos,
  verReportes,
  gestionarMecanicos,
  gestionarUsuarios,
  verHistorial,
  configurarTaller,
}

class PermisoDenegado implements Exception {
  const PermisoDenegado(this.mensaje);

  final String mensaje;

  @override
  String toString() => mensaje;
}

/// Sesión activa de la aplicación. El rol siempre proviene de la cuenta.
class Sesion extends ChangeNotifier {
  Sesion(this.db);

  final BaseDatos db;

  Usuario? _usuario;
  String? _error;
  bool _cargando = false;

  Usuario? get usuario => _usuario;
  String? get error => _error;
  bool get cargando => _cargando;
  bool get autenticado => _usuario != null;
  RolUsuario? get rol => _usuario?.rol;
  int? get mecanicoId => _usuario?.mecanicoId;

  String get nombre => _usuario?.nombrePersona ?? '';
  String get nombreUsuario => _usuario?.nombreUsuario ?? '';
  String get rolEtiqueta => _usuario?.rol.etiqueta ?? 'Invitado';

  bool get esAdministrador => rol == RolUsuario.administrador;
  bool get esRecepcionista => rol == RolUsuario.recepcionista;
  bool get esMecanico => rol == RolUsuario.mecanico;

  Future<bool> iniciarSesion(String usuario, String clave) async {
    _error = null;
    _cargando = true;
    notifyListeners();
    try {
      final encontrado = await db.usuariosDao.porNombreUsuario(usuario);
      if (encontrado == null) {
        _error = 'Usuario o contraseña incorrectos';
        return false;
      }
      if (!encontrado.activo) {
        _error = 'Esta cuenta está desactivada. Contacta al administrador.';
        return false;
      }
      if (!Seguridad.verificar(clave, encontrado.sal, encontrado.claveHash)) {
        _error = 'Usuario o contraseña incorrectos';
        return false;
      }
      _usuario = encontrado;
      return true;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  void cerrarSesion() {
    _usuario = null;
    _error = null;
    notifyListeners();
  }

  void limpiarError() {
    if (_error == null) return;
    _error = null;
    notifyListeners();
  }

  bool puede(Permiso permiso) {
    final rolActual = rol;
    if (rolActual == null) return false;
    if (rolActual == RolUsuario.administrador) return true;
    return switch (permiso) {
      Permiso.verInicio => true,
      Permiso.crearOrden => rolActual == RolUsuario.recepcionista,
      Permiso.editarOrden => rolActual == RolUsuario.recepcionista,
      Permiso.asignarMecanico => rolActual == RolUsuario.recepcionista,
      Permiso.cambiarEstado => true,
      Permiso.registrarTrabajos => rolActual == RolUsuario.mecanico,
      Permiso.consumirInventario => rolActual == RolUsuario.mecanico,
      Permiso.gestionarClientes => rolActual == RolUsuario.recepcionista,
      Permiso.gestionarVehiculos => rolActual == RolUsuario.recepcionista,
      Permiso.gestionarInventario => false,
      Permiso.registrarPagos => rolActual == RolUsuario.recepcionista,
      Permiso.verPagos => rolActual == RolUsuario.recepcionista,
      Permiso.verReportes => false,
      Permiso.gestionarMecanicos => false,
      Permiso.gestionarUsuarios => false,
      Permiso.verHistorial => true,
      Permiso.configurarTaller => false,
    };
  }

  void exigir(Permiso permiso) {
    if (!puede(permiso)) {
      throw const PermisoDenegado(
        'Tu rol no tiene permiso para realizar esta acción.',
      );
    }
  }

  /// Un mecánico solo puede operar las órdenes que tiene asignadas.
  bool puedeOperarOrden(OrdenResumen orden) {
    if (esAdministrador || esRecepcionista) return true;
    if (esMecanico) return orden.mecanico?.id == mecanicoId;
    return false;
  }

  void exigirOperarOrden(OrdenResumen orden) {
    if (!puedeOperarOrden(orden)) {
      throw const PermisoDenegado(
        'Esta orden no está asignada a tu cuenta.',
      );
    }
  }
}
