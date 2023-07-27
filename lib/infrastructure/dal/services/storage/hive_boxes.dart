import 'package:hive/hive.dart';

class Boxes {
  static Box<dynamic> getProducts() => Hive.box<dynamic>("products");

  static Box<dynamic> getNotes() => Hive.box<dynamic>("notes");

  static Box<String> getColumns() {
    final columns = Hive.box<String>("columns");
    if (columns.isEmpty) columns.addAll(['Image', 'Nom', 'Prix', 'Quantité']);
    return columns;
  }
}
