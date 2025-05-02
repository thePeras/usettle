class Transaction {
  final DateTime time;
  final String description;
  final double quantity;

  const Transaction({
    required this.time,
    required this.description,
    required this.quantity,
  });
}
