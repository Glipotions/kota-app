import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:kota_app/features/auth/login_screen/controller/login_controller.dart';
import 'package:kota_app/product/base/base_view.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/widgets/button/clickable_text.dart';
import 'package:kota_app/product/widgets/button/module_button.dart';
import 'package:kota_app/product/widgets/input/module_text_field.dart';
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ImageAssets().exampleImage.image(
                      fit: BoxFit.cover,
                    ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(ModulePadding.s.value),
                    child: _LoginForm(controller: controller),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
