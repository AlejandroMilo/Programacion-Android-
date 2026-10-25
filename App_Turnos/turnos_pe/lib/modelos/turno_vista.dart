import 'cliente.dart';
import 'estilista.dart';
import 'reglas_turno.dart';
import 'servicio.dart';
import 'turno.dart';

/// Turno con sus datos resueltos (cliente, estilista, servicios) y los
/// valores calculados: duracion total, hora de fin y precio total.
class TurnoVista {
  const TurnoVista({
    required this.turno,
    required this.cliente,
    required this.estilista,
    required this.servicios,
  });

  final Turno turno;
  final Cliente cliente;
  final Estilista estilista;
  final List<Servicio> servicios;

  int get duracionMinutos => ReglasTurno.duracionTotal(servicios);

  double get precioTotal => ReglasTurno.precioTotal(servicios);

  DateTime get fin => ReglasTurno.horaFin(turno.inicio, duracionMinutos);

  String get horaInicioTexto => ReglasTurno.formatearHora(turno.inicio);

  String get horaFinTexto => ReglasTurno.formatearHora(fin);

  String get duracionTexto => ReglasTurno.formatearDuracion(duracionMinutos);

  String get precioTexto => '\$ ${precioTotal.toStringAsFixed(0)}';

  String get serviciosTexto =>
      servicios.map((servicio) => servicio.nombre).join(' + ');

  bool get tieneNotas => turno.tieneNotas;
}
