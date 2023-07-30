import 'dart:io';

import 'package:bernard_app/infrastructure/dal/services/storage/hive_boxes.dart';
import 'package:bernard_app/infrastructure/navigation/navigation.dart';
import 'package:bernard_app/infrastructure/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../../infrastructure/dal/services/hive_services.dart';

class ProductsController extends GetxController {
  //TODO: Implement ProductsController
  Box? productsBox;
  Box? columnsBox;

  final isLoading = false.obs;
  final columnsObx = List<DataColumn>.empty().obs;
  final rowsObx = List<DataRow>.empty().obs;

  List<DataColumn> columns = [];
  List<DataRow> rows = [];

  @override
  void onInit() {
    getInit();

    // TODO: implement onInit
    super.onInit();
  }

  TextEditingController search = TextEditingController();

  deleteProducts(String value) async {
    try {
      isLoading.value = true;

      final int indexToDelete = productsBox!.values
          .toList()
          .indexWhere((item) => item['Id'] == value);
      await HiveService.deleteProduct(indexToDelete);

      getInit();
      isLoading.value = false;

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

  onSearchTextChanged(String text) {
    Iterable<dynamic> filteredItems;
    if (text.isEmpty) {
      filteredItems = productsBox!.values;
    } else {
      filteredItems = productsBox!.values.toList().where((item) {
        return item['Nom']
            .toString()
            .toLowerCase()
            .contains(text.toLowerCase());
      }).toList();
    }

    columns.clear();
    rows.clear();

    for (Map<dynamic, dynamic> product in filteredItems) {
      List<DataCell> cells = [];
      for (String column in columnsBox!.values) {
        if (column != 'Id') {
          if (column == 'Image') {
            cells.add(DataCell(Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: 200,
                child: product[column] != ''
                    ? Image(image: FileImage(File(product[column])))
                    : const Text("Pas d'image"),
              ),
            )));
          } else {
            cells.add(DataCell(Text(product[column] ?? '--')));
          }
        }
      }

      //Colonne de modificatoo
      cells.add(DataCell(Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () async {
                bool result =
                await Get.toNamed(Routes.EDIT_PRODUCT, arguments: product);
                if (result == true) {
                  getInit();
                }
              },
              child: const Text("Modifier"),
            ),
            TextButton(
              onPressed: () async {
                await deleteProducts(product['Id']);

                search.clear();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Supprimer"),
            ),
          ],
        ),
      )));

      rows.add(DataRow(cells: cells));

      rowsObx.assignAll(rows);
    }
    if (filteredItems.isEmpty) {
      rowsObx.clear();
    }
  }

  void getInit() {
    isLoading.value = true;
    columnsBox = Boxes.getColumns();
    productsBox = Boxes.getProducts();

    columns.clear();
    rows.clear();
    if (columnsBox != null) {
      for (String column in columnsBox!.values) {
        if (column != 'Id') columns.add(DataColumn(label: Text(column)));
      }
      columns.add(const DataColumn(label: Text("Actions")));
    }
    columnsObx.assignAll(columns);

    for (Map<dynamic, dynamic> product in productsBox!.values) {
      List<DataCell> cells = [];
      for (String column in columnsBox!.values) {
        if (column != 'Id') {
          if (column == 'Image') {
            cells.add(DataCell(Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: 200,
                child: product[column] != ''
                    ? Image(image: FileImage(File(product[column])))
                    : const Text("Pas d'image"),
              ),
            )));
          } else {
            cells.add(DataCell(Text(product[column] ?? '--')));
          }
        }
      }
      cells.add(DataCell(Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () async {
                bool result =
                    await Get.toNamed(Routes.EDIT_PRODUCT, arguments: product);
                if (result == true) {
                  getInit();
                }
              },
              child: const Text("Modifier"),
            ),
            TextButton(
              onPressed: () {
                deleteProducts(product['Id']);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Supprimer"),
            ),
          ],
        ),
      )));
      rows.add(DataRow(cells: cells));
    }
    rowsObx.assignAll(rows);
    isLoading.value = false;
  }
}
