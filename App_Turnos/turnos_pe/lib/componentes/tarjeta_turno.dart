import 'package:flutter/material.dart';

import '../modelos/estado_turno.dart';
import '../modelos/turno_vista.dart';
import 'chip_estado.dart';

/// Tarjeta de un turno en la lista de la Agenda: barra de color a la
/// izquierda, horarios, datos del turno y estado.
class TarjetaTurno extends StatelessWidget {
  const TarjetaTurno({
    super.key,
    required this.vista,
    this.onTap,
    this.onLongPress,
  });

  final TurnoVista vista;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;
    final estado = vista.turno.estado;

    return Opacity(
      opacity: estado == EstadoTurno.cancelado ? 0.75 : 1,
      child: Card(
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 12, 12),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: ColoresEstado.acento(esquema, estado),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 48,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vista.horaInicioTexto,
                          style: textos.titleMedium?.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: esquema.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          vista.horaFinTexto,
                          style: textos.bodySmall?.copyWith(
                            color: esquema.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vista.cliente.nombre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textos.titleSmall?.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: esquema.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          vista.serviciosTexto,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textos.bodySmall?.copyWith(
                            color: esquema.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 13,
                              color: esquema.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                vista.estilista.nombreCorto,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textos.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: esquema.onSurfaceVariant,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ChipEstado(estado: estado),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
