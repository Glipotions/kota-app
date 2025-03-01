import 'package:api/api.dart';
import 'package:common/common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/sub/current_account_screen/view/current_account.dart';
import 'package:kota_app/features/sub/order_history_screen/controller/order_history_controller.dart';
import 'package:kota_app/product/base/base_view.dart';
import 'package:kota_app/product/consts/claims.dart';
import 'package:kota_app/product/utility/enums/general.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/utility/extentions/index.dart';
import 'package:kota_app/product/widgets/other/empty_view.dart';
import 'package:values/values.dart';

part 'components/order_card.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({required this.controller, super.key});

  final OrderHistoryController controller;

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalization.getLabels(context);
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(labels.orderHistory),
        actions: [
          if (controller.sessionHandler.hasClaim(saleInvoiceAdminClaim))
            IconButton(
              icon: const Icon(Icons.account_balance),
              onPressed: () async {
                final result = await Navigator.push<GetCurrentAccount>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CurrentAccount(
                      pageStatusEnum: ScreenArgumentEnum.SelectToBack,
                    ),
                  ),
                );
                if (result != null) {
                  await controller.onCurrentAccountSelected(result);
                }
              },
            ),
        ],
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
                            controller: controller,
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
                  child: EmptyView(
                    message: labels.noOrders,
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
