import 'package:bernard_app/infrastructure/dal/services/hive_services.dart';
import 'package:bernard_app/presentation/manage_product/manage_product.screen.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';

import '../edit_product/edit_product.screen.dart';
import 'controllers/addnote.controller.dart';

class AddnoteScreen extends GetView<AddnoteController> {
  const AddnoteScreen({Key? key}) : super(key: key);

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
    final controller = Get.put(AddnoteController());
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: true);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back(result: true);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text('Nouvelle note'),
          actions: [
            IconButton(
                onPressed: () async {
                  if (controller.title.text.isEmpty) {
                    Get.showSnackbar(const GetSnackBar(
                        duration: Duration(seconds: 3),
                        isDismissible: true,
                        message: "Titre obligatoire"));
                  } else {
                    Map<String, String> result = {};
                    result['id'] = randomIdGenerator();
                    result['titre'] = controller.title.text;
                    result['desc'] = controller.desc.text;
                    HiveService.addNotesToHive(result);

                    var snackBar = const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Données enregistrées avec succès'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    controller.desc.clear();
                    controller.title.clear();
                  }
                },
                icon: const Icon(Icons.save))
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Titre"),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: controller.title,
                decoration: const InputDecoration(
                  focusedBorder: MyCustomOutlineInputBorder.customOutline,
                  enabledBorder: MyCustomOutlineInputBorder.customOutline,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text("Notes"),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: controller.desc,
                maxLines: 20,
                decoration: const InputDecoration(
                  focusedBorder: MyCustomOutlineInputBorder.customOutline,
                  enabledBorder: MyCustomOutlineInputBorder.customOutline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
