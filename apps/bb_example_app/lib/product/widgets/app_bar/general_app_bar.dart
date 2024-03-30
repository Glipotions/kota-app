import 'package:bb_example_app/features/navigation/bottom_navigation_bar/controller/bottom_navigation_controller.dart';
import 'package:bb_example_app/product/managers/cart_controller.dart';
import 'package:bb_example_app/product/utility/enums/module_padding_enums.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    final controller = Get.find<CartController>();
    return AppBar(
      forceMaterialTransparency: true,
      title: Text(title),
      leading: leading,
      actions: [
        additionalIcon ?? const SizedBox(),
        Obx(
          () => IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: controller.itemList.isNotEmpty ? context.primary : null,
            ),
            onPressed: () =>
                Get.find<BottomNavigationController>().onTapBottomBarItem(1),
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
