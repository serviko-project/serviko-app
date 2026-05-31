import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_assets.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/features/user/auth/presentation/cubit/google_sign_in_cubit.dart';
import 'package:serviko_app/injection_container.dart';

// Social Login Buttons
class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GoogleSignInCubit(
        googleSignInUseCase: InjectionContainer.instance.googleSignInUseCase,
      ),
      child: const _SocialLoginView(),
    );
  }
}

class _SocialLoginView extends StatelessWidget {
  const _SocialLoginView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<GoogleSignInCubit, GoogleSignInState>(
      listenWhen: (prev, curr) =>
          prev.error != curr.error || prev.user != curr.user,
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: AppColors.error,
              ),
            );
          context.read<GoogleSignInCubit>().clearError();
        }
      },
      child: BlocBuilder<GoogleSignInCubit, GoogleSignInState>(
        buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
        builder: (context, state) {
          return CustomButton(
            text: 'Continue with Google',
            fontSize: 13,
            isOutlined: true,
            borderColor: AppColors.border,
            textColor: AppColors.textPrimary,
            isLoading: state.isLoading,
            icon: Image.asset(AppAssets.googleIcon, width: 45, height: 45),
            onPressed: () {
              context.read<GoogleSignInCubit>().signInWithGoogle();
            },
          );
        },
      ),
    );
  }
}
