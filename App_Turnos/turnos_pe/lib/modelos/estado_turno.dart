/// Estado de un turno. Los turnos no se eliminan: la baja es la cancelacion.
enum EstadoTurno {
  programado,
  completado,
  cancelado;

  String get etiqueta => switch (this) {
    EstadoTurno.programado => 'Programado',
    EstadoTurno.completado => 'Completado',
    EstadoTurno.cancelado => 'Cancelado',
  };

  String get plural => switch (this) {
    EstadoTurno.programado => 'Programados',
    EstadoTurno.completado => 'Completados',
    EstadoTurno.cancelado => 'Cancelados',
  };

  /// Solo los turnos programados se pueden editar, completar o cancelar.
  bool get esEditable => this == EstadoTurno.programado;
}
