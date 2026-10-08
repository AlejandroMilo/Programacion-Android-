import 'package:flutter/material.dart';

import '../diseno/sistema.dart';
import '../modelos/nota.dart';
import '../modelos/etiqueta.dart';

/// Tarjeta reutilizable que representa una nota dentro de una lista de
/// resultados. Siempre muestra el proyecto de origen, un extracto de la
/// descripción, las etiquetas y la fecha de modificación.
///
/// La usan la pantalla de búsqueda global (RF6) y la pantalla de etiquetas
/// (RF5), de modo que ambas vistas comparten el mismo aspecto.
class TarjetaResultadoNota extends StatelessWidget {
  final Nota nota;
  final String nombreProyecto;
  final List<Etiqueta> etiquetas;
  final VoidCallback alPresionar;
  final VoidCallback? alEditar;
  final VoidCallback? alEliminar;
  final VoidCallback? alAlternarFavorita;
  final VoidCallback? alAlternarFija;
  final int maxLineasExtracto;

  const TarjetaResultadoNota({
    super.key,
    required this.nota,
    required this.nombreProyecto,
    required this.etiquetas,
    required this.alPresionar,
    this.alEditar,
    this.alEliminar,
    this.alAlternarFavorita,
    this.alAlternarFija,
    this.maxLineasExtracto = 3,
  });

  bool get _hayAcciones =>
      alEditar != null || alEliminar != null || alAlternarFija != null;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final paleta = Paleta.of(context);

    return TarjetaBase(
      margen: EdgeInsets.zero,
      alPresionar: alPresionar,
      hijo: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título + acciones opcionales.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AzulejoIcono(
                icono: nota.fija
                    ? Icons.push_pin
                    : Icons.description_outlined,
                lado: 40,
                tamanoIcono: 20,
                dorado: true,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (nota.fija) const MicroEtiqueta('Fijada'),
                    Text(
                      nota.titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: tema.textTheme.titleMedium?.copyWith(
                        color: paleta.texto,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              if (alAlternarFavorita != null)
                IconButton(
                  tooltip: nota.esFavorita
                      ? 'Quitar de favoritas'
                      : 'Marcar como favorita',
                  visualDensity: VisualDensity.compact,
                  onPressed: alAlternarFavorita,
                  icon: Icon(
                    nota.esFavorita
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: nota.esFavorita
                        ? paleta.estrella
                        : paleta.textoSuave,
                  ),
                ),
              if (_hayAcciones)
                PopupMenuButton<String>(
                  tooltip: 'Acciones de la nota',
                  color: paleta.tarjeta,
                  onSelected: (accion) {
                    if (accion == 'editar') {
                      alEditar?.call();
                    } else if (accion == 'eliminar') {
                      alEliminar?.call();
                    } else if (accion == 'fijar') {
                      alAlternarFija?.call();
                    }
                  },
                  itemBuilder: (context) => [
                    if (alAlternarFija != null)
                      PopupMenuItem(
                        value: 'fijar',
                        child: Text(
                          nota.fija
                              ? 'Desfijar'
                              : 'Fijar arriba',
                          style: TextStyle(color: paleta.texto),
                        ),
                      ),
                    if (alEditar != null)
                      PopupMenuItem(
                        value: 'editar',
                        child: Text(
                          'Editar',
                          style: TextStyle(color: paleta.texto),
                        ),
                      ),
                    if (alEliminar != null)
                      PopupMenuItem(
                        value: 'eliminar',
                        child: Text(
                          'Eliminar',
                          style: TextStyle(color: paleta.texto),
                        ),
                      ),
                  ],
                ),
            ],
          ),

          // Proyecto de origen: requisito del listado de resultados.
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: paleta.dorado.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.folder_outlined,
                  size: 14,
                  color: paleta.doradoTexto,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    nombreProyecto,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: paleta.doradoTexto,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Extracto de la descripción.
          if (nota.descripcion.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              nota.descripcion.trim(),
              maxLines: maxLineasExtracto,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: paleta.textoSuave,
                height: 1.5,
              ),
            ),
          ],

          // Etiquetas.
          if (etiquetas.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: etiquetas
                  .map(
                    (etiqueta) => Chip(
                      label: Text(etiqueta.nombre),
                      visualDensity: VisualDensity.compact,
                      side: BorderSide(
                        color: etiqueta.color.withValues(alpha: 0.6),
                      ),
                      labelStyle: TextStyle(
                        color: etiqueta.color,
                        fontSize: 12,
                      ),
                      backgroundColor:
                          etiqueta.color.withValues(alpha: 0.12),
                    ),
                  )
                  .toList(),
            ),
          ],

          // Fecha de última modificación.
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 13,
                color: paleta.textoSuave,
              ),
              const SizedBox(width: 5),
              Text(
                haceCuanto(nota.fechaModificacion),
                style: TextStyle(
                  color: paleta.textoSuave,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (nota.esFavorita) ...[
                const SizedBox(width: Esp.s),
                Icon(
                  Icons.star_rounded,
                  size: 14,
                  color: paleta.estrella,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
