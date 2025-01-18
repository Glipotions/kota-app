// // ignore_for_file: lines_longer_than_80_chars

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:kota_app/product/managers/cart_controller.dart';
// import 'package:kota_app/product/models/cart_product_model.dart';
// import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
// import 'package:kota_app/product/utility/enums/module_radius_enums.dart';
// import 'package:kota_app/product/widgets/button/module_button.dart';
// import 'package:kota_app/product/widgets/card/bordered_image.dart';
// import 'package:kota_app/product/widgets/other/empty_view.dart';
// import 'package:values/values.dart';

// // part 'components/product_card.dart';

// class Cart extends StatelessWidget {
//   const Cart({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<CartController>();

//     return Scaffold(
//       key: controller.scaffoldKey,
//       appBar: AppBar(
//         title: const Text('Sepetim'),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: Obx(
//         () => Padding(
//           padding: EdgeInsets.all(ModulePadding.s.value),
//           child: SizedBox(
//             width: double.infinity,
//             child: ModuleButton.primary(
//               onTap: () => controller.onTapCompleteOrder(context),
//               title: 'Siparişi Tamamla',
//             ),
//           ),
//         ).isVisible(value: controller.itemList.isNotEmpty),
//       ),
//       body: Obx(
//         () => Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Obx(
//               () => Text(
//                 'Toplam Tutar: ${controller.totalAmount().formatPrice()}',
//                 style: context.headlineSmall,
//               ),
//             ),
//             ListView.separated(
//               shrinkWrap: true,
//               padding: EdgeInsets.all(ModulePadding.s.value),
//               itemBuilder: (context, index) {
//                 final item = controller.itemList[index];
//                 return _ProductCard(
//                   item: item,
//                   onTapRemove: () => controller.onTapRemoveProduct(item),
//                 );
//               },
//               separatorBuilder: (context, index) => SizedBox(
//                 height: ModulePadding.xs.value,
//               ),
//               itemCount: controller.itemList.length,
//             ),
//           ],
//         ).isVisible(
//           value: controller.itemList.isNotEmpty,
//           child: const EmptyView(
//             message:
//                 'Sepete ürün eklenmemiştir.\nSepete eklediğiniz bütün ürünler burada listelenecektir!',
//           ),
//         ),
//       ),
//     );
//   }
// }
