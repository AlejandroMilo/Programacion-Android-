import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../aplicacion/alcance_turnos.dart';
import '../datos/almacen_turnos.dart';
import '../modelos/datos_iniciales_turno.dart';
import '../modelos/reglas_turno.dart';
import '../modelos/turno.dart';
import '../modelos/turno_vista.dart';
import '../enrutador/rutas.dart';
import '../tema/tema_app.dart';
import '../modelos_vista/modelo_vista_agenda.dart';
import '../componentes/barra_superior.dart';
import '../componentes/componentes.dart';
import '../componentes/dialogo_confirmacion.dart';
import '../componentes/estado_vacio.dart';
import '../componentes/iconos.dart';
import '../componentes/resumen_del_dia.dart';
import '../componentes/selectores.dart';
import '../componentes/tarjeta_turno.dart';
import '../componentes/tira_de_dias.dart';

/// Pantalla inicial: agenda diaria con filtros y acciones rapidas.
class VistaAgenda extends StatefulWidget {
  const VistaAgenda({super.key, this.estilistaParam});

  /// Parametro de consulta `/agenda?estilista=...`.
  final String? estilistaParam;

  @override
  State<VistaAgenda> createState() => _AgendaViewState();
}

class _AgendaViewState extends State<VistaAgenda> {
  ModeloVistaAgenda? _vm;
  AlmacenTurnos? _store;
  String? _parametroAplicado;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scope = AlcanceTurnos.of(context);
    if (!identical(_store, scope.store)) {
      _store = scope.store;
      _vm = ModeloVistaAgenda(scope.store, fecha: scope.store.ahora);
      _parametroAplicado = null;
      _aplicarParametro();
    }
  }

  @override
  void didUpdateWidget(covariant VistaAgenda oldWidget) {
    super.didUpdateWidget(oldWidget);
    _aplicarParametro();
  }

  void _aplicarParametro() {
    final parametro = widget.estilistaParam;
    if (parametro == null || parametro.isEmpty) return;
    if (parametro == _parametroAplicado) return;
    _parametroAplicado = parametro;
    _vm?.filtrarEstilista(parametro);
  }

  @override
  void dispose() {
    _vm?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = _vm;
    final store = _store;
    if (vm == null || store == null) return const SizedBox.shrink();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: Listenable.merge(<Listenable>[vm, store]),
          builder: (context, _) => _contenido(context, vm, store),
        ),
      ),
      floatingActionButton: BotonFlotante(
        etiqueta: 'Nuevo turno',
        onPressed: () => _nuevoTurno(vm),
      ),
    );
  }

  Widget _contenido(
    BuildContext context,
    ModeloVistaAgenda vm,
    AlmacenTurnos store,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const BarraSuperior(
          titulo: 'Turco',
          mostrarLogo: true,
          tamanoTitulo: 22,
          acciones: [BotonTema()],
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, restricciones) {
              final cabecera = _cabecera(context, vm, store);
              final lista = _lista(context, vm);

              // En horizontal la agenda se divide en dos columnas: controles
              // a la izquierda y turnos a la derecha.
              final apaisado =
                  restricciones.maxWidth > restricciones.maxHeight &&
                  restricciones.maxWidth >= 600;
              if (apaisado) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 380,
                      child: SingleChildScrollView(child: cabecera),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(child: lista),
                  ],
                );
              }

              // En pantallas bajas la cabecera se desplaza para no desbordar.
              if (restricciones.maxHeight < 560) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: restricciones.maxHeight * 0.62,
                      ),
                      child: SingleChildScrollView(child: cabecera),
                    ),
                    Expanded(child: lista),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  cabecera,
                  Expanded(child: lista),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _cabecera(BuildContext context, ModeloVistaAgenda vm, AlmacenTurnos store) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _tiraDeDias(context, vm),
          const SizedBox(height: 10),
          ResumenDelDia(resumen: vm.resumen),
          const SizedBox(height: 10),
          _chipsEstilistas(context, vm, store),
          const SizedBox(height: 10),
          SegmentedEstado(valor: vm.estadoFiltro, onChanged: vm.filtrarEstado),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  /// Cabecera de la semana: mes, selector de fecha y tira de los siete dias.
  Widget _tiraDeDias(BuildContext context, ModeloVistaAgenda vm) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: vm.irSemanaAnterior,
                    icon: const Icon(Icons.chevron_left, size: 22),
                    color: esquema.onSurfaceVariant,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 22,
                      height: 22,
                    ),
                    tooltip: 'Semana anterior',
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      ReglasTurno.formatearMes(vm.fecha),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textos.bodyLarge?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: esquema.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: vm.irSemanaSiguiente,
                    icon: const Icon(Icons.chevron_right, size: 22),
                    color: esquema.onSurfaceVariant,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 22,
                      height: 22,
                    ),
                    tooltip: 'Semana siguiente',
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => _elegirFecha(vm),
              borderRadius: BorderRadius.circular(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: esquema.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Elegir fecha',
                    style: textos.labelMedium?.copyWith(
                      color: esquema.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TiraDeDias(
          dias: vm.diasDeLaSemana,
          seleccionada: vm.fecha,
          onSeleccionar: vm.seleccionarFecha,
        ),
        const SizedBox(height: 8),
        Text(
          vm.domingoCerrado
              ? 'Domingo: salón cerrado'
              : 'Salón abierto de lunes a sábado · 9:00 a 19:00',
          style: textos.labelSmall?.copyWith(
            fontWeight: FontWeight.w400,
            color: esquema.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _lista(BuildContext context, ModeloVistaAgenda vm) {
    return vm.hayTurnos
        ? ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
            itemCount: vm.turnos.length,
            itemBuilder: (context, indice) {
              final vista = vm.turnos[indice];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TarjetaTurno(
                  vista: vista,
                  onTap: () => _abrirDetalle(vista),
                  onLongPress: vista.turno.estado.esEditable
                      ? () => _accionesRapidas(vm, vista)
                      : null,
                ),
              );
            },
          )
        : _estadoVacio(context, vm);
  }

  Widget _chipsEstilistas(
    BuildContext context,
    ModeloVistaAgenda vm,
    AlmacenTurnos store,
  ) {
    final ids = vm.estilistasDelDia;
    // Una sola fila desplazable: los chips no se reparten en varias lineas.
    return SizedBox(
      height: AppTheme.altoPastilla,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Pastilla(
            texto: 'Todos',
            seleccionada: vm.estilistaFiltro == null,
            onTap: () => vm.filtrarEstilista(null),
          ),
          for (final id in ids) ...[
            const SizedBox(width: 8),
            Pastilla(
              texto: _nombreCorto(store.estilistaPorId(id)?.nombre),
              seleccionada: vm.estilistaFiltro == id,
              onTap: () => vm.filtrarEstilista(id),
            ),
          ],
        ],
      ),
    );
  }

  String _nombreCorto(String? nombre) {
    if (nombre == null) return '';
    final partes = nombre.trim().split(RegExp(r'\s+'));
    return partes.isEmpty ? nombre : partes.first;
  }

  Widget _estadoVacio(BuildContext context, ModeloVistaAgenda vm) {
    if (vm.domingoCerrado) {
      return EstadoVacio(
        titulo: 'Domingo: salón cerrado',
        mensaje: 'El salón atiende de lunes a sábado de 9:00 a 19:00.',
        ilustracion: const IconoCalendarioX(size: 56),
        paddingInferior: 88,
      );
    }
    if (vm.sinResultadosPorFiltros) {
      return EstadoVacio(
        titulo: 'No hay turnos con estos filtros',
        mensaje: 'Cambia el estilista, el estado o elige otro día.',
        ilustracion: const IconoCalendarioX(size: 56),
        paddingInferior: 88,
      );
    }
    return EstadoVacio(
      titulo: 'No hay turnos para este día',
      mensaje:
          'Crea el primer turno con el botón de abajo o cambia los filtros.',
      ilustracion: const IconoCalendarioX(size: 56),
      paddingInferior: 88,
    );
  }

  Future<void> _elegirFecha(ModeloVistaAgenda vm) async {
    final hoy = ReglasTurno.soloFecha(DateTime.now());
    final elegida = await showDatePicker(
      context: context,
      initialDate: vm.fecha,
      firstDate: hoy.subtract(const Duration(days: 365)),
      lastDate: hoy.add(const Duration(days: 365)),
      helpText: 'Elegir fecha',
    );
    if (elegida != null) vm.seleccionarFecha(elegida);
  }

  Future<void> _abrirDetalle(TurnoVista vista) async {
    await context.push<void>(Rutas.turno(vista.turno.id));
  }

  Future<void> _nuevoTurno(ModeloVistaAgenda vm) async {
    final turno = await context.push<Object?>(
      Rutas.turnoNuevo,
      extra: DatosInicialesTurno(fecha: vm.fecha),
    );
    if (!mounted || turno is! Turno) return;
    vm.seleccionarFecha(turno.inicio);
    mostrarAviso(
      context,
      'Turno guardado para el ${_fechaHumana(turno.inicio)}',
      accion: SnackBarAction(
        label: 'Ver',
        onPressed: () {
          if (mounted) context.push<void>(Rutas.turno(turno.id));
        },
      ),
    );
  }

  String _fechaHumana(DateTime fecha) =>
      '${ReglasTurno.inicialDia(fecha).toLowerCase()} ${fecha.day} de '
      '${ReglasTurno.nombreMes(fecha)}';

  /// Hoja inferior con las acciones rapidas del turno.
  Future<void> _accionesRapidas(ModeloVistaAgenda vm, TurnoVista vista) async {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    final accion = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      backgroundColor: esquema.surface,
      barrierColor: const Color(0x66000000),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radioHoja),
        ),
      ),
      builder: (hojaContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${vista.cliente.nombre} · ${vista.horaInicioTexto}',
                style: textos.titleMedium?.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: esquema.onSurface,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '${vista.serviciosTexto} · ${vista.estilista.nombreCorto}',
                style: textos.bodyMedium?.copyWith(
                  fontSize: 13,
                  color: esquema.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
              InkWell(
                onTap: () => Navigator.of(hojaContext).pop('completar'),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 22,
                        color: esquema.tertiary,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Marcar como completada',
                        style: textos.bodyLarge?.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: esquema.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.of(hojaContext).pop('cancelar'),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.cancel_outlined,
                        size: 22,
                        color: esquema.error,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Cancelar turno',
                        style: textos.bodyLarge?.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: esquema.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (!mounted) return;

    if (accion == 'completar') {
      final confirmado = await confirmarAccion(
        context,
        titulo: '¿Completar este turno?',
        mensaje:
            'El turno de ${vista.cliente.nombre} a las ${vista.horaInicioTexto} '
            'quedará marcado como completado.',
        textoConfirmar: 'Completar',
        textoCancelar: 'Volver',
      );
      if (confirmado && mounted) vm.completar(vista.turno.id);
    } else if (accion == 'cancelar') {
      final confirmado = await confirmarAccion(
        context,
        titulo: '¿Cancelar este turno?',
        mensaje:
            'El horario de ${vista.cliente.nombre} '
            '(${vista.horaInicioTexto} a ${vista.horaFinTexto}) quedará libre. '
            'Esta acción no se puede deshacer.',
        textoConfirmar: 'Cancelar turno',
        textoCancelar: 'Volver',
      );
      if (confirmado && mounted) vm.cancelar(vista.turno.id);
    }
  }
}

