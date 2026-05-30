import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/info_banner.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/edit_provider_service_area_cubit.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/edit_provider_service_area_state.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/provider_profile_cubit.dart';
import 'package:serviko_app/features/provider/profile/presentation/widgets/coverage_radius_slider_widget.dart';
import 'package:serviko_app/features/shared/location/presentation/widgets/location_info_card.dart';
import 'package:serviko_app/features/shared/location/presentation/widgets/location_map_picker.dart';

class EditProviderServiceAreaView extends StatefulWidget {
  const EditProviderServiceAreaView({super.key});

  @override
  State<EditProviderServiceAreaView> createState() =>
      _EditProviderServiceAreaViewState();
}

class _EditProviderServiceAreaViewState
    extends State<EditProviderServiceAreaView> {
  bool _autoDetectTriggered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_autoDetectTriggered) {
      _autoDetectTriggered = true;
      final cubit = context.read<EditProviderServiceAreaCubit>();
      if (cubit.state.latitude == null) {
        cubit.detectCurrentLocation();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      EditProviderServiceAreaCubit,
      EditProviderServiceAreaState
    >(
      listener: (context, state) {
        if (state.status == EditProviderServiceAreaStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Service area updated successfully'),
              backgroundColor: AppColors.success,
            ),
          );
          context.read<ProviderProfileCubit>().fetchProviderProfile();
          Navigator.of(context).pop();
        } else if (state.status == EditProviderServiceAreaStatus.error &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.error,
            ),
          );
          context.read<EditProviderServiceAreaCubit>().clearError();
        }
      },
      child:
          BlocBuilder<
            EditProviderServiceAreaCubit,
            EditProviderServiceAreaState
          >(
            builder: (context, state) {
              final cubit = context.read<EditProviderServiceAreaCubit>();

              // Default center coordinates if not detected
              final center = LatLng(
                state.latitude ?? 11.0515,
                state.longitude ?? 75.9857,
              );

              final isSaving =
                  state.status == EditProviderServiceAreaStatus.saving;

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSizes.screenPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const InfoBanner(
                            text:
                                'Tap on the map to set your service location, then adjust the radius slider to define your coverage area.',
                          ),
                          const SizedBox(height: AppSizes.xl),

                          // Map Picker
                          LocationMapPicker(
                            center: center,
                            radiusKm: state.coverageRadius,
                            onLocationChanged: (newLatLng) {
                              cubit.updateLocation(
                                newLatLng.latitude,
                                newLatLng.longitude,
                              );
                            },
                          ),
                          const SizedBox(height: AppSizes.lg),

                          // Location details and re-center
                          LocationInfoCard(
                            address: state.resolvedAddress,
                            isLoading: state.isLocationLoading,
                            onRecenter: () => cubit.detectCurrentLocation(),
                          ),
                          const SizedBox(height: AppSizes.xl),

                          // Slider to configure radius
                          CoverageRadiusSliderWidget(
                            cubit: cubit,
                            state: state,
                          ),
                          const SizedBox(height: AppSizes.xl),

                          // Estimated Reach
                          const InfoBanner(
                            text: 'Estimated reach: ~1,000 customers',
                            icon: Icons.people_alt_outlined,
                            color: AppColors.success,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.lg),
                    child: CustomButton(
                      text: 'Save Service Area',
                      onPressed: isSaving
                          ? () {}
                          : () => cubit.saveServiceArea(),
                      isLoading: isSaving,
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }
}
