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
      appBar: GeneralAppBar(
        title: 'Profil',
        leading: const SizedBox(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: BaseView<ProfileController>(
        controller: controller,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ModulePadding.s.value,
                vertical: ModulePadding.xs.value,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // User info section if needed
                  Obx(
                    () => _BalanceCard(
                      balance: controller.balance.balance ?? 0,
                      title: controller.balance.firma ?? '',
                      onTap: controller.onTapPastTransactions,
                    ),
                  ),
                  SizedBox(height: ModulePadding.m.value),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = controller.profileOptions[index];
                        return _OptionTile(item: item);
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: ModulePadding.xs.value),
                      itemCount: controller.profileOptions.length,
                    ),
                  ),
                  // Bottom padding for better scroll experience
                  SizedBox(height: ModulePadding.s.value),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
