import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../datos/base_datos.dart';
import '../../datos/base_datos.dart';
import '../../modelos/estado_orden.dart';
import '../../modelos/repuesto.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';
import '../indicadores/estado_vacio.dart';

class _NotificacionItem {
  const _NotificacionItem({
    required this.titulo,
    required this.detalle,
    required this.icono,
    required this.color,
  });

  final String titulo;
  final String detalle;
  final IconData icono;
  final Color color;
}

class NotificacionesSheet extends StatefulWidget {
  const NotificacionesSheet({super.key});

  static Future<void> mostrar(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const NotificacionesSheet(),
    );
  }

  @override
  State<NotificacionesSheet> createState() => _NotificacionesSheetState();
}

class _NotificacionesSheetState extends State<NotificacionesSheet> {
  late Future<List<_NotificacionItem>> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = _cargar();
  }

  Future<List<_NotificacionItem>> _cargar() async {
    final db = context.read<BaseDatos>();
    final sesion = context.read<Sesion>();
    final items = <_NotificacionItem>[];

    if (sesion.esAdministrador || sesion.esRecepcionista) {
      final bajos = await db.reportesDao.repuestosBajos();
      for (final repuesto in bajos) {
        items.add(
          _NotificacionItem(
            titulo: repuesto.sinStock
                ? 'Repuesto agotado: ${repuesto.nombre}'
                : 'Stock bajo: ${repuesto.nombre}',
            detalle:
                'Quedan ${repuesto.existencias} unidades '
                '(umbral ${repuesto.umbral}).',
            icono: Icons.inventory_2_outlined,
            color: repuesto.sinStock ? Colores.rojo : Colores.amarillo,
          ),
        );
      }

      final deudas = await db.reportesDao.deudas();
      for (final deuda in deudas.take(4)) {
        items.add(
          _NotificacionItem(
            titulo: 'Saldo pendiente de ${deuda.cliente.nombre}',
            detalle:
                '${Formatos.dineroExacto(deuda.saldo)} en '
                '${deuda.ordenes} orden(es).',
            icono: Icons.account_balance_wallet_outlined,
            color: Colores.azul,
          ),
        );
      }
    }

    final listas = await db.ordenesDao.listar(
      estado: EstadoOrden.listaParaEntregar,
    );
    for (final orden in listas) {
      if (sesion.esMecanico && orden.mecanico?.id != sesion.mecanicoId) {
        continue;
      }
      items.add(
        _NotificacionItem(
          titulo: '${orden.numero} lista para entregar',
          detalle: '${orden.cliente.nombre} · ${orden.matricula}',
          icono: Icons.task_alt_rounded,
          color: Colores.verde,
        ),
      );
    }

    if (sesion.esMecanico && sesion.mecanicoId != null) {
      final asignadas = await db.ordenesDao.asignadas(sesion.mecanicoId!);
      for (final orden in asignadas) {
        if (orden.estado == EstadoOrden.listaParaEntregar) continue;
        items.add(
          _NotificacionItem(
            titulo: '${orden.numero}: ${orden.estado.etiqueta}',
            detalle:
                '${orden.cliente.nombre} · ${orden.vehiculoTexto} '
                '(${orden.matricula})',
            icono: Icons.build_circle_outlined,
            color: Colores.naranja,
          ),
        );
      }
    }

    if (sesion.esAdministrador || sesion.esRecepcionista) {
      final ahora = DateTime.now();
      final hoy = await db.ordenesDao.listar(desde: ahora, hasta: ahora);
      if (hoy.isNotEmpty) {
        items.add(
          _NotificacionItem(
            titulo: '${hoy.length} orden(es) recibida(s) hoy',
            detalle: 'Revisa la agenda del taller y asigna mecánicos.',
            icono: Icons.today_rounded,
            color: Colores.morado,
          ),
        );
      }
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.72,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notificaciones',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 3),
              Text(
                'Alertas de inventario, saldos y órdenes.',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).hintColor,
                ),
              ),
              const SizedBox(height: 14),
              Flexible(
                child: FutureBuilder<List<_NotificacionItem>>(
                  future: _futuro,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    final items = snapshot.data ?? const [];
                    if (items.isEmpty) {
                      return const EstadoVacio(
                        titulo: 'Todo en orden',
                        mensaje: 'No hay alertas pendientes por ahora.',
                        icono: Icons.notifications_none_rounded,
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: item.color.withValues(alpha: 0.35),
                            ),
                            color: item.color.withValues(alpha: 0.07),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(item.icono, color: item.color, size: 21),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.titulo,
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.detalle,
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
