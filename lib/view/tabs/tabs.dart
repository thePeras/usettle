import 'package:flutter/cupertino.dart';
import 'package:usettle/view/common/pages/general.dart';
import 'package:usettle/view/tabs/tab_screen.dart';

class TabsPage extends StatelessWidget{
  const TabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Transaction> transactions = [
      Transaction(time: "now", description: "test", quantity: -12),
      Transaction(time: "now", description: "test", quantity: -12),
      Transaction(time: "now", description: "test", quantity: 12),
      Transaction(time: "now", description: "test", quantity: -12),
      Transaction(time: "now", description: "test", quantity: 12),
      Transaction(time: "now", description: "test", quantity: 12)
    ];
    Tab tab = Tab(
        name: "Rubem Neto",
        transactions: transactions);
    return TabScreen(tab: tab);
  }
}
