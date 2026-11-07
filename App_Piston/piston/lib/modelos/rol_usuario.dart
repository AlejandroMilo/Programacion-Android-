import 'package:flutter/material.dart';

import '../utilidades/colores.dart';

/// Roles acordados para El Pistón. El rol sale de la cuenta, nunca de un
/// selector en la pantalla de acceso.
enum RolUsuario {
  administrador,
  recepcionista,
  mecanico;

  String get etiqueta => switch (this) {
    RolUsuario.administrador => 'Administrador',
    RolUsuario.recepcionista => 'Recepcionista',
    RolUsuario.mecanico => 'Mecánico',
  };

  String get descripcion => switch (this) {
    RolUsuario.administrador => 'Acceso completo',
    RolUsuario.recepcionista => 'Gestión del taller',
    RolUsuario.mecanico => 'Acceso operativo',
  };

  bool get esAdministrador => this == RolUsuario.administrador;
  bool get esRecepcionista => this == RolUsuario.recepcionista;
  bool get esMecanico => this == RolUsuario.mecanico;

  String get nombreCorto => switch (this) {
    RolUsuario.administrador => 'Admin',
    RolUsuario.recepcionista => 'Recepción',
    RolUsuario.mecanico => 'Mecánico',
  };

  Color get color => switch (this) {
    RolUsuario.administrador => Colores.naranja,
    RolUsuario.recepcionista => Colores.azul,
    RolUsuario.mecanico => Colores.morado,
  };
}
