import '../datos/base_datos.dart';

extension RepuestoExtension on Repuesto {
  bool get stockBajo => existencias <= umbral;
  bool get sinStock => existencias <= 0;
  double get valorInventario => existencias * precioVenta;

  String get estadoStock {
    if (sinStock) return 'Agotado';
    if (stockBajo) return 'Stock bajo';
    return 'Disponible';
  }
}
