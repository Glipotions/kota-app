import 'package:api/src/index.dart';

///Extension to generically send request and handle error
extension BaseRequestExtension<T> on Future<BaseHttpModel<T>> {
  ///Extension to generically send request and handle error
  ///[defaultErrorMessage] is the message to display when
  ///http response message is null
  ///[skipExceptionCode] is the exception unsuccesfull [BaseModelStatus] to
  ///take action instead of throwing [AppException]
  ///[onSkip] is function to call when [BaseModelStatus]
  ///equals to [skipExceptionCode]
  ///[onSuccess] is function to call when [BaseModelStatus]
  ///equals to [BaseModelStatus.ok]
  ///[ignoreException] determines to return null or throw exception when
  ///status is not equalt to [BaseModelStatus.ok]
  ///[onIgnoreException] is function to call when
  ///status is not equalt to [BaseModelStatus.ok]
  Future<T> handleRequest({
    String? defaultErrorMessage,
    BaseModelStatus? skipExceptionCode,
    void Function()? onSkip,
    void Function(T?)? onSuccess,
    void Function(BaseErrorModel?)? onIgnoreException,
    bool ignoreException = false,
    T? defaultResponse,
  }) async {
    assert(
      skipExceptionCode == null || defaultResponse != null,
      'If skipExceptionCode is not null, defaultResponse cannot be null.',
    );

    assert(
      !ignoreException || defaultResponse != null,
      'If ignoreException is true, defaultResponse cannot be null.',
    );

    assert(
      onSkip == null || skipExceptionCode != null,
      'If onSkip is not null, skipExceptionCode cannot be null.',
    );

    assert(
      onIgnoreException == null || ignoreException == true,
      'If onIgnoreException is not null, ignoreException cannot be false.',
    );

    final response = await this;
    if (response.status.isOk) {
      onSuccess?.call(response.data as T);
      return response.data as T;
    } else if (skipExceptionCode == response.status) {
      onSkip?.call();
      return defaultResponse!;
    } else {
      if (ignoreException) {
        onIgnoreException?.call(response.error);
        return defaultResponse!;
      }
      throw AppException(
        response.error?.type ?? defaultErrorMessage,
        response.error?.status,
      );
    }
  }
}
