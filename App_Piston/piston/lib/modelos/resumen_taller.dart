import '../datos/base_datos.dart';

/// Deuda pendiente agrupada por cliente.
class DeudaCliente {
  const DeudaCliente({
    required this.cliente,
    required this.ordenes,
    required this.saldo,
  });

  final Cliente cliente;
  final int ordenes;
  final double saldo;
}

/// Cifras principales del taller para el panel de inicio y los reportes.
class ResumenTaller {
  const ResumenTaller({
    required this.ordenesAbiertas,
    required this.listasParaEntregar,
    required this.ordenesHoy,
    required this.vehiculosEnTaller,
    required this.ordenesDelMes,
    required this.facturadoMes,
    required this.cobradoMes,
    required this.porCobrar,
    required this.repuestosBajos,
    required this.clientesActivos,
    required this.manoObraMes,
    required this.repuestosMes,
  });

  final int ordenesAbiertas;
  final int listasParaEntregar;
  final int ordenesHoy;
  final int vehiculosEnTaller;
  final int ordenesDelMes;
  final double facturadoMes;
  final double cobradoMes;
  final double porCobrar;
  final int repuestosBajos;
  final int clientesActivos;
  final double manoObraMes;
  final double repuestosMes;

  factory ResumenTaller.vacio() => const ResumenTaller(
    ordenesAbiertas: 0,
    listasParaEntregar: 0,
    ordenesHoy: 0,
    vehiculosEnTaller: 0,
    ordenesDelMes: 0,
    facturadoMes: 0,
    cobradoMes: 0,
    porCobrar: 0,
    repuestosBajos: 0,
    clientesActivos: 0,
    manoObraMes: 0,
    repuestosMes: 0,
  );
}

/// Facturación de un período: valor de las órdenes y dinero realmente cobrado.
class FacturacionPeriodo {
  const FacturacionPeriodo({
    required this.desde,
    required this.hasta,
    required this.ordenes,
    required this.manoObra,
    required this.repuestos,
    required this.cobrado,
    required this.abiertas,
    required this.cerradas,
  });

  final DateTime desde;
  final DateTime hasta;
  final int ordenes;
  final double manoObra;
  final double repuestos;
  final double cobrado;
  final int abiertas;
  final int cerradas;

  double get facturado => manoObra + repuestos;
  double get pendiente => (facturado - cobrado).clamp(0, double.infinity);
}

/// Vehículo atendido dentro de un período.
class VehiculoAtendido {
  const VehiculoAtendido({
    required this.vehiculo,
    required this.cliente,
    required this.visitas,
    required this.ultimaEntrada,
  });

  final Vehiculo vehiculo;
  final Cliente cliente;
  final int visitas;
  final DateTime ultimaEntrada;
}

/// Datos equivalentes a las tablas para exportar o depurar.
typedef ResumenInventario = ({int total, int bajos, int agotados, double valor});
