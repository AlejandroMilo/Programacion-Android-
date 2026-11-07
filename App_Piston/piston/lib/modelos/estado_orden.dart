/// Estados por los que pasa una orden de servicio.
enum EstadoOrden {
  recibida,
  enDiagnostico,
  enReparacion,
  listaParaEntregar,
  entregada,
  cancelada;

  String get etiqueta => switch (this) {
    EstadoOrden.recibida => 'Recibida',
    EstadoOrden.enDiagnostico => 'En diagnóstico',
    EstadoOrden.enReparacion => 'En reparación',
    EstadoOrden.listaParaEntregar => 'Lista para entregar',
    EstadoOrden.entregada => 'Entregada',
    EstadoOrden.cancelada => 'Cancelada',
  };

  bool get esFinal => this == EstadoOrden.entregada || this == EstadoOrden.cancelada;

  bool get estaAbierta => !esFinal;

  /// Las entregadas y canceladas quedan en el historial y no se editan.
  bool get esEditable => estaAbierta;

  /// Siguiente estado natural del flujo del taller.
  EstadoOrden? get siguiente => switch (this) {
    EstadoOrden.recibida => EstadoOrden.enDiagnostico,
    EstadoOrden.enDiagnostico => EstadoOrden.enReparacion,
    EstadoOrden.enReparacion => EstadoOrden.listaParaEntregar,
    EstadoOrden.listaParaEntregar => EstadoOrden.entregada,
    EstadoOrden.entregada => null,
    EstadoOrden.cancelada => null,
  };

  /// Estados a los que se puede mover una orden desde el estado actual.
  List<EstadoOrden> get transiciones => switch (this) {
    EstadoOrden.recibida => const [
      EstadoOrden.enDiagnostico,
      EstadoOrden.cancelada,
    ],
    EstadoOrden.enDiagnostico => const [
      EstadoOrden.enReparacion,
      EstadoOrden.cancelada,
    ],
    EstadoOrden.enReparacion => const [
      EstadoOrden.listaParaEntregar,
      EstadoOrden.cancelada,
    ],
    EstadoOrden.listaParaEntregar => const [
      EstadoOrden.entregada,
      EstadoOrden.enReparacion,
    ],
    EstadoOrden.entregada => const [],
    EstadoOrden.cancelada => const [],
  };

  bool puedePasarA(EstadoOrden destino) => transiciones.contains(destino);
}
