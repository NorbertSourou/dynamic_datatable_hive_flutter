import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/detailnote.controller.dart';

class DetailnoteScreen extends GetView<DetailnoteController> {
  const DetailnoteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DetailnoteController());
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.data['titre']),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Contenu de la note ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Text(
              controller.data['desc'],
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
