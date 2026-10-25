import 'package:flutter/material.dart';

import '../modelos/cliente.dart';
import '../modelos/genero.dart';

/// Fila de la lista de clientes: avatar con iniciales, nombre, telefono,
/// genero y cantidad de turnos.
class FilaCliente extends StatelessWidget {
  const FilaCliente({
    super.key,
    required this.cliente,
    required this.cantidadTurnos,
    this.onTap,
  });

  final Cliente cliente;
  final int cantidadTurnos;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    final esMujer = cliente.genero == Genero.mujer;
    final colorAvatar = esMujer
        ? esquema.primaryContainer
        : esquema.tertiaryContainer;
    final colorInicial = esMujer
        ? esquema.onPrimaryContainer
        : esquema.onTertiaryContainer;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: colorAvatar, shape: BoxShape.circle),
              child: Text(
                cliente.inicial,
                style: textos.titleMedium?.copyWith(
                  fontSize: 17.6,
                  fontWeight: FontWeight.w600,
                  color: colorInicial,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cliente.nombre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textos.titleSmall?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: esquema.onSurface,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    '${cliente.telefonoFormateado} · ${cliente.genero.etiqueta}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textos.bodySmall?.copyWith(
                      color: esquema.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$cantidadTurnos turno${cantidadTurnos == 1 ? '' : 's'}',
              style: textos.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: esquema.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

