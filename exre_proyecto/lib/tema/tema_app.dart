import 'package:flutter/material.dart';

class ColoresExRE {
  static const Color fondo = Color(0xFF231C6B);
  static const Color superficie = Color(0xFF2E2789);
  static const Color primario = Color(0xFF4F46E5);

  static const Color textoPrincipal = Colors.white;
  static const Color textoSecundario = Color(0xFFC5BFEE);

  static const Color favorito = Color(0xFFF43F5E);
  static const Color exito = Color(0xFF16A34A);
  static const Color advertencia = Color(0xFFF59E0B);
}

class TemaApp {
  static ThemeData obtenerTema() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: ColoresExRE.fondo,

      colorScheme: ColorScheme.fromSeed(
        seedColor: ColoresExRE.primario,
        brightness: Brightness.dark,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: ColoresExRE.fondo,
        foregroundColor: ColoresExRE.textoPrincipal,
        elevation: 0,
        centerTitle: false,
      ),

      cardTheme: const CardThemeData(
        color: ColoresExRE.superficie,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColoresExRE.superficie,
        hintStyle: const TextStyle(color: ColoresExRE.textoSecundario),
        prefixIconColor: ColoresExRE.textoSecundario,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide.none,
        ),
      ),

      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: ColoresExRE.superficie,
        indicatorColor: ColoresExRE.primario,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(color: ColoresExRE.textoPrincipal),
        ),
      ),
    );
  }
}
