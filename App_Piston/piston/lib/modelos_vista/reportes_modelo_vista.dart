import 'package:flutter/foundation.dart';

import '../aplicacion/sesion.dart';
import '../datos/base_datos.dart';
import '../modelos/mecanico.dart';
import '../modelos/resumen_taller.dart';

enum PeriodoReporte { mesActual, mesAnterior, ultimos30, personalizado }

/// Datos y filtros de los reportes (solo administración).
class ReportesModeloVista extends ChangeNotifier {
  ReportesModeloVista(this._db, this._sesion) {
    _aplicarPeriodo(PeriodoReporte.mesActual);
  }

  final BaseDatos _db;
  final Sesion _sesion;

  PeriodoReporte periodo = PeriodoReporte.mesActual;
  late DateTime desde;
  late DateTime hasta;
  FacturacionPeriodo? facturacion;
  List<CargaMecanico> cargaMecanicos = const [];
  List<DeudaCliente> deudas = const [];
  List<Repuesto> repuestosBajos = const [];
  List<VehiculoAtendido> vehiculos = const [];
  ResumenInventario inventario = (total: 0, bajos: 0, agotados: 0, valor: 0);
  List<({int dia, double monto})> facturacionDiaria = const [];
  bool cargando = true;
  String? error;

  String get etiquetaPeriodo => switch (periodo) {
    PeriodoReporte.mesActual => 'Mes actual',
    PeriodoReporte.mesAnterior => 'Mes anterior',
    PeriodoReporte.ultimos30 => 'Últimos 30 días',
    PeriodoReporte.personalizado => 'Personalizado',
  };

  void _aplicarPeriodo(PeriodoReporte nuevo, {DateTime? inicio, DateTime? fin}) {
    final ahora = DateTime.now();
    periodo = nuevo;
    switch (nuevo) {
      case PeriodoReporte.mesActual:
        desde = DateTime(ahora.year, ahora.month);
        hasta = DateTime(ahora.year, ahora.month + 1, 0);
      case PeriodoReporte.mesAnterior:
        desde = DateTime(ahora.year, ahora.month - 1);
        hasta = DateTime(ahora.year, ahora.month, 0);
      case PeriodoReporte.ultimos30:
        hasta = ahora;
        desde = ahora.subtract(const Duration(days: 30));
      case PeriodoReporte.personalizado:
        desde = inicio ?? DateTime(ahora.year, ahora.month);
        hasta = fin ?? ahora;
    }
  }

  Future<void> cambiarPeriodo(
    PeriodoReporte nuevo, {
    DateTime? inicio,
    DateTime? fin,
  }) async {
    _aplicarPeriodo(nuevo, inicio: inicio, fin: fin);
    await cargar();
  }

  Future<void> cargar() async {
    _sesion.exigir(Permiso.verReportes);
    cargando = true;
    error = null;
    notifyListeners();
    try {
      facturacion = await _db.reportesDao.facturacion(desde, hasta);
      cargaMecanicos = await _db.reportesDao.cargaMecanicos();
      deudas = await _db.reportesDao.deudas();
      repuestosBajos = await _db.reportesDao.repuestosBajos();
      vehiculos = await _db.reportesDao.vehiculosAtendidos(desde, hasta);
      inventario = await _db.reportesDao.resumenInventario();
      facturacionDiaria = await _db.reportesDao.facturacionDiaria(desde, hasta);
    } catch (e) {
      error = 'No se pudieron generar los reportes: $e';
    } finally {
      cargando = false;
      notifyListeners();
    }
  }
}
