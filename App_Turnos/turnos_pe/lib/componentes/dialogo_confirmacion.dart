import 'package:flutter/material.dart';

import '../tema/tema_app.dart';
import 'iconos.dart';

/// Dialogo de confirmacion con el estilo del diseno: icono de alerta a la
/// izquierda, titulo y mensaje alineados a la izquierda y acciones a la
/// derecha.
Future<bool> confirmarAccion(
  BuildContext context, {
  required String titulo,
  required String mensaje,
  String textoConfirmar = 'Confirmar',
  String textoCancelar = 'Volver',
  bool destructivo = true,
}) async {
  final esquema = Theme.of(context).colorScheme;
  final textos = Theme.of(context).textTheme;

  final confirmado = await showDialog<bool>(
    context: context,
    builder: (dialogoContext) => Dialog(
      backgroundColor: esquema.surfaceContainer,
      surfaceTintColor: esquema.surfaceContainer,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radioHoja),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconoTrianguloAlerta(size: 24, color: esquema.error),
            const SizedBox(height: 14),
            Text(
              titulo,
              style: textos.headlineMedium?.copyWith(
                color: esquema.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              mensaje,
              style: textos.bodyMedium?.copyWith(color: esquema.onSurfaceVariant),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: TextButton(
                    onPressed: () => Navigator.of(dialogoContext).pop(false),
                    style: _estiloBoton(esquema, esquema.primary),
                    child: Text(
                      textoCancelar,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Flexible(
                  child: TextButton(
                    onPressed: () => Navigator.of(dialogoContext).pop(true),
                    style: _estiloBoton(
                      esquema,
                      destructivo ? esquema.error : esquema.primary,
                    ),
                    child: Text(
                      textoConfirmar,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  return confirmado ?? false;
}

/// Estilo de los botones del dialogo: sin padding extra para que el texto
/// nunca se parta en dos lineas.
ButtonStyle _estiloBoton(ColorScheme esquema, Color color) {
  return TextButton.styleFrom(
    foregroundColor: color,
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    minimumSize: const Size(0, 40),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    textStyle: const TextStyle(
      fontFamily: AppTheme.fuente,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  );
}

/// Mensaje breve de confirmacion o aviso.
void mostrarAviso(
  BuildContext context,
  String mensaje, {
  SnackBarAction? accion,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(mensaje),
      action: accion,
      duration: const Duration(seconds: 4),
    ),
  );
}

/// Dialogo informativo de una sola accion (por ejemplo, una accion bloqueada).
Future<void> informar(
  BuildContext context, {
  required String titulo,
  required String mensaje,
  String textoBoton = 'Entendido',
  IconData icono = Icons.info_outline,
}) async {
  final esquema = Theme.of(context).colorScheme;
  final textos = Theme.of(context).textTheme;

  await showDialog<void>(
    context: context,
    builder: (dialogoContext) => Dialog(
      backgroundColor: esquema.surfaceContainer,
      surfaceTintColor: esquema.surfaceContainer,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radioHoja),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icono, size: 24, color: esquema.error),
            const SizedBox(height: 14),
            Text(
              titulo,
              style: textos.headlineMedium?.copyWith(
                color: esquema.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              mensaje,
              style: textos.bodyMedium?.copyWith(color: esquema.onSurfaceVariant),
            ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(dialogoContext).pop(),
                style: TextButton.styleFrom(foregroundColor: esquema.primary),
                child: Text(textoBoton),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

