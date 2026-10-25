import 'package:flutter_test/flutter_test.dart';
import 'package:turnos_pe/datos/almacen_turnos.dart';
import 'package:turnos_pe/modelos/estado_turno.dart';
import 'package:turnos_pe/modelos/estilista.dart';
import 'package:turnos_pe/modelos/genero.dart';
import 'package:turnos_pe/modelos/publico.dart';
import 'package:turnos_pe/modelos/reglas_turno.dart';

void main() {
  test('datos de prueba segun el enunciado', () {
    final store = AlmacenTurnos();
    final hoy = ReglasTurno.soloFecha(store.ahora);

    // Servicios
    expect(store.servicios.length, greaterThanOrEqualTo(12));
    expect(store.servicios.map((s) => s.categoria).toSet().length, 5);
    final porPublico = <Publico, int>{};
    for (final s in store.servicios) {
      porPublico[s.publico] = (porPublico[s.publico] ?? 0) + 1;
    }
    expect(porPublico[Publico.mujeres], greaterThanOrEqualTo(3));
    expect(porPublico[Publico.hombres], greaterThanOrEqualTo(3));
    expect(porPublico[Publico.unisex], greaterThanOrEqualTo(3));

    // Estilistas
    expect(store.estilistas.length, 5);
    bool soloHombres(Estilista e) =>
        e.servicioIds.isNotEmpty &&
        e.servicioIds.every(
          (id) => store.servicioPorId(id)!.publico == Publico.hombres,
        );
    bool soloMujeres(Estilista e) =>
        e.servicioIds.isNotEmpty &&
        e.servicioIds.every(
          (id) => store.servicioPorId(id)!.publico == Publico.mujeres,
        );
    bool ambos(Estilista e) =>
        e.servicioIds.any(
          (id) => store.servicioPorId(id)!.publico == Publico.hombres,
        ) &&
        e.servicioIds.any(
          (id) => store.servicioPorId(id)!.publico == Publico.mujeres,
        );
    expect(store.estilistas.where(soloHombres).isNotEmpty, isTrue);
    expect(store.estilistas.where(soloMujeres).isNotEmpty, isTrue);
    expect(store.estilistas.where(ambos).isNotEmpty, isTrue);
    expect(
      store.estilistas.map((e) => e.servicioIds.toSet()).toSet().length,
      5,
      reason: 'especialidades distintas',
    );

    // Clientes
    expect(store.clientes.length, 10);
    expect(
      store.clientes.where((c) => c.genero == Genero.mujer).length,
      greaterThanOrEqualTo(5),
    );
    expect(
      store.clientes.where((c) => c.genero == Genero.hombre).length,
      greaterThanOrEqualTo(5),
    );
    expect(
      store.clientes.where((c) => store.cantidadTurnosDeCliente(c.id) == 0).isNotEmpty,
      isTrue,
      reason: 'un cliente sin turnos',
    );

    // Turnos
    expect(store.turnos.length, greaterThanOrEqualTo(16));
    final deHoy = store.turnos
        .where((t) => ReglasTurno.mismoDia(t.inicio, hoy))
        .length;
    expect(deHoy, greaterThanOrEqualTo(4));
    expect(
      store.turnos.where((t) => t.estado == EstadoTurno.completado).length,
      greaterThanOrEqualTo(3),
    );
    expect(
      store.turnos.where((t) => t.estado == EstadoTurno.cancelado).length,
      greaterThanOrEqualTo(2),
    );
    expect(store.turnos.any((t) => t.servicioIds.length == 3), isTrue);
    expect(store.turnos.any((t) => t.notas.isEmpty), isTrue);
    expect(
      store.turnos.any((t) => t.notas.length > 300),
      isTrue,
      reason: 'un turno con notas de mas de 300 caracteres',
    );
    expect(
      store.turnos.any(
        (t) =>
            ReglasTurno.formatearHora(
              ReglasTurno.horaFin(
                t.inicio,
                store.serviciosDe(t).fold<int>(
                  0,
                  (t2, s) => t2 + s.duracionMinutos,
                ),
              ),
            ) ==
            '19:00',
      ),
      isTrue,
      reason: 'un turno que termina exactamente a las 19:00',
    );

    // Siete dias distintos alrededor de hoy
    final dias = store.turnos
        .map((t) => ReglasTurno.soloFecha(t.inicio))
        .toSet()
        .length;
    expect(dias, 7);

    // Estilista sin turnos hoy
    expect(
      store.estilistas
          .where((e) => store.turnosDeHoyDeEstilista(e.id) == 0)
          .isNotEmpty,
      isTrue,
    );

    // Ningun solape entre turnos programados del mismo estilista o cliente
    final programados = store.turnos
        .where((t) => t.estado == EstadoTurno.programado)
        .toList();
    for (var i = 0; i < programados.length; i++) {
      for (var j = i + 1; j < programados.length; j++) {
        final a = programados[i];
        final b = programados[j];
        if (a.estilistaId != b.estilistaId && a.clienteId != b.clienteId) {
          continue;
        }
        final durA = store.serviciosDe(a).fold<int>(0, (t, s) => t + s.duracionMinutos);
        final durB = store.serviciosDe(b).fold<int>(0, (t, s) => t + s.duracionMinutos);
        final finA = ReglasTurno.horaFin(a.inicio, durA);
        final finB = ReglasTurno.horaFin(b.inicio, durB);
        final solapa = a.inicio.isBefore(finB) && b.inicio.isBefore(finA);
        expect(
          solapa,
          isFalse,
          reason:
              'solape entre ${a.id} (${a.estilistaId}/${a.clienteId}) y ${b.id}',
        );
      }
    }

    // Cada estilista solo recibe servicios que realiza
    for (final turno in store.turnos) {
      final estilista = store.estilistaPorId(turno.estilistaId)!;
      for (final servicioId in turno.servicioIds) {
        expect(
          estilista.realiza(servicioId),
          isTrue,
          reason: '${estilista.nombre} no realiza $servicioId (turno ${turno.id})',
        );
      }
    }
  });
}
