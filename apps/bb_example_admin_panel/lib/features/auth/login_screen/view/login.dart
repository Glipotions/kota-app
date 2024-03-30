import 'package:bb_example_admin_panel/features/auth/login_screen/controller/login_controller.dart';
import 'package:bb_example_admin_panel/product/base/base_view.dart';
import 'package:bb_example_admin_panel/product/utility/enums/module_padding_enums.dart';
import 'package:bb_example_admin_panel/product/widgets/button/module_button.dart';
import 'package:bb_example_admin_panel/product/widgets/image/circular_image.dart';
import 'package:bb_example_admin_panel/product/widgets/input/module_text_field.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:values/values.dart';

part 'components/login_form.dart';

///Widget for Login Screen View
class Login extends StatelessWidget {
  ///Widget for Login Screen View
  const Login({required this.controller, super.key});

  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.unFocus,
      child: Scaffold(
        key: controller.scaffoldKey,

        ///Body
        body: BaseView<LoginController>(
          controller: controller,
          child: ResponsiveRowColumn(
            rowCrossAxisAlignment: CrossAxisAlignment.stretch,
            columnCrossAxisAlignment: CrossAxisAlignment.stretch,
            layout: ResponsiveBreakpoints.of(context).largerThan(TABLET)
                ? ResponsiveRowColumnType.ROW
                : ResponsiveRowColumnType.COLUMN,
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 1,
                columnFlex: 2,
                columnFit: FlexFit.tight,
                rowFit: FlexFit.tight,
                child: ResponsiveValue<Widget>(
                  context,
                  defaultValue: Padding(
                    padding: EdgeInsets.only(top:ModulePadding.s.value),
                    child: CirclularImage(
                      assetImage: const ImageAssets().exampleImage,
                    ),
                  ),
                  conditionalValues: [
                    Condition.largerThan(
                      value: const ImageAssets().exampleImage.image(
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                      name: TABLET,
                    ),
                  ],
                ).value,
              ),
              ResponsiveRowColumnItem(
                columnFlex: 5,
                rowFlex: 1,
                columnFit: FlexFit.tight,
                rowFit: FlexFit.tight,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(
                      ResponsiveValue<double>(
                        context,
                        defaultValue: ModulePadding.s.value,
                        conditionalValues: [
                          Condition.largerThan(
                            value: ModulePadding.xxl.value,
                            name: TABLET,
                          ),
                        ],
                      ).value,
                    ),
                    child: _LoginForm(controller: controller),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
