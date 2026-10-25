import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../aplicacion/alcance_turnos.dart';
import '../datos/almacen_turnos.dart';
import '../modelos/estado_turno.dart';
import '../modelos/reglas_turno.dart';
import '../modelos/servicio.dart';
import '../modelos/turno.dart';
import '../modelos/turno_vista.dart';
import '../enrutador/rutas.dart';
import '../tema/tema_app.dart';
import '../modelos_vista/modelo_vista_detalle_turno.dart';
import '../componentes/barra_superior.dart';
import '../componentes/chip_estado.dart';
import '../componentes/componentes.dart';
import '../componentes/dialogo_confirmacion.dart';
import '../componentes/estado_vacio.dart';
import '../componentes/iconos.dart';

/// Detalle de un turno con las acciones de editar, completar y cancelar.
class VistaDetalleTurno extends StatefulWidget {
  const VistaDetalleTurno({super.key, required this.turnoId});

  final String turnoId;

  @override
  State<VistaDetalleTurno> createState() => _DetalleTurnoViewState();
}

class _DetalleTurnoViewState extends State<VistaDetalleTurno> {
  ModeloVistaDetalleTurno? _vm;
  AlmacenTurnos? _store;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scope = AlcanceTurnos.of(context);
    if (!identical(_store, scope.store)) {
      _store = scope.store;
      _vm = ModeloVistaDetalleTurno(scope.store, widget.turnoId);
    }
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

    return ListenableBuilder(
      listenable: Listenable.merge(<Listenable>[vm, store]),
      builder: (context, _) {
        final vista = vm.vista;
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BarraSuperior(
                  titulo: vista == null ? null : 'Detalle del turno',
                  onAtras: () => context.pop(),
                ),
                Expanded(
                  child: vista == null
                      ? _noEncontrado(context)
                      : _contenido(context, vista),
                ),
              ],
            ),
          ),
          bottomNavigationBar: vista == null ? null : _pie(context, vm, vista),
        );
      },
    );
  }

  Widget _noEncontrado(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;

    return EstadoVacio(
      titulo: 'No encontramos este turno',
      mensaje: 'El turno no existe o ya no está disponible.',
      ilustracion: const IconoBuscadorX(size: 52),
      colorIlustracion: esquema.errorContainer,
      paddingSuperior: 90,
      accion: BotonPrincipal(
        etiqueta: 'Volver a la agenda',
        icono: Icons.arrow_back,
        onPressed: () => context.go(Rutas.agenda),
      ),
    );
  }

  Widget _contenido(BuildContext context, TurnoVista vista) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _tarjetaHorario(context, vista),
          const SizedBox(height: 12),
          _tarjetaServicios(context, vista),
          if (vista.tieneNotas) ...[
            const SizedBox(height: 12),
            _tarjetaNotas(context, vista),
          ],
          const SizedBox(height: 12),
          Text(
            'Creado el ${_fechaHora(vista.turno.creadoEn)} · '
            'Modificado el ${_fechaHora(vista.turno.modificadoEn)}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaHorario(BuildContext context, TurnoVista vista) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: esquema.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    vista.cliente.inicial,
                    style: textos.titleMedium?.copyWith(
                      fontSize: 19.2,
                      fontWeight: FontWeight.w600,
                      color: esquema.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vista.cliente.nombre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textos.titleMedium?.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: esquema.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 13,
                            color: esquema.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              vista.cliente.telefonoFormateado,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textos.bodyMedium?.copyWith(
                                fontSize: 13,
                                color: esquema.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ChipEstado(estado: vista.turno.estado),
              ],
            ),
            const SizedBox(height: 10),
            _dato(
              context,
              icono: Icons.calendar_today_outlined,
              etiqueta: 'Fecha',
              valor: ReglasTurno.formatearFechaLarga(vista.turno.inicio),
            ),
            const SizedBox(height: 10),
            _dato(
              context,
              icono: Icons.schedule,
              etiqueta: 'Hora',
              valor:
                  '${vista.horaInicioTexto} a ${vista.horaFinTexto} '
                  '(${vista.duracionTexto})',
            ),
            const SizedBox(height: 10),
            _dato(
              context,
              icono: Icons.person_outline,
              etiqueta: 'Estilista',
              valor: vista.estilista.nombreCorto,
            ),
          ],
        ),
      ),
    );
  }

  Widget _dato(
    BuildContext context, {
    required IconData icono,
    required String etiqueta,
    required String valor,
  }) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icono, size: 18, color: esquema.primary),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                etiqueta,
                style: textos.labelSmall?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: esquema.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                valor,
                style: textos.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: esquema.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tarjetaServicios(BuildContext context, TurnoVista vista) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Servicios',
              style: textos.titleSmall?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: esquema.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            for (final servicio in vista.servicios) ...[
              _filaServicio(context, servicio),
              const SizedBox(height: 10),
              const LineaDivisoria(),
              const SizedBox(height: 10),
            ],
            Row(
              children: [
                Text(
                  'Total',
                  style: textos.titleSmall?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: esquema.onSurface,
                  ),
                ),
                const Spacer(),
                Text(
                  vista.precioTexto,
                  style: textos.titleLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: esquema.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _filaServicio(BuildContext context, Servicio servicio) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                servicio.nombre,
                style: textos.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: esquema.onSurface,
                ),
              ),
              Text(
                servicio.duracionTexto,
                style: textos.bodySmall?.copyWith(
                  color: esquema.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          servicio.precioTexto,
          style: textos.bodyMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: esquema.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _tarjetaNotas(BuildContext context, TurnoVista vista) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Notas',
              style: textos.titleSmall?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: esquema.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            // Area de scroll propio: las notas largas no desbordan la
            // tarjeta (lo pide el enunciado).
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 150),
              child: SingleChildScrollView(
                child: Text(
                  vista.turno.notas,
                  style: textos.bodyMedium?.copyWith(
                    fontSize: 13,
                    color: esquema.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pie(
    BuildContext context,
    ModeloVistaDetalleTurno vm,
    TurnoVista vista,
  ) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Container(
      color: esquema.surfaceContainer,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
      child: SafeArea(
        top: false,
        child: vista.turno.estado.esEditable
            ? Row(
                children: [
                  Expanded(
                    child: _BotonAccion(
                      etiqueta: 'Editar',
                      icono: Icons.edit_outlined,
                      colorIcono: esquema.primary,
                      colorTexto: esquema.primary,
                      borde: esquema.outline,
                      onTap: _editar,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _BotonAccion(
                      etiqueta: 'Completar',
                      icono: Icons.check,
                      colorIcono: esquema.onSecondaryContainer,
                      colorTexto: esquema.onSecondaryContainer,
                      relleno: esquema.secondaryContainer,
                      onTap: () => _completar(vm, vista),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _BotonAccion(
                      etiqueta: 'Cancelar',
                      icono: Icons.cancel_outlined,
                      colorIcono: esquema.error,
                      colorTexto: esquema.error,
                      onTap: () => _cancelar(vm, vista),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 16,
                    color: esquema.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      vista.turno.estado == EstadoTurno.completado
                          ? 'Turno completado: solo lectura'
                          : 'Turno cancelado: solo lectura',
                      style: textos.bodyMedium?.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: esquema.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  String _fechaHora(DateTime fecha) =>
      '${ReglasTurno.formatearFechaCorta(fecha)} '
      '${ReglasTurno.formatearHora(fecha)}';

  Future<void> _editar() async {
    final turno = await context.push<Object?>(
      Rutas.turnoEditar(widget.turnoId),
    );
    if (!mounted || turno is! Turno) return;
    mostrarAviso(context, 'Turno actualizado');
  }

  Future<void> _completar(ModeloVistaDetalleTurno vm, TurnoVista vista) async {
    final confirmado = await confirmarAccion(
      context,
      titulo: '¿Completar este turno?',
      mensaje:
          'El turno de ${vista.cliente.nombre} a las ${vista.horaInicioTexto} '
          'quedará marcado como completado.',
      textoConfirmar: 'Completar',
      textoCancelar: 'Volver',
    );
    if (!confirmado || !mounted) return;
    vm.completar();
    mostrarAviso(context, 'Turno completado');
  }

  Future<void> _cancelar(ModeloVistaDetalleTurno vm, TurnoVista vista) async {
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
    if (!confirmado || !mounted) return;
    vm.cancelar();
    mostrarAviso(context, 'Turno cancelado');
  }
}

/// Boton de la barra de acciones del detalle: radio 22 y alto 44.
class _BotonAccion extends StatelessWidget {
  const _BotonAccion({
    required this.etiqueta,
    required this.icono,
    required this.colorIcono,
    required this.colorTexto,
    required this.onTap,
    this.relleno,
    this.borde,
  });

  final String etiqueta;
  final IconData icono;
  final Color colorIcono;
  final Color colorTexto;
  final VoidCallback onTap;
  final Color? relleno;
  final Color? borde;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Material(
      color: relleno ?? Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radioBoton),
        side: borde == null ? BorderSide.none : BorderSide(color: borde!),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, size: 18, color: colorIcono),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  etiqueta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textos.labelLarge?.copyWith(color: colorTexto),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

