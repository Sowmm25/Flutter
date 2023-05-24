// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:test/main.dart';

void main() {
  testWidgets('finds a widget using a Key', (tester) async {
    Finder widgetWithIcon(Type widgetType, IconData icon,
        {bool skipOffstage = true}) {
      return find.ancestor(
        of: find.byIcon(icon),
        matching: find.byType(widgetType),
      );
    }

    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Text('You have pushed the button this many times:'),
      ),
    ));

    // Find a widget that displays the letter 'H'.
    expect(find.text('You have pushed the button this many times:'),
        findsOneWidget);
  });
}
