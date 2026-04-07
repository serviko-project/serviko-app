import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Centralized route configuration using GoRouter.
class AppRouter {
  AppRouter._();

  // ── Route Names ──
  static const String splash = 'splash';
  static const String login = 'login';
  static const String register = 'register';
  static const String home = 'home';
  static const String search = 'search';
  static const String booking = 'booking';
  static const String profile = 'profile';

  // ── Route Paths ──
  static const String splashPath = '/';
  static const String loginPath = '/login';
  static const String registerPath = '/register';
  static const String homePath = '/home';
  static const String searchPath = '/search';
  static const String bookingPath = '/booking';
  static const String profilePath = '/profile';

  // The GoRouter instance.
  static final GoRouter router = GoRouter(
    initialLocation: splashPath,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        name: splash,
        path: splashPath,
        builder: (context, state) => const _PlaceholderScreen(title: 'Splash'),
      ),
      GoRoute(
        name: login,
        path: loginPath,
        builder: (context, state) => const _PlaceholderScreen(title: 'Login'),
      ),
      GoRoute(
        name: register,
        path: registerPath,
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'Register'),
      ),
      GoRoute(
        name: home,
        path: homePath,
        builder: (context, state) => const _PlaceholderScreen(title: 'Home'),
      ),
      GoRoute(
        name: search,
        path: searchPath,
        builder: (context, state) => const _PlaceholderScreen(title: 'Search'),
      ),
      GoRoute(
        name: booking,
        path: bookingPath,
        builder: (context, state) => const _PlaceholderScreen(title: 'Booking'),
      ),
      GoRoute(
        name: profile,
        path: profilePath,
        builder: (context, state) => const _PlaceholderScreen(title: 'Profile'),
      ),
    ],
  );
}

// Temporary placeholder screen
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

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
