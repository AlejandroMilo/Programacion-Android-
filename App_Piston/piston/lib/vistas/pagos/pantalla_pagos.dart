import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../componentes/indicadores/estado_vacio.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../componentes/tarjetas/tarjeta_orden.dart';
import '../../datos/base_datos.dart';
import '../../modelos/orden_servicio.dart';
import '../../modelos_vista/pagos_modelo_vista.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';
import '../ordenes/detalle_orden.dart';
import '../pagos/detalle_pago.dart';
import '../pagos/registrar_pago.dart';

class PantallaPagos extends StatelessWidget {
  const PantallaPagos({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.read<BaseDatos>();
    final sesion = context.read<Sesion>();
    return ChangeNotifierProvider(
      create: (_) => PagosModeloVista(db, sesion)..cargar(),
      child: const _CuerpoPagos(),
    );
  }
}

class _CuerpoPagos extends StatelessWidget {
  const _CuerpoPagos();

  @override
  Widget build(BuildContext context) {
    final modelo = context.watch<PagosModeloVista>();
    final tema = Theme.of(context);

    return Scaffold(
      appBar: BarraSuperior(
        titulo: 'Pagos',
        subtitulo:
            '${modelo.pendientes.length} con saldo · Cobrado hoy ${Formatos.dineroExacto(modelo.cobradoHoy)}',
      ),
      floatingActionButton: modelo.puedeCobrar
          ? FloatingActionButton.extended(
              onPressed: () async {
                if (modelo.pendientes.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No hay saldos pendientes')),
                  );
                  return;
                }
                final primera = modelo.filtrados.first;
                final registrado = await Navigator.of(context).push<bool>(
                  MaterialPageRoute<bool>(
                    builder: (_) => RegistrarPago(
                      saldo: primera.totales.saldo,
                      total: primera.totales.total,
                      pagado: primera.totales.pagado,
                    ),
                  ),
                );
                if (registrado == true && context.mounted) {
                  await modelo.cargar();
                }
              },
              icon: const Icon(Icons.payments_rounded),
              label: const Text('Cobrar'),
            )
          : null,
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
          Expanded(
            child: modelo.cargando && modelo.pendientes.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : modelo.pendientes.isEmpty
                ? EstadoVacio(
                    titulo: modelo.busqueda.isEmpty
                        ? 'Sin saldos pendientes'
                        : 'Sin coincidencias',
                    mensaje: modelo.busqueda.isEmpty
                        ? 'Todos los clientes están al día.'
                        : 'Prueba con otro número, cliente o matrícula.',
                    icono: Icons.account_balance_wallet_outlined,
                  )
                : RefreshIndicator(
                    onRefresh: () async => await modelo.cargar(),
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                      itemCount: modelo.filtrados.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final resultado = modelo.filtrados[index];
                        return _TarjetaCobro(resultado: resultado, modelo: modelo);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaCobro extends StatelessWidget {
  const _TarjetaCobro({required this.resultado, required this.modelo});

  final ResultadoOrden resultado;
  final PagosModeloVista modelo;

  @override
  Widget build(BuildContext context) {
    final orden = resultado.orden;
    final t = resultado.totales;
    final tema = Theme.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => DetallePago(ordenId: orden.id),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      orden.numero,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 0.4),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colores.rojo.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Saldo ${Formatos.dineroExacto(t.saldo)}',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colores.rojo),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                orden.cliente.nombre,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                '${orden.matricula} · ${orden.vehiculoTexto}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11.5, color: tema.hintColor),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _Dato(etiqueta: 'Total', valor: Formatos.dineroExacto(t.total)),
                  ),
                  Expanded(
                    child: _Dato(etiqueta: 'Pagado', valor: Formatos.dineroExacto(t.pagado)),
                  ),
                  Expanded(
                    child: _Dato(etiqueta: 'Saldo', valor: Formatos.dineroExacto(t.saldo), color: Colores.rojo),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: modelo.puedeCobrar
                          ? () async {
                              final registrado = await Navigator.of(context).push<bool>(
                                MaterialPageRoute<bool>(
                                  builder: (_) => RegistrarPago(
                                    saldo: t.saldo,
                                    total: t.total,
                                    pagado: t.pagado,
                                  ),
                                ),
                              );
                              if (registrado == true && context.mounted) {
                                await modelo.cargar();
                              }
                            }
                          : null,
                      icon: const Icon(Icons.payments_rounded, size: 18),
                      label: const Text('Cobrar'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => DetalleOrden(ordenId: orden.id),
                        ),
                      ),
                      icon: const Icon(Icons.assignment_outlined, size: 18),
                      label: const Text('Orden'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
