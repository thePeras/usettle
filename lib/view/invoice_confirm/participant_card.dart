import 'package:dotted_separator/source/separator.dart';
import 'package:flutter/material.dart';
import 'package:usettle/models/item.dart';
import 'package:usettle/models/participant.dart';
import 'package:usettle/view/components/account_mbway_selector.dart';

class ParticipantCard extends StatefulWidget {
  final Participant participant;
  final double total;
  final AccountType selectedAccountType;
  final Function(AccountType) onAccountTypeChanged;

  const ParticipantCard({
    super.key,
    required this.participant,
    required this.total,
    this.selectedAccountType = AccountType.mbway,
    required this.onAccountTypeChanged,
  });

  @override
  State<ParticipantCard> createState() => _ParticipantCardState();
}

class _ParticipantCardState extends State<ParticipantCard> {
  bool _isExpanded = false;
  late AccountType selectedAccountType;

  @override
  void initState() {
    super.initState();
    selectedAccountType = widget.selectedAccountType;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: widget.participant.person.avatarImage !=
                            null
                        ? MemoryImage(widget.participant.person.avatarImage!)
                        : widget.participant.person.avatarUrl != null
                            ? NetworkImage(widget.participant.person.avatarUrl!)
                                as ImageProvider
                            : const AssetImage(
                                'assets/imgs/placeholder_avatar.png'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.participant.person.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget.total.toStringAsFixed(2)} €',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.green[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      // Don't show account type toggle for the user (author)
                      if (!widget.participant.author)
                        _buildAccountTypeToggle(),
                      const SizedBox(width: 8),
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.grey[600],
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
              if (_isExpanded && widget.participant.items.isNotEmpty) ...[
                const SizedBox(height: 12),
                DashedLine(
                  color: Colors.grey,
                  height: 1,
                  width: double.infinity,
                  axis: Axis.horizontal,
                  dashWidth: 5,
                  dashSpace: 3,
                  strokeWidth: 1.5,
                  padding: EdgeInsets.symmetric(vertical: 8),
                ),
                const SizedBox(height: 12),
                ...widget.participant.items.map((item) => _buildItemRow(item)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountTypeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                selectedAccountType = AccountType.conta;
              });
              widget.onAccountTypeChanged(AccountType.conta);
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: selectedAccountType == AccountType.conta
                    ? Colors.green[700]
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person_add_alt_1_outlined,
                    color: selectedAccountType == AccountType.conta
                        ? Colors.white
                        : Colors.black,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Conta',
                    style: TextStyle(
                      fontSize: 12,
                      color: selectedAccountType == AccountType.conta
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedAccountType = AccountType.mbway;
              });
              widget.onAccountTypeChanged(AccountType.mbway);
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: selectedAccountType == AccountType.mbway
                    ? Colors.green[700]
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Image.asset(
                selectedAccountType == AccountType.mbway
                    ? 'assets/imgs/mb-way-white.png'
                    : 'assets/imgs/mb-way-black.png',
                height: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(Item item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              item.name,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${item.price.toStringAsFixed(2)} €',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
