import 'package:flutter/material.dart';

import '../tema/tema_app.dart';

/// Mensaje con ilustracion para listas vacias, filtros sin resultados o
/// errores de navegacion. Sigue la composicion del diseno: circulo
/// ilustrado, titulo, mensaje centrado y una accion opcional.
class EstadoVacio extends StatelessWidget {
  const EstadoVacio({
    super.key,
    required this.titulo,
    required this.mensaje,
    this.ilustracion,
    this.icono,
    this.colorIlustracion,
    this.accion,
    this.paddingSuperior = 28,
    this.paddingInferior = 24,
  });

  final String titulo;
  final String mensaje;

  /// Contenido del circulo (normalmente un icono dibujado).
  final Widget? ilustracion;

  /// Icono de Material usado cuando no se pasa una ilustracion propia.
  final IconData? icono;

  /// Fondo del circulo; por defecto primaryContainer.
  final Color? colorIlustracion;

  final Widget? accion;
  final double paddingSuperior;

  /// Espacio reservado abajo (por ejemplo, para el boton flotante).
  final double paddingInferior;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;
    final contenidoIlustracion =
        ilustracion ??
        (icono == null
            ? null
            : Icon(icono, size: 44, color: esquema.onPrimaryContainer));

    // En pantallas cortas (por ejemplo un movil de 360x758) el mensaje no
    // cabe junto a la ilustracion: se reduce el circulo y el resto se puede
    // desplazar, de modo que nunca hay desbordes.
    return LayoutBuilder(
      builder: (context, restricciones) {
        final compacto = restricciones.maxHeight < 280;
        final lado = compacto ? 84.0 : 120.0;

        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: restricciones.maxHeight),
            child: Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  32,
                  compacto ? 8 : paddingSuperior,
                  32,
                  paddingInferior,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (contenidoIlustracion != null)
                      Container(
                        width: lado,
                        height: lado,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:
                              colorIlustracion ?? esquema.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: contenidoIlustracion,
                        ),
                      ),
                    if (contenidoIlustracion != null)
                      SizedBox(height: compacto ? 10 : 14),
                    Text(
                      titulo,
                      textAlign: TextAlign.center,
                      style: textos.titleMedium?.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: esquema.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 260),
                      child: Text(
                        mensaje,
                        textAlign: TextAlign.center,
                        style: textos.bodyMedium?.copyWith(
                          fontSize: 13,
                          color: esquema.onSurfaceVariant,
                        ),
                      ),
                    ),
                    if (accion != null) ...[
                      const SizedBox(height: 16),
                      accion!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Boton principal del diseno: relleno primary, radio 22 y alto 44.
class BotonPrincipal extends StatelessWidget {
  const BotonPrincipal({
    super.key,
    required this.etiqueta,
    required this.onPressed,
    this.icono,
  });

  final String etiqueta;
  final VoidCallback onPressed;
  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Material(
      color: esquema.primary,
      borderRadius: BorderRadius.circular(AppTheme.radioBoton),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          height: 44,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icono != null) ...[
                  Icon(icono, size: 18, color: esquema.onPrimary),
                  const SizedBox(width: 8),
                ],
                Text(
                  etiqueta,
                  style: textos.labelLarge?.copyWith(color: esquema.onPrimary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
