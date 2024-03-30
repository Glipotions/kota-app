// ignore_for_file: sort_constructors_first

import 'package:api/src/index.dart';

/// Base http model for parsing api responses.
class BaseHttpModel<T> {
  /// Constructor
  BaseHttpModel({required this.status, this.data, this.error});

  /// BaseModelStatus that represent the status of response as [BaseModelStatus]
  BaseModelStatus status;

  /// Parsed API response if there is any response.
  T? data;

  /// Parsed API response if there is any error.
  BaseErrorModel? error;
}

/// Enum that represents api statusses.
enum BaseModelStatus {
  /// 200 - OK
  ok(200),

  /// 400 - Bad Request
  error(400),

  /// 422 - Unprocessable Entity
  unprocessableEntity(422),

  /// 422 - Unprocessable Entity
  internalServerError(500),

  /// 408 - Request Timeout
  timeout(408),

  /// 404 - Not Found
  notFound(404),

  /// 302 - Found (Redirect)
  found(302),

  /// In app error. Throws when request is succesfull but 
  /// [BaseClient] return BaseModelStatus.Error
  inAppError(9999999);

  /// value that represnt the int status code.
  final int value;

  /// Constructor
  const BaseModelStatus(this.value);

  /// method that returns [BaseModelStatus] from int value
  static BaseModelStatus fromValue(int? value) {
    if (value == null) return BaseModelStatus.error;
    return BaseModelStatus.values.firstWhere(
      (element) => element.value == value,
      orElse: () => BaseModelStatus.error,
    );
  }
}

/// BaseModelStatusExtension for checking the status of the response
extension BaseModelStatusExtension on BaseModelStatus {
  ///If resposne status is [BaseModelStatus.ok].
  bool get isOk => this == BaseModelStatus.ok;

  ///If resposne status is [BaseModelStatus.error].
  bool get isError => this == BaseModelStatus.error;

  ///If resposne status is [BaseModelStatus.unprocessableEntity].
  bool get isUnprocessableEntity => this == BaseModelStatus.unprocessableEntity;

  ///If resposne status is [BaseModelStatus.internalServerError].
  bool get isInternalServerError => this == BaseModelStatus.internalServerError;

  ///If resposne status is [BaseModelStatus.timeout].
  bool get isTimeOut => this == BaseModelStatus.timeout;

  ///If resposne status is [BaseModelStatus.notFound].
  bool get isNotFound => this == BaseModelStatus.notFound;

  ///If resposne status is [BaseModelStatus.found].
  bool get isFound => this == BaseModelStatus.found;
}
