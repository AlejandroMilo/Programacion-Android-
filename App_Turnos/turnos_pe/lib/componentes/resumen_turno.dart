import 'package:flutter/material.dart';

import '../tema/tema_app.dart';

/// Resumen siempre visible del formulario: duracion, hora de fin y precio.
class ResumenTurno extends StatelessWidget {
  const ResumenTurno({
    super.key,
    required this.duracion,
    required this.fin,
    required this.precio,
  });

  final String duracion;
  final String fin;
  final String precio;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: esquema.primaryContainer,
        borderRadius: BorderRadius.circular(AppTheme.radioResumen),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _dato(context, Icons.schedule, duracion, peso: FontWeight.w600),
          _dato(context, Icons.flag_outlined, 'Fin $fin'),
          _dato(context, Icons.attach_money, precio, peso: FontWeight.w700),
        ],
      ),
    );
  }

  Widget _dato(
    BuildContext context,
    IconData icono,
    String valor, {
    FontWeight peso = FontWeight.w600,
  }) {
    final esquema = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, size: 14, color: esquema.primary),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            valor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontSize: 13,
              color: esquema.onSurface,
              fontWeight: peso,
            ),
          ),
        ),
      ],
    );
  }
}
