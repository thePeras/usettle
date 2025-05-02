// lib/sliding_segmented_control.dart
import 'package:flutter/material.dart';

class SlidingSegmentedControl extends StatefulWidget {
  final List<String> options;
  final ValueChanged<int> onValueChanged;
  final int initialIndex;
  final Color backgroundColor;
  final Color thumbColor;
  final Color textColor;
  final Color selectedTextColor;
  final double height;
  final EdgeInsets padding;
  final Duration animationDuration;

  const SlidingSegmentedControl({
    super.key,
    required this.options,
    required this.onValueChanged,
    this.initialIndex = 0,
    this.backgroundColor = const Color(0xFFEEEEEE), // Light grey track
    this.thumbColor = Colors.white, // White sliding thumb
    this.textColor = Colors.grey, // Unselected text color
    this.selectedTextColor = Colors.black, // Selected text color
    this.height = 50.0,
    this.padding = const EdgeInsets.all(4.0),
    this.animationDuration = const Duration(milliseconds: 200),
  }) : assert(options.length >= 2),
       assert(initialIndex >= 0 && initialIndex < options.length);

  @override
  SlidingSegmentedControlState createState() => SlidingSegmentedControlState();
}

class SlidingSegmentedControlState extends State<SlidingSegmentedControl> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double controlWidth = constraints.maxWidth;
        final double segmentWidth =
            (controlWidth - widget.padding.horizontal) / widget.options.length;
        final double thumbLeft =
            widget.padding.left + (segmentWidth * _selectedIndex);
        final double thumbHeight = widget.height - widget.padding.vertical;

        return Container(
          height: widget.height,
          width: controlWidth,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.height / 2),
          ),
          child: Stack(
            children: [
              // Animated Thumb
              AnimatedPositioned(
                duration: widget.animationDuration,
                curve: Curves.easeInOut,
                top: widget.padding.top,
                bottom: widget.padding.bottom,
                left: thumbLeft,
                child: Container(
                  width: segmentWidth,
                  height: thumbHeight,
                  decoration: BoxDecoration(
                    color: widget.thumbColor,
                    borderRadius: BorderRadius.circular(thumbHeight / 2),
                  ),
                ),
              ),

              // Options Row (on top)
              Positioned.fill(
                child: Row(
                  children: List.generate(widget.options.length, (index) {
                    final bool isSelected = _selectedIndex == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (_selectedIndex != index) {
                            setState(() {
                              _selectedIndex = index;
                            });
                            widget.onValueChanged(index);
                          }
                        },
                        behavior:
                            HitTestBehavior
                                .opaque, // Ensure taps register across the Expanded area
                        child: Center(
                          child: Text(
                            widget.options[index],
                            style: TextStyle(
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              color:
                                  isSelected
                                      ? widget.selectedTextColor
                                      : widget.textColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
