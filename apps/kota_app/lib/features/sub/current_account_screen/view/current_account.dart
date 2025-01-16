import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/sub/current_account_screen/controller/current_account_controller.dart';
import 'package:kota_app/features/sub/current_account_screen/view/current_account_information_card.dart';
import 'package:kota_app/product/utility/enums/general.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/widgets/app_bar/general_app_bar.dart';
import 'package:values/values.dart';

class CurrentAccount extends StatelessWidget {
  const CurrentAccount({Key? key, required this.pageStatusEnum})
      : super(key: key);
  final ScreenArgumentEnum pageStatusEnum;

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<CurrentAccountController>();
    final controller =
        Get.put(CurrentAccountController(pageStatusEnum: pageStatusEnum));

    return Scaffold(
      key: controller.scaffoldKey,
      appBar: const GeneralAppBar(
        title: 'Cari Hesap Listesi',
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(ModulePadding.m.value),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Ara',
              ),
              onChanged: (text) async {
                await controller.filterList(text);
              },
            ),
          ),
          Expanded(
            child: Obx(
              () => controller.loadingStatus != LoadingStatus.loaded
                  ? const SizedBox()
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ModulePadding.m.value,),
                      child: RefreshIndicator(
                        onRefresh: controller.refreshPage,
                        child: Obx(() => ListView.separated(
                          controller: controller.scrollController,
                          itemBuilder: (context, index) {
                            if (index == controller.currentAccounts.length &&
                                controller.hasMoreData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (index < controller.currentAccounts.length &&
                                !controller.isPaginationLoading) {
                              final item = controller.currentAccounts[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                    top: ModulePadding.xxs.value,),
                                child: CurrentAccountInformationCard(
                                  onTap: controller.onTapCard,
                                  id: item.id!,
                                  cariHesapAdi: item.firma,
                                  caseType: '',
                                  balance: item.bakiye,
                                  foreignBalance: item.dovizliBakiye,
                                  aciklama: item.aciklama,
                                  code: item.kod!,
                                ),
                              );
                            } else if (!controller.hasMoreData) {
                              return const Center(
                                  child: Text(
                                'Daha fazla veri yok.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),);
                            }
                            return null;
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: ModulePadding.xxs.value,
                          ),
                          itemCount: controller.pageCount.value + 1,
                        ),),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
