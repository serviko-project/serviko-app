import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/widgets/app_bottom_nav_shell.dart';

// Customer mode bottom navigation
class MainScreen extends AppBottomNavShell {
  const MainScreen({super.key, required super.navigationShell})
    : super(
        tabs: const [
          NavTab(icon: HugeIcons.strokeRoundedHome03, label: 'Home'),
          NavTab(icon: HugeIcons.strokeRoundedNote01, label: 'Bookings'),
          NavTab(icon: HugeIcons.strokeRoundedCalendar03, label: 'Calendar'),
          NavTab(icon: HugeIcons.strokeRoundedMessage02, label: 'Inbox'),
          NavTab(icon: HugeIcons.strokeRoundedUser03, label: 'Profile'),
        ],
      );
}
