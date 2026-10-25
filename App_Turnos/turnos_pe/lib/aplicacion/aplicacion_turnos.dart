import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import '../datos/almacen_turnos.dart';
import '../enrutador/enrutador_app.dart';
import '../tema/tema_app.dart';
import '../modelos_vista/modelo_vista_tema.dart';
import 'alcance_turnos.dart';

/// Raiz de la aplicacion: crea el estado compartido, el router y el tema global.
class AplicacionTurnos extends StatefulWidget {
  const AplicacionTurnos({super.key, this.store});

  /// Permite inyectar datos en pruebas.
  final AlmacenTurnos? store;

  @override
  State<AplicacionTurnos> createState() => _AplicacionTurnosState();
}

class _AplicacionTurnosState extends State<AplicacionTurnos> {
  late final AlmacenTurnos _store = widget.store ?? AlmacenTurnos();
  final ModeloVistaTema _tema = ModeloVistaTema();
  late final GoRouter _router = crearEnrutador(_store);

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlcanceTurnos(
      store: _store,
      tema: _tema,
      child: ListenableBuilder(
        listenable: _tema,
        builder: (context, _) => MaterialApp.router(
          title: 'Turco',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.claro(),
          darkTheme: AppTheme.oscuro(),
          themeMode: _tema.modo.themeMode,
          locale: const Locale('es'),
          supportedLocales: const <Locale>[Locale('es')],
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: _router,
        ),
      ),
    );
  }
}
