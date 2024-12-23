import 'package:flutter/material.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/utility/enums/module_radius_enums.dart';

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
    this.backgroundColor,
    this.labelColor,
  });

  final String title;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool enabled;
  final EdgeInsets? insidePadding;
  final Widget? action;
  final double? borderWidth;
  final Color? backgroundColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: SizedBox(
        height: 35,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor ??
                (enabled
                    ? isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.primary.withOpacity(.5)
                    : Theme.of(context).colorScheme.primary.withOpacity(.5)),
            borderRadius: BorderRadius.circular(ModuleRadius.xxl.value),
            border: isSelected
                ? Border.all(
                    width: 1.5,
                  )
                : Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: borderWidth ?? 1,
                  ),
            boxShadow: isSelected
                ? [
                   const BoxShadow(
                      color: Colors.white,
                    ),
                    BoxShadow(
                      color: (backgroundColor ?? Theme.of(context).colorScheme.primary).withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
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
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: labelColor ??
                              (enabled
                                  ? isSelected
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.primary),
                        ),
                  ),
                  if (action != null) ...[
                    const SizedBox(width: 4),
                    action!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
