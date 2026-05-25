import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/profile/presentation/cubit/profile_cubit.dart';
import 'package:serviko_app/features/user/profile/presentation/cubit/profile_state.dart';

// Top header section of the provider dashboard
class ProviderDashboardHeader extends StatelessWidget {
  const ProviderDashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: Row(
        children: [
          // Profile image
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              String? imageUrl;
              if (state is ProfileLoaded) {
                imageUrl = state.profile.profileImageUrl;
              }
              return CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.shimmerBase,
                backgroundImage: imageUrl != null
                    ? CachedNetworkImageProvider(imageUrl)
                    : null,
                child: imageUrl == null
                    ? const Icon(
                        Icons.person,
                        size: 27,
                        color: AppColors.textSecondary,
                      )
                    : null,
              );
            },
          ),
          const SizedBox(width: AppSizes.md),

          // Greeting text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back, 👋',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    String name = 'Provider';
                    if (state is ProfileLoaded) {
                      name = state.profile.fullName;
                    } else if (state is ProfileLoading) {
                      name = '...';
                    }
                    return Text(
                      name,
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ],
            ),
          ),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.sm + 2,
              vertical: AppSizes.xs + 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.verified_rounded,
                  color: AppColors.primary,
                  size: 16,
                ),
                const SizedBox(width: AppSizes.xs),
                Text(
                  'Active',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
