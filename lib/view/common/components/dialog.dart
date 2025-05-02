import 'package:usettle/view/common/components/modal/account_header.dart';
import 'package:usettle/view/common/components/modal/footer.dart';
import 'package:usettle/view/common/components/modal/item_list.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatefulWidget {
  late final List<ItemListEntry> itemList;
  double total = 0;

  CustomDialog({super.key, required this.itemList}) {
    total =
        itemList.isEmpty
            ? 0
            : itemList
                .map((e) => e.calculatePrice())
                .toList()
                .reduce((v, e) => v + e);
  }

  @override
  CustomDialogState createState() => CustomDialogState();
}

class CustomDialogState extends State<CustomDialog> {
  void removeItem(int index) {
    if (widget.itemList.length == 1) {
      setState(() {
        widget.itemList.clear();
        widget.total = 0;
      });
    } else {
      setState(() {
        widget.itemList.remove(widget.itemList[index]);
        widget.total = widget.itemList
            .map((e) => e.calculatePrice())
            .toList()
            .reduce((v, e) => v + e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ModalAccountHeader(name: "Rubem Neto"),
          ModalItemList(itemList: widget.itemList, callback: removeItem),
          ModalFooter(total: widget.total),
        ],
      ),
    );
  }
}
