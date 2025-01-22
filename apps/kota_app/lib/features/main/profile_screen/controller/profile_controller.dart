import 'package:api/api.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:kota_app/features/main/profile_screen/view/profile.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/managers/session_handler.dart';
import 'package:kota_app/product/navigation/modules/sub_route/sub_route_enums.dart';
import 'package:kota_app/product/utility/enums/currency_type.dart';
import 'package:values/values.dart';

class ProfileController extends BaseControllerInterface {
  final Rx<BalanceResponseModel> _balance = Rx(BalanceResponseModel());

  BalanceResponseModel get balance => _balance.value;
  set balance(BalanceResponseModel value) => _balance.value = value;

  // Currency related cached value
  late final Rx<int> _currencyType = 1.obs;
  late final Rx<bool> _isCurrencyTL = true.obs;

  int get currencyType => _currencyType.value;
  bool get isCurrencyTL => _isCurrencyTL.value;

  void _updateCurrencyValues() {
    _currencyType.value = sessionHandler.currentUser?.currencyType ?? 1;
    _isCurrencyTL.value = CurrencyType.tl == CurrencyType.fromValue(_currencyType.value);
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await onReadyGeneric(() async {
      _updateCurrencyValues();
      await _getBalance();
    });
  }

  Future<void> _getBalance() async {
    if (sessionHandler.currentUser == null) {
      await context.pushNamed(SubRouteEnums.loginSubScreen.name);
    } else {
      await client.appService
          .balanceInformation(
            id: sessionHandler.currentUser!.currentAccountId!,
            branchCurrentInfoId: sessionHandler
                .currentUser!.connectedBranchCurrentInfoId,
          )
          .handleRequest(
            onSuccess: (res) => balance = res!,
          );
    }
  }

  Future<void> onTapSupport() async {
    try {
      await ''.openWp();
    } catch (e) {
      showErrorToastMessage('Destek merkezi açılırken bir hata oluştu.');
    }
  }

  void onTapPastOrders() => context.pushNamed(SubRouteEnums.orderHistory.name);

  void onTapPastTransactions() =>
      context.pushNamed(SubRouteEnums.transactionHistory.name);

  void onTapManageAccount() =>
      context.pushNamed(SubRouteEnums.manageAccount.name);

  void onTapLogout(BuildContext context) {
    final labels = AppLocalization.getLabels(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Theme.of(context).cardColor,
        title: Column(
          children: [
            Icon(
              Icons.logout_rounded,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              labels.signOut,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ],
        ),
        content: Text(
          labels.signOutDescription,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              labels.cancel,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              SessionHandler.instance.logOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              labels.logout,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onError,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  List<OptionTileModel> getProfileOptions(BuildContext context) {
    final labels = AppLocalization.getLabels(context);
    return [
      OptionTileModel(
        title: labels.pastOrders,
        subTitle: labels.pastOrdersDescription,
        icon: const Icon(Icons.shopping_bag),
        onTap: onTapPastOrders,
      ),
      OptionTileModel(
        title: labels.transactions,
        subTitle: labels.transactionsDescription,
        icon: const Icon(Icons.attach_money),
        onTap: onTapPastTransactions,
      ),
      OptionTileModel(
        title: labels.support,
        subTitle: labels.supportDescription,
        icon: const Icon(Icons.call),
        onTap: onTapSupport,
      ),
      OptionTileModel(
        title: labels.userAccountInfo,
        subTitle: labels.userAccountInfoDescription,
        icon: const Icon(Icons.manage_accounts),
        onTap: onTapManageAccount,
      ),
      OptionTileModel(
        title: labels.signOut,
        subTitle: labels.signOutDescription,
        icon: const Icon(Icons.logout),
        onTap: () => onTapLogout(context),
      ),
    ];
  }
}
