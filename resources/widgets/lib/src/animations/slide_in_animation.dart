import 'package:flutter/material.dart';

///
class SlideInAnimation extends StatefulWidget {
  ///
  const SlideInAnimation({
    required this.order,
    required this.child,
    super.key,
    this.durationInMs,
    this.startFromLeft = true,
    this.keepAlive = true,
  });

  ///Order of the item 
  final int order;
  ///Child to display item 
  final Widget child;
  ///Slide duration in Ms
  final int? durationInMs;
  ///Slide must start from left
  final bool startFromLeft;

  final bool keepAlive;

  @override
  // ignore: library_private_types_in_public_api
  _SlideInAnimationState createState() => _SlideInAnimationState();
}

class _SlideInAnimationState extends State<SlideInAnimation> 
    with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration:
          Duration(milliseconds: (widget.durationInMs ?? 300) * widget.order),
    );
    _animation = Tween<Offset>(
      begin: Offset(widget.startFromLeft ? -1 : 1, 0),
      end: Offset.zero,
    ).animate(_controller);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  bool get wantKeepAlive => widget.keepAlive;
}
