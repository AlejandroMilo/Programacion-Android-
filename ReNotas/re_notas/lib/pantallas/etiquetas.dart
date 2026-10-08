import 'package:flutter/material.dart';

import '../diseno/sistema.dart';
import '../estado/estado_aplicacion.dart';
import '../modelos/etiqueta.dart';
import '../modelos/nota.dart';
import '../componentes/etiqueta_visual.dart';
import '../componentes/tarjeta_resultado_nota.dart';
import 'detalle_nota.dart';

class PantallaEtiquetas extends StatefulWidget {
  final EstadoAplicacion estado;

  /// Cuando se llega desde el Detalle de una nota, indica la etiqueta
  /// por la que hay que filtrar al abrir.
  final String? etiquetaInicialId;

  const PantallaEtiquetas({
    super.key,
    required this.estado,
    this.etiquetaInicialId,
  });

  @override
  State<PantallaEtiquetas> createState() => _PantallaEtiquetasState();
}

class _PantallaEtiquetasState extends State<PantallaEtiquetas> {
  final TextEditingController _controladorBusqueda =
      TextEditingController();

  /// Etiqueta cuyas notas se están mostrando (null = listado normal).
  String? _etiquetaAbiertaId;

  /// Etiquetas seleccionadas para agrupar notas.
  final Set<String> _seleccion = {};

  /// true  -> notas con TODAS las etiquetas seleccionadas.
  /// false -> notas con AL MENOS UNA de las etiquetas seleccionadas.
  bool _modoTodas = true;

  /// Indica si se está mostrando la vista de agrupación.
  bool _agrupando = false;

  @override
  void initState() {
    super.initState();
    _etiquetaAbiertaId = widget.etiquetaInicialId;
  }

  @override
  void dispose() {
    _controladorBusqueda.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------------
  // VISTA: LISTADO DE ETIQUETAS
  // ------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.estado,
      builder: (context, _) {
        final paleta = Paleta.of(context);
        final etiquetas = widget.estado.etiquetas;
        final etiquetasVisibles = _etiquetasFiltradas(etiquetas);

        if (_etiquetaAbiertaId != null) {
          return _construirNotasDeEtiqueta(context);
        }

        if (_agrupando) {
          return _construirAgrupacion(context);
        }

        return Scaffold(
          backgroundColor: paleta.fondo,
          appBar: AppBar(
            backgroundColor: paleta.fondo,
            foregroundColor: paleta.texto,
            title: const Text(
              'Mis etiquetas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                tooltip: 'Crear etiqueta',
                onPressed: () => _mostrarFormulario(context),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          body: etiquetas.isEmpty
              ? _construirVacio(context)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Búsqueda de etiquetas por nombre.
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                      child: TextField(
                        controller: _controladorBusqueda,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Buscar etiqueta...',
                          hintStyle: TextStyle(
                            color: paleta.pista,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: paleta.doradoTexto,
                          ),
                          suffixIcon:
                              _controladorBusqueda.text.isEmpty
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
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    if (_seleccion.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                        child: Row(
                          children: [
                            Text(
                              '${_seleccion.length} '
                              '${_seleccion.length == 1 ? 'etiqueta seleccionada' : 'etiquetas seleccionadas'}',
                              style: TextStyle(
                                color: paleta.textoSuave,
                                fontSize: 13,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                setState(() => _seleccion.clear());
                              },
                              child: const Text('Quitar'),
                            ),
                          ],
                        ),
                      ),

                    Expanded(
                      child: etiquetasVisibles.isEmpty
                          ? _construirSinResultados()
                          : ListView.builder(
                              key: const PageStorageKey('lista_etiquetas'),
                              padding:
                                  const EdgeInsets.fromLTRB(16, 6, 16, 96),
                              itemCount: etiquetasVisibles.length,
                              itemBuilder: (context, indice) {
                                return _construirTarjeta(
                                  context,
                                  etiquetasVisibles[indice],
                                );
                              },
                            ),
                    ),
                  ],
                ),
          // Acción para agrupar las etiquetas seleccionadas.
          bottomNavigationBar: _seleccion.isEmpty
              ? null
              : SafeArea(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                    decoration: BoxDecoration(
                      color: paleta.tarjeta,
                      border: Border(
                        top: BorderSide(
                          color: paleta.borde,
                        ),
                      ),
                    ),
                    child: FilledButton.icon(
                      onPressed: () {
                        setState(() => _agrupando = true);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: paleta.borgona,
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.filter_alt_outlined),
                      label: Text(
                        'Ver notas agrupadas (${_seleccion.length})',
                      ),
                    ),
                  ),
                ),
          floatingActionButton: FloatingActionButton.extended(
            heroTag: 'nueva_etiqueta',
            onPressed: () => _mostrarFormulario(context),
            backgroundColor: paleta.borgona,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text('Nueva etiqueta'),
          ),
        );
      },
    );
  }

  List<Etiqueta> _etiquetasFiltradas(List<Etiqueta> etiquetas) {
    final consulta =
        widget.estado.normalizarTexto(_controladorBusqueda.text);

    if (consulta.isEmpty) return etiquetas;

    return etiquetas
        .where(
          (etiqueta) => widget.estado
              .normalizarTexto(etiqueta.nombre)
              .contains(consulta),
        )
        .toList();
  }

  // ------------------------------------------------------------------
  // VISTA: NOTAS DE UNA ETIQUETA
  // ------------------------------------------------------------------

  Widget _construirNotasDeEtiqueta(BuildContext context) {
    final paleta = Paleta.of(context);
    final etiqueta =
        widget.estado.buscarEtiquetaPorId(_etiquetaAbiertaId!);

    // La etiqueta pudo eliminarce mientras se mostraba.
    if (etiqueta == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _etiquetaAbiertaId = null);
      });

      return Scaffold(
        backgroundColor: paleta.fondo,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final notas = widget.estado.notasDeEtiqueta(etiqueta.id);

    return Scaffold(
      backgroundColor: paleta.fondo,
      appBar: AppBar(
        backgroundColor: paleta.fondo,
        foregroundColor: paleta.texto,
        leading: IconButton(
          tooltip: 'Volver',
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() => _etiquetaAbiertaId = null);
          },
        ),
        title: Text(
          'Notas con "${etiqueta.nombre}"',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: notas.isEmpty
          ? _construirMensajeVacio(
              Icons.sell_outlined,
              'Ninguna nota usa esta etiqueta',
              'Asigna esta etiqueta desde el editor de una nota.',
            )
          : ListView.builder(
              key: const PageStorageKey('notas_de_etiqueta'),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: notas.length,
              itemBuilder: (context, indice) {
                return _tarjetaNota(notas[indice]);
              },
            ),
    );
  }

  // ------------------------------------------------------------------
  // VISTA: AGRUPACIÓN DE NOTAS POR VARIAS ETIQUETAS
  // ------------------------------------------------------------------

  Widget _construirAgrupacion(BuildContext context) {
    final paleta = Paleta.of(context);
    final notas = widget.estado.buscarNotas(
      etiquetasIds: _seleccion.toList(),
      modoTodas: _modoTodas,
    );

    final seleccionadas = widget.estado.etiquetas
        .where((etiqueta) => _seleccion.contains(etiqueta.id))
        .toList();

    return Scaffold(
      backgroundColor: paleta.fondo,
      appBar: AppBar(
        backgroundColor: paleta.fondo,
        foregroundColor: paleta.texto,
        leading: IconButton(
          tooltip: 'Volver',
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() => _agrupando = false);
          },
        ),
        title: const Text('Notas agrupadas'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Etiquetas que forman el grupo.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: seleccionadas
                  .map(
                    (etiqueta) => InputChip(
                      label: Text(etiqueta.nombre),
                      backgroundColor:
                          etiqueta.color.withValues(alpha: 0.18),
                      labelStyle: TextStyle(
                        color: etiqueta.color,
                        fontSize: 12,
                      ),
                      onDeleted: () {
                        setState(() {
                          _seleccion.remove(etiqueta.id);
                          if (_seleccion.isEmpty) _agrupando = false;
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
          ),

          // Elección: todas las etiquetas o al menos una.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                Icon(
                  Icons.filter_alt_outlined,
                  size: 17,
                  color: paleta.doradoTexto,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(
                        value: true,
                        label: Text('Todas'),
                      ),
                      ButtonSegment(
                        value: false,
                        label: Text('Al menos una'),
                      ),
                    ],
                    selected: {_modoTodas},
                    onSelectionChanged: (valores) {
                      setState(() => _modoTodas = valores.first);
                    },
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
            child: Text(
              '${notas.length} ${notas.length == 1 ? 'nota' : 'notas'}',
              style: TextStyle(
                color: paleta.texto,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: notas.isEmpty
                ? _construirMensajeVacio(
                    Icons.search_off,
                    'Ninguna nota coincide con el grupo',
                    _modoTodas
                        ? 'Ninguna nota tiene todas estas etiquetas a la vez.'
                        : 'Ninguna nota tiene ninguna de estas etiquetas.',
                  )
                : ListView.builder(
                    key: const PageStorageKey('notas_agrupadas'),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: notas.length,
                    itemBuilder: (context, indice) {
                      return _tarjetaNota(notas[indice]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------
  // ELEMENTOS COMPARTIDOS
  // ------------------------------------------------------------------

  Widget _tarjetaNota(Nota nota) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TarjetaResultadoNota(
        nota: nota,
        // RF5: cada nota indica de qué proyecto proviene.
        nombreProyecto: widget.estado.nombreProyectoDe(nota),
        etiquetas: widget.estado.etiquetasDeNota(nota),
        alPresionar: () {
          abrirPantalla(
            context,
            PantallaDetalleNota(
              estado: widget.estado,
              notaId: nota.id,
            ),
          );
        },
        alAlternarFavorita: () {
          widget.estado.alternarFavorita(nota.id);
        },
        alAlternarFija: () {
          widget.estado.alternarFija(nota.id);
        },
      ),
    );
  }

  Widget _construirVacio(BuildContext context) {
    return const EstadoVacio(
      icono: Icons.sell_outlined,
      titulo: 'Todavía no tienes etiquetas',
      mensaje: 'Crea etiquetas para organizar tus notas.',
    );
  }

  Widget _construirSinResultados() {
    return const EstadoVacio(
      icono: Icons.search_off,
      titulo: 'No se encontraron etiquetas',
      mensaje: 'Prueba con otro nombre.',
    );
  }

  Widget _construirMensajeVacio(
    IconData icono,
    String titulo,
    String texto,
  ) {
    return EstadoVacio(
      icono: icono,
      titulo: titulo,
      mensaje: texto,
    );
  }

  // ------------------------------------------------------------------
  // TARJETA DE ETIQUETA
  // ------------------------------------------------------------------

  Widget _construirTarjeta(BuildContext context, Etiqueta etiqueta) {
    final paleta = Paleta.of(context);
    final cantidadNotas =
        widget.estado.notasDeEtiqueta(etiqueta.id).length;
    final seleccionada = _seleccion.contains(etiqueta.id);

    return Card(
      color: paleta.tarjeta,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: seleccionada
              ? etiqueta.color.withValues(alpha: 0.9)
              : paleta.borde,
          width: seleccionada ? 1.5 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        // Tocar la etiqueta abre el listado de notas que la usan.
        onTap: () {
          setState(() => _etiquetaAbiertaId = etiqueta.id);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 8,
          ),
          child: Row(
            children: [
              // Selección para agrupar notas.
              Checkbox(
                value: seleccionada,
                activeColor: etiqueta.color,
                onChanged: (_) {
                  setState(() {
                    if (seleccionada) {
                      _seleccion.remove(etiqueta.id);
                    } else {
                      _seleccion.add(etiqueta.id);
                    }
                  });
                },
              ),

              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: etiqueta.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.sell_outlined,
                  color: etiqueta.color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EtiquetaVisual(etiqueta: etiqueta),
                    const SizedBox(height: 4),
                    Text(
                      '$cantidadNotas '
                      '${cantidadNotas == 1 ? 'nota' : 'notas'}',
                      style: TextStyle(
                        color: paleta.textoSuave,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: paleta.textoSuave,
                ),
                onSelected: (opcion) {
                  if (opcion == 'renombrar') {
                    _mostrarFormulario(
                      context,
                      etiqueta: etiqueta,
                    );
                  } else if (opcion == 'color') {
                    _mostrarColores(context, etiqueta);
                  } else if (opcion == 'eliminar') {
                    _confirmarEliminacion(context, etiqueta);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'renombrar',
                    child: Text('Cambiar nombre'),
                  ),
                  PopupMenuItem(
                    value: 'color',
                    child: Text('Cambiar color'),
                  ),
                  PopupMenuItem(
                    value: 'eliminar',
                    child: Text('Eliminar etiqueta'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // FORMULARIO DE CREACIÓN / CAMBIO DE NOMBRE
  // ------------------------------------------------------------------

  Future<void> _mostrarFormulario(
    BuildContext context, {
    Etiqueta? etiqueta,
  }) async {
    // Diálogo con estado propio: su controlador vive lo mismo que la
    // ruta y se destruye al desmontarse, nunca antes.
    final resultado = await showDialog<String>(
      context: context,
      builder: (contextoDialogo) =>
          _DialogoEtiqueta(etiqueta: etiqueta),
    );

    if (resultado == null || resultado.trim().isEmpty) return;
    if (!context.mounted) return;

    try {
      if (etiqueta == null) {
        final existente =
            widget.estado.buscarEtiquetaPorNombre(resultado);

        if (existente != null) {
          _mostrarMensaje(
            'Ya existe una etiqueta con ese nombre.',
            context,
          );
          return;
        }

        widget.estado.crearEtiqueta(resultado);
        _mostrarMensaje('Etiqueta creada.', context);
      } else {
        widget.estado.renombrarEtiqueta(
          id: etiqueta.id,
          nuevoNombre: resultado,
        );
        _mostrarMensaje('Etiqueta actualizada.', context);
      }
    } on ArgumentError catch (error) {
      _mostrarMensaje(error.message.toString(), context);
    }
  }

  // ------------------------------------------------------------------
  // COLOR
  // ------------------------------------------------------------------

  Future<void> _mostrarColores(
    BuildContext context,
    Etiqueta etiqueta,
  ) async {
    const colores = [
      Color(0xFF75162D),
      Color(0xFFF2D9A0),
      Color(0xFF63B3A2),
      Color(0xFF6FA8DC),
      Color(0xFFB39DDB),
      Color(0xFFE89A75),
      Color(0xFFE57373),
      Color(0xFFB9BAC5),
    ];
    final paleta = Paleta.of(context);

    final colorElegido = await showDialog<Color>(
      context: context,
      builder: (contextoDialogo) {
        return AlertDialog(
          backgroundColor: paleta.tarjeta,
          title: Text(
            'Elige un color',
            style: TextStyle(color: paleta.texto),
          ),
          content: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: colores.map((color) {
              return InkWell(
                onTap: () => Navigator.pop(contextoDialogo, color),
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color == etiqueta.color
                          ? Colors.white
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );

    if (colorElegido == null || !context.mounted) return;

    widget.estado.cambiarColorEtiqueta(
      id: etiqueta.id,
      color: colorElegido,
    );
  }

  // ------------------------------------------------------------------
  // ELIMINACIÓN
  // ------------------------------------------------------------------

  Future<void> _confirmarEliminacion(
    BuildContext context,
    Etiqueta etiqueta,
  ) async {
    final paleta = Paleta.of(context);
    final cantidad =
        widget.estado.notasDeEtiqueta(etiqueta.id).length;

    final afectadas = cantidad == 0
        ? 'No se usa en ninguna nota.'
        : cantidad == 1
            ? 'Se quitará de 1 nota. Las notas no se borran.'
            : 'Se quitará de $cantidad notas. '
                'Las notas no se borran.';

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (contextoDialogo) {
        return AlertDialog(
          backgroundColor: paleta.tarjeta,
          title: Text(
            'Eliminar etiqueta',
            style: TextStyle(color: paleta.texto)),
          content: Text(
            '¿Quieres eliminar la etiqueta "${etiqueta.nombre}"?\n\n'
            '$afectadas',
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

    if (confirmar != true || !context.mounted) return;

    widget.estado.eliminarEtiqueta(etiqueta.id);

    // Si la etiqueta eliminada era la que se estaba viendo, volver.
    if (_etiquetaAbiertaId == etiqueta.id) {
      setState(() => _etiquetaAbiertaId = null);
    }

    setState(() => _seleccion.remove(etiqueta.id));

    _mostrarMensajeConDeshacer(context);
  }

  void _mostrarMensajeConDeshacer(BuildContext context) {
    mostrarAviso(
      context,
      'Etiqueta eliminada.',
      accionTexto: 'Deshacer',
      alAccion: widget.estado.deshacerBorrado,
    );
  }

  void _mostrarMensaje(String mensaje, BuildContext context) {
    mostrarAviso(context, mensaje);
  }
}

class _DialogoEtiqueta extends StatefulWidget {
  final Etiqueta? etiqueta;

  const _DialogoEtiqueta({this.etiqueta});

  @override
  State<_DialogoEtiqueta> createState() => _DialogoEtiquetaState();
}

class _DialogoEtiquetaState extends State<_DialogoEtiqueta> {
  final _claveFormulario = GlobalKey<FormState>();

  late final TextEditingController _controlador =
      TextEditingController(text: widget.etiqueta?.nombre ?? '');

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void _cancelar() {
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }

  void _guardar() {
    if (!_claveFormulario.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    Navigator.pop(context, _controlador.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final paleta = Paleta.of(context);
    final esNueva = widget.etiqueta == null;

    return AlertDialog(
      backgroundColor: paleta.tarjeta,
      scrollable: true,
      title: Text(
        esNueva ? 'Nueva etiqueta' : 'Cambiar nombre',
        style: TextStyle(color: paleta.texto),
      ),
      content: Form(
        key: _claveFormulario,
        child: TextFormField(
          controller: _controlador,
          autofocus: true,
          maxLength: 40,
          style: TextStyle(color: paleta.texto),
          decoration: InputDecoration(
            labelText: 'Nombre de la etiqueta',
            labelStyle: TextStyle(color: paleta.textoSuave),
            prefixIcon: const Icon(Icons.sell_outlined),
          ),
          validator: (valor) {
            if (valor == null || valor.trim().isEmpty) {
              return 'Escribe un nombre.';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancelar,
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _guardar,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
