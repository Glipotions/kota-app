// ignore_for_file: lines_longer_than_80_chars

import 'package:api/api.dart';
import 'package:bb_example_app/product/base/controller/base_controller.dart';
import 'package:bb_example_app/product/navigation/modules/auth_route/auth_route_enums.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:widgets/widget.dart';

///Controller for Example Screen
class LoginController extends BaseControllerInterface {
  final GlobalKey<FormState> fKey = GlobalKey<FormState>();
  final TextEditingController cEmail = TextEditingController();
  final TextEditingController cPassword = TextEditingController();

  @override
  Future<void> onReady() async {
    await onReadyGeneric(() async {});
  }

  void onTapRegister() => context.goNamed(AuthRouteScreens.registerScreen.name);

  Future<void> onTapLogin() async {
    if (fKey.currentState!.validate()) {
      final request = LoginRequestModel(
        email: cEmail.text.trim(),
        password: cPassword.text,
      );
      LoadingProgress.start();
      await client.appService.login(request: request).handleRequest(
            defaultResponse: LoginResponseModel(),
            onSuccess: (res) => {
              if (res?.user?.hasCurrentAccount ?? false)
                {
                  sessionHandler.logIn(res: res!),
                }
              else
                {
                  showErrorToastMessage(
                    'Hesabınız onaylanmamıştır. Lütfen hesabınız onaylandıktan sonra tekrar deneyiniz.',
                  ),
                },
            },
            ignoreException: true,
            onIgnoreException: (err) => showErrorToastMessage(
              err?.detail ?? 'Giriş yaparken bir hata oluştu.',
            ),
          );
      LoadingProgress.stop();
    }
  }
}
