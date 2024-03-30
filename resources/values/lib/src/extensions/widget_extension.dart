import 'package:flutter/material.dart';
import 'package:widgets/widget.dart';

/// Flutter extension methods for convenient widget modifications.
extension WidgetExtension on Widget {
  /// Conditionally sets the visibility of the widget.
  ///
  /// If [value] is `true`, returns the original widget; otherwise, returns
  /// a SizedBox with the specified [height] and [width].
  Widget isVisible({
    required bool value,
    double? height,
    double? width,
    Widget? child,
  }) =>
      value
          ? this
          :  child ?? SizedBox(
              height: height,
              width: width,
            );

  /// Conditionally applies a [colorFilter] to the widget.
  ///
  /// If [value] is `true`, returns the original widget with the applied
  /// [colorFilter]; otherwise, returns the original widget.
  Widget isFiltered({required bool value, required ColorFilter colorFilter}) =>
      value ? ColorFiltered(colorFilter: colorFilter, child: this) : this;

  /// Converts the widget into a SliverToBoxAdapter.
  ///
  /// Returns a SliverToBoxAdapter with the original widget as its child.
  SliverToBoxAdapter toSliver() => SliverToBoxAdapter(child: this);

  ///Arranges widgets ratio based on given width and aspectRatio
  AspectRatio toRatio({required double aspectRatio, double? width}) =>
      AspectRatio(
        aspectRatio: aspectRatio,
        child: SizedBox(width: width, child: this),
      );

  ///Applys slide animation to widget
  Widget slideAnimation({
    required int order,
    int? durationInMs,
    bool startFromLeft = false,
  }) {
    return SlideInAnimation(
      order: order,
      durationInMs: durationInMs,
      startFromLeft: startFromLeft,
      child: this,
    );
  }

  ///Animates the padding
  Widget toAnimatedPadding({
    required bool condition,
    required EdgeInsets conditionTruePadding,
    required EdgeInsets conditionFalsePadding,
    int? durationInMs,
  }) {
    return AnimatedPaddingBuilder(
      conditionFalsePadding: conditionFalsePadding,
      conditionTruePadding: conditionTruePadding,
      condition: condition,
      durationInMs: durationInMs,
      child: this,
    );
  }
}
