import 'package:flutter/material.dart';

import '../../datos/base_datos.dart';
import '../../modelos/repuesto.dart';
import '../../utilidades/colores.dart';

class IndicadorInventario extends StatelessWidget {
  const IndicadorInventario({super.key, required this.repuesto});

  final Repuesto repuesto;

  @override
  Widget build(BuildContext context) {
    final color = repuesto.sinStock
        ? Colores.rojo
        : repuesto.stockBajo
        ? Colores.amarillo
        : Colores.verde;
    final icono = repuesto.sinStock
        ? Icons.error_outline_rounded
        : repuesto.stockBajo
        ? Icons.warning_amber_rounded
        : Icons.inventory_2_outlined;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            '${repuesto.existencias} uds.',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
