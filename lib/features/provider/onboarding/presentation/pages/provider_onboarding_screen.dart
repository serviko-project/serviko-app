import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/injection_container.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_cubit.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/views/availability_view.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/views/documents_view.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/views/personal_details_view.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/views/service_area_view.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/views/services_view.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/views/welcome_view.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/features/user/role/presentation/cubit/role_cubit.dart';
import 'package:serviko_app/features/user/role/domain/enums.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/provider_onboarding_app_bar.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/provider_onboarding_bottom_bar.dart';

class ProviderOnboardingScreen extends StatelessWidget {
  final bool isReapplication;

  const ProviderOnboardingScreen({super.key, this.isReapplication = false});

  @override
  Widget build(BuildContext context) {
    final di = InjectionContainer.instance;

    return BlocProvider(
      create: (_) => ProviderOnboardingCubit(
        submitApplicationUseCase: di.submitApplicationUseCase,
        getMyProviderProfileUseCase: di.getMyProviderProfileUseCase,
        uploadDocumentUseCase: di.uploadDocumentUseCase,
        deleteDocumentUseCase: di.deleteDocumentUseCase,
        reapplyUseCase: di.reapplyUseCase,
        getCategoriesUseCase: di.getCategoriesUseCase,
        getMyProfileUseCase: di.getMyProfileUseCase,
        isReapplication: isReapplication,
        submitCategoryRequestUseCase: di.submitCategoryRequestUseCase,
      ),
      child: const _ProviderOnboardingView(),
    );
  }
}

class _ProviderOnboardingView extends StatelessWidget {
  const _ProviderOnboardingView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProviderOnboardingCubit, ProviderOnboardingState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.status == ProviderOnboardingStatus.success) {
          context.read<RoleCubit>().updateProviderStatus(
            ProviderStatus.pending,
          );
          context.goNamed(AppRouter.providerApplicationStatus);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Provider application submitted successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
        }

        if (state.status == ProviderOnboardingStatus.alreadySubmitted) {
          context.goNamed(AppRouter.providerApplicationStatus);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You already have a pending application.'),
              backgroundColor: AppColors.primary,
            ),
          );
        }

        if (state.status == ProviderOnboardingStatus.error &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.error,
            ),
          );
          context.read<ProviderOnboardingCubit>().clearError();
        }
      },
      child: PopScope(
        canPop: context.select(
          (ProviderOnboardingCubit cubit) => cubit.state.currentStep == 0,
        ),
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          final cubit = context.read<ProviderOnboardingCubit>();
          if (cubit.state.currentStep > 0) cubit.previousStep();
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: const ProviderOnboardingAppBar(),
          body: SafeArea(
            child:
                BlocBuilder<ProviderOnboardingCubit, ProviderOnboardingState>(
                  buildWhen: (prev, curr) => prev.status != curr.status,
                  builder: (context, state) {
                    if (state.status == ProviderOnboardingStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return PageView(
                      controller: context
                          .read<ProviderOnboardingCubit>()
                          .pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        WelcomeView(),
                        PersonalDetailsView(),
                        ServicesView(),
                        AvailabilityView(),
                        DocumentsView(),
                        ServiceAreaView(),
                      ],
                    );
                  },
                ),
          ),
          bottomNavigationBar: const ProviderOnboardingBottomBar(),
        ),
      ),
    );
  }
}
