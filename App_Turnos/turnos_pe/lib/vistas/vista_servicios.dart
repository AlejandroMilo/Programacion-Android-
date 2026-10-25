import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../aplicacion/alcance_turnos.dart';
import '../datos/almacen_turnos.dart';
import '../modelos/categoria_servicio.dart';
import '../modelos/datos_iniciales_turno.dart';
import '../modelos/filtros.dart';
import '../modelos/reglas_turno.dart';
import '../modelos/servicio.dart';
import '../modelos/turno.dart';
import '../enrutador/rutas.dart';
import '../tema/tema_app.dart';
import '../modelos_vista/modelo_vista_servicios.dart';
import '../componentes/barra_superior.dart';
import '../componentes/componentes.dart';
import '../componentes/dialogo_confirmacion.dart';
import '../componentes/estado_vacio.dart';
import '../componentes/iconos.dart';
import '../componentes/selectores.dart';
import '../componentes/tarjeta_servicio.dart';

/// Catalogo de servicios: solo lectura, con filtros por categoria y publico.
class VistaServicios extends StatefulWidget {
  const VistaServicios({super.key});

  @override
  State<VistaServicios> createState() => _ServiciosViewState();
}

class _ServiciosViewState extends State<VistaServicios> {
  ModeloVistaServicios? _vm;
  AlmacenTurnos? _store;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scope = AlcanceTurnos.of(context);
    if (!identical(_store, scope.store)) {
      _store = scope.store;
      _vm = ModeloVistaServicios(scope.store);
    }
  }

  @override
  void dispose() {
    _vm?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = _vm;
    final store = _store;
    if (vm == null || store == null) return const SizedBox.shrink();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: Listenable.merge(<Listenable>[vm, store]),
          builder: (context, _) => _contenido(context, vm),
        ),
      ),
    );
  }

  Widget _contenido(BuildContext context, ModeloVistaServicios vm) {
    final servicios = vm.servicios;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const BarraSuperior(
          titulo: 'Servicios',
          subtitulo: 'Toca un servicio para reservar',
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _categorias(context, vm),
                const SizedBox(height: 12),
                SegmentedPublico(
                  valor: vm.publicoFiltro,
                  onChanged: vm.filtrarPublico,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: servicios.isEmpty
                      ? _estadoVacio(context, vm)
                      : LayoutBuilder(
                          builder: (context, restricciones) {
                            final columnas = restricciones.maxWidth > 840
                                ? 4
                                : restricciones.maxWidth >= 600
                                ? 3
                                : 2;
                            return GridView.builder(
                              padding: const EdgeInsets.only(bottom: 16),
                              itemCount: servicios.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: columnas,
                                    mainAxisSpacing: 12,
                                    crossAxisSpacing: 12,
                                    mainAxisExtent: 190,
                                  ),
                              itemBuilder: (context, indice) {
                                final servicio = servicios[indice];
                                return TarjetaServicio(
                                  servicio: servicio,
                                  onTap: () => _agendar(servicio),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _categorias(BuildContext context, ModeloVistaServicios vm) {
    return SizedBox(
      height: AppTheme.altoPastilla,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Pastilla(
            texto: 'Todas',
            seleccionada: vm.categoriaFiltro == null,
            onTap: () => vm.filtrarCategoria(null),
          ),
          for (final categoria in CategoriaServicio.values) ...[
            const SizedBox(width: 8),
            Pastilla(
              texto: categoria.etiqueta,
              seleccionada: vm.categoriaFiltro == categoria,
              onTap: () => vm.filtrarCategoria(categoria),
            ),
          ],
        ],
      ),
    );
  }

  Widget _estadoVacio(BuildContext context, ModeloVistaServicios vm) {
    return EstadoVacio(
      titulo: 'Sin servicios para este filtro',
      mensaje: 'Prueba con otra categoría o cambia el público objetivo.',
      ilustracion: const IconoBuscadorX(size: 52),
      colorIlustracion: Theme.of(context).colorScheme.errorContainer,
      accion: OutlinedButton.icon(
        onPressed: () {
          vm.filtrarCategoria(null);
          vm.filtrarPublico(FiltroPublico.todos);
        },
        icon: const Icon(Icons.filter_alt_off_outlined, size: 18),
        label: const Text('Ver todos los servicios'),
      ),
    );
  }

  Future<void> _agendar(Servicio servicio) async {
    final turno = await context.push<Object?>(
      Rutas.turnoNuevo,
      extra: DatosInicialesTurno(servicioId: servicio.id),
    );
    if (!mounted || turno is! Turno) return;
    mostrarAviso(
      context,
      'Turno guardado para el ${ReglasTurno.fechaHumana(turno.inicio)}',
    );
  }
}
