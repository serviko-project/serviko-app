import 'package:flutter_bloc/flutter_bloc.dart';

class PopularServicesFilterCubit extends Cubit<String> {
  PopularServicesFilterCubit() : super('All');

  void updateFilter(String newFilter) => emit(newFilter);
}
