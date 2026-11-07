import 'package:drift/drift.dart';

import '../../modelos/orden_servicio.dart';
import '../base_datos.dart';

part 'ordenes_dao.g.dart';

@DriftAccessor(
  tables: [
    OrdenesServicio,
    Clientes,
    Vehiculos,
    Mecanicos,
    Trabajos,
    RepuestosOrden,
    Pagos,
  ],
)
class OrdenesDao extends DatabaseAccessor<BaseDatos> with _$OrdenesDaoMixin {
  OrdenesDao(super.db);

  // ---------------------------------------------------------------------------
  // Consultas
  // ---------------------------------------------------------------------------

  Stream<List<OrdenResumen>> observar({
    String busqueda = '',
    EstadoOrden? estado,
    int? mecanicoId,
    int? clienteId,
    int? vehiculoId,
    DateTime? desde,
    DateTime? hasta,
    bool soloAbiertas = false,
    int? limite,
  }) {
    final consulta = _consulta(
      busqueda: busqueda,
      estado: estado,
      mecanicoId: mecanicoId,
      clienteId: clienteId,
      vehiculoId: vehiculoId,
      desde: desde,
      hasta: hasta,
      soloAbiertas: soloAbiertas,
    );
    return consulta.watch().map(_mapear);
  }

  Future<List<OrdenResumen>> listar({
    String busqueda = '',
    EstadoOrden? estado,
    int? mecanicoId,
    int? clienteId,
    int? vehiculoId,
    DateTime? desde,
    DateTime? hasta,
    bool soloAbiertas = false,
    int? limite,
  }) async {
    final consulta = _consulta(
      busqueda: busqueda,
      estado: estado,
      mecanicoId: mecanicoId,
      clienteId: clienteId,
      vehiculoId: vehiculoId,
      desde: desde,
      hasta: hasta,
      soloAbiertas: soloAbiertas,
    );
    final filas = await consulta.get();
    final lista = _mapear(filas);
    if (limite != null && lista.length > limite) {
      return lista.take(limite).toList();
    }
    return lista;
  }

  JoinedSelectStatement<HasResultSet, dynamic> _consulta({
    String busqueda = '',
    EstadoOrden? estado,
    int? mecanicoId,
    int? clienteId,
    int? vehiculoId,
    int? ordenId,
    DateTime? desde,
    DateTime? hasta,
    bool soloAbiertas = false,
  }) {
    final consulta = select(ordenesServicio).join([
      innerJoin(clientes, clientes.id.equalsExp(ordenesServicio.clienteId)),
      innerJoin(vehiculos, vehiculos.id.equalsExp(ordenesServicio.vehiculoId)),
      leftOuterJoin(
        mecanicos,
        mecanicos.id.equalsExp(ordenesServicio.mecanicoId),
      ),
    ]);

    Expression<bool>? filtro;
    final texto = busqueda.trim().toLowerCase();
    if (texto.isNotEmpty) {
      final patron = '%$texto%';
      filtro = ordenesServicio.numero.lower().like(patron) |
          clientes.nombre.lower().like(patron) |
          vehiculos.matricula.lower().like(patron) |
          vehiculos.marca.lower().like(patron) |
          vehiculos.modelo.lower().like(patron);
    }
    if (estado != null) {
      final condicion = ordenesServicio.estado.equalsValue(estado);
      filtro = filtro == null ? condicion : filtro & condicion;
    }
    if (mecanicoId != null) {
      final condicion = ordenesServicio.mecanicoId.equals(mecanicoId);
      filtro = filtro == null ? condicion : filtro & condicion;
    }
    if (clienteId != null) {
      final condicion = ordenesServicio.clienteId.equals(clienteId);
      filtro = filtro == null ? condicion : filtro & condicion;
    }
    if (vehiculoId != null) {
      final condicion = ordenesServicio.vehiculoId.equals(vehiculoId);
      filtro = filtro == null ? condicion : filtro & condicion;
    }
    if (ordenId != null) {
      final condicion = ordenesServicio.id.equals(ordenId);
      filtro = filtro == null ? condicion : filtro & condicion;
    }
    if (desde != null) {
      final condicion =
          ordenesServicio.fechaEntrada.isBiggerOrEqualValue(desde);
      filtro = filtro == null ? condicion : filtro & condicion;
    }
    if (hasta != null) {
      final fin = DateTime(hasta.year, hasta.month, hasta.day, 23, 59, 59);
      final condicion = ordenesServicio.fechaEntrada.isSmallerOrEqualValue(fin);
      filtro = filtro == null ? condicion : filtro & condicion;
    }
    if (soloAbiertas) {
      final condicion = ordenesServicio.estado.equalsValue(EstadoOrden.entregada).not() &
          ordenesServicio.estado.equalsValue(EstadoOrden.cancelada).not();
      filtro = filtro == null ? condicion : filtro & condicion;
    }
    if (filtro != null) consulta.where(filtro);
    consulta.orderBy([
      OrderingTerm.desc(ordenesServicio.fechaEntrada),
      OrderingTerm.desc(ordenesServicio.id),
    ]);
    return consulta;
  }

  List<OrdenResumen> _mapear(List<TypedResult> filas) {
    return filas
        .map(
          (fila) => OrdenResumen(
            orden: fila.readTable(ordenesServicio),
            cliente: fila.readTable(clientes),
            vehiculo: fila.readTable(vehiculos),
            mecanico: fila.readTableOrNull(mecanicos),
          ),
        )
        .toList();
  }

  Future<OrdenResumen?> porId(int id) async {
    final filas = await _consulta(ordenId: id).get();
    if (filas.isEmpty) return null;
    final fila = filas.first;
    return OrdenResumen(
      orden: fila.readTable(ordenesServicio),
      cliente: fila.readTable(clientes),
      vehiculo: fila.readTable(vehiculos),
      mecanico: fila.readTableOrNull(mecanicos),
    );
  }

  Stream<OrdenResumen?> observarPorId(int id) {
    return _consulta(ordenId: id).watchSingleOrNull().map((fila) {
      if (fila == null) return null;
      return OrdenResumen(
        orden: fila.readTable(ordenesServicio),
        cliente: fila.readTable(clientes),
        vehiculo: fila.readTable(vehiculos),
        mecanico: fila.readTableOrNull(mecanicos),
      );
    });
  }

  Future<OrdenResumen?> ultimaDeVehiculo(int vehiculoId) async {
    final ordenes = await listar(vehiculoId: vehiculoId);
    return ordenes.isEmpty ? null : ordenes.first;
  }

  Future<List<OrdenResumen>> deCliente(int clienteId) {
    return listar(clienteId: clienteId);
  }

  Future<List<OrdenResumen>> deVehiculo(int vehiculoId) {
    return listar(vehiculoId: vehiculoId);
  }

  Future<List<OrdenResumen>> historial({
    int? clienteId,
    int? vehiculoId,
    DateTime? desde,
    DateTime? hasta,
  }) async {
    final todas = await listar(desde: desde, hasta: hasta);
    return todas
        .where((o) => o.estado.esFinal)
        .where((o) => clienteId == null || o.cliente.id == clienteId)
        .where((o) => vehiculoId == null || o.vehiculo.id == vehiculoId)
        .toList();
  }

  Future<List<OrdenResumen>> recientes({int limite = 6}) async {
    return listar(limite: limite);
  }

  Future<List<OrdenResumen>> asignadas(int mecanicoId) {
    return listar(mecanicoId: mecanicoId, soloAbiertas: true);
  }

  Future<int> contarAbiertas({int? mecanicoId}) async {
    final lista = await listar(mecanicoId: mecanicoId, soloAbiertas: true);
    return lista.length;
  }

  Future<int> contarPorEstado(EstadoOrden estado, {int? mecanicoId}) async {
    final lista = await listar(estado: estado, mecanicoId: mecanicoId);
    return lista.length;
  }

  // ---------------------------------------------------------------------------
  // Totales
  // ---------------------------------------------------------------------------

  Stream<TotalesOrden> observarTotales(int ordenId) {
    return customSelect(
      '''
      SELECT
        COALESCE((SELECT SUM(precio_mano_obra) FROM trabajos WHERE orden_id = ?), 0) AS mano,
        COALESCE((SELECT SUM(cantidad * precio_unitario) FROM repuestos_orden WHERE orden_id = ?), 0) AS repuestos,
        COALESCE((SELECT SUM(importe) FROM pagos WHERE orden_id = ?), 0) AS pagado
      ''',
      variables: [
        Variable.withInt(ordenId),
        Variable.withInt(ordenId),
        Variable.withInt(ordenId),
      ],
      readsFrom: {trabajos, repuestosOrden, pagos},
    ).watchSingle().map(_leerTotales);
  }

  Future<TotalesOrden> totales(int ordenId) async {
    final fila = await customSelect(
      '''
      SELECT
        COALESCE((SELECT SUM(precio_mano_obra) FROM trabajos WHERE orden_id = ?), 0) AS mano,
        COALESCE((SELECT SUM(cantidad * precio_unitario) FROM repuestos_orden WHERE orden_id = ?), 0) AS repuestos,
        COALESCE((SELECT SUM(importe) FROM pagos WHERE orden_id = ?), 0) AS pagado
      ''',
      variables: [
        Variable.withInt(ordenId),
        Variable.withInt(ordenId),
        Variable.withInt(ordenId),
      ],
      readsFrom: {trabajos, repuestosOrden, pagos},
    ).getSingle();
    return _leerTotales(fila);
  }

  TotalesOrden _leerTotales(QueryRow fila) {
    final mano = fila.read<double>('mano');
    final repuestos = fila.read<double>('repuestos');
    final pagado = fila.read<double>('pagado');
    return TotalesOrden(
      manoObra: mano.toDouble(),
      repuestos: repuestos.toDouble(),
      pagado: pagado.toDouble(),
    );
  }

  // ---------------------------------------------------------------------------
  // Escrituras
  // ---------------------------------------------------------------------------

  Future<int> crear({
    required int clienteId,
    required int vehiculoId,
    int? mecanicoId,
    required DateTime fechaEntrada,
    required String problema,
    required int kilometrajeEntrada,
    String? notas,
  }) {
    return transaction(() async {
      final total = (await select(ordenesServicio).get()).length;
      var numero = 'OS-${(total + 1).toString().padLeft(5, '0')}';
      var intento = total + 1;
      while (await _existeNumero(numero)) {
        intento++;
        numero = 'OS-${intento.toString().padLeft(5, '0')}';
      }
      final ahora = DateTime.now();
      final id = await into(ordenesServicio).insert(
        OrdenesServicioCompanion.insert(
          numero: numero,
          clienteId: clienteId,
          vehiculoId: vehiculoId,
          mecanicoId: Value(mecanicoId),
          fechaEntrada: fechaEntrada,
          problema: problema.trim(),
          estado: EstadoOrden.recibida,
          kilometrajeEntrada: Value(kilometrajeEntrada),
          notas: Value(
            notas == null || notas.trim().isEmpty ? null : notas.trim(),
          ),
          creadoEn: Value(ahora),
          actualizadoEn: Value(ahora),
        ),
      );
      await (update(vehiculos)..where((v) => v.id.equals(vehiculoId))).write(
        VehiculosCompanion(kilometraje: Value(kilometrajeEntrada)),
      );
      return id;
    });
  }

  Future<bool> _existeNumero(String numero) async {
    final fila = await (select(ordenesServicio)
          ..where((o) => o.numero.equals(numero)))
        .getSingleOrNull();
    return fila != null;
  }

  Future<void> cambiarEstado(int id, EstadoOrden nuevo) async {
    final fila = await (select(ordenesServicio)
          ..where((o) => o.id.equals(id)))
        .getSingleOrNull();
    if (fila == null) throw StateError('La orden no existe');
    if (!fila.estado.puedePasarA(nuevo)) {
      throw StateError(
        'No se puede pasar de ${fila.estado.etiqueta} a ${nuevo.etiqueta}',
      );
    }
    await (update(ordenesServicio)..where((o) => o.id.equals(id))).write(
      OrdenesServicioCompanion(
        estado: Value(nuevo),
        actualizadoEn: Value(DateTime.now()),
        fechaCierre: Value(nuevo.esFinal ? DateTime.now() : null),
      ),
    );
  }

  Future<void> asignarMecanico(int id, int? mecanicoId) {
    return (update(ordenesServicio)..where((o) => o.id.equals(id))).write(
      OrdenesServicioCompanion(
        mecanicoId: Value(mecanicoId),
        actualizadoEn: Value(DateTime.now()),
      ),
    );
  }

  Future<void> actualizarOrden({
    required int id,
    int? mecanicoId,
    required DateTime fechaEntrada,
    required String problema,
    required int kilometrajeEntrada,
    String? notas,
  }) {
    return (update(ordenesServicio)..where((o) => o.id.equals(id))).write(
      OrdenesServicioCompanion(
        mecanicoId: Value(mecanicoId),
        fechaEntrada: Value(fechaEntrada),
        problema: Value(problema.trim()),
        kilometrajeEntrada: Value(kilometrajeEntrada),
        notas: Value(
          notas == null || notas.trim().isEmpty ? null : notas.trim(),
        ),
        actualizadoEn: Value(DateTime.now()),
      ),
    );
  }

  Future<void> tocar(int id) {
    return (update(ordenesServicio)..where((o) => o.id.equals(id))).write(
      OrdenesServicioCompanion(actualizadoEn: Value(DateTime.now())),
    );
  }
}
