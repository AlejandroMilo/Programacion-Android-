import 'package:flutter/foundation.dart';

import '../datos/almacen_turnos.dart';
import '../modelos/cliente.dart';
import '../modelos/filtros.dart';
import '../modelos/genero.dart';
import '../utilidades/texto.dart';

/// ViewModel de la pantalla Clientes.
class ModeloVistaClientes extends ChangeNotifier {
  ModeloVistaClientes(this._store);

  final AlmacenTurnos _store;

  String _busqueda = '';
  FiltroGenero _generoFiltro = FiltroGenero.todos;

  String get busqueda => _busqueda;
  FiltroGenero get generoFiltro => _generoFiltro;

  /// Busqueda por nombre o telefono combinada con el filtro de genero.
  /// Ignora mayusculas, minusculas y acentos.
  List<Cliente> get clientes {
    final busqueda = _busqueda.trim();
    return _store.clientes.where((cliente) {
      final genero = _generoFiltro.genero;
      if (genero != null && cliente.genero != genero) return false;
      if (busqueda.isEmpty) return true;
      return Texto.coincide(cliente.nombre, busqueda) ||
          cliente.telefono.contains(busqueda.replaceAll(' ', ''));
    }).toList();
  }

  /// Total de clientes y total por genero de la lista visible.
  String get resumenTotales {
    final total = clientes.length;
    final mujeres = clientes.where((c) => c.genero == Genero.mujer).length;
    final hombres = total - mujeres;
    return '$total cliente${total == 1 ? '' : 's'} · $mujeres mujer'
        '${mujeres == 1 ? '' : 'es'} · $hombres hombre${hombres == 1 ? '' : 's'}';
  }

  bool get listaVacia => clientes.isEmpty;

  bool get busquedaSinResultados => _busqueda.trim().isNotEmpty;

  int cantidadTurnos(Cliente cliente) =>
      _store.cantidadTurnosDeCliente(cliente.id);

  bool tieneTurnosProgramados(Cliente cliente) =>
      _store.clienteTieneTurnosProgramados(cliente.id);

  void buscar(String valor) {
    if (_busqueda == valor) return;
    _busqueda = valor;
    notifyListeners();
  }

  void filtrarGenero(FiltroGenero filtro) {
    if (_generoFiltro == filtro) return;
    _generoFiltro = filtro;
    notifyListeners();
  }

  void refrescar() => notifyListeners();
}
