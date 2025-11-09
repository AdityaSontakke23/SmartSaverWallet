import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import '../constants/app_constants.dart';
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;
  Box? _hiveBox;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _hiveBox = await Hive.openBox(AppConstants.appName);
  }

  // SharedPreferences getters/setters
  bool get isLoggedIn => _prefs?.getBool(AppConstants.keyIsLoggedIn) ?? false;
  Future<void> setLoggedIn(bool value) =>
      _prefs!.setBool(AppConstants.keyIsLoggedIn, value);

  String? get userId => _prefs?.getString(AppConstants.keyUserId);
  Future<void> setUserId(String id) =>
      _prefs!.setString(AppConstants.keyUserId, id);

  ThemeMode? get themeMode {
    final mode = _prefs?.getString(AppConstants.keyThemeMode);
    return mode == 'dark'
        ? ThemeMode.dark
        : mode == 'light'
            ? ThemeMode.light
            : ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) =>
      _prefs!.setString(AppConstants.keyThemeMode, mode.name);

  // Hive data storage
  Future<void> saveTransaction(Map<String, dynamic> txn) =>
      _hiveBox!.put(txn['id'], txn);

  Map<String, dynamic>? getTransaction(String id) =>
      _hiveBox!.get(id)?.cast<String, dynamic>();

  Future<void> deleteTransaction(String id) => _hiveBox!.delete(id);

  List<Map<String, dynamic>> getAllTransactions() =>
      _hiveBox!.values.cast<Map>().toList().cast<Map<String, dynamic>>();

  Future<void> clearAllData() => _hiveBox!.clear();
}
