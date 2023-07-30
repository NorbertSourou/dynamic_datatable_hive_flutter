import 'package:get/get.dart';

import '../../../../presentation/note/controllers/note.controller.dart';

class NoteControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NoteController>(
      () => NoteController(),
    );
  }
}
