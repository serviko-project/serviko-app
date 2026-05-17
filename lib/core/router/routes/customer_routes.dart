import 'package:go_router/go_router.dart';
import '../../../features/user/home/presentation/pages/home_screen.dart';
import '../../../features/user/main/presentation/pages/main_screen.dart';
import '../../../features/user/profile/presentation/pages/profile_screen.dart';
import '../../../features/user/booking/presentation/pages/my_bookings_screen.dart';
import '../../../features/user/calendar/presentation/pages/calendar_screen.dart';
import '../../widgets/placeholder_screen.dart';
import '../route_constants.dart';

RouteBase customerRoutes = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return MainScreen(navigationShell: navigationShell);
  },
  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: RouteNames.home,
          path: RoutePaths.home,
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: RouteNames.booking,
          path: RoutePaths.booking,
          builder: (context, state) => const MyBookingsScreen(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: RouteNames.calendar,
          path: RoutePaths.calendar,
          builder: (context, state) => const CalendarScreen(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: RouteNames.inbox,
          path: RoutePaths.inbox,
          builder: (context, state) => const PlaceholderScreen(title: 'Inbox'),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: RouteNames.profile,
          path: RoutePaths.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
