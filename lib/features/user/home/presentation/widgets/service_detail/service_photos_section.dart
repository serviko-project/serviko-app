import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/section_header.dart';

// Photos & Videos Section
class ServicePhotosSection extends StatelessWidget {
  const ServicePhotosSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        SectionHeader(title: "Photos & Videos", onSeeAllTap: () {}),
        SizedBox(height: AppSizes.md),

        // Photos & Videos Grid
        GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenPadding,
          ),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSizes.sm,
            mainAxisSpacing: AppSizes.sm,
            childAspectRatio: 1.3,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.shimmerBase,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: const Center(
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.textHint,
                  size: 28,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
