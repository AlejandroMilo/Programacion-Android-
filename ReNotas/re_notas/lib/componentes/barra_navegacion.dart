import 'package:flutter/material.dart';

import '../diseno/sistema.dart';

/// Barra de navegación inferior con los tres destinos principales:
/// Proyectos, Etiquetas y Buscar (RF7).
class BarraNavegacion extends StatelessWidget {
  final int indiceSeleccionado;
  final ValueChanged<int> alCambiar;

  const BarraNavegacion({
    super.key,
    required this.indiceSeleccionado,
    required this.alCambiar,
  });

  @override
  Widget build(BuildContext context) {
    final paleta = Paleta.of(context);
    return BottomNavigationBar(
      backgroundColor: paleta.fondo,
      selectedItemColor: paleta.doradoTexto,
      unselectedItemColor: paleta.textoSuave,
      type: BottomNavigationBarType.fixed,
      currentIndex: indiceSeleccionado,
      onTap: alCambiar,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.folder_outlined),
          activeIcon: Icon(Icons.folder),
          label: 'Proyectos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sell_outlined),
          activeIcon: Icon(Icons.sell),
          label: 'Etiquetas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          activeIcon: Icon(Icons.manage_search),
          label: 'Buscar',
        ),
      ],
    );
  }
}
