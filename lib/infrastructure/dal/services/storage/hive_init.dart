import 'package:hive_flutter/hive_flutter.dart';

class HiveData {
  static init() async {
    await Hive.initFlutter();

    await Hive.openBox<dynamic>("products");
    await Hive.openBox<dynamic>("notes");
    await Hive.openBox<dynamic>("columns");
  }
}
