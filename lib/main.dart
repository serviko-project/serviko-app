import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/theme/app_theme.dart';
import 'package:serviko_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:serviko_app/firebase_options.dart';
import 'package:serviko_app/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize all dependencies
  await InjectionContainer.instance.init();

  runApp(const ServikoApp());
}

class ServikoApp extends StatefulWidget {
  const ServikoApp({super.key});

  @override
  State<ServikoApp> createState() => _ServikoAppState();
}

class _ServikoAppState extends State<ServikoApp> {
  late final AuthBloc _authBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final di = InjectionContainer.instance;
    _authBloc = AuthBloc(repository: di.authRepository);
    _authBloc.add(const AuthCheckRequested());
    _router = AppRouter.router(_authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authBloc,
      child: MaterialApp.router(
        title: 'Serviko',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: _router,
      ),
    );
  }
}
