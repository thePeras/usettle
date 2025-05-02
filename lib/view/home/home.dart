import 'package:usettle/view/common/pages/general.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../api/mbway_api.dart';

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
    return DialogExample();
  }
}

class DialogExample extends StatelessWidget {
  DialogExample({super.key});
  final MbwayApi mbwayApi = MbwayApi(
    mbwayKey: dotenv.env['IFTHENPAY_MBWAY_KEY'] ?? "",
  );

  Future<void> createMBWayRequest() async {
    try {
      final Map<String, dynamic> response = await mbwayApi.createMbWayPayment(
        phoneNumber: "351#938043682",
        amount: 10.00,
        orderId: "123123123",
      );
      print(response);
    } catch (e) {
      print('Error while creating MBWAY Request: $e');
    }
  }

  Future<void> checkMBWayRequest() async {
    try {
      final Map<String, dynamic> response = await mbwayApi.checkPaymentStatus();
      print(response);
    } catch (e) {
      print('Error while checking MBWAY Request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton(
          onPressed: createMBWayRequest,
          child: const Text('Create Payment'),
        ),
        TextButton(
          onPressed: checkMBWayRequest,
          child: const Text('Check Payment'),
        ),
      ],
    );
  }
}