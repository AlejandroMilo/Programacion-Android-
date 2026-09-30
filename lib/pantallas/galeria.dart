import 'package:flutter/material.dart';

import '../estado/estado_app.dart';
import '../modelos/recursos_estudiados.dart';
import '../tema/tema_app.dart';

class PantallaGaleria extends StatelessWidget {
  final EstadoApp estadoApp;
  final void Function(RecursoEstudio recurso) alAbrirRecurso;

  const PantallaGaleria({
    super.key,
    required this.estadoApp,
    required this.alAbrirRecurso,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: estadoApp,
      builder: (context, child) {
        final List<RecursoEstudio> recursos = estadoApp.recursosFiltrados;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Galería',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: SafeArea(
            child: recursos.isEmpty
                ? _crearEstadoVacio()
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: recursos.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.60,
                        ),
                    itemBuilder: (context, indice) {
                      final RecursoEstudio recurso = recursos[indice];

                      return _crearTarjeta(context, recurso);
                    },
                  ),
          ),
        );
      },
    );
  }

  Widget _crearTarjeta(BuildContext context, RecursoEstudio recurso) {
    final bool favorito = estadoApp.esFavorito(recurso.id);

    final bool completado = estadoApp.estaCompletado(recurso.id);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          alAbrirRecurso(recurso);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Color(recurso.color)),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        _obtenerIcono(recurso.tipo),
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          favorito ? Icons.favorite : Icons.favorite_border,
                          color: favorito ? ColoresExRE.favorito : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    if (completado)
                      Positioned(
                        left: 10,
                        bottom: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: ColoresExRE.exito,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Completado',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
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
                    const SizedBox(height: 6),
                    Text(
                      recurso.categoria,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ColoresExRE.textoSecundario,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          color: ColoresExRE.textoSecundario,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${recurso.duracionMinutos} min',
                          style: const TextStyle(
                            color: ColoresExRE.textoSecundario,
                            fontSize: 11,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          recurso.nivel.name,
                          style: const TextStyle(
                            color: ColoresExRE.textoSecundario,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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

  Widget _crearEstadoVacio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.grid_off, size: 60, color: ColoresExRE.textoSecundario),
            const SizedBox(height: 16),
            const Text(
              'No hay recursos para mostrar',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColoresExRE.textoPrincipal,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
