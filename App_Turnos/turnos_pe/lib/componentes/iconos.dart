import 'package:flutter/material.dart';

/// Iconos del diseno (Lucide) que se usan en la app. Son imagenes del
/// proyecto (`assets/imagenes/`), no dibujos: se tintan con el color que
/// se les pase para que sirvan en modo claro y oscuro.
class _IconoImagen extends StatelessWidget {
  const _IconoImagen({
    required this.ruta,
    required this.size,
    this.color,
    this.semanticLabel,
  });

  final String ruta;
  final double size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        color ?? Theme.of(context).colorScheme.onSurfaceVariant,
        BlendMode.srcIn,
      ),
      child: Image.asset(
        ruta,
        width: size,
        height: size,
        semanticLabel: semanticLabel,
      ),
    );
  }
}

/// Triangulo con exclamacion: avisa de una accion destructiva o de un error.
class IconoTrianguloAlerta extends StatelessWidget {
  const IconoTrianguloAlerta({super.key, this.size = 24, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return _IconoImagen(
      ruta: 'assets/imagenes/icono_triangle_alert.png',
      size: size,
      color: color,
      semanticLabel: 'Aviso',
    );
  }
}

/// Calendario con una X: no hay turnos para el dia seleccionado.
class IconoCalendarioX extends StatelessWidget {
  const IconoCalendarioX({super.key, this.size = 56, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return _IconoImagen(
      ruta: 'assets/imagenes/icono_calendar_x.png',
      size: size,
      color: color,
      semanticLabel: 'Sin turnos',
    );
  }
}

/// Lupa con una X: el turno buscado no existe.
class IconoBuscadorX extends StatelessWidget {
  const IconoBuscadorX({super.key, this.size = 52, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return _IconoImagen(
      ruta: 'assets/imagenes/icono_search_x.png',
      size: size,
      color: color,
      semanticLabel: 'No encontrado',
    );
  }
}

/// Sol-luna del conmutador de tema: gris oscuro de dia y gris claro de noche.
class IconoSolLuna extends StatelessWidget {
  const IconoSolLuna({super.key, this.size = 22, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return _IconoImagen(
      ruta: 'assets/imagenes/icono_sol_luna.png',
      size: size,
      color: color,
      semanticLabel: 'Cambiar tema',
    );
  }
}
