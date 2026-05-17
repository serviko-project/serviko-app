import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/user/profile/presentation/cubit/profile_cubit.dart';
import 'package:serviko_app/features/user/profile/presentation/cubit/profile_state.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Profile image, User Name and action icons at the top of the home screen
class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: Row(
        children: [
          // Profile Image
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

          // Greeting & Name
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
                    String name = "User";
                    if (state is ProfileLoaded) {
                      name = state.profile.fullName;
                    } else if (state is ProfileLoading) {
                      name = "...";
                    }
                    return Text(
                      name,
                      style: AppTextStyles.h3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ],
            ),
          ),

          // Action Icons
          IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.bell,
              color: AppColors.textPrimary,
              size: 25,
            ),
          ),
          IconButton(
            onPressed: () => context.pushNamed(AppRouter.bookmarks),
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedBookmark02,
              color: AppColors.textPrimary,
              size: 23,
            ),
          ),
        ],
      ),
    );
  }
}
