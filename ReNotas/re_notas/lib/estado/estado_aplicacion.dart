
import 'package:flutter/material.dart';

import '../modelos/proyecto.dart';
import '../modelos/nota.dart';
import '../modelos/etiqueta.dart';
import '../datos/datos_prueba.dart';

class EstadoAplicacion extends ChangeNotifier {
  final List<Proyecto> _proyectos =
  List<Proyecto>.from(DatosPrueba.proyectos);

  final List<Nota> _notas =
  List<Nota>.from(DatosPrueba.notas);

  final List<Etiqueta> _etiquetas =
  List<Etiqueta>.from(DatosPrueba.etiquetas);

  List<Proyecto> get proyectos => List.unmodifiable(_proyectos);

  List<Nota> get notas => List.unmodifiable(_notas);

  List<Etiqueta> get etiquetas => List.unmodifiable(_etiquetas);

  // Tema claro/oscuro (solo en memoria, se reinicia al cerrar la app).
  bool _modoClaro = false;

  bool get modoClaro => _modoClaro;

  void alternarTema() {
    _modoClaro = !_modoClaro;
    notifyListeners();
  }

  // Orden de la lista de proyectos: 'recientes', 'nombre' o 'notas'.
  String _ordenProyectos = 'recientes';

  String get ordenProyectos => _ordenProyectos;

  void cambiarOrdenProyectos(String orden) {
    if (_ordenProyectos == orden) return;
    _ordenProyectos = orden;
    notifyListeners();
  }

  List<Proyecto> get proyectosOrdenados {
    final lista = List<Proyecto>.from(_proyectos);
    switch (_ordenProyectos) {
      case 'nombre':
        lista.sort(
          (a, b) => normalizarTexto(a.nombre)
              .compareTo(normalizarTexto(b.nombre)),
        );
      case 'notas':
        lista.sort(
          (a, b) => notasDeProyecto(b.id)
              .length
              .compareTo(notasDeProyecto(a.id).length),
        );
      case 'recientes':
      default:
        lista.sort(
          (a, b) => b.fechaModificacion.compareTo(a.fechaModificacion),
        );
    }
    return lista;
  }

  // Último borrado para el Deshacer (solo se guarda una acción).
  _Borrado? _ultimoBorrado;

  /// Qué se puede deshacer: 'proyecto', 'nota', 'etiqueta' o null.
  String? get tipoDeshacer => _ultimoBorrado?.tipo;

  void deshacerBorrado() {
    final borrado = _ultimoBorrado;
    if (borrado == null) return;
    _ultimoBorrado = null;

    if (borrado is _ProyectoBorrado) {
      _proyectos.add(borrado.proyecto);
      _notas.addAll(borrado.notas);
    } else if (borrado is _NotaBorrada) {
      _notas.add(borrado.nota);
    } else if (borrado is _EtiquetaBorrada) {
      _etiquetas.add(borrado.etiqueta);
      for (final nota in _notas) {
        if (borrado.notasAfectadas.contains(nota.id) &&
            !nota.etiquetasIds.contains(borrado.etiqueta.id)) {
          nota.etiquetasIds.add(borrado.etiqueta.id);
        }
      }
    }

    notifyListeners();
  }

  // Genera identificadores únicos para los nuevos elementos.
  String _generarId(String prefijo) {
    return '${prefijo}_${DateTime.now().microsecondsSinceEpoch}';
  }

  // Normaliza nombres para comparar sin distinguir mayúsculas,
  // minúsculas, espacios repetidos ni acentos.
  String normalizarTexto(String texto) {
    const caracteresConAcento =
        'áàäâãåéèëêíìïîóòöôõúùüûñç';
    const caracteresSinAcento =
        'aaaaaaeeeeiiiiooooouuuunc';

    var resultado = texto.trim().toLowerCase();

    for (var i = 0; i < caracteresConAcento.length; i++) {
      resultado = resultado.replaceAll(
        caracteresConAcento[i],
        caracteresSinAcento[i],
      );
    }

    return resultado.replaceAll(RegExp(r'\s+'), ' ');
  }

  // ---------------- PROYECTOS ----------------

  Proyecto? buscarProyectoPorId(String id) {
    for (final proyecto in _proyectos) {
      if (proyecto.id == id) return proyecto;
    }
    return null;
  }

  void agregarProyecto({
    required String nombre,
    required String descripcion,
  }) {
    if (nombre.trim().isEmpty) {
      throw ArgumentError('El nombre del proyecto es obligatorio.');
    }

    _proyectos.add(
      Proyecto(
        id: _generarId('proyecto'),
        nombre: nombre.trim(),
        descripcion: descripcion.trim(),
      ),
    );

    notifyListeners();
  }

  void editarProyecto({
    required String id,
    required String nombre,
    required String descripcion,
  }) {
    if (nombre.trim().isEmpty) {
      throw ArgumentError('El nombre del proyecto es obligatorio.');
    }

    final proyecto = buscarProyectoPorId(id);
    if (proyecto == null) return;

    proyecto.actualizar(
      nuevoNombre: nombre,
      nuevaDescripcion: descripcion,
    );

    notifyListeners();
  }


  void eliminarProyecto(String id) {
    final proyecto = buscarProyectoPorId(id);
    final notasEliminadas =
        _notas.where((nota) => nota.proyectoId == id).toList();

    _proyectos.removeWhere((proyecto) => proyecto.id == id);

    // También elimina las notas que pertenecían al proyecto.
    _notas.removeWhere((nota) => nota.proyectoId == id);

    // Guarda el borrado para el Deshacer.
    _ultimoBorrado = proyecto == null
        ? null
        : _ProyectoBorrado(
            proyecto: proyecto,
            notas: notasEliminadas,
          );

    // Las etiquetas NO se eliminan: son globales y pueden seguir siendo
    // útiles para otras notas o para crear nuevas. Solo se borran de forma
    // explícita desde la pantalla de Etiquetas.
    notifyListeners();
  }

  // ---------------- NOTAS ----------------

  Nota? buscarNotaPorId(String id) {
    for (final nota in _notas) {
      if (nota.id == id) return nota;
    }
    return null;
  }

  List<Nota> notasDeProyecto(String proyectoId) {
    final lista = _notas
        .where((nota) => nota.proyectoId == proyectoId)
        .toList();
    lista.sort(compararNotas);
    return lista;
  }

  /// Fijadas primero y luego las más recientes.
  static int compararNotas(Nota a, Nota b) {
    if (a.fija != b.fija) return a.fija ? -1 : 1;
    if (a.esFavorita != b.esFavorita) return a.esFavorita ? -1 : 1;
    return b.fechaModificacion.compareTo(a.fechaModificacion);
  }

  void agregarNota({
    required String proyectoId,
    required String titulo,
    String descripcion = '',
    List<String> etiquetasIds = const [],
  }) {
    if (titulo.trim().isEmpty) {
      throw ArgumentError('El título de la nota es obligatorio.');
    }

    if (buscarProyectoPorId(proyectoId) == null) {
      throw ArgumentError('El proyecto seleccionado no existe.');
    }

    _notas.add(
      Nota(
        id: _generarId('nota'),
        proyectoId: proyectoId,
        titulo: titulo.trim(),
        descripcion: descripcion,
        etiquetasIds: _filtrarEtiquetasExistentes(etiquetasIds),
      ),
    );

    notifyListeners();
  }

  void editarNota({
    required String id,
    required String titulo,
    required String descripcion,
    required List<String> etiquetasIds,
  }) {
    if (titulo.trim().isEmpty) {
      throw ArgumentError('El título de la nota es obligatorio.');
    }

    final nota = buscarNotaPorId(id);
    if (nota == null) return;

    nota.actualizar(
      nuevoTitulo: titulo,
      nuevaDescripcion: descripcion,
      nuevasEtiquetasIds: _filtrarEtiquetasExistentes(etiquetasIds),
    );

    notifyListeners();
  }

  void eliminarNota(String id) {
    final indice = _notas.indexWhere((nota) => nota.id == id);
    final eliminada = indice == -1 ? null : _notas[indice];

    _notas.removeWhere((nota) => nota.id == id);

    _ultimoBorrado =
        eliminada == null ? null : _NotaBorrada(nota: eliminada);

    // Las etiquetas se mantienen aunque ninguna nota las use: solo se
    // eliminan de forma explícita desde la pantalla de Etiquetas.
    notifyListeners();
  }

  void alternarFavorita(String id) {
    final nota = buscarNotaPorId(id);
    if (nota == null) return;

    nota.alternarFavorita();
    notifyListeners();
  }

  void alternarFija(String id) {
    final nota = buscarNotaPorId(id);
    if (nota == null) return;

    nota.alternarFija();
    notifyListeners();
  }

  List<String> _filtrarEtiquetasExistentes(List<String> ids) {
    final idsExistentes = _etiquetas.map((etiqueta) => etiqueta.id).toSet();

    return ids.where(idsExistentes.contains).toSet().toList();
  }

  // ---------------- ETIQUETAS ----------------

  Etiqueta? buscarEtiquetaPorId(String id) {
    for (final etiqueta in _etiquetas) {
      if (etiqueta.id == id) return etiqueta;
    }
    return null;
  }

  Etiqueta? buscarEtiquetaPorNombre(String nombre) {
    final nombreNormalizado = normalizarTexto(nombre);

    for (final etiqueta in _etiquetas) {
      if (normalizarTexto(etiqueta.nombre) == nombreNormalizado) {
        return etiqueta;
      }
    }

    return null;
  }

  Etiqueta crearEtiqueta(
      String nombre, {
        Color color = const Color(0xFF75162D),
      }) {
    if (nombre.trim().isEmpty) {
      throw ArgumentError('El nombre de la etiqueta es obligatorio.');
    }

    final existente = buscarEtiquetaPorNombre(nombre);
    if (existente != null) return existente;

    final etiqueta = Etiqueta(
      id: _generarId('etiqueta'),
      nombre: nombre.trim(),
      color: color,
    );

    _etiquetas.add(etiqueta);
    notifyListeners();

    return etiqueta;
  }

  void renombrarEtiqueta({
    required String id,
    required String nuevoNombre,
  }) {
    if (nuevoNombre.trim().isEmpty) {
      throw ArgumentError('El nombre de la etiqueta es obligatorio.');
    }

    final etiqueta = buscarEtiquetaPorId(id);
    if (etiqueta == null) return;

    final existente = buscarEtiquetaPorNombre(nuevoNombre);

    if (existente != null && existente.id != id) {
      throw ArgumentError('Ya existe una etiqueta con ese nombre.');
    }

    etiqueta.renombrar(nuevoNombre);
    notifyListeners();
  }

  void cambiarColorEtiqueta({
    required String id,
    required Color color,
  }) {
    final etiqueta = buscarEtiquetaPorId(id);
    if (etiqueta == null) return;

    etiqueta.color = color;
    notifyListeners();
  }

  void eliminarEtiqueta(String id) {
    final etiqueta = buscarEtiquetaPorId(id);
    final afectadas = _notas
        .where((nota) => nota.etiquetasIds.contains(id))
        .map((nota) => nota.id)
        .toList();

    _etiquetas.removeWhere((etiqueta) => etiqueta.id == id);

    for (final nota in _notas) {
      nota.etiquetasIds.remove(id);
    }

    _ultimoBorrado = etiqueta == null
        ? null
        : _EtiquetaBorrada(
            etiqueta: etiqueta,
            notasAfectadas: afectadas,
          );

    notifyListeners();
  }

  // ---------------- BÚSQUEDA ----------------

  /// Busca notas por texto, por proyecto y por etiquetas.
  ///
  /// [modoTodas] decide cómo se combinan las etiquetas seleccionadas:
  /// `true` devuelve las notas que tienen **todas** las etiquetas elegidas
  /// y `false` las que tienen **al menos una**.
  List<Nota> buscarNotas({
    String consulta = '',
    String? proyectoId,
    List<String> etiquetasIds = const [],
    bool modoTodas = true,
    bool soloFavoritas = false,
  }) {
    final texto = normalizarTexto(consulta);

    return _notas.where((nota) {
      final coincideProyecto =
          proyectoId == null || nota.proyectoId == proyectoId;

      final coincideFavorita = !soloFavoritas || nota.esFavorita;

      final textoNota = normalizarTexto(
        '${nota.titulo} ${nota.descripcion}',
      );

      final coincideTexto =
          texto.isEmpty || textoNota.contains(texto);

      final bool coincideEtiquetas;
      if (etiquetasIds.isEmpty) {
        coincideEtiquetas = true;
      } else if (modoTodas) {
        coincideEtiquetas = etiquetasIds.every(
          (id) => nota.etiquetasIds.contains(id),
        );
      } else {
        coincideEtiquetas = etiquetasIds.any(
          (id) => nota.etiquetasIds.contains(id),
        );
      }

      return coincideProyecto &&
          coincideFavorita &&
          coincideTexto &&
          coincideEtiquetas;
    }).toList()
      ..sort(compararNotas);
  }

  /// Devuelve las etiquetas que aparecen en al menos una nota del proyecto.
  /// Es el conjunto de etiquetas válidas para filtrar dentro de ese proyecto.
  List<Etiqueta> etiquetasDeProyecto(String proyectoId) {
    final idsEnUso = _notas
        .where((nota) => nota.proyectoId == proyectoId)
        .expand((nota) => nota.etiquetasIds)
        .toSet();

    return _etiquetas
        .where((etiqueta) => idsEnUso.contains(etiqueta.id))
        .toList();
  }

  /// Devuelve el nombre del proyecto de una nota, o un texto de respaldo.
  String nombreProyectoDe(Nota nota) {
    final proyecto = buscarProyectoPorId(nota.proyectoId);
    return proyecto?.nombre ?? 'Proyecto eliminado';
  }

  List<Etiqueta> etiquetasDeNota(Nota nota) {
    return _etiquetas
        .where((etiqueta) => nota.etiquetasIds.contains(etiqueta.id))
        .toList();
  }

  List<Nota> notasDeEtiqueta(String etiquetaId) {
    return _notas
        .where((nota) => nota.etiquetasIds.contains(etiquetaId))
        .toList()
      ..sort(compararNotas);
  }
}

/// Último borrado, guardado para el Deshacer.
sealed class _Borrado {
  String get tipo;
}

class _ProyectoBorrado extends _Borrado {
  final Proyecto proyecto;
  final List<Nota> notas;

  _ProyectoBorrado({required this.proyecto, required this.notas});

  @override
  String get tipo => 'proyecto';
}

class _NotaBorrada extends _Borrado {
  final Nota nota;

  _NotaBorrada({required this.nota});

  @override
  String get tipo => 'nota';
}

class _EtiquetaBorrada extends _Borrado {
  final Etiqueta etiqueta;
  final List<String> notasAfectadas;

  _EtiquetaBorrada({
    required this.etiqueta,
    required this.notasAfectadas,
  });

  @override
  String get tipo => 'etiqueta';
}
