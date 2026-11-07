import '../datos/base_datos.dart';

extension TrabajoExtension on Trabajo {
  String get precioTexto =>
      '\$${precioManoObra.toStringAsFixed(2)}';
}
