import 'package:go_router/go_router.dart';
import '../../widgets/placeholder_screen.dart';
import '../../../features/user/auth/presentation/pages/address_screen.dart';
import '../../../features/user/auth/presentation/pages/congratulations_screen.dart';
import '../../../features/user/auth/presentation/pages/fill_profile_screen.dart';
import '../../../features/user/auth/presentation/pages/splash_screen.dart';
import '../../../features/user/onboarding/presentation/pages/onboarding_screen.dart';
import '../../../features/user/profile/presentation/pages/edit_profile_screen.dart';
import '../../../features/user/bookmarks/presentation/pages/bookmarks_screen.dart';
import '../route_constants.dart';

List<RouteBase> miscRoutes = [
  // ---- Splash ----
  GoRoute(
    name: RouteNames.splash,
    path: RoutePaths.splash,
    builder: (context, state) => const SplashScreen(),
  ),

  // ---- Onboarding ----
  GoRoute(
    name: RouteNames.onboarding,
    path: RoutePaths.onboarding,
    builder: (context, state) => const OnboardingScreen(),
  ),

  // ---- Profile Setup ----
  GoRoute(
    name: RouteNames.fillProfile,
    path: RoutePaths.fillProfile,
    builder: (context, state) => const FillProfileScreen(),
  ),
  GoRoute(
    name: RouteNames.address,
    path: RoutePaths.address,
    builder: (context, state) => const AddressScreen(),
  ),
  GoRoute(
    name: RouteNames.congratulations,
    path: RoutePaths.congratulations,
    builder: (context, state) => const CongratulationsScreen(),
  ),

  GoRoute(
    name: RouteNames.editProfile,
    path: RoutePaths.editProfile,
    builder: (context, state) => const EditProfileScreen(),
  ),
  GoRoute(
    name: RouteNames.search,
    path: RoutePaths.search,
    builder: (context, state) => const PlaceholderScreen(title: 'Search'),
  ),
  GoRoute(
    name: RouteNames.bookmarks,
    path: RoutePaths.bookmarks,
    builder: (context, state) => const BookmarksScreen(),
  ),
];
