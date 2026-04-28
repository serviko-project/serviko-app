import 'package:equatable/equatable.dart';
import 'package:serviko_app/features/user/role/domain/enums.dart';

// Manages role and provider application status
class RoleState extends Equatable {
  final UserRole activeRole;
  final ProviderStatus providerStatus;

  const RoleState({required this.activeRole, required this.providerStatus});

  const RoleState.initial()
    : activeRole = UserRole.customer,
      providerStatus = ProviderStatus.none;

  RoleState copyWith({UserRole? activeRole, ProviderStatus? providerStatus}) {
    return RoleState(
      activeRole: activeRole ?? this.activeRole,
      providerStatus: providerStatus ?? this.providerStatus,
    );
  }

  bool get isProvider => activeRole == UserRole.provider;
  bool get isCustomer => activeRole == UserRole.customer;
  bool get canSwitchToProvider => providerStatus == ProviderStatus.approved;

  @override
  List<Object?> get props => [activeRole, providerStatus];
}
