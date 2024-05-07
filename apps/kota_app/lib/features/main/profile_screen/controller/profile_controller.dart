import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:kota_app/features/main/profile_screen/view/profile.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/managers/session_handler.dart';
import 'package:kota_app/product/navigation/modules/sub_route/sub_route_enums.dart';
import 'package:values/values.dart';

class ProfileController extends BaseControllerInterface {
  final Rx<BalanceResponseModel> _balance = Rx(BalanceResponseModel());

  BalanceResponseModel get balance => _balance.value;
  set balance(BalanceResponseModel value) => _balance.value = value;

  @override
  Future<void> onReady() async {
    super.onReady();
    await onReadyGeneric(() async {
      await _getBalance();
    });
  }

  Future<void> _getBalance() async {
    if (SessionHandler.instance.currentUser == null) {
      await context.pushNamed(SubRouteEnums.loginSubScreen.name);
    } else {
      await client.appService
          .balanceInformation(
            id: SessionHandler.instance.currentUser!.currentAccountId!,
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

  void onTapLogout() => SessionHandler.instance.logOut();

  List<OptionTileModel> get profileOptions => [
        OptionTileModel(
          title: 'Geçmiş Siparişler',
          subTitle: 'Geçmiş siparişlerinizi görüntüleyebilirsiniz.',
          icon: const Icon(Icons.shopping_bag),
          onTap: onTapPastOrders,
        ),
        OptionTileModel(
          title: 'Cari Hareketler',
          subTitle: 'Geçmiş cari hareketlerinizi görüntüleyebilirsiniz.',
          icon: const Icon(Icons.attach_money),
          onTap: onTapPastTransactions,
        ),
        OptionTileModel(
          title: 'Destek',
          subTitle: 'Destek ile iletişime geçebilirsiniz.',
          icon: const Icon(Icons.call),
          onTap: onTapSupport,
        ),
        OptionTileModel(
          title: 'Kullanıcı Bilgilerim',
          subTitle: 'Hesap bilgilerinizi görüntüleyebilirsiniz.',
          icon: const Icon(Icons.manage_accounts),
          onTap: onTapManageAccount,
        ),
        OptionTileModel(
          title: 'Çıkış Yap',
          subTitle: 'Çıkış yapabilirsiniz.',
          icon: const Icon(Icons.logout),
          onTap: onTapLogout,
        ),
      ];
}
