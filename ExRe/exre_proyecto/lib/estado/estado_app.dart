import 'package:exre_proyecto/datos/recurso.dart';
import 'package:flutter/material.dart';
import 'package:exre_proyecto/modelos/recursos_estudiados.dart';

class EstadoApp extends ChangeNotifier {
  // ============================================================
  // RECURSOS
  // ============================================================

  final List<RecursoEstudio> listaRecursos = recursos;

  // ============================================================
  // FAVORITOS
  // ============================================================

  final Set<String> idsFavoritos = <String>{};

  // ============================================================
  // RECURSOS COMPLETADOS
  // ============================================================

  final Set<String> idsCompletados = <String>{};

  // ============================================================
  // BÚSQUEDA
  // ============================================================

  String textoBusqueda = '';

  // ============================================================
  // CATEGORÍA SELECCIONADA
  // ============================================================

  String categoriaSeleccionada = 'Todas';

  // ============================================================
  // RECURSO SELECCIONADO
  // ============================================================

  String? idRecursoSeleccionado;

  // ============================================================
  // CICLO DE VIDA
  // ============================================================

  AppLifecycleState ultimoEstado = AppLifecycleState.resumed;

  final List<AppLifecycleState> historialEstados = <AppLifecycleState>[];

  // ============================================================
  // CATEGORÍAS
  // ============================================================

  List<String> get categorias {
    final Set<String> categoriasEncontradas = <String>{};

    for (final RecursoEstudio recurso in listaRecursos) {
      categoriasEncontradas.add(recurso.categoria);
    }

    return <String>['Todas', ...categoriasEncontradas];
  }

  // ============================================================
  // RECURSOS FILTRADOS
  // ============================================================

  List<RecursoEstudio> get recursosFiltrados {
    final String busqueda = textoBusqueda.trim().toLowerCase();

    return listaRecursos.where((RecursoEstudio recurso) {
      final bool coincideCategoria =
          categoriaSeleccionada == 'Todas' ||
          recurso.categoria == categoriaSeleccionada;

      final bool coincideBusqueda =
          busqueda.isEmpty ||
          recurso.titulo.toLowerCase().contains(busqueda) ||
          recurso.categoria.toLowerCase().contains(busqueda) ||
          recurso.autor.toLowerCase().contains(busqueda);

      return coincideCategoria && coincideBusqueda;
    }).toList();
  }

  // ============================================================
  // FAVORITOS
  // ============================================================

  List<RecursoEstudio> get recursosFavoritos {
    return listaRecursos
        .where((RecursoEstudio recurso) => idsFavoritos.contains(recurso.id))
        .toList();
  }

  bool esFavorito(String id) {
    return idsFavoritos.contains(id);
  }

  void cambiarFavorito(String id) {
    if (idsFavoritos.contains(id)) {
      idsFavoritos.remove(id);
    } else {
      idsFavoritos.add(id);
    }

    notifyListeners();
  }
  // ============================================================
  // COMPLETADOS
  // ============================================================

  List<RecursoEstudio> get recursosCompletados {
    return listaRecursos
        .where((RecursoEstudio recurso) => idsCompletados.contains(recurso.id))
        .toList();
  }

  List<RecursoEstudio> get recursosPendientes {
    return listaRecursos
        .where((RecursoEstudio recurso) => !idsCompletados.contains(recurso.id))
        .toList();
  }

  bool estaCompletado(String id) {
    return idsCompletados.contains(id);
  }

  void cambiarCompletado(String id) {
    if (idsCompletados.contains(id)) {
      idsCompletados.remove(id);
    } else {
      idsCompletados.add(id);
    }

    notifyListeners();
  }

  // ============================================================
  // ESTADÍSTICAS
  // ============================================================

  int get cantidadRecursos {
    return listaRecursos.length;
  }

  int get cantidadFavoritos {
    return idsFavoritos.length;
  }

  int get cantidadCompletados {
    return idsCompletados.length;
  }

  int get cantidadPendientes {
    return listaRecursos.length - idsCompletados.length;
  }

  double get porcentajeCompletado {
    if (listaRecursos.isEmpty) {
      return 0.0;
    }

    return idsCompletados.length / listaRecursos.length;
  }

  // ============================================================
  // BÚSQUEDA
  // ============================================================

  void cambiarTextoBusqueda(String texto) {
    textoBusqueda = texto;
    notifyListeners();
  }

  void limpiarBusqueda() {
    textoBusqueda = '';
    notifyListeners();
  }

  // ============================================================
  // CATEGORÍA
  // ============================================================

  void cambiarCategoria(String categoria) {
    categoriaSeleccionada = categoria;
    notifyListeners();
  }

  // ============================================================
  // RECURSO SELECCIONADO
  // ============================================================

  void seleccionarRecurso(String id) {
    idRecursoSeleccionado = id;
    notifyListeners();
  }

  RecursoEstudio? get recursoSeleccionado {
    if (idRecursoSeleccionado == null) {
      return null;
    }

    for (final RecursoEstudio recurso in listaRecursos) {
      if (recurso.id == idRecursoSeleccionado) {
        return recurso;
      }
    }

    return null;
  }

  // ============================================================
  // CICLO DE VIDA
  // ============================================================

  void registrarEstado(AppLifecycleState estado) {
    ultimoEstado = estado;

    historialEstados.insert(0, estado);

    if (historialEstados.length > 10) {
      historialEstados.removeLast();
    }

    notifyListeners();
  }

  // ============================================================
  // NOMBRE DEL ESTADO DEL CICLO DE VIDA
  // ============================================================

  String get nombreEstado {
    switch (ultimoEstado) {
      case AppLifecycleState.resumed:
        return 'Activa';

      case AppLifecycleState.inactive:
        return 'Inactiva';

      case AppLifecycleState.hidden:
        return 'Oculta';

      case AppLifecycleState.paused:
        return 'En pausa';

      case AppLifecycleState.detached:
        return 'Desconectada';
    }
  }
}
