import 'package:common/common.dart';
import 'package:common/src/i10n/lan/ar.dart';
import 'package:common/src/i10n/lan/en.dart';
import 'package:common/src/i10n/lan/ru.dart';
import 'package:common/src/i10n/lan/tr.dart';
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
    final labels = AppLocalization.getLabels(context);
    return Scaffold(
      appBar: GeneralAppBar(title: labels.accountSettings),
      body: BaseView<ManageAccountController>(
        controller: controller,
        onTapTryAgain: () => controller.onReady(),
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
                  title: labels.accountInfo,
                  child: userInfoCard(context),
                ),
                SizedBox(height: ModulePadding.l.value),
                _buildSection(
                  context,
                  title: labels.preferences,
                  child: _buildPreferences(context),
                ),
                SizedBox(height: ModulePadding.l.value),
                _buildSection(
                  context,
                  title: labels.accountManagement,
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
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.white,
            ),
          ),
          SizedBox(height: ModulePadding.s.value),
          Obx(
            () => Text(
              controller.user?.fullName ?? '',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: ModulePadding.xxs.value),
          Obx(
            () => Text(
              controller.user?.email ?? '',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.theme.hintColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ModulePadding.s.value),
        child,
      ],
    );
  }

  Widget userInfoCard(BuildContext context) {
    final labels = AppLocalization.getLabels(context);
    return Card(
      child: Padding(
        padding: EdgeInsets.all(ModulePadding.m.value),
        child: Obx(
          () => Column(
            children: [
              _buildInfoRow(
                context,
                labels.username,
                controller.user?.username,
              ),
              Divider(height: ModulePadding.m.value * 2),
              _buildInfoRow(
                context,
                labels.fullName,
                controller.user?.fullName,
              ),
              Divider(height: ModulePadding.m.value * 2),
              _buildInfoRow(context, labels.email, controller.user?.email),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.theme.hintColor,
          ),
        ),
        Text(
          value ?? '',
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPreferences(BuildContext context) {
    final labels = AppLocalization.getLabels(context);
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(labels.language),
            trailing: Obx(() => DropdownButton<String>(
                  value: controller.currentLanguage,
                  items: [
                    DropdownMenuItem(
                      value: 'tr',
                      child: Text(TrLocalization().localizationTitle),
                    ),
                    DropdownMenuItem(
                      value: 'en',
                      child: Text(EnLocalization().localizationTitle),
                    ),
                    DropdownMenuItem(
                      value: 'ru',
                      child: Text(RuLocalization().localizationTitle),
                    ),
                    DropdownMenuItem(
                      value: 'ar',
                      child: Text(ArLocalization().localizationTitle),
                    ),
                  ],
                  onChanged: (String? value) {
                    if (value != null) {
                      controller.changeLanguage(value);
                    }
                  },
                )),
          ),
          Divider(
            height: 1,
            indent: ModulePadding.m.value,
            endIndent: ModulePadding.m.value,
          ),
          ListTile(
            title: Text(
              labels.darkMode,
              style: context.textTheme.bodyMedium,
            ),
            trailing: Obx(
              () => Switch(
                value: controller.isDarkMode.value,
                onChanged: controller.setDarkMode,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountManagement(BuildContext context) {
    final labels = AppLocalization.getLabels(context);
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: Text(
              labels.deleteAccount,
              style: context.textTheme.bodyMedium?.copyWith(color: Colors.red),
            ),
            subtitle: Text(
              labels.deleteAccountDescription,
              style: context.textTheme.bodySmall?.copyWith(
                color: Colors.red.withOpacity(0.7),
              ),
            ),
            onTap: () => _showDeleteAccountDialog(context),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final labels = AppLocalization.getLabels(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(labels.deleteAccountConfirmation),
        content: Text(labels.deleteAccountWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(labels.cancel),
          ),
          TextButton(
            onPressed: () {
              controller.onTapRemoveAccount();
              Navigator.pop(context);
            },
            child: Text(
              labels.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
