import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/sub/manage_account_screen/controller/manage_account_controller.dart';
import 'package:kota_app/product/base/base_view.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/widgets/app_bar/general_app_bar.dart';

class ManageAccount extends StatelessWidget {
  const ManageAccount({required this.controller, super.key});

  final ManageAccountController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GeneralAppBar(title: 'Kullanıcı Bilgilerim'),
      body: BaseView<ManageAccountController>(
        controller: controller,
        child: Padding(
          padding: EdgeInsets.all(ModulePadding.s.value),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Yuvarlak köşeler
                ),
                elevation: ModulePadding.xs.value,
                child: Padding(
                  padding: EdgeInsets.all(
                    ModulePadding.m.value,
                  ), // Daha geniş padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => userInfo('Username', controller.user.username),
                      ),
                      Obx(
                        () => userInfo('Full Name', controller.user.fullName),
                      ),
                      Obx(
                        () => userInfo('Email', controller.user.email),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: ModulePadding.xs.value),
              Align(
                child: TextButton(
                  // onPressed: controller.onTapRemoveAccount,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Account Deletion'),
                          content: const Text(
                            'Are you sure you want to delete your account? This action cannot be undone.',
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Dialog'u kapat
                              },
                            ),
                            TextButton(
                              child: const Text('Delete Account'),
                              onPressed: () {
                                // Burada hesap silme işlemini gerçekleştirecek kodu ekleyin
                                // Örneğin, controller.deleteAccount(); gibi
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Remove Account',
                    style: TextStyle(
                      color: Colors
                          .grey, // Kırmızı metin rengi, dikkat çekici ama zarif
                      fontSize: 16, // Uygun font boyutu
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget userInfo(String label, String? value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ModulePadding.xs.value),
      child: Text(
        '$label: $value',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87, // Daha koyu bir yazı rengi
        ),
      ),
    );
  }
}
