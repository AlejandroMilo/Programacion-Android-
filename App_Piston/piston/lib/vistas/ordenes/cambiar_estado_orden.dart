import 'package:flutter/material.dart';

import '../../componentes/indicadores/indicador_estado.dart';
import '../../modelos/estado_orden.dart';

class CambiarEstadoOrdenSheet extends StatelessWidget {
  const CambiarEstadoOrdenSheet({
    super.key,
    required this.actual,
    required this.opciones,
  });

  final EstadoOrden actual;
  final List<EstadoOrden> opciones;

  static Future<EstadoOrden?> mostrar(
    BuildContext context, {
    required EstadoOrden actual,
    required List<EstadoOrden> opciones,
  }) {
    return showModalBottomSheet<EstadoOrden>(
      context: context,
      showDragHandle: true,
      builder: (_) =>
          CambiarEstadoOrdenSheet(actual: actual, opciones: opciones),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 2, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cambiar estado',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'Estado actual: ',
                  style: TextStyle(fontSize: 12, color: tema.hintColor),
                ),
                IndicadorEstado(estado: actual, compacto: true),
              ],
            ),
            const SizedBox(height: 14),
            if (opciones.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'La orden no tiene transiciones disponibles.',
                  style: TextStyle(fontSize: 13, color: tema.hintColor),
                ),
              )
            else
              for (final estado in opciones)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.of(context).pop(estado),
                    child: Ink(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: colorEstado(estado).withValues(alpha: 0.4),
                        ),
                        color: colorEstado(estado).withValues(alpha: 0.06),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            iconoEstado(estado),
                            color: colorEstado(estado),
                            size: 21,
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Text(
                              estado.etiqueta,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: colorEstado(estado),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
