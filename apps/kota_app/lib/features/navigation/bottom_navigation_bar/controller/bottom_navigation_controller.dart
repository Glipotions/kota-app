import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/navigation/modules/bottom_navigation_route/bottom_navigation_route_enums.dart';

///Controller for BottomNavigationBar
class BottomNavigationController extends BaseControllerInterface {
  final Rx<int> _selectedIndex = Rx(0);

  ///Getter for [_selectedIndex]
  int get selectedIndex => _selectedIndex.value;

  ///Setter for [_selectedIndex]
  set selectedIndex(int value) => _selectedIndex.value = value;

  ///Items to display on bottom bar.
  List<MyCustomBottomNavBarItem> tabs (BuildContext localeContext) => [
        MyCustomBottomNavBarItem(
          icon: const Icon(Icons.home),
          activeIcon: const Icon(Icons.home),
          label: 'Ana Sayfa',
          location: BottomNavigationRouteEnum.allProductsScreen.name,
        ),
        MyCustomBottomNavBarItem(
          icon: const Icon(Icons.shopping_cart),
          activeIcon: const Icon(Icons.shopping_cart),
          label: 'Sepetim',
          location: BottomNavigationRouteEnum.cartScreen.name,
        ),
        MyCustomBottomNavBarItem(
          icon: const Icon(Icons.person),
          activeIcon: const Icon(Icons.person),
          label: 'Profil',
          location: BottomNavigationRouteEnum.profileScreen.name,
        ),
      ];

  ///Function that handles bottom bar taps.
  void onTapBottomBarItem(int index) {
    if (index == selectedIndex) return;
    final location = tabs(context)[index].location;
    selectedIndex = index;
    context.goNamed(location);
  }
}

///Class that has all required fields for BottomNavigationBar
class MyCustomBottomNavBarItem extends BottomNavigationBarItem {
  ///Class that has all required fields for BottomNavigationBar
  const MyCustomBottomNavBarItem({
    required this.location,
    required super.icon,
    super.label,
    Widget? activeIcon,
  }) : super(activeIcon: activeIcon ?? icon);

  ///Variable that holds location for GoRouter
  final String location;
}
