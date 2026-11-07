import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../componentes/indicadores/estado_vacio.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../componentes/tarjetas/seccion_titulo.dart';
import '../../componentes/tarjetas/tarjeta_resumen.dart';
import '../../datos/base_datos.dart';
import '../../modelos/mecanico.dart';
import '../../modelos_vista/mecanicos_modelo_vista.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';
import 'detalle_mecanico.dart';
import 'formulario_mecanico.dart';

class PantallaMecanicos extends StatelessWidget {
  const PantallaMecanicos({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.read<BaseDatos>();
    final sesion = context.read<Sesion>();
    return ChangeNotifierProvider(
      create: (_) => MecanicosModeloVista(db, sesion),
      child: const _CuerpoMecanicos(),
    );
  }
}

class _CuerpoMecanicos extends StatelessWidget {
  const _CuerpoMecanicos();

  @override
  Widget build(BuildContext context) {
    final modelo = context.watch<MecanicosModeloVista>();
    final sesion = context.watch<Sesion>();
    final tema = Theme.of(context);
    final activos = modelo.mecanicos.where((m) => m.activo).length;

    return Scaffold(
      appBar: BarraSuperior(
        titulo: 'Mecánicos',
        subtitulo: '${modelo.mecanicos.length} registrados · $activos activos',
      ),
      floatingActionButton: modelo.puedeGestionar
          ? FloatingActionButton.extended(
              onPressed: () async {
                final creado = await Navigator.of(context).push<bool>(
                  MaterialPageRoute<bool>(
                    builder: (_) => const FormularioMecanico(),
                  ),
                );
                if (creado == true && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mecánico registrado')),
                  );
                }
              },
              icon: const Icon(Icons.person_add_alt_rounded),
              label: const Text('Nuevo mecánico'),
            )
          : null,
      body: Column(
        children: [
          Expanded(
            child: modelo.cargando && modelo.mecanicos.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : modelo.mecanicos.isEmpty
                ? const EstadoVacio(
                    titulo: 'Sin mecánicos registrados',
                    mensaje: 'Registra al primer mecánico para asignar órdenes.',
                    icono: Icons.engineering_outlined,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                    itemCount: modelo.mecanicos.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final mecanico = modelo.mecanicos[index];
                      final carga = modelo.cargaDe(mecanico.id);
                      return _TarjetaMecanico(
                        mecanico: mecanico,
                        carga: carga,
                        puedeGestionar: modelo.puedeGestionar,
                        esMecanico: sesion.esMecanico,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => DetalleMecanico(mecanicoId: mecanico.id),
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

class _TarjetaMecanico extends StatelessWidget {
  const _TarjetaMecanico({
    required this.mecanico,
    required this.carga,
    required this.puedeGestionar,
    required this.esMecanico,
    required this.onTap,
  });

  final Mecanico mecanico;
  final CargaMecanico? carga;
  final bool puedeGestionar;
  final bool esMecanico;
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
              CircleAvatar(
                radius: 24,
                backgroundColor: Colores.naranja.withValues(alpha: 0.18),
                child: const Icon(Icons.engineering_rounded, color: Colores.naranja, size: 24),
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
                            mecanico.nombre,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                          ),
                        ),
                        if (!mecanico.activo)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colores.grisClaro,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('Inactivo', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colores.grafito)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    if (mecanico.especialidad != null && mecanico.especialidad!.isNotEmpty)
                      Text(mecanico.especialidad!,
                          style: TextStyle(fontSize: 11.5, color: tema.hintColor)),
                    const SizedBox(height: 8),
                    if (carga != null) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _DatoCarga(etiqueta: 'Abiertas', valor: '${carga!.ordenesAbiertas}', color: Colores.naranja),
                          ),
                          Expanded(
                            child: _DatoCarga(etiqueta: 'Terminadas', valor: '${carga!.ordenesTerminadas}', color: Colores.verde),
                          ),
                          Expanded(
                            child: _DatoCarga(etiqueta: 'Mano de obra', valor: Formatos.dineroExacto(carga!.manoObra), color: Colores.morado),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (puedeGestionar || esMecanico)
                Icon(Icons.chevron_right_rounded, color: tema.hintColor),
            ],
          ),
        ),
      ),
    );
  }
}

class _DatoCarga extends StatelessWidget {
  const _DatoCarga({required this.etiqueta, required this.valor, required this.color});

  final String etiqueta;
  final String valor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta, style: TextStyle(fontSize: 9, color: Theme.of(context).hintColor)),
        const SizedBox(height: 2),
        Text(valor, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: color)),
      ],
    );
  }
}
