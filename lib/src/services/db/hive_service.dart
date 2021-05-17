import 'package:hive/hive.dart';

class HiveService {
  static final HiveService instance = HiveService._internal();

  HiveService._internal();

  isExists({String boxName}) async {
    final openBox = await Hive.openBox(boxName);
    int length = openBox.length;
    return length != 0;
  }

  addBoxes<T>(List<T> items, String boxName) async {
    final openBox = await Hive.openBox(boxName);
    items.forEach((element) {
      openBox.add(element);
    });
  }

  Future<List<T>> getBoxes<T>(String boxName) async {
    List<T> boxList = [];
    final openBox = await Hive.openBox(boxName);
    int length = openBox.length;
    for (int i = 0; i < length; i++) {
      boxList.add(openBox.getAt(i));
    }
    return boxList;
  }

  clear(String boxName) async {
    await (await Hive.openBox(boxName)).clear();
  }
}
