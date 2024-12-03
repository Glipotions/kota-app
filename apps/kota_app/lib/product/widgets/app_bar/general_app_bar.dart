import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:kota_app/features/navigation/bottom_navigation_bar/controller/bottom_navigation_controller.dart';
import 'package:kota_app/product/managers/cart_controller.dart';
import 'package:kota_app/product/navigation/modules/bottom_navigation_route/bottom_navigation_route_enums.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:values/values.dart';

class GeneralAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GeneralAppBar({
    required this.title,
    super.key,
    this.additionalIcon,
    this.leading,
  });
  final String title;
  final Widget? additionalIcon;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());
    final bottomNavController = Get.find<BottomNavigationController>();
    
    return AppBar(
      forceMaterialTransparency: true,
      title: Text(title),
      leading: leading ?? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        additionalIcon ?? const SizedBox(),
        Obx(
          () => IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: cartController.itemList.isNotEmpty ? context.primary : null,
            ),
            onPressed: () {
              // Pop until we reach the bottom navigation route
              Navigator.of(context).popUntil((route) => route.isFirst);
              // Then navigate to cart
              context.goNamed(BottomNavigationRouteEnum.cartScreen.name);
              bottomNavController.selectedIndex = 1;
            },
          ),
        ),
        SizedBox(
          width: ModulePadding.s.value,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(SizeConfig.appBarHeight);
}
