enum TipoRecurso { video, lectura, practica, documento }

enum NivelRecurso { basico, intermedio, avanzado }

class RecursoEstudio {
  final String id;
  final String titulo;
  final String categoria;
  final String autor;
  final int duracionMinutos;
  final NivelRecurso nivel;
  final String descripcion;
  final TipoRecurso tipo;
  final int color;

  const RecursoEstudio({
    required this.id,
    required this.titulo,
    required this.categoria,
    required this.autor,
    required this.duracionMinutos,
    required this.nivel,
    required this.descripcion,
    required this.tipo,
    required this.color,
  });
}
