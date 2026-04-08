import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/features/auth/presentation/pages/address_screen.dart';
import 'package:serviko_app/features/auth/presentation/pages/congratulations_screen.dart';
import 'package:serviko_app/features/auth/presentation/pages/create_new_password_screen.dart';
import 'package:serviko_app/features/auth/presentation/pages/fill_profile_screen.dart';
import 'package:serviko_app/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:serviko_app/features/auth/presentation/pages/otp_verification_screen.dart';
import 'package:serviko_app/features/auth/presentation/pages/reset_success_screen.dart';
import 'package:serviko_app/features/auth/presentation/pages/sign_in_screen.dart';
import 'package:serviko_app/features/auth/presentation/pages/sign_up_screen.dart';
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
  static const String forgotPasswordOtp = 'forgotPasswordOtp';
  static const String createNewPassword = 'createNewPassword';
  static const String resetSuccess = 'resetSuccess';
  static const String fillProfile = 'fillProfile';
  static const String address = 'address';
  static const String congratulations = 'congratulations';
  static const String home = 'home';
  static const String search = 'search';
  static const String booking = 'booking';
  static const String profile = 'profile';

  // ---- Route Paths ----
  static const String _onboardingPath = '/onboarding';
  static const String _loginPath = '/login';
  static const String _registerPath = '/register';
  static const String _otpVerificationPath = '/otp-verification';
  static const String _forgotPasswordPath = '/forgot-password';
  static const String _forgotPasswordOtpPath = '/forgot-password-otp';
  static const String _createNewPasswordPath = '/create-new-password';
  static const String _resetSuccessPath = '/reset-success';
  static const String _fillProfilePath = '/fill-profile';
  static const String _addressPath = '/address';
  static const String _congratulationsPath = '/congratulations';
  static const String _homePath = '/home';
  static const String _searchPath = '/search';
  static const String _bookingPath = '/booking';
  static const String _profilePath = '/profile';

  // The GoRouter instance
  static final GoRouter router = GoRouter(
    initialLocation: _onboardingPath,
    debugLogDiagnostics: true,
    routes: [
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
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        name: forgotPassword,
        path: _forgotPasswordPath,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        name: forgotPasswordOtp,
        path: _forgotPasswordOtpPath,
        builder: (context, state) =>
            const OtpVerificationScreen(isForgotPassword: true),
      ),
      GoRoute(
        name: createNewPassword,
        path: _createNewPasswordPath,
        builder: (context, state) => const CreateNewPasswordScreen(),
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

      // ---- Main App (placeholders) ----
      GoRoute(
        name: home,
        path: _homePath,
        builder: (context, state) => const _PlaceholderScreen(title: 'Home'),
      ),
      GoRoute(
        name: search,
        path: _searchPath,
        builder: (context, state) => const _PlaceholderScreen(title: 'Search'),
      ),
      GoRoute(
        name: booking,
        path: _bookingPath,
        builder: (context, state) => const _PlaceholderScreen(title: 'Booking'),
      ),
      GoRoute(
        name: profile,
        path: _profilePath,
        builder: (context, state) => const _PlaceholderScreen(title: 'Profile'),
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
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}
