import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/usecases/get_popular_services_usecase.dart';

part 'popular_services_state.dart';

class PopularServicesCubit extends Cubit<PopularServicesState> {
  final GetPopularServicesUseCase getPopularServicesUseCase;
  final int? limit;

  PopularServicesCubit({required this.getPopularServicesUseCase, this.limit})
    : super(PopularServicesInitial());

  Future<void> fetchPopularServices({String? categoryId}) async {
    emit(PopularServicesLoading());
    final result = await getPopularServicesUseCase(
      GetPopularServicesParams(categoryId: categoryId, limit: limit),
    );
    result.fold(
      (failure) => emit(PopularServicesError(message: failure.message)),
      (services) => emit(PopularServicesLoaded(services: services)),
    );
  }
}
