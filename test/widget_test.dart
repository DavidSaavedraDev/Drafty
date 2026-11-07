// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:drafty/main.dart';

void main() {
  testWidgets('Drafty muestra las notas iniciales', (WidgetTester tester) async {
    await tester.pumpWidget(const DraftyApp());

    expect(find.text('Mis notas'), findsOneWidget);
    expect(find.text('Ideas para el próximo proyecto'), findsOneWidget);
    expect(find.text('Lista de compras'), findsOneWidget);
  });
}
