import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:re_notas/main.dart';

void main() {
  testWidgets('Sin overflow en Buscar con pantalla angosta', (tester) async {
    tester.view.physicalSize = const Size(640, 1136);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const ReNotesApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Buscar'));
    await tester.pumpAndSettle();

    // Activa Favoritas (muestra el chip Limpiar filtros).
    await tester.tap(find.text('Favoritas'));
    await tester.pumpAndSettle();

    // Selecciona 2 etiquetas (muestra el SegmentedButton).
    await tester.tap(find.text('Importante').first);
    await tester.pump();
    await tester.drag(
      find.byKey(const PageStorageKey('filtros_etiquetas_busqueda')),
      const Offset(-250, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Estudio').first);
    await tester.pumpAndSettle();

    final error = tester.takeException();
    expect(error, isNull, reason: 'Overflow en Buscar: $error');
  });
}
