import 'package:flutter/material.dart';

class SeccionTitulo extends StatelessWidget {
  const SeccionTitulo({
    super.key,
    required this.titulo,
    this.accion,
    this.icono,
  });

  final String titulo;
  final Widget? accion;
  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icono != null) ...[
          Icon(icono, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 7),
        ],
        Expanded(
          child: Text(
            titulo,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
        ),
        if (accion != null) accion!,
      ],
    );
  }
}
