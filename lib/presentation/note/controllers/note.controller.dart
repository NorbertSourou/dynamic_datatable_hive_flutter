import 'package:bernard_app/infrastructure/dal/services/hive_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../../infrastructure/dal/services/storage/hive_boxes.dart';

class NoteController extends GetxController {
  //TODO: Implement NoteController
  final isLoading = false.obs;
  Box? notesBox;
  Map<String, String> notes = {};

  @override
  void onInit() {
    // TODO: implement onInit
    getInit();
    super.onInit();
  }

  void getInit() {
    isLoading.value = true;
    notesBox = Boxes.getNotes();

    //columns.clear();

    isLoading.value = false;
  }

  deleteNote(String id) async {
    isLoading.value = true;
    try {
      final int indexToDelete =
          notesBox!.values.toList().indexWhere((item) => item['id'] == id);
      await HiveService.deleteNotes(indexToDelete);

      getInit();

      isLoading.value = false;

      Get.back();

      Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 3),
          isDismissible: true,
          backgroundColor: Colors.greenAccent,
          message: "Données supprimées"));
    } catch (e) {
      Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 3),
          isDismissible: true,
          message: "Une erreur s'est produite"));
    }
  }
}
