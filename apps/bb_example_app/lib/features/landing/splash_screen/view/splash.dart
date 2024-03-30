import 'package:bb_example_app/features/landing/splash_screen/controller/splash_controller.dart';
import 'package:bb_example_app/product/base/base_view.dart';
import 'package:bb_example_app/product/base/components/general_loading_view.dart';
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
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: BaseView(
        controller: controller,
        loadingView: const Center(
          child: Column(
            children: [
              Spacer(),
              GeneralLoadingView(),
              Spacer(),
            ],
          ),
        ),
        child: const SizedBox.shrink(),
      ),
    );
  }
}
