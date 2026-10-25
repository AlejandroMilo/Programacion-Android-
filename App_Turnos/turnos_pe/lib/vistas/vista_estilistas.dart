import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../aplicacion/alcance_turnos.dart';
import '../datos/almacen_turnos.dart';
import '../modelos/estilista.dart';
import '../enrutador/rutas.dart';
import '../tema/tema_app.dart';
import '../modelos_vista/modelo_vista_estilistas.dart';
import '../componentes/componentes.dart';

/// Pantalla Estilistas: equipo del salon y turnos programados de hoy.
class VistaEstilistas extends StatefulWidget {
  const VistaEstilistas({super.key});

  @override
  State<VistaEstilistas> createState() => _EstilistasViewState();
}

class _EstilistasViewState extends State<VistaEstilistas> {
  ModeloVistaEstilistas? _vm;
  AlmacenTurnos? _store;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scope = AlcanceTurnos.of(context);
    if (!identical(_store, scope.store)) {
      _store = scope.store;
      _vm = ModeloVistaEstilistas(scope.store);
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
          builder: (context, _) => CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 170,
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).colorScheme.primary,
                surfaceTintColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: _cabecera(context, vm),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, indice) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _tarjeta(context, vm, vm.estilistas[indice]),
                    ),
                    childCount: vm.estilistas.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Cabecera a sangre con el fondo primary del diseno.
  Widget _cabecera(BuildContext context, ModeloVistaEstilistas vm) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      height: 170,
      color: esquema.primary,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.assignment_ind_outlined, size: 28, color: esquema.onPrimary),
          const SizedBox(height: 4),
          Text(
            'Estilistas',
            style: textos.displaySmall?.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: esquema.onPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            vm.resumen,
            style: textos.bodyMedium?.copyWith(
              fontSize: 13,
              color: AppTheme.subtituloSobrePrimario,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjeta(
    BuildContext context,
    ModeloVistaEstilistas vm,
    Estilista estilista,
  ) {
    final esquema = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;
    final turnos = vm.turnosDeHoy(estilista);

    return Card(
      child: InkWell(
        onTap: () => context.go(Rutas.agendaConEstilista(estilista.id)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset(
                  estilista.avatar,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  semanticLabel: 'Avatar de ${estilista.nombre}',
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      estilista.nombre,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textos.titleMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: esquema.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        for (final categoria in vm.categoriasDe(estilista))
                          Pastilla(texto: categoria.etiqueta, seleccionada: false),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      turnos == 0
                          ? 'Sin turnos hoy'
                          : '$turnos turno${turnos == 1 ? '' : 's'} hoy',
                      style: textos.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: turnos == 0
                            ? esquema.onSurfaceVariant
                            : esquema.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.chevron_right,
                color: esquema.onSurfaceVariant,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}




