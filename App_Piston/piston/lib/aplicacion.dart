import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'aplicacion/preferencias.dart';
import 'aplicacion/sesion.dart';
import 'datos/base_datos.dart';
import 'utilidades/tema.dart';
import 'vistas/autenticacion/pantalla_bienvenida.dart';
import 'vistas/mas/pantalla_shell.dart';

class AplicacionPiston extends StatefulWidget {
  const AplicacionPiston({super.key, required this.db});

  final BaseDatos db;

  @override
  State<AplicacionPiston> createState() => _AplicacionPistonState();
}

class _AplicacionPistonState extends State<AplicacionPiston> {
  late final Sesion _sesion;
  late final Preferencias _preferencias;

  @override
  void initState() {
    super.initState();
    _sesion = Sesion(widget.db);
    _preferencias = Preferencias(widget.db.configuracionDao);
    _preferencias.cargar();
  }

  @override
  void dispose() {
    _sesion.dispose();
    _preferencias.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<BaseDatos>.value(value: widget.db),
        ChangeNotifierProvider<Sesion>.value(value: _sesion),
        ChangeNotifierProvider<Preferencias>.value(value: _preferencias),
      ],
      child: Consumer<Preferencias>(
        builder: (context, preferencias, _) {
          return MaterialApp(
            title: 'El Pistón',
            debugShowCheckedModeBanner: false,
            theme: TemaApp.claro(),
            darkTheme: TemaApp.oscuro(),
            themeMode: preferencias.modo,
            home: Consumer<Sesion>(
              builder: (context, sesion, _) {
                if (sesion.autenticado) return const PantallaShell();
                return const PantallaBienvenida();
              },
            ),
          );
        },
      ),
    );
  }
}
