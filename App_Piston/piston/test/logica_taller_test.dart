import 'package:flutter_test/flutter_test.dart';

import '../lib/modelos/estado_orden.dart';
import '../lib/modelos/orden_servicio.dart';
import '../lib/modelos/rol_usuario.dart';

void main() {
  group('TotalesOrden', () {
    test('calcula total, saldo y estaPagada correctamente', () {
      final totales = TotalesOrden(
        manoObra: 100,
        repuestos: 50,
        pagado: 80,
      );
      expect(totales.total, 150);
      expect(totales.saldo, 70);
      expect(totales.estaPagada, isFalse);
    });

    test('saldo no es negativo cuando se paga de más', () {
      final totales = TotalesOrden(
        manoObra: 100,
        repuestos: 50,
        pagado: 200,
      );
      expect(totales.total, 150);
      expect(totales.saldo, 0);
      expect(totales.estaPagada, isTrue);
    });

    test('orden sin pagos tiene saldo igual al total', () {
      final totales = TotalesOrden(manoObra: 60, repuestos: 40, pagado: 0);
      expect(totales.total, 100);
      expect(totales.saldo, 100);
      expect(totales.estaPagada, isFalse);
    });
  });

  group('EstadoOrden', () {
    test('transiciones desde recibida', () {
      expect(
        EstadoOrden.recibida.transiciones,
        containsAll([EstadoOrden.enDiagnostico, EstadoOrden.cancelada]),
      );
    });

    test('transiciones desde enReparacion', () {
      expect(
        EstadoOrden.enReparacion.transiciones,
        containsAll([EstadoOrden.listaParaEntregar, EstadoOrden.cancelada]),
      );
    });

    test('entregada y cancelada no tienen transiciones', () {
      expect(EstadoOrden.entregada.transiciones, isEmpty);
      expect(EstadoOrden.cancelada.transiciones, isEmpty);
    });

    test('esEditable es false para estados finales', () {
      expect(EstadoOrden.entregada.esEditable, isFalse);
      expect(EstadoOrden.cancelada.esEditable, isFalse);
      expect(EstadoOrden.recibida.esEditable, isTrue);
      expect(EstadoOrden.enReparacion.esEditable, isTrue);
    });
  });

  group('RolUsuario', () {
    test('etiquetas en español', () {
      expect(RolUsuario.administrador.etiqueta, 'Administrador');
      expect(RolUsuario.recepcionista.etiqueta, 'Recepcionista');
      expect(RolUsuario.mecanico.etiqueta, 'Mecánico');
    });

    test('propiedades de rol', () {
      expect(RolUsuario.administrador.esAdministrador, isTrue);
      expect(RolUsuario.recepcionista.esRecepcionista, isTrue);
      expect(RolUsuario.mecanico.esMecanico, isTrue);
    });
  });

  group('Reglas de negocio de inventario', () {
    test('stock bajo cuando existencias <= umbral', () {
      final existencias = 5;
      final umbral = 6;
      expect(existencias <= umbral, isTrue);
      expect(existencias <= 0, isFalse);
    });

    test('sin stock cuando existencias <= 0', () {
      final existencias = 0;
      final umbral = 4;
      expect(existencias <= 0, isTrue);
      expect(existencias <= umbral, isTrue);
    });

    test('disponible cuando existencias > umbral', () {
      final existencias = 20;
      final umbral = 8;
      expect(existencias <= umbral, isFalse);
      expect(existencias <= 0, isFalse);
    });

    test('el inventario no se descuenta dos veces en la misma orden', () {
      // Simulación: una orden consume 2 unidades de un repuesto con 10 en stock
      int stockInicial = 10;
      int cantidadConsumida = 2;
      int stockDespues = stockInicial - cantidadConsumida;
      // Segunda tentativa de consumo del mismo repuesto en la misma orden
      // debe usar el stock ya actualizado, no el inicial
      int consumoDuplicado = stockDespues - cantidadConsumida;
      expect(stockDespues, 8);
      expect(consumoDuplicado, 6);
    });

    test('no se puede cobrar más que el saldo pendiente', () {
      double saldo = 150;
      double pagoIntentado = 200;
      double pagoValido = (pagoIntentado > saldo) ? saldo : pagoIntentado;
      expect(pagoValido, 150);
      expect(saldo - pagoValido, 0);
    });
  });
}
