import 'package:bb_example_admin_panel/product/utility/enums/module_padding_enums.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:values/values.dart';

///General Error View
class GeneralErrorView extends StatelessWidget {
  ///General Error View
  const GeneralErrorView({
    super.key,
    this.message,
    this.onTapTryAgain,
    this.btnText,
  });

  ///Message to display on screen.
  ///[AppLocalization.getLabels.defaultErrorMessage] if null
  final String? message;

  ///Text to display on button.
  ///[AppLocalization.getLabels.tryAgainText] if null
  final String? btnText;

  ///Function to call when button tapped.
  ///Button is unvisible if null.
  final VoidCallback? onTapTryAgain;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ModulePadding.s.value),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const IconAssets().errorIcon.svg(color: context.primary),
            SizedBox(height: ModulePadding.m.value),
            Text(
              message ?? AppLocalization.getLabels(context).defaultErrorMessage,
              style: context.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ModulePadding.m.value),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: onTapTryAgain,
                child: Text(
                  btnText ?? AppLocalization.getLabels(context).tryAgainBtnText,
                ),
              ),
            ).isVisible(value: onTapTryAgain != null),
          ],
        ),
      ),
    );
  }
}
