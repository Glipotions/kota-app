import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/utility/enums/general.dart';
import 'package:values/values.dart';

class CurrentAccountController extends BaseControllerInterface {
  CurrentAccountController({required this.pageStatusEnum});
  @override
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  BuildContext get context => scaffoldKey.currentContext!;

  late final ScreenArgumentEnum pageStatusEnum;

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  int pageIndex = 0;
  int pageSize = 20;
  bool hasMoreData = true;
  RxBool isLoading = false.obs;
  bool isPaginationLoading = false;
  RxInt pageCount = 0.obs;

  final Rx<List<GetCurrentAccount>> _currentAccounts = Rx([]);
  List<GetCurrentAccount> get currentAccounts => _currentAccounts.value;
  set currentAccounts(List<GetCurrentAccount> value) => _currentAccounts
    ..firstRebuild = true
    ..value = value;

  @override
  void onReady() {
    super.onReady();
    scrollController.addListener(_scrollListener);
    loadMoreData();
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange &&
        hasMoreData) {
      pageIndex++;
      isPaginationLoading = true;
      try {
        loadMoreData();
      } catch (e) {
        pageIndex--;
      } finally {
        isPaginationLoading = false;
      }
    }
  }

  Future<void> filterList(String searchQuery) async {
    isLoading.value = true;
    await client.appService
        .getCurrentAccounts(
      request: CurrentAccountListRequestModel(
        pageIndex: 0,
        pageSize: pageSize,
        searchText: searchQuery,
      ),
    )
        .handleRequest(
      onSuccess: (res) {
        var newList = List<GetCurrentAccount>.from([]);
        newList.addAll(res!.items!);
        _currentAccounts.value = newList;
        hasMoreData = res.hasNext!;
        pageCount.value = _currentAccounts.value.length;
        pageIndex = 0;
      },
    );
    isLoading.value = false;
  }

  Future<void> loadMoreData() async {
    if (hasMoreData && !isLoading.value) {
      await getData();
    }
  }

  Future<void> refreshPage() async {
    pageIndex = 0;
    hasMoreData = true;
    _currentAccounts.value = [];
    await getData();
  }

  Future<void> getData() async {
    loadingStatus = LoadingStatus.loading;
    await client.appService
        .getCurrentAccounts(
          request: CurrentAccountListRequestModel(
            pageIndex: pageIndex,
            pageSize: pageSize,
            searchText: searchController.text,
          ),
        )
        .handleRequest(
          onSuccess: (res) {
            if (res?.items != null) {
              final newList = List<GetCurrentAccount>.from(currentAccounts);
              newList.addAll(res!.items!);
              _currentAccounts.value = newList;
              hasMoreData = res.hasNext!;
              pageCount.value = newList.length;
              loadingStatus = LoadingStatus.loaded;
            }
          },
          ignoreException: true,
          defaultResponse: GetCurrentAccountResponseModel(),
          onIgnoreException: (err) {
            loadingStatus = LoadingStatus.error;
            showErrorToastMessage(
              err?.detail ?? 'Bir hata oluştu.',
            );
          },
        );
  }

  void onTapCard(int id, String name) {
    if (pageStatusEnum == ScreenArgumentEnum.Default) {
      // Navigator.pushNamed(
      //     context, Screens.instance.main.currentAccountTransactionScreen,
      //     arguments: {
      //       EditArgumentEnum.ID: id,
      //       'CurrentAccountName': name
      //     });
    } else if (pageStatusEnum == ScreenArgumentEnum.SelectToBack) {
      Navigator.pop(
        context,
        currentAccounts.singleWhere((element) => element.id == id),
      );
    } 
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
