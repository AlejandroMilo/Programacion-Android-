import '../datos/base_datos.dart';

extension VehiculoExtension on Vehiculo {
  String get descripcion => '$marca $modelo ($anio)';
}

/// Vehículo con su propietario resuelto.
class VehiculoConDueno {
  const VehiculoConDueno({required this.vehiculo, required this.cliente});

  final Vehiculo vehiculo;
  final Cliente cliente;
}
