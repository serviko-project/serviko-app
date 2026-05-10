import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/theme/app_theme.dart';
import 'package:serviko_app/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:serviko_app/features/user/profile/presentation/cubit/profile_cubit.dart';
import 'package:serviko_app/features/user/profile/presentation/cubit/profile_state.dart';
import 'package:serviko_app/features/user/role/presentation/cubit/role_cubit.dart';
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
  late final RoleCubit _roleCubit;
  late final ProfileCubit _profileCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final di = InjectionContainer.instance;
    _authBloc = AuthBloc(
      repository: di.authRepository,
      getMyProfileUseCase: di.getMyProfileUseCase,
      profileLocalDataSource: di.profileLocalDataSource,
    );
    _roleCubit = RoleCubit()..initialize();
    _profileCubit = ProfileCubit(
      getMyProfileUseCase: di.getMyProfileUseCase,
      getCachedProfileUseCase: di.getCachedProfileUseCase,
      updateProfileUseCase: di.updateProfileUseCase,
      uploadProfileImageUseCase: di.uploadProfileImageUseCase,
      deleteProfileImageUseCase: di.deleteProfileImageUseCase,
    );
    _authBloc.add(const AuthCheckRequested());

    // Trigger profile fetch
    if (_authBloc.state is AuthAuthenticated) {
      _profileCubit.fetchProfile();
    }

    _router = AppRouter.router(_authBloc, _roleCubit);
  }

  @override
  void dispose() {
    _authBloc.close();
    _roleCubit.close();
    _profileCubit.close();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider.value(value: _roleCubit),
        BlocProvider.value(value: _profileCubit),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                _profileCubit.fetchProfile();
              } else if (state is AuthUnauthenticated) {
                _profileCubit.reset();
                _roleCubit.reset();
              }
            },
          ),
          BlocListener<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is ProfileLoaded) {
                _roleCubit.syncProviderStatusFromProfile(
                  state.profile.providerStatus,
                );
              }
            },
          ),
        ],
        child: MaterialApp.router(
          title: 'Serviko',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          routerConfig: _router,
        ),
      ),
    );
  }
}
