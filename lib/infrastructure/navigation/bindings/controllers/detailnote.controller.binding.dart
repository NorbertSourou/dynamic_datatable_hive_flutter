import 'package:get/get.dart';

import '../../../../presentation/detailnote/controllers/detailnote.controller.dart';

class DetailnoteControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailnoteController>(
      () => DetailnoteController(),
    );
  }
}
