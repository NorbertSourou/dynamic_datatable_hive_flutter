import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  final List<String> options = <String>["Importer", "Exporter"];
  final List<String> boxes = <String>["products", "notes", "columns"];
  final selectedChoice = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void select(String choice) async {
    selectedChoice.value = choice;
    if (choice == 'Exporter') {
      String path = await createAndGetDirectory();
      try {
        for (String box in boxes) {
          await backupHiveBox(box, path);
        }
        Get.showSnackbar(const GetSnackBar(
            duration: Duration(seconds: 3),
            isDismissible: true,
            backgroundColor: Colors.green,
            message: "Exportation bien effectuée"));
      } catch (e) {
        Get.showSnackbar(const GetSnackBar(
            duration: Duration(seconds: 3),
            isDismissible: true,
            backgroundColor: Colors.red,
            message: "Une erreur s'est produite"));
      }
    }
    if (choice == 'Importer') {
      String path = await createAndGetDirectory();
      try {
        for (String box in boxes) {
          print(box);
          await restoreHiveBox(box, path);
        }
        Get.showSnackbar(const GetSnackBar(
            duration: Duration(seconds: 3),
            isDismissible: true,
            backgroundColor: Colors.green,
            message: "Importation bien effectuée"));
      } catch (e) {
        Get.showSnackbar(const GetSnackBar(
            duration: Duration(seconds: 3),
            isDismissible: true,
            backgroundColor: Colors.red,
            message: "Une erreur s'est produite"));
      }
    }
  }

  Future<String> createAndGetDirectory() async {
    // Obtenez le répertoire de documents de l'application
    Directory? appDocumentsDirectory = await getExternalStorageDirectory();
    print(appDocumentsDirectory);
    // Créez un sous-répertoire dans le répertoire de documents (vous pouvez choisir le nom du dossier)
    String newDirectoryName =
        'bernardapp'; // Remplacez 'mon_dossier' par le nom que vous souhaitez
    Directory newDirectory =
        //  Directory('${appDocumentsDirectory!.path}/$newDirectoryName');
        Directory('${appDocumentsDirectory!.path}/$newDirectoryName');
    print(newDirectory.path);

    // Vérifiez si le dossier existe déjà
    if (await newDirectory.exists()) {
      // Le dossier existe déjà, récupérez simplement son chemin
      return newDirectory.path;
    } else {
      // Le dossier n'existe pas, créez-le
      newDirectory.create(
          recursive:
              true); // Utilisez 'recursive: true' pour créer des répertoires parents si nécessaire
      return newDirectory.path;
    }
  }

  Future<void> backupHiveBox<T>(String boxName, String backupPath) async {
    final box = Hive.box(boxName);
    final boxPath = box.path;
    // await box.close();
    try {


      File(boxPath!).copy('$backupPath/$boxName.hive');
    } finally {
      await Hive.openBox<T>(boxName);
    }
  }

  Future<void> restoreHiveBox<T>(String boxName, String backupPath) async {
    final box = await Hive.openBox(boxName);
    final boxPath = box.path;
    // await box.close();

    try {
      // File(backupPath).copy(boxPath!);
      File('$backupPath/$boxName.hive').copy(boxPath!);
    } finally {
      await Hive.openBox<T>(boxName);
    }
  }
}
