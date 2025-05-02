import 'package:carousel_slider/carousel_slider.dart';
import 'package:collectors/models/Participant.dart';
import 'package:collectors/models/Receipt.dart';
import 'package:collectors/models/item.dart';
import 'package:dashed_circle/dashed_circle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AssignmentPage extends StatefulWidget {
  const AssignmentPage(
      {super.key, required this.receipt, required this.participants});

  final Receipt receipt;
  final List<Participant> participants;

  @override
  AssignmentState createState() => AssignmentState();
}

class AssignmentState extends State<AssignmentPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 70),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Fatura",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
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
          ),
        ),
      ),
      body: Column(
        children: [
          Divider(),
          _buildParticipantsCarousel(),
          Divider(),
          _buildItemsList()
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    Map<String, int> counts = {};

    List<Item> uniqueItems = [];

    for (final item in widget.receipt.items) {
      if (!counts.containsKey(item.name)) {
        uniqueItems.add(item);
      }
      counts[item.name] = (counts[item.name] ?? 0) + 1;
    }

    return Column(
        children: uniqueItems
            .map((item) => _buildItemCard((item, counts[item.name]!)))
            .toList());
  }

  Widget _buildItemCard((Item, int) repeatedItem) {
    final item = repeatedItem.$1;
    final quantity = repeatedItem.$2;
    final totalPrice = item.price * quantity;

    return Container(
      margin: EdgeInsets.only(bottom: 15, left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...List.generate(
                      quantity,
                      (index) {
                        return DashedCircle(
                          dashes: 8,
                          gapSize: 5,
                          color: Colors.grey,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.transparent,
                            child: null,
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Text(
                        item.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('x$quantity', style: TextStyle(fontSize: 15)),
                      Text('${totalPrice.toStringAsFixed(2)}€',
                          style: TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
              ],
            ),
            if (quantity > 1)
              Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Divider()),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(quantity, (index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: index == quantity - 1 ? 5 : 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.name,
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('x1', style: TextStyle(fontSize: 15)),
                                  Text('${item.price.toStringAsFixed(2)}€',
                                      style: TextStyle(fontSize: 15)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantsCarousel() {
    final pages = _chunkParticipants(widget.participants, 3);

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: pages.length,
          itemBuilder: (context, pageIndex, realIndex) {
            return _buildCarouselContent(pages[pageIndex]);
          },
          options: CarouselOptions(
            height: 150,
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            enlargeCenterPage: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: pages.length,
          effect: WormEffect(
            dotHeight: 4,
            dotWidth: 4,
            activeDotColor: Colors.green[800]!,
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselContent(List<Participant> participants) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: participants.map((participant) {
        final itemCount = participant.items.length;
        final totalAmount =
            participant.items.fold(0.0, (sum, item) => sum + item.price);

        return Container(
          width: 90,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    child: Text(
                      participant.person.name[0].toUpperCase(),
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.white,
                      child: Text(
                        itemCount.toString(),
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Text(
                participant.person.name,
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "${totalAmount.toStringAsFixed(2)}€",
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String formatDate(DateTime date) {
    return DateFormat("dd 'de' MMMM yyyy", 'pt').format(date);
  }

  List<List<Participant>> _chunkParticipants(
      List<Participant> participants, int chunkSize) {
    List<List<Participant>> chunks = [];
    for (var i = 0; i < participants.length; i += chunkSize) {
      chunks.add(participants.sublist(
        i,
        i + chunkSize > participants.length
            ? participants.length
            : i + chunkSize,
      ));
    }
    return chunks;
  }
}
