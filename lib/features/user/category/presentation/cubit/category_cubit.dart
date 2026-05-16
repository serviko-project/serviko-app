import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/get_categories_usecase.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetCategoriesUseCase getCategoriesUseCase;

  CategoryCubit({required this.getCategoriesUseCase})
    : super(CategoryInitial());

  Future<void> fetchCategories() async {
    emit(CategoryLoading());
    final result = await getCategoriesUseCase(NoParams());
    result.fold(
      (failure) => emit(CategoryError(message: failure.message)),
      (categories) => emit(CategoryLoaded(categories: categories)),
    );
  }
}
