import 'package:flutter/material.dart';

import '../modelos/franja.dart';
import '../modelos/reglas_turno.dart';
import 'componentes.dart';

/// Cuadricula de franjas de 30 minutos: libre, no disponible o elegida.
class CuadriculaFranjas extends StatelessWidget {
  const CuadriculaFranjas({
    super.key,
    required this.franjas,
    required this.seleccionada,
    required this.onSeleccionar,
    this.error,
    this.mensajeSinDisponibles,
  });

  final List<Franja> franjas;
  final DateTime? seleccionada;
  final ValueChanged<DateTime?> onSeleccionar;
  final String? error;
  final String? mensajeSinDisponibles;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hora de inicio',
          style: textos.titleSmall?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: esquema.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _leyenda(
              context,
              'Libre',
              Colors.transparent,
              esquema.outline,
            ),
            const SizedBox(width: 14),
            _leyenda(
              context,
              'No disponible',
              esquema.surfaceContainerHigh,
              Colors.transparent,
            ),
            const SizedBox(width: 14),
            _leyenda(
              context,
              'Elegida',
              esquema.primary,
              Colors.transparent,
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (franjas.isEmpty)
          Text(
            'Elige los servicios, el estilista y la fecha para ver las franjas.',
            style: textos.bodySmall?.copyWith(color: esquema.onSurfaceVariant),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: franjas.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.1,
            ),
            itemBuilder: (context, indice) => _celda(context, franjas[indice]),
          ),
        if (mensajeSinDisponibles != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: esquema.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    mensajeSinDisponibles!,
                    style: textos.bodySmall?.copyWith(
                      color: esquema.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: MensajeError(error!),
          ),
      ],
    );
  }

  Widget _leyenda(
    BuildContext context,
    String texto,
    Color color,
    Color borde,
  ) {
    final esquema = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: borde),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          texto,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w400,
            color: esquema.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _celda(BuildContext context, Franja franja) {
    final esquema = Theme.of(context).colorScheme;
    final elegida = seleccionada != null && seleccionada == franja.hora;

    final Color fondo;
    final Color borde;
    final Color tinta;
    // Cuando falta la hora se muestra el error de validacion y las franjas
    // libres se enmarcan en rojo para dejar claro que hay que elegir una.
    final conError = error != null;
    if (elegida) {
      fondo = esquema.primary;
      borde = esquema.primary;
      tinta = esquema.onPrimary;
    } else if (franja.disponible) {
      fondo = Colors.transparent;
      borde = conError ? esquema.error : esquema.outline;
      tinta = esquema.onSurface;
    } else {
      fondo = esquema.surfaceContainerHigh;
      borde = Colors.transparent;
      tinta = esquema.onSurfaceVariant;
    }

    return Semantics(
      button: true,
      enabled: franja.disponible,
      label: franja.disponible
          ? 'Franja libre a las ${ReglasTurno.formatearHora(franja.hora)}'
          : 'Franja no disponible: ${franja.motivo ?? ''}',
      child: Opacity(
        opacity: franja.disponible || elegida ? 1 : 0.55,
        child: Material(
          color: fondo,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: borde),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: franja.disponible
                ? () => onSeleccionar(elegida ? null : franja.hora)
                : null,
            child: SizedBox(
              height: 40,
              child: Center(
                child: Text(
                  ReglasTurno.formatearHora(franja.hora),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: tinta,
                    fontWeight: elegida ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



