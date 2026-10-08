import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:re_notas/main.dart';

void main() {
  testWidgets('Sin overflow en filtros con letra grande', (tester) async {
    tester.view.physicalSize = const Size(640, 1136);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
        child: const ReNotesApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Desarrollo móvil'));
    await tester.pumpAndSettle();

    // Activa Favoritas (muestra Limpiar) y 1 etiqueta (muestra Limpiar).
    await tester.tap(find.text('Favoritas'));
    await tester.pump();
    await tester.tap(find.text('Importante').first);
    await tester.pumpAndSettle();

    final error = tester.takeException();
    expect(error, isNull, reason: 'Overflow en Notas del proyecto: $error');
  });
}
