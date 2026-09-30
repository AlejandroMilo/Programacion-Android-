import 'package:flutter/material.dart';

import '../estado/estado_app.dart';
import '../modelos/recursos_estudiados.dart';
import '../tema/tema_app.dart';

class PantallaDetalle extends StatelessWidget {
  final EstadoApp estadoApp;
  final RecursoEstudio recurso;

  const PantallaDetalle({
    super.key,
    required this.estadoApp,
    required this.recurso,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: estadoApp,
      builder: (context, child) {
        final bool favorito = estadoApp.esFavorito(recurso.id);

        final bool completado = estadoApp.estaCompletado(recurso.id);

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Detalle',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              tooltip: 'Volver',
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _crearCabecera(favorito),
                  const SizedBox(height: 24),
                  _crearInformacion(),
                  const SizedBox(height: 24),
                  _crearDescripcion(),
                  const SizedBox(height: 24),
                  _crearContenido(context),
                  const SizedBox(height: 24),
                  _crearAcciones(favorito, completado),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _crearCabecera(bool favorito) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Color(recurso.color),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _crearEtiquetaTipo()),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.20),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  tooltip: favorito
                      ? 'Quitar de favoritos'
                      : 'Agregar a favoritos',
                  onPressed: () {
                    estadoApp.cambiarFavorito(recurso.id);
                  },
                  icon: Icon(
                    favorito ? Icons.favorite : Icons.favorite_border,
                    color: favorito ? Colors.white : Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Icon(_obtenerIcono(recurso.tipo), color: Colors.white, size: 54),
          const SizedBox(height: 18),
          Text(
            recurso.titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            recurso.categoria,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearEtiquetaTipo() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          _nombreTipo(recurso.tipo),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _crearInformacion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Información',
          style: TextStyle(
            color: ColoresExRE.textoPrincipal,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _crearDato(Icons.person_outline, 'Autor', recurso.autor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _crearDato(
                Icons.schedule,
                'Duración',
                '${recurso.duracionMinutos} min',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _crearDato(
                Icons.signal_cellular_alt,
                'Nivel',
                _nombreNivel(recurso.nivel),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _crearDato(
                Icons.category_outlined,
                'Categoría',
                recurso.categoria,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _crearDato(IconData icono, String titulo, String valor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColoresExRE.superficie,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: ColoresExRE.primario, size: 22),
          const SizedBox(height: 8),
          Text(
            titulo,
            style: const TextStyle(
              color: ColoresExRE.textoSecundario,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            valor,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: ColoresExRE.textoPrincipal,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearDescripcion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Descripción',
          style: TextStyle(
            color: ColoresExRE.textoPrincipal,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          recurso.descripcion,
          style: const TextStyle(
            color: ColoresExRE.textoSecundario,
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _crearContenido(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ColoresExRE.superficie,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.play_circle_outline, color: ColoresExRE.primario),
              SizedBox(width: 8),
              Text(
                'Contenido del recurso',
                style: TextStyle(
                  color: ColoresExRE.textoPrincipal,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _descripcionContenido(),
            style: const TextStyle(
              color: ColoresExRE.textoSecundario,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _mostrarContenidoSimulado(context);
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('Abrir contenido'),
            ),
          ),
        ],
      ),
    );
  }

  String _descripcionContenido() {
    switch (recurso.tipo) {
      case TipoRecurso.video:
        return 'Recurso de video simulado para practicar '
            'los conceptos principales de este tema.';

      case TipoRecurso.lectura:
        return 'Material de lectura local con los conceptos '
            'y explicaciones principales del recurso.';

      case TipoRecurso.practica:
        return 'Actividad práctica simulada para aplicar '
            'los conocimientos aprendidos.';

      case TipoRecurso.documento:
        return 'Documento local simulado con información '
            'de referencia sobre el tema.';
    }
  }

  Widget _crearAcciones(bool favorito, bool completado) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estado del recurso',
          style: TextStyle(
            color: ColoresExRE.textoPrincipal,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () {
              estadoApp.cambiarCompletado(recurso.id);
            },
            icon: Icon(
              completado ? Icons.check_circle : Icons.check_circle_outline,
            ),
            label: Text(
              completado ? 'Marcar como pendiente' : 'Marcar como completado',
            ),
            style: FilledButton.styleFrom(
              backgroundColor: completado
                  ? ColoresExRE.exito
                  : ColoresExRE.primario,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              estadoApp.cambiarFavorito(recurso.id);
            },
            icon: Icon(
              favorito ? Icons.favorite : Icons.favorite_border,
              color: ColoresExRE.favorito,
            ),
            label: Text(
              favorito ? 'Quitar de favoritos' : 'Agregar a favoritos',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: ColoresExRE.textoPrincipal,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ],
    );
  }

  void _mostrarContenidoSimulado(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColoresExRE.superficie,
          title: const Text(
            'Contenido simulado',
            style: TextStyle(color: ColoresExRE.textoPrincipal),
          ),
          content: Text(
            'Aquí se abriría el contenido del recurso '
            '“${recurso.titulo}”.\n\n'
            'Esta versión utiliza contenido local simulado, '
            'sin servidor ni base de datos remota.',
            style: const TextStyle(
              color: ColoresExRE.textoSecundario,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  IconData _obtenerIcono(TipoRecurso tipo) {
    switch (tipo) {
      case TipoRecurso.video:
        return Icons.play_circle_fill;

      case TipoRecurso.lectura:
        return Icons.menu_book;

      case TipoRecurso.practica:
        return Icons.code;

      case TipoRecurso.documento:
        return Icons.description;
    }
  }

  String _nombreTipo(TipoRecurso tipo) {
    switch (tipo) {
      case TipoRecurso.video:
        return 'VIDEO';

      case TipoRecurso.lectura:
        return 'LECTURA';

      case TipoRecurso.practica:
        return 'PRÁCTICA';

      case TipoRecurso.documento:
        return 'DOCUMENTO';
    }
  }

  String _nombreNivel(NivelRecurso nivel) {
    switch (nivel) {
      case NivelRecurso.basico:
        return 'Básico';

      case NivelRecurso.intermedio:
        return 'Intermedio';

      case NivelRecurso.avanzado:
        return 'Avanzado';
    }
  }
}
