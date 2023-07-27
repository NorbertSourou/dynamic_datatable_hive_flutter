import 'package:bernard_app/infrastructure/dal/services/hive_services.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import 'controllers/manage_product.controller.dart';

class ManageProductScreen extends GetView<ManageProductController> {
  ManageProductScreen({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ManageProductController());
    return WillPopScope(
      onWillPop: () async {
        Get.closeAllSnackbars();

        print("hello");

        Get.back(result: true);

        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('ManageProductScreen'),
            actions: [
              IconButton(
                onPressed: () {
                  Get.dialog(AlertDialog(
                    scrollable: true,
                    insetPadding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 40.0),
                    title: const Text(
                      'Ajouter une nouvelle colonne à votre tableau',
                      maxLines: 2,
                    ),
                    content: SingleChildScrollView(
                      child: TextField(
                        controller: controller.newColumn,
                        autofocus: true,
                        decoration: const InputDecoration(
                          focusedBorder:
                              MyCustomOutlineInputBorder.customOutline,
                          enabledBorder:
                              MyCustomOutlineInputBorder.customOutline,
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () async {
                            controller.saveColumn(
                                controller.newColumn.text, context);
                          },
                          child: const Text('Enregistrer'))
                    ],
                  ));
                },
                icon: const Icon(Icons.add),
                tooltip: 'Ajouter une colonne',
              )
            ],
          ),
          body: Obx(
            () => controller.isLoading.value
                ? const CircularProgressIndicator()
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          for (String product
                              in controller.productsBox.value!.values)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: controller.controllers[product],
                                  // Access the controller using the variable name
                                  decoration: const InputDecoration(
                                    focusedBorder: MyCustomOutlineInputBorder
                                        .customOutline,
                                    enabledBorder: MyCustomOutlineInputBorder
                                        .customOutline,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (controller
                                    .controllers['Nom']!.text.isNotEmpty) {
                                  Map<String, String> result = {};
                                  if (controller.productsBox.value != null) {
                                    for (String product in controller
                                        .productsBox.value!.values) {
                                      result[product] =
                                          controller.controllers[product]!.text;
                                    }
                                  }
                                  await HiveService.addProductToHive(result);

                                  formKey.currentState!.reset();
                                  var snackBar = const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                        'Données enregistrées avec succès'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  Get.showSnackbar(const GetSnackBar(
                                      duration: Duration(seconds: 3),
                                      isDismissible: true,
                                      message: "Colonne champ obligatoire"));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                vertical: 17,
                              )),
                              child: const Text('Sauvegarder'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          )),
    );
  }
}

class MyCustomOutlineInputBorder {
  static const errorCustomOutline = OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(7),
    ),
    borderSide: BorderSide(
        //  style: BorderStyle.none,
        color: Colors.red,
        width: 1.5),
  );

  static const customOutline = OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(7),
    ),
    borderSide: BorderSide(
        //  style: BorderStyle.none,
        color: Colors.blue,
        width: 1.3),
  );
  static const customOutlineWithoutBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(7),
    ),
    borderSide:
        BorderSide(style: BorderStyle.none, color: Colors.red, width: 1.3),
  );
}
