import 'package:bernard_app/infrastructure/dal/services/storage/hive_boxes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class EditNotesController extends GetxController {
  //TODO: Implement EditNotesController

  TextEditingController title = TextEditingController();

  TextEditingController desc = TextEditingController();
  Box? notesBox;
  var noteObx;

  @override
  void onInit() {
    // TODO: implement onInit

    notesBox = Boxes.getNotes();

    noteObx = Get.arguments;

    title.text = noteObx['titre'];
    desc.text = noteObx['desc'];

    super.onInit();
  }
}
