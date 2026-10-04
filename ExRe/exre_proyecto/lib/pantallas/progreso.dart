import 'package:flutter/material.dart';

import '../estado/estado_app.dart';
import '../modelos/recursos_estudiados.dart';
import '../tema/tema_app.dart';

class PantallaProgreso extends StatelessWidget {
  final EstadoApp estadoApp;

  const PantallaProgreso({super.key, required this.estadoApp});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: estadoApp,
      builder: (context, child) {
        final double porcentaje = estadoApp.porcentajeCompletado;

        final int porcentajeEntero = (porcentaje * 100).round();

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Progreso',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _crearResumen(porcentaje, porcentajeEntero),
                const SizedBox(height: 24),
                _crearEstadisticas(),
                const SizedBox(height: 28),
                _crearTitulo('Recursos completados'),
                const SizedBox(height: 12),
                _crearListaCompletados(),
                const SizedBox(height: 28),
                _crearTitulo('Recursos pendientes'),
                const SizedBox(height: 12),
                _crearListaPendientes(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _crearResumen(double porcentaje, int porcentajeEntero) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: ColoresExRE.superficie,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          const Text(
            'Tu progreso',
            style: TextStyle(
              color: ColoresExRE.textoPrincipal,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: porcentaje,
                    strokeWidth: 12,
                    backgroundColor: ColoresExRE.fondo,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      ColoresExRE.exito,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$porcentajeEntero%',
                      style: const TextStyle(
                        color: ColoresExRE.textoPrincipal,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'completado',
                      style: TextStyle(
                        color: ColoresExRE.textoSecundario,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _crearMensajeProgreso(porcentaje),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: ColoresExRE.textoSecundario,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  String _crearMensajeProgreso(double porcentaje) {
    if (porcentaje == 0) {
      return 'Todavía no has completado recursos. '
          '¡Empieza a explorar!';
    }

    if (porcentaje < 0.5) {
      return 'Vas avanzando. Sigue explorando '
          'y completando recursos.';
    }

    if (porcentaje < 1.0) {
      return '¡Muy buen progreso! Ya has completado '
          'una parte importante.';
    }

    return '¡Has completado todos los recursos!';
  }

  Widget _crearEstadisticas() {
    return Row(
      children: [
        Expanded(
          child: _crearEstadistica(
            icono: Icons.check_circle,
            valor: estadoApp.cantidadCompletados.toString(),
            titulo: 'Completados',
            color: ColoresExRE.exito,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _crearEstadistica(
            icono: Icons.pending_actions,
            valor: estadoApp.cantidadPendientes.toString(),
            titulo: 'Pendientes',
            color: ColoresExRE.advertencia,
          ),
        ),
      ],
    );
  }

  Widget _crearEstadistica({
    required IconData icono,
    required String valor,
    required String titulo,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      decoration: BoxDecoration(
        color: ColoresExRE.superficie,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icono, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            valor,
            style: const TextStyle(
              color: ColoresExRE.textoPrincipal,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            titulo,
            style: const TextStyle(
              color: ColoresExRE.textoSecundario,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearTitulo(String titulo) {
    return Text(
      titulo,
      style: const TextStyle(
        color: ColoresExRE.textoPrincipal,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _crearListaCompletados() {
    final List<RecursoEstudio> recursos = estadoApp.recursosCompletados;

    if (recursos.isEmpty) {
      return _crearMensajeLista(
        icono: Icons.check_circle_outline,
        mensaje: 'Todavía no hay recursos completados.',
      );
    }

    return Column(
      children: recursos.map((recurso) {
        return _crearRecursoProgreso(recurso, completado: true);
      }).toList(),
    );
  }

  Widget _crearListaPendientes() {
    final List<RecursoEstudio> recursos = estadoApp.recursosPendientes;

    if (recursos.isEmpty) {
      return _crearMensajeLista(
        icono: Icons.celebration,
        mensaje: '¡No tienes recursos pendientes!',
      );
    }

    return Column(
      children: recursos.map((recurso) {
        return _crearRecursoProgreso(recurso, completado: false);
      }).toList(),
    );
  }

  Widget _crearRecursoProgreso(
    RecursoEstudio recurso, {
    required bool completado,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColoresExRE.superficie,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Color(recurso.color),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              completado ? Icons.check : Icons.menu_book,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recurso.titulo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ColoresExRE.textoPrincipal,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${recurso.categoria} • '
                  '${recurso.duracionMinutos} min',
                  style: const TextStyle(
                    color: ColoresExRE.textoSecundario,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            completado ? Icons.check_circle : Icons.radio_button_unchecked,
            color: completado ? ColoresExRE.exito : ColoresExRE.textoSecundario,
          ),
        ],
      ),
    );
  }

  Widget _crearMensajeLista({
    required IconData icono,
    required String mensaje,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColoresExRE.superficie,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icono, color: ColoresExRE.textoSecundario, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              mensaje,
              style: const TextStyle(
                color: ColoresExRE.textoSecundario,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
