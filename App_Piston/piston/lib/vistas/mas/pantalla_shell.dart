import 'package:flutter/material.dart';

import '../../componentes/navegacion/barra_navegacion.dart';
import '../../utilidades/colores.dart';
import '../clientes/pantalla_clientes.dart';
import '../inicio/pantalla_inicio.dart';
import '../inventario/pantalla_inventario.dart';
import '../mas/pantalla_mas.dart';
import '../ordenes/pantalla_ordenes.dart';

/// Contenedor principal con barra inferior en teléfonos y riel en tablets.
class PantallaShell extends StatefulWidget {
  const PantallaShell({super.key});

  @override
  State<PantallaShell> createState() => _PantallaShellState();
}

class _PantallaShellState extends State<PantallaShell> {
  int _indice = 0;

  void _cambiar(int indice) => setState(() => _indice = indice);

  @override
  Widget build(BuildContext context) {
    final paginas = [
      PantallaInicio(
        onIrAOrdenes: () => _cambiar(1),
        onIrAInventario: () => _cambiar(3),
      ),
      const PantallaOrdenes(),
      const PantallaClientes(),
      const PantallaInventario(),
      PantallaMas(onCambiarPestana: _cambiar),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final ancha = constraints.maxWidth >= 820;
        if (ancha) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _indice,
                  onDestinationSelected: _cambiar,
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: Theme.of(context).cardTheme.color,
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 18),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colores.naranja, Colores.naranjaOscuro],
                        ),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.car_repair_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: Text('Inicio'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.assignment_outlined),
                      selectedIcon: Icon(Icons.assignment_rounded),
                      label: Text('Órdenes'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.people_outline_rounded),
                      selectedIcon: Icon(Icons.people_rounded),
                      label: Text('Clientes'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.inventory_2_outlined),
                      selectedIcon: Icon(Icons.inventory_2_rounded),
                      label: Text('Inventario'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.grid_view_outlined),
                      selectedIcon: Icon(Icons.grid_view_rounded),
                      label: Text('Más'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: IndexedStack(index: _indice, children: paginas),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          body: IndexedStack(index: _indice, children: paginas),
          bottomNavigationBar: BarraNavegacion(
            indice: _indice,
            onSelected: _cambiar,
          ),
        );
      },
    );
  }
}
