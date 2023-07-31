import 'package:hive/hive.dart';

class Boxes {
  static Box<dynamic> getProducts() => Hive.box<dynamic>("products");

  static Box<dynamic> getNotes() => Hive.box<dynamic>("notes");

  static Box<dynamic> getColumns() {
    final columns = Hive.box<dynamic>("columns");
    if (columns.isEmpty) columns.addAll(['Id','Image', 'Nom', 'Prix', 'Quantité']);
    return columns;

  }
}
