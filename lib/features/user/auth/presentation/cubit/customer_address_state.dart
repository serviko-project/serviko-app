import 'package:equatable/equatable.dart';

enum CustomerAddressStatus { initial, locLoading, submitting, success, error }

class CustomerAddressState extends Equatable {
  final CustomerAddressStatus status;
  final double? latitude;
  final double? longitude;
  final String resolvedAddress;
  final String? errorMessage;

  const CustomerAddressState({
    this.status = CustomerAddressStatus.initial,
    this.latitude,
    this.longitude,
    this.resolvedAddress = '',
    this.errorMessage,
  });

  bool get isLocationLoading => status == CustomerAddressStatus.locLoading;

  CustomerAddressState copyWith({
    CustomerAddressStatus? status,
    double? latitude,
    double? longitude,
    String? resolvedAddress,
    String? errorMessage,
  }) {
    return CustomerAddressState(
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      resolvedAddress: resolvedAddress ?? this.resolvedAddress,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    latitude,
    longitude,
    resolvedAddress,
    errorMessage,
  ];
}
