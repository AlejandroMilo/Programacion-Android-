import 'package:flutter/material.dart';

import '../datos/almacen_turnos.dart';

/// Resumen del dia: turnos programados, completados e ingreso estimado.
class ResumenDelDia extends StatelessWidget {
  const ResumenDelDia({super.key, required this.resumen});

  final ResumenDia resumen;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: _Metrica(
            valor: '${resumen.programados}',
            etiqueta: 'Programados',
            colorValor: esquema.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _Metrica(
            valor: '${resumen.completados}',
            etiqueta: 'Completados',
            colorValor: esquema.tertiary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _Metrica(
            valor: resumen.ingresoTexto,
            etiqueta: 'Ingreso est.',
            colorValor: esquema.onSurface,
          ),
        ),
      ],
    );
  }
}

class _Metrica extends StatelessWidget {
  const _Metrica({
    required this.valor,
    required this.etiqueta,
    required this.colorValor,
  });

  final String valor;
  final String etiqueta;
  final Color colorValor;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: esquema.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              valor,
              style: textos.titleLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colorValor,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            etiqueta,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textos.labelSmall?.copyWith(
              fontWeight: FontWeight.w400,
              color: esquema.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
