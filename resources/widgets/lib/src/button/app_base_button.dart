import 'package:flutter/material.dart';

/// `AppBaseButton` is a customizable Flutter widget that provides a button 
/// with various styling options.
///
/// ## Parameters:
/// - `onTap`: A callback function to be executed when the button is tapped.
/// - `txt`: The text to be displayed on the button. Defaults to an empty string
/// - `widget`: An optional widget to be displayed on the button instead of text
/// - `padding`: The padding around the button. Defaults to zero padding.
/// - `style`: The style of the button. If null, it uses the default 
/// elevated button style.
/// - `btnKey`: An optional key that can be used to uniquely identify the button
/// - `width`: The width of the button. If null, the button takes the 
/// width of its child.
/// - `bgColor`: The background color of the button. Defaults to the background
///  color of the current theme.
/// - `textStyle`: The text style of the button text. If provided, it overrides 
/// the default text style.
/// - `textColor`: The text color of the button. If not provided, it uses the 
/// default text color from the current theme.
///
/// ## Example:
/// ```dart
/// AppBaseButton(
///   onTap: () {
///     // Handle button tap
///   },
///   txt: 'Click me',
///   textColor: Colors.white,
///   bgColor: Colors.blue,
///   width: 200.0,
/// )
/// ```
class AppBaseButton extends StatelessWidget {
  /// Creates an instance of `AppBaseButton`.
  ///
  /// The `onTap` parameter is required, while all other parameters are optional
  const AppBaseButton({
    required this.onTap,
    super.key,
    this.txt = '',
    this.widget,
    this.padding,
    this.style,
    this.btnKey,
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

  /// The style of the button. If null, it uses the
  /// default elevated button style.
  final ButtonStyle? style;

  /// An optional key that can be used to uniquely identify the button.
  final Key? btnKey;

  /// The width of the button. If null, the button takes the width of its child.
  final double? width;

  /// The background color of the button. Defaults to the background
  /// color of the current theme.
  final Color? bgColor;

  /// The text style of the button text. If provided, it overrides
  /// the default text style.
  final TextStyle? textStyle;



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        key: btnKey,
        padding: padding ?? EdgeInsets.zero,
        child: ElevatedButton(
          onPressed: onTap,
          style: style ??
              ElevatedButtonTheme.of(context).style!.copyWith(
                    backgroundColor: bgColor == null
                        ? null
                        : MaterialStateProperty.all<Color>(bgColor!),
                  ),
          child: widget ??
              Text(
                txt!,
                style: textStyle,
              ),
        ),
      ),
    );
  }
}
