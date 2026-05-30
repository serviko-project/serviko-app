import 'package:equatable/equatable.dart';
import 'package:serviko_app/features/provider/onboarding/domain/entities/category_entity.dart';

enum EditProviderServicesStatus {
  initial,
  loading,
  loaded,
  updating,
  success,
  error,
}

class EditProviderServicesState extends Equatable {
  final EditProviderServicesStatus status;
  final List<CategoryEntity> categories;
  final Set<String> selectedServices;
  final Map<String, double> categoryPrices;
  final bool showPriceValidation;
  final String? errorMessage;
  final String? successMessage;

  const EditProviderServicesState({
    this.status = EditProviderServicesStatus.initial,
    this.categories = const [],
    this.selectedServices = const {},
    this.categoryPrices = const {},
    this.showPriceValidation = false,
    this.errorMessage,
    this.successMessage,
  });

  EditProviderServicesState copyWith({
    EditProviderServicesStatus? status,
    List<CategoryEntity>? categories,
    Set<String>? selectedServices,
    Map<String, double>? categoryPrices,
    bool? showPriceValidation,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return EditProviderServicesState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      selectedServices: selectedServices ?? this.selectedServices,
      categoryPrices: categoryPrices ?? this.categoryPrices,
      showPriceValidation: showPriceValidation ?? this.showPriceValidation,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    categories,
    selectedServices,
    categoryPrices,
    showPriceValidation,
    errorMessage,
    successMessage,
  ];
}
