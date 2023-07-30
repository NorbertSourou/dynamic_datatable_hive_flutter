import 'package:get/get.dart';

class DetailnoteController extends GetxController {
  //TODO: Implement DetailnoteController
  var data;

  @override
  void onInit() {
    data = Get.arguments;
    print(data);
    super.onInit();
  }


}
