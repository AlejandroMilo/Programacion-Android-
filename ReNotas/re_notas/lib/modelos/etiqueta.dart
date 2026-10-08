
import 'package:flutter/material.dart';

class Etiqueta {
  final String id;
  String nombre;
  Color color;

  Etiqueta({
    required this.id,
    required this.nombre,
    this.color = const Color(0xFF75162D),
  });

  // Se elimina un getter "nombreNormalizado" que estaba sin usar y que no
  // eliminaba los acentos. La comparación real de nombres se hace siempre
  // con EstadoAplicacion.normalizarTexto, que sí ignora mayúsculas,
  // acentos y espacios.

  void renombrar(String nuevoNombre) {
    nombre = nuevoNombre.trim();
  }
}
