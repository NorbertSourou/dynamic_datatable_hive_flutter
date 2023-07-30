import 'package:bernard_app/infrastructure/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:get/get.dart';

import 'controllers/products.controller.dart';

class ProductsScreen extends GetView<ProductsController> {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductsController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon carnet'),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Obx(() => controller.isLoading.value
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: controller.search,
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        hintText: 'Rechercher...',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: controller.onSearchTextChanged,
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      dataRowHeight: 100,
                      columns: controller.columnsObx,
                      rows: controller.rowsObx,
                    ),
                  ),
                ],
              ),
            )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Get.toNamed(Routes.MANAGE_PRODUCT);
          if (result == true) {
            controller.getInit();
          }
        },
      ),
    );
  }
}

