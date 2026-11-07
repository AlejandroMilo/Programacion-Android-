import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../componentes/botones/boton_principal.dart';
import '../../componentes/indicadores/estado_vacio.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../componentes/tarjetas/seccion_titulo.dart';
import '../../componentes/tarjetas/tarjeta_orden.dart';
import '../../datos/base_datos.dart';
import '../../modelos/orden_servicio.dart';
import '../../modelos_vista/detalle_vehiculo_modelo_vista.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';
import '../ordenes/detalle_orden.dart';
import '../ordenes/formulario_orden.dart';
import '../vehiculos/formulario_vehiculo.dart';

class DetalleVehiculo extends StatelessWidget {
  const DetalleVehiculo({super.key, required this.vehiculoId});

  final int vehiculoId;

  @override
  Widget build(BuildContext context) {
    final db = context.read<BaseDatos>();
    final sesion = context.read<Sesion>();
    return ChangeNotifierProvider(
      create: (_) => DetalleVehiculoModeloVista(db, sesion, vehiculoId)..cargar(),
      child: const _CuerpoDetalleVehiculo(),
    );
  }
}

class _CuerpoDetalleVehiculo extends StatelessWidget {
  const _CuerpoDetalleVehiculo();

  @override
  Widget build(BuildContext context) {
    final modelo = context.watch<DetalleVehiculoModeloVista>();
    final tema = Theme.of(context);
    final v = modelo.vehiculo;
    final cliente = modelo.cliente;

    return Scaffold(
      appBar: BarraSuperior(
        titulo: v == null ? 'Vehículo' : v.matricula,
        subtitulo: v == null
            ? null
            : '${cliente?.nombre ?? ''} · ${modelo.historial.length} orden(es)',
        mostrarVolver: true,
        acciones: [
          if (v != null && modelo.puedeGestionar)
            IconButton(
              tooltip: 'Editar vehículo',
              onPressed: () => _editar(context, modelo),
              icon: const Icon(Icons.edit_outlined),
            ),
          if (v != null && modelo.puedeGestionar)
            PopupMenuButton<String>(
              tooltip: 'Más acciones',
              onSelected: (valor) {
                if (valor == 'estado') _cambiarActivo(context, modelo);
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'estado',
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      v.activo ? Icons.lock_outlined : Icons.lock_open_outlined,
                      size: 20,
                    ),
                    title: Text(v.activo ? 'Desactivar vehículo' : 'Activar vehículo'),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: modelo.cargando && v == null
          ? const Center(child: CircularProgressIndicator())
          : v == null
          ? const EstadoVacio(
              titulo: 'Vehículo no encontrado',
              mensaje: 'El registro pudo haber sido eliminado.',
              icono: Icons.directions_car_outlined,
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
              children: [
                _TarjetaPerfil(v: v, cliente: cliente, saldo: modelo.saldo),
                const SizedBox(height: 18),
                SeccionTitulo(
                  titulo: 'Historial de órdenes',
                  icono: Icons.history_rounded,
                  accion: TextButton(
                    onPressed: () => _nuevaOrden(context, modelo),
                    child: const Text('Nueva orden'),
                  ),
                ),
                const SizedBox(height: 7),
                if (modelo.historial.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Sin órdenes registradas para este vehículo.',
                        style: TextStyle(fontSize: 12, color: tema.hintColor),
                      ),
                    ),
                  )
                else
                  for (final resultado in modelo.historial)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colores.rojo.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Saldo ${Formatos.dineroExacto(resultado.totales.saldo)}',
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colores.rojo),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colores.verde.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text('Pagada', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colores.verde)),
                            ),
                        ],
                      ),
                    ),
                if (modelo.error != null) ...[
                  const SizedBox(height: 12),
                  Text(modelo.error!, style: const TextStyle(color: Colores.rojo, fontSize: 12)),
                ],
              ],
            ),
    );
  }

  Future<void> _editar(BuildContext context, DetalleVehiculoModeloVista modelo) async {
    final v = modelo.vehiculo;
    if (v == null) return;
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => FormularioVehiculo(clienteId: v.clienteId, vehiculo: v),
      ),
    );
    if (guardado == true) await modelo.cargar();
  }

  Future<void> _cambiarActivo(BuildContext context, DetalleVehiculoModeloVista modelo) async {
    final v = modelo.vehiculo;
    if (v == null) return;
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: Text(v.activo ? 'Desactivar vehículo' : 'Activar vehículo'),
        content: Text(v.activo
            ? 'El vehículo dejará de aparecer en los formularios de nueva orden, pero su historial se conserva.'
            : 'El vehículo volverá a estar disponible para nuevas órdenes.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(contexto).pop(false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.of(contexto).pop(true), child: Text(v.activo ? 'Desactivar' : 'Activar')),
        ],
      ),
    );
    if (confirmar != true) return;
    try {
      await modelo.cambiarActivo(!v.activo);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'), backgroundColor: Colores.rojo));
      }
    }
  }

  void _nuevaOrden(BuildContext context, DetalleVehiculoModeloVista modelo) {
    final clienteId = modelo.cliente?.id;
    if (clienteId == null) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FormularioOrden(
              clientePreselected: modelo.cliente?.id,
              vehiculoPreselected: modelo.vehiculo?.id,
            ),
      ),
    ).then((_) => modelo.cargar());
  }
}

class _TarjetaPerfil extends StatelessWidget {
  const _TarjetaPerfil({required this.v, required this.cliente, required this.saldo});

  final Vehiculo v;
  final Cliente? cliente;
  final double saldo;

  @override
  Widget build(BuildContext context) {
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
                  color: Colores.naranja.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.directions_car_rounded, size: 26, color: Colores.naranja),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(v.matricula, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800, letterSpacing: 0.6)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${v.marca} ${v.modelo} · ${v.anio}',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: v.activo ? Colores.verde.withValues(alpha: 0.2) : Colores.gris.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(v.activo ? 'Activo' : 'Inactivo', style: TextStyle(color: v.activo ? Colores.verde : Colores.gris, fontSize: 9, fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (cliente != null) ...[
            Row(
              children: [
                const Icon(Icons.person_outlined, size: 14, color: Colors.white60),
                const SizedBox(width: 5),
                Expanded(child: Text(cliente!.nombre, style: const TextStyle(color: Colors.white70, fontSize: 12))),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone_outlined, size: 14, color: Colors.white60),
                const SizedBox(width: 5),
                Expanded(child: Text(cliente!.telefono, style: const TextStyle(color: Colors.white70, fontSize: 12))),
              ],
            ),
          ],
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(13)),
            child: Row(
              children: [
                const Icon(Icons.speed_rounded, size: 20, color: Colores.naranja),
                const SizedBox(width: 9),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Kilometraje', style: TextStyle(fontSize: 10, color: Colors.white54)),
                    Text(Formatos.kilometraje(v.kilometraje), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                  ],
                )),
                if (saldo > 0) ...[
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Saldo pendiente', style: TextStyle(fontSize: 10, color: Colors.white54)),
                      Text(Formatos.dineroExacto(saldo), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colores.naranja)),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
