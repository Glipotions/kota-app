///Custom exception to handle AppExceptions
class AppException implements Exception {
  ///Custom exception to handle AppExceptions
  AppException(this.message, this.status);

  ///Exception message
  String? message;
  int? status;

  @override
  String toString() {
    message ??= '';
    return message!;
  }
}
