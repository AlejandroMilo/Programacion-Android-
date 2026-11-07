import 'package:flutter/material.dart';

/// Botón principal de El Pistón, con estado de carga incorporado.
class BotonPrincipal extends StatelessWidget {
  const BotonPrincipal({
    super.key,
    required this.texto,
    required this.onPressed,
    this.icono,
    this.cargando = false,
    this.expandido = true,
  });

  final String texto;
  final VoidCallback? onPressed;
  final IconData? icono;
  final bool cargando;
  final bool expandido;

  @override
  Widget build(BuildContext context) {
    final boton = FilledButton.icon(
      onPressed: cargando ? null : onPressed,
      icon: cargando
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(icono ?? Icons.check_rounded, size: 20),
      label: Text(cargando ? 'Procesando…' : texto),
    );
    return expandido
        ? SizedBox(width: double.infinity, child: boton)
        : boton;
  }
}
