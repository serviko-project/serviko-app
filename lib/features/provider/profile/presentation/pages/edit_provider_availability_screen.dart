import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/features/provider/onboarding/domain/entities/provider_profile_entity.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/edit_provider_availability_cubit.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/provider_profile_cubit.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/provider_profile_state.dart';
import 'package:serviko_app/features/provider/profile/presentation/widgets/edit_provider_availability_view.dart';
import 'package:serviko_app/injection_container.dart';

class EditProviderAvailabilityScreen extends StatelessWidget {
  const EditProviderAvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final profileState = context.read<ProviderProfileCubit>().state;
        final currentAvailability = profileState is ProviderProfileLoaded
            ? profileState.profile.availability
            : const <ProviderAvailabilityEntity>[];
        return EditProviderAvailabilityCubit(
          updateProviderAvailabilityUseCase:
              InjectionContainer.instance.updateProviderAvailabilityUseCase,
        )..init(currentAvailability);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CustomAppBar(title: 'Timing & Availability'),
        body: SafeArea(
          child: BlocBuilder<ProviderProfileCubit, ProviderProfileState>(
            builder: (context, profileState) {
              if (profileState is ProviderProfileLoading ||
                  profileState is ProviderProfileInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              return BlocListener<ProviderProfileCubit, ProviderProfileState>(
                listener: (context, state) {
                  if (state is ProviderProfileLoaded) {
                    context.read<EditProviderAvailabilityCubit>().init(
                      state.profile.availability,
                    );
                  }
                },
                child: const EditProviderAvailabilityView(),
              );
            },
          ),
        ),
      ),
    );
  }
}
