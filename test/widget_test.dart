import 'package:flutter_test/flutter_test.dart';
import 'package:fitpulse/main.dart';

void main() {
  testWidgets('FitPulse app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FitPulseApp());
    expect(find.text('Antrenman'), findsOneWidget);
  });
}
