
class Proyecto {
  final String id;
  String nombre;
  String descripcion;
  final DateTime fechaCreacion;
  DateTime fechaModificacion;

  Proyecto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    DateTime? fechaCreacion,
    DateTime? fechaModificacion,
  })  : fechaCreacion = fechaCreacion ?? DateTime.now(),
        fechaModificacion = fechaModificacion ?? DateTime.now();

  void actualizar({
    required String nuevoNombre,
    required String nuevaDescripcion,
  }) {
    nombre = nuevoNombre.trim();
    descripcion = nuevaDescripcion.trim();
    fechaModificacion = DateTime.now();
  }
}
