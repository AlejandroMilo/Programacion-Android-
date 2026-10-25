import 'package:flutter/foundation.dart';

import '../modelos/categoria_servicio.dart';
import '../modelos/cliente.dart';
import '../modelos/estado_turno.dart';
import '../modelos/estilista.dart';
import '../modelos/franja.dart';
import '../modelos/genero.dart';
import '../modelos/publico.dart';
import '../modelos/reglas_turno.dart';
import '../modelos/servicio.dart';
import '../modelos/turno.dart';
import '../modelos/turno_vista.dart';

/// Resumen del dia que se muestra en la Agenda.
class ResumenDia {
  const ResumenDia({
    required this.programados,
    required this.completados,
    required this.ingresoEstimado,
  });

  final int programados;
  final int completados;
  final double ingresoEstimado;

  String get ingresoTexto => '\$ ${ingresoEstimado.toStringAsFixed(0)}';
}

/// Fuente de datos en memoria de la app. Se carga con los datos de prueba
/// y notifica a las vistas (MVVM con ChangeNotifier) ante cualquier cambio.
class AlmacenTurnos extends ChangeNotifier {
  AlmacenTurnos({bool conDatosDePrueba = true, DateTime Function()? reloj})
    : _reloj = reloj ?? DateTime.now {
    if (conDatosDePrueba) _cargarDatosPrueba();
  }

  /// Permite fijar la hora en pruebas y capturas; en la app es `DateTime.now`.
  final DateTime Function() _reloj;

  final List<Servicio> servicios = <Servicio>[];
  final List<Estilista> estilistas = <Estilista>[];
  final List<Cliente> clientes = <Cliente>[];
  final List<Turno> turnos = <Turno>[];

  int _secuencia = 0;

  DateTime get ahora => _reloj();

  String nuevoId(String prefijo) =>
      '$prefijo${++_secuencia}_${DateTime.now().microsecondsSinceEpoch}';

  // ---------------------------------------------------------------------------
  // Consultas basicas
  // ---------------------------------------------------------------------------

  Servicio? servicioPorId(String id) {
    for (final servicio in servicios) {
      if (servicio.id == id) return servicio;
    }
    return null;
  }

  Estilista? estilistaPorId(String id) {
    for (final estilista in estilistas) {
      if (estilista.id == id) return estilista;
    }
    return null;
  }

  Cliente? clientePorId(String id) {
    for (final cliente in clientes) {
      if (cliente.id == id) return cliente;
    }
    return null;
  }

  Turno? turnoPorId(String id) {
    for (final turno in turnos) {
      if (turno.id == id) return turno;
    }
    return null;
  }

  List<Servicio> serviciosDe(Turno turno) => turno.servicioIds
      .map(servicioPorId)
      .whereType<Servicio>()
      .toList(growable: false);

  TurnoVista? vistaDe(String turnoId) {
    final turno = turnoPorId(turnoId);
    if (turno == null) return null;
    final cliente = clientePorId(turno.clienteId);
    final estilista = estilistaPorId(turno.estilistaId);
    if (cliente == null || estilista == null) return null;
    return TurnoVista(
      turno: turno,
      cliente: cliente,
      estilista: estilista,
      servicios: serviciosDe(turno),
    );
  }

  List<TurnoVista> turnosDelDia(DateTime fecha) {
    final lista = turnos
        .where((turno) => ReglasTurno.mismoDia(turno.inicio, fecha))
        .map((turno) => vistaDe(turno.id))
        .whereType<TurnoVista>()
        .toList();
    lista.sort((a, b) => a.turno.inicio.compareTo(b.turno.inicio));
    return lista;
  }

  ResumenDia resumenDelDia(DateTime fecha) {
    var programados = 0;
    var completados = 0;
    var ingreso = 0.0;
    for (final vista in turnosDelDia(fecha)) {
      if (vista.turno.estado == EstadoTurno.programado) {
        programados++;
        ingreso += vista.precioTotal;
      } else if (vista.turno.estado == EstadoTurno.completado) {
        completados++;
        ingreso += vista.precioTotal;
      }
    }
    return ResumenDia(
      programados: programados,
      completados: completados,
      ingresoEstimado: ingreso,
    );
  }

  /// Turnos de un cliente, mas recientes primero (historial).
  List<TurnoVista> historialDeCliente(String clienteId) {
    final lista = turnos
        .where((turno) => turno.clienteId == clienteId)
        .map((turno) => vistaDe(turno.id))
        .whereType<TurnoVista>()
        .toList();
    lista.sort((a, b) => b.turno.inicio.compareTo(a.turno.inicio));
    return lista;
  }

  int cantidadTurnosDeCliente(String clienteId) =>
      turnos.where((turno) => turno.clienteId == clienteId).length;

  bool clienteTieneTurnosProgramados(String clienteId) => turnos.any(
    (turno) =>
        turno.clienteId == clienteId && turno.estado == EstadoTurno.programado,
  );

  int turnosDeHoyDeEstilista(String estilistaId) {
    final hoy = ReglasTurno.soloFecha(ahora);
    return turnos
        .where(
          (turno) =>
              turno.estilistaId == estilistaId &&
              turno.estado != EstadoTurno.cancelado &&
              ReglasTurno.mismoDia(turno.inicio, hoy),
        )
        .length;
  }

  /// Un estilista solo puede recibir turnos con servicios que realiza.
  List<Estilista> estilistasQueRealizanTodos(Iterable<String> servicioIds) {
    final ids = servicioIds.toList(growable: false);
    if (ids.isEmpty) return const <Estilista>[];
    return estilistas.where((e) => e.realizaTodos(ids)).toList(growable: false);
  }

  List<Servicio> serviciosDeCategoria(CategoriaServicio categoria) =>
      servicios.where((s) => s.categoria == categoria).toList();

  Map<Genero, int> totalesDeClientesPorGenero() {
    final totales = <Genero, int>{Genero.mujer: 0, Genero.hombre: 0};
    for (final cliente in clientes) {
      totales[cliente.genero] = (totales[cliente.genero] ?? 0) + 1;
    }
    return totales;
  }

  bool telefonoEnUso(String telefono, {String? exceptoId}) => clientes.any(
    (cliente) => cliente.telefono == telefono && cliente.id != exceptoId,
  );

  // ---------------------------------------------------------------------------
  // Franjas horarias
  // ---------------------------------------------------------------------------

  /// Franjas de 30 minutos del dia con su disponibilidad.
  /// Una franja no esta disponible si: es domingo, ya paso, el turno no
  /// terminaria antes de las 19:00, o el estilista / el cliente ya tiene un
  /// turno programado que se solapa.
  List<Franja> franjasDe({
    required DateTime fecha,
    required List<String> servicioIds,
    String? estilistaId,
    String? clienteId,
    String? turnoEditandoId,
  }) {
    final dia = ReglasTurno.soloFecha(fecha);
    final duracion = ReglasTurno.duracionTotal(
      servicioIds.map(servicioPorId).whereType<Servicio>(),
    );
    if (duracion == 0 || estilistaId == null) return const <Franja>[];

    final cierre = dia.add(const Duration(hours: ReglasTurno.horaCierre));
    final ahora = this.ahora;
    final programados = turnos.where(
      (turno) =>
          turno.estado == EstadoTurno.programado &&
          turno.id != turnoEditandoId &&
          ReglasTurno.mismoDia(turno.inicio, dia),
    );

    final resultado = <Franja>[];
    for (
      var minutos = ReglasTurno.horaApertura * 60;
      minutos + ReglasTurno.minutosFranja <= ReglasTurno.horaCierre * 60;
      minutos += ReglasTurno.minutosFranja
    ) {
      final hora = dia.add(Duration(minutes: minutos));
      final fin = ReglasTurno.horaFin(hora, duracion);
      String? motivo;

      if (ReglasTurno.esDomingo(dia)) {
        motivo = 'Domingo: salón cerrado';
      } else if (fin.isAfter(cierre)) {
        motivo = 'No termina antes del cierre';
      } else if (ReglasTurno.mismoDia(dia, ahora) && !hora.isAfter(ahora)) {
        motivo = 'Ya pasó';
      } else {
        for (final turno in programados) {
          final ocupadoFin = ReglasTurno.horaFin(
            turno.inicio,
            ReglasTurno.duracionTotal(serviciosDe(turno)),
          );
          if (ReglasTurno.seSolapan(hora, fin, turno.inicio, ocupadoFin)) {
            if (turno.estilistaId == estilistaId) {
              motivo = 'Estilista ocupado';
              break;
            }
            if (clienteId != null && turno.clienteId == clienteId) {
              motivo = 'Cliente ocupado';
              break;
            }
          }
        }
      }

      resultado.add(
        Franja(hora: hora, disponible: motivo == null, motivo: motivo),
      );
    }
    return resultado;
  }

  // ---------------------------------------------------------------------------
  // Reglas de validacion
  // ---------------------------------------------------------------------------

  /// Devuelve el mensaje de error o null si el turno es valido.
  String? validarTurno({
    required String clienteId,
    required String estilistaId,
    required List<String> servicioIds,
    required DateTime inicio,
    String? turnoEditandoId,
  }) {
    final serviciosElegidos = servicioIds
        .map(servicioPorId)
        .whereType<Servicio>()
        .toList();
    if (serviciosElegidos.isEmpty) return 'Selecciona al menos un servicio';

    final estilista = estilistaPorId(estilistaId);
    if (estilista == null) return 'Selecciona un estilista';
    if (!estilista.realizaTodos(servicioIds)) {
      return '${estilista.nombre} no realiza todos los servicios elegidos';
    }

    final duracion = ReglasTurno.duracionTotal(serviciosElegidos);
    final fin = ReglasTurno.horaFin(inicio, duracion);

    if (ReglasTurno.esDomingo(inicio)) {
      return 'El salón cierra los domingos';
    }
    if (inicio.isBefore(ahora)) {
      return 'No se pueden crear turnos en una fecha y hora que ya pasaron';
    }
    if (fin.isAfter(
      inicio
          .copyWith(hour: 0, minute: 0)
          .add(const Duration(hours: ReglasTurno.horaCierre)),
    )) {
      return 'El turno no puede terminar después de las 19:00';
    }
    if (inicio.hour < ReglasTurno.horaApertura) {
      return 'El salón abre a las 9:00';
    }

    for (final turno in turnos) {
      if (turno.id == turnoEditandoId) continue;
      if (turno.estado != EstadoTurno.programado) continue;
      final ocupadoFin = ReglasTurno.horaFin(
        turno.inicio,
        ReglasTurno.duracionTotal(serviciosDe(turno)),
      );
      if (!ReglasTurno.seSolapan(inicio, fin, turno.inicio, ocupadoFin)) {
        continue;
      }
      if (turno.estilistaId == estilistaId) {
        return '${estilista.nombre} ya tiene un turno en ese horario';
      }
      if (turno.clienteId == clienteId) {
        return 'El cliente ya tiene un turno en ese horario';
      }
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Turnos
  // ---------------------------------------------------------------------------

  Turno guardarTurno({
    String? turnoId,
    required String clienteId,
    required String estilistaId,
    required List<String> servicioIds,
    required DateTime inicio,
    required String notas,
  }) {
    final momento = ahora;
    final existente = turnoId == null ? null : turnoPorId(turnoId);
    if (existente == null) {
      final nuevo = Turno(
        id: nuevoId('turno'),
        clienteId: clienteId,
        estilistaId: estilistaId,
        servicioIds: List<String>.of(servicioIds),
        inicio: inicio,
        notas: notas,
        estado: EstadoTurno.programado,
        creadoEn: momento,
        modificadoEn: momento,
      );
      turnos.add(nuevo);
      notifyListeners();
      return nuevo;
    }
    final actualizado = existente.copyWith(
      clienteId: clienteId,
      estilistaId: estilistaId,
      servicioIds: List<String>.of(servicioIds),
      inicio: inicio,
      notas: notas,
      modificadoEn: momento,
    );
    final indice = turnos.indexWhere((turno) => turno.id == existente.id);
    turnos[indice] = actualizado;
    notifyListeners();
    return actualizado;
  }

  void completarTurno(String turnoId) {
    _cambiarEstado(turnoId, EstadoTurno.completado);
  }

  /// La baja de un turno es la cancelacion: su horario vuelve a quedar libre.
  void cancelarTurno(String turnoId) {
    _cambiarEstado(turnoId, EstadoTurno.cancelado);
  }

  void _cambiarEstado(String turnoId, EstadoTurno estado) {
    final turno = turnoPorId(turnoId);
    if (turno == null || !turno.estado.esEditable) return;
    final indice = turnos.indexWhere((t) => t.id == turnoId);
    turnos[indice] = turno.copyWith(estado: estado, modificadoEn: ahora);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Clientes
  // ---------------------------------------------------------------------------

  Cliente agregarCliente({
    required String nombre,
    required String telefono,
    required Genero genero,
    String? correo,
  }) {
    final cliente = Cliente(
      id: nuevoId('cliente'),
      nombre: nombre.trim(),
      telefono: telefono,
      genero: genero,
      correo: (correo == null || correo.trim().isEmpty) ? null : correo.trim(),
      fechaRegistro: ahora,
    );
    clientes.add(cliente);
    notifyListeners();
    return cliente;
  }

  void actualizarCliente(
    String clienteId, {
    required String nombre,
    required String telefono,
    required Genero genero,
    String? correo,
  }) {
    final indice = clientes.indexWhere((cliente) => cliente.id == clienteId);
    if (indice == -1) return;
    clientes[indice] = clientes[indice].copyWith(
      nombre: nombre.trim(),
      telefono: telefono,
      genero: genero,
      correo: (correo == null || correo.trim().isEmpty) ? null : correo.trim(),
      limpiarCorreo: correo == null || correo.trim().isEmpty,
    );
    notifyListeners();
  }

  /// Elimina un cliente y su historial de turnos completados y cancelados.
  /// Devuelve el mensaje de error si no se puede eliminar (turnos programados).
  String? eliminarCliente(String clienteId) {
    if (clienteTieneTurnosProgramados(clienteId)) {
      return 'No se puede eliminar: el cliente tiene turnos programados';
    }
    clientes.removeWhere((cliente) => cliente.id == clienteId);
    turnos.removeWhere((turno) => turno.clienteId == clienteId);
    notifyListeners();
    return null;
  }

  // ---------------------------------------------------------------------------
  // Datos de prueba
  // ---------------------------------------------------------------------------

  void _cargarDatosPrueba() {
    servicios.addAll(const [
      Servicio(
        id: 's1',
        nombre: 'Corte mujer',
        categoria: CategoriaServicio.corte,
        duracionMinutos: 60,
        precio: 30,
        publico: Publico.mujeres,
      ),
      Servicio(
        id: 's2',
        nombre: 'Corte caballero',
        categoria: CategoriaServicio.corte,
        duracionMinutos: 45,
        precio: 25,
        publico: Publico.hombres,
      ),
      Servicio(
        id: 's3',
        nombre: 'Corte clásico',
        categoria: CategoriaServicio.corte,
        duracionMinutos: 45,
        precio: 28,
        publico: Publico.unisex,
      ),
      Servicio(
        id: 's4',
        nombre: 'Color completo',
        categoria: CategoriaServicio.color,
        duracionMinutos: 120,
        precio: 70,
        publico: Publico.mujeres,
      ),
      Servicio(
        id: 's5',
        nombre: 'Color de raíz',
        categoria: CategoriaServicio.color,
        duracionMinutos: 60,
        precio: 45,
        publico: Publico.mujeres,
      ),
      Servicio(
        id: 's6',
        nombre: 'Color caballero',
        categoria: CategoriaServicio.color,
        duracionMinutos: 45,
        precio: 35,
        publico: Publico.hombres,
      ),
      Servicio(
        id: 's7',
        nombre: 'Barba',
        categoria: CategoriaServicio.barba,
        duracionMinutos: 45,
        precio: 20,
        publico: Publico.hombres,
      ),
      Servicio(
        id: 's8',
        nombre: 'Afeitado',
        categoria: CategoriaServicio.barba,
        duracionMinutos: 30,
        precio: 18,
        publico: Publico.hombres,
      ),
      Servicio(
        id: 's9',
        nombre: 'Peinado evento',
        categoria: CategoriaServicio.peinado,
        duracionMinutos: 60,
        precio: 40,
        publico: Publico.unisex,
      ),
      Servicio(
        id: 's10',
        nombre: 'Peinado diario',
        categoria: CategoriaServicio.peinado,
        duracionMinutos: 30,
        precio: 20,
        publico: Publico.unisex,
      ),
      Servicio(
        id: 's11',
        nombre: 'Hidratación',
        categoria: CategoriaServicio.tratamiento,
        duracionMinutos: 45,
        precio: 28,
        publico: Publico.unisex,
      ),
      Servicio(
        id: 's12',
        nombre: 'Keratina',
        categoria: CategoriaServicio.tratamiento,
        duracionMinutos: 90,
        precio: 65,
        publico: Publico.mujeres,
      ),
    ]);

    estilistas.addAll(const [
      Estilista(
        id: 'e1',
        nombre: 'Marta Salazar',
        avatar: 'assets/imagenes/avatar_marta.png',
        servicioIds: ['s1', 's4', 's5', 's9', 's12'],
      ),
      Estilista(
        id: 'e2',
        nombre: 'Pedro Vega',
        avatar: 'assets/imagenes/avatar_pedro.png',
        servicioIds: ['s2', 's6', 's7', 's8'],
      ),
      Estilista(
        id: 'e3',
        nombre: 'Lucía Torres',
        avatar: 'assets/imagenes/avatar_lucia.png',
        servicioIds: ['s1', 's2', 's3', 's9', 's11'],
      ),
      Estilista(
        id: 'e4',
        nombre: 'Rafael Núñez',
        avatar: 'assets/imagenes/avatar_rafael.png',
        servicioIds: ['s2', 's7', 's8'],
      ),
      Estilista(
        id: 'e5',
        nombre: 'Noelia Castro',
        avatar: 'assets/imagenes/avatar_noelia.png',
        // Solo servicios de mujeres (el enunciado pide un estilista de este
        // tipo, ademas de uno de hombres y otro que haga de ambos).
        servicioIds: ['s4', 's5', 's12'],
      ),
    ]);

    final hoy = ReglasTurno.soloFecha(ahora);
    final registro = hoy.subtract(const Duration(days: 120));

    clientes.addAll([
      Cliente(
        id: 'c1',
        nombre: 'Laura Gómez',
        telefono: '52111222',
        genero: Genero.mujer,
        correo: 'laura.gomez@correo.com',
        fechaRegistro: registro,
      ),
      Cliente(
        id: 'c2',
        nombre: 'Carlos Ruiz',
        telefono: '52345678',
        genero: Genero.hombre,
        correo: 'carlos.ruiz@correo.com',
        fechaRegistro: registro,
      ),
      Cliente(
        id: 'c3',
        nombre: 'Ana Martín',
        telefono: '53220140',
        genero: Genero.mujer,
        fechaRegistro: registro,
      ),
      Cliente(
        id: 'c4',
        nombre: 'Diego Pérez',
        telefono: '55908771',
        genero: Genero.hombre,
        fechaRegistro: registro,
      ),
      Cliente(
        id: 'c5',
        nombre: 'Sofía Díaz',
        telefono: '54667310',
        genero: Genero.mujer,
        correo: 'sofia.diaz@correo.com',
        fechaRegistro: registro,
      ),
      // Cliente sin ningun turno.
      Cliente(
        id: 'c6',
        nombre: 'Javier Soto',
        telefono: '52774009',
        genero: Genero.hombre,
        fechaRegistro: registro,
      ),
      Cliente(
        id: 'c7',
        nombre: 'Marta Peña',
        telefono: '53441902',
        genero: Genero.mujer,
        fechaRegistro: registro,
      ),
      Cliente(
        id: 'c8',
        nombre: 'Elena Vargas',
        telefono: '55612804',
        genero: Genero.mujer,
        correo: 'elena.vargas@correo.com',
        fechaRegistro: registro,
      ),
      Cliente(
        id: 'c9',
        nombre: 'Hugo Ramos',
        telefono: '54120395',
        genero: Genero.hombre,
        fechaRegistro: registro,
      ),
      Cliente(
        id: 'c10',
        nombre: 'Iván Cabrera',
        telefono: '56884012',
        genero: Genero.hombre,
        fechaRegistro: registro,
      ),
    ]);

    final notasLargas =
        'La clienta prefiere el secado al aire y sin plancha. Tiene el cabello '
        'con decoloración previa en las puntas, por lo que hay que trabajar el '
        'tono con mucho cuidado y usar protector térmico antes de cualquier '
        'herramienta. Acostumbra a venir acompañada de su hermana, así que '
        'conviene reservar dos asientos en la sala de espera mientras dura el '
        'servicio. Pide cita siempre por la mañana y avisa con antelación si no '
        'puede asistir.';

    final notasCarlos =
        'Prefiere la máquina en el número 2 a los lados. Llega siempre diez '
        'minutos antes y pide agua.';

    final creado = DateTime(2026, 1, 5, 10, 0);
    final editado = DateTime(2026, 1, 6, 9, 30);

    Turno turno(
      String id,
      String clienteId,
      String estilistaId,
      List<String> servicioIds,
      int offsetDias,
      int hora,
      int minuto,
      EstadoTurno estado, {
      String notas = '',
      bool estadoPorHora = false,
    }) {
      final fecha = _diaHabil(hoy, offsetDias);
      final duracion = servicioIds.fold<int>(
        0,
        (total, id) =>
            total +
            servicios
                .firstWhere((servicio) => servicio.id == id)
                .duracionMinutos,
      );
      return Turno(
        id: id,
        clienteId: clienteId,
        estilistaId: estilistaId,
        servicioIds: servicioIds,
        inicio: DateTime(fecha.year, fecha.month, fecha.day, hora, minuto),
        notas: notas,
        estado: estadoPorHora
            ? _estadoSegunHora(fecha, hora, minuto, duracion)
            : estado,
        creadoEn: creado,
        modificadoEn: editado,
      );
    }

    turnos.addAll([
      // Dias pasados: completados o cancelados.
      turno('t1', 'c3', 'e3', ['s1', 's11'], -4, 11, 0, EstadoTurno.completado),
      turno(
        't2',
        'c8',
        'e5',
        ['s4'],
        -3,
        10,
        0,
        EstadoTurno.completado,
        notas: notasLargas,
      ),
      turno('t3', 'c4', 'e4', ['s7'], -3, 9, 0, EstadoTurno.completado),
      turno('t4', 'c9', 'e2', ['s2', 's7'], -2, 16, 0, EstadoTurno.cancelado),
      turno('t5', 'c7', 'e1', ['s1'], -2, 9, 30, EstadoTurno.completado),
      turno('t6', 'c10', 'e4', ['s7', 's8'], -1, 15, 0, EstadoTurno.cancelado),
      turno('t7', 'c1', 'e3', ['s9'], -2, 9, 0, EstadoTurno.completado),
      // Hoy: el estado se calcula con la hora actual.
      turno(
        't8',
        'c1',
        'e1',
        ['s1'],
        0,
        9,
        0,
        EstadoTurno.programado,
        estadoPorHora: true,
      ),
      turno(
        't9',
        'c2',
        'e2',
        ['s2', 's7'],
        0,
        10,
        0,
        EstadoTurno.programado,
        notas: notasCarlos,
        estadoPorHora: true,
      ),
      turno(
        't10',
        'c3',
        'e1',
        ['s5', 's9'],
        0,
        10,
        30,
        EstadoTurno.programado,
        estadoPorHora: true,
      ),
      turno('t11', 'c4', 'e2', ['s8'], 0, 12, 0, EstadoTurno.cancelado),
      turno(
        't12',
        'c5',
        'e3',
        ['s11', 's1'],
        0,
        14,
        0,
        EstadoTurno.programado,
        estadoPorHora: true,
      ),
      turno(
        't17',
        'c7',
        'e1',
        ['s1'],
        0,
        16,
        0,
        EstadoTurno.programado,
        estadoPorHora: true,
      ),
      turno(
        't18',
        'c10',
        'e4',
        ['s7', 's8'],
        0,
        17,
        30,
        EstadoTurno.programado,
        estadoPorHora: true,
      ),
      // Dias futuros: programados. Lucia es la unica que realiza los dos
      // servicios de este turno.
      turno('t13', 'c7', 'e3', ['s1', 's11'], 1, 11, 0, EstadoTurno.programado),
      turno('t14', 'c9', 'e4', ['s7'], 1, 17, 30, EstadoTurno.programado),
      // Tres servicios en un mismo turno.
      turno(
        't15',
        'c2',
        'e2',
        ['s2', 's7', 's8'],
        2,
        10,
        0,
        EstadoTurno.programado,
      ),
      // Termina exactamente a las 19:00.
      turno('t16', 'c3', 'e1', ['s9'], 2, 18, 0, EstadoTurno.programado),
    ]);

    // Orden estable por fecha para que las listas se vean ordenadas de serie.
    turnos.sort((a, b) => a.inicio.compareTo(b.inicio));
  }

  /// Fecha del dia con el desplazamiento indicado, saltando los domingos.
  /// Dia habil a `offset` dias habiles de `base` (los domingos se saltan).
  /// Asi los turnos de prueba se reparten en siete dias distintos siempre,
  /// sin que dos turnos caigan en el mismo dia por el salto de domingo.
  static DateTime _diaHabil(DateTime base, int offset) {
    var fecha = base;
    var restante = offset;
    while (restante > 0) {
      fecha = fecha.add(const Duration(days: 1));
      while (ReglasTurno.esDomingo(fecha)) {
        fecha = fecha.add(const Duration(days: 1));
      }
      restante--;
    }
    while (restante < 0) {
      fecha = fecha.subtract(const Duration(days: 1));
      while (ReglasTurno.esDomingo(fecha)) {
        fecha = fecha.subtract(const Duration(days: 1));
      }
      restante++;
    }
    return fecha;
  }

  /// Los turnos de hoy que ya terminaron quedan completados.
  EstadoTurno _estadoSegunHora(
    DateTime fecha,
    int hora,
    int minuto,
    int duracionMinutos,
  ) {
    final fin = DateTime(
      fecha.year,
      fecha.month,
      fecha.day,
      hora,
      minuto,
    ).add(Duration(minutes: duracionMinutos));
    return fin.isBefore(ahora)
        ? EstadoTurno.completado
        : EstadoTurno.programado;
  }
}

