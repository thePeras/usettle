import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:usettle/models/item.dart';
import 'package:usettle/models/participant.dart';
import 'package:usettle/models/profile.dart';
import 'package:usettle/models/receipt.dart';
import 'package:usettle/view/assignment/assignment.dart';
import 'package:usettle/view/history/invoices_history.dart';
import 'package:usettle/view/home/home.dart';
import 'package:usettle/view/invoice_confirm/confirmation_page.dart';
import 'package:usettle/view/scan/scanner.dart';
import 'package:usettle/view/contacts/contacts_selection.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final apiKey = dotenv.env['GEMINI_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    print('Error: GEMINI_API_KEY not found in .env file');
    return;
  }
  Gemini.init(apiKey: apiKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color _greenColor = Color(0xFF2A6E55);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'uSettle',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _greenColor),
        //fontFamily: 'Monteserrat' TODO: change to the correct name
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
                    Item(id: 1, name: 'Double Smash Burguer', price: 3.50),
                    Item(id: 2, name: 'Apples', price: 3.50),
                    Item(id: 3, name: 'Apples', price: 3.50),
                    Item(id: 4, name: 'Apples', price: 3.50),
                    Item(id: 5, name: 'Apples', price: 3.50),
                    Item(id: 7, name: 'Bread', price: 2.00),
                    Item(id: 11, name: 'Bread', price: 2.00),
                    Item(id: 12, name: 'Bread', price: 2.00),
                    Item(id: 8, name: 'Milk', price: 1.50),
                    Item(id: 9, name: 'Milk', price: 1.50),
                    Item(id: 10, name: 'Milk', price: 1.50),
                  ],
                ),
                participants: [
                  Participant(
                    id: 0,
                    person: Profile(
                      name: 'Alice',
                      contact: 'alice@example.com',
                      avatarUrl: 'https://example.com/avatar/alice.png',
                    ),
                    items: [],
                  ),
                  Participant(
                    id: 1,
                    person: Profile(
                      name: 'Alice',
                      contact: 'alice@example.com',
                      avatarUrl: 'https://example.com/avatar/alice.png',
                    ),
                    items: [],
                  ),
                  Participant(
                    id: 2,
                    person: Profile(
                      name: 'Alice',
                      contact: 'alice@example.com',
                      avatarUrl: 'https://example.com/avatar/alice.png',
                    ),
                    items: [],
                  ),
                  Participant(
                    id: 3,
                    person: Profile(
                      name: 'Alice',
                      contact: 'alice@example.com',
                      avatarUrl: 'https://example.com/avatar/alice.png',
                    ),
                    items: [],
                  ),
                  Participant(
                    id: 4,
                    person: Profile(
                      name: 'Alice',
                      contact: 'alice@example.com',
                      avatarUrl: 'https://example.com/avatar/alice.png',
                    ),
                    items: [Item(id: 7, name: 'Bread', price: 2)],
                  ),
                  Participant(
                    id: 5,
                    person: Profile(
                      name: 'Bob',
                      contact: 'bob@example.com',
                      avatarUrl: 'https://example.com/avatar/bob.png',
                    ),
                    items: [],
                  ),
                  Participant(
                    id: 6,
                    person: Profile(
                      name: 'Charlie',
                      contact: 'charlie@example.com',
                      avatarUrl: 'https://example.com/avatar/charlie.png',
                    ),
                    items: [],
                  ),
                ],
              ),
              settings,
            );
          //  return _createRoute(InvoicesHistoryPage(), settings);
          case '/contacts':
            return _createRoute(ContactsSelectionPage(), settings);
          case '/confirmation':
            return _createRoute(const ConfirmationPage(), settings);
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
