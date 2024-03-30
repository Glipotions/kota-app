import 'package:bb_example_app/product/navigation/routing_manager.dart';
import 'package:flutter/material.dart';
import 'package:values/values.dart';
import 'package:widgets/widget.dart';

/// Internal widget for handling the button
class ModuleButton extends StatelessWidget {
  // Constructor for other types of buttons can be added as needed

  /// Generates [ModuleButton]
  const ModuleButton({required this.button, super.key});

  
  /// Primary Button for current Module
  factory ModuleButton.primary({
    required VoidCallback onTap,
    required String title,
    Color? bgColor,
    bool enabled=true,
  }) {
    return ModuleButton(
      button: AppBaseButton(
        onTap: onTap,
        txt: title,
        bgColor: enabled ? bgColor : RoutingManager.instance.context!.outline,
      ),
    );
  }

  /// Secondary Button for current Module
  factory ModuleButton.secondary({
    required VoidCallback onTap,
    required String title,
  }) {
    return ModuleButton(
      button: AppBaseButton(
        onTap: onTap,
        txt: title,
        bgColor: RoutingManager.instance.context!.onSecondary,
  
      ),
    );
  }


  ///Button to Display under [ModuleButton]
  ///[AppBaseButton] in our case.
  final Widget button;

  @override
  Widget build(BuildContext context) {
    return button;
  }
}
