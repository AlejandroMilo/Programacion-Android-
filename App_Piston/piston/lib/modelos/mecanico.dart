import '../datos/base_datos.dart';

/// Carga de trabajo y producción de un mecánico.
class CargaMecanico {
  const CargaMecanico({
    required this.mecanico,
    required this.ordenesAbiertas,
    required this.ordenesTerminadas,
    required this.manoObra,
  });

  final Mecanico mecanico;
  final int ordenesAbiertas;
  final int ordenesTerminadas;
  final double manoObra;

  int get totalOrdenes => ordenesAbiertas + ordenesTerminadas;
}
