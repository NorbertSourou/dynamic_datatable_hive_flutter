import 'package:get/get.dart';

import '../../../../presentation/addnote/controllers/addnote.controller.dart';

class AddnoteControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddnoteController>(
      () => AddnoteController(),
    );
  }
}
