import 'package:flutter/material.dart';

import '../../utilidades/colores.dart';

/// Tarjeta de métrica usada en el inicio y en los reportes.
class TarjetaResumen extends StatelessWidget {
  const TarjetaResumen({
    super.key,
    required this.titulo,
    required this.valor,
    this.subtitulo,
    this.icono = Icons.insights_rounded,
    this.color = Colores.naranja,
    this.onTap,
  });

  final String titulo;
  final String valor;
  final String? subtitulo;
  final IconData icono;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: tema.cardTheme.color,
            border: Border.all(
              color: tema.dividerTheme.color ?? Colores.grafitoClaro,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icono, color: color, size: 19),
                  ),
                  const Spacer(),
                  if (onTap != null)
                    Icon(
                      Icons.arrow_outward_rounded,
                      size: 15,
                      color: tema.hintColor,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                valor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                titulo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: tema.hintColor,
                ),
              ),
              if (subtitulo != null) ...[
                const SizedBox(height: 3),
                Text(
                  subtitulo!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: tema.hintColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
