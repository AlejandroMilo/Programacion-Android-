// Capturas de las pantallas para la entrega (carpeta `capturas/`).
//
// No forma parte de `flutter test`: se ejecuta a proposito con
//   flutter test test/capturas.dart --update-goldens
//
// El sufijo `_test` se deja fuera del nombre a proposito para que la suite
// normal (`flutter test`) no intente comparar las imagenes.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turnos_pe/aplicacion/aplicacion_turnos.dart';
import 'package:turnos_pe/datos/almacen_turnos.dart';
import 'package:turnos_pe/componentes/barra_superior.dart';
import 'package:turnos_pe/componentes/componentes.dart';

Future<void> _cargarPoppins() async {
  final loader = FontLoader('Poppins');
  for (final archivo in [
    'Poppins-Regular.ttf',
    'Poppins-Medium.ttf',
    'Poppins-SemiBold.ttf',
    'Poppins-Bold.ttf',
  ]) {
    loader.addFont(rootBundle.load('assets/fuentes/$archivo'));
  }
  await loader.load();
}

/// Carga la fuente de iconos de Material para que las capturas no muestren
/// cuadros vacios (en las pruebas no se carga por defecto).
Future<void> _cargarIconos() async {
  final candidatas = <String>[];
  final raiz = Platform.environment['FLUTTER_ROOT'];
  if (raiz != null) candidatas.add(raiz);
  final ejecutable = File(Platform.resolvedExecutable);
  candidatas.add(ejecutable.parent.parent.parent.parent.parent.path);

  for (final base in candidatas) {
    final archivo = File(
      '$base/bin/cache/artifacts/material_fonts/materialicons-regular.otf',
    );
    if (!archivo.existsSync()) continue;
    final bytes = await archivo.readAsBytes();
    final loader = FontLoader('MaterialIcons')
      ..addFont(Future.value(ByteData.sublistView(bytes)));
    await loader.load();
    return;
  }
}

/// Decodifica las imagenes que ya estan en pantalla; sin esto las capturas
/// quedan con los huecos vacios porque la decodificacion es asincrona.
Future<void> _precargarImagenes(WidgetTester tester) async {
  final contexto = tester.element(find.byType(Navigator).first);
  final proveedores = tester
      .widgetList<Image>(find.byType(Image))
      .map((imagen) => imagen.image)
      .toSet();
  for (final proveedor in proveedores) {
    await tester.runAsync(() => precacheImage(proveedor, contexto));
  }
  await tester.pumpAndSettle();
}

Future<void> _capturar(WidgetTester tester, String nombre) async {
  await _precargarImagenes(tester);
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('../capturas/$nombre.png'),
  );
}

Finder _pestana(String etiqueta) => find.descendant(
  of: find.byType(BarraNavegacion),
  matching: find.text(etiqueta),
);

/// Boton de atras de la barra superior (la flecha del diseno).
Finder get _atras => find.descendant(
  of: find.byType(BarraSuperior),
  matching: find.byIcon(Icons.chevron_left),
);

Future<void> _tocar(WidgetTester tester, Finder finder) async {
  try {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
  } catch (_) {
    // Los widgets que no viven dentro de un scrollable no necesitan ajuste.
  }
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Devuelve la lista al principio para poder tocar las primeras filas.
Future<void> _alPrincipio(WidgetTester tester) async {
  final listas = find.byType(ListView);
  if (listas.evaluate().isEmpty) return;
  await tester.drag(listas.last, const Offset(0, 600));
  await tester.pumpAndSettle();
}

/// Cierra la hoja inferior pulsando fuera de ella.
Future<void> _cerrarHoja(WidgetTester tester) async {
  await tester.tapAt(const Offset(195, 100));
  await tester.pumpAndSettle();
}

/// Cierra el Snackbar que tapa la barra de botones.
Future<void> _cerrarAviso(WidgetTester tester) async {
  final scaffolds = find.byType(Scaffold);
  if (scaffolds.evaluate().isEmpty) return;
  ScaffoldMessenger.of(tester.element(scaffolds.last)).hideCurrentSnackBar();
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    await _cargarPoppins();
    await _cargarIconos();
  });

  testWidgets('capturas de las pantallas', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    // Miercoles 21 de octubre de 2026 a las 11:00: la misma fecha del
    // diseno, para que las capturas coincidan con la guia de estilo.
    final reloj = DateTime(2026, 10, 21, 11, 0);

    await tester.pumpWidget(AplicacionTurnos(store: AlmacenTurnos(reloj: () => reloj)));
    await tester.pumpAndSettle();

    // 1. Agenda del dia (miercoles 21).
    await _capturar(tester, '01_agenda');

    // 2. Domingo: salon cerrado.
    await _tocar(tester, find.text('Dom'));
    await _capturar(tester, '02_agenda_domingo');

    // 3. Vuelve al dia con turnos.
    await _tocar(tester, find.text('Mié'));
    await _capturar(tester, '03_agenda_lista');

    // 4. Acciones rapidas del turno (pulsacion larga).
    await tester.longPress(find.text('Carlos Ruiz'));
    await tester.pumpAndSettle();
    await _capturar(tester, '04_agenda_acciones_rapidas');
    await _cerrarHoja(tester);

    // 5. Detalle de un turno programado (con acciones).
    await _tocar(tester, find.text('Carlos Ruiz'));
    await _capturar(tester, '05_detalle_turno');

    // 6. Dialogo de confirmacion de cancelacion.
    await _tocar(tester, find.text('Cancelar').last);
    await _capturar(tester, '06_confirmar_cancelar');
    await _tocar(tester, find.text('Volver'));
    await _tocar(tester, _atras);

    // 7. Formulario de nuevo turno.
    await _tocar(tester, find.byType(BotonFlotante));
    await _capturar(tester, '07_nuevo_turno');

    // 8. Cliente, servicios y estilista.
    await _tocar(tester, find.text('Selecciona un cliente'));
    await _tocar(tester, find.text('Carlos Ruiz · 52 345 678').last);
    await _tocar(tester, find.text('Corte caballero'));
    await _tocar(tester, find.text('Barba'));
    await _capturar(tester, '08_formulario_servicios');

    // 9. Estilista y franja horaria.
    await _tocar(tester, find.text('Selecciona un estilista'));
    await _tocar(tester, find.text('Pedro Vega').last);
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, -420),
    );
    await tester.pumpAndSettle();
    await _capturar(tester, '09_formulario_hora');

    // 10. Salir con cambios sin guardar.
    await _tocar(tester, _atras);
    await _capturar(tester, '10_descartar_cambios');
    await _tocar(tester, find.text('Seguir editando'));

    // 11. Errores de validacion del formulario (formulario vacio).
    await _tocar(tester, _atras);
    await _tocar(tester, find.text('Descartar'));
    await _tocar(tester, find.byType(BotonFlotante));
    await _tocar(tester, find.text('Guardar turno'));
    await _capturar(tester, '11_formulario_errores');
    await _tocar(tester, _atras);

    // 12. Selector de tema y tema oscuro.
    await _tocar(tester, find.byTooltip('Tema'));
    await _capturar(tester, '12_selector_tema');
    await _tocar(tester, find.text('Oscuro'));
    await _capturar(tester, '13_agenda_oscuro');
    await _tocar(tester, find.byTooltip('Tema'));
    await _tocar(tester, find.text('Claro'));

    // 14. Clientes.
    await _tocar(tester, _pestana('Clientes'));
    await _capturar(tester, '14_clientes');

    // 15. Hoja de detalle del cliente con su historial.
    await _tocar(tester, find.text('Laura Gómez'));
    await _capturar(tester, '15_hoja_cliente');
    await _cerrarHoja(tester);

    // 16. Alta de cliente con los errores de validacion.
    await _tocar(tester, find.byTooltip('Nuevo cliente'));
    await _tocar(tester, find.text('Guardar cliente'));
    await _capturar(tester, '16_cliente_errores');
    await _tocar(tester, find.text('Cancelar').last);
    await _cerrarHoja(tester);

    // 17. Confirmacion de eliminacion de un cliente sin turnos.
    await _tocar(tester, find.text('Diego Pérez'));
    await tester.pumpAndSettle();
    await _tocar(tester, find.byIcon(Icons.delete_outline));
    await _capturar(tester, '17_confirmar_eliminar');
    await _tocar(tester, find.text('Cancelar'));
    await _cerrarHoja(tester);

    // 18. Eliminacion bloqueada: el cliente tiene turnos programados.
    await _alPrincipio(tester);
    await _tocar(tester, find.text('Carlos Ruiz'));
    await tester.pumpAndSettle();
    await _tocar(tester, find.byIcon(Icons.delete_outline));
    await _capturar(tester, '18_eliminacion_bloqueada');
    await _cerrarAviso(tester);

    // 19. Servicios.
    await _tocar(tester, _pestana('Servicios'));
    await _capturar(tester, '19_servicios');

    // 20. Errores de fecha y de hora: las franjas libres quedan en rojo.
    await _tocar(tester, find.text('Corte caballero'));
    await _tocar(tester, find.text('Barba'));
    await _tocar(tester, find.text('Selecciona un estilista'));
    await _tocar(tester, find.text('Pedro Vega').last);
    await _tocar(tester, find.text('Guardar turno'));
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, -430),
    );
    await tester.pumpAndSettle();
    await _capturar(tester, '20_errores_fecha_hora');
    await _tocar(tester, _atras);
    await _tocar(tester, find.text('Descartar'));

    // 21. Estilistas.
    await _tocar(tester, _pestana('Estilistas'));
    await _capturar(tester, '21_estilistas');
  });
}


