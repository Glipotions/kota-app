import 'package:bb_example_app/product/utility/enums/module_padding_enums.dart';
import 'package:bb_example_app/product/utility/enums/module_radius_enums.dart';
import 'package:flutter/material.dart';

class CustomChoiceChip extends StatelessWidget {
  const CustomChoiceChip({
    required this.title,
    required this.isSelected,
    this.enabled = true,
    super.key,
    this.onTap,
    this.insidePadding,
    this.borderWidth,
    this.action,
  });

  final String title;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool enabled;
  final EdgeInsets? insidePadding;
  final Widget? action;
  final double? borderWidth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: SizedBox(
        height: 35,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: enabled
                ? isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.primary.withOpacity(.3)
                : Theme.of(context)
                    .colorScheme
                    .primary
                    .withOpacity(.3), // etkin değilse opacity azaltılır
            borderRadius: BorderRadius.circular(ModuleRadius.xxl.value),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Theme.of(context).colorScheme.surface,
              width: borderWidth ?? 2,
            ),
          ),
          child: Padding(
            padding: insidePadding ??
                EdgeInsets.symmetric(horizontal: ModulePadding.xxs.value),
            child: Center(
              widthFactor: 1,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: enabled
                            ? isSelected
                                ? Theme.of(context).colorScheme.background
                                : null
                            : Theme.of(context)
                                .colorScheme
                                .background
                                .withOpacity(
                                    .5,),), // etkin değilse renk azaltılır
                    textAlign: TextAlign.center,
                  ),
                  if (action != null)
                    Padding(
                      padding: EdgeInsets.only(left: ModulePadding.xxxs.value),
                      child: action,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
