import 'package:get/get.dart';

import '../../../../presentation/manage_product/controllers/manage_product.controller.dart';

class ManageProductControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageProductController>(
      () => ManageProductController(),
    );
  }
}
