import '../datos/base_datos.dart';

/// Orden con los datos que necesita la interfaz ya resueltos.
class OrdenResumen {
  const OrdenResumen({
    required this.orden,
    required this.cliente,
    required this.vehiculo,
    this.mecanico,
  });

  final OrdenServicio orden;
  final Cliente cliente;
  final Vehiculo vehiculo;
  final Mecanico? mecanico;

  EstadoOrden get estado => orden.estado;
  int get id => orden.id;
  String get numero => orden.numero;
  String get matricula => vehiculo.matricula;
  String get vehiculoTexto => '${vehiculo.marca} ${vehiculo.modelo}';
  String get mecanicoTexto => mecanico?.nombre ?? 'Sin asignar';
}

/// Totales calculados de una orden.
class TotalesOrden {
  const TotalesOrden({
    required this.manoObra,
    required this.repuestos,
    required this.pagado,
  });

  final double manoObra;
  final double repuestos;
  final double pagado;

  double get total => manoObra + repuestos;
  double get saldo => (total - pagado).clamp(0, double.infinity);
  bool get estaPagada => saldo <= 0.009;
}

/// Resultados de una orden que se muestran en los reportes.
class ResultadoOrden {
  const ResultadoOrden({required this.orden, required this.totales});

  final OrdenResumen orden;
  final TotalesOrden totales;
}
