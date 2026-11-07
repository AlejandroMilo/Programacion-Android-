import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../componentes/tarjetas/seccion_titulo.dart';
import '../../componentes/tarjetas/tarjeta_orden.dart';
import '../../datos/base_datos.dart';
import '../../modelos/orden_servicio.dart';
import '../../modelos/pago.dart';
import '../../modelos_vista/pagos_modelo_vista.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';

class DetallePago extends StatelessWidget {
  const DetallePago({super.key, required this.ordenId});

  final int ordenId;

  @override
  Widget build(BuildContext context) {
    final db = context.read<BaseDatos>();
    final sesion = context.read<Sesion>();
    return ChangeNotifierProvider(
      create: (_) => PagosModeloVista(db, sesion),
      child: _CuerpoDetallePago(ordenId: ordenId),
    );
  }
}

class _CuerpoDetallePago extends StatelessWidget {
  const _CuerpoDetallePago({required this.ordenId});

  final int ordenId;

  @override
  Widget build(BuildContext context) {
    final modelo = context.watch<PagosModeloVista>();
    return FutureBuilder<List<Pago>>(
      future: modelo.pagosDe(ordenId),
      builder: (context, pagosSnapshot) {
        if (pagosSnapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            appBar: BarraSuperior(titulo: 'Pagos', mostrarVolver: true),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final pagos = pagosSnapshot.data ?? const [];
        final ordenResultado = modelo.historialDe(ordenId).then(
          (lista) => lista.isEmpty ? null : lista.first,
        );
        return FutureBuilder<ResultadoOrden?>(
          future: ordenResultado,
          builder: (context, resSnapshot) {
            if (resSnapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            final resultado = resSnapshot.data;
            if (resultado == null) {
              return const Center(child: Text('Orden no encontrada'));
            }
            return _VistaDetallePago(
              modelo: modelo,
              resultado: resultado,
              pagos: pagos,
            );
          },
        );
      },
    );
  }
}

class _VistaDetallePago extends StatelessWidget {
  const _VistaDetallePago({
    required this.modelo,
    required this.resultado,
    required this.pagos,
  });

  final PagosModeloVista modelo;
  final ResultadoOrden resultado;
  final List<Pago> pagos;

  @override
  Widget build(BuildContext context) {
    final orden = resultado.orden;
    final tema = Theme.of(context);

    return Scaffold(
      appBar: BarraSuperior(
        titulo: 'Pagos de ${orden.numero}',
        subtitulo: orden.cliente.nombre,
        mostrarVolver: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumen de la orden',
                    style: TextStyle(fontSize: 11, color: tema.hintColor, fontWeight: FontWeight.w800, letterSpacing: 0.6),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _Dato(etiqueta: 'Total', valor: Formatos.dineroExacto(resultado.totales.total))),
                      Expanded(child: _Dato(etiqueta: 'Pagado', valor: Formatos.dineroExacto(resultado.totales.pagado), color: Colores.verde)),
                      Expanded(child: _Dato(etiqueta: 'Saldo', valor: Formatos.dineroExacto(resultado.totales.saldo), color: Colores.rojo)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          const SeccionTitulo(titulo: 'Movimientos de pago', icono: Icons.history_rounded),
          const SizedBox(height: 7),
          (pagos.isEmpty
              ? Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Sin pagos registrados.',
                      style: TextStyle(fontSize: 12, color: tema.hintColor),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pagos.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final pago = pagos[index];
                    return ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      leading: const Icon(
                        Icons.check_circle_rounded,
                        color: Colores.verde,
                        size: 20,
                      ),
                      title: Text(
                        '${pago.metodoEtiqueta} · ${Formatos.fechaHora(pago.fecha)}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (pago.nota != null && pago.nota!.isNotEmpty)
                            Text(
                              pago.nota!,
                              style: TextStyle(
                                fontSize: 10.5,
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
                      trailing: Text(
                        Formatos.dineroExacto(pago.importe),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colores.verde,
                        ),
                      ),
                    );
                  },
                )), 
          ],
        ),
      );
  }
}

class _Dato extends StatelessWidget {
  const _Dato({required this.etiqueta, required this.valor, this.color});

  final String etiqueta;
  final String valor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta, style: TextStyle(fontSize: 9, color: tema.hintColor)),
        const SizedBox(height: 2),
        Text(valor, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color)),
      ],
    );
  }
}
