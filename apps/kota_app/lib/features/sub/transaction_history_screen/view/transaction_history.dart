import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/sub/transaction_history_screen/controller/transaction_history_controller.dart';
import 'package:kota_app/product/base/base_view.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/widgets/other/empty_view.dart';
import 'package:values/values.dart';

part 'components/transaction_card.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({required this.controller, super.key});

  final TransactionHistoryController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text('Cari Hareketler'),
      ),
      body: BaseView<TransactionHistoryController>(
        controller: controller,
        child: Padding(
          padding: EdgeInsets.all(ModulePadding.s.value),
          child: Column(
            children: [
              Obx(
                () => Flexible(
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: controller.scrollController,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final item = controller.transactionItems[index];
                      return Column(
                        children: [
                          _TransactionCard(
                            item: item,
                          ),
                          Obx(
                            () => Padding(
                              padding:
                                  EdgeInsets.only(top: ModulePadding.m.value),
                              child: const CircularProgressIndicator.adaptive(),
                            ).isVisible(
                              value: controller.isPaginationLoading &&
                                  index ==
                                      controller.transactionItems.length - 1,
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (content, index) =>
                        SizedBox(height: ModulePadding.xxs.value),
                    itemCount: controller.transactionItems.length,
                  ),
                ).isVisible(
                  value: controller.transactionItems.isNotEmpty,
                  child: const EmptyView(
                    message: 'Geçmiş hareket bulunmamaktadır.',
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
