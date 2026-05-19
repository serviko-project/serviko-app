import 'package:serviko_app/features/shared/support/domain/entities/faq_item.dart';

class FaqModel extends FaqItem {
  const FaqModel({
    required super.id,
    required super.question,
    required super.answer,
    required super.category,
    required super.isActive,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'] as String? ?? '',
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      category: json['category'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'category': category,
      'is_active': isActive,
    };
  }
}
