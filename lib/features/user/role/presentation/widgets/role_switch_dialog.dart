import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/features/user/role/domain/enums.dart';
import 'package:serviko_app/features/user/role/presentation/cubit/role_cubit.dart';
import 'package:serviko_app/features/user/role/presentation/cubit/role_state.dart';
import 'package:serviko_app/features/user/role/presentation/widgets/role_switch_action_button.dart';
import 'package:serviko_app/features/user/role/presentation/widgets/role_switch_mode_tile.dart';

// Bottom sheet dialog for switching between customer and provider modes
class RoleSwitchDialog extends StatelessWidget {
  const RoleSwitchDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<RoleCubit>(),
        child: const RoleSwitchDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleCubit, RoleState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              HugeIcon(
                icon: HugeIcons.strokeRoundedSolidLine01,
                color: AppColors.border,
                size: 35,
              ),
              const SizedBox(height: 15),

              // Header
              Text(
                'Switch Mode',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Choose how you want to use Serviko',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 30),

              // Customer tile
              RoleSwitchModeTile(
                icon: HugeIcons.strokeRoundedUser03,
                title: 'Customer',
                subtitle: 'Find and book services',
                isSelected: state.isCustomer,
                onTap: () => _switchTo(context, UserRole.customer),
              ),
              const SizedBox(height: 15),

              // Provider tile
              RoleSwitchModeTile(
                icon: HugeIcons.strokeRoundedBriefcase01,
                title: 'Service Provider',
                subtitle: _providerSubtitle(state.providerStatus),
                isSelected: state.isProvider,
                isEnabled: state.canSwitchToProvider,
                statusBadge: _buildStatusBadge(state.providerStatus),
                onTap: state.canSwitchToProvider
                    ? () => _switchTo(context, UserRole.provider)
                    : null,
              ),

              // CTA based on provider status
              if (state.providerStatus == ProviderStatus.none) ...[
                const SizedBox(height: 25),
                ActionButton(
                  label: 'Become a Service Provider',
                  icon: HugeIcons.strokeRoundedAdd01,
                  onTap: () {
                    Navigator.pop(context);
                    context.pushNamed(AppRouter.providerOnboarding);
                  },
                ),
              ] else if (state.providerStatus == ProviderStatus.pending ||
                  state.providerStatus == ProviderStatus.rejected) ...[
                const SizedBox(height: 25),
                ActionButton(
                  label: 'Check Application Status',
                  icon: HugeIcons.strokeRoundedSearch01,
                  onTap: () {
                    Navigator.pop(context);
                    context.pushNamed(AppRouter.providerApplicationStatus);
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // Handle role switching and navigation
  void _switchTo(BuildContext context, UserRole role) {
    final cubit = context.read<RoleCubit>();
    if (role == UserRole.provider) {
      cubit.switchToProvider();
      Navigator.pop(context);
      context.goNamed(AppRouter.providerDashboard);
    } else {
      cubit.switchToCustomer();
      Navigator.pop(context);
      context.goNamed(AppRouter.home);
    }
  }

  // Get subtitle text based on provider status
  String _providerSubtitle(ProviderStatus status) {
    return switch (status) {
      ProviderStatus.none => 'Start offering your services',
      ProviderStatus.pending => 'Application is under review',
      ProviderStatus.approved => 'Manage jobs and earnings',
      ProviderStatus.rejected => 'Application was not approved',
      ProviderStatus.blocked => 'Account is currently blocked',
    };
  }

  // Build status badge widget based on provider status
  Widget? _buildStatusBadge(ProviderStatus status) {
    if (status == ProviderStatus.none || status == ProviderStatus.approved) {
      return null;
    }

    final (label, color) = switch (status) {
      ProviderStatus.pending => ('Pending', AppColors.warning),
      ProviderStatus.rejected => ('Rejected', AppColors.error),
      ProviderStatus.blocked => ('Blocked', AppColors.error),
      _ => ('', Colors.transparent),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
