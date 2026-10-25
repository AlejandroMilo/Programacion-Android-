import 'estado_turno.dart';

/// Turno: pertenece a un cliente y a un estilista e incluye uno o varios servicios.
/// La duracion total, la hora de fin y el precio total se calculan, no se guardan.
class Turno {
  const Turno({
    required this.id,
    required this.clienteId,
    required this.estilistaId,
    required this.servicioIds,
    required this.inicio,
    this.notas = '',
    required this.estado,
    required this.creadoEn,
    required this.modificadoEn,
  });

  final String id;
  final String clienteId;
  final String estilistaId;
  final List<String> servicioIds;
  final DateTime inicio;
  final String notas;
  final EstadoTurno estado;
  final DateTime creadoEn;
  final DateTime modificadoEn;

  bool get tieneNotas => notas.trim().isNotEmpty;

  Turno copyWith({
    String? clienteId,
    String? estilistaId,
    List<String>? servicioIds,
    DateTime? inicio,
    String? notas,
    EstadoTurno? estado,
    DateTime? modificadoEn,
  }) {
    return Turno(
      id: id,
      clienteId: clienteId ?? this.clienteId,
      estilistaId: estilistaId ?? this.estilistaId,
      servicioIds: servicioIds ?? this.servicioIds,
      inicio: inicio ?? this.inicio,
      notas: notas ?? this.notas,
      estado: estado ?? this.estado,
      creadoEn: creadoEn,
      modificadoEn: modificadoEn ?? this.modificadoEn,
    );
  }
}
