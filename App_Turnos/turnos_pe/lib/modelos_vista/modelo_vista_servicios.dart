import 'package:flutter/foundation.dart';

import '../datos/almacen_turnos.dart';
import '../modelos/categoria_servicio.dart';
import '../modelos/filtros.dart';
import '../modelos/servicio.dart';

/// ViewModel de la pantalla Servicios.
class ModeloVistaServicios extends ChangeNotifier {
  ModeloVistaServicios(this._store);

  final AlmacenTurnos _store;

  CategoriaServicio? _categoriaFiltro;
  FiltroPublico _publicoFiltro = FiltroPublico.todos;

  CategoriaServicio? get categoriaFiltro => _categoriaFiltro;
  FiltroPublico get publicoFiltro => _publicoFiltro;

  List<Servicio> get servicios {
    return _store.servicios.where((servicio) {
      if (_categoriaFiltro != null && servicio.categoria != _categoriaFiltro) {
        return false;
      }
      if (!_publicoFiltro.incluye(servicio.publico)) return false;
      return true;
    }).toList();
  }

  bool get listaVacia => servicios.isEmpty;

  int get total => _store.servicios.length;

  void filtrarCategoria(CategoriaServicio? categoria) {
    if (_categoriaFiltro == categoria) return;
    _categoriaFiltro = categoria;
    notifyListeners();
  }

  void filtrarPublico(FiltroPublico publico) {
    if (_publicoFiltro == publico) return;
    _publicoFiltro = publico;
    notifyListeners();
  }

  void refrescar() => notifyListeners();
}
