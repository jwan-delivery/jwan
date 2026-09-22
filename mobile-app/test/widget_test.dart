import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jawan_flutter/main.dart';

void main() {
  testWidgets('Ayez branding renders', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: BrandHeader()));

    expect(find.text('عايز'), findsOneWidget);
    expect(find.text('للتوصيل'), findsOneWidget);
  });
}
