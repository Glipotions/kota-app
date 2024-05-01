// ignore_for_file: lines_longer_than_80_chars

import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/navigation/modules/auth_route/auth_route_enums.dart';
import 'package:widgets/widget.dart';

class RegisterController extends BaseControllerInterface {

  final GlobalKey<FormState> fKey = GlobalKey<FormState>();
  final TextEditingController cEmail = TextEditingController();
  final TextEditingController cPassword = TextEditingController();
  final TextEditingController cFullName = TextEditingController();
  final TextEditingController cUserName = TextEditingController();

  
  @override
  Future<void> onReady() async {
    super.onReady();
    await onReadyGeneric(() async {});
  }

  void onTapLogin()=>context.goNamed(AuthRouteScreens.loginScreen.name);

  Future<void> onTapRegister()async{
    if(fKey.currentState!.validate()){

      if (fKey.currentState!.validate()) {
      final request = RegisterRequestModel(
        email: cEmail.text.trim(),
        password: cPassword.text,
        fullName: cFullName.text,
        userName: cUserName.text,
      );
      LoadingProgress.start();
      await client.appService.register(request: request).handleRequest(
            defaultResponse: LoginResponseModel(),
            onSuccess: (res){
              showSuccessToastMessage(
                  'Hesap başarı ile oluşturuldu. Cari hesap onayından sonra giriş yapabilirsiniz.',
                );
              context.goNamed(AuthRouteScreens.loginScreen.name);
            },
            ignoreException: true,
            onIgnoreException: (err) => showErrorToastMessage(
              err?.detail ?? 'Kayıt işlemi yapılırken bir hata oluştu.',
            ),
          );
      LoadingProgress.stop();
    }

    }
  } 
}
