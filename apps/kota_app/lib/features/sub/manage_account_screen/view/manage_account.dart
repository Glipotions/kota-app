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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(ModulePadding.m.value),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(context),
                SizedBox(height: ModulePadding.l.value),
                _buildSection(
                  context,
                  title: 'Hesap Bilgileri',
                  child: userInfoCard(context),
                ),
                SizedBox(height: ModulePadding.l.value),
                _buildSection(
                  context,
                  title: 'Tercihler',
                  child: _buildPreferences(context),
                ),
                SizedBox(height: ModulePadding.l.value),
                _buildSection(
                  context,
                  title: 'Hesap Yönetimi',
                  child: _buildAccountManagement(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.theme.primaryColor.withOpacity(0.1),
            ),
            child: Icon(
              Icons.person,
              size: 50,
              color: context.theme.primaryColor,
            ),
          ),
          SizedBox(height: ModulePadding.s.value),
          Obx(() => Text(
                controller.user.fullName ?? '',
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              )),
          SizedBox(height: ModulePadding.xxs.value),
          Obx(() => Text(
                controller.user.email ?? '',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.theme.hintColor,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.theme.primaryColor,
          ),
        ),
        SizedBox(height: ModulePadding.s.value),
        child,
      ],
    );
  }

  Widget userInfoCard(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: context.theme.dividerColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(ModulePadding.m.value),
        child: Obx(() => Column(
          children: [
            _buildInfoRow(context, 'Kullanıcı Adı', controller.user.username),
            Divider(height: ModulePadding.m.value * 2),
            _buildInfoRow(context, 'Ad Soyad', controller.user.fullName),
            Divider(height: ModulePadding.m.value * 2),
            _buildInfoRow(context, 'E-posta', controller.user.email),
          ],
        )),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.theme.hintColor,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value ?? '',
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreferences(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: context.theme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Dil Seçimi',
              style: context.textTheme.bodyMedium,
            ),
            trailing: Obx(() => DropdownButton<String>(
              value: controller.currentLanguage.value,
              underline: const SizedBox(),
              items: <String>['English', 'Türkçe'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) => controller.setLanguage(newValue!),
            )),
          ),
          Divider(height: 1, indent: ModulePadding.m.value, endIndent: ModulePadding.m.value),
          ListTile(
            title: Text(
              'Karanlık Mod',
              style: context.textTheme.bodyMedium,
            ),
            trailing: Obx(() => Switch(
              value: controller.isDarkMode.value,
              onChanged: controller.setDarkMode,
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountManagement(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: context.theme.dividerColor,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: const Icon(Icons.delete_outline, color: Colors.red),
        title: Text(
          'Hesabı Sil',
          style: context.textTheme.bodyMedium?.copyWith(
            color: Colors.red,
          ),
        ),
        subtitle: Text(
          'Bu işlem geri alınamaz',
          style: context.textTheme.bodySmall?.copyWith(
            color: Colors.red.withOpacity(0.7),
          ),
        ),
        onTap: () => _showDeleteAccountDialog(context),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hesap Silme Onayı'),
          content: const Text(
            'Hesabınızı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.',
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'İptal',
                style: TextStyle(color: context.theme.hintColor),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hesabı Sil'),
              onPressed: () {
                controller.onTapRemoveAccount();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
