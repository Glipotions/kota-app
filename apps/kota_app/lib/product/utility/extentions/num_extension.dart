import 'package:intl/intl.dart';
import 'package:kota_app/product/managers/session_handler.dart';

extension NumExtension on num {

  String formatPrice({String? locale}) {
    var symbol = '₺';
    switch (SessionHandler.instance.currentUser?.currencyType) {
      case 2:
        symbol = '\$';
      case 3:
        symbol = '€';
      case 4:
        symbol = '£';
      default:
        symbol = '₺';
    }
    
    final formatter = NumberFormat.currency(
      locale: locale ?? 'tr_TR',
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(this);
  }

}
