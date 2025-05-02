import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:usettle/models/item.dart';
import 'package:usettle/models/participant.dart';
import 'package:usettle/models/receipt.dart';

class AssignmentPage extends StatefulWidget {
  const AssignmentPage({
    super.key,
    required this.receipt,
    required this.participants,
  });

  final Receipt receipt;
  final List<Participant> participants;

  @override
  AssignmentState createState() => AssignmentState();
}

class AssignmentState extends State<AssignmentPage> {
  late int _currentIndex;
  int? _activeParticipant;
  bool assigning = false;

  Map<String, List<Item>> namedItems = {};

  Map<String, List<int?>> assignments = {};

  Set<String> expandedItems = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;

    for (final item in widget.receipt.items) {
      if (!namedItems.containsKey(item.name)) {
        namedItems[item.name] = [item];
      } else {
        namedItems[item.name]!.add(item);
      }
    }

    for (final item in widget.receipt.items) {
      assignments[item.id.toString()] = List<int?>.filled(
        namedItems[item.name]!.length,
        null,
        growable: true,
      );
    }

    for (int participantIndex = 0;
        participantIndex < widget.participants.length;
        participantIndex++) {
      final participant = widget.participants[participantIndex];

      for (final participantItem in participant.items) {
        final itemId = participantItem.id.toString();
        if (assignments.containsKey(itemId)) {
          final assignmentList = assignments[itemId]!;
          final availableSlot = assignmentList.indexWhere(
            (assignment) => assignment == null,
          );
          if (availableSlot >= 0) {
            assignmentList[availableSlot] = participantIndex;
          }
        }
      }
    }
  }

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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
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
                    fontSize: 20,
                  ),
                ),
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
          Expanded(child: _buildItemsList()),
        ],
      ),
    );
  }

  Widget _buildItemsList() => SingleChildScrollView(
        child: Column(
          children: namedItems.entries.map((entry) {
            if (entry.value.length == 1) {
              return _buildItemCard(entry.value[0]);
            } else {
              return _buildExpanded(entry.value);
            }
          }).toList(),
        ),
      );

  Widget _buildExpanded(List<Item> items) {
    final itemName = items[0].name;
    final isExpanded = expandedItems.contains(itemName);

    final totalQuantity = items.length;
    final totalPrice = items.fold(0.0, (sum, item) => sum + item.price);

    final uniqueAssignments = <int>{};
    for (final item in items) {
      final assignees = assignments[item.id.toString()]!;
      uniqueAssignments.addAll(assignees.whereType<int>());
    }

    return Container(
      margin: EdgeInsets.only(bottom: 15, left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  if (isExpanded) {
                    expandedItems.remove(itemName);
                  } else {
                    expandedItems.add(itemName);
                  }
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 25,
                        width: 14 *
                                (uniqueAssignments.length > 3
                                        ? 4
                                        : uniqueAssignments.length)
                                    .toDouble() +
                            8,
                        child: Stack(
                          children: uniqueAssignments
                              .take(3)
                              .toList()
                              .asMap()
                              .entries
                              .map((entry) {
                            final index = entry.key;
                            final participantIndex = entry.value;
                            return Positioned(
                              left: index * 14.0,
                              child: CircleAvatar(
                                radius: 11,
                                backgroundColor: Colors.green[800],
                                child: Text(
                                  widget.participants[participantIndex].person
                                      .name[0]
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }).toList()
                            ..addAll(
                              uniqueAssignments.length > 3
                                  ? [
                                      Positioned(
                                        left: 14 * 3.0,
                                        top: 1,
                                        child: Container(
                                          height: 21.5,
                                          width: 21.5,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            shape: BoxShape.circle,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '+${uniqueAssignments.length - 3}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]
                                  : [],
                            ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Text(
                          itemName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                      width: 90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('x' + totalQuantity.toString()),
                          Text(
                            "${totalPrice.toStringAsFixed(2)}€",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                        ],
                      ))
                ],
              ),
            ),
            if (isExpanded)
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Column(
                  children: items.map((item) {
                    final assignmentList = assignments[item.id.toString()]!;
                    final avatarCount =
                        max(1, assignmentList.where((a) => a != null).length);

                    return GestureDetector(
                      onTap: _activeParticipant != null
                          ? () => setState(() {
                                if (assignmentList
                                    .contains(_activeParticipant)) {
                                  assignmentList.remove(_activeParticipant);
                                } else {
                                  assignmentList.add(_activeParticipant);
                                }
                              })
                          : null,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 25,
                                  width: 14 *
                                          (avatarCount > 3 ? 4 : avatarCount)
                                              .toDouble() +
                                      8,
                                  child: Stack(
                                    children:
                                        _buildAvatarRow(item, avatarCount),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Text(
                                    item.name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text("x1", style: TextStyle(fontSize: 14)),
                                SizedBox(width: 8),
                                Text(
                                  "${item.price.toStringAsFixed(2)}€",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(Item repeatedItem) {
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
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: _activeParticipant != null
                  ? () => setState(() {
                        final peopleAssignedToItem =
                            assignments[repeatedItem.id.toString()]!;

                        if (peopleAssignedToItem.length == 1 &&
                            peopleAssignedToItem[0] == null) {
                          assignments[repeatedItem.id.toString()]!.remove(null);
                        }

                        if (peopleAssignedToItem.contains(_activeParticipant)) {
                          assignments[repeatedItem.id.toString()]!.remove(
                            _activeParticipant,
                          );
                        } else {
                          assignments[repeatedItem.id.toString()]!.add(
                            _activeParticipant,
                          );
                        }
                      })
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 25,
                        width: 14 *
                                (max(
                                              1,
                                              assignments[repeatedItem.id
                                                      .toString()]!
                                                  .length,
                                            ) >
                                            3
                                        ? 4
                                        : max(
                                            1,
                                            assignments[
                                                    repeatedItem.id.toString()]!
                                                .length,
                                          ))
                                    .toDouble() +
                            8,
                        child: Stack(
                          children: _buildAvatarRow(repeatedItem, 1),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Text(
                          repeatedItem.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('x1', style: TextStyle(fontSize: 15)),
                            Text(
                              '${repeatedItem.price.toStringAsFixed(2)}€',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAvatarRow(Item item, int displayCount) {
    final assignmentList = assignments[item.id.toString()]!;
    final assignedParticipants =
        assignmentList.where((a) => a != null).cast<int>().toList();

    final showCount = max(1, assignedParticipants.length);
    final visibleCount = showCount > 3 ? 3 : showCount;

    return [
      ...List.generate(visibleCount, (index) {
        if (index < assignedParticipants.length) {
          final participantIndex = assignedParticipants[index];
          return Positioned(
            left: index * 14.0,
            child: CircleAvatar(
              radius: 11,
              backgroundColor: Colors.green[800],
              child: Text(
                widget.participants[participantIndex].person.name[0]
                    .toUpperCase(),
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
          );
        } else {
          return Positioned(
            left: index * 14.0,
            child: PhosphorIcon(
              color: Colors.grey[500],
              size: 25,
              PhosphorIcons.circleDashed(PhosphorIconsStyle.duotone),
            ),
          );
        }
      }),
      if (showCount > 3)
        Positioned(
          left: 14 * 3.0,
          top: 1,
          child: Container(
            height: 21.5,
            width: 21.5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '+${showCount - 3}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
    ];
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
        final totalAmount = participant.items.fold(
          0.0,
          (sum, item) => sum + item.price,
        );

        return Container(
          width: 90,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: participant.id == _activeParticipant
                          ? Border.all(
                              color: Colors.green[800]!,
                              width: 3,
                            )
                          : null,
                    ),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        if (_activeParticipant == participant.id) {
                          assigning = false;
                          _activeParticipant = null;
                        } else {
                          assigning = true;
                          _activeParticipant = participant.id;
                        }
                      }),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey,
                        child: Text(
                          participant.person.name[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
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
    List<Participant> participants,
    int chunkSize,
  ) {
    List<List<Participant>> chunks = [];
    for (var i = 0; i < participants.length; i += chunkSize) {
      chunks.add(
        participants.sublist(
          i,
          i + chunkSize > participants.length
              ? participants.length
              : i + chunkSize,
        ),
      );
    }
    return chunks;
  }
}
