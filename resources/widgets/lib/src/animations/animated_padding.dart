import 'package:flutter/material.dart';

///
class AnimatedPaddingBuilder extends StatelessWidget {
  ///
  const AnimatedPaddingBuilder({
    required this.child,
    required this.condition,
    required this.conditionTruePadding,
    required this.conditionFalsePadding,
    super.key,
    this.durationInMs,
  });

  /// Child to display
  final Widget child;
  /// condition
  final bool condition;
  /// padding to display when condition true
  final EdgeInsets conditionTruePadding;
  /// padding to display when condition false
  final EdgeInsets conditionFalsePadding;
  /// Animation duration in MS
  final int? durationInMs;

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: Duration(milliseconds: durationInMs ?? 500),
      padding: condition ? conditionTruePadding : conditionFalsePadding,
      child: child,
    );
  }
}
