import 'package:flutter/material.dart';

class AnimatedCountBadge extends StatefulWidget {
  final int count;
  final double radius;
  final Color backgroundColor;
  final Color textColor;

  const AnimatedCountBadge({
    Key? key,
    required this.count,
    this.radius = 10,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  State<AnimatedCountBadge> createState() => _AnimatedCountBadgeState();
}

class _AnimatedCountBadgeState extends State<AnimatedCountBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  int _previousCount = 0;

  @override
  void initState() {
    super.initState();
    _previousCount = widget.count;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 20,
      ),
    ]).animate(_animationController);
  }

  @override
  void didUpdateWidget(AnimatedCountBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count != _previousCount) {
      _animationController.forward(from: 0.0);
      _previousCount = widget.count;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: CircleAvatar(
            radius: widget.radius,
            backgroundColor: widget.backgroundColor,
            child: Text(
              widget.count.toString(),
              style: TextStyle(
                fontSize: widget.radius * 0.8,
                color: widget.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
