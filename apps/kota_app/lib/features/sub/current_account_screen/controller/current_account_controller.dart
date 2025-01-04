import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/service/product_client.dart';
import 'package:kota_app/product/utility/enums/general.dart';

class CurrentAccountController extends BaseControllerInterface {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext get context => scaffoldKey.currentContext!;

  late final ScreenArgumentEnum pageStatusEnum;
  CurrentAccountController({required this.pageStatusEnum});

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  var pageIndex = 0;
  var pageSize = 20;
  var hasMoreData = true;
  var isLoading = false.obs;
  var isPaginationLoading = false;
  var pageCount = 0.obs;

  final RxList<GetCurrentAccount> _currentAccounts = <GetCurrentAccount>[].obs;
  List<GetCurrentAccount> get currentAccounts => _currentAccounts;

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
      pageIndex: 0,
      pageSize: pageSize,
      search: searchQuery,
    )
        .handleRequest(
      onSuccess: (res) {
        _currentAccounts.value = res!.items!;
        hasMoreData = res.hasNext!;
        pageCount.value = _currentAccounts.length;
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
    _currentAccounts.clear();
    await getData();
  }

  Future<void> getData() async {
    isLoading.value = true;
    await client.appService
        .getCurrentAccounts(
          pageIndex: pageIndex,
          pageSize: pageSize,
          search: searchController.text,
        )
        .handleRequest(
          onSuccess: (res) {
            _currentAccounts.addAll(res!.items!);
            hasMoreData = res.hasNext!;
            pageCount.value = _currentAccounts.length;
          },
          ignoreException: true,
          defaultResponse: GetCurrentAccountResponseModel(),
          onIgnoreException: (err) => showErrorToastMessage(
            err?.detail ?? 'Bir hata oluştu.',
          ),
        );
    isLoading.value = false;
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
