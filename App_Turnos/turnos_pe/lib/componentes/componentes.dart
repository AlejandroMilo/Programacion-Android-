import 'package:flutter/material.dart';

import '../tema/tema_app.dart';

/// Pastilla de filtro del diseno: radio 8, alto 32, con check cuando esta
/// seleccionada y borde tenue cuando no lo esta.
class Pastilla extends StatelessWidget {
  const Pastilla({
    super.key,
    required this.texto,
    required this.seleccionada,
    this.onTap,
  });

  final String texto;
  final bool seleccionada;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;
    final colorTexto = seleccionada
        ? esquema.onSecondaryContainer
        : esquema.onSurfaceVariant;

    return Material(
      color: seleccionada ? esquema.secondaryContainer : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radioPastilla),
        side: BorderSide(
          color: seleccionada ? Colors.transparent : esquema.outlineVariant,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: AppTheme.altoPastilla,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (seleccionada) ...[
                  Icon(Icons.check, size: 14, color: colorTexto),
                  const SizedBox(width: 6),
                ],
                Text(
                  texto,
                  style: textos.labelMedium?.copyWith(color: colorTexto),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Selector segmentado del diseno: se apoya en el [SegmentedButton] de
/// Material 3 (el enunciado lo pide explicitamente) con la paleta y las
/// medidas de la guia de estilo.
class Segmentado<T> extends StatelessWidget {
  const Segmentado({
    super.key,
    required this.opciones,
    required this.valor,
    required this.onChanged,
  });

  /// Pares de valor y etiqueta, en el orden en que se muestran.
  final List<(T, String)> opciones;

  /// Valor activo; si es null no hay ningun segmento seleccionado.
  final T? valor;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return SizedBox(
      height: AppTheme.altoSegmentado,
      child: LayoutBuilder(
        builder: (context, restricciones) {
          // Si las etiquetas no caben a lo ancho (moviles de 360 dp) se
          // reduce el texto y, si tampoco cabe, el selector se vuelve
          // desplazable en horizontal en vez de desbordarse.
          for (final (tamano, icono) in const [(12.0, 12.0), (11.0, 10.0)]) {
            final estilo = textos.labelMedium?.copyWith(fontSize: tamano);
            if (_anchoNecesario(context, opciones, estilo, icono) <=
                restricciones.maxWidth) {
              return _boton(context, esquema, estilo, icono, expandido: true);
            }
          }
          final estilo = textos.labelMedium?.copyWith(fontSize: 11);
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _boton(context, esquema, estilo, 10, expandido: false),
          );
        },
      ),
    );
  }

  /// Selector segmentado de Material 3 con la paleta del diseno.
  Widget _boton(
    BuildContext context,
    ColorScheme esquema,
    TextStyle? estilo,
    double tamanoIcono, {
    required bool expandido,
  }) {
    return SegmentedButton<T>(
      segments: [
        for (final (opcion, etiqueta) in opciones)
          ButtonSegment<T>(
            value: opcion,
            label: Text(
              etiqueta,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      selected: valor == null ? <T>{} : <T>{valor as T},
      emptySelectionAllowed: valor == null,
      showSelectedIcon: true,
      expandedInsets: expandido ? EdgeInsets.zero : null,
      onSelectionChanged: (seleccion) {
        if (seleccion.isNotEmpty) onChanged(seleccion.first);
      },
      style: ButtonStyle(
        shape: const WidgetStatePropertyAll(StadiumBorder()),
        side: WidgetStatePropertyAll(BorderSide(color: esquema.outline)),
        backgroundColor: WidgetStateProperty.resolveWith((estados) {
          if (estados.contains(WidgetState.selected)) {
            return esquema.secondaryContainer;
          }
          return Colors.transparent;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((estados) {
          if (estados.contains(WidgetState.selected)) {
            return esquema.onSecondaryContainer;
          }
          return esquema.onSurface;
        }),
        iconSize: WidgetStatePropertyAll(tamanoIcono),
        textStyle: WidgetStatePropertyAll(estilo),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 2),
        ),
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: const WidgetStatePropertyAll(Size(0, 0)),
      ),
    );
  }

  /// Ancho que necesitan los segmentos segun el texto de sus etiquetas.
  double _anchoNecesario(
    BuildContext context,
    List<(T, String)> opciones,
    TextStyle? estilo,
    double tamanoIcono,
  ) {
    var total = 0.0;
    for (final (_, etiqueta) in opciones) {
      final pintor = TextPainter(
        text: TextSpan(text: etiqueta, style: estilo),
        textDirection: Directionality.of(context),
      )..layout();
      // Padding interno de Material 3 + icono de seleccion + separacion.
      total += pintor.width + 28 + tamanoIcono + 8;
    }
    return total;
  }
}

/// Barra de navegacion inferior del diseno: se apoya en el [NavigationBar]
/// de Material 3 (el enunciado pide BottomNavigationBar o NavigationBar) con
/// la paleta y las medidas de la guia de estilo.
class BarraNavegacion extends StatelessWidget {
  const BarraNavegacion({
    super.key,
    required this.indice,
    required this.onSeleccionar,
  });

  final int indice;
  final ValueChanged<int> onSeleccionar;

  static const List<String> _etiquetas = [
    'Agenda',
    'Clientes',
    'Servicios',
    'Estilistas',
  ];

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return NavigationBar(
      selectedIndex: indice,
      onDestinationSelected: onSeleccionar,
      backgroundColor: esquema.surfaceContainer,
      surfaceTintColor: esquema.surfaceContainer,
      indicatorColor: esquema.secondaryContainer,
      elevation: 0,
      height: AppTheme.altoBarraNavegacion,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStateProperty.resolveWith((estados) {
        final seleccionado = estados.contains(WidgetState.selected);
        return textos.labelSmall?.copyWith(
          fontSize: 12,
          color: seleccionado ? esquema.onSurface : esquema.onSurfaceVariant,
          fontWeight: seleccionado ? FontWeight.w600 : FontWeight.w500,
        );
      }),
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.calendar_month_outlined),
          selectedIcon: Icon(Icons.calendar_month_outlined),
          label: _etiquetas[0],
        ),
        NavigationDestination(
          icon: Icon(Icons.people_outline),
          selectedIcon: Icon(Icons.people_outline),
          label: _etiquetas[1],
        ),
        NavigationDestination(
          icon: Icon(Icons.content_cut_outlined),
          selectedIcon: Icon(Icons.content_cut_outlined),
          label: _etiquetas[2],
        ),
        NavigationDestination(
          icon: Icon(Icons.assignment_ind_outlined),
          selectedIcon: Icon(Icons.assignment_ind_outlined),
          label: _etiquetas[3],
        ),
      ],
    );
  }
}

/// Boton flotante del diseno: pastilla de primaryContainer con sombra suave.
class BotonFlotante extends StatelessWidget {
  const BotonFlotante({
    super.key,
    required this.etiqueta,
    required this.onPressed,
    this.icono = Icons.add,
  });

  final String etiqueta;
  final VoidCallback onPressed;
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radioTarjetas),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: esquema.primaryContainer,
        borderRadius: BorderRadius.circular(AppTheme.radioTarjetas),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            height: AppTheme.altoBotonFlotante,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icono, size: 20, color: esquema.onPrimaryContainer),
                  const SizedBox(width: 10),
                  Text(
                    etiqueta,
                    style: textos.labelLarge?.copyWith(
                      color: esquema.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
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

/// Contenedor de campo con etiqueta, icono y borde, tal y como aparece en el
/// formulario del diseno.
class CajaCampo extends StatelessWidget {
  const CajaCampo({
    super.key,
    required this.etiqueta,
    required this.contenido,
    this.icono,
    this.onTap,
    this.error,
  });

  final String etiqueta;
  final Widget contenido;
  final IconData? icono;
  final VoidCallback? onTap;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EtiquetaCampo(etiqueta, error: error != null),
        const SizedBox(height: 4),
        Material(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radioCampos),
            side: BorderSide(
              color: error != null ? esquema.error : esquema.outline,
              width: error != null ? 2 : 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              height: AppTheme.altoCampo,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    if (icono != null) ...[
                      Icon(icono, size: 18, color: esquema.onSurfaceVariant),
                      const SizedBox(width: 10),
                    ],
                    Expanded(child: contenido),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 4),
          MensajeError(error!),
        ],
      ],
    );
  }
}

/// Etiqueta de campo: 12 medio, en rojo cuando el campo tiene error.
class EtiquetaCampo extends StatelessWidget {
  const EtiquetaCampo(this.texto, {super.key, this.error = false});

  final String texto;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Text(
      texto,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: error ? esquema.error : esquema.onSurfaceVariant,
      ),
    );
  }
}

/// Mensaje de error con el icono de alerta.
class MensajeError extends StatelessWidget {
  const MensajeError(this.texto, {super.key});

  final String texto;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.error_outline, size: 13, color: esquema.error),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            texto,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 12,
              color: esquema.error,
            ),
          ),
        ),
      ],
    );
  }
}

/// Aviso informativo con icono de informacion.
class Aviso extends StatelessWidget {
  const Aviso(this.texto, {super.key});

  final String texto;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline, size: 14, color: esquema.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            texto,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w400,
              color: esquema.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

/// Linea divisoria horizontal del diseno.
class LineaDivisoria extends StatelessWidget {
  const LineaDivisoria({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}




