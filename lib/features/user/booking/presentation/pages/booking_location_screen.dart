import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/router/route_constants.dart';
import 'package:serviko_app/features/shared/location/presentation/widgets/location_info_card.dart';
import 'package:serviko_app/features/shared/location/presentation/widgets/location_map_picker.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_request_payload.dart';
import 'package:serviko_app/features/user/booking/presentation/bloc/booking_location_cubit.dart';
import 'package:serviko_app/injection_container.dart';

class BookingLocationScreen extends StatelessWidget {
  final BookingRequestPayload payload;

  const BookingLocationScreen({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BookingLocationCubit(InjectionContainer.instance.locationService),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: "Your Location"),
        body: BlocBuilder<BookingLocationCubit, BookingLocationState>(
          builder: (context, state) {
            if (state.currentLocation == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Stack(
              children: [
                // Full Screen Map
                Positioned.fill(
                  child: LocationMapPicker(
                    center: state.currentLocation!,
                    height: double.infinity,
                    onLocationChanged: (newLocation) {
                      context.read<BookingLocationCubit>().updateLocation(
                        newLocation,
                      );
                    },
                  ),
                ),

                // Location Details Card
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.screenPadding),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppSizes.radiusXl),
                        topRight: Radius.circular(AppSizes.radiusXl),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drag Handle
                        Center(
                          child: Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: AppColors.border,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.xl),

                        // Location Details
                        const Text(
                          'Location Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.md),
                        LocationInfoCard(
                          address: state.currentAddress,
                          isLoading: state.isLoading,
                          onRecenter: () {
                            context.read<BookingLocationCubit>().recenter();
                          },
                        ),
                        const SizedBox(height: AppSizes.xl),
                        CustomButton(
                          text: "Continue",
                          isLoading: state.isLoading,
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  final updatedPayload = payload.copyWith(
                                    customerLatitude:
                                        state.currentLocation!.latitude,
                                    customerLongitude:
                                        state.currentLocation!.longitude,
                                    customerAddress: state.currentAddress,
                                  );
                                  context.pushNamed(
                                    RouteNames.bookingSummary,
                                    extra: updatedPayload,
                                  );
                                },
                        ),
                        const SizedBox(height: AppSizes.md),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
