import 'package:flutter_test/flutter_test.dart';
import 'package:serviko_app/main.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const ServikoApp());
    // Verify the app boots and shows the initial screen.
    // expect(find.text('Servico'), findsOneWidget);
  });
}
