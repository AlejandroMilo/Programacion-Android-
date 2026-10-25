import 'categoria_servicio.dart';
import 'publico.dart';

/// Servicio del catalogo (solo lectura desde la app).
class Servicio {
  const Servicio({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.duracionMinutos,
    required this.precio,
    required this.publico,
  });

  final String id;
  final String nombre;
  final CategoriaServicio categoria;
  final int duracionMinutos;
  final double precio;
  final Publico publico;

  String get duracionTexto => '$duracionMinutos min';

  String get precioTexto => '\$ ${precio.toStringAsFixed(0)}';
}
