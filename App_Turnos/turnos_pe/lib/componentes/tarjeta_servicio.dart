import 'package:flutter/material.dart';

import '../modelos/servicio.dart';
import '../tema/tema_app.dart';

/// Tarjeta del catalogo de servicios: ilustracion de la categoria, nombre,
/// duracion, precio y publico al que se dirige.
class TarjetaServicio extends StatelessWidget {
  const TarjetaServicio({super.key, required this.servicio, this.onTap});

  final Servicio servicio;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ilustracion de la categoria con el icono del diseno.
              Container(
                height: 84,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: esquema.primaryContainer,
                  borderRadius: BorderRadius.circular(AppTheme.radioCampos),
                ),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    esquema.primary,
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(
                    servicio.categoria.rutaIcono,
                    width: 36,
                    height: 36,
                    semanticLabel: 'Icono de ${servicio.categoria.etiqueta}',
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                servicio.nombre,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textos.titleSmall?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: esquema.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 12,
                    color: esquema.onSurfaceVariant,
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      servicio.duracionTexto,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textos.bodySmall?.copyWith(
                        color: esquema.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Text(
                    servicio.precioTexto,
                    style: textos.labelMedium?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: esquema.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: esquema.secondaryContainer,
                  borderRadius: BorderRadius.circular(AppTheme.radioPastilla),
                ),
                child: Text(
                  servicio.publico.etiqueta,
                  style: textos.labelSmall?.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: esquema.onSecondaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



