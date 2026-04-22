import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/features/auth/presentation/bloc/auth_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: EdgeInsets.all(AppSizes.screenPadding),
        child: Center(
          child: CustomButton(
            text: "Log Out",
            onPressed: () {
              context.read<AuthBloc>().add(AuthSignOutRequested());
            },
          ),
        ),
      ),
    );
  }
}
