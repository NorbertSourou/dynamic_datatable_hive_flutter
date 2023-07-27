import 'package:bernard_app/infrastructure/navigation/routes.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'controllers/products.controller.dart';

class ProductsScreen extends GetView<ProductsController> {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductsController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProductsScreen'),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const CircularProgressIndicator()
            : PlutoGrid(
                columns: controller.columns,
                rows: controller.rows,
                onChanged: (PlutoGridOnChangedEvent event) {
                  print(event);
                },
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  event.stateManager.setShowColumnFilter(true);
                },
                configuration: PlutoGridConfiguration(
                  columnFilter: PlutoGridColumnFilterConfig(
                    filters: const [
                      ...FilterHelper.defaultFilters,
                      ClassYouImplemented(),
                    ],
                    resolveDefaultColumnFilter: (column, resolver) {
                      if (column.field == 'text') {
                        return resolver<PlutoFilterTypeContains>()
                            as PlutoFilterType;
                      }
                      return resolver<PlutoFilterTypeContains>()
                          as PlutoFilterType;
                    },
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Get.toNamed(Routes.MANAGE_PRODUCT);
          if (result == true) {
            print(result);
            controller.getInit();
          }
        },
      ),
    );
  }
}

class ClassYouImplemented implements PlutoFilterType {
  @override
  String get title => 'Custom contains';

  @override
  get compare => ({
        required String? base,
        required String? search,
        required PlutoColumn? column,
      }) {
        var keys = search!.split(',').map((e) => e.toUpperCase()).toList();

        return keys.contains(base!.toUpperCase());
      };

  const ClassYouImplemented();
}
