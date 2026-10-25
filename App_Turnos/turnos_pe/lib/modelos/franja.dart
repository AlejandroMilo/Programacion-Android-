/// Una franja de 30 minutos ofrecida en el formulario de turno.
class Franja {
  const Franja({required this.hora, required this.disponible, this.motivo});

  final DateTime hora;
  final bool disponible;

  /// Motivo por el que la franja no esta disponible (informativo).
  final String? motivo;
}
