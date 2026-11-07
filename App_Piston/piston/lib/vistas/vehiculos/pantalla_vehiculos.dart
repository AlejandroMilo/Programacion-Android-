import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../componentes/indicadores/estado_vacio.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../componentes/tarjetas/seccion_titulo.dart';
import '../../componentes/tarjetas/tarjeta_vehiculo.dart';
import '../../datos/base_datos.dart';
import '../../modelos/vehiculo.dart';
import '../../modelos_vista/vehiculos_modelo_vista.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';
import 'detalle_vehiculo.dart';
import 'formulario_vehiculo.dart';

class PantallaVehiculos extends StatelessWidget {
  const PantallaVehiculos({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.read<BaseDatos>();
    final sesion = context.read<Sesion>();
    return ChangeNotifierProvider(
      create: (_) => VehiculosModeloVista(db, sesion),
      child: const _CuerpoVehiculos(),
    );
  }
}

class _CuerpoVehiculos extends StatelessWidget {
  const _CuerpoVehiculos();

  @override
  Widget build(BuildContext context) {
    final modelo = context.watch<VehiculosModeloVista>();
    final tema = Theme.of(context);
    final activos = modelo.vehiculos.where((v) => v.vehiculo.activo).length;

    return Scaffold(
      appBar: BarraSuperior(
        titulo: 'Vehículos',
        subtitulo:
            '${modelo.vehiculos.length} registrados · $activos activos',
      ),
      floatingActionButton: modelo.puedeGestionar
          ? FloatingActionButton.extended(
              onPressed: () async {
                final creado = await Navigator.of(context).push<bool>(
                  MaterialPageRoute<bool>(
                    builder: (_) => const FormularioVehiculo(),
                  ),
                );
                if (creado == true && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vehículo registrado')),
                  );
                }
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Nuevo vehículo'),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
            child: TextField(
              onChanged: modelo.cambiarBusqueda,
              decoration: const InputDecoration(
                hintText: 'Buscar por matrícula, marca o propietario…',
                prefixIcon: Icon(Icons.search_rounded, size: 21),
              ),
            ),
          ),
          Expanded(
            child: modelo.cargando && modelo.vehiculos.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : modelo.vehiculos.isEmpty
                ? EstadoVacio(
                    titulo: modelo.busqueda.isEmpty
                        ? 'Sin vehículos registrados'
                        : 'Sin coincidencias',
                    mensaje: modelo.busqueda.isEmpty
                        ? 'Registra el primer vehículo desde un cliente o '
                              'desde aquí.'
                        : 'Prueba con otra matrícula o marca.',
                    icono: Icons.directions_car_outlined,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                    itemCount: modelo.vehiculos.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final conDueno = modelo.vehiculos[index];
                      return _TarjetaVehiculoResume(
                        conDueno: conDueno,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                DetalleVehiculo(vehiculoId: conDueno.vehiculo.id),
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

class _TarjetaVehiculoResume extends StatelessWidget {
  const _TarjetaVehiculoResume({
    required this.conDueno,
    required this.onTap,
  });

  final VehiculoConDueno conDueno;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final v = conDueno.vehiculo;
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
                  color: tema.colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.directions_car_rounded,
                  size: 22,
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
                            v.matricula,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                        if (!v.activo)
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
                    Text(
                      '${v.marca} ${v.modelo} (${v.anio})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: tema.hintColor),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(Icons.person_outlined, size: 13, color: tema.hintColor),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            conDueno.cliente.nombre,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 11.5, color: tema.hintColor),
                          ),
                        ),
                        Text(
                          Formatos.kilometraje(v.kilometraje),
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
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
}
