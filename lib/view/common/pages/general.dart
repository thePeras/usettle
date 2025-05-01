import 'package:collectors/view/common/components/navbar.dart';
import 'package:flutter/material.dart';

abstract class GeneralPage extends StatelessWidget {
  const GeneralPage({super.key});

  Widget getBody(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: getBody(context),
      bottomNavigationBar: SafeArea(child: CustomBottomNavbar()),
    );
  }
}
