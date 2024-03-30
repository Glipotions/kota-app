import 'package:bb_example_admin_panel/features/navigation/main_screen/controller/main_controller.dart';
import 'package:bb_example_admin_panel/product/utility/enums/module_padding_enums.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

class Header extends StatelessWidget {
  const Header({
    required this.title,
    super.key,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        rf.ResponsiveVisibility(
          hiddenConditions: [
            rf.Condition.largerThan(
              name: rf.TABLET,
              value: false,
            ),
          ],
          child: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              final mainCont = Get.find<MainController>();
              if (!mainCont.scaffoldKey.currentState!.isDrawerOpen) {
                mainCont.scaffoldKey.currentState!.openDrawer();
              }
            },
          ),
        ),
        rf.ResponsiveVisibility(
          hiddenConditions: [
            rf.Condition.smallerThan(
              name: rf.TABLET,
              value: false,
            ),
          ],
          child: Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        rf.ResponsiveVisibility(
          visibleConditions: [
            rf.Condition.smallerThan(
              name: rf.TABLET,
              value: false,
            ),
          ],
          child: const Spacer(),
        ),
        DropdownButton(
          icon: const Icon(Icons.language),
          items: supportedLocalization.values
              .map(
                (e) => DropdownMenuItem(
                  value: e.lanCode,
                  child: Text(e.localizationTitle),
                ),
              )
              .toList(),
          onChanged: (lanCode) =>
              AppStateController.instance.setLocale(lanCode!),
          value: AppStateController.instance.getCurrentLanCode,
        ),
        SizedBox(
          width: rf.ResponsiveValue<double>(
            context,
            conditionalValues: [
              rf.Condition.smallerThan(
                value: ModulePadding.s.value,
                name: rf.TABLET,
              ),
            ],
            defaultValue: ModulePadding.xxl.value,
          ).value,
        ),
        Switch(
          value: false,
          onChanged: (_) {
            AppStateController.instance.setTheme(
              colorPalette: AppStateController.instance.getCurrentThemeCode ==
                      DarkColors().themeCode
                  ? LightColors()
                  : DarkColors(),
            );
          },
        ),
      ],
    );
  }
}
