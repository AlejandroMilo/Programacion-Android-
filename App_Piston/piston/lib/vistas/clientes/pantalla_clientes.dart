import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../componentes/indicadores/estado_vacio.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../datos/base_datos.dart';
import '../../modelos_vista/clientes_modelo_vista.dart';
import '../../utilidades/colores.dart';
import 'detalle_cliente.dart';
import 'formulario_cliente.dart';

class PantallaClientes extends StatelessWidget {
  const PantallaClientes({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.read<BaseDatos>();
    final sesion = context.read<Sesion>();
    return ChangeNotifierProvider(
      create: (_) => ClientesModeloVista(db, sesion),
      child: const _CuerpoClientes(),
    );
  }
}

class _CuerpoClientes extends StatelessWidget {
  const _CuerpoClientes();

  @override
  Widget build(BuildContext context) {
    final modelo = context.watch<ClientesModeloVista>();
    final tema = Theme.of(context);
    final activos = modelo.clientes.where((c) => c.activo).length;

    return Scaffold(
      appBar: BarraSuperior(
        titulo: 'Clientes',
        subtitulo:
            '${modelo.clientes.length} registrados · $activos activos',
      ),
      floatingActionButton: modelo.puedeGestionar
          ? FloatingActionButton.extended(
              onPressed: () async {
                final creado = await Navigator.of(context).push<bool>(
                  MaterialPageRoute<bool>(
                    builder: (_) => const FormularioCliente(),
                  ),
                );
                if (creado == true && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cliente registrado')),
                  );
                }
              },
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: const Text('Nuevo cliente'),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
            child: TextField(
              onChanged: modelo.cambiarBusqueda,
              decoration: const InputDecoration(
                hintText: 'Buscar por nombre o teléfono…',
                prefixIcon: Icon(Icons.search_rounded, size: 21),
              ),
            ),
          ),
          Expanded(
            child: modelo.cargando && modelo.clientes.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : modelo.clientes.isEmpty
                ? EstadoVacio(
                    titulo: modelo.busqueda.isEmpty
                        ? 'Sin clientes registrados'
                        : 'Sin coincidencias',
                    mensaje: modelo.busqueda.isEmpty
                        ? 'Registra al primer cliente para empezar a crear '
                              'órdenes.'
                        : 'Prueba con otro nombre o teléfono.',
                    icono: Icons.people_outline_rounded,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                    itemCount: modelo.clientes.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final cliente = modelo.clientes[index];
                      return _TarjetaCliente(
                        nombre: cliente.nombre,
                        telefono: cliente.telefono,
                        direccion: cliente.direccion,
                        activo: cliente.activo,
                        color: tema.colorScheme.primary,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                DetalleCliente(clienteId: cliente.id),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaCliente extends StatelessWidget {
  const _TarjetaCliente({
    required this.nombre,
    required this.telefono,
    required this.direccion,
    required this.activo,
    required this.color,
    required this.onTap,
  });

  final String nombre;
  final String telefono;
  final String? direccion;
  final bool activo;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  _iniciales(nombre),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            nombre,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (!activo)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colores.grisClaro,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Inactivo',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Colores.grafito,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 13,
                          color: tema.hintColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          telefono,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: tema.hintColor,
                          ),
                        ),
                      ],
                    ),
                    if (direccion != null && direccion!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.place_outlined,
                            size: 13,
                            color: tema.hintColor,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              direccion!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                color: tema.hintColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: tema.hintColor),
            ],
          ),
        ),
      ),
    );
  }

  String _iniciales(String texto) {
    final partes = texto.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty || partes.first.isEmpty) return '?';
    if (partes.length == 1) return partes.first[0].toUpperCase();
    return '${partes.first[0]}${partes[1][0]}'.toUpperCase();
  }
}
