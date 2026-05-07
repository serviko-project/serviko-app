import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

// Profile image, User Name and action icons at the top of the home screen
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: Row(
        children: [
          // Profile Image
          CircleAvatar(
            radius: 24,
            backgroundImage: const NetworkImage(
              "https://imgs.search.brave.com/escqQ8ZcajwNi21WSqfUpZo9B9rNcmsmh42fdgstEI0/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zdGF0/aWMudmVjdGVlenku/Y29tL3N5c3RlbS9y/ZXNvdXJjZXMvdGh1/bWJuYWlscy8wMzIv/MTc2LzE5MS9zbWFs/bC9idXNpbmVzcy1h/dmF0YXItcHJvZmls/ZS1ibGFjay1pY29u/LW1hbi1vZi11c2Vy/LXN5bWJvbC1pbi10/cmVuZHktZmxhdC1z/dHlsZS1pc29sYXRl/ZC1vbi1tYWxlLXBy/b2ZpbGUtcGVvcGxl/LWRpdmVyc2UtZmFj/ZS1mb3Itc29jaWFs/LW5ldHdvcmstb3It/d2ViLXZlY3Rvci5q/cGc",
            ),
            backgroundColor: AppColors.shimmerBase,
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
                Text(
                  "User Name",
                  style: AppTextStyles.h3,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Action Icons
          IconButton(
            onPressed: () {},
            icon: Icon(
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
