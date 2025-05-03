import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PendingInvoiceCard extends StatelessWidget {
  final String amount;
  final String date;
  final List<String> avatarUrls;
  final String location;

  const PendingInvoiceCard({
    super.key,
    required this.amount,
    required this.date,
    required this.avatarUrls,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location with icon
            Row(
              children: [
                PhosphorIcon(
                  PhosphorIcons.mapPin(PhosphorIconsStyle.light),
                  size: 14.0,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4.0),
                Expanded(
                  child: Text(
                    location,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),

            // Amount
            Text(
              amount,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 6.0),

            // Date
            Row(
              children: [
                PhosphorIcon(
                  PhosphorIcons.calendar(PhosphorIconsStyle.light),
                  size: 14.0,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4.0),
                Text(date,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    )),
              ],
            ),

            const SizedBox(height: 16.0),

            // Status indicator
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 6.0),
                Text(
                  'Pending',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12.0),

            // Participants
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildAvatarRow(avatarUrls),
                PhosphorIcon(
                  PhosphorIcons.caretRight(PhosphorIconsStyle.light),
                  size: 16.0,
                  color: Colors.grey[500],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarRow(List<String> avatarUrls) {
    const double avatarRadius = 16.0;
    const double overlap = 10.0;

    List<Widget> avatarWidgets = [];
    for (int i = 0; i < avatarUrls.length; i++) {
      avatarWidgets.add(
        Positioned(
          left: i * (2 * avatarRadius - overlap),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: CircleAvatar(
              radius: avatarRadius - 2,
              backgroundImage: AssetImage(avatarUrls[i]),
            ),
          ),
        ),
      );
    }

    // Calculate the width based on avatars with overlap
    double stackWidth = avatarUrls.isEmpty
        ? 0
        : (avatarUrls.length * (2 * avatarRadius - overlap)) + overlap;

    return SizedBox(
      height: 2 * avatarRadius,
      width: stackWidth,
      child: Stack(children: avatarWidgets),
    );
  }
}
