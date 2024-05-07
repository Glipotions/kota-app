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
              languageSelection(context),
              themeModeSwitch(context),
              SizedBox(height: ModulePadding.s.value),
              userInfoCard(context),
              SizedBox(height: ModulePadding.xs.value),
              removeAccountButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget userInfoCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Yuvarlak köşeler
      ),
      elevation: ModulePadding.xs.value,
      child: Padding(
        padding: EdgeInsets.all(ModulePadding.m.value),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => userInfo('Username', controller.user.username)),
            Obx(() => userInfo('Full Name', controller.user.fullName)),
            Obx(() => userInfo('Email', controller.user.email)),
          ],
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
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget languageSelection(BuildContext context) {
    return DropdownButton<String>(
      value: controller.currentLanguage.value,
      onChanged: (newValue) {
        controller.setLanguage(newValue!);
      },
      items: <String>['English', 'Türkçe']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget themeModeSwitch(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Dark Mode',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Obx(
          () => Switch(
            value: controller.isDarkMode.value,
            onChanged: (bool value) {
              controller.setDarkMode(value);
            },
          ),
        ),
      ],
    );
  }

  Widget removeAccountButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
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
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: const Text('Delete Account'),
                    onPressed: () {
                      controller.onTapRemoveAccount();
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
            color: Colors.red,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
