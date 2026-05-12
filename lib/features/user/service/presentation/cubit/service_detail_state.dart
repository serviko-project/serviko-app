part of 'service_detail_cubit.dart';

abstract class ServiceDetailState extends Equatable {
  final bool isAboutExpanded;
  final int selectedRating;
  final ProviderServiceEntity? selectedService;
  final String? address;

  const ServiceDetailState({
    this.isAboutExpanded = false,
    this.selectedRating = 0,
    this.selectedService,
    this.address,
  });

  @override
  List<Object?> get props => [
    isAboutExpanded,
    selectedRating,
    selectedService,
    address,
  ];
}

class ServiceDetailInitial extends ServiceDetailState {
  const ServiceDetailInitial() : super();
}

class ServiceDetailLoading extends ServiceDetailState {
  const ServiceDetailLoading() : super();
}

class ServiceDetailLoaded extends ServiceDetailState {
  final ServiceEntity service;

  const ServiceDetailLoaded({
    required this.service,
    super.isAboutExpanded,
    super.selectedRating,
    super.selectedService,
    super.address,
  });

  @override
  List<Object?> get props => [
    service,
    isAboutExpanded,
    selectedRating,
    selectedService,
    address,
  ];

  ServiceDetailLoaded copyWith({
    ServiceEntity? service,
    bool? isAboutExpanded,
    int? selectedRating,
    ProviderServiceEntity? selectedService,
    String? address,
  }) {
    return ServiceDetailLoaded(
      service: service ?? this.service,
      isAboutExpanded: isAboutExpanded ?? this.isAboutExpanded,
      selectedRating: selectedRating ?? this.selectedRating,
      selectedService: selectedService ?? this.selectedService,
      address: address ?? this.address,
    );
  }
}

class ServiceDetailError extends ServiceDetailState {
  final String message;

  const ServiceDetailError({required this.message}) : super();

  @override
  List<Object?> get props => [
    message,
    isAboutExpanded,
    selectedRating,
    address,
  ];
}
