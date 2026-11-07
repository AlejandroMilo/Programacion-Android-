import '../datos/base_datos.dart';

extension PagoExtension on Pago {
  String get metodoEtiqueta => switch (metodo) {
    'efectivo' => 'Efectivo',
    'tarjeta' => 'Tarjeta',
    'transferencia' => 'Transferencia',
    _ => metodo,
  };
}
