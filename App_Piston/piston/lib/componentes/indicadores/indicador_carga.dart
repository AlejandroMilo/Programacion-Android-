import 'package:flutter/material.dart';

import '../../utilidades/colores.dart';

/// Pequeño indicador de carga de trabajo (órdenes abiertas, pendientes…).
class IndicadorCarga extends StatelessWidget {
  const IndicadorCarga({
    super.key,
    required this.etiqueta,
    required this.valor,
    this.color = Colores.naranja,
    this.icono = Icons.work_outline_rounded,
  });

  final String etiqueta;
  final int valor;
  final Color color;
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, size: 15, color: color),
        const SizedBox(width: 5),
        Text(
          '$valor $etiqueta',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
