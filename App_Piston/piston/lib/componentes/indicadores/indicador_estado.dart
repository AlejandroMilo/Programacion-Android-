import 'package:flutter/material.dart';

import '../../modelos/estado_orden.dart';
import '../../utilidades/colores.dart';

Color colorEstado(EstadoOrden estado) => switch (estado) {
  EstadoOrden.recibida => Colores.azul,
  EstadoOrden.enDiagnostico => Colores.morado,
  EstadoOrden.enReparacion => Colores.naranja,
  EstadoOrden.listaParaEntregar => Colores.verde,
  EstadoOrden.entregada => Colores.verde,
  EstadoOrden.cancelada => Colores.rojo,
};

IconData iconoEstado(EstadoOrden estado) => switch (estado) {
  EstadoOrden.recibida => Icons.inbox_rounded,
  EstadoOrden.enDiagnostico => Icons.troubleshoot_rounded,
  EstadoOrden.enReparacion => Icons.build_rounded,
  EstadoOrden.listaParaEntregar => Icons.task_alt_rounded,
  EstadoOrden.entregada => Icons.check_circle_rounded,
  EstadoOrden.cancelada => Icons.cancel_rounded,
};

class IndicadorEstado extends StatelessWidget {
  const IndicadorEstado({super.key, required this.estado, this.compacto = false});

  final EstadoOrden estado;
  final bool compacto;

  @override
  Widget build(BuildContext context) {
    final color = colorEstado(estado);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compacto ? 8 : 10,
        vertical: compacto ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconoEstado(estado), size: compacto ? 12 : 14, color: color),
          const SizedBox(width: 5),
          Text(
            estado.etiqueta,
            style: TextStyle(
              color: color,
              fontSize: compacto ? 11 : 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
