import 'package:flutter/material.dart';

/// `AppOutlineButton` is a customizable Flutter widget that provides an
/// outlined button with various styling options.
///
/// ## Parameters:
/// - `onTap`: A callback function to be executed when the button is tapped.
/// - `txt`: The text to be displayed on the button. Defaults to an empty string
/// - `widget`: An optional widget to be displayed on the button instead of text
/// - `padding`: The padding around the button. Defaults to zero padding.
/// - `style`: The style of the button. If null, it uses the
/// default outlined button style.
/// - `btnKey`: An optional key that can be used to uniquely identify the button
/// - `width`: The width of the button. If null, the button takes
/// the width of its child.
/// - `bgColor`: The background color of the button. Defaults
///  to null (transparent)
/// - `textStyle`: The text style of the button text. If provided, it
/// overrides the default text style.
/// - `textColor`: The text color of the button. If not provided, it
/// uses the default text color from the current theme.
///
/// ## Example:
/// ```dart
/// AppOutlineButton(
///   onTap: () {
///     // Handle button tap
///   },
///   txt: 'Click me',
///   textColor: Colors.blue,
///   width: 200.0,
/// )
/// ```
class AppOutlineButton extends StatelessWidget {
  /// Creates an instance of `AppOutlineButton`.
  ///
  /// The `onTap` parameter is required, while all other parameters are optional
  const AppOutlineButton({
    required this.onTap,
    super.key,
    this.txt = '',
    this.widget,
    this.padding,
    this.style,
    this.btnKey,
    this.textColor,
    this.bgColor,
    this.width,
    this.textStyle,
  });

  /// A callback function to be executed when the button is tapped.
  final VoidCallback? onTap;

  /// The text to be displayed on the button. Defaults to an empty string.
  final String? txt;

  /// An optional widget to be displayed on the button instead of text.
  final Widget? widget;

  /// The padding around the button. Defaults to zero padding.
  final EdgeInsets? padding;

  /// The style of the button. If null, it uses the default
  /// outlined button style.
  final ButtonStyle? style;

  /// An optional key that can be used to uniquely identify the button.
  final Key? btnKey;

  /// The width of the button. If null, the button takes the width of its child.
  final double? width;

  /// The background color of the button. Defaults to null (transparent).
  final Color? bgColor;

  /// The text style of the button text. If provided, it overrides
  /// the default text style.
  final TextStyle? textStyle;

  /// The text color of the button. If not provided, it uses the
  /// default text color from the current theme.
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        key: btnKey,
        padding: padding ?? EdgeInsets.zero,
        child: OutlinedButton(
          onPressed: onTap,
          style: style ??
              OutlinedButtonTheme.of(context).style!.copyWith(
                    backgroundColor: bgColor == null
                        ? null
                        : WidgetStateProperty.all<Color>(bgColor!),
                  ),
          child: widget ??
              Text(
                txt!,
                style: textStyle?.copyWith(color: textColor) ??
                    Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: textColor),
              ),
        ),
      ),
    );
  }
}
