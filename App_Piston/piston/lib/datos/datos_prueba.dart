import 'package:drift/drift.dart';

import '../modelos/estado_orden.dart';
import '../modelos/rol_usuario.dart';
import '../utilidades/constantes.dart';
import '../utilidades/seguridad.dart';
import 'base_datos.dart';

/// Crea datos de demostración la primera vez que se abre la aplicación.
///
/// Así el taller puede probar todos los módulos (órdenes, deudas, inventario
/// bajo, reportes) sin tener que cargar información a mano.
class SembradorDatos {
  SembradorDatos(this.db);

  final BaseDatos db;

  Future<void> sembrarSiHaceFalta() async {
    final usuarios = await db.select(db.usuarios).get();
    if (usuarios.isNotEmpty) return;

    await db.transaction(() async {
      final mecanicoPedro = await db.into(db.mecanicos).insert(
        MecanicosCompanion.insert(
          nombre: 'Pedro Ramírez',
          telefono: const Value('555-1001'),
          especialidad: const Value('Motor y transmisión'),
        ),
      );
      final mecanicoLuis = await db.into(db.mecanicos).insert(
        MecanicosCompanion.insert(
          nombre: 'Luis Fernández',
          telefono: const Value('555-1002'),
          especialidad: const Value('Frenos y suspensión'),
        ),
      );

      await _crearUsuario(
        usuario: 'admin',
        clave: 'admin123',
        nombre: 'Alejandro Pérez',
        rol: RolUsuario.administrador,
      );
      await _crearUsuario(
        usuario: 'recepcion',
        clave: 'recepcion123',
        nombre: 'María Gómez',
        rol: RolUsuario.recepcionista,
      );
      await _crearUsuario(
        usuario: 'mecanico',
        clave: 'mecanico123',
        nombre: 'Pedro Ramírez',
        rol: RolUsuario.mecanico,
        mecanicoId: mecanicoPedro,
      );

      final carlos = await db.into(db.clientes).insert(
        ClientesCompanion.insert(
          nombre: 'Carlos Mendoza',
          telefono: '555-1234',
          direccion: const Value('Av. Central 123'),
        ),
      );
      final lucia = await db.into(db.clientes).insert(
        ClientesCompanion.insert(
          nombre: 'Lucía Torres',
          telefono: '555-5678',
          direccion: const Value('Calle 5 #45'),
        ),
      );
      final jorge = await db.into(db.clientes).insert(
        ClientesCompanion.insert(
          nombre: 'Jorge Ramírez',
          telefono: '555-9012',
        ),
      );
      final ana = await db.into(db.clientes).insert(
        ClientesCompanion.insert(
          nombre: 'Ana Beltrán',
          telefono: '555-3456',
          direccion: const Value('Boulevard Norte 89'),
        ),
      );
      final miguel = await db.into(db.clientes).insert(
        ClientesCompanion.insert(
          nombre: 'Miguel Santos',
          telefono: '555-7890',
          direccion: const Value('Calle Los Pinos 12'),
        ),
      );
      final rosa = await db.into(db.clientes).insert(
        ClientesCompanion.insert(
          nombre: 'Rosa Herrera',
          telefono: '555-2345',
        ),
      );

      final corolla = await _crearVehiculo(
        clienteId: carlos,
        matricula: 'ABC-123',
        marca: 'Toyota',
        modelo: 'Corolla',
        anio: 2018,
        kilometraje: 85400,
      );
      final civic = await _crearVehiculo(
        clienteId: carlos,
        matricula: 'XYZ-789',
        marca: 'Honda',
        modelo: 'Civic',
        anio: 2020,
        kilometraje: 42300,
      );
      final sentra = await _crearVehiculo(
        clienteId: lucia,
        matricula: 'DEF-456',
        marca: 'Nissan',
        modelo: 'Sentra',
        anio: 2016,
        kilometraje: 120500,
      );
      final aveo = await _crearVehiculo(
        clienteId: jorge,
        matricula: 'GHI-012',
        marca: 'Chevrolet',
        modelo: 'Aveo',
        anio: 2019,
        kilometraje: 76500,
      );
      final ranger = await _crearVehiculo(
        clienteId: ana,
        matricula: 'JKL-345',
        marca: 'Ford',
        modelo: 'Ranger',
        anio: 2021,
        kilometraje: 35200,
      );
      final tucson = await _crearVehiculo(
        clienteId: miguel,
        matricula: 'MNO-678',
        marca: 'Hyundai',
        modelo: 'Tucson',
        anio: 2017,
        kilometraje: 97800,
      );
      final rio = await _crearVehiculo(
        clienteId: rosa,
        matricula: 'PQR-901',
        marca: 'Kia',
        modelo: 'Rio',
        anio: 2022,
        kilometraje: 21200,
      );

      final aceite = await _crearRepuesto(
        nombre: 'Aceite sintético 10W-40 (5L)',
        codigo: 'ACE-10W40',
        precio: 35,
        existencias: 30,
        umbral: 8,
      );
      final filtroAceite = await _crearRepuesto(
        nombre: 'Filtro de aceite',
        codigo: 'FIL-ACE',
        precio: 12,
        existencias: 20,
        umbral: 6,
      );
      final filtroAire = await _crearRepuesto(
        nombre: 'Filtro de aire',
        codigo: 'FIL-AIR',
        precio: 15,
        existencias: 6,
        umbral: 6,
      );
      final pastillas = await _crearRepuesto(
        nombre: 'Pastillas de freno delanteras',
        codigo: 'BUM-FRE',
        precio: 48,
        existencias: 10,
        umbral: 4,
      );
      final discos = await _crearRepuesto(
        nombre: 'Disco de freno',
        codigo: 'DIS-FRE',
        precio: 65,
        existencias: 4,
        umbral: 4,
      );
      final bujias = await _crearRepuesto(
        nombre: 'Bujía NGK',
        codigo: 'BUI-NGK',
        precio: 8,
        existencias: 40,
        umbral: 10,
      );
      final correa = await _crearRepuesto(
        nombre: 'Correa de alternador',
        codigo: 'COR-ALT',
        precio: 22,
        existencias: 8,
        umbral: 3,
      );
      final refrigerante = await _crearRepuesto(
        nombre: 'Refrigerante anticongelante (1L)',
        codigo: 'REF-ANT',
        precio: 10,
        existencias: 18,
        umbral: 5,
      );
      final amortiguadores = await _crearRepuesto(
        nombre: 'Amortiguador delantero',
        codigo: 'AMO-DEL',
        precio: 85,
        existencias: 3,
        umbral: 3,
      );
      final bateria = await _crearRepuesto(
        nombre: 'Batería 12V 60Ah',
        codigo: 'BAT-12V',
        precio: 120,
        existencias: 6,
        umbral: 2,
      );
      final limpiaparabrisas = await _crearRepuesto(
        nombre: 'Limpiaparabrisas 22"',
        codigo: 'LIM-PAR',
        precio: 9,
        existencias: 1,
        umbral: 4,
      );
      final aceiteTransmision = await _crearRepuesto(
        nombre: 'Aceite de transmisión',
        codigo: 'ACE-TRA',
        precio: 28,
        existencias: 10,
        umbral: 4,
      );

      final ahora = DateTime.now();
      // Fechas dentro del mes actual para que las métricas del inicio se vean con valores.
      DateTime enMes(int dia) => DateTime(ahora.year, ahora.month, dia);
      final dia1 = enMes(1);   // inicio del mes
      final dia2 = enMes(2);
      final dia3 = enMes(3);
      final dia4 = enMes(4);
      final dia5 = enMes(5);   // hoy (5 de noviembre)

      // OS-00001: entregada y pagada (inicio del mes).
      final os1 = await _crearOrden(
        numero: 'OS-00001',
        clienteId: carlos,
        vehiculoId: corolla,
        mecanicoId: mecanicoPedro,
        fecha: dia1,
        problema: 'Cambio de aceite y revisión general.',
        estado: EstadoOrden.entregada,
        kilometraje: 84000,
        fechaCierre: dia1,
      );
      await _trabajo(os1, 'Cambio de aceite y filtro', 25, mecanicoPedro, dia1);
      await _trabajo(os1, 'Revisión general de 20 puntos', 15, mecanicoPedro, dia1);
      await _repuesto(os1, aceite, 1, 35, dia1);
      await _repuesto(os1, filtroAceite, 1, 12, dia1);
      await _pago(os1, 87, 'efectivo', dia1, 'María Gómez');

      // OS-00002: entregada con saldo pendiente.
      final os2 = await _crearOrden(
        numero: 'OS-00002',
        clienteId: lucia,
        vehiculoId: sentra,
        mecanicoId: mecanicoLuis,
        fecha: dia2,
        problema: 'Ruido y vibración al frenar.',
        estado: EstadoOrden.entregada,
        kilometraje: 119000,
        fechaCierre: dia2,
      );
      await _trabajo(os2, 'Cambio de pastillas delanteras', 40, mecanicoLuis, dia2);
      await _trabajo(os2, 'Rectificación de discos', 30, mecanicoLuis, dia2);
      await _repuesto(os2, pastillas, 1, 48, dia2);
      await _repuesto(os2, discos, 2, 65, dia2);
      await _pago(os2, 198, 'tarjeta', dia2, 'María Gómez', 'Abono inicial');

      // OS-00003: mantenimiento completo entregado.
      final os3 = await _crearOrden(
        numero: 'OS-00003',
        clienteId: jorge,
        vehiculoId: aveo,
        mecanicoId: mecanicoPedro,
        fecha: dia3,
        problema: 'Mantenimiento de 80.000 km.',
        estado: EstadoOrden.entregada,
        kilometraje: 76000,
        fechaCierre: dia3,
      );
      await _trabajo(os3, 'Mantenimiento programado', 80, mecanicoPedro, dia3);
      await _repuesto(os3, aceite, 1, 35, dia3);
      await _repuesto(os3, filtroAceite, 1, 12, dia3);
      await _repuesto(os3, filtroAire, 1, 15, dia3);
      await _repuesto(os3, bujias, 4, 8, dia3);
      await _pago(os3, 174, 'transferencia', dia3, 'María Gómez');

      // OS-00004: lista para entregar, sin pagar.
      final os4 = await _crearOrden(
        numero: 'OS-00004',
        clienteId: ana,
        vehiculoId: ranger,
        mecanicoId: mecanicoLuis,
        fecha: dia4,
        problema: 'La suspensión delantera golpea al pasar por baches.',
        estado: EstadoOrden.listaParaEntregar,
        kilometraje: 35000,
      );
      await _trabajo(os4, 'Cambio de amortiguadores delanteros', 100, mecanicoLuis, dia4);
      await _trabajo(os4, 'Alineación y balanceo', 30, mecanicoLuis, dia4);
      await _repuesto(os4, amortiguadores, 2, 85, dia4);

      // OS-00005: en reparación por recalentamiento (ayer).
      final os5 = await _crearOrden(
        numero: 'OS-00005',
        clienteId: miguel,
        vehiculoId: tucson,
        mecanicoId: mecanicoPedro,
        fecha: dia4,
        problema: 'El motor se recalentó y perdió refrigerante.',
        estado: EstadoOrden.enReparacion,
        kilometraje: 97500,
      );
      await _trabajo(os5, 'Diagnóstico de sistema de enfriamiento', 20, mecanicoPedro, dia4);
      await _trabajo(os5, 'Cambio de correa de alternador', 35, mecanicoPedro, dia4);
      await _repuesto(os5, correa, 1, 22, dia4);
      await _repuesto(os5, refrigerante, 2, 10, dia4);

      // OS-00006: en diagnóstico (ayer).
      final os6 = await _crearOrden(
        numero: 'OS-00006',
        clienteId: rosa,
        vehiculoId: rio,
        mecanicoId: mecanicoLuis,
        fecha: dia4,
        problema: 'Vibración en el volante al frenar.',
        estado: EstadoOrden.enDiagnostico,
        kilometraje: 21000,
      );
      await _trabajo(os6, 'Diagnóstico de frenos', 20, mecanicoLuis, dia4);

      // OS-00007: recién recibida y sin asignar (ayer).
      final os7 = await _crearOrden(
        numero: 'OS-00007',
        clienteId: carlos,
        vehiculoId: civic,
        fecha: dia4,
        problema: 'El aire acondicionado no enfría.',
        estado: EstadoOrden.recibida,
        kilometraje: 42300,
      );

      // OS-00008: hoy, en reparación y con abono.
      final os8 = await _crearOrden(
        numero: 'OS-00008',
        clienteId: lucia,
        vehiculoId: sentra,
        mecanicoId: mecanicoLuis,
        fecha: ahora,
        problema: 'El vehículo no enciende, posible batería descargada.',
        estado: EstadoOrden.enReparacion,
        kilometraje: 120500,
      );
      await _trabajo(os8, 'Instalación de batería nueva', 15, mecanicoLuis, ahora);
      await _repuesto(os8, bateria, 1, 120, ahora);
      await _pago(os8, 100, 'efectivo', ahora, 'María Gómez', 'Abono');

      // OS-00009: recibida hoy, sin asignar.
      await _crearOrden(
        numero: 'OS-00009',
        clienteId: jorge,
        vehiculoId: aveo,
        fecha: ahora,
        problema: 'Revisión general antes de un viaje.',
        estado: EstadoOrden.recibida,
        kilometraje: 76500,
      );

      // OS-00010: cancelada (inicio del mes).
      await _crearOrden(
        numero: 'OS-00010',
        clienteId: ana,
        vehiculoId: ranger,
        mecanicoId: mecanicoPedro,
        fecha: dia1,
        problema: 'Presupuesto de pintura completa.',
        estado: EstadoOrden.cancelada,
        kilometraje: 34600,
        fechaCierre: dia1,
      );

      // OS-00011: entregada y pagada.
      final os11 = await _crearOrden(
        numero: 'OS-00011',
        clienteId: rosa,
        vehiculoId: rio,
        mecanicoId: mecanicoLuis,
        fecha: dia5,
        problema: 'Cambio de limpiaparabrisas y revisión.',
        estado: EstadoOrden.entregada,
        kilometraje: 20800,
        fechaCierre: dia5,
      );
      await _trabajo(os11, 'Cambio de limpiaparabrisas', 10, mecanicoLuis, dia5);
      await _repuesto(os11, filtroAire, 1, 15, dia5);
      await _pago(os11, 25, 'efectivo', dia5, 'María Gómez');

      // OS-00012: alineación entregada (ayer).
      final os12 = await _crearOrden(
        numero: 'OS-00012',
        clienteId: miguel,
        vehiculoId: tucson,
        mecanicoId: mecanicoPedro,
        fecha: dia4,
        problema: 'Alineación y balanceo después de cambio de neumáticos.',
        estado: EstadoOrden.entregada,
        kilometraje: 96000,
        fechaCierre: dia4,
      );
      await _trabajo(os12, 'Alineación y balanceo', 45, mecanicoPedro, dia4);
      await _pago(os12, 45, 'tarjeta', dia4, 'María Gómez');

      await db.configuracionDao.guardarVarios({
        Constantes.claveTema: Constantes.temaOscuro,
        Constantes.claveNombreTaller: Constantes.nombreTaller,
        Constantes.claveTelefonoTaller: '555-0100',
        Constantes.claveDireccionTaller: 'Av. de los Mecánicos 45',
        Constantes.claveUmbral: '5',
      });
    });
  }

  Future<void> _crearUsuario({
    required String usuario,
    required String clave,
    required String nombre,
    required RolUsuario rol,
    int? mecanicoId,
  }) async {
    final sal = Seguridad.generarSal();
    await db.into(db.usuarios).insert(
      UsuariosCompanion.insert(
        nombreUsuario: usuario,
        nombrePersona: nombre,
        rol: rol,
        claveHash: Seguridad.hashear(clave, sal),
        sal: sal,
        mecanicoId: Value(mecanicoId),
      ),
    );
  }

  Future<int> _crearVehiculo({
    required int clienteId,
    required String matricula,
    required String marca,
    required String modelo,
    required int anio,
    required int kilometraje,
  }) {
    return db.into(db.vehiculos).insert(
      VehiculosCompanion.insert(
        clienteId: clienteId,
        matricula: matricula,
        marca: marca,
        modelo: modelo,
        anio: anio,
        kilometraje: Value(kilometraje),
      ),
    );
  }

  Future<int> _crearRepuesto({
    required String nombre,
    required String codigo,
    required double precio,
    required int existencias,
    required int umbral,
  }) async {
    final id = await db.into(db.repuestos).insert(
      RepuestosCompanion.insert(
        nombre: nombre,
        codigo: codigo,
        precioVenta: precio,
        existencias: Value(existencias),
        umbral: Value(umbral),
      ),
    );
    await db.into(db.movimientosInventario).insert(
      MovimientosInventarioCompanion.insert(
        repuestoId: id,
        tipo: 'entrada',
        cantidad: existencias,
        nota: const Value('Existencia inicial'),
      ),
    );
    return id;
  }

  Future<int> _crearOrden({
    required String numero,
    required int clienteId,
    required int vehiculoId,
    int? mecanicoId,
    required DateTime fecha,
    required String problema,
    required EstadoOrden estado,
    required int kilometraje,
    DateTime? fechaCierre,
  }) {
    return db.into(db.ordenesServicio).insert(
      OrdenesServicioCompanion.insert(
        numero: numero,
        clienteId: clienteId,
        vehiculoId: vehiculoId,
        mecanicoId: Value(mecanicoId),
        fechaEntrada: fecha,
        problema: problema,
        estado: estado,
        kilometrajeEntrada: Value(kilometraje),
        creadoEn: Value(fecha),
        actualizadoEn: Value(fechaCierre ?? fecha),
        fechaCierre: Value(fechaCierre),
      ),
    );
  }

  Future<void> _trabajo(
    int ordenId,
    String descripcion,
    double precio,
    int mecanicoId,
    DateTime fecha,
  ) {
    return db.into(db.trabajos).insert(
      TrabajosCompanion.insert(
        ordenId: ordenId,
        descripcion: descripcion,
        precioManoObra: precio,
        mecanicoId: Value(mecanicoId),
        fecha: Value(fecha),
      ),
    );
  }

  Future<void> _repuesto(
    int ordenId,
    int repuestoId,
    int cantidad,
    double precio,
    DateTime fecha,
  ) async {
    await db.into(db.repuestosOrden).insert(
      RepuestosOrdenCompanion.insert(
        ordenId: ordenId,
        repuestoId: repuestoId,
        cantidad: cantidad,
        precioUnitario: precio,
        fecha: Value(fecha),
      ),
    );
    final repuesto = await db.repuestosDao.porId(repuestoId);
    if (repuesto != null) {
      await (db.update(db.repuestos)..where((r) => r.id.equals(repuestoId)))
          .write(
            RepuestosCompanion(
              existencias: Value(
                ((repuesto.existencias - cantidad).clamp(0, 999999)) as int,
              ),
            ),
          );
    }
    await db.into(db.movimientosInventario).insert(
      MovimientosInventarioCompanion.insert(
        repuestoId: repuestoId,
        ordenId: Value(ordenId),
        tipo: 'salida',
        cantidad: -cantidad,
        nota: const Value('Consumo en orden'),
      ),
    );
  }

  Future<void> _pago(
    int ordenId,
    double importe,
    String metodo,
    DateTime fecha,
    String usuario, [
    String? nota,
  ]) {
    return db.into(db.pagos).insert(
      PagosCompanion.insert(
        ordenId: ordenId,
        importe: importe,
        metodo: metodo,
        fecha: Value(fecha),
        registradoPor: Value(usuario),
        nota: Value(nota),
      ),
    );
  }
}
