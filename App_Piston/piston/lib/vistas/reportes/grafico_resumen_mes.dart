import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';

/// Gráfico de línea del resumen del mes: facturación diaria.
class GraficoResumenMes extends StatelessWidget {
  const GraficoResumenMes({super.key, required this.puntos});

  final List<({int dia, double monto})> puntos;

  @override
  Widget build(BuildContext context) {
    final oscuro = Theme.of(context).brightness == Brightness.dark;

    if (puntos.isEmpty) {
      return const _GraficoVacio();
    }

    final maxY = puntos.map((p) => p.monto).reduce((a, b) => a > b ? a : b);
    final maxConMargen = maxY == 0 ? 100 : maxY * 1.25;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Resumen del Mes',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colores.blanco,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxConMargen / 4,
                getDrawingHorizontalLine: (valor) {
                  return FlLine(
                    color: Colores.grafitoClaro.withValues(alpha: 0.3),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    interval: 1,
                    getTitlesWidget: (valor, meta) {
                      final dia = valor.toInt();
                      if (dia < 1 || dia > puntos.length) {
                        return const Text('');
                      }
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 8,
                        child: Text(
                          '$dia',
                          style: TextStyle(
                            fontSize: 10,
                            color: oscuro
                                ? Colores.blanco.withValues(alpha: 0.5)
                                : const Color(0xFF17181C).withValues(alpha: 0.5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: maxConMargen / 4,
                    getTitlesWidget: (valor, meta) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 4,
                        child: Text(
                          Formatos.dineroExacto(valor),
                          style: TextStyle(
                            fontSize: 10,
                            color: oscuro
                                ? Colores.blanco.withValues(alpha: 0.5)
                                : const Color(0xFF17181C).withValues(alpha: 0.5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: puntos
                      .asMap()
                      .entries
                      .map(
                        (e) => FlSpot(e.key.toDouble() + 1, e.value.monto),
                      )
                      .toList(),
                  isCurved: true,
                  curveSmoothness: 0.3,
                  color: Colores.naranja,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colores.naranja.withValues(alpha: 0.25),
                        Colores.naranja.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GraficoVacio extends StatelessWidget {
  const _GraficoVacio();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colores.grafitoClaro,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colores.naranja.withValues(alpha: 0.2)),
      ),
      child: const Center(
        child: Text(
          'Sin datos para graficar este período',
          style: TextStyle(
            fontSize: 13,
            color: Colores.gris,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
