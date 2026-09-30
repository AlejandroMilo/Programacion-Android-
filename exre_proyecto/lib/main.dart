import 'package:flutter/material.dart';

import 'widgets/barra_navegacion_inferior.dart';
import 'estado/estado_app.dart';
import 'modelos/recursos_estudiados.dart';
import 'pantallas/catalogo.dart';
import 'pantallas/detalle.dart';
import 'pantallas/favoritos.dart';
import 'pantallas/galeria.dart';
import 'pantallas/inicio.dart';
import 'pantallas/progreso.dart';
import 'tema/tema_app.dart';

void main() {
  runApp(const AplicacionExRE());
}

class AplicacionExRE extends StatefulWidget {
  const AplicacionExRE({super.key});

  @override
  State<AplicacionExRE> createState() => _AplicacionExREState();
}

class _AplicacionExREState extends State<AplicacionExRE>
    with WidgetsBindingObserver {
  final EstadoApp estadoApp = EstadoApp();

  final GlobalKey<NavigatorState> claveNavegador = GlobalKey<NavigatorState>();

  int indiceSeleccionado = 0;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    estadoApp.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    estadoApp.registrarEstado(state);
  }

  void _cambiarPantalla(int indice) {
    setState(() {
      indiceSeleccionado = indice;
    });
  }

  void _abrirDetalle(RecursoEstudio recurso) {
    estadoApp.seleccionarRecurso(recurso.id);

    claveNavegador.currentState!.push(
      MaterialPageRoute(
        builder: (context) {
          return PantallaDetalle(estadoApp: estadoApp, recurso: recurso);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pantallas = [
      PantallaInicio(
        estadoApp: estadoApp,
        alSeleccionarPantalla: _cambiarPantalla,
      ),
      PantallaCatalogo(estadoApp: estadoApp, alAbrirRecurso: _abrirDetalle),
      PantallaGaleria(estadoApp: estadoApp, alAbrirRecurso: _abrirDetalle),
      PantallaFavoritos(estadoApp: estadoApp, alAbrirRecurso: _abrirDetalle),
      PantallaProgreso(estadoApp: estadoApp),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ExRE',
      theme: TemaApp.obtenerTema(),
      navigatorKey: claveNavegador,
      home: Scaffold(
        body: IndexedStack(index: indiceSeleccionado, children: pantallas),
        bottomNavigationBar: BarraNavegacionInferior(
          indiceSeleccionado: indiceSeleccionado,
          alSeleccionar: _cambiarPantalla,
        ),
      ),
    );
  }
}
