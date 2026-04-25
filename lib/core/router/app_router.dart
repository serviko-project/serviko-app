import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/router/go_router_refresh_stream.dart';
import 'package:serviko_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:serviko_app/features/auth/presentation/pages/address_screen.dart';
import 'package:serviko_app/features/auth/presentation/pages/congratulations_screen.dart';
import 'package:serviko_app/features/auth/presentation/pages/choose_reset_method_screen.dart';
import 'package:serviko_app/features/auth/presentation/pages/create_new_password_screen.dart';
import 'package:serviko_app/features/auth/presentation/pages/fill_profile_screen.dart';
import 'package:serviko_app/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:serviko_app/features/auth/presentation/pages/otp_verification_screen.dart';
import 'package:serviko_app/features/auth/presentation/pages/reset_success_screen.dart';
import 'package:serviko_app/features/auth/presentation/pages/sign_in_screen.dart';
import 'package:serviko_app/features/auth/presentation/pages/sign_up_screen.dart';
import 'package:serviko_app/features/auth/presentation/pages/splash_screen.dart';
import 'package:serviko_app/features/auth/presentation/models/password_recovery_flow_args.dart';
import 'package:serviko_app/features/home/presentation/pages/home_screen.dart';
import 'package:serviko_app/features/main/presentation/pages/main_screen.dart';
import 'package:serviko_app/features/onboarding/presentation/pages/onboarding_screen.dart';

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

  // Auth-related paths that authenticated users should not see
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

  // Router configuration with authentication-based redirection logic
  static GoRouter router(AuthBloc authBloc) => GoRouter(
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

      // ---- Main App ----
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
                builder: (context, state) =>
                    const _PlaceholderScreen(title: 'Profile'),
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
