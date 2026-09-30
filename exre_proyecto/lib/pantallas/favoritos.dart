import 'package:flutter/material.dart';

import '../estado/estado_app.dart';
import '../modelos/recursos_estudiados.dart';
import '../tema/tema_app.dart';

class PantallaFavoritos extends StatelessWidget {
  final EstadoApp estadoApp;
  final void Function(RecursoEstudio recurso) alAbrirRecurso;

  const PantallaFavoritos({
    super.key,
    required this.estadoApp,
    required this.alAbrirRecurso,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: estadoApp,
      builder: (context, child) {
        final List<RecursoEstudio> favoritos = estadoApp.recursosFavoritos;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Favoritos',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: SafeArea(
            child: favoritos.isEmpty
                ? _crearEstadoVacio()
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: favoritos.length,
                    separatorBuilder: (context, indice) {
                      return const SizedBox(height: 12);
                    },
                    itemBuilder: (context, indice) {
                      final RecursoEstudio recurso = favoritos[indice];

                      return _crearTarjetaFavorito(context, recurso);
                    },
                  ),
          ),
        );
      },
    );
  }

  Widget _crearTarjetaFavorito(BuildContext context, RecursoEstudio recurso) {
    final bool completado = estadoApp.estaCompletado(recurso.id);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          alAbrirRecurso(recurso);
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              _crearIcono(recurso),
              const SizedBox(width: 14),
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      recurso.categoria,
                      style: const TextStyle(
                        color: ColoresExRE.textoSecundario,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${recurso.autor} • '
                      '${recurso.duracionMinutos} min',
                      style: const TextStyle(
                        color: ColoresExRE.textoSecundario,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _crearEtiqueta(recurso.nivel.name),
                        if (completado) ...[
                          const SizedBox(width: 6),
                          _crearEtiqueta(
                            'Completado',
                            color: ColoresExRE.exito,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Quitar de favoritos',
                onPressed: () {
                  estadoApp.cambiarFavorito(recurso.id);
                },
                icon: const Icon(Icons.favorite, color: ColoresExRE.favorito),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _crearIcono(RecursoEstudio recurso) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: Color(recurso.color),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(_obtenerIcono(recurso.tipo), color: Colors.white, size: 28),
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

  Widget _crearEtiqueta(String texto, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color ?? ColoresExRE.primario,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _crearEstadoVacio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 72,
              color: ColoresExRE.textoSecundario,
            ),
            const SizedBox(height: 20),
            const Text(
              'Todavía no tienes favoritos',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColoresExRE.textoPrincipal,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Marca recursos con el corazón para '
              'encontrarlos rápidamente aquí.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColoresExRE.textoSecundario,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
