import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/sub/order_history_detail_screen/view/components/product_card.dart';
import 'package:kota_app/product/base/base_view.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/widgets/app_bar/general_app_bar.dart';
import 'package:kota_app/product/widgets/other/empty_view.dart';
import 'package:values/values.dart';

// ignore: always_use_package_imports
import '../controller/order_history_detail_controller.dart';

class OrderHistoryDetail extends StatelessWidget {
  const OrderHistoryDetail({required this.controller, super.key});

  final OrderHistoryDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: GeneralAppBar(title: AppLocalization.getLabels(context).orderDetail),
      body: BaseView<OrderHistoryDetailController>(
        controller: controller,
        child: Padding(
          padding: EdgeInsets.all(ModulePadding.s.value),
          child: Column(
            children: [
              Obx(
                () => Flexible(
                  child: ListView.separated(
                    itemCount: controller.cartProductItems.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        item: controller.cartProductItems[index],
                        isCurrencyTL: controller.isCurrencyTL,
                        onTap: () {
                          // Handle onTap action here
                        },
                        onTapRemove: () {
                          // Handle onTapRemove action here
                        },
                      );
                    },
                    separatorBuilder: (content, index) =>
                        SizedBox(height: ModulePadding.xxs.value),
                  ),
                ).isVisible(
                  value: controller.cartProductItems.isNotEmpty,
                  child: EmptyView(
                    message: AppLocalization.getLabels(context).noOrderDetail,
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
