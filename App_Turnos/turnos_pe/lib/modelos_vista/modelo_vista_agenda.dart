import 'package:flutter/foundation.dart';

import '../datos/almacen_turnos.dart';
import '../modelos/filtros.dart';
import '../modelos/reglas_turno.dart';
import '../modelos/turno_vista.dart';

/// ViewModel de la pantalla Agenda.
class ModeloVistaAgenda extends ChangeNotifier {
  ModeloVistaAgenda(this._store, {DateTime? fecha})
    : _fecha = ReglasTurno.soloFecha(fecha ?? DateTime.now());

  final AlmacenTurnos _store;

  DateTime _fecha;
  String? _estilistaFiltro;
  FiltroEstado _estadoFiltro = FiltroEstado.todos;

  DateTime get fecha => _fecha;
  String? get estilistaFiltro => _estilistaFiltro;
  FiltroEstado get estadoFiltro => _estadoFiltro;

  /// Lunes de la semana de la fecha seleccionada.
  DateTime get inicioSemana => ReglasTurno.soloFecha(
    _fecha.subtract(Duration(days: _fecha.weekday - DateTime.monday)),
  );

  /// Tira horizontal con los siete dias de la semana.
  List<DateTime> get diasDeLaSemana => List<DateTime>.generate(
    7,
    (indice) => inicioSemana.add(Duration(days: indice)),
  );

  bool get domingoCerrado => ReglasTurno.esDomingo(_fecha);

  ResumenDia get resumen => _store.resumenDelDia(_fecha);

  List<TurnoVista> get turnos {
    var lista = _store.turnosDelDia(_fecha);
    if (_estilistaFiltro != null) {
      lista = lista
          .where((vista) => vista.turno.estilistaId == _estilistaFiltro)
          .toList();
    }
    final estado = _estadoFiltro.estado;
    if (estado != null) {
      lista = lista.where((vista) => vista.turno.estado == estado).toList();
    }
    return lista;
  }

  /// Estilistas que tienen turnos el dia seleccionado (para los chips).
  List<String> get estilistasDelDia {
    final ids = <String>[];
    for (final vista in _store.turnosDelDia(_fecha)) {
      if (!ids.contains(vista.estilista.id)) ids.add(vista.estilista.id);
    }
    return ids;
  }

  void seleccionarFecha(DateTime fecha) {
    final nueva = ReglasTurno.soloFecha(fecha);
    if (nueva == _fecha) return;
    _fecha = nueva;
    notifyListeners();
  }

  void irSemanaAnterior() =>
      seleccionarFecha(_fecha.subtract(const Duration(days: 7)));

  void irSemanaSiguiente() =>
      seleccionarFecha(_fecha.add(const Duration(days: 7)));

  void filtrarEstilista(String? estilistaId) {
    if (_estilistaFiltro == estilistaId) return;
    _estilistaFiltro = estilistaId;
    notifyListeners();
  }

  void filtrarEstado(FiltroEstado filtro) {
    if (_estadoFiltro == filtro) return;
    _estadoFiltro = filtro;
    notifyListeners();
  }

  /// Aplica el filtro recibido por parametro de consulta (`/agenda?estilista=3`).
  void aplicarParametroEstilista(String? estilistaId) {
    if (estilistaId == null || estilistaId.isEmpty) return;
    filtrarEstilista(estilistaId);
  }

  void completar(String turnoId) {
    _store.completarTurno(turnoId);
  }

  void cancelar(String turnoId) {
    _store.cancelarTurno(turnoId);
  }

  bool get hayTurnos => turnos.isNotEmpty;

  bool get sinResultadosPorFiltros =>
      turnos.isEmpty &&
      (_estilistaFiltro != null || _estadoFiltro != FiltroEstado.todos);

  void refrescar() => notifyListeners();
}
