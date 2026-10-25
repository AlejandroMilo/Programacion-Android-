import 'package:flutter/material.dart';

/// Tema global de Turco. La paleta, la tipografia Poppins y los radios salen
/// de la guia de estilo del diseno y se aplican solo desde aqui: en las
/// pantallas y widgets no hay colores fijos.
class AppTheme {
  const AppTheme._();

  /// Semilla del diseno: Material 3 con seedColor 0xFF00695C.
  static const Color semilla = Color(0xFF00695C);

  static const String fuente = 'Poppins';

  /// Subtitulo claro sobre el fondo primary de la cabecera de Estilistas.
  static const Color subtituloSobrePrimario = Color(0xFFD9F5F0);

  // Radios tomados del diseno.
  static const double radioTarjetas = 16;
  static const double radioCampos = 12;
  static const double radioResumen = 12;
  static const double radioSegmentado = 20;
  static const double radioPastilla = 8;
  static const double radioBoton = 23;
  static const double radioHoja = 28;
  static const double radioIndicador = 15;
  static const double radioFiltro = 24;

  /// Alturas fijas del diseno.
  static const double altoBarraSuperior = 56;
  static const double altoBarraNavegacion = 76;
  static const double altoCampo = 52;
  static const double altoPastilla = 32;
  static const double altoSegmentado = 40;
  static const double altoBotonFlotante = 56;

  static ColorScheme _esquemaClaro() {
    return ColorScheme.fromSeed(
      seedColor: semilla,
      brightness: Brightness.light,
    ).copyWith(
      primary: const Color(0xFF006A60),
      onPrimary: const Color(0xFFFFFFFF),
      primaryContainer: const Color(0xFF9EF2E4),
      onPrimaryContainer: const Color(0xFF00201C),
      secondaryContainer: const Color(0xFFCCE8E2),
      onSecondaryContainer: const Color(0xFF05201C),
      tertiary: const Color(0xFF456179),
      onTertiary: const Color(0xFFFFFFFF),
      tertiaryContainer: const Color(0xFFCDE5FF),
      onTertiaryContainer: const Color(0xFF001D32),
      error: const Color(0xFFBA1A1A),
      onError: const Color(0xFFFFFFFF),
      errorContainer: const Color(0xFFFFDAD6),
      onErrorContainer: const Color(0xFF410002),
      surface: const Color(0xFFF4FBF9),
      onSurface: const Color(0xFF161D1C),
      onSurfaceVariant: const Color(0xFF3F4947),
      surfaceContainerLowest: const Color(0xFFFFFFFF),
      surfaceContainerLow: const Color(0xFFEFF5F3),
      surfaceContainer: const Color(0xFFE9EFED),
      surfaceContainerHigh: const Color(0xFFE3EAE8),
      surfaceContainerHighest: const Color(0xFFDDE4E2),
      outline: const Color(0xFF6F7977),
      outlineVariant: const Color(0xFFBEC9C6),
      inverseSurface: const Color(0xFF2B3231),
      onInverseSurface: const Color(0xFFF4FBF9),
      inversePrimary: const Color(0xFF74F8E5),
    );
  }

  static ColorScheme _esquemaOscuro() {
    return ColorScheme.fromSeed(
      seedColor: semilla,
      brightness: Brightness.dark,
    ).copyWith(
      primary: const Color(0xFF53DBC9),
      onPrimary: const Color(0xFF003731),
      primaryContainer: const Color(0xFF005047),
      onPrimaryContainer: const Color(0xFF74F8E5),
      secondaryContainer: const Color(0xFF314B47),
      onSecondaryContainer: const Color(0xFFCCE8E2),
      tertiary: const Color(0xFFADCAE6),
      onTertiary: const Color(0xFF001D32),
      tertiaryContainer: const Color(0xFF2D4A62),
      onTertiaryContainer: const Color(0xFFCDE5FF),
      error: const Color(0xFFFFB4AB),
      onError: const Color(0xFF690005),
      errorContainer: const Color(0xFF93000A),
      onErrorContainer: const Color(0xFFFFDAD6),
      surface: const Color(0xFF0E1514),
      onSurface: const Color(0xFFDDE4E2),
      onSurfaceVariant: const Color(0xFFBEC9C6),
      surfaceContainerLowest: const Color(0xFF090F0F),
      surfaceContainerLow: const Color(0xFF171D1C),
      surfaceContainer: const Color(0xFF1A2120),
      surfaceContainerHigh: const Color(0xFF242B2A),
      surfaceContainerHighest: const Color(0xFF2E3533),
      outline: const Color(0xFF899390),
      outlineVariant: const Color(0xFF3F4947),
      inverseSurface: const Color(0xFFE9EFED),
      onInverseSurface: const Color(0xFF161D1C),
      inversePrimary: const Color(0xFF006A60),
    );
  }

  static ThemeData claro() => _construir(_esquemaClaro(), Brightness.light);

  static ThemeData oscuro() => _construir(_esquemaOscuro(), Brightness.dark);

  static TextTheme _tipografia(Brightness brillo) {
    final base =
        (brillo == Brightness.light
                ? Typography.material2021().black
                : Typography.material2021().white)
            .apply(fontFamily: fuente);
    return base.copyWith(
      displaySmall: base.displaySmall?.copyWith(
        fontFamily: fuente,
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontFamily: fuente,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontFamily: fuente,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontFamily: fuente,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontFamily: fuente,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontFamily: fuente,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontFamily: fuente,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontFamily: fuente,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontFamily: fuente,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontFamily: fuente,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontFamily: fuente,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontFamily: fuente,
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  static ThemeData _construir(ColorScheme esquema, Brightness brillo) {
    final textos = _tipografia(brillo);
    final bordeCampo = OutlineInputBorder(
      borderRadius: BorderRadius.circular(radioCampos),
      borderSide: BorderSide(color: esquema.outline),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: esquema,
      brightness: brillo,
      fontFamily: fuente,
      textTheme: textos,
      scaffoldBackgroundColor: esquema.surface,
      canvasColor: esquema.surface,
      dividerTheme: DividerThemeData(
        color: esquema.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: esquema.surface,
        foregroundColor: esquema.onSurface,
        surfaceTintColor: esquema.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textos.headlineMedium?.copyWith(
          color: esquema.onSurface,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: esquema.onSurface, size: 24),
      ),
      cardTheme: CardThemeData(
        color: esquema.surfaceContainer,
        surfaceTintColor: esquema.surfaceContainer,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radioTarjetas),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radioCampos),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: textos.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radioCampos),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          side: BorderSide(color: esquema.outline),
          foregroundColor: esquema.onSurface,
          textStyle: textos.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radioCampos),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: textos.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        fillColor: Colors.transparent,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: bordeCampo,
        enabledBorder: bordeCampo,
        focusedBorder: bordeCampo.copyWith(
          borderSide: BorderSide(color: esquema.primary, width: 1.6),
        ),
        errorBorder: bordeCampo.copyWith(
          borderSide: BorderSide(color: esquema.error, width: 2),
        ),
        focusedErrorBorder: bordeCampo.copyWith(
          borderSide: BorderSide(color: esquema.error, width: 2),
        ),
        hintStyle: textos.bodyMedium?.copyWith(color: esquema.onSurfaceVariant),
        labelStyle: textos.bodyMedium?.copyWith(
          color: esquema.onSurfaceVariant,
        ),
        errorStyle: textos.bodySmall?.copyWith(color: esquema.error),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: esquema.surface,
        selectedColor: esquema.secondaryContainer,
        disabledColor: esquema.surfaceContainerHighest,
        side: BorderSide(color: esquema.outlineVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radioPastilla),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: textos.labelMedium,
        secondaryLabelStyle: textos.labelMedium?.copyWith(
          color: esquema.onSecondaryContainer,
        ),
        checkmarkColor: esquema.onSecondaryContainer,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: esquema.surfaceContainer,
        surfaceTintColor: esquema.surfaceContainer,
        indicatorColor: esquema.secondaryContainer,
        elevation: 0,
        height: altoBarraNavegacion,
        labelTextStyle: WidgetStatePropertyAll(textos.labelSmall),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: esquema.primaryContainer,
        foregroundColor: esquema.onPrimaryContainer,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radioTarjetas),
        ),
        extendedTextStyle: textos.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: esquema.surfaceContainer,
        surfaceTintColor: esquema.surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radioHoja),
        ),
        titleTextStyle: textos.headlineMedium?.copyWith(
          color: esquema.onSurface,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: textos.bodyMedium?.copyWith(
          color: esquema.onSurfaceVariant,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: esquema.inverseSurface,
        contentTextStyle: textos.bodyMedium?.copyWith(
          color: esquema.onInverseSurface,
        ),
        actionTextColor: esquema.inversePrimary,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radioPastilla),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: esquema.onSurfaceVariant,
        textColor: esquema.onSurface,
        titleTextStyle: textos.titleMedium,
        subtitleTextStyle: textos.bodySmall?.copyWith(
          color: esquema.onSurfaceVariant,
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: esquema.surface,
        surfaceTintColor: esquema.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radioTarjetas),
        ),
        headerBackgroundColor: esquema.primaryContainer,
        headerForegroundColor: esquema.onPrimaryContainer,
      ),
      iconTheme: IconThemeData(color: esquema.onSurfaceVariant, size: 22),
      splashFactory: InkSparkle.splashFactory,
    );
  }
}
