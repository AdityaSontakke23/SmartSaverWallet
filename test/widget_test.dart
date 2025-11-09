import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartsaverwallet/app.dart'; // import App, not main.dart

void main() {
  testWidgets('App builds', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartSaverApp());
    // Basic smoke check: verify a MaterialApp is built
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
