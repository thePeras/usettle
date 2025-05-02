import 'package:flutter/cupertino.dart';
import 'package:usettle/view/tabs/tab_screen.dart';

class TabsPage extends StatelessWidget {
  const TabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Transaction> transactions = [
      Transaction(time: DateTime.now(), description: "Jantar Natal", quantity: 120),
      Transaction(time: DateTime.now(), description: "Almoço", quantity: 15),
      Transaction(time: DateTime.now(), description: "Snack", quantity: -12),
      Transaction(time: DateTime.now(), description: "Compras", quantity: 100),
      Transaction(time: DateTime.now(), description: "Aluguel", quantity: -300),
      Transaction(time: DateTime.now(), description: "Netflix", quantity: 9),
    ];
    Tab tab = Tab(
        name: "Rubem Neto",
        transactions: transactions);
    return TabScreen(tab: tab);
  }
}
