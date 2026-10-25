/// Categorias del catalogo de servicios.
enum CategoriaServicio {
  corte,
  color,
  barba,
  peinado,
  tratamiento;

  String get etiqueta => switch (this) {
    CategoriaServicio.corte => 'Corte',
    CategoriaServicio.color => 'Color',
    CategoriaServicio.barba => 'Barba',
    CategoriaServicio.peinado => 'Peinado',
    CategoriaServicio.tratamiento => 'Tratamiento',
  };

  String get titulo => etiqueta.toUpperCase();

  /// Icono de la categoria tal y como aparece en el diseno.
  String get rutaIcono => 'assets/imagenes/icono_$name.png';
}


