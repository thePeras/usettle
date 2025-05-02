import 'package:collectors/view/history/invoices_history.dart';
import 'package:collectors/view/home/home.dart';
import 'package:collectors/view/scan/scanner.dart';
import 'package:collectors/view/contacts/contacts_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
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
      title: 'The Collectors',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _greenColor),
        //fontFamily: 'Monteserrat' TODO: change to the correct name
      ),
      home: HomePage(),
      initialRoute: '/history',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return _createRoute(const HomePage(), settings);
          case '/scan':
            return _createRoute(const Scanner(), settings);
          case '/history':
            return _createRoute(InvoicesHistoryPage(), settings);
          case '/contacts':
            return _createRoute(ContactsSelectionPage(), settings);
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
