import 'package:go_router/go_router.dart';
import 'package:kota_app/features/auth/login_screen/login_screen.dart';
import 'package:kota_app/features/sub/manage_account_screen/manage_account_screen.dart';
import 'package:kota_app/features/sub/order_history_screen/order_history_screen.dart';
import 'package:kota_app/features/sub/product_detail_screen/product_detail_screen.dart';
import 'package:kota_app/features/sub/transaction_history_screen/transaction_history_screen.dart';
import 'package:kota_app/product/navigation/modules/auth_route/auth_route_enums.dart';
import 'package:kota_app/product/navigation/modules/sub_route/sub_route_enums.dart';

/// Route Class for Initial Route
class SubRoute {
  SubRoute._();

  /// Initial Router
  static final route = [
    GoRoute(
      name: SubRouteEnums.orderHistory.name,
      path: SubRouteEnums.orderHistory.path,
      builder: (context, state) => const OrderHistoryScreen(),
    ),
    GoRoute(
      name: SubRouteEnums.transactionHistory.name,
      path: SubRouteEnums.transactionHistory.path,
      builder: (context, state) => const TransactionHistoryScreen(),
    ),
    GoRoute(
      name: SubRouteEnums.manageAccount.name,
      path: SubRouteEnums.manageAccount.path,
      builder: (context, state) => const ManageAccountScreen(),
    ),
    GoRoute(
      name: SubRouteEnums.loginSubScreen.name,
      path: SubRouteEnums.loginSubScreen.path,
      builder: (context, state) => const LoginScreen(),

      // pageBuilder: (context, state) {
      //   return const NoTransitionPage(
      //     child: LoginScreen(),
      //   );
      // },
    ),
    GoRoute(
      name: SubRouteEnums.productDetail.name,
      path: '${SubRouteEnums.productDetail.path}/:id/:productCode',
      builder: (context, state) => ProductDetailScreen(
        id: state.pathParameters['id']!,
        productCode: state.pathParameters['productCode']!,
      ),
    ),
  ];
}
