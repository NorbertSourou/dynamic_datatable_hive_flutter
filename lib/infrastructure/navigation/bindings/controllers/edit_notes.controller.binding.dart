import 'package:get/get.dart';

import '../../../../presentation/edit_notes/controllers/edit_notes.controller.dart';

class EditNotesControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditNotesController>(
      () => EditNotesController(),
    );
  }
}
