import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/sub/manage_account_screen/controller/manage_account_controller.dart';
import 'package:kota_app/features/sub/manage_account_screen/view/manage_account.dart';

class ManageAccountScreen extends StatelessWidget {
  const ManageAccountScreen({
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      tag: UniqueKey().toString(),
      init: ManageAccountController(),
      builder: (controller) => ManageAccount(controller: controller),
    );
  }
}
