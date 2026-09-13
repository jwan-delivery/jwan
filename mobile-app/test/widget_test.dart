import 'package:flutter_test/flutter_test.dart';
import 'package:jawan_flutter/main.dart';

void main() {
  testWidgets('Jawan app starts successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const JawanApp());

    expect(find.text('أهلاً بك في جوان'), findsOneWidget);
  });
}
