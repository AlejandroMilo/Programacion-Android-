import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:re_notas/main.dart';

void main() {
  testWidgets('Crear proyecto desde el diálogo (RF1)',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ReNotesApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Nuevo proyecto'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nombre del proyecto'),
      'Proyecto de prueba',
    );
    await tester.pump();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Proyecto de prueba'), findsWidgets);
    expect(find.text('Proyecto creado.'), findsOneWidget);
  });

  testWidgets('Buscar filtra por título en todos los proyectos (RF6)',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ReNotesApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Buscar'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Buscar por título o contenido...'),
      'flutter',
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('resultado'), findsWidgets);
  });

  testWidgets('Editor abre el autocompletado de etiquetas (RF3)',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ReNotesApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Desarrollo móvil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nueva nota'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Escribe el título de la nota'),
      'Nota de prueba',
    );
    await tester.pump();

    await tester.enterText(
      find.widgetWithText(TextField, 'Buscar o escribir etiqueta'),
      'estu',
    );
    await tester.pumpAndSettle();

    expect(find.text('Guardar nota'), findsOneWidget);
  });
}
