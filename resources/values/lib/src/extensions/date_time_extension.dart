import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {


  /// Time formatter to display user the current time in 
  /// dd-mm-yyyy format.
  String displayToDateFormat() {
    final formatter = DateFormat(
      'dd-MM-yyyy',
    );
    return formatter.format(this);
  }
}
