///Custom exception to handle AppExceptions
class AppException implements Exception {
  ///Custom exception to handle AppExceptions
  AppException(this.message);

  ///Exception message
  String? message;

  @override
  String toString() {
    message ??= '';
    return message!;
  }
}
