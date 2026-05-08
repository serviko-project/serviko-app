import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_cubit.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/coverage_radius_widget.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/info_banner.dart';
import 'package:serviko_app/features/shared/location/presentation/widgets/location_info_card.dart';
import 'package:serviko_app/features/shared/location/presentation/widgets/location_map_picker.dart';

class ServiceAreaView extends StatefulWidget {
  const ServiceAreaView({super.key});

  @override
  State<ServiceAreaView> createState() => _ServiceAreaViewState();
}

class _ServiceAreaViewState extends State<ServiceAreaView> {
  bool _autoDetectTriggered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_autoDetectTriggered) {
      _autoDetectTriggered = true;
      final cubit = context.read<ProviderOnboardingCubit>();
      if (cubit.state.latitude == null) {
        cubit.detectCurrentLocation();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderOnboardingCubit, ProviderOnboardingState>(
      buildWhen: (prev, curr) =>
          prev.latitude != curr.latitude ||
          prev.longitude != curr.longitude ||
          prev.resolvedAddress != curr.resolvedAddress ||
          prev.isLocationLoading != curr.isLocationLoading ||
          prev.coverageRadius != curr.coverageRadius,
      builder: (context, state) {
        final cubit = context.read<ProviderOnboardingCubit>();

        // Default Value
        final center = LatLng(
          state.latitude ?? 11.0168,
          state.longitude ?? 76.0694,
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSizes.lg),

              const InfoBanner(
                text:
                    'Tap on the map to set your service location, then adjust the radius slider to define your coverage area.',
              ),
              const SizedBox(height: AppSizes.xl),

              // Map
              LocationMapPicker(
                center: center,
                radiusKm: state.coverageRadius,
                onLocationChanged: (newLatLng) {
                  cubit.updateLocation(newLatLng.latitude, newLatLng.longitude);
                },
              ),
              const SizedBox(height: AppSizes.lg),

              // Location info card with re-center button
              LocationInfoCard(
                address: state.resolvedAddress,
                isLoading: state.isLocationLoading,
                onRecenter: () => cubit.detectCurrentLocation(),
              ),
              const SizedBox(height: AppSizes.xl),

              // Radius slider
              const CoverageRadiusWidget(),

              const SizedBox(height: AppSizes.xl),

              // Estimated reach
              const InfoBanner(
                text: 'Estimated reach: ~1,000 customers',
                icon: Icons.people_alt_outlined,
                color: AppColors.success,
              ),
              const SizedBox(height: AppSizes.xl * 2),
            ],
          ),
        );
      },
    );
  }
}
