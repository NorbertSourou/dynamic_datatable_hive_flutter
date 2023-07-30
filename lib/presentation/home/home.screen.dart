import 'package:bernard_app/infrastructure/navigation/routes.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenue'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Center(
          child: Column(

            children: [
              SizedBox(height: 15,),
               Card(
                child: ListTile(
                  onTap: () {
                    Get.toNamed(Routes.PRODUCTS);
                  },
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 7, horizontal: 12),
                  title: Text("Carnet"),
                  leading: Icon(Icons.my_library_books_sharp),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {
                    Get.toNamed(Routes.NOTE);
                  },
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
                  title: const Text("Notes"),
                  leading: const Icon(Icons.edit_document),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
