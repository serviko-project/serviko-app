import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/back_button_widget.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/features/shared/location/presentation/widgets/location_info_card.dart';
import 'package:serviko_app/features/shared/location/presentation/widgets/location_map_picker.dart';
import 'package:serviko_app/features/user/auth/presentation/cubit/customer_address_cubit.dart';
import 'package:serviko_app/features/user/auth/presentation/cubit/customer_address_state.dart';
import 'package:serviko_app/injection_container.dart';

// Address input screen
class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CustomerAddressCubit(
        locationService: InjectionContainer.instance.locationService,
        updateProfileUseCase: InjectionContainer.instance.updateProfileUseCase,
      ),
      child: const _AddressScreenView(),
    );
  }
}

class _AddressScreenView extends StatefulWidget {
  const _AddressScreenView();

  @override
  State<_AddressScreenView> createState() => _AddressScreenViewState();
}

class _AddressScreenViewState extends State<_AddressScreenView> {
  bool _autoDetectTriggered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_autoDetectTriggered) {
      _autoDetectTriggered = true;
      final cubit = context.read<CustomerAddressCubit>();
      if (cubit.state.latitude == null) {
        cubit.detectCurrentLocation();
      }
    }
  }

  void _onContinue(BuildContext context) {
    context.read<CustomerAddressCubit>().submitAddress();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerAddressCubit, CustomerAddressState>(
      listener: (context, state) {
        if (state.status == CustomerAddressStatus.success) {
          context.pushNamed(AppRouter.congratulations);
        } else if (state.status == CustomerAddressStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Something went wrong'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizes.xl),

                // ---- Back button ----
                const BackButtonWidget(),
                const SizedBox(height: AppSizes.xl),

                // ---- Header ----
                Text('Your Location 📍', style: AppTextStyles.h2),
                const SizedBox(height: AppSizes.xl),

                // ---- Map ----
                Expanded(
                  child:
                      BlocBuilder<CustomerAddressCubit, CustomerAddressState>(
                        buildWhen: (prev, curr) =>
                            prev.latitude != curr.latitude ||
                            prev.longitude != curr.longitude ||
                            prev.resolvedAddress != curr.resolvedAddress ||
                            prev.status != curr.status,
                        builder: (context, state) {
                          final cubit = context.read<CustomerAddressCubit>();

                          // Default Value
                          final center = LatLng(
                            state.latitude ?? 11.0515,
                            state.longitude ?? 75.9857,
                          );

                          return Column(
                            children: [
                              Expanded(
                                child: LocationMapPicker(
                                  center: center,
                                  onLocationChanged: (newLatLng) {
                                    cubit.updateLocation(
                                      newLatLng.latitude,
                                      newLatLng.longitude,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: AppSizes.lg),
                              LocationInfoCard(
                                address: state.resolvedAddress,
                                isLoading: state.isLocationLoading,
                                onRecenter: () => cubit.detectCurrentLocation(),
                              ),
                            ],
                          );
                        },
                      ),
                ),

                const SizedBox(height: AppSizes.xl),

                // ---- Continue Button ----
                BlocBuilder<CustomerAddressCubit, CustomerAddressState>(
                  buildWhen: (prev, curr) => prev.status != curr.status,
                  builder: (context, state) {
                    final isLoading =
                        state.status == CustomerAddressStatus.submitting;
                    return CustomButton(
                      text: isLoading ? 'Saving...' : 'Continue',
                      onPressed: isLoading ? null : () => _onContinue(context),
                    );
                  },
                ),
                const SizedBox(height: AppSizes.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
