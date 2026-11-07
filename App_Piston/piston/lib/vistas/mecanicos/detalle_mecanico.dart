import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../componentes/indicadores/estado_vacio.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../componentes/tarjetas/seccion_titulo.dart';
import '../../componentes/tarjetas/tarjeta_orden.dart';
import '../../datos/base_datos.dart';
import '../../modelos/mecanico.dart';
import '../../modelos/orden_servicio.dart';
import '../../modelos_vista/mecanicos_modelo_vista.dart';
import '../ordenes/detalle_orden.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';
import 'formulario_mecanico.dart';

class DetalleMecanico extends StatelessWidget {
  const DetalleMecanico({super.key, required this.mecanicoId});

  final int mecanicoId;

  @override
  Widget build(BuildContext context) {
    final db = context.read<BaseDatos>();
    final sesion = context.read<Sesion>();
    return ChangeNotifierProvider(
      create: (_) => MecanicosModeloVista(db, sesion),
      child: _CuerpoDetalleMecanico(mecanicoId: mecanicoId),
    );
  }
}

class _CuerpoDetalleMecanico extends StatelessWidget {
  const _CuerpoDetalleMecanico({required this.mecanicoId});

  final int mecanicoId;

  @override
  Widget build(BuildContext context) {
    final modelo = context.watch<MecanicosModeloVista>();
    final tema = Theme.of(context);
    final m = modelo.mecanicos.firstWhereOrNull((mec) => mec.id == mecanicoId);
    final carga = modelo.cargaDe(mecanicoId);

    return Scaffold(
      appBar: BarraSuperior(
        titulo: m == null ? 'Mecánico' : m.nombre,
        subtitulo: m == null ? null : m.especialidad,
        mostrarVolver: true,
        acciones: [
          if (m != null && modelo.puedeGestionar)
            IconButton(
              tooltip: 'Editar mecánico',
              onPressed: () => _editar(context, m),
              icon: const Icon(Icons.edit_outlined),
            ),
          if (m != null && modelo.puedeGestionar)
            PopupMenuButton<String>(
              tooltip: 'Más acciones',
              onSelected: (valor) {
                if (valor == 'estado') _cambiarActivo(context, m);
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'estado',
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(m.activo ? Icons.lock_outlined : Icons.lock_open_outlined, size: 20),
                    title: Text(m.activo ? 'Desactivar mecánico' : 'Activar mecánico'),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: m == null
          ? const EstadoVacio(titulo: 'Mecánico no encontrado', mensaje: 'El registro pudo haber sido eliminado.', icono: Icons.person_off_outlined)
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
              children: [
                _TarjetaPerfil(m: m, carga: carga),
                const SizedBox(height: 18),
                const SeccionTitulo(titulo: 'Órdenes asignadas', icono: Icons.assignment_ind_rounded),
                const SizedBox(height: 7),
                FutureBuilder<List<OrdenResumen>>(
                  future: modelo.ordenesAsignadas(mecanicoId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final ordenes = snapshot.data ?? const [];
                    if (ordenes.isEmpty) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text('Sin órdenes asignadas actualmente.', style: TextStyle(fontSize: 12, color: tema.hintColor)),
                        ),
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ordenes.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final orden = ordenes[index];
                        return TarjetaOrden(
                          orden: orden,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(builder: (_) => DetalleOrden(ordenId: orden.id)),
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

  Future<void> _editar(BuildContext context, Mecanico m) async {
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (_) => FormularioMecanico(mecanico: m)),
    );
    if (guardado == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mecánico actualizado')));
    }
  }

  Future<void> _cambiarActivo(BuildContext context, Mecanico m) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: Text(m.activo ? 'Desactivar mecánico' : 'Activar mecánico'),
        content: Text(m.activo
            ? 'El mecánico dejará de poder tomar órdenes activas.'
            : 'El mecánico volverá a estar disponible para asignaciones.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(contexto).pop(false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.of(contexto).pop(true), child: Text(m.activo ? 'Desactivar' : 'Activar')),
        ],
      ),
    );
    if (confirmar != true) return;
    try {
      await modeloCambiarActivo(context, m, !m.activo);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'), backgroundColor: Colores.rojo));
      }
    }
  }
}

Future<void> modeloCambiarActivo(BuildContext context, Mecanico m, bool activo) async {
  final modelo = context.read<MecanicosModeloVista>();
  await modelo.cambiarActivo(m, activo);
}

class _TarjetaPerfil extends StatelessWidget {
  const _TarjetaPerfil({required this.m, required this.carga});

  final Mecanico m;
  final CargaMecanico? carga;

  @override
  Widget build(BuildContext context) {
    final especialidad = m.especialidad != null && m.especialidad!.isNotEmpty
        ? 'Especialidad: ${m.especialidad}'
        : 'Sin especialidad definida';
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
                radius: 28,
                backgroundColor: Colores.naranja.withValues(alpha: 0.18),
                child: const Icon(Icons.engineering_rounded, color: Colores.naranja, size: 30),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m.nombre, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(especialidad, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: m.activo ? Colores.verde.withValues(alpha: 0.2) : Colores.gris.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(m.activo ? 'Activo' : 'Inactivo', style: TextStyle(color: m.activo ? Colores.verde : Colores.gris, fontSize: 9, fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (carga != null) ...[
            const Text('Carga de trabajo (historial)', style: TextStyle(fontSize: 10, color: Colors.white54)),
            const SizedBox(height: 7),
            Row(
              children: [
                Expanded(child: _DatoCarga(etiqueta: 'Órdenes abiertas', valor: '${carga!.ordenesAbiertas}', color: Colores.naranja)),
                Expanded(child: _DatoCarga(etiqueta: 'Órdenes terminadas', valor: '${carga!.ordenesTerminadas}', color: Colores.verde)),
                Expanded(child: _DatoCarga(etiqueta: 'Mano de obra facturada', valor: Formatos.dineroExacto(carga!.manoObra), color: Colores.morado)),
              ],
            ),
          ],
        ],
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
        Text(etiqueta, style: TextStyle(fontSize: 9, color: Colors.white.withValues(alpha: 0.55))),
        const SizedBox(height: 2),
        Text(valor, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color)),
      ],
    );
  }
}

extension _FirstWhereOrNullMec<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final elemento in this) {
      if (test(elemento)) return elemento;
    }
    return null;
  }
}
