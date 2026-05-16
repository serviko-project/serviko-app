import 'package:flutter_test/flutter_test.dart';
import 'package:serviko_app/main.dart';
import 'package:serviko_app/features/user/role/presentation/cubit/role_cubit.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    final roleCubit = RoleCubit();
    await tester.pumpWidget(ServikoApp(roleCubit: roleCubit));
  });
}
