import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'dart:math' as math;
import '../../infrastructure/dal/services/hive_services.dart';
import '../manage_product/manage_product.screen.dart';
import 'controllers/edit_product.controller.dart';

class EditProductScreen extends GetView<EditProductController> {
  const EditProductScreen({Key? key}) : super(key: key);

  randomIdGenerator() {
    var ranAssets = RanKeyAssets();
    String first4alphabets = '';
    String middle4Digits = '';
    String last4alphabets = '';
    for (int i = 0; i < 4; i++) {
      first4alphabets += ranAssets.smallAlphabets[
          math.Random.secure().nextInt(ranAssets.smallAlphabets.length)];

      middle4Digits += ranAssets
          .digits[math.Random.secure().nextInt(ranAssets.digits.length)];

      last4alphabets += ranAssets.smallAlphabets[
          math.Random.secure().nextInt(ranAssets.smallAlphabets.length)];
    }

    return '$first4alphabets-$middle4Digits-${DateTime.now().microsecondsSinceEpoch.toString().substring(8, 12)}-$last4alphabets';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProductController());

    return Scaffold(
        appBar: AppBar(
          title: const Text('Modifier carnet'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back(result: false);
            },
          ),
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
                        focusedBorder: MyCustomOutlineInputBorder.customOutline,
                        enabledBorder: MyCustomOutlineInputBorder.customOutline,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              controller.finalPath.value.isNotEmpty
                                  ? CircleAvatar(
                                      backgroundColor: Colors.white60,
                                      backgroundImage: Image.file(
                                        File(controller.finalPath.value),
                                      ).image,
                                      radius: 80,
                                    )
                                  : const CircleAvatar(
                                      backgroundColor: Colors.greenAccent,
                                      radius: 80,
                                    ),
                              Positioned(
                                bottom: 5,
                                right: 20,
                                child: InkWell(
                                  onTap: () {
                                    Get.dialog(
                                      AlertDialog(
                                        title: const Text(
                                          "Choisir une image",
                                          style: TextStyle(color: Colors.green),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListTile(
                                              title: const Text("Camera"),
                                              onTap: controller
                                                  .pickImageFromCamera,
                                              minLeadingWidth: 0,
                                              minVerticalPadding: 0,
                                              contentPadding: EdgeInsets.zero,
                                              leading: const Icon(Icons.camera),
                                            ),
                                            ListTile(
                                              title: const Text("Galerie"),
                                              onTap: controller
                                                  .pickImageFromGallery,
                                              minLeadingWidth: 0,
                                              minVerticalPadding: 0,
                                              contentPadding: EdgeInsets.zero,
                                              leading: const Icon(Icons.image),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Icon(Icons.camera_alt),
                                ),
                              )
                            ],
                          ),
                        ),
                        for (String product
                            in controller.columnBox.value!.values)
                          if (product != 'Image' && product != 'Id')
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
                                if (controller.columnBox.value != null) {
                                  for (String product
                                      in controller.columnBox.value!.values) {
                                    if (product == 'Image') {
                                      result[product] =
                                          controller.finalPath.value;
                                    } else if (product == 'Id') {
                                      result[product] = randomIdGenerator();
                                    } else {
                                      result[product] =
                                          controller.controllers[product]!.text;
                                    }
                                  }
                                }

                                final int indexToEdit = controller
                                    .productBox.value!.values
                                    .toList()
                                    .indexWhere((item) =>
                                        item['Id'] ==
                                        controller.productObx['Id']);

                                await HiveService.editProductToHive(
                                    indexToEdit, result);

                                var snackBar = const SnackBar(
                                  backgroundColor: Colors.green,
                                  content:
                                      Text('Données modifiées avec succès'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                               Get.back(result: true);
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
                            child: const Text('Modifier'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
        ));
  }
}

class RanKeyAssets {
  var smallAlphabets = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z'
  ];
  var digits = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
  ];
}
