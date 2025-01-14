import 'dart:convert';
import 'package:api/src/index.dart';
import 'package:dio/dio.dart';
import 'package:universal_io/io.dart';

///Base Client that handles all kind of request using [DioClient]
abstract class BaseClient {
  ///Base Client constructors.
  BaseClient({
    required this.dio,
  });

  ///Dio instance within BaseClient
  final DioClient dio;

  ///Base request that handles request that returns single instance of type
  Future<BaseHttpModel<R>> baseRequest<T, R>({
    required String httpUrl,
    required DioHttpMethod method,
    IBaseModel<dynamic>? requestModel,

    ///only use If requestModel is null
    Object? bodyParam,
    IBaseModel<T>? responseModel,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headerParam,
    int? successStatus,
  }) async {
    try {
      final response = await dio.request(
        method,
        httpUrl,
        bodyParam: requestModel?.toJson() ?? (bodyParam ?? {}),
        queryParams: queryParams,
        headerParam: headerParam,
      );
      print('Raw API Response: ${response?.data}'); // Debug print
      if (response!.statusCode == (successStatus ?? HttpStatus.ok)) {
        R? returnResponse;
        if (responseModel != null) {
          final jsonString = jsonEncode(response.data);
          print('Response JSON string: $jsonString'); // Debug print
          returnResponse =
              responseModel.jsonParser(jsonString) as R;
        }
        return BaseHttpModel(
          status: BaseModelStatus.ok,
          data: returnResponse == null ? null : returnResponse as R,
        );
      } else {
        var errorModel = BaseErrorModel();
        if (response.data != '') {
          errorModel = BaseErrorModel().jsonParser(jsonEncode(response.data))
              as BaseErrorModel;
        }

        return BaseHttpModel(status: BaseModelStatus.error, error: errorModel);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        return BaseHttpModel(
          status: BaseModelStatus.timeout,
          error: BaseErrorModel(
            status: BaseModelStatus.timeout.value,
            type: e.message,
            title: 'Zaman aşımı.',
            detail: 'Zaman aşımı.',
          ),
        );
      }
      final errorModel = BaseErrorModel()
          .jsonParser(jsonEncode(e.response?.data)) as BaseErrorModel;
      return BaseHttpModel(
        status: BaseModelStatus.fromValue(e.response?.statusCode),
        error: errorModel,
      );
    } catch (e) {
      return BaseHttpModel(status: BaseModelStatus.inAppError);
    }
  }

  Future<BaseHttpModel<List<T>>> fetchData<T>(String url, 
      {int? pageIndex,
      int? pageSize,
      T Function(Map<String, dynamic>)? fromJson,
      int? id = null,
      String? search = null}) async {
    try {
      final Map<String, dynamic> bodyParam = {
        if (pageIndex != null) 'PageIndex': pageIndex.toString(),
        if (pageSize != null) 'PageSize': pageSize.toString(),
        if (id != null) 'id': id.toString(),
        if (search != null) 'searchText': search,
      };

      var response = await dio.request(
        DioHttpMethod.get,
        url,
        // headerParam: createHeader(),
        bodyParam: bodyParam,
      );

      if (response!.statusCode == HttpStatus.ok) {
        final responseModel =
            BaseListModel<T>.fromJsonList(response.data.toString(), fromJson!);
        return BaseHttpListModel<List<T>>(
          status: BaseModelStatus.ok,
          data: responseModel.data,
          hasNext: responseModel.hasNext,
          pageSize: responseModel.size,
          pages: responseModel.pages,
          pageIndex: responseModel.index,
        );
      } else if (response.statusCode == HttpStatus.notFound) {
        return BaseHttpListModel(status: BaseModelStatus.notFound);
      } else {
        // final responseModel =
        //     BaseErrorModel().jsonParser(utf8.decode(response.));
        return BaseHttpListModel(
          status: BaseModelStatus.error,
          message: response.statusMessage,
        );
      }
    } on AppException catch (e) {
      return BaseHttpListModel(
        status: BaseModelStatus.error,
        message: e.toString(),
      );
    } catch (e) {
      return BaseHttpListModel(status: BaseModelStatus.error);
    }
  }
}
