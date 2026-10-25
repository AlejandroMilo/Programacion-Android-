/// Datos iniciales con los que puede abrirse el formulario de turno,
/// enviados desde la Agenda, Clientes o Servicios con `extra`.
class DatosInicialesTurno {
  const DatosInicialesTurno({this.clienteId, this.servicioId, this.fecha});

  final String? clienteId;
  final String? servicioId;
  final DateTime? fecha;
}
