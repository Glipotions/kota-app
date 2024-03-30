import 'package:bb_example_admin_panel/product/utility/enums/module_padding_enums.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

extension ContextExtension on BuildContext {
  
  double conditionalPadding() {
    return ResponsiveValue<double>(
      this,
      defaultValue: ModulePadding.xxl.value,
      conditionalValues: [
        Condition.smallerThan(
          value: ModulePadding.s.value,
          name: TABLET,
        ),
      ],
    ).value;
  }
  
}
