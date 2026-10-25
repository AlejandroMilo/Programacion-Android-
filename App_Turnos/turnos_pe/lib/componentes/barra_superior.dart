import 'package:flutter/material.dart';

import '../aplicacion/alcance_turnos.dart';
import '../modelos/filtros.dart';
import '../tema/tema_app.dart';
import '../modelos_vista/modelo_vista_tema.dart';
import 'iconos.dart';

/// Logo de la app: cuadro de esquinas redondeadas con la tijera.
class LogoTurco extends StatelessWidget {
  const LogoTurco({super.key, this.tamano = 32});

  final double tamano;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(
        color: esquema.primary,
        borderRadius: BorderRadius.circular(tamano * 0.31),
      ),
      child: Icon(
        Icons.content_cut,
        size: tamano * 0.56,
        color: esquema.onPrimary,
      ),
    );
  }
}

/// Barra superior del diseno. Admite logo, boton de atras, titulo con
/// subtitulo y las acciones de la derecha.
class BarraSuperior extends StatelessWidget {
  const BarraSuperior({
    super.key,
    this.titulo,
    this.subtitulo,
    this.mostrarLogo = false,
    this.onAtras,
    this.acciones = const <Widget>[],
    this.tamanoTitulo = 20,
  });

  final String? titulo;
  final String? subtitulo;
  final bool mostrarLogo;
  final VoidCallback? onAtras;
  final List<Widget> acciones;
  final double tamanoTitulo;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final esquema = Theme.of(context).colorScheme;

    return SizedBox(
      height: AppTheme.altoBarraSuperior,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (mostrarLogo) ...[
              const LogoTurco(),
              const SizedBox(width: 12),
            ],
            if (onAtras != null) ...[
              InkWell(
                onTap: onAtras,
                borderRadius: BorderRadius.circular(24),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: Icon(
                    Icons.chevron_left,
                    size: 24,
                    color: esquema.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (titulo != null)
                    Text(
                      titulo!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textos.titleLarge?.copyWith(
                        fontSize: tamanoTitulo,
                        fontWeight: FontWeight.w600,
                        color: esquema.onSurface,
                      ),
                    ),
                  if (subtitulo != null)
                    Text(
                      subtitulo!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textos.bodySmall?.copyWith(
                        color: esquema.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            ...acciones,
          ],
        ),
      ),
    );
  }
}

/// Boton de la barra superior que cambia el tema claro, oscuro o sistema.
class BotonTema extends StatelessWidget {
  const BotonTema({super.key});

  @override
  Widget build(BuildContext context) {
    final ModeloVistaTema tema = AlcanceTurnos.temaDe(context);
    final esquema = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: tema,
      builder: (context, _) {
        return PopupMenuButton<ModoTema>(
          icon: const IconoSolLuna(size: 22),
          tooltip: 'Tema',
          position: PopupMenuPosition.under,
          color: esquema.surfaceContainerHigh,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: tema.cambiar,
          itemBuilder: (context) => ModoTema.values
              .map(
                (modo) => PopupMenuItem<ModoTema>(
                  value: modo,
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: _OpcionTema(
                    modo: modo,
                    seleccionado: modo == tema.modo,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _OpcionTema extends StatelessWidget {
  const _OpcionTema({required this.modo, required this.seleccionado});

  final ModoTema modo;
  final bool seleccionado;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(
          modo.icono,
          size: 18,
          color: seleccionado ? esquema.primary : esquema.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            modo.etiqueta,
            style: textos.bodyMedium?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: esquema.onSurface,
            ),
          ),
        ),
        if (seleccionado)
          Icon(Icons.check, size: 16, color: esquema.primary),
      ],
    );
  }
}
