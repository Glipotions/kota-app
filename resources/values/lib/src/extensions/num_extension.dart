import 'package:intl/intl.dart';

extension NumExtension on num {

  String formatPrice({String? locale}) {
  final formatter = NumberFormat.currency(
    locale: locale,
    symbol: '₺', 
    decimalDigits: 2,
  );
  return formatter.format(this);
}

}
