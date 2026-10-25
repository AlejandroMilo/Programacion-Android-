/// Utilidades de texto para busquedas que ignoran mayusculas, minusculas y acentos.
class Texto {
  const Texto._();

  static const Map<String, String> _acentos = {
    'á': 'a',
    'à': 'a',
    'ä': 'a',
    'â': 'a',
    'é': 'e',
    'è': 'e',
    'ë': 'e',
    'ê': 'e',
    'í': 'i',
    'ì': 'i',
    'ï': 'i',
    'î': 'i',
    'ó': 'o',
    'ò': 'o',
    'ö': 'o',
    'ô': 'o',
    'ú': 'u',
    'ù': 'u',
    'ü': 'u',
    'û': 'u',
    'ñ': 'n',
    'ç': 'c',
  };

  /// minusculas, sin acentos y con espacios normalizados.
  static String normalizar(String valor) {
    final buffer = StringBuffer();
    for (final caracter in valor.toLowerCase().split('')) {
      buffer.write(_acentos[caracter] ?? caracter);
    }
    return buffer.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static bool coincide(String texto, String busqueda) =>
      normalizar(texto).contains(normalizar(busqueda));
}
