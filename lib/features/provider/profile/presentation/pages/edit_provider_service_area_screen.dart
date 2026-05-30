import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/edit_provider_service_area_cubit.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/provider_profile_cubit.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/provider_profile_state.dart';
import 'package:serviko_app/features/provider/profile/presentation/widgets/edit_provider_service_area_view.dart';
import 'package:serviko_app/injection_container.dart';

class EditProviderServiceAreaScreen extends StatelessWidget {
  const EditProviderServiceAreaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final profileState = context.read<ProviderProfileCubit>().state;
        double? initialLat;
        double? initialLng;
        double initialRadius = 15.0;

        if (profileState is ProviderProfileLoaded) {
          initialLat = profileState.profile.latitude;
          initialLng = profileState.profile.longitude;
          initialRadius = profileState.profile.coverageRadiusKm ?? 15.0;
        }

        return EditProviderServiceAreaCubit(
          updateProviderDetailsUseCase:
              InjectionContainer.instance.updateProviderDetailsUseCase,
        )..init(
          latitude: initialLat,
          longitude: initialLng,
          coverageRadius: initialRadius,
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CustomAppBar(title: 'Service Area'),
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
                    context.read<EditProviderServiceAreaCubit>().init(
                      latitude: state.profile.latitude,
                      longitude: state.profile.longitude,
                      coverageRadius: state.profile.coverageRadiusKm ?? 15.0,
                    );
                  }
                },
                child: const EditProviderServiceAreaView(),
              );
            },
          ),
        ),
      ),
    );
  }
}
