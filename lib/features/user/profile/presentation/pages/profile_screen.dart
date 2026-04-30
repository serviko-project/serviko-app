import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/core/widgets/role_switch_tile.dart';
import 'package:serviko_app/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:serviko_app/features/user/profile/presentation/cubit/profile_cubit.dart';
import 'package:serviko_app/features/user/profile/presentation/cubit/profile_state.dart';
import 'package:serviko_app/features/user/profile/presentation/widgets/logout_tile.dart';
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
                    photoUrl = authState.user.photoUrl;
                  }

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),

                        // Avatar Section
                        Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.surface,
                            backgroundImage:
                                photoUrl != null && photoUrl.isNotEmpty
                                ? NetworkImage(photoUrl)
                                : null,
                            child: (photoUrl == null || photoUrl.isEmpty)
                                ? const HugeIcon(
                                    icon: HugeIcons.strokeRoundedUser03,
                                    color: AppColors.textSecondary,
                                    size: 40,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // User Info Section
                        Center(
                          child: Text(
                            displayName,
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: Text(
                            email,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
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
                              const Divider(
                                height: 1,
                                indent: 46,
                                endIndent: 16,
                                color: AppColors.border,
                              ),
                              const ProfileMenuTile(
                                title: 'Notification',
                                icon: HugeIcons.strokeRoundedNotification03,
                                onTap: null,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Support / Info Card
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.border,
                              width: 1,
                            ),
                          ),
                          child: const Column(
                            children: [
                              ProfileMenuTile(
                                title: 'Privacy Policy',
                                icon: HugeIcons.strokeRoundedShield01,
                                onTap: null,
                              ),
                              Divider(
                                height: 1,
                                indent: 46,
                                endIndent: 16,
                                color: AppColors.border,
                              ),
                              ProfileMenuTile(
                                title: 'Help Center',
                                icon: HugeIcons.strokeRoundedInformationCircle,
                                onTap: null,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // App's Role Switch Tile
                        const RoleSwitchTile(),

                        const SizedBox(height: 30),

                        // Logout Tile
                        LogoutTile(),

                        const SizedBox(height: 48),
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
