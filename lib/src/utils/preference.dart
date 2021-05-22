import 'dart:convert';

import 'package:ism_app/imports.dart';
import 'package:ism_app/src/screens/login/model/login_data.dart';
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
    return myPref.containsKey(key);
  }

  static Future<dynamic> clear() async {
    SharedPreferences myPref = await SharedPreferences.getInstance();
    return await myPref.clear();
  }

  static Future<LoginData> getLoginData() async {
    SharedPreferences myPref = await SharedPreferences.getInstance();
    var loginDetails = myPref.get(ApiConstant.LOGIN_DATA);
    var jsonData = json.decode(loginDetails);
    LoginData loginData = LoginData.fromJson(jsonData);
    return loginData;
  }

  static Future<String> getAccessToken() async {
    LoginData loginData = await getLoginData();
    return loginData.accessToken;
  }
}

enum SharePrefType {
  Int,
  String,
  Bool,
  Double,
}
