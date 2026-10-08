import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:re_notas/main.dart';

void main() {
  testWidgets('La app arranca mostrando los proyectos de prueba',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ReNotesApp());
    await tester.pumpAndSettle();

    expect(find.text('Mis proyectos'), findsOneWidget);
    expect(find.text('Desarrollo móvil'), findsOneWidget);
    expect(find.text('Desarrollo web'), findsOneWidget);
    expect(find.text('Programación con Python'), findsOneWidget);
  });

  testWidgets('La barra inferior tiene los tres destinos (RF7)',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ReNotesApp());
    await tester.pumpAndSettle();

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Proyectos'), findsOneWidget);
    expect(find.text('Etiquetas'), findsOneWidget);
    expect(find.text('Buscar'), findsOneWidget);
  });

  testWidgets('Al tocar un proyecto se abren sus notas (RF1 -> RF2)',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ReNotesApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Desarrollo móvil'));
    await tester.pumpAndSettle();

    // El proyecto tiene cinco notas de prueba.
    expect(find.text('5 notas'), findsOneWidget);
    expect(find.text('Nueva nota'), findsOneWidget);
  });

  testWidgets('Al cambiar de pestaña se muestran las etiquetas (RF5)',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ReNotesApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Etiquetas'));
    await tester.pumpAndSettle();

    expect(find.text('Mis etiquetas'), findsOneWidget);
    // La lista puede necesitar scroll para mostrar la última etiqueta.
    await tester.drag(
      find.byKey(const PageStorageKey('lista_etiquetas')),
      const Offset(0, -600),
    );
    await tester.pumpAndSettle();
    expect(find.text('Archivo'), findsOneWidget);
  });
}
