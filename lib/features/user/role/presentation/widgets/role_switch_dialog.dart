import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/features/user/role/domain/enums.dart';
import 'package:serviko_app/features/user/role/presentation/cubit/role_cubit.dart';
import 'package:serviko_app/features/user/role/presentation/cubit/role_state.dart';

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
              _ModeTile(
                icon: HugeIcons.strokeRoundedUser03,
                title: 'Customer',
                subtitle: 'Find and book services',
                isSelected: state.isCustomer,
                onTap: () => _switchTo(context, UserRole.customer),
              ),
              const SizedBox(height: 15),

              // Provider tile
              _ModeTile(
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

              // CTA for unapplied or rejected providers
              if (state.providerStatus == ProviderStatus.none ||
                  state.providerStatus == ProviderStatus.rejected) ...[
                const SizedBox(height: 25),
                _ActionButton(
                  label: state.providerStatus == ProviderStatus.none
                      ? 'Become a Service Provider'
                      : 'Re-apply as Provider',
                  icon: state.providerStatus == ProviderStatus.none
                      ? HugeIcons.strokeRoundedAdd01
                      : HugeIcons.strokeRoundedRefresh03,
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to provider onboarding
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

// Mode selection tile
class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    this.isEnabled = true,
    this.statusBadge,
    this.onTap,
  });

  final dynamic icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final bool isEnabled;
  final Widget? statusBadge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tileColor = isSelected
        ? AppColors.primary.withAlpha(10)
        : AppColors.surface;
    final borderColor = isSelected
        ? AppColors.primary.withAlpha(80)
        : AppColors.border.withAlpha(120);
    final iconBg = isSelected
        ? AppColors.primary.withAlpha(20)
        : AppColors.border.withAlpha(60);
    final iconColor = isSelected ? AppColors.primary : AppColors.textHint;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: isEnabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: HugeIcon(
                    icon: icon,
                    color: iconColor,
                    size: 22,
                    strokeWidth: 1.8,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Text + badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.5,
                            color: isEnabled
                                ? AppColors.textPrimary
                                : AppColors.textHint,
                            letterSpacing: 0.2,
                          ),
                        ),
                        if (statusBadge != null) ...[
                          const SizedBox(width: 10),
                          statusBadge!,
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isEnabled
                            ? AppColors.textSecondary
                            : AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),

              // Check indicator
              if (isSelected)
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                  color: AppColors.primary,
                  size: 25,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// CTA button for becoming or re-applying as provider
class _ActionButton extends StatelessWidget {
  final String label;
  final dynamic icon;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(width: 2, color: AppColors.primary.withAlpha(60)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HugeIcon(
              icon: icon,
              color: AppColors.primary,
              size: 18,
              strokeWidth: 2,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
