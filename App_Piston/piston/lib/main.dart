import 'package:flutter/material.dart';

import 'aplicacion.dart';
import 'datos/base_datos.dart';
import 'datos/datos_prueba.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = BaseDatos();
  await SembradorDatos(db).sembrarSiHaceFalta();
  runApp(AplicacionPiston(db: db));
}
