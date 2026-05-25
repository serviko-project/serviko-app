class TransactionEntity {
  final String id;
  final String title;
  final String dateStr;
  final double amount;
  final bool isCredit;

  TransactionEntity({
    required this.id,
    required this.title,
    required this.dateStr,
    required this.amount,
    required this.isCredit,
  });
}
