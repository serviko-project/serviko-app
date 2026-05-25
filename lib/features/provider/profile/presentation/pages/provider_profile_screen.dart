import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/core/widgets/role_switch_tile.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/router/route_constants.dart';
import 'package:serviko_app/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:serviko_app/features/user/profile/presentation/cubit/profile_cubit.dart';
import 'package:serviko_app/features/user/profile/presentation/cubit/profile_state.dart';
import 'package:serviko_app/features/user/profile/presentation/widgets/logout_tile.dart';
import 'package:serviko_app/features/user/profile/presentation/widgets/policy_and_help_card_widget.dart';
import 'package:serviko_app/features/user/profile/presentation/widgets/profile_info_header.dart';
import 'package:serviko_app/features/user/profile/presentation/widgets/profile_menu_tile.dart';

// Profile Screen of Provider
class ProviderProfileScreen extends StatelessWidget {
  const ProviderProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: "Provider Profile",
        leading: SizedBox.shrink(),
      ),
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            return BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, userProfileState) {
                String displayName = 'Provider';
                String email = '';
                String? photoUrl;

                // Auth Information
                if (authState is AuthAuthenticated) {
                  displayName = authState.user.displayName ?? '';
                  email = authState.user.email ?? '';
                }

                // Cached Information
                if (userProfileState is ProfileLoaded) {
                  displayName = userProfileState.profile.fullName;
                  email = userProfileState.profile.email;
                  photoUrl =
                      userProfileState.profile.profileImageUrl ?? photoUrl;
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),

                      // Provider Profile Info Header
                      ProfileInfoHeader(
                        displayName: displayName,
                        email: email,
                        photoUrl: photoUrl,
                      ),

                      SizedBox(height: AppSizes.xl),

                      // Business Management Card
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border, width: 1),
                        ),
                        child: Column(
                          children: [
                            // Edit Profie Tile
                            ProfileMenuTile(
                              title: 'Edit Provider Details',
                              icon: HugeIcons.strokeRoundedUserEdit01,
                              onTap: () => context.pushNamed(
                                RouteNames.providerEditDetails,
                              ),
                            ),
                            ProfileMenuDivider(),

                            // Manage Services Tile
                            ProfileMenuTile(
                              title: 'Manage Services',
                              icon: HugeIcons.strokeRoundedBriefcase01,
                              onTap: null,
                            ),
                            ProfileMenuDivider(),

                            // Timing & Availability Tile
                            ProfileMenuTile(
                              title: 'Timing & Availability',
                              icon: HugeIcons.strokeRoundedClock01,
                              onTap: null,
                            ),
                            ProfileMenuDivider(),

                            // Service Area Tile
                            ProfileMenuTile(
                              title: 'Service Area',
                              icon: HugeIcons.strokeRoundedLocation01,
                              onTap: null,
                            ),
                            ProfileMenuDivider(),

                            // Promo Codes Tile
                            ProfileMenuTile(
                              title: 'Promo Codes',
                              icon: HugeIcons.strokeRoundedTicket01,
                              onTap: () => context.pushNamed(
                                RouteNames.providerPromoCodes,
                              ),
                            ),
                            ProfileMenuDivider(),
                          ],
                        ),
                      ),

                      SizedBox(height: AppSizes.md),

                      // Notification Card
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border, width: 1),
                        ),
                        child: const Column(
                          children: [
                            ProfileMenuTile(
                              title: 'Notification',
                              icon: HugeIcons.strokeRoundedNotification03,
                              onTap: null,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppSizes.md),

                      // Support & Policies Card
                      PolicyAndHelpCardWidget(),

                      SizedBox(height: AppSizes.md),

                      // Role Switch Tile
                      const RoleSwitchTile(),

                      SizedBox(height: AppSizes.lg),

                      // Logout Tile
                      const LogoutTile(),

                      const SizedBox(height: AppSizes.xxl),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
