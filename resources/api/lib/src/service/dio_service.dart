import 'package:api/src/service/interceptors/index.dart';
import 'package:dio/dio.dart';

/// Enum to define HTTP methods
enum DioHttpMethod {
  ///Enum that represents GET method
  get,

  ///Enum that represents POST method
  post,

  ///Enum that represents PUT method
  put,

  ///Enum that represents DELETE method
  delete,

  ///Enum that represents PATCH method
  patch,
}

/// DioClient class for handling API requests
class DioClient {
  /// Singleton instance method for DioClient
  factory DioClient({
    required String baseUrl,
    Function? onUnauthorized,
    Map<String, dynamic>? headerParam,
    int connectTimeoutSecond = 15,
    int receiveTimeoutSecond = 15,
  }) {
    _instance ??= DioClient._internal(
      baseUrl: baseUrl,
      onUnauthorized: onUnauthorized,
      headerParam: headerParam,
      connectTimeout: connectTimeoutSecond,
      receiveTimeout: receiveTimeoutSecond,
    );
    return _instance!;
  }

  // Private constructor for DioClient
  DioClient._internal({
    required this.baseUrl,
    required int connectTimeout,
    required int receiveTimeout,
    Function? onUnauthorized,
    this.headerParam,
  }) : _dio = Dio(
          BaseOptions(
            followRedirects: false,
            validateStatus: (status) {
              return status != null && status < 500;
            },
            baseUrl: Uri.https(baseUrl).toString(),
            headers: headerParam,
            connectTimeout: Duration(seconds: connectTimeout),
            receiveTimeout: Duration(seconds: receiveTimeout),
          ),
        ) {
    addInterceptors(onUnauthorized: onUnauthorized);
  }

  /// Instance of DioClient class
  static DioClient? _instance;

  /// Base URL of the API
  final String baseUrl;

  /// Header for requests.
  final Map<String, dynamic>? headerParam;

  /// Dio instance  for making HTTP requests
  final Dio _dio;

  /// Method to add interceptors for adding desired interceptors.
  void addInterceptors({Function? onUnauthorized}) {
    const prettyDioLogger = OmegaDioLogger();
    final unAuthorizedInterceptor = UnauthorizedInterceptor(
      onUnauthorized: onUnauthorized,
    );

    _dio.interceptors.add(prettyDioLogger);
    _dio.interceptors.add(unAuthorizedInterceptor);
  }

  Options _options(Map<String, dynamic>? customHeaderParams) {
    return Options(
      headers: <String, dynamic>{}
        ..addAll(customHeaderParams ?? {})
        ..addAll(headerParam ?? {}),
    );
  }

  // Method to send HTTP requests based on the specified method
  Future<Response<dynamic>?> _sendRequest(
    DioHttpMethod method,
    String pathBody,
    Object bodyParam,
    Map<String, String>? customHeaderParams,
    Map<String, dynamic>? queryParams,
  ) async {
    final uri = Uri.https(
      baseUrl,
      (pathBody.isNotEmpty ? pathBody : ''),
      queryParams,
    );
    try {
      Response<dynamic> response;
      switch (method) {
        case DioHttpMethod.get:
          response = await _dio.getUri(
            uri,
            data: bodyParam,
            options: _options(
              customHeaderParams,
            ),
          );
        case DioHttpMethod.post:
          response = await _dio.postUri(
            uri,
            data: bodyParam,
            options: _options(
              customHeaderParams,
            ),
          );
        case DioHttpMethod.delete:
          response = await _dio.deleteUri(
            uri,
            data: bodyParam,
            options: _options(
              customHeaderParams,
            ),
          );
        case DioHttpMethod.put:
          response = await _dio.putUri(
            uri,
            data: bodyParam,
            options: _options(
              customHeaderParams,
            ),
          );
        case DioHttpMethod.patch:
          response = await _dio.patchUri(
            uri,
            data: bodyParam,
            options: _options(
              customHeaderParams,
            ),
          );
      }
      return response;
    } on DioException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  ///Function to send request from outside of this class.
  Future<Response<dynamic>?> request(
    DioHttpMethod method,
    String path, {
    Object bodyParam = const {},
    Map<String, String>? headerParam,
    bool? forceRefresh,
    Map<String, dynamic>? queryParams,
  }) async {
    return _sendRequest(
      method,
      path,
      bodyParam,
      headerParam,
      queryParams,
    );
  }
}
