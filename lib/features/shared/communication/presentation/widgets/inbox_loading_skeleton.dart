import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:skeletonizer/skeletonizer.dart';

class InboxLoadingSkeleton extends StatelessWidget {
  const InboxLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSizes.sm),
        itemCount: 8,
        separatorBuilder: (_, _) => const SizedBox(height: 2),
        itemBuilder: (context, index) {
          return const Material(
            color: AppColors.background,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.xs,
                vertical: AppSizes.sm,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.shimmerHighlight,
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Contact Name'),
                        SizedBox(height: 5),
                        Text('Latest message preview'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
