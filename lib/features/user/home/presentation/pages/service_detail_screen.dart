import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/features/user/home/presentation/cubit/service_detail_cubit.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_detail/service_cover_image.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_detail/service_info_section.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_detail/service_about_section.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_detail/service_photos_section.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_detail/service_reviews_section.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_detail/service_bottom_bar.dart';

// Service detail Screen
class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({super.key, required this.serviceIndex});

  final int serviceIndex;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServiceDetailCubit(),
      child: _ServiceDetailView(serviceIndex: serviceIndex),
    );
  }
}

class _ServiceDetailView extends StatelessWidget {
  final int serviceIndex;

  const _ServiceDetailView({required this.serviceIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Banner
            ServiceCoverImage(serviceIndex: serviceIndex),

            // Service info (provider name, categories, price, rating)
            ServiceInfoSection(serviceIndex: serviceIndex),
            const SizedBox(height: AppSizes.lg),

            // Divider
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
              child: Divider(),
            ),
            const SizedBox(height: AppSizes.md),

            // About Provider
            const ServiceAboutSection(),
            const SizedBox(height: AppSizes.lg),

            // Divider
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
              child: Divider(),
            ),
            const SizedBox(height: AppSizes.lg),

            // Photos & Videos
            const ServicePhotosSection(),
            const SizedBox(height: AppSizes.lg),

            // Divider
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
              child: Divider(),
            ),
            const SizedBox(height: AppSizes.md),

            // Reviews
            const ServiceReviewsSection(),
            const SizedBox(height: AppSizes.lg),
          ],
        ),
      ),

      // Bottom bar with Message and Book Now buttons
      bottomNavigationBar: ServiceBottomBar(
        onMessageTap: () {},
        onBookNowTap: () {},
      ),
    );
  }
}
