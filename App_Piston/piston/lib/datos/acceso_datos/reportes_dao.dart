import 'package:drift/drift.dart';

import '../../modelos/mecanico.dart';
import '../../modelos/orden_servicio.dart';
import '../../modelos/resumen_taller.dart';
import '../base_datos.dart';

part 'reportes_dao.g.dart';

@DriftAccessor(
  tables: [
    OrdenesServicio,
    Clientes,
    Vehiculos,
    Mecanicos,
    Trabajos,
    Repuestos,
    RepuestosOrden,
    Pagos,
  ],
)
class ReportesDao extends DatabaseAccessor<BaseDatos>
    with _$ReportesDaoMixin {
  ReportesDao(super.db);

  Future<ResumenTaller> resumen() async {
    final ahora = DateTime.now();
    final ordenes = await attachedDatabase.ordenesDao.listar();
    final abiertas = ordenes.where((o) => o.estado.estaAbierta).toList();
    final listas = ordenes
        .where((o) => o.estado == EstadoOrden.listaParaEntregar)
        .length;
    final hoy = ordenes
        .where(
          (o) =>
              o.orden.fechaEntrada.year == ahora.year &&
              o.orden.fechaEntrada.month == ahora.month &&
              o.orden.fechaEntrada.day == ahora.day,
        )
        .length;
    final vehiculos = abiertas.map((o) => o.vehiculo.id).toSet().length;

    var facturadoMes = 0.0;
    var manoObraMes = 0.0;
    var repuestosMes = 0.0;
    for (final orden in ordenes) {
      if (orden.estado == EstadoOrden.cancelada) continue;
      final totales = await attachedDatabase.ordenesDao.totales(orden.id);
      if (orden.orden.fechaEntrada.month == ahora.month &&
          orden.orden.fechaEntrada.year == ahora.year) {
        facturadoMes += totales.total;
        manoObraMes += totales.manoObra;
        repuestosMes += totales.repuestos;
      }
    }

    final pagosMes = await attachedDatabase.pagosDao.pagosDelPeriodo(
      DateTime(ahora.year, ahora.month),
      ahora,
    );
    final cobradoMes = pagosMes.fold<double>(
      0,
      (total, pago) => total + pago.importe,
    );
    final deudasClientes = await deudas();
    final porCobrar = deudasClientes.fold<double>(
      0,
      (total, deuda) => total + deuda.saldo,
    );
    final bajos = await repuestosBajos();
    final clientes = await attachedDatabase.clientesDao.todos(
      soloActivos: true,
    );

    return ResumenTaller(
      ordenesAbiertas: abiertas.length,
      listasParaEntregar: listas,
      ordenesHoy: hoy,
      vehiculosEnTaller: vehiculos,
      ordenesDelMes: ordenes
          .where(
            (o) =>
                o.orden.fechaEntrada.month == ahora.month &&
                o.orden.fechaEntrada.year == ahora.year,
          )
          .length,
      facturadoMes: facturadoMes,
      cobradoMes: cobradoMes,
      porCobrar: porCobrar,
      repuestosBajos: bajos.length,
      clientesActivos: clientes.length,
      manoObraMes: manoObraMes,
      repuestosMes: repuestosMes,
    );
  }

  Future<FacturacionPeriodo> facturacion(
    DateTime desde,
    DateTime hasta,
  ) async {
    final ordenes = await attachedDatabase.ordenesDao.listar(
      desde: desde,
      hasta: hasta,
    );
    var mano = 0.0;
    var repuestos = 0.0;
    var abiertas = 0;
    var cerradas = 0;
    for (final orden in ordenes) {
      final totales = await attachedDatabase.ordenesDao.totales(orden.id);
      mano += totales.manoObra;
      repuestos += totales.repuestos;
      if (orden.estado.estaAbierta) {
        abiertas++;
      } else {
        cerradas++;
      }
    }
    final cobrado = await attachedDatabase.pagosDao.totalCobrado(desde, hasta);
    return FacturacionPeriodo(
      desde: desde,
      hasta: hasta,
      ordenes: ordenes.length,
      manoObra: mano,
      repuestos: repuestos,
      cobrado: cobrado,
      abiertas: abiertas,
      cerradas: cerradas,
    );
  }

  Future<List<DeudaCliente>> deudas() async {
    final ordenes = await attachedDatabase.ordenesDao.listar();
    final porCliente = <int, List<OrdenResumen>>{};
    for (final orden in ordenes) {
      if (orden.estado == EstadoOrden.cancelada) continue;
      final totales = await attachedDatabase.ordenesDao.totales(orden.id);
      if (totales.saldo <= 0.009) continue;
      porCliente.putIfAbsent(orden.cliente.id, () => []).add(orden);
    }
    final resultado = <DeudaCliente>[];
    for (final entrada in porCliente.entries) {
      var saldo = 0.0;
      for (final orden in entrada.value) {
        saldo += (await attachedDatabase.ordenesDao.totales(orden.id)).saldo;
      }
      resultado.add(
        DeudaCliente(
          cliente: entrada.value.first.cliente,
          ordenes: entrada.value.length,
          saldo: saldo,
        ),
      );
    }
    resultado.sort((a, b) => b.saldo.compareTo(a.saldo));
    return resultado;
  }

  /// Órdenes con saldo pendiente, incluidas las ya entregadas.
  Future<List<ResultadoOrden>> ordenesConSaldo() async {
    final ordenes = await attachedDatabase.ordenesDao.listar();
    final resultado = <ResultadoOrden>[];
    for (final orden in ordenes) {
      if (orden.estado == EstadoOrden.cancelada) continue;
      final totales = await attachedDatabase.ordenesDao.totales(orden.id);
      if (totales.saldo > 0.009) {
        resultado.add(ResultadoOrden(orden: orden, totales: totales));
      }
    }
    resultado.sort((a, b) => b.totales.saldo.compareTo(a.totales.saldo));
    return resultado;
  }

  Future<List<CargaMecanico>> cargaMecanicos() async {
    final mecanicos = await attachedDatabase.mecanicosDao.todos();
    final ordenes = await attachedDatabase.ordenesDao.listar();
    final listaTrabajos = await select(trabajos).get();
    final resultado = <CargaMecanico>[];

    for (final mecanico in mecanicos) {
      final asignadas = ordenes
          .where((o) => o.mecanico?.id == mecanico.id)
          .toList();
      final abiertas = asignadas.where((o) => o.estado.estaAbierta).length;
      final terminadas = asignadas
          .where((o) => o.estado == EstadoOrden.entregada)
          .length;
      final mano = listaTrabajos
          .where((t) => t.mecanicoId == mecanico.id)
          .fold<double>(0, (total, t) => total + t.precioManoObra);
      resultado.add(
        CargaMecanico(
          mecanico: mecanico,
          ordenesAbiertas: abiertas,
          ordenesTerminadas: terminadas,
          manoObra: mano,
        ),
      );
    }
    resultado.sort((a, b) => b.ordenesAbiertas.compareTo(a.ordenesAbiertas));
    return resultado;
  }

  Future<List<Repuesto>> repuestosBajos() async {
    return (select(repuestos)
          ..where((r) => r.activo.equals(true))
          ..where((r) => r.existencias.isSmallerOrEqual(r.umbral))
          ..orderBy([(r) => OrderingTerm.asc(r.existencias)]))
        .get();
  }

  Future<ResumenInventario> resumenInventario() async {
    final lista = await select(repuestos).get();
    final bajos = lista.where((r) => r.existencias <= r.umbral).length;
    final agotados = lista.where((r) => r.existencias <= 0).length;
    final valor = lista.fold<double>(
      0,
      (total, r) => total + (r.existencias * r.precioVenta),
    );
    return (total: lista.length, bajos: bajos, agotados: agotados, valor: valor);
  }

  /// Facturación agrupada por día dentro de un período.
  Future<List<({int dia, double monto})>> facturacionDiaria(
    DateTime desde,
    DateTime hasta,
  ) async {
    final ordenes = await attachedDatabase.ordenesDao.listar(
      desde: desde,
      hasta: hasta,
    );
    final porDia = <int, double>{};
    for (final orden in ordenes) {
      if (orden.estado == EstadoOrden.cancelada) continue;
      final totales = await attachedDatabase.ordenesDao.totales(orden.id);
      final claveDia = orden.orden.fechaEntrada.day;
      porDia.update(
        claveDia,
        (valor) => valor + totales.total,
        ifAbsent: () => totales.total,
      );
    }
    final dias = <int>{};
    var actual = desde;
    while (!actual.isAfter(hasta)) {
      dias.add(actual.day);
      actual = actual.add(const Duration(days: 1));
    }
    return dias
        .map((dia) => (dia: dia, monto: porDia[dia] ?? 0))
        .toList()
      ..sort((a, b) => a.dia.compareTo(b.dia));
  }

  Future<List<VehiculoAtendido>> vehiculosAtendidos(
    DateTime desde,
    DateTime hasta,
  ) async {
    final ordenes = await attachedDatabase.ordenesDao.listar(
      desde: desde,
      hasta: hasta,
    );
    final porVehiculo = <int, List<OrdenResumen>>{};
    for (final orden in ordenes) {
      porVehiculo.putIfAbsent(orden.vehiculo.id, () => []).add(orden);
    }
    final resultado = <VehiculoAtendido>[];
    for (final entrada in porVehiculo.entries) {
      final lista = entrada.value
        ..sort((a, b) => b.orden.fechaEntrada.compareTo(a.orden.fechaEntrada));
      resultado.add(
        VehiculoAtendido(
          vehiculo: lista.first.vehiculo,
          cliente: lista.first.cliente,
          visitas: lista.length,
          ultimaEntrada: lista.first.orden.fechaEntrada,
        ),
      );
    }
    resultado.sort((a, b) => b.visitas.compareTo(a.visitas));
    return resultado;
  }
}
