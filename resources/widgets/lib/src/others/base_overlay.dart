import 'package:flutter/material.dart';
import 'package:overlay_kit/overlay_kit.dart';

class BaseOverlay extends StatelessWidget {
  const BaseOverlay({
    required this.child, super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return OverlayKit(child: child);
  }
}
