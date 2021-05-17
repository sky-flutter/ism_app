import 'package:shared_preferences/shared_preferences.dart';


class MyPreference {
  static add(String key, dynamic value, SharePrefType prefType) async {
    SharedPreferences myPref = await SharedPreferences.getInstance();
    switch (prefType) {
      case SharePrefType.Bool:
        return myPref.setBool(key, value);
      case SharePrefType.Double:
        return myPref.setDouble(key, value);
      case SharePrefType.Int:
        return myPref.setInt(key, value);
      case SharePrefType.String:
        return myPref.setString(key, value);
    }
  }

  static get(String key, SharePrefType prefType) async {
    SharedPreferences myPref = await SharedPreferences.getInstance();
    switch (prefType) {
      case SharePrefType.Bool:
        return myPref.getBool(key);
      case SharePrefType.Double:
        return myPref.getDouble(key);
      case SharePrefType.Int:
        return myPref.getInt(key);
      case SharePrefType.String:
        return myPref.getString(key);
    }
  }


  static Future<bool> removeKeyData(String key) async {
    SharedPreferences myPref = await SharedPreferences.getInstance();
    return await myPref.remove(key);
  }

  static containsKey(key) async {
    SharedPreferences myPref = await SharedPreferences.getInstance();
    return await myPref.containsKey(key);
  }

  static Future<dynamic> clear() async {
    SharedPreferences myPref = await SharedPreferences.getInstance();
    return await myPref.clear();
  }

}

enum SharePrefType {
  Int,
  String,
  Bool,
  Double,
}
