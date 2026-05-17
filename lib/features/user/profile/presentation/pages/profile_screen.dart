import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/core/widgets/role_switch_tile.dart';
import 'package:serviko_app/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:serviko_app/features/user/profile/presentation/cubit/profile_cubit.dart';
import 'package:serviko_app/features/user/profile/presentation/cubit/profile_state.dart';
import 'package:serviko_app/features/user/profile/presentation/widgets/logout_tile.dart';
import 'package:serviko_app/features/user/profile/presentation/widgets/policy_and_help_card_widget.dart';
import 'package:serviko_app/features/user/profile/presentation/widgets/profile_info_header.dart';
import 'package:serviko_app/features/user/profile/presentation/widgets/profile_menu_tile.dart';

// Profile Screen of User
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: "My Profile", leading: SizedBox.shrink()),
        body: SafeArea(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              return BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, profileState) {
                  String displayName = 'User';
                  String email = '';
                  String? photoUrl;

                  if (profileState is ProfileLoaded) {
                    displayName = profileState.profile.fullName;
                    email = profileState.profile.email;
                    photoUrl = profileState.profile.profileImageUrl;
                  } else if (authState is AuthAuthenticated) {
                    displayName = authState.user.displayName ?? 'User';
                    email = authState.user.email ?? '';
                  }

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),

                        // Profile Info Header
                        ProfileInfoHeader(
                          displayName: displayName,
                          email: email,
                          photoUrl: photoUrl,
                        ),

                        const SizedBox(height: 32),

                        // General Settings Card
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.border,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              ProfileMenuTile(
                                title: 'Edit Profile',
                                icon: HugeIcons.strokeRoundedUser03,
                                onTap: () =>
                                    context.pushNamed(AppRouter.editProfile),
                              ),
                              const ProfileMenuDivider(),
                              const ProfileMenuTile(
                                title: 'Notification',
                                icon: HugeIcons.strokeRoundedNotification03,
                                onTap: null,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: AppSizes.md),

                        // Support & Policies Card
                        PolicyAndHelpCardWidget(),

                        const SizedBox(height: AppSizes.md),

                        // App's Role Switch Tile
                        const RoleSwitchTile(),

                        const SizedBox(height: AppSizes.lg),

                        // Logout Tile
                        LogoutTile(),

                        const SizedBox(height: AppSizes.xxl),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
