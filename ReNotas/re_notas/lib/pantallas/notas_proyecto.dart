
import 'package:flutter/material.dart';

import '../diseno/sistema.dart';
import '../estado/estado_aplicacion.dart';
import '../modelos/proyecto.dart';
import '../modelos/nota.dart';
import '../componentes/tarjeta_nota.dart';
import 'editar_nota.dart';
import 'detalle_nota.dart';

class PantallaNotasProyecto extends StatefulWidget {
  final EstadoAplicacion estado;
  final Proyecto proyecto;

  const PantallaNotasProyecto({
    super.key,
    required this.estado,
    required this.proyecto,
  });

  @override
  State<PantallaNotasProyecto> createState() =>
      _PantallaNotasProyectoState();
}

class _PantallaNotasProyectoState extends State<PantallaNotasProyecto> {
  final TextEditingController _controladorBusqueda =
      TextEditingController();

  final Set<String> _etiquetasFiltro = {};
  bool _soloFavoritas = false;
  bool _soloFijadas = false;

  @override
  void dispose() {
    _controladorBusqueda.dispose();
    super.dispose();
  }

  bool get _hayFiltroActivo =>
      _controladorBusqueda.text.trim().isNotEmpty ||
      _etiquetasFiltro.isNotEmpty ||
      _soloFavoritas ||
      _soloFijadas;

  List<Nota> _notasFiltradas(List<Nota> notasDelProyecto) {
    final consulta = widget.estado.normalizarTexto(
      _controladorBusqueda.text,
    );

    return notasDelProyecto.where((nota) {
      if (_soloFavoritas && !nota.esFavorita) return false;
      if (_soloFijadas && !nota.fija) return false;

      final coincideTexto = consulta.isEmpty ||
          widget.estado
              .normalizarTexto('${nota.titulo} ${nota.descripcion}')
              .contains(consulta);

      final coincideEtiquetas = _etiquetasFiltro.every(
        (id) => nota.etiquetasIds.contains(id),
      );

      return coincideTexto && coincideEtiquetas;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.estado,
      builder: (context, _) {
        final paleta = Paleta.of(context);
        final proyectoActual =
            widget.estado.buscarProyectoPorId(widget.proyecto.id);

        if (proyectoActual == null) {
          return Scaffold(
            backgroundColor: paleta.fondo,
            body: const EstadoVacio(
              icono: Icons.folder_off_outlined,
              titulo: 'Este proyecto ya no existe',
              mensaje: 'Vuelve al listado de proyectos.',
            ),
          );
        }

        final notasDelProyecto =
            widget.estado.notasDeProyecto(proyectoActual.id);
        final resultados = _notasFiltradas(notasDelProyecto);
        final etiquetasDisponibles =
            widget.estado.etiquetasDeProyecto(proyectoActual.id);

        return Scaffold(
          backgroundColor: paleta.fondo,
          appBar: AppBar(
            backgroundColor: paleta.fondo,
            foregroundColor: paleta.texto,
            title: Text(
              proyectoActual.nombre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (proyectoActual.descripcion.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(
                    proyectoActual.descripcion,
                    style: TextStyle(
                      color: paleta.textoSuave,
                      height: 1.4,
                    ),
                  ),
                ),

              // Cantidad de notas del proyecto.
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.notes,
                      color: paleta.doradoTexto,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${notasDelProyecto.length} '
                      '${notasDelProyecto.length == 1 ? 'nota' : 'notas'}',
                      style: TextStyle(
                        color: paleta.texto,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Búsqueda por título o contenido dentro del proyecto.
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  controller: _controladorBusqueda,
                  onChanged: (_) => setState(() {}),
                  style: TextStyle(color: paleta.texto),
                  decoration: InputDecoration(
                    hintText: 'Buscar en este proyecto...',
                    hintStyle: TextStyle(
                      color: paleta.pista,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: paleta.doradoTexto,
                    ),
                    suffixIcon: _controladorBusqueda.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Limpiar búsqueda',
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _controladorBusqueda.clear();
                              setState(() {});
                            },
                          ),
                    filled: true,
                    fillColor: paleta.campo,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Filtros rápidos: favoritas y fijadas.
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('Favoritas'),
                      avatar: Icon(
                        _soloFavoritas
                            ? Icons.star
                            : Icons.star_border,
                        size: 18,
                        color: paleta.estrella,
                      ),
                      selected: _soloFavoritas,
                      onSelected: (valor) {
                        setState(() => _soloFavoritas = valor);
                      },
                    ),
                    FilterChip(
                      label: const Text('Fijadas'),
                      avatar: Icon(
                        Icons.push_pin,
                        size: 18,
                        color: paleta.doradoTexto,
                      ),
                      selected: _soloFijadas,
                      onSelected: (valor) {
                        setState(() => _soloFijadas = valor);
                      },
                    ),
                    if (_hayFiltroActivo)
                      ActionChip(
                        label: const Text('Limpiar'),
                        avatar: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          setState(() {
                            _controladorBusqueda.clear();
                            _etiquetasFiltro.clear();
                            _soloFavoritas = false;
                            _soloFijadas = false;
                          });
                        },
                      ),
                  ],
                ),
              ),

              // Filtro por etiquetas: solo las presentes en el proyecto.
              if (etiquetasDisponibles.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
                  child: Row(
                    children: [
                      Icon(
                        Icons.sell_outlined,
                        size: 17,
                        color: paleta.doradoTexto,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Filtrar por etiquetas',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                color: paleta.texto,
                              ),
                        ),
                      ),
                      if (_etiquetasFiltro.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            setState(() => _etiquetasFiltro.clear());
                          },
                          child: const Text('Limpiar'),
                        ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 46,
                  // ListView.separated con los divisores entre los filtros.
                  child: ListView.separated(
                    key: const PageStorageKey('filtros_etiquetas_proyecto'),
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: etiquetasDisponibles.length,
                    separatorBuilder: (context, indice) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, indice) {
                      final etiqueta = etiquetasDisponibles[indice];
                      final seleccionada =
                          _etiquetasFiltro.contains(etiqueta.id);

                      return FilterChip(
                        label: Text(etiqueta.nombre),
                        selected: seleccionada,
                        selectedColor:
                            etiqueta.color.withValues(alpha: 0.3),
                        checkmarkColor: paleta.texto,
                        onSelected: (valor) {
                          setState(() {
                            if (valor) {
                              _etiquetasFiltro.add(etiqueta.id);
                            } else {
                              _etiquetasFiltro.remove(etiqueta.id);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
              ],

              const SizedBox(height: 6),

              Expanded(
                child: notasDelProyecto.isEmpty
                    ? EstadoVacio(
                        icono: Icons.note_add_outlined,
                        titulo: 'Este proyecto aún no tiene notas',
                        mensaje:
                            'Crea una nota para guardar tus ideas.',
                        textoAccion: 'Crear nota',
                        alAccion: () => _abrirEditor(context),
                      )
                    : resultados.isEmpty
                        ? EstadoVacio(
                            icono: Icons.search_off,
                            titulo: 'No se encontraron notas',
                            mensaje: _hayFiltroActivo
                                ? 'Prueba otra palabra o quita algún filtro de etiquetas.'
                                : 'Cambia la palabra de búsqueda.',
                            textoAccion: _hayFiltroActivo
                                ? 'Quitar filtros'
                                : null,
                            alAccion: _hayFiltroActivo
                                ? () {
                                    setState(() {
                                      _controladorBusqueda.clear();
                                      _etiquetasFiltro.clear();
                                      _soloFavoritas = false;
                                      _soloFijadas = false;
                                    });
                                  }
                                : null,
                          )
                        : ListView.builder(
                            key:
                                const PageStorageKey('notas_proyecto'),
                            padding:
                                const EdgeInsets.fromLTRB(16, 0, 16, 90),
                            itemCount: resultados.length,
                            itemBuilder: (context, indice) {
                              final nota = resultados[indice];

                              return Dismissible(
                                key: ValueKey(nota.id),
                                direction:
                                    DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(
                                      right: Esp.xl),
                                  margin: const EdgeInsets.only(
                                      bottom: Esp.m),
                                  decoration: BoxDecoration(
                                    color: paleta.peligro,
                                    borderRadius: BorderRadius.circular(
                                        Radios.tarjeta),
                                  ),
                                  child: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.white,
                                  ),
                                ),
                                confirmDismiss: (_) =>
                                    _pedirEliminar(context, nota),
                                onDismissed: (_) =>
                                    _eliminarConDeshacer(
                                        context, nota),
                                child: TarjetaNota(
                                  nota: nota,
                                  etiquetas:
                                      widget.estado.etiquetasDeNota(nota),
                                  alPresionar: () {
                                    _abrirDetalle(context, nota);
                                  },
                                  alEditar: () {
                                    _abrirEditor(context, nota: nota);
                                  },
                                  alEliminar: () async {
                                    if (await _pedirEliminar(
                                        context, nota)) {
                                      if (!context.mounted) return;
                                      _eliminarConDeshacer(
                                          context, nota);
                                    }
                                  },
                                  alAlternarFavorita: () {
                                    widget.estado
                                        .alternarFavorita(nota.id);
                                  },
                                  alAlternarFija: () {
                                    widget.estado
                                        .alternarFija(nota.id);
                                  },
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            heroTag: 'nueva_nota',
            onPressed: () => _abrirEditor(context),
            backgroundColor: paleta.borgona,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text('Nueva nota'),
          ),
        );
      },
    );
  }

  void _abrirEditor(
    BuildContext context, {
    Nota? nota,
  }) {
    abrirPantalla(
      context,
      PantallaEditarNota(
        estado: widget.estado,
        proyecto: widget.proyecto,
        nota: nota,
      ),
    );
  }

  void _abrirDetalle(BuildContext context, Nota nota) {
    abrirPantalla(
      context,
      PantallaDetalleNota(
        estado: widget.estado,
        notaId: nota.id,
      ),
    );
  }

  Future<bool> _pedirEliminar(
    BuildContext context,
    Nota nota,
  ) async {
    final paleta = Paleta.of(context);
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (contextoDialogo) {
        return AlertDialog(
          backgroundColor: paleta.tarjeta,
          title: Text(
            'Eliminar nota',
            style: TextStyle(color: paleta.texto)),
          content: Text(
            '¿Quieres eliminar "${nota.titulo}"? '
            'Esta acción no se puede deshacer.',
            style: TextStyle(color: paleta.textoSuave),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(contextoDialogo, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: paleta.borgona,
              ),
              onPressed: () => Navigator.pop(contextoDialogo, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    return confirmar == true;
  }

  void _eliminarConDeshacer(BuildContext context, Nota nota) {
    widget.estado.eliminarNota(nota.id);
    if (!context.mounted) return;
    mostrarAviso(
      context,
      'Nota eliminada.',
      accionTexto: 'Deshacer',
      alAccion: widget.estado.deshacerBorrado,
    );
  }
}
