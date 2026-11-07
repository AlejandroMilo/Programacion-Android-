import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../componentes/tarjetas/seccion_titulo.dart';
import '../../componentes/tarjetas/tarjeta_resumen.dart';
import '../../datos/base_datos.dart';
import '../../modelos/resumen_taller.dart';
import '../../modelos_vista/reportes_modelo_vista.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';
import 'grafico_resumen_mes.dart';
import 'reporte_deudas.dart';
import 'reporte_facturacion.dart';
import 'reporte_inventario.dart';
import 'reporte_mecanicos.dart';
import 'reporte_vehiculos.dart';

class PantallaReportes extends StatelessWidget {
  const PantallaReportes({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.read<BaseDatos>();
    final sesion = context.read<Sesion>();
    return ChangeNotifierProvider(
      create: (_) => ReportesModeloVista(db, sesion)..cargar(),
      child: const _CuerpoReportes(),
    );
  }
}

class _CuerpoReportes extends StatelessWidget {
  const _CuerpoReportes();

  @override
  Widget build(BuildContext context) {
    final modelo = context.watch<ReportesModeloVista>();
    final tema = Theme.of(context);
    final f = modelo.facturacion;

    return Scaffold(
      appBar: BarraSuperior(
        titulo: 'Reportes',
        subtitulo: '${modelo.etiquetaPeriodo} · ${Formatos.rango(modelo.desde, modelo.hasta)}',
      ),
      body: modelo.cargando && f == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              children: [
                const SeccionTitulo(titulo: 'Filtro de período', icono: Icons.date_range_rounded),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    _PeriodoChip(
                      etiqueta: 'Mes actual',
                      periodo: PeriodoReporte.mesActual,
                      seleccionado: modelo.periodo == PeriodoReporte.mesActual,
                      onTap: () => modelo.cambiarPeriodo(PeriodoReporte.mesActual),
                    ),
                    _PeriodoChip(
                      etiqueta: 'Mes anterior',
                      periodo: PeriodoReporte.mesAnterior,
                      seleccionado: modelo.periodo == PeriodoReporte.mesAnterior,
                      onTap: () => modelo.cambiarPeriodo(PeriodoReporte.mesAnterior),
                    ),
                    _PeriodoChip(
                      etiqueta: 'Últimos 30 días',
                      periodo: PeriodoReporte.ultimos30,
                      seleccionado: modelo.periodo == PeriodoReporte.ultimos30,
                      onTap: () => modelo.cambiarPeriodo(PeriodoReporte.ultimos30),
                    ),
                    _PeriodoChip(
                      etiqueta: 'Personalizado',
                      periodo: PeriodoReporte.personalizado,
                      seleccionado: modelo.periodo == PeriodoReporte.personalizado,
                      onTap: () => _elegirRango(context, modelo),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                if (f != null) ...[
                  const SeccionTitulo(titulo: 'Resumen del período', icono: Icons.insights_rounded),
                  const SizedBox(height: 8),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columnas = constraints.maxWidth >= 760 ? 4 : 2;
                      final ancho = (constraints.maxWidth - (columnas - 1) * 10) / columnas;
                      return Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          SizedBox(
                            width: ancho,
                            child: TarjetaResumen(
                              titulo: 'Órdenes del período',
                              valor: '${f.ordenes}',
                              subtitulo: '${f.abiertas} abiertas · ${f.cerradas} cerradas',
                              icono: Icons.assignment_rounded,
                              color: Colores.naranja,
                            ),
                          ),
                          SizedBox(
                            width: ancho,
                            child: TarjetaResumen(
                              titulo: 'Facturado',
                              valor: Formatos.dinero(f.facturado),
                              subtitulo: 'Mano de obra + repuestos',
                              icono: Icons.receipt_long_rounded,
                              color: Colores.morado,
                            ),
                          ),
                          SizedBox(
                            width: ancho,
                            child: TarjetaResumen(
                              titulo: 'Cobrado',
                              valor: Formatos.dinero(f.cobrado),
                              subtitulo: 'Pagos registrados',
                              icono: Icons.payments_rounded,
                              color: Colores.verde,
                            ),
                          ),
                          SizedBox(
                            width: ancho,
                            child: TarjetaResumen(
                              titulo: 'Pendiente',
                              valor: Formatos.dinero(f.pendiente),
                              subtitulo: 'Por cobrar a clientes',
                              icono: Icons.account_balance_wallet_rounded,
                              color: Colores.rojo,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 22),
                  GraficoResumenMes(
                    puntos: modelo.facturacionDiaria,
                  ),
                  const SizedBox(height: 22),
                  ReporteFacturacion(datos: f),
                  const SizedBox(height: 22),
                  ReporteMecanicos(datos: modelo.cargaMecanicos),
                  const SizedBox(height: 22),
                  ReporteDeudas(deudas: modelo.deudas),
                  const SizedBox(height: 22),
                  ReporteInventario(
                    inventario: modelo.inventario,
                    bajos: modelo.repuestosBajos,
                  ),
                  const SizedBox(height: 22),
                  ReporteVehiculos(datos: modelo.vehiculos),
                  if (modelo.error != null) ...[
                    const SizedBox(height: 12),
                    Text(modelo.error!, style: const TextStyle(color: Colores.rojo, fontSize: 12)),
                  ],
                ],
              ],
            ),
    );
  }

  Future<void> _elegirRango(BuildContext context, ReportesModeloVista modelo) async {
    final rango = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: modelo.desde, end: modelo.hasta),
      helpText: 'Selecciona el período del reporte',
      cancelText: 'Cancelar',
      confirmText: 'Aplicar',
      saveText: 'Aplicar',
    );
    if (rango != null) {
      await modelo.cambiarPeriodo(PeriodoReporte.personalizado, inicio: rango.start, fin: rango.end);
    }
  }
}

class _PeriodoChip extends StatelessWidget {
  const _PeriodoChip({
    required this.etiqueta,
    required this.periodo,
    required this.seleccionado,
    required this.onTap,
  });

  final String etiqueta;
  final PeriodoReporte periodo;
  final bool seleccionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: seleccionado,
      onSelected: (_) => onTap(),
      label: Text(etiqueta, style: const TextStyle(fontSize: 11.5)),
      selectedColor: Colores.naranja,
      showCheckmark: false,
      side: BorderSide(color: Colores.naranja.withValues(alpha: 0.4)),
    );
  }
}
