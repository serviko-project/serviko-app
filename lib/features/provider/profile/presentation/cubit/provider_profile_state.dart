import 'package:equatable/equatable.dart';
import 'package:serviko_app/features/provider/onboarding/domain/entities/provider_profile_entity.dart';

abstract class ProviderProfileState extends Equatable {
  const ProviderProfileState();

  @override
  List<Object> get props => [];
}

class ProviderProfileInitial extends ProviderProfileState {}

class ProviderProfileLoading extends ProviderProfileState {}

class ProviderProfileLoaded extends ProviderProfileState {
  final ProviderProfileEntity profile;

  const ProviderProfileLoaded(this.profile);

  @override
  List<Object> get props => [profile];
}

class ProviderProfileError extends ProviderProfileState {
  final String message;

  const ProviderProfileError(this.message);

  @override
  List<Object> get props => [message];
}
