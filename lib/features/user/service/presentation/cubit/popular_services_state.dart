part of 'popular_services_cubit.dart';

abstract class PopularServicesState extends Equatable {
  const PopularServicesState();

  @override
  List<Object> get props => [];
}

class PopularServicesInitial extends PopularServicesState {}

class PopularServicesLoading extends PopularServicesState {}

class PopularServicesLoaded extends PopularServicesState {
  final List<ServiceEntity> services;

  const PopularServicesLoaded({required this.services});

  @override
  List<Object> get props => [services];
}

class PopularServicesError extends PopularServicesState {
  final String message;

  const PopularServicesError({required this.message});

  @override
  List<Object> get props => [message];
}
