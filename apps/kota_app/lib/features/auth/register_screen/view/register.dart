import 'package:flutter/material.dart';
import 'package:kota_app/features/auth/register_screen/controller/register_controller.dart';
import 'package:kota_app/product/base/base_view.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/widgets/button/clickable_text.dart';
import 'package:kota_app/product/widgets/button/module_button.dart';
import 'package:kota_app/product/widgets/input/module_text_field.dart';
import 'package:values/values.dart';

part 'components/register_form.dart';

class Register extends StatelessWidget {
  const Register({required this.controller, super.key});

  final RegisterController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      body: BaseView<RegisterController>(
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
                  child: _RegisterForm(controller: controller),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
