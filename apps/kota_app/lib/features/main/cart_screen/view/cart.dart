// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/product/managers/cart_controller.dart';
import 'package:kota_app/product/models/cart_product_model.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/utility/enums/module_radius_enums.dart';
import 'package:kota_app/product/widgets/button/clickable_text.dart';
import 'package:kota_app/product/widgets/button/module_button.dart';
import 'package:kota_app/product/widgets/card/bordered_image.dart';
import 'package:kota_app/product/widgets/other/empty_view.dart';
import 'package:values/values.dart';

part 'components/product_card.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  Future<void> _showClearCartDialog(BuildContext context, CartController controller) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            'Sepeti Temizle',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          content: Text(
            'Sepetteki tüm ürünleri silmek istediğinizden emin misiniz?',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'İptal',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                'Temizle',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                controller.clearCart();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();

    return Scaffold(
      key: controller.scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Sepetim',
          style: context.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          Obx(() => controller.itemList.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _showClearCartDialog(context, controller),
                )
              : const SizedBox()),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Obx(
        () => AnimatedSlide(
          duration: const Duration(milliseconds: 300),
          offset: controller.itemList.isEmpty ? const Offset(0, 2) : Offset.zero,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: controller.itemList.isEmpty ? 0 : 1,
            child: Padding(
              padding: EdgeInsets.all(ModulePadding.s.value),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(ModulePadding.s.value),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(ModuleRadius.m.value),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Toplam Tutar:',
                              style: context.titleMedium,
                            ),
                            Obx(
                              () => Text(
                                controller.totalAmount().formatPrice(),
                                style: context.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ModulePadding.s.value),
                        Obx(() => Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.note_add_outlined,
                                  color: Theme.of(context).primaryColor,
                                ),
                                SizedBox(width: ModulePadding.xs.value),
                                Text(
                                  'Sipariş Notu',
                                  style: context.titleSmall,
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () => controller.isDescriptionVisible.toggle(),
                                  icon: Icon(
                                    controller.isDescriptionVisible.value
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                  ),
                                ),
                              ],
                            ),
                            if (controller.isDescriptionVisible.value) ...[
                              SizedBox(height: ModulePadding.xs.value),
                              TextField(
                                controller: controller.descriptionController,
                                decoration: InputDecoration(
                                  hintText: 'Siparişiniz için not ekleyin...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(ModuleRadius.s.value),
                                  ),
                                ),
                                maxLines: 3,
                              ),
                              SizedBox(height: ModulePadding.s.value),
                            ],
                          ],
                        )),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ModuleButton.primary(
                            onTap: controller.onTapCompleteOrder,
                            title: 'Siparişi Tamamla',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Obx(
        () => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: controller.itemList.isEmpty
                    ? const EmptyView(
                        message:
                            'Sepete ürün eklenmemiştir.\nSepete eklediğiniz bütün ürünler burada listelenecektir!',
                      )
                    : Padding(
                        padding: EdgeInsets.all(ModulePadding.s.value),
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final item = controller.itemList[index];
                            return Dismissible(
                              key: Key(item.id.toString()),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: ModulePadding.m.value),
                                color: Colors.red,
                                child: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (direction) => 
                                controller.onTapRemoveProduct(item),
                              child: _ProductCard(
                                item: item,
                                onTapRemove: () => controller.onTapRemoveProduct(item),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: ModulePadding.xs.value,
                          ),
                          itemCount: controller.itemList.length,
                        ),
                      ),
              ),
            ),
            // Add extra space at bottom for the floating action button
            SliverToBoxAdapter(
              child: SizedBox(height: 120),
            ),
          ],
        ),
      ),
    );
  }
}
