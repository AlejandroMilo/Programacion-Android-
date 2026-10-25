import 'package:flutter/foundation.dart';

import '../datos/almacen_turnos.dart';
import '../modelos/turno_vista.dart';

/// ViewModel de la pantalla Detalle de turno.
class ModeloVistaDetalleTurno extends ChangeNotifier {
  ModeloVistaDetalleTurno(this._store, this.turnoId);

  final AlmacenTurnos _store;
  final String turnoId;

  TurnoVista? get vista => _store.vistaDe(turnoId);

  bool get existe => vista != null;

  bool get esEditable => vista?.turno.estado.esEditable ?? false;

  void completar() {
    _store.completarTurno(turnoId);
    notifyListeners();
  }

  void cancelar() {
    _store.cancelarTurno(turnoId);
    notifyListeners();
  }

  void refrescar() => notifyListeners();
}
