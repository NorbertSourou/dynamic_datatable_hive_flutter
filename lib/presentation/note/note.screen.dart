import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../infrastructure/navigation/routes.dart';
import 'controllers/note.controller.dart';

class NoteScreen extends GetView<NoteController> {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NoteController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes notes'),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Get.toNamed(Routes.ADDNOTE);
            if (result == true) {
              controller.getInit();
            }
          },
          child: const Icon(Icons.add)),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Obx(
            () => controller.isLoading.value == true
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          controller: controller.search,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            hintText: 'Rechercher...',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: controller.onSearchTextChanged,
                        ),
                      ),
                      for (var i in controller.filteredItems.value)
                        Card(
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(Routes.DETAILNOTE, arguments: i);
                            },
                            onLongPress: () async {
                              return Get.dialog(
                                AlertDialog(
                                  title: const Text(
                                    "Plus d'actions",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        title: const Text("Modifier"),
                                        onTap: () async {
                                          bool result = await Get.toNamed(
                                              Routes.EDIT_NOTES,
                                              arguments: i);

                                          if (result) controller.getInit();
                                        },
                                        minVerticalPadding: 0,
                                        contentPadding: EdgeInsets.zero,
                                        leading: const Icon(Icons.edit),
                                      ),
                                      ListTile(
                                        title: const Text("Supprimer"),
                                        onTap: () async {
                                          await controller.deleteNote(i['id']);
                                        },
                                        minLeadingWidth: 0,
                                        minVerticalPadding: 0,
                                        contentPadding: EdgeInsets.zero,
                                        leading: const Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 5),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.note_alt),
                                ),
                                title: Text(i['titre']),
                                subtitle: Text(
                                  i['desc'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
          )),
    );
  }
}
