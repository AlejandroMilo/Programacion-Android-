import '../datos/base_datos.dart';

/// Línea de repuesto usada en una orden, con su subtotal.
class RepuestoUtilizado {
  const RepuestoUtilizado({required this.linea, required this.repuesto});

  final RepuestoOrden linea;
  final Repuesto repuesto;

  int get cantidad => linea.cantidad;
  double get precioUnitario => linea.precioUnitario;
  double get subtotal => linea.cantidad * linea.precioUnitario;
}
