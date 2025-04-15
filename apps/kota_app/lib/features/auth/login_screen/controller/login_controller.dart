// ignore_for_file: lines_longer_than_80_chars

import 'package:api/api.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/navigation/modules/auth_route/auth_route_enums.dart';
import 'package:kota_app/product/navigation/modules/bottom_navigation_route/bottom_navigation_route_enums.dart';
import 'package:kota_app/product/utility/enums/cache_enums.dart';
import 'package:kota_app/features/navigation/bottom_navigation_bar/controller/bottom_navigation_controller.dart';
import 'package:widgets/widget.dart';

///Controller for Example Screen
class LoginController extends BaseControllerInterface {
  final GlobalKey<FormState> fKey = GlobalKey<FormState>();
  final TextEditingController cEmail = TextEditingController();
  final TextEditingController cPassword = TextEditingController();
  RxBool rememberMe = false.obs;

  @override
  Future<void> onReady() async {
    await onReadyGeneric(() async {
      await getUserCredentials();
    });
  }

  // Şifremi unuttum ekranına geçiş
  void onTapForgotPassword() {
    // Use GoRouter to navigate to the named route
    context.goNamed(AuthRouteScreens.forgotPasswordScreen.name);
  }

  // Kayıt ol ekranına geçiş
  void onTapRegister() {
    // Use GoRouter to navigate to the named route
    context.goNamed(AuthRouteScreens.registerScreen.name);
  }

  Future<void> onTapLogin() async {
    final labels = AppLocalization.getLabels(context);
    if (fKey.currentState!.validate()) {
      final request = LoginRequestModel(
        email: cEmail.text.trim(),
        password: cPassword.text,
      );
      LoadingProgress.start();
      await client.appService.login(request: request).handleRequest(
            defaultResponse: LoginResponseModel(),
            onSuccess: (res) async => {
              if (res?.user?.hasCurrentAccount ?? false)
                {
                  await Future.wait([
                    saveUserCredentials(),
                  ]),
                  sessionHandler.logIn(res: res!, isLogin: true),
                  // Doğrudan profil ekranına yönlendir
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // BottomNavigationController'ı bul ve index'i güncelle
                    if (Get.isRegistered<BottomNavigationController>()) {
                      final navController = Get.find<BottomNavigationController>();
                      navController.selectedIndex = 0;
                    }
                    // Profil ekranına yönlendir
                    context.goNamed(BottomNavigationRouteEnum.allProductsScreen.name);
                  }),
                }
              else
                {
                  showErrorToastMessage(
                    labels.accountNotApproved,
                  ),
                },
            },
            ignoreException: true,
            onIgnoreException: (err) => showErrorToastMessage(
              err?.detail ?? labels.loginError,
            ),
          );
      LoadingProgress.stop();
    }
  }

  Future<void> getUserCredentials() async {
    // ignore:  use_if_null_to_convert_nulls_to_bools
    if (LocaleManager.instance.getBoolValue(key: CacheKey.isRemember.name) ==
        true) {
      final username = await LocaleManager.instance
          .getSecuredValue(SecuredCacheKey.username.name);
      final password = await LocaleManager.instance
          .getSecuredValue(SecuredCacheKey.password.name);
      rememberMe.value = true;
      if (username != null) {
        cEmail.text = username;
      }
      if (password != null) {
        cPassword.text = password;
      }
    }
  }

  Future<void> saveUserCredentials() async {
    await LocaleManager.instance
        .setBoolValue(key: CacheKey.isRemember.name, value: rememberMe.value);

    if (rememberMe.value) {
      await LocaleManager.instance
          .setSecuredValue(SecuredCacheKey.username.name, cEmail.text);
      await LocaleManager.instance
          .setSecuredValue(SecuredCacheKey.password.name, cPassword.text);
    } else {
      await LocaleManager.instance.deleteAllSecuredValues();
    }
  }
}
