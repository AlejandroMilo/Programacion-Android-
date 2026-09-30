import 'package:flutter/material.dart';

import '../estado/estado_app.dart';
import '../modelos/recursos_estudiados.dart';
import '../tema/tema_app.dart';

class PantallaCatalogo extends StatelessWidget {
  final EstadoApp estadoApp;
  final void Function(RecursoEstudio recurso) alAbrirRecurso;

  const PantallaCatalogo({
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
              'Catálogo',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                _crearBuscador(),
                _crearCategorias(),
                const SizedBox(height: 8),
                Expanded(
                  child: recursos.isEmpty
                      ? _crearEstadoVacio()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                          itemCount: recursos.length,
                          itemBuilder: (context, indice) {
                            final RecursoEstudio recurso = recursos[indice];

                            return _crearTarjetaRecurso(context, recurso);
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _crearBuscador() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: TextField(
        onChanged: estadoApp.cambiarTextoBusqueda,
        style: const TextStyle(color: ColoresExRE.textoPrincipal),
        decoration: InputDecoration(
          hintText: 'Buscar por título, categoría o autor',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: estadoApp.textoBusqueda.isNotEmpty
              ? IconButton(
                  onPressed: estadoApp.limpiarBusqueda,
                  icon: const Icon(Icons.clear),
                )
              : null,
        ),
      ),
    );
  }

  Widget _crearCategorias() {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: estadoApp.categorias.length,
        separatorBuilder: (context, indice) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (context, indice) {
          final String categoria = estadoApp.categorias[indice];

          final bool seleccionada =
              estadoApp.categoriaSeleccionada == categoria;

          return ChoiceChip(
            label: Text(categoria),
            selected: seleccionada,
            onSelected: (seleccionado) {
              estadoApp.cambiarCategoria(categoria);
            },
            selectedColor: ColoresExRE.primario,
            backgroundColor: ColoresExRE.superficie,
            labelStyle: TextStyle(
              color: seleccionada ? Colors.white : ColoresExRE.textoSecundario,
              fontWeight: seleccionada ? FontWeight.bold : FontWeight.normal,
            ),
          );
        },
      ),
    );
  }

  Widget _crearTarjetaRecurso(BuildContext context, RecursoEstudio recurso) {
    final bool favorito = estadoApp.esFavorito(recurso.id);

    final bool completado = estadoApp.estaCompletado(recurso.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          alAbrirRecurso(recurso);
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              _crearIconoTipo(recurso),
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
                      '${recurso.autor} • ${recurso.duracionMinutos} min',
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
              Icon(
                favorito ? Icons.favorite : Icons.favorite_border,
                color: favorito
                    ? ColoresExRE.favorito
                    : ColoresExRE.textoSecundario,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _crearIconoTipo(RecursoEstudio recurso) {
    IconData icono;

    switch (recurso.tipo) {
      case TipoRecurso.video:
        icono = Icons.play_circle_fill;
        break;

      case TipoRecurso.lectura:
        icono = Icons.menu_book;
        break;

      case TipoRecurso.practica:
        icono = Icons.code;
        break;

      case TipoRecurso.documento:
        icono = Icons.description;
        break;
    }

    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: Color(recurso.color),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icono, color: Colors.white, size: 28),
    );
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
              Icons.search_off,
              size: 60,
              color: ColoresExRE.textoSecundario,
            ),
            const SizedBox(height: 16),
            const Text(
              'No encontramos recursos',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColoresExRE.textoPrincipal,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Prueba con otra búsqueda o categoría.',
              textAlign: TextAlign.center,
              style: TextStyle(color: ColoresExRE.textoSecundario),
            ),
          ],
        ),
      ),
    );
  }
}
