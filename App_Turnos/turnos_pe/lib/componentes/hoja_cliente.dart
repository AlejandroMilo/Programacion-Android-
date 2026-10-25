import 'package:flutter/material.dart';

import '../aplicacion/alcance_turnos.dart';
import '../modelos/cliente.dart';
import '../modelos/estado_turno.dart';
import '../modelos/genero.dart';
import '../modelos/reglas_turno.dart';
import '../modelos/turno_vista.dart';
import '../tema/tema_app.dart';
import 'chip_estado.dart';
import 'dialogo_confirmacion.dart';

/// Resultado de interactuar con la hoja de detalle del cliente.
enum AccionHojaCliente { nuevoTurno, editar, eliminado }

/// Abre el detalle del cliente con su historial de turnos y acciones.
Future<AccionHojaCliente?> mostrarHojaCliente(
  BuildContext context,
  String clienteId,
) {
  final esquema = Theme.of(context).colorScheme;
  return showModalBottomSheet<AccionHojaCliente>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: esquema.surface,
    barrierColor: const Color(0x66000000),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppTheme.radioHoja),
      ),
    ),
    builder: (hojaContext) => _HojaCliente(clienteId: clienteId),
  );
}

/// Asa de arrastre de las hojas inferiores del diseno.
class AsaHoja extends StatelessWidget {
  const AsaHoja({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _HojaCliente extends StatefulWidget {
  const _HojaCliente({required this.clienteId});

  final String clienteId;

  @override
  State<_HojaCliente> createState() => _HojaClienteState();
}

class _HojaClienteState extends State<_HojaCliente> {
  @override
  Widget build(BuildContext context) {
    final store = AlcanceTurnos.storeDe(context);
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final cliente = store.clientePorId(widget.clienteId);
        if (cliente == null) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Text('Este cliente ya no existe.'),
          );
        }
        final historial = store.historialDeCliente(cliente.id);

        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const AsaHoja(),
                const SizedBox(height: 14),
                _cabecera(context, cliente),
                const SizedBox(height: 14),
                Text(
                  'Historial de turnos · ${historial.length}',
                  style: textos.bodyMedium?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: esquema.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                if (historial.isEmpty)
                  Text(
                    'Sin turnos registrados. Crea el primero con el botón de abajo.',
                    style: textos.bodySmall?.copyWith(
                      color: esquema.onSurfaceVariant,
                    ),
                  )
                else
                  for (final vista in historial) _filaHistorial(context, vista),
                const SizedBox(height: 12),
                _botones(context, cliente),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _cabecera(BuildContext context, Cliente cliente) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    final esMujer = cliente.genero == Genero.mujer;
    final colorAvatar = esMujer
        ? esquema.primaryContainer
        : esquema.tertiaryContainer;
    final colorInicial = esMujer
        ? esquema.onPrimaryContainer
        : esquema.onTertiaryContainer;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: colorAvatar, shape: BoxShape.circle),
          child: Text(
            cliente.inicial,
            style: textos.titleLarge?.copyWith(
              fontSize: 22.4,
              fontWeight: FontWeight.w600,
              color: colorInicial,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cliente.nombre,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textos.titleLarge?.copyWith(
                  fontSize: 18,
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
                  Text(
                    cliente.telefonoFormateado,
                    style: textos.bodyMedium?.copyWith(
                      fontSize: 13,
                      color: esquema.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              if (cliente.correo != null) ...[
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.mail_outline,
                      size: 13,
                      color: esquema.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        cliente.correo!,
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _filaHistorial(BuildContext context, TurnoVista vista) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${ReglasTurno.formatearDiaMes(vista.turno.inicio)} · '
              '${vista.serviciosTexto}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textos.bodyMedium?.copyWith(
                fontSize: 13,
                color: esquema.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ChipEstado(estado: vista.turno.estado),
        ],
      ),
    );
  }

  Widget _botones(BuildContext context, Cliente cliente) {
    final esquema = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          flex: 188,
          child: _BotonHoja(
            etiqueta: 'Nuevo turno',
            icono: Icons.add,
            onTap: () =>
                Navigator.of(context).pop(AccionHojaCliente.nuevoTurno),
            relleno: esquema.primary,
            colorIcono: esquema.onPrimary,
            colorTexto: esquema.onPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 100,
          child: _BotonHoja(
            etiqueta: 'Editar',
            icono: Icons.edit_outlined,
            onTap: () => Navigator.of(context).pop(AccionHojaCliente.editar),
            borde: esquema.outline,
            colorIcono: esquema.primary,
            colorTexto: esquema.primary,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 46,
          child: _BotonHoja(
            etiqueta: '',
            icono: Icons.delete_outline,
            onTap: () => _eliminar(cliente),
            borde: esquema.outlineVariant,
            colorIcono: esquema.error,
            colorTexto: esquema.error,
            compacto: true,
          ),
        ),
      ],
    );
  }

  Future<void> _eliminar(Cliente cliente) async {
    final store = AlcanceTurnos.storeDe(context);
    final messenger = ScaffoldMessenger.of(context);

    if (store.clienteTieneTurnosProgramados(cliente.id)) {
      final programados = store
          .historialDeCliente(cliente.id)
          .where((vista) => vista.turno.estado == EstadoTurno.programado)
          .length;
      // La hoja se cierra y el aviso queda sobre la lista de clientes.
      Navigator.of(context).pop();
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'No se puede eliminar: ${cliente.nombre} tiene $programados '
            'turno${programados == 1 ? '' : 's'} programado'
            '${programados == 1 ? '' : 's'}.',
          ),
          action: SnackBarAction(label: 'Ver', onPressed: () {}),
        ),
      );
      return;
    }

    final confirmado = await confirmarAccion(
      context,
      titulo: '¿Eliminar a ${cliente.nombre}?',
      mensaje:
          'Se eliminará el cliente junto con su historial de turnos '
          'completados y cancelados.',
      textoConfirmar: 'Eliminar',
      textoCancelar: 'Cancelar',
    );
    if (!confirmado || !mounted) return;

    final error = store.eliminarCliente(cliente.id);
    if (error != null) {
      if (mounted) mostrarAviso(context, error);
      return;
    }
    if (mounted) {
      Navigator.of(context).pop(AccionHojaCliente.eliminado);
    }
  }
}

/// Boton de la hoja del cliente: relleno o borde, radio 23 y alto 46.
class _BotonHoja extends StatelessWidget {
  const _BotonHoja({
    required this.etiqueta,
    required this.icono,
    required this.onTap,
    this.relleno,
    this.borde,
    this.colorIcono,
    this.colorTexto,
    this.compacto = false,
  });

  final String etiqueta;
  final IconData icono;
  final VoidCallback onTap;
  final Color? relleno;
  final Color? borde;
  final Color? colorIcono;
  final Color? colorTexto;
  final bool compacto;

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
          height: 46,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: compacto ? 0 : 14),
            child: Row(
              mainAxisSize: compacto ? MainAxisSize.min : MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icono, size: compacto ? 18 : 17, color: colorIcono),
                if (etiqueta.isNotEmpty) ...[
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
              ],
            ),          ),
        ),
      ),
    );
  }
}

