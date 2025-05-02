import 'package:collectors/view/common/components/bill_card.dart';
import 'package:collectors/view/common/components/tabs.dart';
import 'package:collectors/view/common/pages/general.dart';
import 'package:flutter/material.dart';

// --- Mock Data ---
final List<Map<String, dynamic>> mockBills = [
  {
    'name': 'KFC Cafe',
    'date': '10 Dec, 2022',
    'time': '09.30',
    'amount': 61.43,
    'paidPercentage': 75,
    'participants': 3,
    'logoIcon': Icons.fastfood, // Placeholder icon
  },
  {
    'name': 'McD Sudirman',
    'date': '10 Dec, 2022',
    'time': '09.30',
    'amount': 61.43,
    'paidPercentage': 50,
    'participants': 5,
    'logoIcon': Icons.local_pizza, // Placeholder icon
  },
  {
    'name': 'Costa Coffee',
    'date': '10 Dec, 2022',
    'time': '09.30',
    'amount': 61.43,
    'paidPercentage': 75,
    'participants': 3,
    'logoIcon': Icons.local_cafe, // Placeholder icon
  },
  {
    'name': 'Burger King',
    'date': '10 Dec, 2022',
    'time': '09.30',
    'amount': 61.43,
    'paidPercentage': 65,
    'participants': 4,
    'logoIcon': Icons.lunch_dining, // Placeholder icon
  },
  {
    'name': 'Breakfast Together',
    'date': '10 Dec, 2022',
    'time': '09.30',
    'amount': 61.43,
    'paidPercentage': 75,
    'participants': 4,
    'logoIcon': Icons.bakery_dining, // Placeholder icon
  },
  {
    'name': 'Burger King', // Duplicate example at bottom
    'date': '10 Dec, 2022',
    'time': '09.30',
    'amount': 61.43,
    'paidPercentage': 0, // Assuming 0% if not shown
    'participants': 1, // Needs at least one participant avatar
    'logoIcon': Icons.lunch_dining, // Placeholder icon
  },
];

class InvoicesHistoryPage extends StatefulWidget {
  const InvoicesHistoryPage({super.key});

  @override
  State<StatefulWidget> createState() => _InvoicesHistoryPageState();
}

class _InvoicesHistoryPageState
    extends GeneralPageViewState<InvoicesHistoryPage> {
  @override
  String? getTitle() => "História";

  @override
  Widget getBody(BuildContext context) {
    int selectedTab = 0;
    final List<String> tabOptions = ['Recentes', 'Pendentes', 'Completos'];

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 12.0,
            ),
            child: SlidingSegmentedControl(
              options: tabOptions, // Use the options defined above
              initialIndex: selectedTab,
              onValueChanged: (index) {
                setState(() {
                  selectedTab = index;
                });
              },
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: mockBills.length,
              itemBuilder: (context, index) {
                final bill = mockBills[index];
                return BillCard(
                  logoIcon: bill['logoIcon'],
                  name: bill['name'],
                  date: bill['date'],
                  time: bill['time'],
                  amount: bill['amount'],
                  paidPercentage: bill['paidPercentage'],
                  participantCount: bill['participants'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
