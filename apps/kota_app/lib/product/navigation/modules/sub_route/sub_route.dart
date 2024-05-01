import 'package:go_router/go_router.dart';
import 'package:kota_app/features/sub/order_history_screen/order_history_screen.dart';
import 'package:kota_app/features/sub/product_detail_screen/product_detail_screen.dart';
import 'package:kota_app/features/sub/transaction_history_screen/transaction_history_screen.dart';
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
      name: SubRouteEnums.productDetail.name,
      path: '${SubRouteEnums.productDetail.path}/:id/:productCode',
      builder: (context, state) => ProductDetailScreen(
        id: state.pathParameters['id']!,
        productCode: state.pathParameters['productCode']!,
      ),
    ),
  ];
}
