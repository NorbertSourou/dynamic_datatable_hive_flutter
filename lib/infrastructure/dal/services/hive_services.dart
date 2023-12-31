import 'package:bernard_app/infrastructure/dal/services/storage/hive_boxes.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class HiveService {
  static Box productsBox = Boxes.getProducts();
  static Box notesBox = Boxes.getNotes();
  static Box columnsBox = Boxes.getColumns();

  static addProductToHive(var data) async {
    await productsBox.add(data);
  }

  static editProductToHive(int index, var data) async {
    await productsBox.putAt(index, data);
  }

  static addNotesToHive(var data) async {
    await notesBox.add(data);
  }
  static editNotesToHive(int index,var data) async {
    await notesBox.putAt(index,data);
  }
  static addColumnsToHive(String column) async {
    await columnsBox.add(column);
  }

  static checkIfColumnExist(String column) async {
    return columnsBox.values
        .any((value) => value.toLowerCase() == column.toLowerCase());
  }

  static deleteProduct(int index) async {
    return productsBox.deleteAt(index);
  }
  static deleteNotes(int index) async {
    return notesBox.deleteAt(index);
  }

//
// // To delete User from hive
// static deleteUserFromHive(UserModel user) async {
//   var key = user.key;
//   await userBox.delete(key);
// }
//
// // To update data in hive
//
// // update User's name
// static updateUserName(UserModel user, String name) async {
//   user.name = name;
//   await user.save();
// }
//
// // update User's age
// static updateUserAge(UserModel user, int age) async {
//   user.age = age;
//   await user.save();
// }
//
// // update User's hobbies
// static updateUserHobbies(UserModel user, List newHobbies) async {
//   user.hobbies = newHobbies;
//   await user.save();
// }
}
