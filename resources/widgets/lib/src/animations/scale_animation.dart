import 'package:flutter/material.dart';

///
class ScaleAnimation extends StatefulWidget {
  ///
  const ScaleAnimation({
    required this.value,
    required this.child,
    super.key,
  });

  ///value if it should animates
  final bool value;

  ///Child to display.
  final Widget child;

  @override
  // ignore: library_private_types_in_public_api
  _ScaleAnimationState createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends State<ScaleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Listen to changes in value and trigger animation accordingly
    widget.value
        ? _animationController.forward()
        : _animationController.reverse();
  }

  @override
  void didUpdateWidget(covariant ScaleAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if value property changed and trigger animation accordingly
    if (widget.value != oldWidget.value) {
      widget.value
          ? _animationController.forward()
          : _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final scaleValue = widget.value ? 1.1 - (_animation.value * 0.1) : 1.0;
        const perspectiveValue =
            0.003; // You can adjust this value for more or less perspective

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, perspectiveValue) // Apply perspective
            ..scale(scaleValue),
          alignment: Alignment.center,
          child: widget.child,
        );
      },
    );
  }
}
