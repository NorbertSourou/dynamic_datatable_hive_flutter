import 'dart:io';

import 'package:bernard_app/infrastructure/dal/services/hive_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../../../infrastructure/dal/services/storage/hive_boxes.dart';

class ManageProductController extends GetxController {
  TextEditingController newColumn = TextEditingController();
  Map<String, TextEditingController> controllers = {};
  final productsBox = Rxn<Box>();
  final isLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  XFile? pickedFile;
  final finalPath = "".obs;
  final ImagePicker picker = ImagePicker();

  void createController(String variableName) {
    controllers[variableName] = TextEditingController();
  }

  @override
  void onInit() {
    getInit();

    super.onInit();
  }

  void getInit() {
    isLoading.value = true;
    productsBox.value = Boxes.getColumns();
    if (productsBox.value != null) {
      for (String product in productsBox.value!.values) {
        createController(product);
      }
    }
    isLoading.value = false;
  }

  saveColumn(String value, BuildContext context) async {
    final ProgressDialog pr = ProgressDialog(context);
    bool check = await HiveService.checkIfColumnExist(value);
    if (!check) {
      await pr.show();
      HiveService.addColumnsToHive(value);
      getInit();
      await pr.hide();
      Get.back();
    } else {
      Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 3),
          isDismissible: true,
          message: "Ce nom de colonne existe. Choisir un autre"));
    }
  }

  pickImageFromGallery() async {
    pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    if (pickedFile != null) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      final filename = path.basename(pickedFile!.path);

      final File localImage =
          await File(pickedFile!.path).copy('$appDocPath/$filename');
      finalPath.value = localImage.path;
    }
  }

  pickImageFromCamera() async {
    pickedFile = await picker.pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    if (pickedFile == null) return;

    if (pickedFile != null) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      final filename = path.basename(pickedFile!.path);

      final File localImage =
          await File(pickedFile!.path).copy('$appDocPath/$filename');
      finalPath.value = localImage.path;
    }
  }
}
