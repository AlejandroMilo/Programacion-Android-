import 'package:flutter/foundation.dart';

import '../datos/almacen_turnos.dart';
import '../modelos/categoria_servicio.dart';
import '../modelos/estilista.dart';

/// ViewModel de la pantalla Estilistas.
class ModeloVistaEstilistas extends ChangeNotifier {
  ModeloVistaEstilistas(this._store);

  final AlmacenTurnos _store;

  List<Estilista> get estilistas =>
      List<Estilista>.unmodifiable(_store.estilistas);

  int get total => estilistas.length;

  int get turnosHoy =>
      estilistas.fold(0, (total, estilista) => total + turnosDeHoy(estilista));

  String get resumen {
    final turnos = turnosHoy;
    return '$total profesional${total == 1 ? '' : 'es'} · $turnos turno'
        '${turnos == 1 ? '' : 's'} programado${turnos == 1 ? '' : 's'} hoy';
  }

  Set<CategoriaServicio> categoriasDe(Estilista estilista) =>
      estilista.categoriasDe(_store.servicios);

  int turnosDeHoy(Estilista estilista) =>
      _store.turnosDeHoyDeEstilista(estilista.id);

  String turnosDeHoyTexto(Estilista estilista) {
    final cantidad = turnosDeHoy(estilista);
    if (cantidad == 0) return 'Sin turnos hoy';
    return '$cantidad turno${cantidad == 1 ? '' : 's'} programado'
        '${cantidad == 1 ? '' : 's'} hoy';
  }

  void refrescar() => notifyListeners();
}
