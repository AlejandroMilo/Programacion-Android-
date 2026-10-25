import 'categoria_servicio.dart';
import 'servicio.dart';

/// Estilista del salon (solo lectura desde la app).
class Estilista {
  const Estilista({
    required this.id,
    required this.nombre,
    required this.avatar,
    required this.servicioIds,
  });

  final String id;
  final String nombre;
  final String avatar;
  final List<String> servicioIds;

  String get iniciales {
    final partes = nombre.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty) return '?';
    if (partes.length == 1) return partes.first.substring(0, 1).toUpperCase();
    return (partes.first.substring(0, 1) + partes[1].substring(0, 1))
        .toUpperCase();
  }

  /// Solo el nombre de pila: asi aparece en la agenda y en el detalle.
  String get nombreCorto {
    final partes = nombre.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty) return nombre;
    return partes.first;
  }

  /// Inicial que aparece en el avatar del diseno.
  String get inicial {
    final partes = nombre.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty) return '?';
    return partes.first.substring(0, 1).toUpperCase();
  }

  bool realiza(String servicioId) => servicioIds.contains(servicioId);

  /// Un estilista solo puede recibir turnos con servicios que realiza.
  bool realizaTodos(Iterable<String> ids) => ids.every(realiza);

  /// Categorias que cubre, para mostrarlas agrupadas con Wrap.
  Set<CategoriaServicio> categoriasDe(List<Servicio> catalogo) {
    final categorias = <CategoriaServicio>{};
    for (final servicio in catalogo) {
      if (realiza(servicio.id)) categorias.add(servicio.categoria);
    }
    return categorias;
  }
}
