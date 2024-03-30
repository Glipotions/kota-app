import 'package:flutter/material.dart';

/// An abstract class for creating custom bottom sheet widgets.
///
/// Extend this class to create your own bottom sheet widget by implementing
/// the build method. Use the showBottomSheet method to display 
/// the bottom sheet.
///
/// Example:
/// ```dart
/// MyCustomBottomSheet().showBottomSheet(context: context);
/// ```
abstract class BottomSheetWidget<T> extends StatelessWidget {
  /// Creates a bottom sheet widget.
  ///
  /// Parameters:
  /// - `barrierColor`: The color of the barrier between 
  /// the content and the overlay.
  /// - `backgroundColor`: The background color of the bottom sheet.
  /// - `barrierDismissible`: Whether tapping on the barrier 
  /// dismisses the bottom sheet.
  /// - `shape`: The shape of the bottom sheet.
  /// - `constraints`: Additional constraints to apply to the bottom sheet.
  /// - `isScrollControlled`: Whether the bottom sheet should take 
  /// the full screen height.
  /// - `useRootNavigator`: Whether to use the root navigator.
  /// - `isDismissible`: Whether the bottom sheet can be dismissed by dragging.
  /// - `enableDrag`: Whether to enable dragging to dismiss.
  const BottomSheetWidget({
    super.key,
    this.barrierColor,
    this.backgroundColor,
    this.barrierDismissible,
    this.shape,
    this.constraints,
    this.isScrollControlled,
    this.useRootNavigator,
    this.isDismissible,
    this.enableDrag,
  });

  /// The color of the barrier between the content and the overlay.
  final Color? barrierColor;

  /// The background color of the bottom sheet.
  final Color? backgroundColor;

  /// Whether tapping on the barrier dismisses the bottom sheet.
  final bool? barrierDismissible;

  /// The shape of the bottom sheet.
  final ShapeBorder? shape;

  /// Additional constraints to apply to the bottom sheet.
  final BoxConstraints? constraints;

  /// Whether the bottom sheet should take the full screen height.
  final bool? isScrollControlled;

  /// Whether to use the root navigator.
  final bool? useRootNavigator;

  /// Whether the bottom sheet can be dismissed by dragging.
  final bool? isDismissible;

  /// Whether to enable dragging to dismiss.
  final bool? enableDrag;

  /// Displays the bottom sheet using [showModalBottomSheet].
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns a [Future] that resolves to the value 
  /// returned by the bottom sheet.
  Future<T?> showBottomSheet({required BuildContext context}) =>
      showModalBottomSheet<T>(
        context: context,
        barrierColor: barrierColor,
        backgroundColor: backgroundColor,
        isScrollControlled: isScrollControlled ?? false,
        useRootNavigator: useRootNavigator ?? false,
        isDismissible: isDismissible ?? true,
        enableDrag: enableDrag ?? true,
        shape: shape,
        constraints: constraints,
        builder: (BuildContext context) {
          return this;
        },
      );

  @override
  Widget build(BuildContext context);
}
