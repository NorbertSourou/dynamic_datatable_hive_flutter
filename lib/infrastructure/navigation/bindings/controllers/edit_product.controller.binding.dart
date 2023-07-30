import 'package:get/get.dart';

import '../../../../presentation/edit_product/controllers/edit_product.controller.dart';

class EditProductControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditProductController>(
      () => EditProductController(),
    );
  }
}
