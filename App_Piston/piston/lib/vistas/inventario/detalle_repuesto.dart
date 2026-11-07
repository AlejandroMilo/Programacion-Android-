import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../componentes/indicadores/estado_vacio.dart';
import '../../componentes/indicadores/indicador_inventario.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../componentes/tarjetas/seccion_titulo.dart';
import '../../datos/base_datos.dart';
import '../../modelos/repuesto.dart';
import '../../modelos_vista/inventario_modelo_vista.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';
import 'formulario_repuesto.dart';

class DetalleRepuesto extends StatelessWidget {
  const DetalleRepuesto({super.key, required this.repuestoId});

  final int repuestoId;

  @override
  Widget build(BuildContext context) {
    final db = context.read<BaseDatos>();
    final sesion = context.read<Sesion>();
    return ChangeNotifierProvider(
      create: (_) => InventarioModeloVista(db, sesion),
      child: _CuerpoDetalleRepuesto(repuestoId: repuestoId),
    );
  }
}

class _CuerpoDetalleRepuesto extends StatelessWidget {
  const _CuerpoDetalleRepuesto({required this.repuestoId});

  final int repuestoId;

  @override
  Widget build(BuildContext context) {
    final modelo = context.watch<InventarioModeloVista>();
    final repuesto = modelo.repuestos.firstWhereOrNull((r) => r.id == repuestoId);
    final tema = Theme.of(context);

    return Scaffold(
      appBar: BarraSuperior(
        titulo: repuesto == null ? 'Repuesto' : repuesto.nombre,
        subtitulo: repuesto == null ? null : repuesto.codigo,
        mostrarVolver: true,
        acciones: [
          if (repuesto != null && modelo.puedeGestionar)
            IconButton(
              tooltip: 'Editar repuesto',
              onPressed: () => _editar(context, repuesto),
              icon: const Icon(Icons.edit_outlined),
            ),
          if (repuesto != null && modelo.puedeGestionar)
            PopupMenuButton<String>(
              tooltip: 'Más acciones',
              onSelected: (valor) {
                if (valor == 'estado') _cambiarActivo(context, repuesto);
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'estado',
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      repuesto.activo ? Icons.lock_outlined : Icons.lock_open_outlined,
                      size: 20,
                    ),
                    title: Text(repuesto.activo ? 'Desactivar repuesto' : 'Activar repuesto'),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: repuesto == null
          ? const EstadoVacio(
              titulo: 'Repuesto no encontrado',
              mensaje: 'El registro pudo haber sido eliminado.',
              icono: Icons.inventory_outlined,
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
              children: [
                _TarjetaPerfil(repuesto: repuesto),
                const SizedBox(height: 18),
                const SeccionTitulo(
                  titulo: 'Movimientos de inventario',
                  icono: Icons.history_rounded,
                ),
                const SizedBox(height: 7),
                FutureBuilder<List<MovimientoInventario>>(
                  future: modelo.movimientos(repuestoId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final movimientos = snapshot.data ?? const [];
                    if (movimientos.isEmpty) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Sin movimientos registrados.',
                            style: TextStyle(fontSize: 12, color: tema.hintColor),
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: movimientos.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final m = movimientos[index];
                        final esEntrada = m.tipo == 'entrada';
                        return ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          leading: CircleAvatar(
                            radius: 12,
                            backgroundColor: esEntrada
                                ? Colores.verde.withValues(alpha: 0.15)
                                : Colores.naranja.withValues(alpha: 0.15),
                            child: Icon(
                              esEntrada ? Icons.add_circle_outline : Icons.remove_circle_outline,
                              color: esEntrada ? Colores.verde : Colores.naranja,
                              size: 18,
                            ),
                          ),
                          title: Text(
                            esEntrada ? 'Entrada de stock' : 'Salida de stock',
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            '${Formatos.fechaHora(m.fecha)} ${m.usuario != null ? '· ${m.usuario}' : ''}',
                            style: TextStyle(fontSize: 10.5, color: tema.hintColor),
                          ),
                          trailing: Text(
                            '${esEntrada ? '+' : '-'}${m.cantidad.abs()}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: esEntrada ? Colores.verde : Colores.naranja,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                if (modelo.error != null) ...[
                  const SizedBox(height: 12),
                  Text(modelo.error!, style: const TextStyle(color: Colores.rojo, fontSize: 12)),
                ],
              ],
            ),
    );
  }

  Future<void> _editar(BuildContext context, Repuesto repuesto) async {
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => FormularioRepuesto(repuesto: repuesto),
      ),
    );
    if (guardado == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Repuesto actualizado')),
      );
    }
  }

  Future<void> _cambiarActivo(BuildContext context, Repuesto repuesto) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: Text(repuesto.activo ? 'Desactivar repuesto' : 'Activar repuesto'),
        content: Text(repuesto.activo
            ? 'El repuesto dejará de estar disponible al consumirlo en órdenes.'
            : 'El repuesto volverá a estar disponible.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(contexto).pop(false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.of(contexto).pop(true), child: Text(repuesto.activo ? 'Desactivar' : 'Activar')),
        ],
      ),
    );
    if (confirmar != true) return;
    try {
      await context.read<InventarioModeloVista>().cambiarActivo(repuesto, !repuesto.activo);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'), backgroundColor: Colores.rojo));
      }
    }
  }
}

class _TarjetaPerfil extends StatelessWidget {
  const _TarjetaPerfil({required this.repuesto});

  final Repuesto repuesto;

  @override
  Widget build(BuildContext context) {
    final color = repuesto.sinStock
        ? Colores.rojo
        : repuesto.stockBajo
        ? Colores.amarillo
        : Colores.verde;
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colores.grafito, Colores.negro],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colores.naranja.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.settings_outlined, size: 26, color: Colores.naranja),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(repuesto.nombre, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(repuesto.codigo, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12, letterSpacing: 0.8)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  repuesto.sinStock ? 'Agotado' : repuesto.stockBajo ? 'Stock bajo' : 'Disponible',
                  style: TextStyle(color: color, fontSize: 9.5, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(child: _Dato(etiqueta: 'Precio de venta', valor: Formatos.dineroExacto(repuesto.precioVenta))),
              Expanded(child: _Dato(etiqueta: 'Existencias', valor: '${repuesto.existencias} uds.')),
              Expanded(child: _Dato(etiqueta: 'Umbral', valor: '${repuesto.umbral} uds.')),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              const Icon(Icons.attach_money_rounded, size: 14, color: Colores.naranja),
              const SizedBox(width: 5),
              Text(
                'Valor del inventario: ${Formatos.dineroExacto(repuesto.precioVenta * repuesto.existencias)}',
                style: const TextStyle(fontSize: 11, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  const _Dato({required this.etiqueta, required this.valor});

  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta, style: TextStyle(fontSize: 9, color: Colors.white.withValues(alpha: 0.55))),
        const SizedBox(height: 2),
        Text(valor, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
      ],
    );
  }
}

extension _FirstWhereOrNull<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final elemento in this) {
      if (test(elemento)) return elemento;
    }
    return null;
  }
}
