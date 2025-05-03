import 'dart:typed_data';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.name,
    this.avatarImage,
    required this.radius,
    this.backgroundColor,
  });

  final String name;
  final Uint8List? avatarImage;
  final double radius;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    if (avatarImage != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: MemoryImage(avatarImage!),
      );
    } else {
      final initials = name
          .split(' ')
          .where((part) => part.isNotEmpty)
          .take(2)
          .map((part) => part[0].toUpperCase())
          .join('');

      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? Colors.blueGrey[200],
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: radius * 0.8,
          ),
        ),
      );
    }
  }
}
