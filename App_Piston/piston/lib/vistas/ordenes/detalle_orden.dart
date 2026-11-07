import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../componentes/indicadores/estado_vacio.dart';
import '../../componentes/indicadores/indicador_estado.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../componentes/tarjetas/seccion_titulo.dart';
import '../../datos/base_datos.dart';
import '../../modelos/estado_orden.dart';
import '../../modelos/orden_servicio.dart';
import '../../modelos/pago.dart';
import '../../modelos/repuesto_utilizado.dart';
import '../../modelos_vista/orden_detalle_modelo_vista.dart';
import '../../modelos_vista/trabajos_modelo_vista.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';
import '../historial/pantalla_historial.dart';
import '../pagos/registrar_pago.dart';
import '../trabajos/formulario_trabajo.dart';
import 'agregar_repuesto.dart';
import 'asignar_mecanico.dart';
import 'cambiar_estado_orden.dart';
import 'editar_orden.dart';

class DetalleOrden extends StatelessWidget {
  const DetalleOrden({super.key, required this.ordenId});

  final int ordenId;

  @override
  Widget build(BuildContext context) {
    final db = context.read<BaseDatos>();
    final sesion = context.read<Sesion>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => OrdenDetalleModeloVista(db, sesion, ordenId),
        ),
        ChangeNotifierProvider(
          create: (_) => TrabajosModeloVista(db, sesion, ordenId),
        ),
      ],
      child: const _CuerpoDetalleOrden(),
    );
  }
}

class _CuerpoDetalleOrden extends StatelessWidget {
  const _CuerpoDetalleOrden();

  @override
  Widget build(BuildContext context) {
    final modelo = context.watch<OrdenDetalleModeloVista>();
    final orden = modelo.orden;

    return Scaffold(
      appBar: BarraSuperior(
        titulo: orden == null ? 'Orden' : 'Orden ${orden.numero}',
        subtitulo: orden == null
            ? null
            : '${orden.estado.etiqueta} · ${orden.cliente.nombre}',
        mostrarVolver: true,
        acciones: [
          if (modelo.puedeEditarDatos)
            IconButton(
              tooltip: 'Editar datos',
              onPressed: () => _editar(context, modelo),
              icon: const Icon(Icons.edit_outlined),
            ),
          if (orden != null)
            PopupMenuButton<String>(
              tooltip: 'Más acciones',
              onSelected: (valor) {
                switch (valor) {
                  case 'asignar':
                    _asignar(context, modelo);
                  case 'estado':
                    _cambiarEstado(context, modelo);
                  case 'historial':
                    _historial(context, modelo);
                  case 'cancelar':
                    _cancelar(context, modelo);
                }
              },
              itemBuilder: (contexto) => [
                if (modelo.puedeAsignar)
                  const PopupMenuItem(
                    value: 'asignar',
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.engineering_outlined, size: 20),
                      title: Text('Asignar mecánico'),
                    ),
                  ),
                if (modelo.puedeCambiarEstado)
                  const PopupMenuItem(
                    value: 'estado',
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.swap_horiz_rounded, size: 20),
                      title: Text('Cambiar estado'),
                    ),
                  ),
                const PopupMenuItem(
                  value: 'historial',
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.history_rounded, size: 20),
                    title: Text('Ver historial'),
                  ),
                ),
                if (modelo.puedeCambiarEstado &&
                    modelo.transicionesDisponibles.contains(
                      EstadoOrden.cancelada,
                    ))
                  const PopupMenuItem(
                    value: 'cancelar',
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.cancel_outlined,
                        size: 20,
                        color: Colores.rojo,
                      ),
                      title: Text(
                        'Cancelar orden',
                        style: TextStyle(color: Colores.rojo),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
      body: modelo.cargando && orden == null
          ? const Center(child: CircularProgressIndicator())
          : orden == null
          ? const EstadoVacio(
              titulo: 'Orden no encontrada',
              mensaje: 'La orden pudo haber sido eliminada o no existe.',
              icono: Icons.assignment_late_outlined,
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 28),
              children: [
                _EncabezadoOrden(orden: orden),
                const SizedBox(height: 14),
                _ProgresoEstados(orden: orden),
                const SizedBox(height: 14),
                _TarjetaTotales(modelo: modelo),
                const SizedBox(height: 18),
                _SeccionTrabajos(orden: orden),
                const SizedBox(height: 18),
                _SeccionRepuestos(orden: orden),
                const SizedBox(height: 18),
                _SeccionPagos(modelo: modelo),
                if (orden.orden.notas != null &&
                    orden.orden.notas!.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  _Notas(texto: orden.orden.notas!),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _historial(
                          context,
                          modelo,
                          vehiculo: true,
                        ),
                        icon: const Icon(
                          Icons.directions_car_outlined,
                          size: 18,
                        ),
                        label: const Text('Historial del vehículo'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _historial(context, modelo),
                        icon: const Icon(Icons.person_outline_rounded, size: 18),
                        label: const Text('Historial del cliente'),
                      ),
                    ),
                  ],
                ),
                if (modelo.error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    modelo.error!,
                    style: const TextStyle(color: Colores.rojo, fontSize: 12),
                  ),
                ],
              ],
            ),
    );
  }

  Future<void> _cambiarEstado(
    BuildContext context,
    OrdenDetalleModeloVista modelo,
  ) async {
    final orden = modelo.orden;
    if (orden == null) return;
    final nuevo = await CambiarEstadoOrdenSheet.mostrar(
      context,
      actual: orden.estado,
      opciones: modelo.transicionesDisponibles,
    );
    if (nuevo == null) return;
    try {
      await modelo.cambiarEstado(nuevo);
      if (context.mounted) _ok(context, 'Estado actualizado a ${nuevo.etiqueta}');
    } catch (e) {
      if (context.mounted) _error(context, e);
    }
  }

  Future<void> _asignar(
    BuildContext context,
    OrdenDetalleModeloVista modelo,
  ) async {
    final orden = modelo.orden;
    if (orden == null) return;
    await modelo.recargarRepuestos();
    if (!context.mounted) return;
    final elegido = await AsignarMecanicoSheet.mostrar(
      context,
      mecanicos: modelo.mecanicosDisponibles,
      actualId: orden.mecanico?.id,
    );
    if (elegido == null) return;
    try {
      await modelo.asignarMecanico(elegido == 0 ? null : elegido);
      if (context.mounted) {
        _ok(context, elegido == 0 ? 'Orden sin asignar' : 'Mecánico asignado');
      }
    } catch (e) {
      if (context.mounted) _error(context, e);
    }
  }

  Future<void> _editar(
    BuildContext context,
    OrdenDetalleModeloVista modelo,
  ) async {
    final orden = modelo.orden;
    if (orden == null) return;
    await modelo.recargarRepuestos();
    if (!context.mounted) return;
    final datos = await EditarOrdenDialog.mostrar(
      context,
      orden: orden,
      mecanicos: modelo.mecanicosDisponibles,
    );
    if (datos == null) return;
    try {
      await modelo.actualizarDatos(
        fechaEntrada: datos.fecha,
        problema: datos.problema,
        kilometrajeEntrada: datos.kilometraje,
        notas: datos.notas,
        mecanicoId: datos.mecanicoId,
      );
      if (context.mounted) _ok(context, 'Orden actualizada');
    } catch (e) {
      if (context.mounted) _error(context, e);
    }
  }

  Future<void> _cancelar(
    BuildContext context,
    OrdenDetalleModeloVista modelo,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: const Text('Cancelar orden'),
        content: const Text(
          'La orden quedará en el historial como cancelada. '
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(contexto).pop(false),
            child: const Text('Volver'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colores.rojo),
            onPressed: () => Navigator.of(contexto).pop(true),
            child: const Text('Cancelar orden'),
          ),
        ],
      ),
    );
    if (confirmar != true) return;
    try {
      await modelo.cambiarEstado(EstadoOrden.cancelada);
      if (context.mounted) _ok(context, 'Orden cancelada');
    } catch (e) {
      if (context.mounted) _error(context, e);
    }
  }

  void _historial(
    BuildContext context,
    OrdenDetalleModeloVista modelo, {
    bool vehiculo = false,
  }) {
    final orden = modelo.orden;
    if (orden == null) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PantallaHistorial(
          clienteId: vehiculo ? null : orden.cliente.id,
          vehiculoId: vehiculo ? orden.vehiculo.id : null,
          titulo: vehiculo
              ? 'Historial de ${orden.matricula}'
              : 'Historial de ${orden.cliente.nombre}',
        ),
      ),
    );
  }
}

class _EncabezadoOrden extends StatelessWidget {
  const _EncabezadoOrden({required this.orden});

  final OrdenResumen orden;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colores.grafito, Colores.negro],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colores.naranja.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  orden.numero,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ),
              IndicadorEstado(estado: orden.estado, compacto: true),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            'Ingreso: ${Formatos.fechaHora(orden.orden.fechaEntrada)}',
            style: TextStyle(
              fontSize: 10.5,
              color: Colors.white.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(height: 13),
          _FilaDato(
            icono: Icons.person_outline_rounded,
            titulo: orden.cliente.nombre,
            detalle: orden.cliente.telefono,
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colores.naranja,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  orden.matricula,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${orden.vehiculoTexto} ${orden.vehiculo.anio} · '
                  '${Formatos.kilometraje(orden.orden.kilometrajeEntrada)}',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          _FilaDato(
            icono: Icons.engineering_outlined,
            titulo: orden.mecanicoTexto,
            detalle: orden.mecanico?.especialidad ?? 'Sin especialidad',
          ),
          const SizedBox(height: 13),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Text(
              orden.orden.problema,
              style: TextStyle(
                fontSize: 12,
                height: 1.35,
                color: Colors.white.withValues(alpha: 0.82),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilaDato extends StatelessWidget {
  const _FilaDato({
    required this.icono,
    required this.titulo,
    required this.detalle,
  });

  final IconData icono;
  final String titulo;
  final String detalle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icono, size: 16, color: Colores.naranja),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            titulo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          detalle,
          style: TextStyle(
            fontSize: 10.5,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

class _ProgresoEstados extends StatelessWidget {
  const _ProgresoEstados({required this.orden});

  final OrdenResumen orden;

  @override
  Widget build(BuildContext context) {
    if (orden.estado == EstadoOrden.cancelada) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colores.rojo.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colores.rojo.withValues(alpha: 0.3)),
        ),
        child: const Row(
          children: [
            Icon(Icons.cancel_rounded, color: Colores.rojo, size: 19),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Esta orden fue cancelada y quedó como registro histórico.',
                style: TextStyle(fontSize: 12, color: Colores.rojo),
              ),
            ),
          ],
        ),
      );
    }

    final pasos = [
      EstadoOrden.recibida,
      EstadoOrden.enDiagnostico,
      EstadoOrden.enReparacion,
      EstadoOrden.listaParaEntregar,
      EstadoOrden.entregada,
    ];
    final actual = pasos.indexOf(orden.estado);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < pasos.length; i++) ...[
                _PasoEstado(
                  estado: pasos[i],
                  completado: i < actual,
                  actual: i == actual,
                ),
                if (i != pasos.length - 1)
                  Container(
                    width: 24,
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    color: i < actual ? Colores.verde : Colores.grisClaro,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PasoEstado extends StatelessWidget {
  const _PasoEstado({
    required this.estado,
    required this.completado,
    required this.actual,
  });

  final EstadoOrden estado;
  final bool completado;
  final bool actual;

  @override
  Widget build(BuildContext context) {
    final color = completado
        ? Colores.verde
        : actual
        ? Colores.naranja
        : Theme.of(context).hintColor;
    return SizedBox(
      width: 76,
      child: Column(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (completado || actual)
                  ? color.withValues(alpha: 0.16)
                  : Colors.transparent,
              border: Border.all(
                color: (completado || actual) ? color : Colores.grisClaro,
                width: 1.5,
              ),
            ),
            child: Icon(
              completado ? Icons.check_rounded : iconoEstado(estado),
              size: 14,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            estado.etiqueta,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              fontSize: 9,
              height: 1.1,
              fontWeight: actual ? FontWeight.w800 : FontWeight.w500,
              color: (completado || actual)
                  ? null
                  : Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaTotales extends StatelessWidget {
  const _TarjetaTotales({required this.modelo});

  final OrdenDetalleModeloVista modelo;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final totales = modelo.totales;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _Total(
                    etiqueta: 'Mano de obra',
                    valor: Formatos.dineroExacto(totales.manoObra),
                  ),
                ),
                Expanded(
                  child: _Total(
                    etiqueta: 'Repuestos',
                    valor: Formatos.dineroExacto(totales.repuestos),
                  ),
                ),
                Expanded(
                  child: _Total(
                    etiqueta: 'Total',
                    valor: Formatos.dineroExacto(totales.total),
                    color: Colores.naranja,
                    grande: true,
                  ),
                ),
              ],
            ),
            const Divider(height: 22),
            Row(
              children: [
                Expanded(
                  child: _Total(
                    etiqueta: 'Pagado',
                    valor: Formatos.dineroExacto(totales.pagado),
                    color: Colores.verde,
                  ),
                ),
                Expanded(
                  child: _Total(
                    etiqueta: 'Saldo',
                    valor: Formatos.dineroExacto(totales.saldo),
                    color: totales.estaPagada
                        ? Colores.verde
                        : Colores.rojo,
                    grande: true,
                  ),
                ),
                if (modelo.puedePagar && !totales.estaPagada)
                  FilledButton.icon(
                    onPressed: () => _pagar(context, modelo),
                    icon: const Icon(Icons.payments_rounded, size: 18),
                    label: const Text('Cobrar'),
                  )
                else if (totales.estaPagada)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colores.verde.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Text(
                      'Pagada',
                      style: TextStyle(
                        color: Colores.verde,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
            if (modelo.puedePagar && totales.saldo > 0) ...[
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Puedes registrar un abono o el saldo completo.',
                  style: TextStyle(fontSize: 10.5, color: tema.hintColor),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pagar(
    BuildContext context,
    OrdenDetalleModeloVista modelo,
  ) async {
    final datos = await RegistrarPago.mostrar(
      context,
      saldo: modelo.saldo,
      total: modelo.totales.total,
      pagado: modelo.totales.pagado,
    );
    if (datos == null) return;
    try {
      await modelo.registrarPago(
        importe: datos.importe,
        metodo: datos.metodo,
        nota: datos.nota,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pago registrado correctamente')),
        );
      }
    } catch (e) {
      if (context.mounted) _error(context, e);
    }
  }
}

class _Total extends StatelessWidget {
  const _Total({
    required this.etiqueta,
    required this.valor,
    this.color,
    this.grande = false,
  });

  final String etiqueta;
  final String valor;
  final Color? color;
  final bool grande;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiqueta,
          style: TextStyle(
            fontSize: 9.5,
            color: Theme.of(context).hintColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          valor,
          style: TextStyle(
            fontSize: grande ? 16 : 13.5,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _SeccionTrabajos extends StatelessWidget {
  const _SeccionTrabajos({required this.orden});

  final OrdenResumen orden;

  @override
  Widget build(BuildContext context) {
    final detalle = context.watch<OrdenDetalleModeloVista>();
    final trabajos = context.watch<TrabajosModeloVista>();
    final tema = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SeccionTitulo(
          titulo: 'Trabajos realizados',
          icono: Icons.build_circle_outlined,
          accion: detalle.puedeRegistrarTrabajos
              ? TextButton.icon(
                  onPressed: () => _agregar(context, detalle, trabajos),
                  icon: const Icon(Icons.add_rounded, size: 17),
                  label: const Text('Agregar'),
                )
              : null,
        ),
        const SizedBox(height: 6),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                if (trabajos.trabajos.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Aún no hay trabajos registrados.',
                      style: TextStyle(fontSize: 12, color: tema.hintColor),
                    ),
                  )
                else
                  for (final trabajo in trabajos.trabajos)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            size: 17,
                            color: Colores.naranja,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trabajo.descripcion,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${Formatos.fecha(trabajo.fecha)} · '
                                  'Mano de obra',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: tema.hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            Formatos.dineroExacto(trabajo.precioManoObra),
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (detalle.puedeRegistrarTrabajos)
                            IconButton(
                              tooltip: 'Eliminar trabajo',
                              onPressed: () => _eliminar(
                                context,
                                detalle,
                                trabajos,
                                trabajo,
                              ),
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                size: 18,
                              ),
                            ),
                        ],
                      ),
                    ),
                const Divider(height: 18),
                Row(
                  children: [
                    Text(
                      'Total mano de obra',
                      style: TextStyle(fontSize: 11, color: tema.hintColor),
                    ),
                    const Spacer(),
                    Text(
                      Formatos.dineroExacto(trabajos.total),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colores.naranja,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _agregar(
    BuildContext context,
    OrdenDetalleModeloVista detalle,
    TrabajosModeloVista trabajos,
  ) async {
    final datos = await FormularioTrabajo.mostrar(context);
    if (datos == null) return;
    try {
      await trabajos.agregar(
        orden: orden,
        descripcion: datos.descripcion,
        precio: datos.precio,
      );
    } catch (e) {
      if (context.mounted) _error(context, e);
    }
  }

  Future<void> _eliminar(
    BuildContext context,
    OrdenDetalleModeloVista detalle,
    TrabajosModeloVista trabajos,
    Trabajo trabajo,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: const Text('Eliminar trabajo'),
        content: Text('¿Eliminar "${trabajo.descripcion}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(contexto).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(contexto).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmar != true) return;
    try {
      await trabajos.eliminar(orden: orden, trabajoId: trabajo.id);
    } catch (e) {
      if (context.mounted) _error(context, e);
    }
  }
}

class _SeccionRepuestos extends StatelessWidget {
  const _SeccionRepuestos({required this.orden});

  final OrdenResumen orden;

  @override
  Widget build(BuildContext context) {
    final detalle = context.watch<OrdenDetalleModeloVista>();
    final tema = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SeccionTitulo(
          titulo: 'Repuestos utilizados',
          icono: Icons.inventory_2_outlined,
          accion: detalle.puedeConsumir
              ? TextButton.icon(
                  onPressed: () => _agregar(context, detalle),
                  icon: const Icon(Icons.add_rounded, size: 17),
                  label: const Text('Agregar'),
                )
              : null,
        ),
        const SizedBox(height: 6),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                if (detalle.repuestos.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'No se han usado repuestos en esta orden.',
                      style: TextStyle(fontSize: 12, color: tema.hintColor),
                    ),
                  )
                else
                  for (final linea in detalle.repuestos)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.settings_outlined,
                            size: 17,
                            color: Colores.azul,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  linea.repuesto.nombre,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${linea.cantidad} × '
                                  '${Formatos.dineroExacto(linea.precioUnitario)}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: tema.hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            Formatos.dineroExacto(linea.subtotal),
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (detalle.puedeConsumir)
                            IconButton(
                              tooltip: 'Quitar repuesto',
                              onPressed: () => _quitar(context, detalle, linea),
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                size: 18,
                              ),
                            ),
                        ],
                      ),
                    ),
                const Divider(height: 18),
                Row(
                  children: [
                    Text(
                      'Total repuestos',
                      style: TextStyle(fontSize: 11, color: tema.hintColor),
                    ),
                    const Spacer(),
                    Text(
                      Formatos.dineroExacto(detalle.totales.repuestos),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colores.azul,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _agregar(
    BuildContext context,
    OrdenDetalleModeloVista detalle,
  ) async {
    await detalle.recargarRepuestos();
    if (!context.mounted) return;
    final datos = await SeleccionarRepuesto.mostrar(
      context,
      repuestos: detalle.repuestosDisponibles,
    );
    if (datos == null) return;
    try {
      await detalle.agregarRepuesto(datos.repuestoId, datos.cantidad);
    } catch (e) {
      if (context.mounted) _error(context, e);
    }
  }

  Future<void> _quitar(
    BuildContext context,
    OrdenDetalleModeloVista detalle,
    RepuestoUtilizado linea,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: const Text('Quitar repuesto'),
        content: Text(
          'Se devolverán ${linea.cantidad} unidades de '
          '"${linea.repuesto.nombre}" al inventario.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(contexto).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(contexto).pop(true),
            child: const Text('Quitar'),
          ),
        ],
      ),
    );
    if (confirmar != true) return;
    try {
      await detalle.quitarRepuesto(linea.linea.id);
    } catch (e) {
      if (context.mounted) _error(context, e);
    }
  }
}

class _SeccionPagos extends StatelessWidget {
  const _SeccionPagos({required this.modelo});

  final OrdenDetalleModeloVista modelo;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SeccionTitulo(
          titulo: 'Pagos',
          icono: Icons.payments_outlined,
          accion: modelo.puedePagar && !modelo.estaPagada
              ? TextButton.icon(
                  onPressed: () => _cobrar(context),
                  icon: const Icon(Icons.add_rounded, size: 17),
                  label: const Text('Cobrar'),
                )
              : null,
        ),
        const SizedBox(height: 6),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: modelo.pagos.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Sin pagos registrados.',
                      style: TextStyle(fontSize: 12, color: tema.hintColor),
                    ),
                  )
                : Column(
                    children: [
                      for (final pago in modelo.pagos)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 17,
                                color: Colores.verde,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${pago.metodoEtiqueta} · '
                                      '${Formatos.fechaHora(pago.fecha)}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (pago.nota != null &&
                                        pago.nota!.isNotEmpty)
                                      Text(
                                        pago.nota!,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: tema.hintColor,
                                        ),
                                      ),
                                    if (pago.registradoPor != null)
                                      Text(
                                        'Registró: ${pago.registradoPor}',
                                        style: TextStyle(
                                          fontSize: 9.5,
                                          color: tema.hintColor,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Text(
                                Formatos.dineroExacto(pago.importe),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: Colores.verde,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _cobrar(BuildContext context) async {
    final datos = await RegistrarPago.mostrar(
      context,
      saldo: modelo.saldo,
      total: modelo.totales.total,
      pagado: modelo.totales.pagado,
    );
    if (datos == null) return;
    try {
      await modelo.registrarPago(
        importe: datos.importe,
        metodo: datos.metodo,
        nota: datos.nota,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pago registrado correctamente')),
        );
      }
    } catch (e) {
      if (context.mounted) _error(context, e);
    }
  }
}

class _Notas extends StatelessWidget {
  const _Notas({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colores.naranja.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colores.naranja.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.sticky_note_2_outlined,
            size: 18,
            color: Colores.naranja,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(fontSize: 12, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

void _ok(BuildContext context, String mensaje) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(mensaje)),
  );
}

void _error(BuildContext context, Object error) {
  final texto = error
      .toString()
      .replaceFirst('Bad state: ', '')
      .replaceFirst('Invalid argument(s): ', '');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(texto), backgroundColor: Colores.rojo),
  );
}
