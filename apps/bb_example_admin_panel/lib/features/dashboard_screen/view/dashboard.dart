import 'package:bb_example_admin_panel/features/dashboard_screen/controller/dashboard_controller.dart';
import 'package:bb_example_admin_panel/product/base/base_view.dart';
import 'package:bb_example_admin_panel/product/utility/enums/module_padding_enums.dart';
import 'package:bb_example_admin_panel/product/widgets/layout/header.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:values/values.dart';

// part 'components/character_card.dart';

///Widget for Dashboard Screen View
class Dashboard extends StatelessWidget {
  ///Widget for Dashboard Screen View
  const Dashboard({required this.controller, super.key});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,

      ///Body
      body: BaseView<DashboardController>(
        controller: controller,
        child: Padding(
          padding: EdgeInsets.all(
            rf.ResponsiveValue<double>(
              context,
              defaultValue: ModulePadding.xxl.value,
              conditionalValues: [
                rf.Condition.smallerThan(
                  value: ModulePadding.s.value,
                  name: rf.TABLET,
                ),
              ],
            ).value,
          ),
          child: Column(
            children: [
              Header(
                title: context.i10n.dashboard,
              ),
              SizedBox(height: ModulePadding.s.value),
              // Expanded(
              //   child: Obx(
              //     () => rf.ResponsiveGridView.builder(
              //       gridDelegate: const rf.ResponsiveGridDelegate(
              //         minCrossAxisExtent: 100,
              //         maxCrossAxisExtent: 500,
              //         mainAxisSpacing: 16,
              //         crossAxisSpacing: 16,
              //         childAspectRatio: 1.8,
              //       ),
              //       itemCount: controller.characters.results?.length ?? 0,
              //       shrinkWrap: true,
              //       itemBuilder: (context, index) {
              //         final item = controller.characters.results![index];
              //         return _CharacterCard(item: item).slideAnimation(
              //           order: 2,
              //         );
              //       },
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
