import 'package:bb_example_admin_panel/product/base/controller/base_controller.dart';

///Controller for Example Screen
class DashboardController extends BaseControllerInterface {

  // final Rx<AllProductsResponseModel> _characters = Rx(
  //   AllProductsResponseModel(),
  // );

  // set characters (AllProductsResponseModel value) => _characters.value=value;
  // AllProductsResponseModel get characters => _characters.value;
  
  @override
  Future<void> onReady() async {
    await onReadyGeneric(() async {
      // await _getAllCharacters();
    });
  }

  // Future<void> _getAllCharacters() async {
  //   characters = await client.authRepository.login().handleRequest(
  //     skipExceptionCode: BaseModelStatus.notFound,
  //     defaultResponse: AllProductsResponseModel(),
  //   );
  // }

  
}
