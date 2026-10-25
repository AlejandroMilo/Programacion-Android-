import 'package:flutter/material.dart';

import '../datos/almacen_turnos.dart';
import '../modelos_vista/modelo_vista_tema.dart';

/// Acceso al estado compartido de la app (datos y tema) desde cualquier vista.
class AlcanceTurnos extends InheritedWidget {
  const AlcanceTurnos({
    super.key,
    required this.store,
    required this.tema,
    required super.child,
  });

  final AlmacenTurnos store;
  final ModeloVistaTema tema;

  static AlcanceTurnos of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AlcanceTurnos>();
    assert(scope != null, 'AlcanceTurnos no encontrado en el arbol de widgets');
    return scope!;
  }

  static AlmacenTurnos storeDe(BuildContext context) => of(context).store;

  static ModeloVistaTema temaDe(BuildContext context) => of(context).tema;

  @override
  bool updateShouldNotify(AlcanceTurnos oldWidget) =>
      store != oldWidget.store || tema != oldWidget.tema;
}
