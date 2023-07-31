import 'package:flutter/material.dart';


import 'package:get/get.dart';


class AddnoteController extends GetxController {
  //TODO: Implement AddnoteController

  TextEditingController title = TextEditingController();

  TextEditingController desc = TextEditingController();

  @override
  void dispose() {
    title.dispose();
    //desc.dispose();
    super.dispose();
    // TODO: implement dispose
  }
}
