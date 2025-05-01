import 'package:collectors/models/Participant.dart';
import 'package:collectors/models/Receipt.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AssignmentPage extends StatefulWidget {
  const AssignmentPage(
      {super.key, required this.receipt, required this.participants});

  final Receipt receipt;
  final List<Participant> participants;

  @override
  AssignmentState createState() => AssignmentState();
}

class AssignmentState extends State<AssignmentPage> {
  String formatDate(DateTime date) {
    return DateFormat("dd 'de' MMMM yyyy", 'pt').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size(double.infinity, 150),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 25,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Fatura",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      Text(
                        formatDate(widget.receipt.date),
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  Text(
                    "${widget.receipt.total}€",
                    style: TextStyle(
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  )
                ],
              ),
            )));
  }
}
