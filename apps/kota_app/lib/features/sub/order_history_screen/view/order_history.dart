import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/sub/order_history_screen/controller/order_history_controller.dart';
import 'package:kota_app/product/base/base_view.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/widgets/chip/custom_choice_chip.dart';
import 'package:kota_app/product/widgets/other/empty_view.dart';
import 'package:values/values.dart';

part 'components/order_card.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({required this.controller, super.key});

  final OrderHistoryController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text('Geçmiş Siparişler'),
      ),
      body: BaseView<OrderHistoryController>(
        controller: controller,
        child: Padding(
          padding: EdgeInsets.all(ModulePadding.s.value),
          child: Column(
            children: [
              Obx(
                () => Flexible(
                  child: ListView.separated(
                    controller: controller.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final item = controller.orderItems[index];
                      return Column(
                        children: [
                          _OrderCard(
                            item: item,
                          ),
                          Obx(
                            () => Padding(
                              padding:
                                  EdgeInsets.only(top: ModulePadding.m.value),
                              child: const CircularProgressIndicator.adaptive(),
                            ).isVisible(
                              value: controller.isPaginationLoading &&
                                  index == controller.orderItems.length - 1,
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (content, index) =>
                        SizedBox(height: ModulePadding.xxs.value),
                    itemCount: controller.orderItems.length,
                  ),
                ).isVisible(
                  value: controller.orderItems.isNotEmpty,
                  child: const EmptyView(
                    message: 'Geçmiş sipariş bulunmamaktadır.',
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
