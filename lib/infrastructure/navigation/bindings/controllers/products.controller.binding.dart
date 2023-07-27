import 'package:get/get.dart';

import '../../../../presentation/products/controllers/products.controller.dart';

class ProductsControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductsController>(
      () => ProductsController(),
    );
  }
}
