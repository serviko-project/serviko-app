import '../../domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    required super.id,
    required super.title,
    required super.dateStr,
    required super.amount,
    required super.isCredit,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      dateStr: json['date_str'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      isCredit: json['is_credit'] ?? false,
    );
  }
}
