import 'package:flutter_bloc/flutter_bloc.dart';
import 'review_form_state.dart';

class ReviewFormCubit extends Cubit<ReviewFormState> {
  ReviewFormCubit() : super(const ReviewFormState());

  void updateRating(int rating) {
    emit(state.copyWith(selectedRating: rating));
  }

  void updateComment(String comment) {
    emit(state.copyWith(comment: comment));
  }
}
