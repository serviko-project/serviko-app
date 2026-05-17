import 'package:flutter_bloc/flutter_bloc.dart';

class PopularServicesFilterCubit extends Cubit<String?> {
  PopularServicesFilterCubit() : super(null);

  void updateFilter(String? categoryId) => emit(categoryId);
}
