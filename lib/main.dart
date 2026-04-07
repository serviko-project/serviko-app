import 'package:flutter/material.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/theme/app_theme.dart';
import 'package:serviko_app/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all dependencies
  await InjectionContainer.instance.init();

  runApp(const ServikoApp());
}

class ServikoApp extends StatelessWidget {
  const ServikoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Serviko',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
    );
  }
}
