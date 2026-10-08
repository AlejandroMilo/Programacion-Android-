
import 'package:flutter/material.dart';
import 'diseno/sistema.dart';
import 'estado/estado_aplicacion.dart';
import 'modelos/proyecto.dart';
import 'pantallas/proyectos.dart';
import 'pantallas/notas_proyecto.dart';
import 'pantallas/etiquetas.dart';
import 'pantallas/busqueda.dart';
import 'componentes/barra_navegacion.dart';

void main() {
runApp(const ReNotesApp());
}

class ReNotesApp extends StatefulWidget {
const ReNotesApp({super.key});

@override
State<ReNotesApp> createState() => _ReNotesAppState();
}

class _ReNotesAppState extends State<ReNotesApp> {
late final EstadoAplicacion _estado = EstadoAplicacion();

// Clave del Navigator: el context del State está por encima del
// MaterialApp y no contiene un Navigator; con esta clave la
// navegación funciona desde cualquier punto (RF7).
final GlobalKey<NavigatorState> _claveNavegacion =
GlobalKey<NavigatorState>();

int _indiceSeleccionado = 0;

@override
void dispose() {
_estado.dispose();
super.dispose();
}

void _abrirProyecto(Proyecto proyecto) {
_claveNavegacion.currentState?.push(
rutaAnimada(
PantallaNotasProyecto(
estado: _estado,
proyecto: proyecto,
),
),
);
}

ThemeData _tema(Brightness brillo) {
final paleta = brillo == Brightness.light ? Paleta.clara : Paleta.oscura;
final esquema = ColorScheme.fromSeed(
seedColor: paleta.borgona,
brightness: brillo,
);

return ThemeData(
useMaterial3: true,
brightness: brillo,
scaffoldBackgroundColor: paleta.fondo,
colorScheme: esquema,
appBarTheme: AppBarTheme(
backgroundColor: paleta.fondo,
foregroundColor: paleta.texto,
centerTitle: false,
),
cardTheme: CardThemeData(
color: paleta.tarjeta,
elevation: 2,
shadowColor: Colors.black.withValues(alpha: 0.3),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(Radios.tarjeta),
),
),
dialogTheme: DialogThemeData(
backgroundColor: paleta.tarjeta,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(Radios.dialogo),
),
),
filledButtonTheme: FilledButtonThemeData(
style: FilledButton.styleFrom(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(Radios.boton),
),
padding: const EdgeInsets.symmetric(
horizontal: Esp.l,
vertical: Esp.m,
),
),
),
outlinedButtonTheme: OutlinedButtonThemeData(
style: OutlinedButton.styleFrom(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(Radios.boton),
),
padding: const EdgeInsets.symmetric(
horizontal: Esp.l,
vertical: Esp.m,
),
),
),
textButtonTheme: TextButtonThemeData(
style: TextButton.styleFrom(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(Radios.boton),
),
),
),
floatingActionButtonTheme: FloatingActionButtonThemeData(
backgroundColor: paleta.borgona,
foregroundColor: Colors.white,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(Radios.tarjeta),
),
extendedPadding: const EdgeInsets.symmetric(
horizontal: Esp.xl,
vertical: Esp.l,
),
),
chipTheme: ChipThemeData(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(Radios.chip),
),
),
snackBarTheme: SnackBarThemeData(
behavior: SnackBarBehavior.floating,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(Radios.boton),
),
insetPadding: const EdgeInsets.all(Esp.l),
),
bottomNavigationBarTheme: BottomNavigationBarThemeData(
backgroundColor: paleta.fondo,
selectedItemColor: paleta.doradoTexto,
unselectedItemColor: paleta.textoSuave,
type: BottomNavigationBarType.fixed,
),
inputDecorationTheme: InputDecorationTheme(
filled: true,
fillColor: paleta.campo,
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(Radios.campo),
borderSide: BorderSide.none,
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(Radios.campo),
borderSide: BorderSide(color: paleta.borde),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(Radios.campo),
borderSide: BorderSide(color: paleta.doradoTexto),
),
),
popupMenuTheme: PopupMenuThemeData(
color: paleta.tarjeta,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(Radios.boton),
),
),
textTheme: const TextTheme(
titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
bodyMedium: TextStyle(fontSize: 14, height: 1.5),
bodySmall: TextStyle(fontSize: 12),
labelSmall: TextStyle(fontSize: 11),
),
);
}

@override
Widget build(BuildContext context) {
return AnimatedBuilder(
animation: _estado,
builder: (context, _) {
return MaterialApp(
title: 'ReNotes',
navigatorKey: _claveNavegacion,
debugShowCheckedModeBanner: false,
theme: _tema(Brightness.light),
darkTheme: _tema(Brightness.dark),
themeMode: _estado.modoClaro ? ThemeMode.light : ThemeMode.dark,
home: Scaffold(
body: IndexedStack(
index: _indiceSeleccionado,
children: [
PantallaProyectos(
key: const PageStorageKey('tab_proyectos'),
estado: _estado,
alAbrirProyecto: _abrirProyecto,
),
PantallaEtiquetas(
key: const PageStorageKey('tab_etiquetas'),
estado: _estado,
),
PantallaBusqueda(
key: const PageStorageKey('tab_buscar'),
estado: _estado,
),
],
),
bottomNavigationBar: BarraNavegacion(
indiceSeleccionado: _indiceSeleccionado,
alCambiar: (indice) {
setState(() {
_indiceSeleccionado = indice;
});
},
),
),
);
},
);
}
}
