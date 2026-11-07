import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../componentes/indicadores/estado_vacio.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../componentes/tarjetas/seccion_titulo.dart';
import '../../componentes/tarjetas/tarjeta_orden.dart';
import '../../datos/base_datos.dart';
import '../../modelos/orden_servicio.dart';
import '../../modelos_vista/historial_modelo_vista.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';
import '../ordenes/detalle_orden.dart';

class PantallaHistorial extends StatelessWidget {
  const PantallaHistorial({
    super.key,
    this.clienteId,
    this.vehiculoId,
    required this.titulo,
  });

  final int? clienteId;
  final int? vehiculoId;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    final db = context.read<BaseDatos>();
    final sesion = context.read<Sesion>();
    return ChangeNotifierProvider(
      create: (_) => HistorialModeloVista(db, sesion,
          clienteId: clienteId, vehiculoId: vehiculoId)..cargar(),
      child: _CuerpoHistorial(titulo: titulo),
    );
  }
}

class _CuerpoHistorial extends StatelessWidget {
  const _CuerpoHistorial({required this.titulo});

  final String titulo;

  @override
  Widget build(BuildContext context) {
    final modelo = context.watch<HistorialModeloVista>();
    final tema = Theme.of(context);

    return Scaffold(
      appBar: BarraSuperior(
        titulo: titulo,
        subtitulo: '${modelo.resultados.length} orden(es)',
        mostrarVolver: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
            child: TextField(
              onChanged: modelo.cambiarBusqueda,
              decoration: const InputDecoration(
                hintText: 'Buscar orden, cliente o matrícula…',
                prefixIcon: Icon(Icons.search_rounded, size: 21),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _elegirFechas(context, modelo),
                    icon: const Icon(Icons.date_range_rounded, size: 18),
                    label: Text(
                      modelo.desde == null
                          ? 'Fecha'
                          : Formatos.rango(modelo.desde!, modelo.hasta!),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                if (modelo.desde != null)
                  IconButton(
                    tooltip: 'Quitar fecha',
                    onPressed: () => modelo.cambiarFechas(null, null),
                    icon: const Icon(Icons.close_rounded, size: 19),
                  ),
              ],
            ),
          ),
          Expanded(
            child: modelo.cargando && modelo.resultados.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : modelo.resultados.isEmpty
                ? const EstadoVacioHistorial()
                : RefreshIndicator(
                    onRefresh: () async => await modelo.cargar(),
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                      itemCount: modelo.resultados.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final resultado = modelo.resultados[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: TarjetaOrden(
                            orden: resultado.orden,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => DetalleOrden(ordenId: resultado.orden.id),
                              ),
                            ),
                            acciones: [
                              if (resultado.totales.saldo > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colores.rojo.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Saldo ${Formatos.dineroExacto(resultado.totales.saldo)}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colores.rojo,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _elegirFechas(BuildContext context, HistorialModeloVista modelo) async {
    final rango = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: modelo.desde == null
          ? null
          : DateTimeRange(start: modelo.desde!, end: modelo.hasta ?? DateTime.now()),
      helpText: 'Filtrar historial por fecha',
      cancelText: 'Cancelar',
      confirmText: 'Aplicar',
      saveText: 'Aplicar',
    );
    if (rango != null) {
      modelo.cambiarFechas(rango.start, rango.end);
    }
  }
}

class EstadoVacioHistorial extends StatelessWidget {
  const EstadoVacioHistorial();

  @override
  Widget build(BuildContext context) {
    return const EstadoVacio(
      titulo: 'Sin órdenes',
      mensaje: 'No hay órdenes registradas con estos filtros.',
      icono: Icons.history_rounded,
    );
  }
}
