import 'package:bb_example_admin_panel/product/utility/enums/module_padding_enums.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:values/values.dart';

/// Screen to show when called route is not exist
class UnknownRouteScreen extends StatelessWidget {
  /// Screen to show when called route is not exist
  const UnknownRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const IconAssets().outlineErrorIcon.svg(color: context.primary),
            SizedBox(height: ModulePadding.m.value),
            Text(
              AppLocalization.getLabels(context).unknownPageRouteMessageText,
              style: context.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
