import 'package:bernard_app/infrastructure/dal/services/storage/hive_boxes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pluto_grid/pluto_grid.dart';

class ProductsController extends GetxController {
  //TODO: Implement ProductsController
  Box? productsBox;
  Box? columnsBox;
  List<PlutoColumn> columns = [];

  final isLoading = false.obs;

  List<PlutoRow> rows = [
    // PlutoRow(
    //   cells: {
    //     'image': PlutoCell(value: 'Text cell value1'),
    //     'nom': PlutoCell(value: 2020),
    //     'prix': PlutoCell(value: 'item1'),
    //     'quantité': PlutoCell(value: '2020-08-06')
    //   },
    // ),
  ];

  @override
  void onInit() {
    getInit();

    // TODO: implement onInit
    super.onInit();
  }

  void getInit() {
    isLoading.value = true;
    columnsBox = Boxes.getColumns();
    productsBox = Boxes.getProducts();
    columns.clear();
    rows.clear();
    if (columnsBox != null) {
      for (String column in columnsBox!.values) {
        columns.add(PlutoColumn(
          title: column,
          field: column.toLowerCase().replaceAll(' ', '_'),
          type: PlutoColumnType.text(),
        ));
      }
    }
    for (Map<dynamic, dynamic> product in productsBox!.values) {
      Map<String, PlutoCell> cells = {};
      for (String column in columnsBox!.values) {
        cells[column.toLowerCase().replaceAll(' ', '_')] =
            PlutoCell(value: product[column] ?? '--');
      }
      rows.add(PlutoRow(cells: cells));
    }
    isLoading.value = false;
  }
}
