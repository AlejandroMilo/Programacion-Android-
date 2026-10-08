import 'package:flutter/material.dart';
import '../diseno/sistema.dart';
import '../estado/estado_aplicacion.dart';
import '../modelos/proyecto.dart';
import '../modelos/nota.dart';
import '../modelos/etiqueta.dart';
import '../componentes/etiqueta_visual.dart';

/// Pantalla RF3: editor de una nota (tanto para crear como para editar).
///
/// Incluye el requisito principal de la asignatura: autocompletado de
/// etiquetas con el widget [Autocomplete] del SDK de Flutter.
class PantallaEditarNota extends StatefulWidget {
  final EstadoAplicacion estado;
  final Proyecto proyecto;
  final Nota? nota;

  const PantallaEditarNota({
    super.key,
    required this.estado,
    required this.proyecto,
    this.nota,
  });

  @override
  State<PantallaEditarNota> createState() => _PantallaEditarNotaState();
}

class _PantallaEditarNotaState extends State<PantallaEditarNota> {
  /// Identificador ficticio que marca la opción "crear etiqueta nueva"
  /// dentro de las sugerencias del autocompletado.
  static const String _idEtiquetaNueva = '__etiqueta_nueva__';

  final _claveFormulario = GlobalKey<FormState>();

  final _controladorTitulo = TextEditingController();
  final _controladorDescripcion = TextEditingController();

  /// Controlador que entrega el widget [Autocomplete] al construir el
  /// campo de texto. Se guarda para poder limpiarlo al elegir una opción.
  TextEditingController? _controladorEtiquetas;

  final List<String> _etiquetasSeleccionadas = [];

  // Valores con los que se abriO la pantalla, para detectar cambios
  // sin guardar.
  String _tituloInicial = '';
  String _descripcionInicial = '';
  List<String> _etiquetasIniciales = const [];

  bool get _estaEditando => widget.nota != null;

  /// Indica si la nota tiene cambios que aún no se han guardado.
  bool get _hayCambios {
    if (_controladorTitulo.text != _tituloInicial) return true;
    if (_controladorDescripcion.text != _descripcionInicial) return true;

    if (_etiquetasSeleccionadas.length != _etiquetasIniciales.length) {
      return true;
    }

    for (final id in _etiquetasIniciales) {
      if (!_etiquetasSeleccionadas.contains(id)) return true;
    }

    return false;
  }

  @override
  void initState() {
    super.initState();

    final nota = widget.nota;

    if (nota != null) {
      _controladorTitulo.text = nota.titulo;
      _controladorDescripcion.text = nota.descripcion;
      _etiquetasSeleccionadas.addAll(nota.etiquetasIds);
    }

    _tituloInicial = _controladorTitulo.text;
    _descripcionInicial = _controladorDescripcion.text;
    _etiquetasIniciales = List<String>.from(_etiquetasSeleccionadas);

    // Se añaden al final para que escribir actualice la detección de
    // cambios sin guardar  y el botón Cancelar.
    _controladorTitulo.addListener(_alCambiarTexto);
    _controladorDescripcion.addListener(_alCambiarTexto);
  }

  void _alCambiarTexto() {
    setState(() {});
  }

  @override
  void dispose() {
    _controladorTitulo.removeListener(_alCambiarTexto);
    _controladorDescripcion.removeListener(_alCambiarTexto);
    _controladorTitulo.dispose();
    _controladorDescripcion.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------------
  // SALIDA CON CAMBIOS SIN GUARDAR
  // ------------------------------------------------------------------

  /// Pide confirmación antes de salir. Devuelve `true` si se debe salir.
  Future<bool> _confirmarSalida() async {
    if (!_hayCambios) return true;

    final salir = await showDialog<bool>(
      context: context,
      builder: (contextoDialogo) {
        return AlertDialog(
          backgroundColor: Paleta.of(context).tarjeta,
          title: Text(
            'Cambios sin guardar',
            style: TextStyle(color: Paleta.of(context).texto),
          ),
          content: Text(
            'Tienes cambios sin guardar en esta nota. '
            'Si sales ahora se perderán.',
            style: TextStyle(color: Paleta.of(context).textoSuave),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(contextoDialogo, false),
              child: const Text('Seguir editando'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Paleta.of(context).borgona,
              ),
              onPressed: () => Navigator.pop(contextoDialogo, true),
              child: const Text('Salir sin guardar'),
            ),
          ],
        );
      },
    );

    return salir ?? false;
  }

  /// Botón "Cancelar": avisa si hay cambios pendientes.
  Future<void> _intentarSalir() async {
    final salir = await _confirmarSalida();
    if (!salir || !mounted) return;

    Navigator.pop(context);
  }

  // ------------------------------------------------------------------
  // CONSTRUCCIÓN
  // ------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Impide salir con el botón Atrás o el gesto del sistema cuando
    // quedan cambios sin guardar.
    return PopScope(
      canPop: !_hayCambios,
      onPopInvokedWithResult: (salio, resultado) async {
        if (salio) return;

        final salir = await _confirmarSalida();
        if (!salir || !mounted) return;

        // Navigator.pop es programático: PopScope no lo bloquea.
        if (context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Paleta.of(context).fondo,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Paleta.of(context).fondo,
          foregroundColor: Paleta.of(context).texto,
          title: Text(
            _estaEditando ? 'Editar nota' : 'Nueva nota',
          ),
        ),
        body: AnimatedBuilder(
          animation: widget.estado,
          builder: (context, _) {
            final paleta = Paleta.of(context);
            return Form(
              key: _claveFormulario,
              // SingleChildScrollView: el texto largo del editor se
              // desplaza sin provocar overflow con el teclado abierto.
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  Text(
                    'Proyecto: ${widget.proyecto.nombre}',
                    style: TextStyle(
                      color: paleta.doradoTexto,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 22),

                  Text(
                    'Título',
                    style: TextStyle(
                      color: paleta.texto,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _controladorTitulo,
                    autofocus: !_estaEditando,
                    maxLength: 120,
                    style: TextStyle(color: paleta.texto),
                    decoration: _decoracion(
                      context,
                      'Escribe el título de la nota',
                      Icons.title,
                    ),
                    validator: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return 'El título es obligatorio.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  Text(
                    'Descripción',
                    style: TextStyle(
                      color: paleta.texto,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Texto largo: scroll interno propio y sin overflow.
                  TextFormField(
                    controller: _controladorDescripcion,
                    minLines: 6,
                    maxLines: 10,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(
                      color: paleta.texto,
                      height: 1.5,
                    ),
                    decoration: _decoracion(
                      context,
                      'Escribe aquí tus ideas, apuntes o información...',
                      Icons.notes,
                    ).copyWith(alignLabelWithHint: true),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${_controladorDescripcion.text.length} caracteres',
                      style: TextStyle(
                        color: paleta.textoSuave,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Etiquetas',
                    style: TextStyle(
                      color: paleta.texto,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Escribe para buscar una etiqueta o crear una nueva. '
                    'También puedes confirmar con Enter o con una coma.',
                    style: TextStyle(
                      color: paleta.textoSuave,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _construirAutocompletado(),

                  const SizedBox(height: 16),

                  if (_etiquetasSeleccionadas.isNotEmpty) ...[
                    Text(
                      'Etiquetas añadidas',
                      style: TextStyle(
                        color: paleta.textoSuave,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Wrap(
                      children: _etiquetasSeleccionadas.map((id) {
                        final etiqueta =
                            widget.estado.buscarEtiquetaPorId(id);

                        if (etiqueta == null) {
                          return const SizedBox.shrink();
                        }

                        return GestureDetector(
                          onTap: () => _quitarEtiqueta(id),
                          child: EtiquetaVisual(
                            etiqueta: etiqueta,
                            mostrarCerrar: true,
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  const SizedBox(height: 28),

                  FilledButton.icon(
                    onPressed: _guardarNota,
                    style: FilledButton.styleFrom(
                      backgroundColor: paleta.borgona,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Icon(Icons.save_outlined),
                    label: Text(
                      _estaEditando ? 'Guardar cambios' : 'Guardar nota',
                    ),
                  ),

                  const SizedBox(height: 12),

                  OutlinedButton(
                    onPressed: _intentarSalir,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: paleta.doradoTexto,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // AUTOCOMPLETADO DE ETIQUETAS (requisito principal de la pantalla)
  // ------------------------------------------------------------------

  Widget _construirAutocompletado() {
    return Autocomplete<Etiqueta>(
      displayStringForOption: (etiqueta) => etiqueta.nombre,

      // Muestra las etiquetas existentes cuyo nombre contenga lo escrito.
      // La comparación ignora mayúsculas y acentos, y abarca etiquetas de
      // cualquier nota de cualquier proyecto. No sugiere las que la nota ya
      // tiene asignadas.
      optionsBuilder: (valor) {
        final texto = valor.text.trim();
        final consulta = widget.estado.normalizarTexto(texto);

        if (consulta.isEmpty) {
          return const Iterable<Etiqueta>.empty();
        }

        final sugerencias = widget.estado.etiquetas
            .where(
              (etiqueta) {
                final coincide = widget.estado
                    .normalizarTexto(etiqueta.nombre)
                    .contains(consulta);

                return coincide &&
                    !_etiquetasSeleccionadas.contains(etiqueta.id);
              },
            )
            .toList();

        // Si el texto no coincide exactamente con ninguna etiqueta
        // existente, se ofrece crearla con ese nombre.
        final existeExacta =
            widget.estado.buscarEtiquetaPorNombre(texto) != null;

        return [
          ...sugerencias,
          if (!existeExacta)
            Etiqueta(id: _idEtiquetaNueva, nombre: texto),
        ];
      },

      onSelected: (etiqueta) {
        if (etiqueta.id == _idEtiquetaNueva) {
          _crearOAgregarEtiqueta(
            etiqueta.nombre,
            desenfocar: false,
          );
          return;
        }

        _agregarEtiqueta(etiqueta.id);
        _controladorEtiquetas?.clear();
        setState(() {});
      },

      fieldViewBuilder: (
        context,
        controlador,
        foco,
        alEnviar,
      ) {
        _controladorEtiquetas = controlador;

        return TextField(
          controller: controlador,
          focusNode: foco,
          style: TextStyle(color: Paleta.of(context).texto),
          onChanged: (texto) {
            // Escribir una coma confirma la etiqueta.
            if (texto.contains(',')) {
              _crearOAgregarEtiqueta(
                texto.split(',').first,
                controlador: controlador,
                desenfocar: false,
              );
              return;
            }

            setState(() {});
          },
          decoration: _decoracion(
            context,
            'Buscar o escribir etiqueta',
            Icons.sell_outlined,
          ).copyWith(
            suffixIcon: IconButton(
              tooltip: 'Añadir etiqueta',
              icon: const Icon(Icons.add),
              onPressed: () => _crearOAgregarEtiqueta(
                controlador.text,
                controlador: controlador,
              ),
            ),
          ),
          // La tecla de acción (Enter) crea o asigna la etiqueta escrita.
          onSubmitted: (texto) {
            _crearOAgregarEtiqueta(
              texto,
              controlador: controlador,
            );
          },
        );
      },

      optionsViewBuilder: (
        context,
        alSeleccionar,
        opciones,
      ) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: Paleta.of(context).tarjeta,
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 220,
                maxWidth: 320,
              ),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 6),
                shrinkWrap: true,
                itemCount: opciones.length,
                itemBuilder: (context, indice) {
                  final etiqueta = opciones.elementAt(indice);
                  final paletaOpcion = Paleta.of(context);

                  // Opción para crear la etiqueta en el mismo paso.
                  if (etiqueta.id == _idEtiquetaNueva) {
                    return ListTile(
                      leading: Icon(
                        Icons.add_circle_outline,
                        color: paletaOpcion.doradoTexto,
                      ),
                      title: Text(
                        'Crear "${etiqueta.nombre}"',
                        style: TextStyle(
                          color: paletaOpcion.texto,
                        ),
                      ),
                      subtitle: Text(
                        'Crea la etiqueta y la asigna a la nota',
                        style: TextStyle(
                          color: paletaOpcion.textoSuave,
                          fontSize: 12,
                        ),
                      ),
                      onTap: () => alSeleccionar(etiqueta),
                    );
                  }

                  return ListTile(
                    leading: Icon(
                      Icons.circle,
                      size: 12,
                      color: etiqueta.color,
                    ),
                    title: Text(
                      etiqueta.nombre,
                      style: TextStyle(
                        color: paletaOpcion.texto,
                      ),
                    ),
                    onTap: () => alSeleccionar(etiqueta),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------------
  // ETIQUETAS
  // ------------------------------------------------------------------

  void _agregarEtiqueta(String id) {
    if (_etiquetasSeleccionadas.contains(id)) return;

    setState(() {
      _etiquetasSeleccionadas.add(id);
    });
  }

  void _quitarEtiqueta(String id) {
    setState(() {
      _etiquetasSeleccionadas.remove(id);
    });
  }

  /// Crea la etiqueta si no existe y la asigna a la nota.
  /// Si el nombre ya existe se reutiliza: nunca se duplican etiquetas.
  void _crearOAgregarEtiqueta(
    String texto, {
    TextEditingController? controlador,
    bool desenfocar = true,
  }) {
    final nombre = texto.trim();

    if (nombre.isEmpty) return;

    final existente = widget.estado.buscarEtiquetaPorNombre(nombre);

    final etiqueta = existente ?? widget.estado.crearEtiqueta(nombre);

    final yaEstaba = _etiquetasSeleccionadas.contains(etiqueta.id);
    _agregarEtiqueta(etiqueta.id);

    (controlador ?? _controladorEtiquetas)?.clear();

    if (desenfocar) {
      FocusScope.of(context).unfocus();
    } else if (!yaEstaba) {
      setState(() {});
    }
  }

  // ------------------------------------------------------------------
  // GUARDAR
  // ------------------------------------------------------------------

  void _guardarNota() {
    if (!_claveFormulario.currentState!.validate()) return;

    try {
      if (_estaEditando) {
        widget.estado.editarNota(
          id: widget.nota!.id,
          titulo: _controladorTitulo.text,
          descripcion: _controladorDescripcion.text,
          etiquetasIds: _etiquetasSeleccionadas,
        );
      } else {
        widget.estado.agregarNota(
          proyectoId: widget.proyecto.id,
          titulo: _controladorTitulo.text,
          descripcion: _controladorDescripcion.text,
          etiquetasIds: _etiquetasSeleccionadas,
        );
      }

      Navigator.pop(context);
    } on ArgumentError catch (error) {
      if (!context.mounted) return;
      mostrarAviso(context, error.message.toString());
    }
  }

  InputDecoration _decoracion(
      BuildContext context, String texto, IconData icono) {
    final paleta = Paleta.of(context);
    return InputDecoration(
      hintText: texto,
      hintStyle: TextStyle(color: paleta.pista),
      prefixIcon: Icon(
        icono,
        color: paleta.doradoTexto,
      ),
      filled: true,
      fillColor: paleta.campo,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: paleta.borde,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: paleta.doradoTexto,
        ),
      ),
    );
  }
}
