import 'genero.dart';

/// Cliente del salon.
class Cliente {
  const Cliente({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.genero,
    this.correo,
    required this.fechaRegistro,
  });

  final String id;
  final String nombre;
  final String telefono;
  final Genero genero;
  final String? correo;
  final DateTime fechaRegistro;

  String get iniciales {
    final partes = nombre.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty) return '?';
    if (partes.length == 1) return partes.first.substring(0, 1).toUpperCase();
    return (partes.first.substring(0, 1) + partes[1].substring(0, 1))
        .toUpperCase();
  }

  /// Inicial que aparece en el avatar del diseno.
  String get inicial {
    final partes = nombre.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty) return '?';
    return partes.first.substring(0, 1).toUpperCase();
  }

  String get telefonoFormateado {
    if (telefono.length != 8) return telefono;
    return '${telefono.substring(0, 2)} ${telefono.substring(2, 5)} ${telefono.substring(5)}';
  }

  Cliente copyWith({
    String? nombre,
    String? telefono,
    Genero? genero,
    String? correo,
    bool limpiarCorreo = false,
  }) {
    return Cliente(
      id: id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      genero: genero ?? this.genero,
      correo: limpiarCorreo ? null : (correo ?? this.correo),
      fechaRegistro: fechaRegistro,
    );
  }
}
