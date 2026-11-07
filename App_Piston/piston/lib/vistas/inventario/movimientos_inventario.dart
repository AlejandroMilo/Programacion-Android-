import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../componentes/indicadores/estado_vacio.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../datos/base_datos.dart';
import '../../modelos_vista/inventario_modelo_vista.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';

class MovimientosInventario extends StatelessWidget {
  const MovimientosInventario({
    super.key,
    required this.repuestoId,
    required this.repuestoNombre,
  });

  final int repuestoId;
  final String repuestoNombre;

  @override
  Widget build(BuildContext context) {
    final db = context.read<BaseDatos>();
    final sesion = context.read<Sesion>();
    return ChangeNotifierProvider(
      create: (_) => InventarioModeloVista(db, sesion),
      child: _CuerpoMovimientos(repuestoId: repuestoId, repuestoNombre: repuestoNombre),
    );
  }
}

class _CuerpoMovimientos extends StatelessWidget {
  const _CuerpoMovimientos({required this.repuestoId, required this.repuestoNombre});

  final int repuestoId;
  final String repuestoNombre;

  @override
  Widget build(BuildContext context) {
    final modelo = context.watch<InventarioModeloVista>();
    final tema = Theme.of(context);

    return Scaffold(
      appBar: BarraSuperior(
        titulo: 'Movimientos',
        subtitulo: repuestoNombre,
        mostrarVolver: true,
      ),
      body: FutureBuilder<List<MovimientoInventario>>(
        future: modelo.movimientos(repuestoId),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final movimientos = snapshot.data ?? const [];
          if (movimientos.isEmpty) {
            return EstadoVacio(
              titulo: 'Sin movimientos',
              mensaje: 'No hay registros de entradas o salidas de stock.',
              icono: Icons.inventory_outlined,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            itemCount: movimientos.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final m = movimientos[index];
              final esEntrada = m.tipo == 'entrada';
              return ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                leading: CircleAvatar(
                  radius: 14,
                  backgroundColor: esEntrada
                      ? Colores.verde.withValues(alpha: 0.15)
                      : Colores.naranja.withValues(alpha: 0.15),
                  child: Icon(
                    esEntrada ? Icons.add_circle_outline : Icons.remove_circle_outline,
                    color: esEntrada ? Colores.verde : Colores.naranja,
                    size: 20,
                  ),
                ),
                title: Text(
                  esEntrada ? 'Entrada de stock' : 'Salida de stock',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${Formatos.fechaHora(m.fecha)} ${m.usuario != null ? '· ${m.usuario}' : ''}',
                      style: TextStyle(fontSize: 11, color: tema.hintColor),
                    ),
                    if (m.nota != null && m.nota!.isNotEmpty)
                      Text(m.nota!, style: const TextStyle(fontSize: 11)),
                  ],
                ),
                trailing: Text(
                  '${esEntrada ? '+' : '-'}${m.cantidad.abs()}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: esEntrada ? Colores.verde : Colores.naranja,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
