import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/sub/current_account_screen/controller/current_account_controller.dart';
import 'package:kota_app/features/sub/current_account_screen/view/current_account.dart';
import 'package:kota_app/product/utility/enums/general.dart';

class CurrentAccountScreen extends StatelessWidget {
  const CurrentAccountScreen({required this.pageStatusEnum, super.key});
  final ScreenArgumentEnum pageStatusEnum;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CurrentAccountController(pageStatusEnum: pageStatusEnum),
      builder: (_) => CurrentAccount(pageStatusEnum: pageStatusEnum),
    );
  }
}