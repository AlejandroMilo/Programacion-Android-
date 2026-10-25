import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turnos_pe/aplicacion/aplicacion_turnos.dart';
import 'package:turnos_pe/componentes/componentes.dart';

Finder _destino(String etiqueta) => find.descendant(
  of: find.byType(BarraNavegacion),
  matching: find.text(etiqueta),
);

Future<void> _recorrerPestanas(WidgetTester tester) async {
  for (final etiqueta in ['Clientes', 'Servicios', 'Estilistas', 'Agenda']) {
    await tester.tap(_destino(etiqueta));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: 'Pestaña $etiqueta');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // La app usa Poppins; sin cargarla el test mide con la fuente Ahem y
    // aparecen desbordes que no ocurren en el dispositivo.
    final cargador = FontLoader('Poppins');
    for (final archivo in [
      'Poppins-Regular.ttf',
      'Poppins-Medium.ttf',
      'Poppins-SemiBold.ttf',
      'Poppins-Bold.ttf',
    ]) {
      cargador.addFont(rootBundle.load('assets/fuentes/$archivo'));
    }
    await cargador.load();
  });

  testWidgets('la app abre en la agenda con el resumen del día', (
    tester,
  ) async {
    await tester.pumpWidget(const AplicacionTurnos());
    await tester.pumpAndSettle();

    expect(find.text('Turco'), findsOneWidget);
    expect(find.text('Programados'), findsOneWidget);
    expect(find.text('Completados'), findsOneWidget);
    expect(find.text('Nuevo turno'), findsOneWidget);
    expect(find.text('Agenda'), findsOneWidget);
  });

  testWidgets('el botón de tema ofrece las tres opciones', (tester) async {
    await tester.pumpWidget(const AplicacionTurnos());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Tema'));
    await tester.pumpAndSettle();

    expect(find.text('Sistema'), findsOneWidget);
    expect(find.text('Claro'), findsOneWidget);
    expect(find.text('Oscuro'), findsOneWidget);

    await tester.tap(find.text('Oscuro'));
    await tester.pumpAndSettle();

    final contexto = tester.element(find.text('Turco'));
    expect(Theme.of(contexto).brightness, Brightness.dark);
  });

  testWidgets('las pantallas no desbordan en horizontal', (tester) async {
    tester.view.physicalSize = const Size(2532, 1170);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const AplicacionTurnos());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await _recorrerPestanas(tester);

    await tester.tap(find.text('Nuevo turno'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
  });

  testWidgets('las pantallas no desbordan en una pantalla pequeña', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const AplicacionTurnos());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await _recorrerPestanas(tester);

    await tester.tap(find.text('Nuevo turno'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
  });

  testWidgets('no desbordan en un móvil de 360x758 (agenda vacía)', (
    tester,
  ) async {
    // Medidas del TECNO KI5k (720x1516 px a 2x), el móvil donde se probó.
    tester.view.physicalSize = const Size(720, 1516);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const AplicacionTurnos());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // El domingo la agenda se queda sin turnos: es el caso con menos espacio
    // y el que desborda el mensaje de estado vacio.
    await tester.ensureVisible(find.text('Dom'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dom'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Domingo: salón cerrado'), findsWidgets);

    await _recorrerPestanas(tester);

    await tester.tap(find.text('Nuevo turno'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('el formulario de cliente marca los campos vacíos', (
    tester,
  ) async {
    await tester.pumpWidget(const AplicacionTurnos());
    await tester.pumpAndSettle();

    await tester.tap(_destino('Clientes'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Nuevo cliente').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Guardar cliente'));
    await tester.pumpAndSettle();

    expect(find.text('Ingresa el nombre del cliente'), findsOneWidget);
    expect(find.text('Ingresa el teléfono'), findsOneWidget);
    expect(find.text('Selecciona un género'), findsOneWidget);
    expect(find.text('Revisa los campos marcados en rojo.'), findsOneWidget);
  });

  testWidgets('la búsqueda de clientes ignora acentos y mayúsculas', (
    tester,
  ) async {
    await tester.pumpWidget(const AplicacionTurnos());
    await tester.pumpAndSettle();

    await tester.tap(_destino('Clientes'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'MARTIN');
    await tester.pumpAndSettle();

    expect(find.text('Ana Martín'), findsOneWidget);
    expect(find.text('Sofía Díaz'), findsNothing);
  });
}
