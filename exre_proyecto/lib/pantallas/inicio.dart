import 'package:flutter/material.dart';

import '../estado/estado_app.dart';
import '../tema/tema_app.dart';

class PantallaInicio extends StatelessWidget {
  final EstadoApp estadoApp;
  final ValueChanged<int> alSeleccionarPantalla;

  const PantallaInicio({
    super.key,
    required this.estadoApp,
    required this.alSeleccionarPantalla,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: estadoApp,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'ExRE',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _crearEncabezado(),
                  const SizedBox(height: 24),
                  _crearEstadoAplicacion(),
                  const SizedBox(height: 20),
                  _crearEstadisticas(),
                  const SizedBox(height: 28),
                  _crearTituloSeccion('Accesos rápidos'),
                  const SizedBox(height: 12),
                  _crearAccesosRapidos(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _crearEncabezado() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Explorador de Recursos de Estudio',
          style: TextStyle(
            color: ColoresExRE.textoPrincipal,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Encuentra, guarda y completa recursos para aprender Flutter y Android.',
          style: TextStyle(
            color: ColoresExRE.textoSecundario,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _crearEstadoAplicacion() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColoresExRE.superficie,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: ColoresExRE.primario,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.smartphone, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Estado de la aplicación',
                  style: TextStyle(
                    color: ColoresExRE.textoPrincipal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  estadoApp.nombreEstado,
                  style: const TextStyle(color: ColoresExRE.textoSecundario),
                ),
              ],
            ),
          ),
          const Icon(Icons.circle, color: ColoresExRE.exito, size: 12),
        ],
      ),
    );
  }

  Widget _crearEstadisticas() {
    return Row(
      children: [
        Expanded(
          child: _crearTarjetaEstadistica(
            icono: Icons.menu_book,
            valor: estadoApp.cantidadRecursos.toString(),
            etiqueta: 'Recursos',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _crearTarjetaEstadistica(
            icono: Icons.favorite,
            valor: estadoApp.cantidadFavoritos.toString(),
            etiqueta: 'Favoritos',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _crearTarjetaEstadistica(
            icono: Icons.check_circle,
            valor: estadoApp.cantidadCompletados.toString(),
            etiqueta: 'Completados',
          ),
        ),
      ],
    );
  }

  Widget _crearTarjetaEstadistica({
    required IconData icono,
    required String valor,
    required String etiqueta,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        color: ColoresExRE.superficie,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icono, color: ColoresExRE.primario, size: 24),
          const SizedBox(height: 8),
          Text(
            valor,
            style: const TextStyle(
              color: ColoresExRE.textoPrincipal,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            etiqueta,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: ColoresExRE.textoSecundario,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearTituloSeccion(String titulo) {
    return Text(
      titulo,
      style: const TextStyle(
        color: ColoresExRE.textoPrincipal,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _crearAccesosRapidos() {
    return Column(
      children: [
        _crearBotonAcceso(
          icono: Icons.menu_book,
          titulo: 'Catálogo',
          descripcion: 'Explora todos los recursos',
          indice: 1,
        ),
        const SizedBox(height: 12),
        _crearBotonAcceso(
          icono: Icons.grid_view_rounded,
          titulo: 'Galería',
          descripcion: 'Visualiza los recursos en cuadrícula',
          indice: 2,
        ),
        const SizedBox(height: 12),
        _crearBotonAcceso(
          icono: Icons.favorite,
          titulo: 'Favoritos',
          descripcion: 'Consulta tus recursos guardados',
          indice: 3,
        ),
        const SizedBox(height: 12),
        _crearBotonAcceso(
          icono: Icons.bar_chart_rounded,
          titulo: 'Progreso',
          descripcion: 'Consulta tus recursos completados',
          indice: 4,
        ),
      ],
    );
  }

  Widget _crearBotonAcceso({
    required IconData icono,
    required String titulo,
    required String descripcion,
    required int indice,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        alSeleccionarPantalla(indice);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColoresExRE.superficie,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: ColoresExRE.primario,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icono, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      color: ColoresExRE.textoPrincipal,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descripcion,
                    style: const TextStyle(
                      color: ColoresExRE.textoSecundario,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: ColoresExRE.textoSecundario),
          ],
        ),
      ),
    );
  }
}
