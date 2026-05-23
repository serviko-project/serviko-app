import 'package:equatable/equatable.dart';

class ReviewFormState extends Equatable {
  final int selectedRating;
  final String comment;

  const ReviewFormState({this.selectedRating = 0, this.comment = ''});

  bool get isValid => selectedRating > 0 && comment.trim().isNotEmpty;

  int get commentLength => comment.length;

  ReviewFormState copyWith({int? selectedRating, String? comment}) {
    return ReviewFormState(
      selectedRating: selectedRating ?? this.selectedRating,
      comment: comment ?? this.comment,
    );
  }

  @override
  List<Object?> get props => [selectedRating, comment];
}
