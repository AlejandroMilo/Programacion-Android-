import 'package:flutter_test/flutter_test.dart';
import 'package:turnos_pe/datos/almacen_turnos.dart';
import 'package:turnos_pe/modelos/categoria_servicio.dart';
import 'package:turnos_pe/modelos/cliente.dart';
import 'package:turnos_pe/modelos/estado_turno.dart';
import 'package:turnos_pe/modelos/estilista.dart';
import 'package:turnos_pe/modelos/franja.dart';
import 'package:turnos_pe/modelos/genero.dart';
import 'package:turnos_pe/modelos/publico.dart';
import 'package:turnos_pe/modelos/reglas_turno.dart';
import 'package:turnos_pe/modelos/servicio.dart';

void main() {
  late AlmacenTurnos store;
  late DateTime dia;

  DateTime proximoDiaHabil() {
    var fecha = DateTime.now().add(const Duration(days: 3));
    while (fecha.weekday == DateTime.sunday) {
      fecha = fecha.add(const Duration(days: 1));
    }
    return DateTime(fecha.year, fecha.month, fecha.day);
  }

  setUp(() {
    store = AlmacenTurnos(conDatosDePrueba: false);
    dia = proximoDiaHabil();

    store.servicios.addAll(const [
      Servicio(
        id: 's1',
        nombre: 'Corte',
        categoria: CategoriaServicio.corte,
        duracionMinutos: 60,
        precio: 30,
        publico: Publico.unisex,
      ),
      Servicio(
        id: 's2',
        nombre: 'Barba',
        categoria: CategoriaServicio.barba,
        duracionMinutos: 30,
        precio: 20,
        publico: Publico.hombres,
      ),
    ]);
    store.estilistas.addAll([
      const Estilista(
        id: 'e1',
        nombre: 'Ana',
        avatar: 'assets/imagenes/avatar_marta.png',
        servicioIds: ['s1', 's2'],
      ),
      const Estilista(
        id: 'e2',
        nombre: 'Beto',
        avatar: 'assets/imagenes/avatar_pedro.png',
        servicioIds: ['s1'],
      ),
    ]);
    store.clientes.addAll([
      Cliente(
        id: 'c1',
        nombre: 'Luis',
        telefono: '12345678',
        genero: Genero.hombre,
        fechaRegistro: DateTime(2026, 1, 1),
      ),
      Cliente(
        id: 'c2',
        nombre: 'Eva',
        telefono: '87654321',
        genero: Genero.mujer,
        fechaRegistro: DateTime(2026, 1, 1),
      ),
    ]);
  });

  test('la duración y el precio se calculan sumando los servicios', () {
    final servicios = [store.servicioPorId('s1')!, store.servicioPorId('s2')!];
    expect(ReglasTurno.duracionTotal(servicios), 90);
    expect(ReglasTurno.precioTotal(servicios), 50);
  });

  test('el estilista debe realizar todos los servicios elegidos', () {
    expect(store.estilistasQueRealizanTodos(['s1', 's2']).single.id, 'e1');
    expect(store.estilistasQueRealizanTodos(['s2']).single.id, 'e1');
    expect(store.estilistasQueRealizanTodos(['s1']).length, 2);
  });

  test('no se permiten turnos en domingo', () {
    var domingo = dia.add(const Duration(days: 1));
    while (domingo.weekday != DateTime.sunday) {
      domingo = domingo.add(const Duration(days: 1));
    }
    final inicio = DateTime(domingo.year, domingo.month, domingo.day, 10, 0);
    final error = store.validarTurno(
      clienteId: 'c1',
      estilistaId: 'e1',
      servicioIds: ['s1'],
      inicio: inicio,
    );
    expect(error, isNotNull);
    expect(error, contains('domingos'));
  });

  test('no se permiten turnos en el pasado', () {
    var ayer = ReglasTurno.soloFecha(DateTime.now())
        .subtract(const Duration(days: 1));
    while (ayer.weekday == DateTime.sunday) {
      ayer = ayer.subtract(const Duration(days: 1));
    }
    final error = store.validarTurno(
      clienteId: 'c1',
      estilistaId: 'e1',
      servicioIds: ['s1'],
      inicio: DateTime(ayer.year, ayer.month, ayer.day, 10, 0),
    );
    expect(error, contains('ya pasaron'));
  });

  test('el turno no puede terminar después de las 19:00', () {
    final error = store.validarTurno(
      clienteId: 'c1',
      estilistaId: 'e1',
      servicioIds: ['s1'],
      inicio: DateTime(dia.year, dia.month, dia.day, 18, 30),
    );
    expect(error, contains('19:00'));
  });

  test('el estilista y el cliente no pueden tener turnos solapados', () {
    final inicio = DateTime(dia.year, dia.month, dia.day, 10, 0);
    expect(
      store.validarTurno(
        clienteId: 'c1',
        estilistaId: 'e1',
        servicioIds: ['s1'],
        inicio: inicio,
      ),
      isNull,
    );

    final turno = store.guardarTurno(
      clienteId: 'c1',
      estilistaId: 'e1',
      servicioIds: ['s1'],
      inicio: inicio,
      notas: '',
    );
    expect(turno.estado, EstadoTurno.programado);

    final ocupadoEstilista = store.validarTurno(
      clienteId: 'c2',
      estilistaId: 'e1',
      servicioIds: ['s1'],
      inicio: DateTime(dia.year, dia.month, dia.day, 10, 30),
    );
    expect(ocupadoEstilista, contains('ya tiene un turno'));

    final ocupadoCliente = store.validarTurno(
      clienteId: 'c1',
      estilistaId: 'e2',
      servicioIds: ['s1'],
      inicio: DateTime(dia.year, dia.month, dia.day, 10, 30),
    );
    expect(ocupadoCliente, contains('cliente ya tiene un turno'));
  });

  test('las franjas reflejan los turnos del estilista', () {
    final inicio = DateTime(dia.year, dia.month, dia.day, 10, 0);

    List<Franja> franjas() => store.franjasDe(
      fecha: dia,
      servicioIds: ['s1'],
      estilistaId: 'e1',
      clienteId: 'c1',
    );

    expect(franjas().firstWhere((f) => f.hora.hour == 10).disponible, isTrue);

    store.guardarTurno(
      clienteId: 'c1',
      estilistaId: 'e1',
      servicioIds: ['s1'],
      inicio: inicio,
      notas: '',
    );

    final franja10 = franjas().firstWhere((f) => f.hora.hour == 10);
    expect(franja10.disponible, isFalse);
    expect(franja10.motivo, 'Estilista ocupado');
    expect(franjas().firstWhere((f) => f.hora.hour == 11).disponible, isTrue);
  });

  test('cancelar libera el horario y no cuenta como ingreso', () {
    final inicio = DateTime(dia.year, dia.month, dia.day, 10, 0);
    final turno = store.guardarTurno(
      clienteId: 'c1',
      estilistaId: 'e1',
      servicioIds: ['s1'],
      inicio: inicio,
      notas: '',
    );

    expect(store.resumenDelDia(dia).ingresoEstimado, 30);
    store.cancelarTurno(turno.id);

    final resumen = store.resumenDelDia(dia);
    expect(resumen.ingresoEstimado, 0);
    expect(resumen.programados, 0);
    expect(
      store
          .franjasDe(fecha: dia, servicioIds: ['s1'], estilistaId: 'e1')
          .firstWhere((f) => f.hora.hour == 10)
          .disponible,
      isTrue,
    );
  });

  test('no se puede eliminar un cliente con turnos programados', () {
    store.guardarTurno(
      clienteId: 'c1',
      estilistaId: 'e1',
      servicioIds: ['s1'],
      inicio: DateTime(dia.year, dia.month, dia.day, 10, 0),
      notas: '',
    );

    expect(store.eliminarCliente('c1'), contains('turnos programados'));
    expect(store.clientePorId('c1'), isNotNull);

    final turno = store.turnos.single;
    store.completarTurno(turno.id);

    expect(store.eliminarCliente('c1'), isNull);
    expect(store.clientePorId('c1'), isNull);
    expect(store.turnos, isEmpty);
  });
}
