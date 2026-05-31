import 'package:equatable/equatable.dart';

enum EditProviderServiceAreaStatus { initial, loading, saving, success, error }

class EditProviderServiceAreaState extends Equatable {
  final EditProviderServiceAreaStatus status;
  final double? latitude;
  final double? longitude;
  final double coverageRadius;
  final String? resolvedAddress;
  final bool isLocationLoading;
  final String? errorMessage;

  const EditProviderServiceAreaState({
    this.status = EditProviderServiceAreaStatus.initial,
    this.latitude,
    this.longitude,
    this.coverageRadius = 15.0,
    this.resolvedAddress,
    this.isLocationLoading = false,
    this.errorMessage,
  });

  EditProviderServiceAreaState copyWith({
    EditProviderServiceAreaStatus? status,
    double? latitude,
    double? longitude,
    double? coverageRadius,
    String? resolvedAddress,
    bool? isLocationLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EditProviderServiceAreaState(
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      coverageRadius: coverageRadius ?? this.coverageRadius,
      resolvedAddress: resolvedAddress ?? this.resolvedAddress,
      isLocationLoading: isLocationLoading ?? this.isLocationLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    latitude,
    longitude,
    coverageRadius,
    resolvedAddress,
    isLocationLoading,
    errorMessage,
  ];
}
