import 'package:collectors/models/item.dart';
import 'package:collectors/models/Participant.dart';
import 'package:collectors/models/profile.dart';
import 'package:collectors/models/Receipt.dart';
import 'package:collectors/view/assignment/assignment.dart';
import 'package:collectors/view/home/home.dart';
import 'package:collectors/view/scan/scanner.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Collectors',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(),
      initialRoute: '/home',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return _createRoute(const HomePage(), settings);
          case '/scan':
            return _createRoute(const Scanner(), settings);
          case '/history':
            return _createRoute(
                AssignmentPage(
                    receipt: Receipt(
                        total: 120.50,
                        date: DateTime(2025, 5, 2),
                        items: [
                          Item(name: 'Double Smash Burguer', price: 3.50),
                          Item(name: 'Apples', price: 6.32),
                          Item(name: 'Apples', price: 3.50),
                          Item(name: 'Bread', price: 2.00),
                          Item(name: 'Milk', price: 1.50),
                        ]),
                    participants: [
                      Participant(
                          person: Profile(
                              name: 'Alice',
                              contact: 'alice@example.com',
                              avatarUrl:
                                  'https://example.com/avatar/alice.png'),
                          items: [
                            Item(name: 'Apples', price: 3.50),
                            Item(name: 'Milk', price: 1.50),
                          ]),
                      Participant(
                          person: Profile(
                              name: 'Alice',
                              contact: 'alice@example.com',
                              avatarUrl:
                                  'https://example.com/avatar/alice.png'),
                          items: [
                            Item(name: 'Apples', price: 3.50),
                            Item(name: 'Milk', price: 1.50),
                          ]),
                      Participant(
                          person: Profile(
                              name: 'Alice',
                              contact: 'alice@example.com',
                              avatarUrl:
                                  'https://example.com/avatar/alice.png'),
                          items: [
                            Item(name: 'Apples', price: 3.50),
                            Item(name: 'Milk', price: 1.50),
                          ]),
                      Participant(
                          person: Profile(
                              name: 'Alice',
                              contact: 'alice@example.com',
                              avatarUrl:
                                  'https://example.com/avatar/alice.png'),
                          items: [
                            Item(name: 'Apples', price: 3.50),
                            Item(name: 'Milk', price: 1.50),
                          ]),
                      Participant(
                          person: Profile(
                              name: 'Alice',
                              contact: 'alice@example.com',
                              avatarUrl:
                                  'https://example.com/avatar/alice.png'),
                          items: [
                            Item(name: 'Apples', price: 3.50),
                            Item(name: 'Milk', price: 1.50),
                          ]),
                      Participant(
                          person: Profile(
                              name: 'Bob',
                              contact: 'bob@example.com',
                              avatarUrl: 'https://example.com/avatar/bob.png'),
                          items: [
                            Item(name: 'Bread', price: 2.00),
                          ]),
                      Participant(
                          person: Profile(
                              name: 'Charlie',
                              contact: 'charlie@example.com',
                              avatarUrl:
                                  'https://example.com/avatar/charlie.png'),
                          items: [
                            Item(name: 'Apples', price: 3.50),
                            Item(name: 'Bread', price: 2.00),
                          ]),
                    ]),
                settings);
          default:
            return null;
        }
      },
    );
  }
}

PageRouteBuilder _createRoute(Widget page, RouteSettings settings) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    settings: settings,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
