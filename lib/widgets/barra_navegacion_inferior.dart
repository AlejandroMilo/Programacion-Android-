import 'package:flutter/material.dart';

import '../tema/tema_app.dart';

class BarraNavegacionInferior extends StatelessWidget {
  final int indiceSeleccionado;
  final ValueChanged<int> alSeleccionar;

  const BarraNavegacionInferior({
    super.key,
    required this.indiceSeleccionado,
    required this.alSeleccionar,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: indiceSeleccionado,
      onDestinationSelected: alSeleccionar,
      backgroundColor: ColoresExRE.superficie,
      indicatorColor: ColoresExRE.primario,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Inicio',
        ),
        NavigationDestination(
          icon: Icon(Icons.menu_book_outlined),
          selectedIcon: Icon(Icons.menu_book),
          label: 'Catálogo',
        ),
        NavigationDestination(
          icon: Icon(Icons.grid_view_outlined),
          selectedIcon: Icon(Icons.grid_view),
          label: 'Galería',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_border),
          selectedIcon: Icon(Icons.favorite),
          label: 'Favoritos',
        ),
        NavigationDestination(
          icon: Icon(Icons.bar_chart_outlined),
          selectedIcon: Icon(Icons.bar_chart),
          label: 'Progreso',
        ),
      ],
    );
  }
}
