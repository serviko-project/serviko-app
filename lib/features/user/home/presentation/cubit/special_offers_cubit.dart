import 'package:flutter_bloc/flutter_bloc.dart';

class SpecialOffersCubit extends Cubit<int> {
  SpecialOffersCubit() : super(0);

  void updatePage(int index) => emit(index);
}
