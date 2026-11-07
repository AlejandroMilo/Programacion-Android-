import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../aplicacion/sesion.dart';
import '../../componentes/indicadores/estado_vacio.dart';
import '../../componentes/navegacion/barra_superior.dart';
import '../../componentes/tarjetas/tarjeta_orden.dart';
import '../../datos/base_datos.dart';
import '../../modelos/estado_orden.dart';
import '../../modelos_vista/ordenes_modelo_vista.dart';
import '../../utilidades/colores.dart';
import '../../utilidades/formatos.dart';
import 'detalle_orden.dart';
import 'formulario_orden.dart';

class PantallaOrdenes extends StatelessWidget {
  const PantallaOrdenes({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.read<BaseDatos>();
    final sesion = context.read<Sesion>();
    return ChangeNotifierProvider(
      create: (_) => OrdenesModeloVista(db, sesion),
      child: const _CuerpoOrdenes(),
    );
  }
}

class _CuerpoOrdenes extends StatelessWidget {
  const _CuerpoOrdenes();

  @override
  Widget build(BuildContext context) {
    final modelo = context.watch<OrdenesModeloVista>();
    final sesion = context.watch<Sesion>();
    final tema = Theme.of(context);

    return Scaffold(
      appBar: BarraSuperior(
        titulo: modelo.esMecanico ? 'Mis órdenes' : 'Órdenes',
        subtitulo:
            '${modelo.ordenes.length} resultado(s) · '
            '${modelo.esMecanico ? 'solo asignadas a ti' : 'taller completo'}',
        acciones: [
          if (modelo.hayFiltros)
            IconButton(
              tooltip: 'Limpiar filtros',
              onPressed: modelo.limpiarFiltros,
              icon: const Icon(Icons.filter_alt_off_rounded),
            ),
        ],
      ),
      floatingActionButton: sesion.puede(Permiso.crearOrden)
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const FormularioOrden(),
                ),
              ),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Nueva orden'),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
            child: TextField(
              onChanged: modelo.cambiarBusqueda,
              decoration: const InputDecoration(
                hintText: 'Buscar por número, cliente o matrícula…',
                prefixIcon: Icon(Icons.search_rounded, size: 21),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _ChipEstado(
                  etiqueta: 'Todas',
                  color: tema.colorScheme.primary,
                  seleccionado: modelo.estado == null,
                  onTap: () => modelo.cambiarEstado(null),
                ),
                for (final estado in EstadoOrden.values)
                  _ChipEstado(
                    etiqueta: estado.etiqueta,
                    color: _color(estado),
                    seleccionado: modelo.estado == estado,
                    onTap: () => modelo.cambiarEstado(estado),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                if (!modelo.esMecanico) ...[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              tema.dividerTheme.color ?? Colores.grisClaro,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int?>(
                          value: modelo.mecanicoId,
                          isExpanded: true,
                          icon: const Icon(Icons.expand_more_rounded),
                          hint: const Text('Mecánico'),
                          items: [
                            const DropdownMenuItem<int?>(
                              value: null,
                              child: Text('Todos los mecánicos'),
                            ),
                            for (final mecanico in modelo.mecanicos)
                              DropdownMenuItem<int?>(
                                value: mecanico.id,
                                child: Text(mecanico.nombre),
                              ),
                          ],
                          onChanged: modelo.cambiarMecanico,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
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
            child: modelo.cargando && modelo.ordenes.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : modelo.ordenes.isEmpty
                ? EstadoVacio(
                    titulo: 'No hay órdenes',
                    mensaje: modelo.hayFiltros
                        ? 'Prueba con otros filtros o limpia la búsqueda.'
                        : 'Registra la primera orden desde el botón Nueva orden.',
                    icono: Icons.assignment_outlined,
                    accion: modelo.hayFiltros
                        ? TextButton(
                            onPressed: modelo.limpiarFiltros,
                            child: const Text('Limpiar filtros'),
                          )
                        : null,
                  )
                : RefreshIndicator(
                    onRefresh: () async => modelo.refrescar(),
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                      itemCount: modelo.ordenes.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 9),
                      itemBuilder: (context, index) {
                        final orden = modelo.ordenes[index];
                        return TarjetaOrden(
                          orden: orden,
                          total: modelo.totalDe(orden.id),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => DetalleOrden(ordenId: orden.id),
                            ),
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

  Color _color(EstadoOrden estado) => switch (estado) {
    EstadoOrden.recibida => Colores.azul,
    EstadoOrden.enDiagnostico => Colores.morado,
    EstadoOrden.enReparacion => Colores.naranja,
    EstadoOrden.listaParaEntregar => Colores.verde,
    EstadoOrden.entregada => Colores.verde,
    EstadoOrden.cancelada => Colores.rojo,
  };

  Future<void> _elegirFechas(
    BuildContext context,
    OrdenesModeloVista modelo,
  ) async {
    final ahora = DateTime.now();
    final rango = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: ahora,
      initialDateRange: modelo.desde == null
          ? null
          : DateTimeRange(start: modelo.desde!, end: modelo.hasta ?? ahora),
      helpText: 'Filtrar órdenes por fecha',
      cancelText: 'Cancelar',
      confirmText: 'Aplicar',
      saveText: 'Aplicar',
    );
    if (rango != null) {
      modelo.cambiarFechas(rango.start, rango.end);
    }
  }
}

class _ChipEstado extends StatelessWidget {
  const _ChipEstado({
    required this.etiqueta,
    required this.color,
    required this.seleccionado,
    required this.onTap,
  });

  final String etiqueta;
  final Color color;
  final bool seleccionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 7),
      child: ChoiceChip(
        selected: seleccionado,
        onSelected: (_) => onTap(),
        label: Text(
          etiqueta,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: seleccionado ? Colors.white : null,
          ),
        ),
        selectedColor: color,
        showCheckmark: false,
        side: BorderSide(color: color.withValues(alpha: 0.4)),
      ),
    );
  }
}
