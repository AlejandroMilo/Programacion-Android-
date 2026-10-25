import 'genero.dart';

/// Publico al que se dirige un servicio.
enum Publico {
  mujeres,
  hombres,
  unisex;

  String get etiqueta => switch (this) {
    Publico.mujeres => 'Mujeres',
    Publico.hombres => 'Hombres',
    Publico.unisex => 'Unisex',
  };

  /// Un servicio unisex sirve a los dos generos.
  bool sirveA(Genero genero) => switch (this) {
    Publico.unisex => true,
    Publico.mujeres => genero == Genero.mujer,
    Publico.hombres => genero == Genero.hombre,
  };
}
