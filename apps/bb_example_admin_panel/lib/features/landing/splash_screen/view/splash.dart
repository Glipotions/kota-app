import 'package:bb_example_admin_panel/features/landing/splash_screen/controller/splash_controller.dart';
import 'package:bb_example_admin_panel/product/base/base_view.dart';
import 'package:bb_example_admin_panel/product/base/components/general_loading_view.dart';
import 'package:bb_example_admin_panel/product/utility/enums/module_padding_enums.dart';
import 'package:flutter/material.dart';

///Widget for Splash Screen View
class Splash extends StatelessWidget {
  ///Widget for Splash Screen View
  const Splash({
    required this.controller,
    super.key,
  });

  ///It takes controller as parameter to avoid duplicate
  ///controller error. When restarting the app etc.
  final SplashController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      body: BaseView(
        controller: controller,
        loadingView: Center(
          child: Column(
            children: [
              const Spacer(),
              SizedBox(height: ModulePadding.l.value),
              const GeneralLoadingView(),
              const Spacer(),
            ],
          ),
        ),
        child: const SizedBox.shrink(),
      ),
    );
  }
}
