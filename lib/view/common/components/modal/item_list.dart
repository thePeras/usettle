import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'ItemListEntry.dart';


class ModalItemList extends StatefulWidget {
  final List<ItemListEntry> itemList;
  final void Function(int) callback;

  ModalItemList({required this.itemList, required this.callback});

  @override
  ModalItemListState createState() => ModalItemListState();
}

class ModalItemListState extends State<ModalItemList> {
  Widget buildEntry(ItemListEntry entry, int index) {
    List<Widget> children = [
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...entry.toTextList(),
          IconButton(
            icon: Icon(PhosphorIcons.xCircle(PhosphorIconsStyle.fill)),
            onPressed: () => widget.callback(index),
          ),
        ],
      ),
    ];

    if (index != widget.itemList.length - 1) {
      children.add(Divider(height: 20, indent: 16, endIndent: 16));
    }
    return Column(children: children);
  }

  @override
  Widget build(BuildContext context) {
    return widget.itemList.isNotEmpty
        ? Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey, width: .5),
              bottom: BorderSide(color: Colors.grey, width: .5),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: List.generate(
                widget.itemList.length,
                (i) => buildEntry(widget.itemList[i], i),
              ),
            ),
          ),
        )
        : Column(children: [Text("Não há mais itens associados")]);
  }
}
