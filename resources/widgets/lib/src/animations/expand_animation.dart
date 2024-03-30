import 'package:flutter/material.dart';

///
class BaseExpandAnimation extends StatefulWidget {
  ///
  const BaseExpandAnimation({required this.builder, super.key,
  });

  ///
  final Widget Function(
    // ignore: avoid_positional_boolean_parameters
    bool isExpanded,
    VoidCallback onTapExpand,
    Animation<double> animation,
    Animation<double> rotateAnimation,
  ) builder;

  @override
  // ignore: library_private_types_in_public_api
  _BaseExpandAnimationState createState() => _BaseExpandAnimationState();
}

class _BaseExpandAnimationState extends State<BaseExpandAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _rotateAnimation;

  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    _rotateAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
        isExpanded, onTapExpand, _animation, _rotateAnimation,);
  }

  void onTapExpand() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
