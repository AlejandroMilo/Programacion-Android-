import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../componentes/componentes.dart';

/// Contenedor de las cuatro pestanas con su barra de navegacion inferior.
class VistaShell extends StatelessWidget {
  const VistaShell({super.key, required this.navegacion});

  final StatefulNavigationShell navegacion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navegacion,
      bottomNavigationBar: BarraNavegacion(
        indice: navegacion.currentIndex,
        onSeleccionar: (indice) => navegacion.goBranch(
          indice,
          initialLocation: indice == navegacion.currentIndex,
        ),
      ),
    );
  }
}
