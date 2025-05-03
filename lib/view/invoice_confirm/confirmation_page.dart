import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:dotted_separator/source/separator.dart';
import 'package:usettle/api/mbway_api.dart';
import 'package:usettle/models/participant.dart';
import 'package:usettle/models/receipt.dart';
import 'package:usettle/view/components/account_mbway_selector.dart';
import 'package:usettle/view/invoice_confirm/participant_card.dart';
import 'package:usettle/view/utils/utils.dart';

class ConfirmationPage extends StatefulWidget {
  const ConfirmationPage(
      {super.key, required this.participants, required this.receipt});

  final List<Participant> participants;
  final Receipt receipt;

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  final _key = dotenv.env["YOUR_MB_KEY"];

  late final MbwayApi _mbwayApi;
  final Map<int, AccountType> _participantPaymentMethods = {};
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _mbwayApi = MbwayApi(mbwayKey: _key!);

    for (var participant in widget.participants) {
      _participantPaymentMethods[participant.id] = AccountType.mbway;
    }
  }

  void _updatePaymentMethod(int participantId, AccountType method) {
    setState(() {
      _participantPaymentMethods[participantId] = method;
    });
  }

  Future<void> _settlePayments() async {
    setState(() {
      _isProcessing = true;
    });

    final List<Participant> filteredParticipants = widget.participants
        .where((participant) => participant.items.isNotEmpty)
        .toList();

    List<Future> mbwayPayments = [];

    for (var participant in filteredParticipants) {
      if (_participantPaymentMethods[participant.id] != AccountType.mbway) {
        continue;
      }

      final String phoneNumber = participant.person.contact;
      if (phoneNumber.isEmpty || !_isValidPhoneNumber(phoneNumber)) {
        continue;
      }

      final double amount = _calculateParticipantTotal(participant);
      if (amount <= 0) continue;

      final String orderId =
          '${participant.id}-${DateTime.now().millisecondsSinceEpoch}';

      mbwayPayments.add(_processMbWayPayment(phoneNumber, amount, orderId));
    }

    await Future.wait(mbwayPayments);

    setState(() {
      _isProcessing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Pedidos enviados com sucesso!"),
      ));
    }

    sleep(Duration(seconds: 3));

    if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _processMbWayPayment(
      String phoneNumber, double amount, String orderId) async {
    try {
      await _mbwayApi.createMbWayPayment(
        phoneNumber: phoneNumber.substring(4),
        amount: amount,
        orderId: orderId,
      );
    } catch (e) {
      debugPrint('Error processing payment: ${e.toString()}');
    }
  }

  Future<void> _processMBWayPayments() async {
    for (Participant participant in widget.participants) {
      if (participant.accountType != AccountType.mbway ||
          participant.person.contact.isEmpty) {
        continue;
      }

      if (!participant.person.contact.startsWith('+')) {
        continue;
      }

      final double total = widget.receipt.calculateTotal(participant);
      if (total <= 0) continue;

      final orderId =
          'ORDER-${DateTime.now().millisecondsSinceEpoch}-${participant.id}';

      try {
        final MBWayPayment payment = await MbwayApi.requestPayment(
          phoneNumber: participant.person.contact,
          amount: total,
          description: 'Bill from uSettle',
          orderId: orderId,
        );

        setState(() {
          _mbwayPayments[participant.id] = payment;
        });
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to request MB WAY payment: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith('+351')) {
      return phoneNumber.length == 13;
    } else if (phoneNumber.startsWith('9')) {
      return phoneNumber.length == 9;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final List<Participant> filteredParticipants = widget.participants
        .where((participant) => participant.items.isNotEmpty)
        .toList();

    double totalAmount = 0;
    for (var participant in filteredParticipants) {
      totalAmount += _calculateParticipantTotal(participant);
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Stack(
          children: [
            Positioned(
              left: 15,
              child: SafeArea(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: PhosphorIcon(
                      color: Colors.black,
                      PhosphorIcons.arrowLeft(PhosphorIconsStyle.regular),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Quase lá!",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Confirme os dados antes de finalizar",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Image.asset(
                        'assets/imgs/confirm_illustration.png',
                        height: 80,
                        fit: BoxFit.contain,
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recibo',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      Utils.formatDate(widget.receipt.date),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...filteredParticipants.map((participant) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ParticipantCard(
                              participant: participant,
                              total: _calculateParticipantTotal(participant),
                              selectedAccountType:
                                  _participantPaymentMethods[participant.id] ??
                                      AccountType.mbway,
                              onAccountTypeChanged: (AccountType type) {
                                _updatePaymentMethod(participant.id, type);
                              },
                            ),
                          )),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: DashedLine(
                          color: Colors.grey,
                          height: 1,
                          width: double.infinity,
                          axis: Axis.horizontal,
                          dashWidth: 5,
                          dashSpace: 3,
                          strokeWidth: 1.5,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 12, bottom: 24, left: 12, right: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF008069).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'TOTAL',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${totalAmount.toStringAsFixed(2)} €',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF008069),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: ElevatedButton(
          onPressed: _isProcessing ? null : _settlePayments,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[800],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            disabledBackgroundColor: Colors.grey,
          ),
          child: _isProcessing
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Processing...',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              : const Text(
                  'Settle!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }

  double _calculateParticipantTotal(Participant participant) {
    if (participant.items.isEmpty) return 0.0;
    return participant.items.fold(0.0, (sum, item) => sum + item.price);
  }
}
