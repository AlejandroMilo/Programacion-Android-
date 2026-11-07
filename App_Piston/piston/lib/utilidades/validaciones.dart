/// Validaciones de formularios. Devuelven null si el valor es correcto.
class Validaciones {
  const Validaciones._();

  static String? requerido(String? valor, {String campo = 'Este campo'}) {
    if (valor == null || valor.trim().isEmpty) return '$campo es obligatorio';
    return null;
  }

  static String? nombre(String? valor) {
    final base = requerido(valor, campo: 'El nombre');
    if (base != null) return base;
    if (valor!.trim().length < 2) return 'El nombre es demasiado corto';
    return null;
  }

  static String? telefono(String? valor) {
    final base = requerido(valor, campo: 'El teléfono');
    if (base != null) return base;
    final limpio = valor!.replaceAll(RegExp(r'[^0-9+]'), '');
    if (limpio.length < 7) return 'Ingresa un teléfono válido';
    return null;
  }

  static String? matricula(String? valor) {
    final base = requerido(valor, campo: 'La matrícula');
    if (base != null) return base;
    if (valor!.trim().length < 3) return 'La matrícula es demasiado corta';
    return null;
  }

  static String? anio(String? valor) {
    final base = requerido(valor, campo: 'El año');
    if (base != null) return base;
    final numero = int.tryParse(valor!);
    final actual = DateTime.now().year + 1;
    if (numero == null || numero < 1950 || numero > actual) {
      return 'Año entre 1950 y $actual';
    }
    return null;
  }

  static String? entero(String? valor, {String campo = 'El valor'}) {
    final base = requerido(valor, campo: campo);
    if (base != null) return base;
    if (int.tryParse(valor!) == null) return '$campo debe ser un número entero';
    return null;
  }

  static String? monto(String? valor, {String campo = 'El importe'}) {
    final base = requerido(valor, campo: campo);
    if (base != null) return base;
    final numero = double.tryParse(valor!.replaceAll(',', '.'));
    if (numero == null) return '$campo debe ser un número';
    if (numero <= 0) return '$campo debe ser mayor que cero';
    return null;
  }

  static String? usuario(String? valor) {
    final base = requerido(valor, campo: 'El usuario');
    if (base != null) return base;
    if (valor!.trim().length < 3) return 'El usuario debe tener 3 caracteres';
    if (!RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(valor)) {
      return 'Solo letras, números, punto, guion y guion bajo';
    }
    return null;
  }

  static String? clave(String? valor) {
    final base = requerido(valor, campo: 'La contraseña');
    if (base != null) return base;
    if (valor!.length < 6) return 'La contraseña debe tener 6 caracteres';
    return null;
  }
}
