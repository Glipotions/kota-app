import 'package:api/api.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/sub/transaction_history_screen/controller/transaction_history_controller.dart';
import 'package:kota_app/product/base/base_view.dart';
import 'package:kota_app/product/utility/enums/currency_type.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/utility/extentions/num_extension.dart';
import 'package:kota_app/product/widgets/app_bar/general_app_bar.dart';
import 'package:kota_app/product/widgets/other/empty_view.dart';
import 'package:values/values.dart';

part 'components/transaction_card.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({required this.controller, super.key});

  final TransactionHistoryController controller;

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalization.getLabels(context);
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: GeneralAppBar(
        title: labels.transactionHistory,
        showCartIcon: false,
        additionalIcon: IconButton(
          icon: const Icon(Icons.picture_as_pdf),
          onPressed: () => controller.generatePdfReport(
            context,
            '',
            controller.transactionItems,
            false,
          ),
        ),
      ),
      body: BaseView<TransactionHistoryController>(
        controller: controller,
        child: Column(
          children: [
            // Account Summary Card
            Card(
              margin: EdgeInsets.all(ModulePadding.s.value),
              child: Padding(
                padding: EdgeInsets.all(ModulePadding.m.value),
                child: Column(
                  children: [
                    Obx(
                      () => Text(
                        controller.currentBalance.formatPrice(),
                        style: context.headlineMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: ModulePadding.xs.value),
                    Text(
                      labels.currentBalance,
                      style: context.titleSmall.copyWith(
                        color: context.secondary.withOpacity(0.7),
                      ),
                    ),
                    SizedBox(height: ModulePadding.m.value),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _SummaryTile(
                            icon: Icons.arrow_upward,
                            color: Colors.green,
                            title: labels.income,
                            amount: controller.totalIncome.formatPrice(),
                          ),
                          _SummaryTile(
                            icon: Icons.arrow_downward,
                            color: Colors.red,
                            title: labels.expense,
                            amount: controller.totalExpense.formatPrice(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search and Filter Bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ModulePadding.s.value,
                vertical: ModulePadding.xxxs.value,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.searchController,
                      decoration: InputDecoration(
                        hintText: labels.searchTransactions,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: controller.onSearchChanged,
                    ),
                  ),
                ],
              ),
            ),

            // Transaction List
            Obx(
              () => Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: controller.transactionItems.isEmpty
                      ? EmptyView(
                          message: labels.noTransactions,
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: controller.scrollController,
                          padding: EdgeInsets.all(ModulePadding.s.value),
                          itemBuilder: (context, index) {
                            if (index == 0 ||
                                controller.shouldShowDateHeader(index)) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: ModulePadding.xs.value,
                                    ),
                                    child: Text(
                                      controller.getDateHeader(index),
                                      style: context.titleSmall.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: context.secondary,
                                      ),
                                    ),
                                  ),
                                  _TransactionCard(
                                    item: controller.transactionItems[index],
                                    currencyType: controller.currencyType,
                                  ),
                                ],
                              );
                            }
                            return _TransactionCard(
                              item: controller.transactionItems[index],
                              currencyType: controller.currencyType,
                            );
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox(height: ModulePadding.xxs.value),
                          itemCount: controller.transactionItems.length,
                        ),
                ),
              ),
            ),

            // Loading Indicator
            Obx(
              () => Padding(
                padding: EdgeInsets.only(top: ModulePadding.m.value),
                child: const CircularProgressIndicator.adaptive(),
              ).isVisible(value: controller.isPaginationLoading),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.amount,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(ModulePadding.xs.value),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        SizedBox(height: ModulePadding.xxs.value),
        Text(
          title,
          style: context.bodySmall.copyWith(
            color: context.secondary.withOpacity(0.7),
          ),
        ),
        SizedBox(height: ModulePadding.xxs.value),
        Text(
          amount,
          style: context.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
