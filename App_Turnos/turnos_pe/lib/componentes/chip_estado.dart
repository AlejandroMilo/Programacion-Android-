import 'package:flutter/material.dart';

import '../modelos/estado_turno.dart';
import '../tema/tema_app.dart';

/// Colores del estado de un turno, siempre derivados del ColorScheme.
class ColoresEstado {
  const ColoresEstado._();

  static Color fondo(ColorScheme esquema, EstadoTurno estado) =>
      switch (estado) {
        EstadoTurno.programado => esquema.primaryContainer,
        EstadoTurno.completado => esquema.tertiaryContainer,
        EstadoTurno.cancelado => esquema.errorContainer,
      };

  static Color texto(ColorScheme esquema, EstadoTurno estado) =>
      switch (estado) {
        EstadoTurno.programado => esquema.onPrimaryContainer,
        EstadoTurno.completado => esquema.onTertiaryContainer,
        EstadoTurno.cancelado => esquema.onErrorContainer,
      };

  static Color acento(ColorScheme esquema, EstadoTurno estado) =>
      switch (estado) {
        EstadoTurno.programado => esquema.primary,
        EstadoTurno.completado => esquema.tertiary,
        EstadoTurno.cancelado => esquema.error,
      };
}

/// Etiqueta con el estado del turno y su color.
class ChipEstado extends StatelessWidget {
  const ChipEstado({super.key, required this.estado});

  final EstadoTurno estado;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: ColoresEstado.fondo(esquema, estado),
        borderRadius: BorderRadius.circular(AppTheme.radioPastilla),
      ),
      child: Text(
        estado.etiqueta,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: ColoresEstado.texto(esquema, estado),
        ),
      ),
    );
  }
}
