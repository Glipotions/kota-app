
import 'package:dio/dio.dart';
import 'package:universal_io/io.dart';

///Class to handle when API response returns Authorized.
class UnauthorizedInterceptor extends Interceptor {
  ///Class to handle when API response returns Authorized.
  UnauthorizedInterceptor({
    this.onUnauthorized,
  });

  ///Function to call when API response returns Authorized.
  final Function? onUnauthorized;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      (onUnauthorized as void Function()?)?.call();
    }
    super.onError(err, handler);
  }
}
