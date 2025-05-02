import 'package:flutter/cupertino.dart';

class ItemListEntry {
  final String name;
  final double price;

  const ItemListEntry({required this.name, required this.price});

  List<Widget> toTextList() {
    return [
      SizedBox(
        width: 150,
        child: Text(
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
      ),
      Text("${price.toStringAsFixed(2)}€"),
    ];
  }

  double calculatePrice() {
    return price;
  }
}
