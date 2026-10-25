import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turnos_pe/aplicacion/aplicacion_turnos.dart';

Future<void> _cargarFuentes() async {
  final raiz = Platform.environment['FLUTTER_ROOT'];
  final bytes = await File(
    '$raiz/bin/cache/artifacts/material_fonts/materialicons-regular.otf',
  ).readAsBytes();
  final iconos = FontLoader('MaterialIcons')
    ..addFont(Future.value(ByteData.sublistView(bytes)));
  await iconos.load();

  final poppins = FontLoader('Poppins');
  for (final archivo in [
    'Poppins-Regular.ttf',
    'Poppins-Medium.ttf',
    'Poppins-SemiBold.ttf',
    'Poppins-Bold.ttf',
  ]) {
    poppins.addFont(rootBundle.load('assets/fuentes/$archivo'));
  }
  await poppins.load();
}

Future<void> _tocar(WidgetTester tester, Finder finder) async {
  try {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
  } catch (_) {}
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(_cargarFuentes);

  testWidgets('el formulario avisa cuando ningun estilista puede hacer los '
      'servicios', (tester) async {
    tester.view.physicalSize = const Size(720, 1516);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const AplicacionTurnos());
    await tester.pumpAndSettle();

    await _tocar(tester, find.text('Servicios'));
    await _tocar(tester, find.text('Corte mujer'));
    await _tocar(tester, find.text('Barba'));

    // Nadie hace las dos cosas a la vez: hay que avisarlo.
    expect(
      find.text(
        'Ningún estilista realiza todos los servicios elegidos. '
        'Quita alguno o elige otros servicios.',
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('con estilista elegido se ven las franjas y en rojo si falta la '
      'hora', (tester) async {
    tester.view.physicalSize = const Size(720, 1516);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const AplicacionTurnos());
    await tester.pumpAndSettle();

    // Se abre desde Servicios: el formulario entra sin fecha.
    await _tocar(tester, find.text('Servicios'));
    await _tocar(tester, find.text('Corte caballero'));
    await _tocar(tester, find.text('Barba'));
    await _tocar(tester, find.text('Selecciona un estilista'));
    await _tocar(tester, find.text('Pedro Vega').last);

    // La cuadrícula de horas aparece.
    expect(find.text('Hora de inicio'), findsOneWidget);
    expect(find.text('Libre'), findsOneWidget);

    // Sin hora: las franjas libres quedan enmarcadas en rojo.
    await _tocar(tester, find.text('Guardar turno'));
    expect(find.text('Elige una hora para el turno'), findsOneWidget);

    final rojas = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.foregroundDecoration == null &&
          widget.decoration is BoxDecoration &&
          (widget.decoration as BoxDecoration).border != null &&
          ((widget.decoration as BoxDecoration).border!.top.color ==
                  const Color(0xFFBA1A1A) ||
              (widget.decoration as BoxDecoration).border!.top.color ==
                  const Color(0xFFFFB4AB)),
    );
    expect(rojas, findsWidgets, reason: 'franjas libres en rojo');
    expect(tester.takeException(), isNull);
  });

  testWidgets('el dialogo de descartar no desborda', (tester) async {
    tester.view.physicalSize = const Size(720, 1516);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const AplicacionTurnos());
    await tester.pumpAndSettle();

    await _tocar(tester, find.text('Nuevo turno'));
    await _tocar(tester, find.text('Corte caballero'));

    await _tocar(tester, find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();

    expect(find.text('¿Descartar los cambios?'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
