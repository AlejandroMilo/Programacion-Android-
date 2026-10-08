import 'package:flutter_test/flutter_test.dart';

import 'package:re_notas/estado/estado_aplicacion.dart';

void main() {
  test('Alternar favorita y fijada de una nota', () {
    final estado = EstadoAplicacion();

    expect(estado.buscarNotaPorId('nota_01')!.esFavorita, isFalse);
    estado.alternarFavorita('nota_01');
    expect(estado.buscarNotaPorId('nota_01')!.esFavorita, isTrue);
    estado.alternarFavorita('nota_01');
    expect(estado.buscarNotaPorId('nota_01')!.esFavorita, isFalse);

    expect(estado.buscarNotaPorId('nota_01')!.fija, isFalse);
    estado.alternarFija('nota_01');
    expect(estado.buscarNotaPorId('nota_01')!.fija, isTrue);
    estado.alternarFija('nota_01');
    expect(estado.buscarNotaPorId('nota_01')!.fija, isFalse);
  });

  test('Las notas fijadas van primero', () {
    final estado = EstadoAplicacion();

    estado.alternarFija('nota_03');
    final notas = estado.notasDeProyecto('proyecto_flutter');
    expect(notas.first.id, 'nota_03');

    estado.alternarFija('nota_03');
  });

  test('Deshacer restaura la nota borrada', () {
    final estado = EstadoAplicacion();
    final total = estado.notas.length;

    estado.eliminarNota('nota_02');
    expect(estado.notas.length, total - 1);
    expect(estado.tipoDeshacer, 'nota');

    estado.deshacerBorrado();
    expect(estado.notas.length, total);
    expect(estado.buscarNotaPorId('nota_02'), isNotNull);
  });

  test('Deshacer restaura el proyecto con sus notas', () {
    final estado = EstadoAplicacion();

    estado.eliminarProyecto('proyecto_web');
    expect(estado.buscarProyectoPorId('proyecto_web'), isNull);

    estado.deshacerBorrado();
    expect(estado.buscarProyectoPorId('proyecto_web'), isNotNull);
    expect(estado.notasDeProyecto('proyecto_web').length, 5);
  });

  test('Deshacer restaura la etiqueta en sus notas', () {
    final estado = EstadoAplicacion();
    final antes = estado.notasDeEtiqueta('etiqueta_estudio').length;
    expect(antes, greaterThan(0));

    estado.eliminarEtiqueta('etiqueta_estudio');
    expect(estado.buscarEtiquetaPorId('etiqueta_estudio'), isNull);

    estado.deshacerBorrado();
    expect(estado.buscarEtiquetaPorId('etiqueta_estudio'), isNotNull);
    expect(estado.notasDeEtiqueta('etiqueta_estudio').length, antes);
  });

  test('Los proyectos se ordenan por nombre', () {
    final estado = EstadoAplicacion();

    estado.cambiarOrdenProyectos('nombre');
    final nombres =
        estado.proyectosOrdenados.map((p) => p.nombre).toList();
    final esperados = List.of(nombres)..sort();
    expect(nombres, esperados);
  });

  test('El tema claro y oscuro se alterna', () {
    final estado = EstadoAplicacion();

    expect(estado.modoClaro, isFalse);
    estado.alternarTema();
    expect(estado.modoClaro, isTrue);
  });

  test('La búsqueda filtra solo favoritas', () {
    final estado = EstadoAplicacion();

    estado.alternarFavorita('nota_01');
    final resultados = estado.buscarNotas(soloFavoritas: true);
    expect(resultados.map((nota) => nota.id), contains('nota_01'));
    expect(resultados.every((nota) => nota.esFavorita), isTrue);

    estado.alternarFavorita('nota_01');
  });
}
