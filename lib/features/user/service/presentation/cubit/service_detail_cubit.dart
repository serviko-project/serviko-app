import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/features/shared/location/data/services/location_service.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/usecases/get_service_detail_usecase.dart';

part 'service_detail_state.dart';

class ServiceDetailCubit extends Cubit<ServiceDetailState> {
  final GetServiceDetailUseCase getServiceDetailUseCase;
  final LocationService locationService;

  ServiceDetailCubit({
    required this.getServiceDetailUseCase,
    required this.locationService,
  }) : super(const ServiceDetailInitial());

  Future<void> fetchServiceDetail(String id) async {
    emit(const ServiceDetailLoading());
    final result = await getServiceDetailUseCase(
      GetServiceDetailParams(id: id),
    );
    result.fold(
      (failure) => emit(ServiceDetailError(message: failure.message)),
      (service) async {
        String? address;
        if (service.latitude != null && service.longitude != null) {
          address = await locationService.getAddressFromCoordinates(
            service.latitude!,
            service.longitude!,
          );
        } else {
          address = 'Location not available';
        }

        emit(
          ServiceDetailLoaded(
            service: service,
            address: address,
            selectedService: ProviderServiceEntity(
              categoryId: service.categoryId,
              categoryName: service.categoryName,
              basePricePerHour: service.basePricePerHour,
            ),
          ),
        );
      },
    );
  }

  void toggleAboutExpanded() {
    if (state is ServiceDetailLoaded) {
      final currentState = state as ServiceDetailLoaded;
      emit(
        currentState.copyWith(isAboutExpanded: !currentState.isAboutExpanded),
      );
    }
  }

  void selectRating(int rating) {
    if (state is ServiceDetailLoaded) {
      final currentState = state as ServiceDetailLoaded;
      emit(currentState.copyWith(selectedRating: rating));
    }
  }

  void selectService(ProviderServiceEntity service) {
    if (state is ServiceDetailLoaded) {
      final currentState = state as ServiceDetailLoaded;
      emit(currentState.copyWith(selectedService: service));
    }
  }
}
