import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/widgets/app_bottom_nav_shell.dart';

// Provider mode bottom navigation
class ProviderMainScreen extends AppBottomNavShell {
  const ProviderMainScreen({super.key, required super.navigationShell})
    : super(
        tabs: const [
          NavTab(icon: HugeIcons.strokeRoundedHome03, label: 'Home'),
          NavTab(icon: HugeIcons.strokeRoundedBriefcase01, label: 'Jobs'),
          NavTab(icon: HugeIcons.strokeRoundedMoney03, label: 'Earnings'),
          NavTab(icon: HugeIcons.strokeRoundedMessage02, label: 'Inbox'),
          NavTab(icon: HugeIcons.strokeRoundedUser03, label: 'Profile'),
        ],
      );
}
