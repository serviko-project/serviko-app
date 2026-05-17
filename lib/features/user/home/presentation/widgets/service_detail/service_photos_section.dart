import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/section_header.dart';

// Photos & Videos Section
class ServicePhotosSection extends StatelessWidget {
  final List<String> images;

  const ServicePhotosSection({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        SectionHeader(title: "Photos & Videos", onSeeAllTap: () {}),
        SizedBox(height: AppSizes.md),

        // Photos & Videos Grid
        images.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Center(
                  child: Text(
                    "No photos available",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                ),
              )
            : GridView.builder(
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
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBase,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      image: DecorationImage(
                        image: NetworkImage(images[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}
