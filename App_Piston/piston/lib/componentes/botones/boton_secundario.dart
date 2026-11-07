import 'package:flutter/material.dart';

/// Acción secundaria (cancelar, volver, filtros).
class BotonSecundario extends StatelessWidget {
  const BotonSecundario({
    super.key,
    required this.texto,
    required this.onPressed,
    this.icono,
    this.expandido = true,
  });

  final String texto;
  final VoidCallback? onPressed;
  final IconData? icono;
  final bool expandido;

  @override
  Widget build(BuildContext context) {
    final boton = OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icono ?? Icons.arrow_back_rounded, size: 19),
      label: Text(texto),
    );
    return expandido
        ? SizedBox(width: double.infinity, child: boton)
        : boton;
  }
}
