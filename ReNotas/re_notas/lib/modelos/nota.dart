
class Nota {
  final String id;
  final String proyectoId;
  String titulo;
  String descripcion;
  final DateTime fechaCreacion;
  DateTime fechaModificacion;
  final List<String> etiquetasIds;
  bool esFavorita;
  bool fija;

  Nota({
    required this.id,
    required this.proyectoId,
    required this.titulo,
    this.descripcion = '',
    DateTime? fechaCreacion,
    DateTime? fechaModificacion,
    List<String> etiquetasIds = const [],
    this.esFavorita = false,
    this.fija = false,
  })  : fechaCreacion = fechaCreacion ?? DateTime.now(),
        fechaModificacion = fechaModificacion ?? DateTime.now(),
        etiquetasIds = List<String>.from(etiquetasIds);

  void actualizar({
    required String nuevoTitulo,
    required String nuevaDescripcion,
    required List<String> nuevasEtiquetasIds,
  }) {
    titulo = nuevoTitulo.trim();
    descripcion = nuevaDescripcion;
    etiquetasIds
      ..clear()
      ..addAll(nuevasEtiquetasIds.toSet());
    fechaModificacion = DateTime.now();
  }

  void alternarFavorita() {
    esFavorita = !esFavorita;
  }

  void alternarFija() {
    fija = !fija;
  }
}
