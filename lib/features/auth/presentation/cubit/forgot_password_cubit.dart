import 'package:flutter_bloc/flutter_bloc.dart';

// Manages forgot password method selection (0 = SMS, 1 = Email)
class ForgotPasswordCubit extends Cubit<int> {
  ForgotPasswordCubit() : super(0);

  void selectMethod(int index) => emit(index);
}
