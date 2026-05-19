import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/router/route_constants.dart';
import 'package:serviko_app/features/user/profile/presentation/widgets/profile_menu_tile.dart';

class PolicyAndHelpCardWidget extends StatelessWidget {
  const PolicyAndHelpCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        children: [
          ProfileMenuTile(
            title: 'Privacy Policy',
            icon: HugeIcons.strokeRoundedShield01,
            onTap: () => context.pushNamed(RouteNames.privacyPolicy),
          ),
          const ProfileMenuDivider(),
          ProfileMenuTile(
            title: 'Help Center',
            icon: HugeIcons.strokeRoundedInformationCircle,
            onTap: () => context.pushNamed(RouteNames.helpCenter),
          ),
        ],
      ),
    );
  }
}
