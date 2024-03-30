import 'package:bb_example_admin_panel/features/navigation/main_screen/controller/main_controller.dart';
import 'package:bb_example_admin_panel/product/utility/enums/module_padding_enums.dart';
import 'package:bb_example_admin_panel/product/widgets/image/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:values/values.dart';

part 'components/side_menu.dart';

class MainView extends StatelessWidget {
  const MainView({required this.child, required this.controller, super.key});

  final Widget child;
  final MainController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      drawer: _SideMenu(
        items: controller.tabs(context),
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ 
            if (ResponsiveBreakpoints.of(context).largerThan(TABLET))
              Expanded(
                child: _SideMenu(
                  items: controller.tabs(context),
                ),
              ),
            Expanded(
              flex: 5,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
