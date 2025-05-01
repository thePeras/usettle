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
                    receipt:
                        Receipt(total: 83.72, date: DateTime.now(), items: []),
                    participants: []),
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
