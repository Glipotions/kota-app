import 'package:api/api.dart';
import 'package:bb_example_app/product/managers/session_handler.dart';
import 'package:bb_example_app/product/service/product_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:values/values.dart';
import 'package:widgets/widget.dart';

///Abstract class for Base Controller that holds every required
///common thing for each controller.
abstract class BaseControllerInterface extends GetxController {
  ///Key for scaffold. If it's not given to View's scaffold [context]
  ///throws error when trying to access.
  final scaffoldKey = GlobalKey<ScaffoldState>();

  ///Context for the current scaffold key.
  BuildContext get context => scaffoldKey.currentContext!;

  final Rx<LoadingStatus> _loadingStatus = Rx(LoadingStatus.init);
  final Rx<String?> _errorMessage = Rx(null);

  ///Getter for [_loadingStatus]
  LoadingStatus get loadingStatus => _loadingStatus.value;

  ///Setter for [_loadingStatus]
  set loadingStatus(LoadingStatus value) => _loadingStatus.value = value;

  ///Getter for [_errorMessage]
  String? get errorMessage => _errorMessage.value;

  ///Setter for [_errorMessage]
  set errorMessage(String? value) => _errorMessage.value = value;


  ProductClient get client => ProductClient.instance;

  SessionHandler get sessionHandler => SessionHandler.instance;
  

  StringValidator get validator => StringValidator(context);

  ///Method to handle async request when [GetxController] onReady triggered.
  ///It handles view status also.
  Future<void> onReadyGeneric(AsyncCallback onReadyFunction) async {
    super.onReady();
    try {
      loadingStatus = LoadingStatus.loading;
      await onReadyFunction();
      loadingStatus = LoadingStatus.loaded;
    } on AppException catch (e) {
      errorMessage = e.toString();
      loadingStatus = LoadingStatus.error;
    } catch (e) {
      errorMessage = context.i10n.defaultErrorMessage;
      loadingStatus = LoadingStatus.error;
    }
  }

    void showErrorToastMessage(String message) {
    ToastMessage.showToastMessage(
      message: message,
      type: ToastMessageType.error,
    );
  }

  void showWarningToastMessage(String message) {
    ToastMessage.showToastMessage(
      message: message,
      type: ToastMessageType.warning,
    );
  }

  void showSuccessToastMessage(String message) {
    ToastMessage.showToastMessage(
      message: message,
      type: ToastMessageType.success,
    );
  }

  

  /// Method to unfocus field on tap of outside of the text fields handle
  void unFocus() => FocusScope.of(context).unfocus();

  /// Method to check if context is mounted before performnig anything
  /// async and context related.
  Future<void> safeOperation(AsyncCallback function) async {
    if (!(scaffoldKey.currentContext?.mounted ?? true)) return;
    await function.call();
  }
}
