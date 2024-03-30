import 'package:bb_example_admin_panel/product/base/controller/base_controller.dart';
import 'package:bb_example_admin_panel/product/managers/auth_handler.dart';
import 'package:bb_example_admin_panel/product/navigation/modules/drawer_route/drawer_route_enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:values/values.dart';
import 'package:widgets/widget.dart';

///Controller for BottomNavigationBar
class MainController extends BaseControllerInterface {
  final Rx<int> _selectedIndex = Rx(0);

  ///Getter for [_selectedIndex]
  int get selectedIndex => _selectedIndex.value;

  ///Setter for [_selectedIndex]
  set selectedIndex(int value) => _selectedIndex.value = value;

  ///Items to display on bottom bar.
  List<DrawerItem>  tabs(BuildContext localeContext) => [
        DrawerItem(
          title: localeContext.i10n.dashboard,
          svg: const IconAssets().circleDoneIcon,
          onTap: () => onTapDrawerOption(0),
          location: DrawerRouteScreens.dashboardScreen.name,
        ),
        DrawerItem(
          title: localeContext.i10n.transaction,
          svg: const IconAssets().circleDoneIcon,
          onTap: () => onTapDrawerOption(1),
          location: DrawerRouteScreens.transactionScreen.name,
        ),
        DrawerItem(
          title: localeContext.i10n.task,
          svg: const IconAssets().circleDoneIcon,
          onTap: () => onTapDrawerOption(2),
          location: DrawerRouteScreens.taskScreen.name,
        ),
        DrawerItem(
          title: localeContext.i10n.document,
          svg: const IconAssets().circleDoneIcon,
          onTap: () => onTapDrawerOption(3),
          location: DrawerRouteScreens.documentScreen.name,
        ),
        DrawerItem(
          title: localeContext.i10n.logout,
          svg: const IconAssets().circleDoneIcon,
          onTap: onTapLogout,
          location: DrawerRouteScreens.documentScreen.name,
        ),
      ];

  void onTapDrawerOption(int index) {
    if (index == selectedIndex) return;
    if(isDrawerOpen){
      scaffoldKey.currentState!.closeDrawer();
    }
    final location = tabs(context)[index].location;
    selectedIndex = index;
    context.goNamed(location);
  }

  void onTapLogout() {
    sessionManager.logOut();
    AuthHandler.instance.userAuthStatus = UserAuthStatus.unAuthorized;
    ToastMessage.showToastMessage(
      message: context.i10n.succesfullyLoggedOut,
      type: ToastMessageType.success,
    );
  }

  bool get isDrawerOpen=> scaffoldKey.currentState!.isDrawerOpen;


}

///Class that has all required fields for BottomNavigationBar
class DrawerItem {
  DrawerItem({
    required this.title,
    required this.svg,
    required this.onTap,
    required this.location,
  });

  final String title;
  final SvgGeneralImage svg;
  final VoidCallback onTap;
  final String location;
}
