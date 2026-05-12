import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/features/user/service/presentation/cubit/service_detail_cubit.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_detail/service_cover_image.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_detail/service_info_section.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_detail/service_about_section.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_detail/service_photos_section.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_detail/service_reviews_section.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_detail/service_bottom_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:serviko_app/features/user/service/domain/entities/service_entity.dart';
import 'package:serviko_app/core/widgets/custom_error_widget.dart';

// Service detail Screen
class ServiceDetailScreen extends StatefulWidget {
  final String serviceId;

  const ServiceDetailScreen({super.key, required this.serviceId});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ServiceDetailCubit>().fetchServiceDetail(widget.serviceId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceDetailCubit, ServiceDetailState>(
      builder: (context, state) {
        if (state is ServiceDetailError) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: CustomErrorWidget(
              message: state.message,
              isFullPage: true,
              onRetry: () {
                context.read<ServiceDetailCubit>().fetchServiceDetail(
                  widget.serviceId,
                );
              },
            ),
          );
        }

        final bool isLoading =
            state is ServiceDetailLoading || state is ServiceDetailInitial;

        final ServiceEntity service = state is ServiceDetailLoaded
            ? state.service
            : const ServiceEntity(
                id: '',
                categoryId: '',
                categoryName: 'Category',
                categoryIcon: 'category_rounded',
                providerId: '',
                providerName: 'Provider Name',
                basePricePerHour: 0,
                rating: 0,
                reviewsCount: 0,
                professionalTitle: 'Professional Title',
                galleryImages: [],
                latitude: 9.9312,
                longitude: 76.2673,
              );

        final List<ProviderServiceEntity> categories =
            service.allCategories.isEmpty
            ? [
                ProviderServiceEntity(
                  categoryId: service.categoryId,
                  categoryName: service.categoryName,
                  basePricePerHour: service.basePricePerHour,
                ),
              ]
            : service.allCategories;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Skeletonizer(
            enabled: isLoading,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Banner
                  ServiceCoverImage(
                    imageUrl: service.bannerImage,
                    categoryIcon: service.categoryIcon,
                    providerImage: service.providerImage,
                    isLoading: isLoading,
                  ),

                  // Service info
                  ServiceInfoSection(
                    providerName: service.providerName,
                    providerImage: service.providerImage,
                    selectedCategoryId: state.selectedService?.categoryId,
                    categories: categories,
                    rating: service.rating,
                    reviewsCount: service.reviewsCount,
                    professionalTitle: service.professionalTitle,
                    yearsOfExperience: service.yearsOfExperience,
                    address: state.address,
                    onServiceSelected: (selected) {
                      context.read<ServiceDetailCubit>().selectService(
                        selected,
                      );
                    },
                  ),
                  const SizedBox(height: AppSizes.lg),

                  // Divider
                  _buildDivider(),
                  const SizedBox(height: AppSizes.md),

                  // About Provider
                  ServiceAboutSection(about: service.about),
                  const SizedBox(height: AppSizes.lg),

                  // Divider
                  _buildDivider(),
                  const SizedBox(height: AppSizes.lg),

                  // Photos & Videos
                  ServicePhotosSection(images: service.galleryImages),
                  const SizedBox(height: AppSizes.lg),

                  // Divider
                  _buildDivider(),
                  const SizedBox(height: AppSizes.md),

                  // Reviews
                  const ServiceReviewsSection(),
                  const SizedBox(height: AppSizes.lg),
                ],
              ),
            ),
          ),
          // Bottom bar with Price, Message and Book Now buttons
          bottomNavigationBar: isLoading
              ? null
              : ServiceBottomBar(
                  serviceName:
                      state.selectedService?.categoryName ??
                      service.categoryName,
                  price:
                      state.selectedService?.basePricePerHour ??
                      service.basePricePerHour,
                  onMessageTap: () {},
                  onBookNowTap: () {},
                ),
        );
      },
    );
  }

  // Divider builder
  Padding _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
      child: Divider(),
    );
  }
}
