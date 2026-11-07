import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../componentes/indicadores/estado_vacio.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../componentes/tarjetas/seccion_titulo.dart';
import '../../componentes/tarjetas/tarjeta_orden.dart';
import '../../componentes/tarjetas/tarjeta_vehiculo.dart';
import '../../datos/base_datos.dart';
import '../../modelos/orden_servicio.dart';
import '../../modelos/vehiculo.dart';
import '../../modelos_vista/detalle_cliente_modelo_vista.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';
import '../ordenes/detalle_orden.dart';
import '../vehiculos/detalle_vehiculo.dart';
import '../vehiculos/formulario_vehiculo.dart';
import 'formulario_cliente.dart';

class DetalleCliente extends StatelessWidget {
  const DetalleCliente({super.key, required this.clienteId});

  final int clienteId;

  @override
  Widget build(BuildContext context) {
    final db = context.read<BaseDatos>();
    final sesion = context.read<Sesion>();
    return ChangeNotifierProvider(
      create: (_) =>
          DetalleClienteModeloVista(db, sesion, clienteId)..cargar(),
      child: const _CuerpoDetalleCliente(),
    );
  }
}

class _CuerpoDetalleCliente extends StatelessWidget {
  const _CuerpoDetalleCliente();

  @override
  Widget build(BuildContext context) {
    final modelo = context.watch<DetalleClienteModeloVista>();
    final cliente = modelo.cliente;
    final tema = Theme.of(context);

    return Scaffold(
      appBar: BarraSuperior(
        titulo: cliente?.nombre ?? 'Cliente',
        subtitulo: cliente == null
            ? null
            : '${modelo.vehiculos.length} vehículo(s) · '
                  '${modelo.historial.length} orden(es)',
        mostrarVolver: true,
        acciones: [
          if (cliente != null && modelo.puedeGestionar)
            IconButton(
              tooltip: 'Editar cliente',
              onPressed: () => _editar(context, modelo),
              icon: const Icon(Icons.edit_outlined),
            ),
          if (cliente != null && modelo.puedeGestionar)
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
                      cliente.activo
                          ? Icons.person_off_outlined
                          : Icons.person_outline_rounded,
                      size: 20,
                    ),
                    title: Text(
                      cliente.activo ? 'Desactivar cliente' : 'Activar cliente',
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: modelo.cargando && cliente == null
          ? const Center(child: CircularProgressIndicator())
          : cliente == null
          ? const EstadoVacio(
              titulo: 'Cliente no encontrado',
              mensaje: 'El registro pudo haber sido eliminado.',
              icono: Icons.person_off_outlined,
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
              children: [
                _TarjetaPerfil(cliente: cliente, saldo: modelo.saldo),
                const SizedBox(height: 18),
                SeccionTitulo(
                  titulo: 'Vehículos',
                  icono: Icons.directions_car_outlined,
                  accion: modelo.puedeGestionar
                      ? TextButton.icon(
                          onPressed: () => _nuevoVehiculo(context, modelo),
                          icon: const Icon(Icons.add_rounded, size: 17),
                          label: const Text('Agregar'),
                        )
                      : null,
                ),
                const SizedBox(height: 7),
                if (modelo.vehiculos.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Este cliente aún no tiene vehículos registrados.',
                        style: TextStyle(fontSize: 12, color: tema.hintColor),
                      ),
                    ),
                  )
                else
                  for (final vehiculo in modelo.vehiculos)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TarjetaVehiculo(
                        vehiculo: VehiculoConDueno(
                          vehiculo: vehiculo,
                          cliente: cliente,
                        ),
                        onTap: () => _abrirVehiculo(context, vehiculo, modelo),
                      ),
                    ),
                const SizedBox(height: 18),
                const SeccionTitulo(
                  titulo: 'Historial de órdenes',
                  icono: Icons.history_rounded,
                ),
                const SizedBox(height: 7),
                if (modelo.historial.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Sin órdenes registradas para este cliente.',
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
                            builder: (_) =>
                                DetalleOrden(ordenId: resultado.orden.id),
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
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colores.verde.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Pagada',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colores.verde,
                                ),
                              ),
                            ),
                        ],
                      ),
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

  Future<void> _editar(
    BuildContext context,
    DetalleClienteModeloVista modelo,
  ) async {
    final cliente = modelo.cliente;
    if (cliente == null) return;
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => FormularioCliente(cliente: cliente),
      ),
    );
    if (guardado == true) await modelo.cargar();
  }

  Future<void> _nuevoVehiculo(
    BuildContext context,
    DetalleClienteModeloVista modelo,
  ) async {
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => FormularioVehiculo(clienteId: modelo.clienteId),
      ),
    );
    if (guardado == true) await modelo.cargar();
  }

  void _abrirVehiculo(
    BuildContext context,
    Vehiculo vehiculo,
    DetalleClienteModeloVista modelo,
  ) {
    Navigator.of(context)
        .push(
          MaterialPageRoute<void>(
            builder: (_) => DetalleVehiculo(vehiculoId: vehiculo.id),
          ),
        )
        .then((_) => modelo.cargar());
  }

  Future<void> _cambiarActivo(
    BuildContext context,
    DetalleClienteModeloVista modelo,
  ) async {
    final cliente = modelo.cliente;
    if (cliente == null) return;
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: Text(cliente.activo ? 'Desactivar cliente' : 'Activar cliente'),
        content: Text(
          cliente.activo
              ? 'El cliente dejará de aparecer en los formularios de nueva '
                    'orden, pero su historial se conserva.'
              : 'El cliente volverá a estar disponible para nuevas órdenes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(contexto).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(contexto).pop(true),
            child: Text(cliente.activo ? 'Desactivar' : 'Activar'),
          ),
        ],
      ),
    );
    if (confirmar != true) return;
    try {
      await modelo.cambiarActivo(!cliente.activo);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$e'),
            backgroundColor: Colores.rojo,
          ),
        );
      }
    }
  }
}

class _TarjetaPerfil extends StatelessWidget {
  const _TarjetaPerfil({required this.cliente, required this.saldo});

  final Cliente cliente;
  final double saldo;

  @override
  Widget build(BuildContext context) {
    final partes = cliente.nombre.trim().split(RegExp(r'\s+'));
    final iniciales = partes.length >= 2
        ? '${partes.first[0]}${partes[1][0]}'.toUpperCase()
        : cliente.nombre.isEmpty
        ? '?'
        : cliente.nombre[0].toUpperCase();

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
              CircleAvatar(
                radius: 27,
                backgroundColor: Colores.naranja.withValues(alpha: 0.18),
                child: Text(
                  iniciales,
                  style: const TextStyle(
                    color: Colores.naranja,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cliente.nombre,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 13,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          cliente.telefono,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: cliente.activo
                                ? Colores.verde.withValues(alpha: 0.2)
                                : Colores.gris.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            cliente.activo ? 'Activo' : 'Inactivo',
                            style: TextStyle(
                              color: cliente.activo
                                  ? Colores.verde
                                  : Colores.gris,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (cliente.direccion != null && cliente.direccion!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.place_outlined,
                  size: 14,
                  color: Colors.white.withValues(alpha: 0.55),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    cliente.direccion!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 11.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                Icon(
                  saldo > 0
                      ? Icons.account_balance_wallet_outlined
                      : Icons.verified_outlined,
                  color: saldo > 0 ? Colores.naranja : Colores.verde,
                  size: 21,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        saldo > 0 ? 'Saldo pendiente' : 'Sin saldo pendiente',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.55),
                        ),
                      ),
                      Text(
                        saldo > 0
                            ? Formatos.dineroExacto(saldo)
                            : 'Cuenta al día',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: saldo > 0 ? Colores.naranja : Colores.verde,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${cliente.fechaRegistro.year}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
