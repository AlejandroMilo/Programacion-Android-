import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Utilidades para no guardar contraseñas en texto legible.
class Seguridad {
  const Seguridad._();

  static final Random _random = Random.secure();

  static String generarSal([int longitud = 16]) {
    const caracteres =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
      longitud,
      (_) => caracteres[_random.nextInt(caracteres.length)],
    ).join();
  }

  /// SHA-256 de sal + contraseña. La sal se guarda junto a la cuenta.
  static String hashear(String clave, String sal) {
    return sha256.convert(utf8.encode('$sal:$clave')).toString();
  }

  static bool verificar(String clave, String sal, String hash) {
    return hashear(clave, sal) == hash;
  }
}
