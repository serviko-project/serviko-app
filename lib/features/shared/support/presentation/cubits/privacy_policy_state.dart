import 'package:equatable/equatable.dart';
import 'package:serviko_app/features/shared/support/domain/entities/privacy_policy_item.dart';

// States for Privacy Policy Cubit
sealed class PrivacyPolicyState extends Equatable {
  const PrivacyPolicyState();

  @override
  List<Object?> get props => [];
}

class PrivacyPolicyInitial extends PrivacyPolicyState {
  const PrivacyPolicyInitial();
}

class PrivacyPolicyLoading extends PrivacyPolicyState {
  const PrivacyPolicyLoading();
}

class PrivacyPolicyLoaded extends PrivacyPolicyState {
  final PrivacyPolicyItem policy;

  const PrivacyPolicyLoaded(this.policy);

  @override
  List<Object?> get props => [policy];
}

class PrivacyPolicyError extends PrivacyPolicyState {
  final String message;

  const PrivacyPolicyError(this.message);

  @override
  List<Object?> get props => [message];
}
