import 'package:flutter_bloc/flutter_bloc.dart';

class EditPromoFormState {
  final DateTime? expiresAt;

  const EditPromoFormState({this.expiresAt});

  EditPromoFormState copyWith({
    DateTime? expiresAt,
    bool clearExpiresAt = false,
  }) {
    return EditPromoFormState(
      expiresAt: clearExpiresAt ? null : (expiresAt ?? this.expiresAt),
    );
  }
}

class EditPromoFormCubit extends Cubit<EditPromoFormState> {
  EditPromoFormCubit({DateTime? initialExpiresAt})
    : super(EditPromoFormState(expiresAt: initialExpiresAt));

  void setExpiresAt(DateTime? date) {
    emit(state.copyWith(expiresAt: date, clearExpiresAt: date == null));
  }
}
