import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/entities/provider_profile_entity.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/get_categories_usecase.dart';
import 'package:serviko_app/features/provider/onboarding/domain/usecases/update_provider_services_usecase.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/edit_provider_services_state.dart';

class EditProviderServicesCubit extends Cubit<EditProviderServicesState> {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final UpdateProviderServicesUseCase _updateProviderServicesUseCase;

  EditProviderServicesCubit({
    required GetCategoriesUseCase getCategoriesUseCase,
    required UpdateProviderServicesUseCase updateProviderServicesUseCase,
  }) : _getCategoriesUseCase = getCategoriesUseCase,
       _updateProviderServicesUseCase = updateProviderServicesUseCase,
       super(const EditProviderServicesState());

  Future<void> init(List<ProviderServiceEntity> currentServices) async {
    emit(state.copyWith(status: EditProviderServicesStatus.loading));
    final result = await _getCategoriesUseCase(NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: EditProviderServicesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (categories) {
        final selectedServices = <String>{};
        final categoryPrices = <String, double>{};
        final activeCategoryIds = categories.map((c) => c.id).toSet();

        for (final service in currentServices) {
          if (activeCategoryIds.contains(service.categoryId)) {
            selectedServices.add(service.categoryId);
            if (service.basePricePerHour != null) {
              categoryPrices[service.categoryId] = service.basePricePerHour!;
            }
          }
        }

        emit(
          state.copyWith(
            status: EditProviderServicesStatus.loaded,
            categories: categories,
            selectedServices: selectedServices,
            categoryPrices: categoryPrices,
          ),
        );
      },
    );
  }

  void toggleService(String categoryId) {
    if (state.status == EditProviderServicesStatus.loaded ||
        state.status == EditProviderServicesStatus.error ||
        state.status == EditProviderServicesStatus.updating) {
      final selectedServices = Set<String>.from(state.selectedServices);
      final categoryPrices = Map<String, double>.from(state.categoryPrices);

      if (selectedServices.contains(categoryId)) {
        selectedServices.remove(categoryId);
        categoryPrices.remove(categoryId);
      } else {
        selectedServices.add(categoryId);
        categoryPrices[categoryId] = 0.0;
      }

      emit(
        state.copyWith(
          selectedServices: selectedServices,
          categoryPrices: categoryPrices,
        ),
      );
    }
  }

  void setPrice(String categoryId, double price) {
    if (state.status == EditProviderServicesStatus.loaded ||
        state.status == EditProviderServicesStatus.error ||
        state.status == EditProviderServicesStatus.updating) {
      final categoryPrices = Map<String, double>.from(state.categoryPrices);
      categoryPrices[categoryId] = price;
      emit(state.copyWith(categoryPrices: categoryPrices));
    }
  }

  Future<void> saveServices() async {
    if (state.selectedServices.isEmpty) {
      emit(
        state.copyWith(
          status: EditProviderServicesStatus.error,
          errorMessage: 'Please select at least one service',
        ),
      );
      return;
    }

    // Check if any selected service has missing/invalid price
    bool hasInvalidPrice = false;
    for (final serviceId in state.selectedServices) {
      final price = state.categoryPrices[serviceId] ?? 0.0;
      if (price <= 0.0) {
        hasInvalidPrice = true;
        break;
      }
    }

    if (hasInvalidPrice) {
      emit(state.copyWith(showPriceValidation: true));
      return;
    }

    emit(
      state.copyWith(
        status: EditProviderServicesStatus.updating,
        showPriceValidation: false,
      ),
    );

    final servicesPayload = state.selectedServices.map((categoryId) {
      return {
        'category_id': categoryId,
        'base_price_per_hour': state.categoryPrices[categoryId] ?? 0.0,
      };
    }).toList();

    final result = await _updateProviderServicesUseCase(
      UpdateProviderServicesParams(services: servicesPayload),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: EditProviderServicesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: EditProviderServicesStatus.success,
          successMessage: 'Services updated successfully',
        ),
      ),
    );
  }

  void clearError() => emit(
    state.copyWith(
      status: EditProviderServicesStatus.loaded,
      clearError: true,
      showPriceValidation: false,
    ),
  );
  void clearSuccess() => emit(state.copyWith(clearSuccess: true));
}
