import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/router/go_router_refresh_stream.dart';
import 'package:serviko_app/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:serviko_app/features/user/auth/presentation/pages/address_screen.dart';
import 'package:serviko_app/features/user/auth/presentation/pages/congratulations_screen.dart';
import 'package:serviko_app/features/user/auth/presentation/pages/choose_reset_method_screen.dart';
import 'package:serviko_app/features/user/auth/presentation/pages/create_new_password_screen.dart';
import 'package:serviko_app/features/user/auth/presentation/pages/fill_profile_screen.dart';
import 'package:serviko_app/features/user/auth/presentation/pages/forgot_password_screen.dart';
import 'package:serviko_app/features/user/auth/presentation/pages/otp_verification_screen.dart';
import 'package:serviko_app/features/user/auth/presentation/pages/reset_success_screen.dart';
import 'package:serviko_app/features/user/auth/presentation/pages/sign_in_screen.dart';
import 'package:serviko_app/features/user/auth/presentation/pages/sign_up_screen.dart';
import 'package:serviko_app/features/user/auth/presentation/pages/splash_screen.dart';
import 'package:serviko_app/features/user/auth/presentation/models/password_recovery_flow_args.dart';
import 'package:serviko_app/features/user/home/presentation/pages/home_screen.dart';
import 'package:serviko_app/features/user/main/presentation/pages/main_screen.dart';
import 'package:serviko_app/features/user/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:serviko_app/features/user/role/presentation/cubit/role_cubit.dart';
import 'package:serviko_app/features/provider/main/presentation/pages/provider_main_screen.dart';
import 'package:serviko_app/features/user/profile/presentation/pages/profile_screen.dart';
import 'package:serviko_app/features/provider/profile/presentation/pages/provider_profile_screen.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/pages/provider_onboarding_screen.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/pages/application_status_screen.dart';

// App Routes and Paths
class AppRouter {
  AppRouter._();

  // ---- Route Names ----
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String register = 'register';
  static const String otpVerification = 'otpVerification';
  static const String forgotPassword = 'forgotPassword';
  static const String chooseResetMethod = 'chooseResetMethod';
  static const String createNewPassword = 'createNewPassword';
  static const String resetSuccess = 'resetSuccess';
  static const String fillProfile = 'fillProfile';
  static const String address = 'address';
  static const String congratulations = 'congratulations';
  static const String home = 'home';
  static const String booking = 'booking';
  static const String calendar = 'calendar';
  static const String inbox = 'inbox';
  static const String profile = 'profile';
  static const String search = 'search';

  // Provider route names
  static const String providerOnboarding = 'providerOnboarding';
  static const String providerApplicationStatus = 'providerApplicationStatus';
  static const String providerDashboard = 'providerDashboard';
  static const String providerJobs = 'providerJobs';
  static const String providerInbox = 'providerInbox';
  static const String providerEarnings = 'providerEarnings';
  static const String providerProfile = 'providerProfile';

  // ---- Route Paths ----
  static const String _splashPath = '/splash';
  static const String _onboardingPath = '/onboarding';
  static const String _loginPath = '/login';
  static const String _registerPath = '/register';
  static const String _otpVerificationPath = '/otp-verification';
  static const String _forgotPasswordPath = '/forgot-password';
  static const String _chooseResetMethodPath = '/choose-reset-method';
  static const String _createNewPasswordPath = '/create-new-password';
  static const String _resetSuccessPath = '/reset-success';
  static const String _fillProfilePath = '/fill-profile';
  static const String _addressPath = '/address';
  static const String _congratulationsPath = '/congratulations';
  static const String _homePath = '/home';
  static const String _bookingPath = '/booking';
  static const String _calendarPath = '/calendar';
  static const String _inboxPath = '/inbox';
  static const String _profilePath = '/profile';
  static const String _searchPath = '/search';

  // Provider paths
  static const String _providerOnboardingPath = '/provider/onboarding';
  static const String _providerApplicationStatusPath =
      '/provider/application-status';
  static const String _providerDashboardPath = '/provider/dashboard';
  static const String _providerJobsPath = '/provider/jobs';
  static const String _providerInboxPath = '/provider/inbox';
  static const String _providerEarningsPath = '/provider/earnings';
  static const String _providerProfilePath = '/provider/profile';

  // Auth-related paths
  static final Set<String> _authPaths = {
    _onboardingPath,
    _loginPath,
    _registerPath,
  };

  // Paths that anyone can access without authentication
  static final Set<String> _publicPaths = {
    _splashPath,
    _onboardingPath,
    _loginPath,
    _registerPath,
    _forgotPasswordPath,
    _chooseResetMethodPath,
    _otpVerificationPath,
    _createNewPasswordPath,
    _resetSuccessPath,
  };

  // Paths used for profile setup
  static final Set<String> _profileSetupPaths = {
    _fillProfilePath,
    _addressPath,
    _congratulationsPath,
  };

  // Customer Bottom Navigation paths
  static final Set<String> _customerShellPaths = {
    _homePath,
    _bookingPath,
    _calendarPath,
    _inboxPath,
    _profilePath,
  };

  // Provider Bottom Navigation paths
  static final Set<String> _providerShellPaths = {
    _providerDashboardPath,
    _providerJobsPath,
    _providerInboxPath,
    _providerEarningsPath,
    _providerProfilePath,
  };

  static bool _isProviderRoute(String path) =>
      path != _providerOnboardingPath &&
      path != _providerApplicationStatusPath &&
      (_providerShellPaths.contains(path) || path.startsWith('/provider'));

  static bool _isCustomerShellRoute(String path) =>
      _customerShellPaths.contains(path);

  // Router configuration with auth + role-based redirection
  static GoRouter router(AuthBloc authBloc, RoleCubit roleCubit) => GoRouter(
    initialLocation: _splashPath,
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final currentPath = state.matchedLocation;

      // Loading State
      if (authState is AuthInitial) {
        return currentPath == _splashPath ? null : _splashPath;
      }

      final isAuthenticated = authState is AuthAuthenticated;

      // Unauthenticated user
      if (!isAuthenticated) {
        if (!_publicPaths.contains(currentPath)) {
          return _loginPath;
        }

        if (authState is AuthUnauthenticated) {
          final isOnboardingCompleted = authState.isOnboardingCompleted;

          if (isOnboardingCompleted) {
            if (currentPath == _onboardingPath || currentPath == _splashPath) {
              return _loginPath;
            }
          } else {
            if (currentPath != _onboardingPath) {
              return _onboardingPath;
            }
          }
        }

        return null;
      }

      // --- Authenticated User Logic ---
      final isNewUser = authState.isNewUser;
      final isOnAuthPage = _authPaths.contains(currentPath);
      final isOnProfileSetupPage = _profileSetupPaths.contains(currentPath);

      if (isNewUser) {
        if (!isOnProfileSetupPage) {
          return _fillProfilePath;
        }
        return null;
      }

      // Existing user
      if (isOnAuthPage || isOnProfileSetupPage || currentPath == _splashPath) {
        return _homePath;
      }

      // --- Role-based redirect for users ---
      final roleState = roleCubit.state;

      if (_isProviderRoute(currentPath) && !roleState.canSwitchToProvider) {
        return _homePath;
      }

      if (roleState.isProvider && _isCustomerShellRoute(currentPath)) {
        return _providerDashboardPath;
      }

      if (roleState.isCustomer && _isProviderRoute(currentPath)) {
        return _homePath;
      }

      return null;
    },
    routes: [
      // ---- Splash ----
      GoRoute(
        name: splash,
        path: _splashPath,
        builder: (context, state) => const SplashScreen(),
      ),

      // ---- Onboarding ----
      GoRoute(
        name: onboarding,
        path: _onboardingPath,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // ---- Auth ----
      GoRoute(
        name: login,
        path: _loginPath,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        name: register,
        path: _registerPath,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        name: otpVerification,
        path: _otpVerificationPath,
        builder: (context, state) =>
            OtpVerificationScreen(args: state.extra as OtpVerificationArgs),
      ),
      GoRoute(
        name: forgotPassword,
        path: _forgotPasswordPath,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        name: chooseResetMethod,
        path: _chooseResetMethodPath,
        builder: (context, state) =>
            ChooseResetMethodScreen(args: state.extra as ChooseResetMethodArgs),
      ),

      GoRoute(
        name: createNewPassword,
        path: _createNewPasswordPath,
        builder: (context, state) =>
            CreateNewPasswordScreen(args: state.extra as CreateNewPasswordArgs),
      ),
      GoRoute(
        name: resetSuccess,
        path: _resetSuccessPath,
        builder: (context, state) => const ResetSuccessScreen(),
      ),

      // ---- Profile Setup ----
      GoRoute(
        name: fillProfile,
        path: _fillProfilePath,
        builder: (context, state) => const FillProfileScreen(),
      ),
      GoRoute(
        name: address,
        path: _addressPath,
        builder: (context, state) => const AddressScreen(),
      ),
      GoRoute(
        name: congratulations,
        path: _congratulationsPath,
        builder: (context, state) => const CongratulationsScreen(),
      ),

      // ---- Customer Shell ----
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: home,
                path: _homePath,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: booking,
                path: _bookingPath,
                builder: (context, state) =>
                    const _PlaceholderScreen(title: 'Bookings'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: calendar,
                path: _calendarPath,
                builder: (context, state) =>
                    const _PlaceholderScreen(title: 'Calendar'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: inbox,
                path: _inboxPath,
                builder: (context, state) =>
                    const _PlaceholderScreen(title: 'Inbox'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: profile,
                path: _profilePath,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // ---- Provider Onboarding ----
      GoRoute(
        name: providerOnboarding,
        path: _providerOnboardingPath,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final isReapplication = extra?['isReapplication'] == true;
          return ProviderOnboardingScreen(isReapplication: isReapplication);
        },
      ),

      // ---- Provider Application Status ----
      GoRoute(
        name: providerApplicationStatus,
        path: _providerApplicationStatusPath,
        builder: (context, state) => const ApplicationStatusScreen(),
      ),

      // ---- Provider Shell ----
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ProviderMainScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: providerDashboard,
                path: _providerDashboardPath,
                builder: (context, state) =>
                    const _PlaceholderScreen(title: 'Provider Dashboard'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: providerJobs,
                path: _providerJobsPath,
                builder: (context, state) =>
                    const _PlaceholderScreen(title: 'Jobs'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: providerInbox,
                path: _providerInboxPath,
                builder: (context, state) =>
                    const _PlaceholderScreen(title: 'Inbox'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: providerEarnings,
                path: _providerEarningsPath,
                builder: (context, state) =>
                    const _PlaceholderScreen(title: 'Earnings'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: providerProfile,
                path: _providerProfilePath,
                builder: (context, state) => const ProviderProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        name: search,
        path: _searchPath,
        builder: (context, state) => const _PlaceholderScreen(title: 'Search'),
      ),
    ],
  );
}

// Temporary placeholder screen
class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
      ),
    );
  }
}
