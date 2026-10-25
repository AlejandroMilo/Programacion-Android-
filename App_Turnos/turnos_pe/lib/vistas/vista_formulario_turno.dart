import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../aplicacion/alcance_turnos.dart';
import '../datos/almacen_turnos.dart';
import '../modelos/categoria_servicio.dart';
import '../modelos/cliente.dart';
import '../modelos/datos_iniciales_turno.dart';
import '../modelos/reglas_turno.dart';
import '../modelos/servicio.dart';
import '../modelos/turno.dart';
import '../tema/tema_app.dart';
import '../modelos_vista/modelo_vista_formulario_turno.dart';
import '../componentes/barra_superior.dart';
import '../componentes/campo_dropdown.dart';
import '../componentes/componentes.dart';
import '../componentes/cuadricula_franjas.dart';
import '../componentes/dialogo_confirmacion.dart';
import '../componentes/formulario_cliente.dart';
import '../componentes/resumen_turno.dart';
import '../componentes/selectores.dart';

/// Formulario de alta y edicion de turnos.
class VistaFormularioTurno extends StatefulWidget {
  const VistaFormularioTurno({super.key, this.turnoId, this.datosIniciales});

  final String? turnoId;
  final DatosInicialesTurno? datosIniciales;

  @override
  State<VistaFormularioTurno> createState() => _FormularioTurnoViewState();
}

class _FormularioTurnoViewState extends State<VistaFormularioTurno> {
  ModeloVistaFormularioTurno? _vm;
  AlmacenTurnos? _store;

  final FocusNode _focoCliente = FocusNode();
  final FocusNode _focoEstilista = FocusNode();
  final FocusNode _focoNotas = FocusNode();
  TextEditingController? _notas;

  /// Formulario con validacion: los validadores de cada campo viven en el
  /// modelo de vista y se ejecutan con formKey.currentState!.validate().
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Se activa cuando la salida ya fue confirmada (descartar o guardar).
  bool _ignorarCambios = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scope = AlcanceTurnos.of(context);
    if (!identical(_store, scope.store)) {
      _store = scope.store;
      _vm = ModeloVistaFormularioTurno(
        scope.store,
        turnoId: widget.turnoId,
        iniciales: widget.datosIniciales,
      );
      _notas = TextEditingController(text: _vm!.notas);
    }
  }

  @override
  void dispose() {
    _notas?.dispose();
    _focoCliente.dispose();
    _focoEstilista.dispose();
    _focoNotas.dispose();
    _vm?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = _vm;
    final store = _store;
    if (vm == null || store == null) return const SizedBox.shrink();

    return ListenableBuilder(
      listenable: Listenable.merge(<Listenable>[vm, store]),
      builder: (context, _) => PopScope<Turno>(
        canPop: _ignorarCambios || !vm.tieneCambios,
        onPopInvokedWithResult: (didPop, resultado) async {
          if (didPop) return;
          final descartar = await _confirmarDescarte();
          if (descartar) _salir();
        },
        child: Scaffold(
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BarraSuperior(
                  titulo: vm.esEdicion ? 'Editar turno' : 'Nuevo turno',
                  onAtras: () => _atras(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _seccionCliente(context, vm, store),
                          _crearCliente(context, vm),
                          _seccionServicios(context, vm, store),
                          _seccionEstilista(context, vm),
                          const SizedBox(height: 10),
                          _seccionFecha(context, vm),
                          const SizedBox(height: 10),
                          _seccionHora(context, vm),
                          const SizedBox(height: 10),
                          _seccionNotas(context, vm),
                        ],
                      ),
                    ),
                  ),
                ),
                _barraInferior(context, vm),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Secciones
  // ---------------------------------------------------------------------------

  Widget _seccionCliente(
    BuildContext context,
    ModeloVistaFormularioTurno vm,
    AlmacenTurnos store,
  ) {
    final clientes = List<Cliente>.of(store.clientes)
      ..sort((a, b) => a.nombre.compareTo(b.nombre));
    final textos = Theme.of(context).textTheme;

    return FormField<String>(
      initialValue: vm.clienteId,
      validator: (valor) => vm.mensajeCliente(),
      builder: (estado) => CampoDropdown<String>(
        etiqueta: 'Cliente',
        hint: 'Selecciona un cliente',
        valor: vm.clienteId,
        focusNode: _focoCliente,
        error: vm.errorCliente,
        icono: Icons.person_outline,
        onChanged: vm.seleccionarCliente,
        opcionesSeleccionadas: [
          for (final cliente in clientes)
            Text(
              cliente.nombre,
              overflow: TextOverflow.ellipsis,
              style: textos.bodyMedium?.copyWith(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
        ],
        opciones: [
          for (final cliente in clientes)
            DropdownMenuItem<String>(
              value: cliente.id,
              child: Text(
                '${cliente.nombre} · ${cliente.telefonoFormateado}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  /// Enlace para dar de alta un cliente sin salir del formulario.
  Widget _crearCliente(BuildContext context, ModeloVistaFormularioTurno vm) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: () => _nuevoCliente(vm),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.person_add_alt_1,
                  size: 16,
                  color: esquema.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Crear cliente nuevo',
                  style: textos.labelMedium?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: esquema.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _seccionServicios(
    BuildContext context,
    ModeloVistaFormularioTurno vm,
    AlmacenTurnos store,
  ) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return FormField<String>(
      initialValue: vm.servicioIds.join(','),
      validator: (valor) => vm.mensajeServicios(),
      builder: (estado) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EtiquetaCampo('Servicios para'),
          const SizedBox(height: 4),
          SegmentedPublico(
            valor: vm.filtroPublico,
            onChanged: vm.cambiarFiltroPublico,
          ),
          const SizedBox(height: 10),
          Text(
            'Servicios',
            style: textos.titleSmall?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: esquema.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          for (final categoria in CategoriaServicio.values)
            ..._bloqueCategoria(context, vm, store, categoria),
          if (vm.errorServicios != null) ...[
            const SizedBox(height: 8),
            MensajeError(vm.errorServicios!),
          ],
        ],
      ),
    );
  }

  List<Widget> _bloqueCategoria(
    BuildContext context,
    ModeloVistaFormularioTurno vm,
    AlmacenTurnos store,
    CategoriaServicio categoria,
  ) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    final servicios = store.servicios
        .where(
          (servicio) =>
              servicio.categoria == categoria &&
              vm.filtroPublico.incluye(servicio.publico),
        )
        .toList();
    if (servicios.isEmpty) return const <Widget>[];

    return [
      Text(
        categoria.titulo,
        style: textos.labelMedium?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: esquema.onSurfaceVariant,
        ),
      ),
      const SizedBox(height: 6),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final servicio in servicios)
            Pastilla(
              texto: servicio.nombre,
              seleccionada: vm.servicioIds.contains(servicio.id),
              onTap: () => _alternarServicio(vm, servicio),
            ),
        ],
      ),
      const SizedBox(height: 10),
    ];
  }

  Widget _seccionEstilista(BuildContext context, ModeloVistaFormularioTurno vm) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;
    final disponibles = vm.estilistasDisponibles;

    return FormField<String>(
      initialValue: vm.estilistaId,
      validator: (valor) => vm.mensajeEstilista(),
      builder: (estado) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CampoDropdown<String>(
            etiqueta: 'Estilista',
            hint: vm.servicioIds.isEmpty
                ? 'Primero elige los servicios'
                : disponibles.isEmpty
                ? 'Ningún estilista puede hacer esto'
                : 'Selecciona un estilista',
            valor: vm.estilistaId,
            focusNode: _focoEstilista,
            error: vm.errorEstilista,
            icono: Icons.content_cut,
            onChanged: disponibles.isEmpty ? null : vm.seleccionarEstilista,
            opcionesSeleccionadas: [
              for (final estilista in disponibles)
                Text(
                  estilista.nombre,
                  overflow: TextOverflow.ellipsis,
                  style: textos.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: esquema.onSurface,
                  ),
                ),
            ],
            opciones: [
              for (final estilista in disponibles)
                DropdownMenuItem<String>(
                  value: estilista.id,
                  child: Text(
                    estilista.nombre,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
          if (vm.servicioIds.isNotEmpty && disponibles.isEmpty) ...[
            const SizedBox(height: 8),
            // Sin estilista no se puede elegir hora: hay que avisar.
            const MensajeError(
              'Ningún estilista realiza todos los servicios elegidos. '
              'Quita alguno o elige otros servicios.',
            ),
          ] else ...[
            const SizedBox(height: 10),
            const Aviso(
              'Solo se muestran estilistas que realizan todos los servicios '
              'elegidos.',
            ),
          ],
        ],
      ),
    );
  }

  Widget _seccionFecha(BuildContext context, ModeloVistaFormularioTurno vm) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return FormField<DateTime>(
      initialValue: vm.fecha,
      validator: (valor) => vm.mensajeFecha(),
      builder: (estado) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EtiquetaCampo('Fecha', error: vm.errorFecha != null),
          const SizedBox(height: 4),
          Material(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radioCampos),
              side: BorderSide(
                color: vm.errorFecha != null ? esquema.error : esquema.outline,
                width: vm.errorFecha != null ? 2 : 1,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => _elegirFecha(vm),
              child: SizedBox(
                height: AppTheme.altoCampo,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: esquema.onSurfaceVariant,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          vm.fecha == null
                              ? 'Elegir fecha'
                              : ReglasTurno.formatearFechaLarga(vm.fecha!),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textos.bodyMedium?.copyWith(
                            fontSize: 14,
                            color: vm.fecha == null
                                ? esquema.onSurfaceVariant
                                : esquema.onSurface,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 18,
                        color: esquema.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (vm.errorFecha != null) ...[
            const SizedBox(height: 4),
            MensajeError(vm.errorFecha!),
          ],
        ],
      ),
    );
  }

  /// Cuadricula de franjas: el error de hora se muestra debajo, como pide
  /// el enunciado.
  Widget _seccionHora(
    BuildContext context,
    ModeloVistaFormularioTurno vm,
  ) {
    return FormField<DateTime>(
      initialValue: vm.hora,
      validator: (valor) => vm.mensajeHora(),
      builder: (estado) => CuadriculaFranjas(
        franjas: vm.franjas,
        seleccionada: vm.hora,
        onSeleccionar: vm.seleccionarHora,
        error: vm.errorHora,
        mensajeSinDisponibles: vm.sinFranjasLibres
            ? 'No quedan franjas libres ese día con este estilista. Prueba '
                  'otra fecha u otro estilista.'
            : null,
      ),
    );
  }

  Widget _seccionNotas(BuildContext context, ModeloVistaFormularioTurno vm) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EtiquetaCampo('Notas (opcional)', error: vm.errorNotas != null),
        const SizedBox(height: 4),
        TextFormField(
          controller: _notas,
          focusNode: _focoNotas,
          minLines: 3,
          maxLines: 5,
          maxLength: 500,
          textCapitalization: TextCapitalization.sentences,
          onChanged: vm.cambiarNotas,
          validator: (valor) => vm.mensajeNotas(),
          style: textos.bodyMedium?.copyWith(color: esquema.onSurface),
          decoration: InputDecoration(
            hintText: 'Preferencias, alergias, indicaciones...',
            hintStyle: textos.bodyMedium?.copyWith(
              color: esquema.onSurfaceVariant,
            ),
            counterText: '',
            contentPadding: const EdgeInsets.all(14),
            border: _borde(esquema, vm.errorNotas != null),
            enabledBorder: _borde(esquema, vm.errorNotas != null),
            focusedBorder: _borde(esquema, vm.errorNotas != null, activo: true),
          ),
        ),
        if (vm.errorNotas != null) ...[
          const SizedBox(height: 4),
          MensajeError(vm.errorNotas!),
        ],
        const SizedBox(height: 4),
        Text(
          '${_notas?.text.length ?? 0} / 500',
          textAlign: TextAlign.right,
          style: textos.labelSmall?.copyWith(
            fontWeight: FontWeight.w400,
            color: esquema.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _borde(
    ColorScheme esquema,
    bool error, {
    bool activo = false,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.radioCampos),
      borderSide: BorderSide(
        color: error
            ? esquema.error
            : activo
            ? esquema.primary
            : esquema.outline,
        width: error ? 2 : (activo ? 1.6 : 1),
      ),
    );
  }

  Widget _barraInferior(BuildContext context, ModeloVistaFormularioTurno vm) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Container(
      color: esquema.surfaceContainer,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ResumenTurno(
              duracion: vm.resumenDuracion,
              fin: vm.resumenFin,
              precio: vm.resumenPrecio,
            ),
            const SizedBox(height: 10),
            if (vm.errorAlGuardar != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  vm.errorAlGuardar!,
                  textAlign: TextAlign.center,
                  style: textos.bodySmall?.copyWith(color: esquema.error),
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: _BotonFormulario(
                    etiqueta: 'Cancelar',
                    relleno: false,
                    color: esquema.primary,
                    onTap: _cancelar,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _BotonFormulario(
                    etiqueta: 'Guardar turno',
                    relleno: true,
                    color: esquema.onPrimary,
                    icono: Icons.check,
                    onTap: _guardar,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Acciones
  // ---------------------------------------------------------------------------

  void _alternarServicio(ModeloVistaFormularioTurno vm, Servicio servicio) {
    final estilistaLimpiado = vm.alternarServicio(servicio.id);
    if (estilistaLimpiado) {
      mostrarAviso(
        context,
        'El estilista elegido no realiza todos los servicios. Elige otro.',
      );
    }
  }

  Future<void> _nuevoCliente(ModeloVistaFormularioTurno vm) async {
    final creado = await mostrarFormularioCliente(context);
    if (!mounted || creado == null) return;
    vm.seleccionarCliente(creado.id);
    mostrarAviso(context, 'Cliente «${creado.nombre}» agregado');
  }

  DateTime _siguienteDiaHabil(DateTime desde) {
    final hoy = ReglasTurno.soloFecha(DateTime.now());
    var fecha = ReglasTurno.soloFecha(desde);
    if (fecha.isBefore(hoy)) fecha = hoy;
    while (ReglasTurno.esDomingo(fecha)) {
      fecha = fecha.add(const Duration(days: 1));
    }
    return fecha;
  }

  Future<void> _elegirFecha(ModeloVistaFormularioTurno vm) async {
    final hoy = ReglasTurno.soloFecha(DateTime.now());
    final inicial = _siguienteDiaHabil(vm.fecha ?? hoy);
    final elegida = await showDatePicker(
      context: context,
      initialDate: inicial,
      firstDate: hoy,
      lastDate: hoy.add(const Duration(days: 365)),
      helpText: 'Fecha del turno',
      selectableDayPredicate: (dia) => !ReglasTurno.esDomingo(dia),
    );
    if (elegida != null) vm.seleccionarFecha(elegida);
  }

  void _guardar() {
    final vm = _vm!;
    // El ViewModel calcula los mensajes de cada campo y el [Form] los valida
    // con esos mismos validadores.
    vm.validar();
    final valido = _formKey.currentState!.validate();
    if (!mounted) return;
    setState(() {});

    if (!valido) {
      final campo = vm.primerCampoConError;
      if (campo == CampoFormulario.cliente) {
        _focoCliente.requestFocus();
      } else if (campo == CampoFormulario.estilista) {
        _focoEstilista.requestFocus();
      } else if (campo == CampoFormulario.notas) {
        _focoNotas.requestFocus();
      }
      // Los errores de campo ya se muestran junto al campo; solo avisa de
      // las reglas de negocio (por ejemplo, un horario ya ocupado).
      if (vm.errorAlGuardar != null) {
        mostrarAviso(context, vm.errorAlGuardar!);
      }
      return;
    }
    final turno = vm.guardar();
    if (turno == null) {
      if (vm.errorAlGuardar != null) {
        mostrarAviso(context, vm.errorAlGuardar!);
      }
      return;
    }
    _salirConResultado(turno);
  }

  Future<bool> _confirmarDescarte() => confirmarAccion(
    context,
    titulo: '¿Descartar los cambios?',
    mensaje:
        'Tienes cambios sin guardar en este turno. Si sales ahora se '
        'perderán.',
    textoConfirmar: 'Descartar',
    textoCancelar: 'Seguir editando',
  );

  void _atras() {
    final vm = _vm!;
    if (!vm.tieneCambios) {
      _salir();
      return;
    }
    _confirmarDescarte().then((descartar) {
      if (descartar && mounted) _salir();
    });
  }

  Future<void> _cancelar() async {
    final vm = _vm!;
    if (!vm.tieneCambios) {
      _salir();
      return;
    }
    final descartar = await _confirmarDescarte();
    if (descartar && mounted) _salir();
  }

  /// Sale del formulario cuando hay que esperar a que PopScope se reconstruya.
  void _salir() {
    setState(() => _ignorarCambios = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.pop();
    });
  }

  void _salirConResultado(Turno turno) {
    setState(() => _ignorarCambios = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.pop(turno);
    });
  }
}

/// Boton de la barra inferior del formulario: radio 23 y alto 46.
class _BotonFormulario extends StatelessWidget {
  const _BotonFormulario({
    required this.etiqueta,
    required this.relleno,
    required this.color,
    required this.onTap,
    this.icono,
  });

  final String etiqueta;
  final bool relleno;
  final Color color;
  final VoidCallback onTap;
  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Material(
      color: relleno ? esquema.primary : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radioBoton),
        side: relleno ? BorderSide.none : BorderSide(color: esquema.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 46,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icono != null) ...[
                Icon(icono, size: 18, color: color),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  etiqueta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textos.labelLarge?.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
