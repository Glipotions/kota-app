import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/main/profile_screen/controller/profile_controller.dart';
import 'package:kota_app/product/base/base_view.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/widgets/app_bar/general_app_bar.dart';
import 'package:values/values.dart';

part 'components/balance_card.dart';
part 'components/option_tile.dart';

class Profile extends StatelessWidget {
  const Profile({required this.controller, super.key});

  final ProfileController controller;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: const GeneralAppBar(title: 'Profil'),
      body: BaseView<ProfileController>(
        controller: controller,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(ModulePadding.s.value),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(()=>_BalanceCard(
                  balance: controller.balance.balance ?? 0,
                  title: controller.balance.firma ?? '',
                  onTap: controller.onTapPastTransactions,
                ),),
                SizedBox(
                  height: ModulePadding.xxs.value,
                ),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = controller.profileOptions[index];
                      return _OptionTile(item: item,);
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(height: ModulePadding.xxs.value),
                    itemCount: controller.profileOptions.length,
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
