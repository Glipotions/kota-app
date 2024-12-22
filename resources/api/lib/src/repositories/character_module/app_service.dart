import 'package:api/src/index.dart';
import 'package:api/src/repositories/character_module/endpoint/app_service_path.dart';
import 'package:universal_io/io.dart';

///Class that handles all Auth Module requests.
class AppService extends BaseClient {
  ///Class that handles all Auth Module requests.
  AppService({
    required this.dioClient,
  }) : super(dio: dioClient);

  ///Client to use in requests
  final DioClient dioClient;

  ///Request that returns all characters
  Future<BaseHttpModel<LoginResponseModel>> login({
    required LoginRequestModel request,
  }) async {
    return baseRequest<LoginResponseModel, LoginResponseModel>(
      responseModel: LoginResponseModel(),
      httpUrl: AppServicePath.login.value,
      method: DioHttpMethod.post,
      requestModel: request,
    );
  }

  ///Request that returns all characters
  Future<BaseHttpModel<RegisterResponseModel>> register({
    required RegisterRequestModel request,
  }) async {
    return baseRequest<RegisterResponseModel, RegisterResponseModel>(
      responseModel: RegisterResponseModel(),
      httpUrl: AppServicePath.register.value,
      method: DioHttpMethod.post,
      requestModel: request,
      successStatus: HttpStatus.created,
    );
  }

  ///Request that returns all characters
  Future<BaseHttpModel<TransactionsHistoryResponseModel>> transactionHistory({
    required TransactionsHistoryRequestModel request,
  }) async {
    return baseRequest<TransactionsHistoryResponseModel,
        TransactionsHistoryResponseModel>(
      responseModel: TransactionsHistoryResponseModel(),
      httpUrl: AppServicePath.transactionHistory.value,
      method: DioHttpMethod.get,
      queryParams: request.toJson(),
    );
  }

  ///Request that returns all characters
  Future<BaseHttpModel<OrdersHistoryResponseModel>> orderHistory({
    required OrderHistoryRequestModel request,
  }) async {
    return baseRequest<OrdersHistoryResponseModel, OrdersHistoryResponseModel>(
      responseModel: OrdersHistoryResponseModel(),
      httpUrl: AppServicePath.orderHistory.value,
      method: DioHttpMethod.get,
      queryParams: request.toJson(),
    );
  }

  ///Request that returns all characters
  Future<BaseHttpModel<OrdersHistoryDetailResponseModel>> orderHistoryDetail({
required int id,
  }) async {
    return baseRequest<OrdersHistoryDetailResponseModel, OrdersHistoryDetailResponseModel>(
      responseModel: OrdersHistoryDetailResponseModel(),
      httpUrl: AppServicePath.orderHistoryDetail.withPath(id.toString()),
      method: DioHttpMethod.get,
    );
  }

  Future<BaseHttpModel<OrdersHistoryDetailResponseModel>> deleteOrder({
required int id,
  }) async {
    return baseRequest<OrdersHistoryDetailResponseModel, OrdersHistoryDetailResponseModel>(
      httpUrl: AppServicePath.orderHistoryDetail.withPath(id.toString()),
      method: DioHttpMethod.delete,
    );
  }

  ///Request that returns all characters
  Future<BaseHttpModel<CreateOrderResponseModel>> createOrder({
    required CreateOrderRequestModel request,
  }) async {
    return baseRequest<CreateOrderResponseModel, CreateOrderResponseModel>(
      responseModel: CreateOrderResponseModel(),
      httpUrl: AppServicePath.createOrder.value,
      method: DioHttpMethod.post,
      requestModel: request,
      successStatus: HttpStatus.created,
    );
  }

  ///Request that returns all characters
  Future<BaseHttpModel<ProductGroupListResponseModel>> productGroupList({
    required ProductGroupListRequestModel request,
  }) async {
    return baseRequest<ProductGroupListResponseModel,
        ProductGroupListResponseModel>(
      responseModel: ProductGroupListResponseModel(),
      httpUrl: AppServicePath.productGroupList.value,
      method: DioHttpMethod.get,
      requestModel: request,
    );
  }

  ///Request that returns all characters
  Future<BaseHttpModel<BalanceResponseModel>> balanceInformation({
    required int id,
  }) async {
    return baseRequest<BalanceResponseModel, BalanceResponseModel>(
      responseModel: BalanceResponseModel(),
      httpUrl: AppServicePath.balance.withPath(id.toString()),
      method: DioHttpMethod.get,
    );
  }

  ///Request that returns all characters
  Future<BaseHttpModel<ProductGroupListResponseModel>> allProducts({
    required ProductGroupListRequestModel request,
  }) async {
    return baseRequest<ProductGroupListResponseModel,
        ProductGroupListResponseModel>(
      responseModel: ProductGroupListResponseModel(),
      httpUrl: AppServicePath.productGroupList.value,
      method: DioHttpMethod.get,
      queryParams: request.toJson(),
    );
  }

  ///Request that returns all characters
  Future<BaseHttpModel<LoginResponseModel>> currentUser() async {
    return baseRequest<LoginResponseModel, LoginResponseModel>(
      responseModel: LoginResponseModel(),
      httpUrl: AppServicePath.currentUser.value,
      method: DioHttpMethod.get,
    );
  }

  ///Request that returns all characters
  Future<BaseHttpModel<ProductVariantResponseModel>> productDetail(
    String productCode,
  ) async {
    return baseRequest<ProductVariantResponseModel,
        ProductVariantResponseModel>(
      responseModel: ProductVariantResponseModel(),
      httpUrl: AppServicePath.productVariant.value,
      method: DioHttpMethod.get,
      queryParams: {'code': productCode},
    );
  }

  ///Request that returns all characters
  Future<BaseHttpModel<ProductGroupItem>> productByBarcode(
    String barcode,
  ) async {
    return baseRequest<ProductGroupItem, ProductGroupItem>(
      responseModel: ProductGroupItem(),
      httpUrl: AppServicePath.productGroupItem.value,
      method: DioHttpMethod.get,
      queryParams: {'barcode': barcode},
    );
  }
}
