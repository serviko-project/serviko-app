import 'package:equatable/equatable.dart';

class FaqItem extends Equatable {
  final String id;
  final String question;
  final String answer;
  final String category;
  final bool isActive;

  const FaqItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, question, answer, category, isActive];
}
