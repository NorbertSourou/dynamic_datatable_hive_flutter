import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../config.dart';
import '../../presentation/screens.dart';
import 'bindings/controllers/controllers_bindings.dart';
import 'routes.dart';

class EnvironmentsBadge extends StatelessWidget {
  final Widget child;
  EnvironmentsBadge({required this.child});
  @override
  Widget build(BuildContext context) {
    var env = ConfigEnvironments.getEnvironments()['env'];
    return env != Environments.PRODUCTION
        ? Banner(
            location: BannerLocation.topStart,
            message: env!,
            color: env == Environments.QAS ? Colors.blue : Colors.purple,
            child: child,
          )
        : SizedBox(child: child);
  }
}

class Nav {
  static List<GetPage> routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      binding: HomeControllerBinding(),
    ),
    GetPage(
      name: Routes.PRODUCTS,
      page: () => const ProductsScreen(),
      binding: ProductsControllerBinding(),
    ),
    GetPage(
      name: Routes.MANAGE_PRODUCT,
      page: () => ManageProductScreen(),
      binding: ManageProductControllerBinding(),
    ),
    GetPage(
      name: Routes.NOTE,
      page: () => const NoteScreen(),
      binding: NoteControllerBinding(),
    ),
    GetPage(
      name: Routes.ADDNOTE,
      page: () => const AddnoteScreen(),
      binding: AddnoteControllerBinding(),
    ),
    GetPage(
      name: Routes.DETAILNOTE,
      page: () => const DetailnoteScreen(),
      binding: DetailnoteControllerBinding(),
    ),
    GetPage(
      name: Routes.EDIT_PRODUCT,
      page: () => const EditProductScreen(),
      binding: EditProductControllerBinding(),
    ),
    GetPage(
      name: Routes.EDIT_NOTES,
      page: () => const EditNotesScreen(),
      binding: EditNotesControllerBinding(),
    ),
  ];
}
