import 'dart:async';
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
import 'package:serviko_app/features/user/category/presentation/cubit/category_cubit.dart';
import 'package:serviko_app/features/user/service/presentation/cubit/popular_services_cubit.dart';
import 'package:serviko_app/features/user/service/presentation/cubit/service_detail_cubit.dart';
import 'package:serviko_app/features/user/bookmarks/presentation/cubit/bookmarks_cubit.dart';
import 'package:serviko_app/features/shared/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:serviko_app/features/shared/notifications/presentation/utils/notification_navigation_handler.dart';
import 'package:serviko_app/firebase_options.dart';
import 'package:serviko_app/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize all dependencies
  await InjectionContainer.instance.init();

  // Notification setup
  await InjectionContainer.instance.localNotificationService.initialize(
    onNotificationTapped: NotificationNavigationHandler.handleNotificationTap,
  );
  // Zego SDK initialization
  await InjectionContainer.instance.zegoService.initializeSdk();

  // Pre-load saved role
  final roleCubit = RoleCubit();
  await roleCubit.initialize();

  runApp(ServikoApp(roleCubit: roleCubit));
}

class ServikoApp extends StatefulWidget {
  final RoleCubit roleCubit;

  const ServikoApp({super.key, required this.roleCubit});

  @override
  State<ServikoApp> createState() => _ServikoAppState();
}

class _ServikoAppState extends State<ServikoApp> {
  late final AuthBloc _authBloc;
  late final ProfileCubit _profileCubit;
  late final CategoryCubit _categoryCubit;
  late final PopularServicesCubit _popularServicesCubit;
  late final ServiceDetailCubit _serviceDetailCubit;
  late final BookmarksCubit _bookmarksCubit;
  late final NotificationsCubit _notificationsCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final di = InjectionContainer.instance;
    _authBloc = AuthBloc(
      repository: di.authRepository,
      getMyProfileUseCase: di.getMyProfileUseCase,
      profileLocalDataSource: di.profileLocalDataSource,
      removeDeviceTokenUseCase: di.removeDeviceTokenUseCase,
      pushNotificationService: di.pushNotificationService,
    );
    _profileCubit = ProfileCubit(
      getMyProfileUseCase: di.getMyProfileUseCase,
      getCachedProfileUseCase: di.getCachedProfileUseCase,
      updateProfileUseCase: di.updateProfileUseCase,
      uploadProfileImageUseCase: di.uploadProfileImageUseCase,
      deleteProfileImageUseCase: di.deleteProfileImageUseCase,
      updateFirebaseDisplayNameUseCase: di.updateFirebaseDisplayNameUseCase,
    );
    _categoryCubit = CategoryCubit(
      getCategoriesUseCase: di.userGetCategoriesUseCase,
    );
    _popularServicesCubit = PopularServicesCubit(
      getPopularServicesUseCase: di.getPopularServicesUseCase,
      limit: 5,
    );
    _serviceDetailCubit = ServiceDetailCubit(
      getServiceDetailUseCase: di.getServiceDetailUseCase,
      locationService: di.locationService,
    );
    _bookmarksCubit = BookmarksCubit(
      bookmarkServiceUseCase: di.bookmarkServiceUseCase,
      unbookmarkServiceUseCase: di.unbookmarkServiceUseCase,
      getBookmarksUseCase: di.getBookmarksUseCase,
    );
    _notificationsCubit = NotificationsCubit(
      getNotificationsUseCase: di.getNotificationsUseCase,
      getUnreadCountUseCase: di.getUnreadCountUseCase,
      markNotificationReadUseCase: di.markNotificationReadUseCase,
      markAllNotificationsReadUseCase: di.markAllNotificationsReadUseCase,
      registerDeviceTokenUseCase: di.registerDeviceTokenUseCase,
      removeDeviceTokenUseCase: di.removeDeviceTokenUseCase,
    );

    _authBloc.add(const AuthCheckRequested());

    // Trigger profile fetch
    if (_authBloc.state is AuthAuthenticated) {
      _profileCubit.fetchProfile();
      _bookmarksCubit.fetchBookmarks();
      _notificationsCubit.fetchNotifications();
    }

    _router = AppRouter.router(_authBloc, widget.roleCubit);
  }

  @override
  void dispose() {
    _authBloc.close();
    widget.roleCubit.close();
    _profileCubit.close();
    _categoryCubit.close();
    _popularServicesCubit.close();
    _serviceDetailCubit.close();
    _bookmarksCubit.close();
    _notificationsCubit.close();
    _router.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider.value(value: widget.roleCubit),
        BlocProvider.value(value: _profileCubit),
        BlocProvider.value(value: _categoryCubit),
        BlocProvider.value(value: _popularServicesCubit),
        BlocProvider.value(value: _serviceDetailCubit),
        BlocProvider.value(value: _bookmarksCubit),
        BlocProvider.value(value: _notificationsCubit),
      ],

      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                _profileCubit.fetchProfile();
                _bookmarksCubit.fetchBookmarks();
                _notificationsCubit.fetchNotifications();

                NotificationNavigationHandler.setupPushNotifications(
                  _notificationsCubit,
                );
                unawaited(
                  InjectionContainer.instance.zegoService.login(state.user),
                );
              } else if (state is AuthUnauthenticated) {
                _profileCubit.reset();
                widget.roleCubit.reset();
                unawaited(InjectionContainer.instance.zegoService.logout());
              }
            },
          ),
          BlocListener<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is ProfileLoaded) {
                widget.roleCubit.syncProviderStatusFromProfile(
                  state.profile.providerStatus,
                );
                unawaited(
                  InjectionContainer.instance.zegoService.updateUserDisplayName(
                    state.profile.fullName,
                  ),
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
