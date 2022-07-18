import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// 本地持久化方法封装
class StorageUtil {
  static final StorageUtil _instance = StorageUtil._();

  factory StorageUtil() => _instance;
  static late SharedPreferences _sharedPreferences;

  StorageUtil._();

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setJSON(String key, dynamic jsonVal) {
    String jsonString = jsonEncode(jsonVal);
    return _sharedPreferences.setString(key, jsonString);
  }

  static dynamic getJSON(String key) {
    String? jsonString = _sharedPreferences.getString(key);
    return jsonString == null ? null : jsonDecode(jsonString);
  }

  static Future<bool> setBool(String key, bool val) {
    return _sharedPreferences.setBool(key, val);
  }

  static bool getBool(String key) {
    bool? val = _sharedPreferences.getBool(key);
    return val ?? false;
  }

  static bool getBoolNullTrue(String key) {
    bool? val = _sharedPreferences.getBool(key);
    return val ?? true;
  }

  static Future<bool> remove(String key) {
    return _sharedPreferences.remove(key);
  }

  static int? getInt(String key) {
    return _sharedPreferences.getInt(key);
  }

  static Future<bool> setInt(String key, int value) {
    return _sharedPreferences.setInt(key, value);
  }

  static Future<bool> clear() {
    return _sharedPreferences.clear();
  }

  static bool containsKey(String key) {
    return _sharedPreferences.containsKey(key);
  }

  static Future<bool> setString(String key, String value) {
    return _sharedPreferences.setString(key, value);
  }

  static String getString(String key, {String defValue = ''}) {
    return _sharedPreferences.getString(key) ?? defValue;
  }
}
