import 'package:flutter/material.dart';
import 'package:values/values.dart';

class ClickableText extends StatelessWidget {
  const ClickableText({
    required this.text,
    super.key,
    this.onTap,
    this.textStyle,
  });

  final String text;
  final VoidCallback? onTap;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: textStyle ??
            Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.primary,
                ),
      ),
    );
  }
}
