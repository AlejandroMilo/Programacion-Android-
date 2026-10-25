/// Genero de una persona (cliente o publico objetivo de un servicio).
enum Genero {
  mujer,
  hombre;

  String get etiqueta => switch (this) {
    Genero.mujer => 'Mujer',
    Genero.hombre => 'Hombre',
  };

  String get plural => switch (this) {
    Genero.mujer => 'Mujeres',
    Genero.hombre => 'Hombres',
  };
}
