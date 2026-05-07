import 'package:flutter_bloc/flutter_bloc.dart';
import 'service_detail_state.dart';

class ServiceDetailCubit extends Cubit<ServiceDetailState> {
  ServiceDetailCubit() : super(const ServiceDetailState());

  void selectRating(int? rating) {
    emit(state.copyWith(selectedRating: () => rating));
  }

  void toggleAboutExpanded() {
    emit(state.copyWith(isAboutExpanded: !state.isAboutExpanded));
  }
}
