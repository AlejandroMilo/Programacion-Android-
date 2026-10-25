import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../datos/almacen_turnos.dart';
import '../modelos/datos_iniciales_turno.dart';
import '../vistas/vista_agenda.dart';
import '../vistas/vista_clientes.dart';
import '../vistas/vista_detalle_turno.dart';
import '../vistas/vista_estilistas.dart';
import '../vistas/vista_formulario_turno.dart';
import '../vistas/vista_servicios.dart';
import '../vistas/vista_shell.dart';
import 'rutas.dart';

/// Router de la app. Toda la navegacion pasa por go_router con
/// StatefulShellRoute.indexedStack para las cuatro pestanas.
GoRouter crearEnrutador(AlmacenTurnos store) {
  final GlobalKey<NavigatorState> rootKey = GlobalKey<NavigatorState>(
    debugLabel: 'root',
  );

  return GoRouter(
    navigatorKey: rootKey,
    initialLocation: Rutas.agenda,
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: rootKey,
        builder: (context, state, navegacion) =>
            VistaShell(navegacion: navegacion),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Rutas.agenda,
                name: 'agenda',
                builder: (context, state) => VistaAgenda(
                  estilistaParam: state.uri.queryParameters['estilista'],
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Rutas.clientes,
                name: 'clientes',
                builder: (context, state) => const VistaClientes(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Rutas.servicios,
                name: 'servicios',
                builder: (context, state) => const VistaServicios(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Rutas.estilistas,
                name: 'estilistas',
                builder: (context, state) => const VistaEstilistas(),
              ),
            ],
          ),
        ],
      ),
      // Pantallas que se abren por encima de la barra inferior.
      GoRoute(
        path: Rutas.turnoNuevo,
        name: 'turnoNuevo',
        parentNavigatorKey: rootKey,
        builder: (context, state) => VistaFormularioTurno(
          datosIniciales: state.extra is DatosInicialesTurno
              ? state.extra! as DatosInicialesTurno
              : null,
        ),
      ),
      GoRoute(
        path: '/turno/:id',
        name: 'turnoDetalle',
        parentNavigatorKey: rootKey,
        builder: (context, state) =>
            VistaDetalleTurno(turnoId: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: '/turno/:id/editar',
        name: 'turnoEditar',
        parentNavigatorKey: rootKey,
        builder: (context, state) =>
            VistaFormularioTurno(turnoId: state.pathParameters['id']),
      ),
    ],
  );
}
