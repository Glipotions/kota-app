
import 'package:bb_example_admin_panel/product/navigation/routing_manager.dart';
import 'package:bb_example_admin_panel/product/utility/enums/module_padding_enums.dart';
import 'package:flutter/material.dart';
import 'package:values/values.dart';
import 'package:widgets/widget.dart';


/// A custom implementation of [BaseMessageWidget] for displaying
///  styled toast messages.
class ModuleToastMessage extends BaseMessageWidget {
  /// Constructs a [ModuleToastMessage] with the required parameters.
  ///
  /// The [backgroundColor] is the background color of the message card.
  /// associated with the message.
  const ModuleToastMessage({
    required this.backgroundColor,
    required this.svg,
    this.msg,
    super.key,
  });

    factory ModuleToastMessage.error() {
    return ModuleToastMessage(
      backgroundColor: RoutingManager.instance.context!.error,
      svg: const IconAssets().outlineDoneIcon.svg(
            height: 24,
            width: 24,
            color: RoutingManager.instance.context!.primary,
          ),
    );
  }

  /// Creates a [ModuleToastMessage] with a success theme.
  factory ModuleToastMessage.success() {
    return ModuleToastMessage(
      backgroundColor: Colors.green.withOpacity(0.5),
      svg: const IconAssets().circleDoneIcon.svg(
            height: 24,
            width: 24,
            color: RoutingManager.instance.context!.primary,
          ),
    );
  }

  /// Creates a [ModuleToastMessage] with a warning theme.
  factory ModuleToastMessage.warning() {
    return ModuleToastMessage(
      backgroundColor: const Color(0xffFFFCF2),
      svg: const IconAssets().warningIcon.svg(
            height: 24,
            width: 24,
            color: RoutingManager.instance.context!.primary,
          ),
    );
  }

  /// The background color of the message card.
  final Color backgroundColor;

  /// The SVG string representing an icon associated with the message.
  final Widget svg;

  /// Message to display on toast message.
  final String? msg;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(ModulePadding.xxs.value),
      child: Card(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ModulePadding.s.value),
        ),
        child: Padding(
          padding: EdgeInsets.all(ModulePadding.s.value),
          child: Row(
            children: [
              svg,
              SizedBox(width: ModulePadding.xxs.value),
              Flexible(
                child: Text(
                  message ?? '',
                  maxLines: 2,
                  style: context.labelMedium.copyWith(
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  BaseMessageWidget copyWith({String? message}) {
    return ModuleToastMessage(
      backgroundColor: backgroundColor,
      svg: svg,
      msg: message,
    );
  }
}
