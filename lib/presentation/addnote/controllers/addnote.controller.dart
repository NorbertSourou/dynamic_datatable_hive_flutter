import 'package:flutter/material.dart';


import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';

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
