import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/widgets/role_switch_tile.dart';
import 'package:serviko_app/features/user/role/domain/enums.dart';
import 'package:serviko_app/features/user/role/presentation/cubit/role_cubit.dart';
import 'package:serviko_app/features/user/role/presentation/cubit/role_state.dart';

// Profile Screen of User
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            const RoleSwitchTile(),
            const SizedBox(height: 16),

            // Status Display for Testing
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warning.withAlpha(15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.warning.withAlpha(50)),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ProviderStatus.values.map((status) {
                  return _StatusChip(status: status);
                }).toList(),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

// Status Chip for displaying and changing provider status
class _StatusChip extends StatelessWidget {
  final ProviderStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleCubit, RoleState>(
      builder: (context, state) {
        final isActive = state.providerStatus == status;
        return FilterChip(
          label: Text(status.name),
          selected: isActive,
          onSelected: (_) {
            context.read<RoleCubit>().updateProviderStatus(status);
          },
          selectedColor: AppColors.primary.withAlpha(30),
          checkmarkColor: AppColors.primary,
        );
      },
    );
  }
}
