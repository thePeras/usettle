import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:usettle/view/common/pages/general.dart';
import 'package:usettle/view/tabs/tab_list.dart';
import 'package:usettle/view/tabs/tab_screen.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({super.key});


  @override
  State<StatefulWidget> createState() => _TabsPageState();
}

class _TabsPageState extends GeneralPageViewState<TabsPage>{
  List<Transaction> generateTransactions() {
    final now = DateTime.now();
    final random = Random();
    final pastDays = 30;

    return List.generate(20, (index) {
      final dayOffset = random.nextInt(pastDays);
      final hourOffset = random.nextInt(24);
      final minuteOffset = random.nextInt(60);
      final secondOffset = random.nextInt(60);
      final isPositive = random.nextBool();
      final quantity = (random.nextDouble() * 200 * (isPositive ? 1 : -1)).toStringAsFixed(2);

      final descriptions = [
        "Supermercado Continente",
        "Almoço com amigos",
        "Conta de eletricidade",
        "Renda do apartamento",
        "Bilhetes de cinema",
        "Livro novo",
        "Gasolina",
        "Café da manhã",
        "Transporte público",
        "Consulta médica",
        "Farmácia",
        "Roupa nova",
        "Corte de cabelo",
        "Doação para caridade",
        "Curso online",
        "Assinatura de streaming",
        "Jantar de aniversário",
        "Pequeno almoço",
        "Reparação do carro",
        "Viagem de fim de semana",
      ];

      return Transaction(
        time: now.subtract(Duration(days: dayOffset, hours: hourOffset, minutes: minuteOffset, seconds: secondOffset)),
        description: descriptions[index % descriptions.length],
        quantity: double.parse(quantity),
      );
    });
  }

  List<String> generateNames({int count = 20}) {
    final random = Random();
    const firstNames = [
      "Maria", "João", "Ana", "Pedro", "Sofia", "Miguel", "Beatriz", "Ricardo",
      "Carolina", "Tiago", "Inês", "André", "Mariana", "Daniel", "Laura", "Rui",
      "Francisca", "Manuel", "Alice", "Vasco"
    ];
    const lastNames = [
      "Silva", "Santos", "Ferreira", "Pereira", "Oliveira", "Costa", "Rodrigues",
      "Martins", "Alves", "Teixeira", "Carvalho", "Gomes", "Pinto", "Mendes",
      "Sousa", "Nunes", "Moreira", "Vieira", "Marques", "Machado"
    ];
    final generatedNames = <String>[];

    while (generatedNames.length < count) {
      final firstName = firstNames[random.nextInt(firstNames.length)];
      final lastName = lastNames[random.nextInt(lastNames.length)];
      final fullName = "$firstName $lastName";
      if (!generatedNames.contains(fullName)) {
        generatedNames.add(fullName);
      }
    }

    return generatedNames;
  }

  List<Transaction> getRandomTransactions({required List<Transaction> transactions,required int count}) {
    final length = transactions.length;
    final random = Random();
    return List.generate(count, (_) => transactions[random.nextInt(length)]);

  }

  List<CustomTab> generateTabs() {
    List<Transaction> transactions = generateTransactions();
    List<String> names = generateNames(count: 12);
    final random = Random();

    return names.map((e) =>
      CustomTab(name: names[random.nextInt(names.length)],
          transactions: getRandomTransactions(transactions: transactions, count: 10))
    ).toList();
  }


  @override
  Widget getBody(BuildContext context) {
    return TabSelectionPage(initialTabs: generateTabs());
  }

  @override
  String? getTitle() {
    return "Contas";
  }
}
