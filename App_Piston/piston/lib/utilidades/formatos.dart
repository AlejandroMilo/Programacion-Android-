/// Formatos de moneda, fechas y kilometraje usados en toda la app.
class Formatos {
  const Formatos._();

  static const List<String> _meses = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];

  static const List<String> _dias = [
    'lunes',
    'martes',
    'miércoles',
    'jueves',
    'viernes',
    'sábado',
    'domingo',
  ];

  static String dinero(double valor) {
    final entero = valor.round();
    final texto = entero.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < texto.length; i++) {
      final restante = texto.length - i;
      buffer.write(texto[i]);
      if (restante > 1 && restante % 3 == 1) buffer.write(',');
    }
    return '\$${buffer.toString()}';
  }

  static String dineroExacto(double valor) => '\$${valor.toStringAsFixed(2)}';

  static String fecha(DateTime valor) =>
      '${valor.day.toString().padLeft(2, '0')}/${valor.month.toString().padLeft(2, '0')}/${valor.year}';

  static String fechaHora(DateTime valor) =>
      '${fecha(valor)} ${hora(valor)}';

  static String hora(DateTime valor) =>
      '${valor.hour.toString().padLeft(2, '0')}:${valor.minute.toString().padLeft(2, '0')}';

  static String fechaLarga(DateTime valor) =>
      '${_dias[valor.weekday - 1]} ${valor.day} de ${_meses[valor.month - 1]} de ${valor.year}';

  static String diaMes(DateTime valor) =>
      '${valor.day.toString().padLeft(2, '0')}/${valor.month.toString().padLeft(2, '0')}';

  static String mesCorto(DateTime valor) {
    final nombre = _meses[valor.month - 1];
    return '${nombre[0].toUpperCase()}${nombre.substring(1).padLeft(3, '.').substring(0, 3)}';
  }

  static String kilometraje(int valor) {
    final texto = valor.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < texto.length; i++) {
      final restante = texto.length - i;
      buffer.write(texto[i]);
      if (restante > 1 && restante % 3 == 1) buffer.write('.');
    }
    return '$buffer km';
  }

  static String haceCuanto(DateTime valor) {
    final diferencia = DateTime.now().difference(valor);
    if (diferencia.inMinutes < 1) return 'ahora';
    if (diferencia.inHours < 1) return 'hace ${diferencia.inMinutes} min';
    if (diferencia.inDays < 1) return 'hace ${diferencia.inHours} h';
    if (diferencia.inDays == 1) return 'ayer';
    if (diferencia.inDays < 7) return 'hace ${diferencia.inDays} días';
    return fecha(valor);
  }

  static String rango(DateTime desde, DateTime hasta) =>
      '${fecha(desde)} — ${fecha(hasta)}';
}
