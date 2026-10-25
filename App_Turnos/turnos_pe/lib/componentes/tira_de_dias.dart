import 'package:flutter/material.dart';

import '../modelos/reglas_turno.dart';

/// Tira con los siete dias de la semana de la fecha seleccionada. El dia
/// activo se marca con un pastilla de primary.
class TiraDeDias extends StatelessWidget {
  const TiraDeDias({
    super.key,
    required this.dias,
    required this.seleccionada,
    required this.onSeleccionar,
  });

  final List<DateTime> dias;
  final DateTime seleccionada;
  final ValueChanged<DateTime> onSeleccionar;

  @override
  Widget build(BuildContext context) {
    // Tira horizontal construida con ListView.builder, como exige el
    // enunciado. Los siete dias caben a lo ancho de una pantalla normal.
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dias.length,
        itemExtent: 51.1,
        padding: EdgeInsets.zero,
        itemBuilder: (context, indice) {
          final dia = dias[indice];
          return _Dia(
            dia: dia,
            activo: ReglasTurno.mismoDia(dia, seleccionada),
            cerrado: ReglasTurno.esDomingo(dia),
            onTap: () => onSeleccionar(dia),
          );
        },
      ),
    );
  }
}

class _Dia extends StatelessWidget {
  const _Dia({
    required this.dia,
    required this.activo,
    required this.cerrado,
    required this.onTap,
  });

  final DateTime dia;
  final bool activo;
  final bool cerrado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    final colorEtiqueta = activo
        ? esquema.onPrimary
        : esquema.onSurfaceVariant;
    final colorNumero = activo ? esquema.onPrimary : esquema.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: activo ? esquema.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Opacity(
          opacity: cerrado ? 0.4 : 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ReglasTurno.inicialDia(dia),
                style: textos.labelSmall?.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: colorEtiqueta,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${dia.day}',
                style: textos.titleMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorNumero,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
