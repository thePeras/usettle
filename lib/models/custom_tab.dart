import 'dart:ui';

import 'transaction.dart';

class CustomTab {
  final String name;
  final Image? imageUrl;
  late double total = 0;
  bool owes = false;
  late final List<Transaction> transactions;

  CustomTab({required this.name, required this.transactions, this.imageUrl}) {
    total = transactions.map((e) => e.quantity).reduce((v, e) => v + e);
    owes = total < 0;
  }

  void updateTransactions(List<Transaction> transactions) {
    this.transactions = transactions;
    total = transactions.map((e) => e.quantity).reduce((v, e) => v + e);
    owes = total < 0;
  }
}
