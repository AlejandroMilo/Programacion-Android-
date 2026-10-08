
import 'package:flutter/material.dart';

/// Sistema visual de ReNotes: paleta claro/oscuro, espaciado, radios,
/// duraciones, avisos, estados vacíos y navegación animada.
///
/// Todo sale del SDK: sin paquetes externos.
class Paleta {
  final Color fondo;
  final Color tarjeta;
  final Color campo;
  final Color borde;
  final Color borgona;
  final Color dorado;
  final Color doradoTexto;
  final Color texto;
  final Color textoSuave;
  final Color pista;
  final Color estrella;
  final Color peligro;

  const Paleta({
    required this.fondo,
    required this.tarjeta,
    required this.campo,
    required this.borde,
    required this.borgona,
    required this.dorado,
    required this.doradoTexto,
    required this.texto,
    required this.textoSuave,
    required this.pista,
    required this.estrella,
    required this.peligro,
  });

  static const oscura = Paleta(
    fondo: Color(0xFF12131A),
    tarjeta: Color(0xFF1E2029),
    campo: Color(0xFF23262F),
    borde: Color(0x14FFFFFF),
    borgona: Color(0xFF8A1E35),
    dorado: Color(0xFFE8C87E),
    doradoTexto: Color(0xFFE8C87E),
    texto: Color(0xFFF5EDD8),
    textoSuave: Color(0xFFA7AAB8),
    pista: Color(0xFF7C7F8D),
    estrella: Color(0xFFF0BE3C),
    peligro: Color(0xFFE57373),
  );

  static const clara = Paleta(
    fondo: Color(0xFFF4EFE4),
    tarjeta: Color(0xFFFFFFFF),
    campo: Color(0xFFECE7D8),
    borde: Color(0x14000000),
    borgona: Color(0xFF75162D),
    dorado: Color(0xFFE8C87E),
    doradoTexto: Color(0xFF8A6D2F),
    texto: Color(0xFF26232E),
    textoSuave: Color(0xFF686B78),
    pista: Color(0xFF9AA0AE),
    estrella: Color(0xFFD99A16),
    peligro: Color(0xFFB3261E),
  );

  static Paleta of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? clara
        : oscura;
  }
}

/// Espaciado uniforme en múltiplos de 4.
class Esp {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 20;
  static const double xxl = 24;
}

/// Bordes redondeados de 16–20 px en superficies.
class Radios {
  static const double tarjeta = 18;
  static const double dialogo = 20;
  static const double boton = 14;
  static const double campo = 14;
  static const double chip = 20;
}

/// Animaciones de 150–250 ms.
class Tiempos {
  static const Duration corto = Duration(milliseconds: 150);
  static const Duration medio = Duration(milliseconds: 200);
  static const Duration largo = Duration(milliseconds: 250);
}

/// Sombra muy suave para tarjetas en ambos temas.
List<BoxShadow> sombraSuave(BuildContext context) {
  final esClaro = Theme.of(context).brightness == Brightness.light;
  return [
    BoxShadow(
      color: esClaro
          ? const Color(0xFF3A2E12).withValues(alpha: 0.10)
          : Colors.black.withValues(alpha: 0.45),
      blurRadius: 14,
      offset: const Offset(0, 5),
    ),
  ];
}

/// Degradado de marca para azulejos de icono y cabeceras.
LinearGradient degradadoMarca(BuildContext context) {
  final paleta = Paleta.of(context);
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      paleta.borgona,
      paleta.borgona.withValues(alpha: 0.65),
    ],
  );
}

/// Degradado dorado sutil para fondos de icono.
LinearGradient degradadoDorado(BuildContext context) {
  final paleta = Paleta.of(context);
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      paleta.dorado.withValues(alpha: 0.28),
      paleta.dorado.withValues(alpha: 0.10),
    ],
  );
}

/// Tarjeta base de la app: radio 18, borde fino, sombra suave y
/// destello superior.
class TarjetaBase extends StatelessWidget {
  final Widget hijo;
  final VoidCallback? alPresionar;
  final EdgeInsetsGeometry margen;
  final EdgeInsetsGeometry relleno;

  const TarjetaBase({
    super.key,
    required this.hijo,
    this.alPresionar,
    this.margen = const EdgeInsets.only(bottom: Esp.m),
    this.relleno = const EdgeInsets.all(Esp.l),
  });

  @override
  Widget build(BuildContext context) {
    final paleta = Paleta.of(context);
    final esClaro = Theme.of(context).brightness == Brightness.light;

    return Container(
      margin: margen,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Radios.tarjeta),
        boxShadow: sombraSuave(context),
      ),
      child: Material(
        color: paleta.tarjeta,
        borderRadius: BorderRadius.circular(Radios.tarjeta),
        child: InkWell(
          onTap: alPresionar,
          borderRadius: BorderRadius.circular(Radios.tarjeta),
          splashColor: paleta.dorado.withValues(alpha: 0.10),
          highlightColor: paleta.dorado.withValues(alpha: 0.05),
          child: Container(
            padding: relleno,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(Radios.tarjeta),
              border: Border.all(color: paleta.borde),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  (esClaro ? Colors.white : Colors.white)
                      .withValues(alpha: esClaro ? 0.0 : 0.04),
                  const Color(0x00000000),
                ],
              ),
            ),
            child: hijo,
          ),
        ),
      ),
    );
  }
}

/// Azulejo de icono con degradado de marca.
class AzulejoIcono extends StatelessWidget {
  final IconData icono;
  final double lado;
  final double tamanoIcono;
  final bool dorado;

  const AzulejoIcono({
    super.key,
    required this.icono,
    this.lado = 52,
    this.tamanoIcono = 26,
    this.dorado = false,
  });

  @override
  Widget build(BuildContext context) {
    final paleta = Paleta.of(context);
    return Container(
      width: lado,
      height: lado,
      decoration: BoxDecoration(
        gradient:
            dorado ? degradadoDorado(context) : degradadoMarca(context),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: (dorado ? paleta.dorado : paleta.borgona)
                .withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        icono,
        color: dorado ? paleta.doradoTexto : Colors.white,
        size: tamanoIcono,
      ),
    );
  }
}

/// Etiqueta pequeña en mayúsculas para secciones.
class MicroEtiqueta extends StatelessWidget {
  final String texto;

  const MicroEtiqueta(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto.toUpperCase(),
      style: TextStyle(
        color: Paleta.of(context).textoSuave,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
      ),
    );
  }
}

/// SnackBar moderno: flotante, redondeado y con acción opcional.
void mostrarAviso(
  BuildContext context,
  String texto, {
  String? accionTexto,
  VoidCallback? alAccion,
}) {
  final paleta = Paleta.of(context);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(texto),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radios.boton),
        ),
        margin: const EdgeInsets.all(Esp.l),
        duration: const Duration(seconds: 4),
        action: accionTexto == null
            ? null
            : SnackBarAction(
                label: accionTexto,
                textColor: paleta.doradoTexto,
                onPressed: () => alAccion?.call(),
              ),
      ),
    );
}

/// Estado vacío bonito: icono en círculo, título, mensaje y acción.
class EstadoVacio extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String mensaje;
  final String? textoAccion;
  final VoidCallback? alAccion;

  const EstadoVacio({
    super.key,
    required this.icono,
    required this.titulo,
    required this.mensaje,
    this.textoAccion,
    this.alAccion,
  });

  @override
  Widget build(BuildContext context) {
    final paleta = Paleta.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Esp.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: paleta.dorado.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icono,
                size: 44,
                color: paleta.doradoTexto,
              ),
            ),
            const SizedBox(height: Esp.l),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: paleta.texto,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Esp.s),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: paleta.textoSuave,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            if (textoAccion != null && alAccion != null) ...[
              const SizedBox(height: Esp.xl),
              FilledButton.icon(
                onPressed: alAccion,
                icon: const Icon(Icons.add),
                label: Text(textoAccion!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Ruta con animación de 200 ms ( fundido + leve deslizamiento ).
PageRouteBuilder<T> rutaAnimada<T>(Widget pantalla) {
  return PageRouteBuilder<T>(
    transitionDuration: Tiempos.medio,
    reverseTransitionDuration: Tiempos.corto,
    pageBuilder: (_, animacion, _) => pantalla,
    transitionsBuilder: (_, animacion, _, hijo) {
      final curva = CurvedAnimation(
        parent: animacion,
        curve: Curves.easeOut,
      );
      return FadeTransition(
        opacity: curva,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0.04, 0),
            end: Offset.zero,
          ).animate(curva),
          child: hijo,
        ),
      );
    },
  );
}

/// Abrir una pantalla con la animación estándar (200 ms).
Future<T?> abrirPantalla<T>(BuildContext context, Widget pantalla) {
  return Navigator.push<T>(context, rutaAnimada<T>(pantalla));
}

/// Fecha relativa corta: "ahora mismo", "hace 5 min", "hace 3 h",
/// "hace 2 d" o la fecha dd/mm/aaaa si es más vieja.
String haceCuanto(DateTime fecha) {
  final diferencia = DateTime.now().difference(fecha);

  if (diferencia.inMinutes < 1) return 'ahora mismo';
  if (diferencia.inHours < 1) {
    final minutos = diferencia.inMinutes;
    return 'hace $minutos min';
  }
  if (diferencia.inDays < 1) {
    final horas = diferencia.inHours;
    return 'hace $horas h';
  }
  if (diferencia.inDays < 7) {
    final dias = diferencia.inDays;
    return 'hace $dias d';
  }

  final dia = fecha.day.toString().padLeft(2, '0');
  final mes = fecha.month.toString().padLeft(2, '0');
  return '$dia/$mes/${fecha.year}';
}
