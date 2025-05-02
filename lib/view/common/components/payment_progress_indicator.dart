import 'package:flutter/material.dart';

class PaymentProgressIndicator extends StatelessWidget {
  final int percentageValue;

  const PaymentProgressIndicator({super.key, required this.percentageValue});

  @override
  Widget build(BuildContext context) {
    final double progress = percentageValue / 100.0;
    final Color progressColor = Colors.green.shade500;

    return SizedBox(
      width: 45, // Increased size slightly for text fit
      height: 45,
      child: Stack(
        fit: StackFit.expand, // Make stack children fill the SizedBox
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 4.5, // Thickness of the circle
            backgroundColor: Colors.grey.shade200, // Background track color
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$percentageValue%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11, // Adjust size as needed
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Paid',
                  style: TextStyle(
                    fontSize: 8, // Smaller text for "Paid"
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
