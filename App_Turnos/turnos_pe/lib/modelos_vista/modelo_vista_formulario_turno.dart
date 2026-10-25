import 'package:flutter/foundation.dart';

import '../datos/almacen_turnos.dart';
import '../modelos/categoria_servicio.dart';
import '../modelos/cliente.dart';
import '../modelos/datos_iniciales_turno.dart';
import '../modelos/estilista.dart';
import '../modelos/filtros.dart';
import '../modelos/franja.dart';
import '../modelos/reglas_turno.dart';
import '../modelos/servicio.dart';
import '../modelos/turno.dart';

/// Campos del formulario, en el orden en que se validan y se enfocan.
enum CampoFormulario { cliente, servicios, estilista, fecha, hora, notas }

/// ViewModel del formulario de turno (crear y editar).
class ModeloVistaFormularioTurno extends ChangeNotifier {
  ModeloVistaFormularioTurno(
    this._store, {
    this.turnoId,
    DatosInicialesTurno? iniciales,
  }) {
    final existente = turnoId == null ? null : _store.turnoPorId(turnoId!);
    if (existente != null) {
      clienteId = existente.clienteId;
      servicioIds.addAll(existente.servicioIds);
      estilistaId = existente.estilistaId;
      fecha = ReglasTurno.soloFecha(existente.inicio);
      hora = existente.inicio;
      notas = existente.notas;
      final cliente = _store.clientePorId(existente.clienteId);
      if (cliente != null) {
        filtroPublico = FiltroPublico.desdeGenero(cliente.genero);
      }
    } else if (iniciales != null) {
      if (iniciales.clienteId != null) {
        _aplicarCliente(iniciales.clienteId!);
      }
      final servicioId = iniciales.servicioId;
      if (servicioId != null && _store.servicioPorId(servicioId) != null) {
        servicioIds.add(servicioId);
      }
      if (iniciales.fecha != null) {
        fecha = ReglasTurno.soloFecha(iniciales.fecha!);
      }
    }
    _original = _fotoActual();
  }

  final AlmacenTurnos _store;
  final String? turnoId;

  String? clienteId;
  final Set<String> servicioIds = <String>{};
  String? estilistaId;
  DateTime? fecha;
  DateTime? hora;
  String notas = '';
  FiltroPublico filtroPublico = FiltroPublico.todos;

  final Map<CampoFormulario, String> errores = <CampoFormulario, String>{};

  /// Error devuelto por las reglas de negocio al intentar guardar.
  String? errorAlGuardar;

  String? _original;

  bool get esEdicion => turnoId != null;

  bool get tieneCambios => _fotoActual() != _original;

  Cliente? get cliente =>
      clienteId == null ? null : _store.clientePorId(clienteId!);

  Estilista? get estilista =>
      estilistaId == null ? null : _store.estilistaPorId(estilistaId!);

  List<String> get todosLosServicioIds => servicioIds.toList(growable: false);

  /// Servicios elegidos agrupados por categoria, en el orden del catalogo.
  List<Servicio> get serviciosElegidos {
    final elegidos = _store.servicios
        .where((servicio) => servicioIds.contains(servicio.id))
        .toList();
    elegidos.sort((a, b) {
      final categoria = a.categoria.index.compareTo(b.categoria.index);
      if (categoria != 0) return categoria;
      return a.nombre.compareTo(b.nombre);
    });
    return elegidos;
  }

  List<CategoriaServicio> get categoriasElegidas {
    final categorias = <CategoriaServicio>[];
    for (final servicio in serviciosElegidos) {
      if (!categorias.contains(servicio.categoria)) {
        categorias.add(servicio.categoria);
      }
    }
    return categorias;
  }

  List<Servicio> serviciosDeCategoria(CategoriaServicio categoria) =>
      serviciosElegidos
          .where((servicio) => servicio.categoria == categoria)
          .toList();

  /// Estilistas que realizan todos los servicios elegidos.
  List<Estilista> get estilistasDisponibles =>
      _store.estilistasQueRealizanTodos(servicioIds);

  int get duracionMinutos => ReglasTurno.duracionTotal(serviciosElegidos);

  double get precioTotal => ReglasTurno.precioTotal(serviciosElegidos);

  DateTime? get horaFin {
    final inicio = hora;
    if (inicio == null || duracionMinutos == 0) return null;
    return ReglasTurno.horaFin(inicio, duracionMinutos);
  }

  String get resumenDuracion => duracionMinutos == 0
      ? '--'
      : ReglasTurno.formatearDuracion(duracionMinutos);

  String get resumenFin =>
      horaFin == null ? '--' : ReglasTurno.formatearHora(horaFin!);

  String get resumenPrecio =>
      precioTotal == 0 ? '\$ 0' : '\$ ${precioTotal.toStringAsFixed(0)}';

  bool get resumenCompleto =>
      servicioIds.isNotEmpty && hora != null && fecha != null;

  bool get fechaSeleccionadaEsDomingo =>
      fecha != null && ReglasTurno.esDomingo(fecha!);

  List<Franja> get franjas {
    if (estilistaId == null || servicioIds.isEmpty) {
      return const <Franja>[];
    }
    // Si todavia no hay fecha se previsualiza el primer dia con franjas
    // libres: asi el usuario ve de una vez las horas que puede elegir y el
    // error de la fecha sigue apareciendo hasta que elija una.
    if (fecha != null) return _franjasDe(fecha!);
    final dias = _proximosDias();
    for (final dia in dias) {
      final lista = _franjasDe(dia);
      if (lista.any((franja) => franja.disponible)) return lista;
    }
    return _franjasDe(dias.first);
  }

  List<Franja> _franjasDe(DateTime dia) {
    return _store.franjasDe(
      fecha: dia,
      servicioIds: servicioIds.toList(growable: false),
      estilistaId: estilistaId,
      clienteId: clienteId,
      turnoEditandoId: turnoId,
    );
  }

  /// Los proximos dias habiles a partir de hoy.
  List<DateTime> _proximosDias() {
    final hoy = ReglasTurno.soloFecha(_store.ahora);
    final dias = <DateTime>[];
    var dia = hoy;
    while (dias.length < 7) {
      if (!ReglasTurno.esDomingo(dia)) dias.add(dia);
      dia = dia.add(const Duration(days: 1));
    }
    return dias;
  }

  bool get hayFranjasLibres => franjas.any((franja) => franja.disponible);

  /// Hay cuadricula pero ninguna franja libre con los datos actuales.
  bool get sinFranjasLibres => franjas.isNotEmpty && !hayFranjasLibres;

  // ---------------------------------------------------------------------------
  // Acciones
  // ---------------------------------------------------------------------------

  void _aplicarCliente(String id) {
    clienteId = id;
    final seleccionado = _store.clientePorId(id);
    if (seleccionado != null) {
      // Al elegir un cliente el filtro de publico se ajusta a su genero.
      filtroPublico = FiltroPublico.desdeGenero(seleccionado.genero);
    }
  }

  void seleccionarCliente(String? id) {
    if (id == null) {
      clienteId = null;
    } else {
      _aplicarCliente(id);
    }
    errores.remove(CampoFormulario.cliente);
    hora = null;
    errorAlGuardar = null;
    notifyListeners();
  }

  /// Devuelve true si el estilista elegido dejo de ser valido y se limpio.
  bool alternarServicio(String servicioId) {
    if (servicioIds.contains(servicioId)) {
      servicioIds.remove(servicioId);
    } else {
      servicioIds.add(servicioId);
    }
    errores.remove(CampoFormulario.servicios);
    final aviso = _revisarEstilista();
    _revisarHora();
    errorAlGuardar = null;
    notifyListeners();
    return aviso;
  }

  /// Si los servicios cambian y el estilista deja de realizarlos, se limpia.
  bool _revisarEstilista() {
    if (estilistaId == null) return false;
    final actual = _store.estilistaPorId(estilistaId!);
    if (actual != null && actual.realizaTodos(servicioIds)) return false;
    estilistaId = null;
    hora = null;
    return servicioIds.isNotEmpty;
  }

  void _revisarHora() {
    final inicio = hora;
    if (inicio == null) return;
    final libres = franjas;
    final sigueLibre = libres.any(
      (franja) => franja.disponible && franja.hora == inicio,
    );
    if (!sigueLibre) hora = null;
  }

  void seleccionarEstilista(String? id) {
    if (estilistaId == id) return;
    estilistaId = id;
    errores.remove(CampoFormulario.estilista);
    hora = null;
    errorAlGuardar = null;
    notifyListeners();
  }

  void seleccionarFecha(DateTime? valor) {
    final nueva = valor == null ? null : ReglasTurno.soloFecha(valor);
    if (nueva == fecha) return;
    fecha = nueva;
    errores.remove(CampoFormulario.fecha);
    hora = null;
    errorAlGuardar = null;
    notifyListeners();
  }

  void seleccionarHora(DateTime? valor) {
    if (valor != null && valor == hora) {
      hora = null;
    } else {
      hora = valor;
      // Si todavia no hay fecha, la franja elegida fija el dia previsualizado.
      if (valor != null && fecha == null) {
        fecha = ReglasTurno.soloFecha(valor);
        errores.remove(CampoFormulario.fecha);
      }
    }
    errores.remove(CampoFormulario.hora);
    errorAlGuardar = null;
    notifyListeners();
  }

  void cambiarNotas(String valor) {
    notas = valor;
    if (valor.trim().isNotEmpty) errores.remove(CampoFormulario.notas);
    notifyListeners();
  }

  void cambiarFiltroPublico(FiltroPublico valor) {
    if (filtroPublico == valor) return;
    filtroPublico = valor;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Validacion y guardado
  // ---------------------------------------------------------------------------

  bool validar() {
    errores.clear();
    final cliente = mensajeCliente();
    if (cliente != null) errores[CampoFormulario.cliente] = cliente;
    final servicios = mensajeServicios();
    if (servicios != null) errores[CampoFormulario.servicios] = servicios;
    final estilista = mensajeEstilista();
    if (estilista != null) errores[CampoFormulario.estilista] = estilista;
    final fecha = mensajeFecha();
    if (fecha != null) errores[CampoFormulario.fecha] = fecha;
    final hora = mensajeHora();
    if (hora != null) errores[CampoFormulario.hora] = hora;
    final notas = mensajeNotas();
    if (notas != null) errores[CampoFormulario.notas] = notas;
    notifyListeners();
    return errores.isEmpty;
  }

  // Mensajes de validacion por campo. Son reglas de negocio, asi que viven
  // en el modelo de vista y los usan tanto el [Form] como la pantalla.

  /// Mensaje de error del cliente, o null si ya hay uno elegido.
  String? mensajeCliente() =>
      clienteId == null ? 'Selecciona un cliente' : null;

  /// Mensaje de error de los servicios, o null si hay alguno elegido.
  String? mensajeServicios() =>
      servicioIds.isEmpty ? 'Elige al menos un servicio' : null;

  /// Mensaje de error del estilista, o null si ya hay uno elegido.
  String? mensajeEstilista() =>
      estilistaId == null ? 'Selecciona un estilista' : null;

  /// Mensaje de error de la fecha, o null si ya hay una valida.
  String? mensajeFecha() =>
      fecha == null ? 'Elige una fecha válida (no domingos)' : null;

  /// Mensaje de error de la hora, o null si ya hay una elegida.
  String? mensajeHora() => hora == null ? 'Elige una hora para el turno' : null;

  /// Mensaje de error de las notas, o null si no superan el limite.
  String? mensajeNotas() => notas.length > 500
      ? 'Las notas no pueden pasar de 500 caracteres'
      : null;

  /// Primer campo con error, para llevar el foco ahi.
  CampoFormulario? get primerCampoConError {
    for (final campo in CampoFormulario.values) {
      if (errores.containsKey(campo)) return campo;
    }
    return null;
  }

  String? get errorCliente => errores[CampoFormulario.cliente];
  String? get errorServicios => errores[CampoFormulario.servicios];
  String? get errorEstilista => errores[CampoFormulario.estilista];
  String? get errorFecha => errores[CampoFormulario.fecha];
  String? get errorHora => errores[CampoFormulario.hora];
  String? get errorNotas => errores[CampoFormulario.notas];

  /// Valida y guarda. Devuelve el turno guardado o null si no se pudo.
  Turno? guardar() {
    errorAlGuardar = null;
    if (!validar()) return null;

    final inicio = hora;
    if (inicio == null) return null;

    final error = _store.validarTurno(
      clienteId: clienteId!,
      estilistaId: estilistaId!,
      servicioIds: servicioIds.toList(growable: false),
      inicio: inicio,
      turnoEditandoId: turnoId,
    );
    if (error != null) {
      errorAlGuardar = error;
      notifyListeners();
      return null;
    }

    final guardado = _store.guardarTurno(
      turnoId: turnoId,
      clienteId: clienteId!,
      estilistaId: estilistaId!,
      servicioIds: servicioIds.toList(growable: false),
      inicio: inicio,
      notas: notas.trim(),
    );
    _original = _fotoActual();
    notifyListeners();
    return guardado;
  }

  String _fotoActual() => [
    clienteId,
    (servicioIds.toList()..sort()).join(','),
    estilistaId,
    fecha?.toIso8601String(),
    hora?.toIso8601String(),
    notas.trim(),
  ].join('|');
}
