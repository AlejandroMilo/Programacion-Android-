import 'package:flutter/material.dart';

/// Abre una pantalla con una transición suave y consistente.
Future<T?> abrirPantalla<T>(BuildContext context, Widget pantalla) {
  return Navigator.of(context).push<T>(
    MaterialPageRoute<T>(builder: (_) => pantalla),
  );
}

/// Abre una pantalla sustituyendo la actual (por ejemplo, tras iniciar sesión).
Future<T?> reemplazarPantalla<T>(BuildContext context, Widget pantalla) {
  return Navigator.of(context).pushReplacement<T, T>(
    MaterialPageRoute<T>(builder: (_) => pantalla),
  );
}
