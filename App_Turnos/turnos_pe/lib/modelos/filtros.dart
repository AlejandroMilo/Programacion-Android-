import 'package:flutter/material.dart';

import 'estado_turno.dart';
import 'genero.dart';
import 'publico.dart';

/// Filtro por publico usado en el formulario y en el catalogo de servicios.
enum FiltroPublico {
  todos,
  mujeres,
  hombres;

  String get etiqueta => switch (this) {
    FiltroPublico.todos => 'Todos',
    FiltroPublico.mujeres => 'Mujeres',
    FiltroPublico.hombres => 'Hombres',
  };

  Publico? get publico => switch (this) {
    FiltroPublico.todos => null,
    FiltroPublico.mujeres => Publico.mujeres,
    FiltroPublico.hombres => Publico.hombres,
  };

  /// Al filtrar por mujeres u hombres tambien se ofrecen los servicios unisex.
  bool incluye(Publico publico) => switch (this) {
    FiltroPublico.todos => true,
    FiltroPublico.mujeres =>
      publico == Publico.mujeres || publico == Publico.unisex,
    FiltroPublico.hombres =>
      publico == Publico.hombres || publico == Publico.unisex,
  };

  static FiltroPublico desdeGenero(Genero genero) => switch (genero) {
    Genero.mujer => FiltroPublico.mujeres,
    Genero.hombre => FiltroPublico.hombres,
  };
}

/// Filtro por genero de la pantalla Clientes.
enum FiltroGenero {
  todos,
  mujeres,
  hombres;

  String get etiqueta => switch (this) {
    FiltroGenero.todos => 'Todos',
    FiltroGenero.mujeres => 'Mujeres',
    FiltroGenero.hombres => 'Hombres',
  };

  Genero? get genero => switch (this) {
    FiltroGenero.todos => null,
    FiltroGenero.mujeres => Genero.mujer,
    FiltroGenero.hombres => Genero.hombre,
  };

  bool get coincide => genero != null;
}

/// Filtro por estado de la Agenda.
enum FiltroEstado {
  todos,
  programados,
  completados,
  cancelados;

  String get etiquetaCorta => switch (this) {
    FiltroEstado.todos => 'Todos',
    FiltroEstado.programados => 'Program.',
    FiltroEstado.completados => 'Complet.',
    FiltroEstado.cancelados => 'Cancel.',
  };

  EstadoTurno? get estado => switch (this) {
    FiltroEstado.todos => null,
    FiltroEstado.programados => EstadoTurno.programado,
    FiltroEstado.completados => EstadoTurno.completado,
    FiltroEstado.cancelados => EstadoTurno.cancelado,
  };
}

/// Opciones de tema de la app.
enum ModoTema {
  sistema,
  claro,
  oscuro;

  String get etiqueta => switch (this) {
    ModoTema.sistema => 'Sistema',
    ModoTema.claro => 'Claro',
    ModoTema.oscuro => 'Oscuro',
  };

  ThemeMode get themeMode => switch (this) {
    ModoTema.sistema => ThemeMode.system,
    ModoTema.claro => ThemeMode.light,
    ModoTema.oscuro => ThemeMode.dark,
  };

  IconData get icono => switch (this) {
    ModoTema.sistema => Icons.brightness_auto_outlined,
    ModoTema.claro => Icons.light_mode_outlined,
    ModoTema.oscuro => Icons.dark_mode_outlined,
  };
}
