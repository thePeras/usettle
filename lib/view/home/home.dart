import 'package:collectors/view/common/pages/general.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends GeneralPageViewState<HomePage> {
  @override
  String? getTitle() => "Homepage";

  @override
  Widget getBody(BuildContext context) {
    return Text("data");
  }
}